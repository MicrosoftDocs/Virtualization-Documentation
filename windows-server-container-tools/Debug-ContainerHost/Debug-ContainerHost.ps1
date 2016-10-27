Write-Output "Checking for common problems"

$filesToDump = @{}

Describe "Windows Version and Prerequisites" {
    $buildNumber = (Get-CimInstance -Namespace root\cimv2 Win32_OperatingSystem).BuildNumber
    It "Is Windows 10 Anniversary Update or Windows Server 2016" {
        $buildNumber -ge 14393 | Should Be $true
    }
    It "Has KB3192366, KB3194496, or later installed if running Windows build 14393" {
        if ($buildNumber -eq 14393)
        {
            (Get-ItemProperty -Path 'HKLM:\software\Microsoft\Windows NT\CurrentVersion' -Name UBR).UBR | Should Not BeLessThan 206
        }
    }
    It "Is not a build with blocking issues" {
        $buildNumber | Should Not Be 14931
        $buildNumber | Should Not Be 14936
    }
    # TODO Check on SKU support - Home, Pro, Education, ...
}

Describe "Docker is installed" {
    
    $services = Get-Service | Where-Object {($_.Name -eq "Docker") -or ($_.Name -eq "com.Docker.Service")}
    It "A Docker service is installed - 'Docker' or 'com.Docker.Service' " {
        $services | Should Not Be Null
    }
    It "Service is running" {
        foreach ($service in $services)
        {
           $service.Status | Should Be Running
        }        
    }
    It "Docker.exe is in path" {
        # This also captures 'docker info' and 'docker version' output to be shown later
        { 
            Start-Process -NoNewWindow `
                        -Wait `
                        -FilePath docker.exe `
                        -ArgumentList "info" `
                        -RedirectStandardError err.txt `
                        -RedirectStandardOutput dockerinfo.txt
            $filesToDump["docker info"] = "dockerinfo.txt"
            Start-Process -NoNewWindow `
                        -Wait `
                        -FilePath docker.exe `
                        -ArgumentList "version" `
                        -RedirectStandardError err.txt `
                        -RedirectStandardOutput dockerversion.txt
            $filesToDump["docker version"] = "dockerversion.txt"
            Start-Process -NoNewWindow `
                        -Wait `
                        -FilePath docker.exe `
                        -ArgumentList "network ls" `
                        -RedirectStandardError err.txt `
                        -RedirectStandardOutput dockernetworks.txt
            $filesToDump["docker network"] = "dockernetworks.txt"
        } | Should Not Throw
    }
}

Describe "User has permissions to use Docker daemon" {
    It "docker.exe should not return access denied" {
        "err.txt" | Should Not Contain "access is denied"
    }
}

Describe "Windows container settings are correct" {
     It "Do not have DisableVSmbOplock set to 1" {
         $regvalue = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\Containers" -Name VSmbDisableOplocks -ErrorAction Ignore
         if ($regvalue) {
             $regvalue.VSmbDisableOplocks | Should Be 0
         } 
     }
     It "Do not have zz values set" {
         $regvalues = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\Containers"
         ($regvalues | Get-Member zz* | Measure-Object).Count | Should Be 0
     }
 }

Describe "The right container base images are installed" {
    $imageListOutput = docker.exe images
    $images = $imageListOutput | Foreach-Object {
        if (($_ -match "^REPOSITORY") -eq $false) {
            $trimmed = [regex]::Replace($_, "\s{2,}"," ")
            $split = $trimmed.Split(" ")
            New-Object -Typename PSObject -Property @{Repository=$split[0];
            Tag=$split[1];
            ImageId=$split[2]}
        }
    }

    It "At least one of 'microsoft/windowsservercore' or 'microsoft/nanoserver' should be installed" {
        $baseImages = $images | Where-Object { ($_.Repository -eq "microsoft/windowsservercore") `
                                                -or ($_.Repository -eq "microsoft/nanoserver")}
        (Measure-Object $baseImages).Count | Should Not BeNullOrEmpty
    }
}

Describe "Container network is created" {
   $networksListOutput = docker.exe network ls
   $networks = $networksListOutput | Foreach-object {
       if (($_ -match "^NETWORK") -eq $false) {
           $trimmed = [regex]::Replace($_, "\s{2,}", " ")
           $split = $trimmed.Split(" ")
           New-Object -Typename PSObject -Property @{Driver=$split[2];
           NetName=$split[1];
           Scope=$split[3]}
       }       
   }
   
   # Get all NAT networks 
   $natNetworks = $networks | Where-Object { ($_.Driver -eq "nat")}

   # TODO - Add checks for the case where there are no (default) nat networks, everything will need to be user-defined 
   $natInternalPrefix = docker.exe network inspect --format="{{range .IPAM.Config }}{{.Subnet}}{{end}}" $natNetworks[0].NetName
   if ($natInternalPrefix.Contains("/"))
   {
        $Temp = $natInternalPrefix.Split("/") 
        $Prefix = $Temp[0]
        $Length = $Temp[1]
   }
   $IPSubnet = [Net.IPAddress]::Parse($Prefix)
   $BinaryIPSubnet = [String]::Join('', $( $IPSubnet.GetAddressBytes() | %{ 
         [Convert]::ToString($_, 2).PadLeft(8, '0') } ))   

   # Get all Host IP Addresses from Container Host 
   #$hostips = @()
   $hostips = Get-NetIPAddress -AddressFamily IPv4 | where { $_.InterfaceAlias -notmatch "Loopback"  -And $_.InterfaceAlias -notmatch "HNS" -And $_.InterfaceAlias -notmatch "NAT" } | Select IPAddress

   It "At least one local container network is available" {
      $localNetworks = $networks | Where-Object { ($_.Scope -eq "local")}
      (Measure-Object $localNetworks).Count | Should Not BeNullOrEmpty
   }

   It "No more than one NAT network" {   
      (Measure-Object $natNetworks).Count | Should BeLessThan 2
   }

   It "NAT Network's internal prefix does not overlap with external IP'" {      
      $hostips | Foreach-object {
          $testip = [Net.IPAddress]::Parse( ($_.IPAddress) ) 
          $BinaryIP = [String]::Join('', $( $testip.GetAddressBytes() | %{ 
             [Convert]::ToString($_, 2).PadLeft(8, '0') } ))       

          $BinaryIP.Substring(0, $Length) | Should Not Be $BinaryIPSubnet.Substring(0, $Length)                     
      }
   }           
}

# Dump & Cleanup temporary files used during Pester tests
$filesToDump.Keys | ForEach-Object {
     if (Test-Path $filesToDump[$_]) {
         Write-Output "Showing output from: $($_)"
         Get-Content $filesToDump[$_] | Write-Output
         Remove-Item $filesToDump[$_]
         Write-Output ""
     }
}

if (Test-Path err.txt) { Remove-Item err.txt}

Write-Output "Warnings & errors from the last 24 hours"
$logStartTime = (Get-Date).AddHours(-24)

$logNames = "Microsoft-Windows-Containers-Wcifs/Operational",
            "Microsoft-Windows-Containers-Wcnfs/Operational",
            "Microsoft-Windows-Hyper-V-Compute-Admin", 
            "Microsoft-Windows-Hyper-V-Compute-Operational",
            "Application"
$levels = 3,2,1,0
$providers = "Docker", "Microsoft-Windows-Hyper-V-Compute"

$events = Get-WinEvent -FilterHashtable @{Logname=$logNames; StartTime=$logStartTime; Level=$levels; ProviderName=$providers} -ErrorAction Ignore

$eventCsv = "logs_$((get-date).ToString("yyyyMMdd'-'HHmmss")).csv"
$events | Format-Table
$events | Export-CSV $eventCsv
Write-Host "Logs saved to $($PWD)\$($eventCsv)"