Write-Output "Checking for common problems"

$filesToDump = @{}
$currentVersion = Get-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$OSProductName = $currentVersion.GetValue('ProductName')
$OSBuildLabel = $currentVersion.GetValue('BuildLabEx')
Write-Output "Container Host OS Product Name: $OSProductName"
Write-Output "Container Host OS Build Label: $OSBuildLabel"

Describe "Windows Version and Prerequisites" {
    $buildNumber = (Get-CimInstance -Namespace root\cimv2 Win32_OperatingSystem).BuildNumber
    It "Is Windows 10 Anniversary Update or Windows Server 2016" {
        $buildNumber -ge 14393 | Should Be $true
    }
    It "Has KB3192366, KB3194496, or later installed if running Windows build 14393" {
        if ($buildNumber -eq 14393)
        {
            (Get-ItemProperty -Path 'HKLM:\software\Microsoft\Windows NT\CurrentVersion' -Name UBR).UBR | Should Not BeLessThan 351
        }
    }
    It "Is not a build with blocking issues" {
        $buildNumber | Should Not Be 14931
        $buildNumber | Should Not Be 14936
    }

    It "Has 'Containers' feature installed" {
        if (((Get-ComputerInfo).WindowsInstallationType) -eq "Client") {
            (Get-WindowsOptionalFeature -Online -FeatureName Containers).State | Should Be "Enabled"
        }
        else {
            (Get-WindowsFeature -Name Containers).InstallState | Should Be "Installed"
        }
    }

    # TODO Check on SKU support - Home, Pro, Education, ...
}

Describe "Docker is installed" {

    $services = Get-Service | Where-Object {($_.Name -eq "Docker") -or ($_.Name -eq "com.Docker.Service")}
    It "A Docker service is installed - 'Docker' or 'com.Docker.Service' " {
        $services| Should Not BeNullOrEmpty
    }
    It "Service is running" {
        $AtLeastOneRunning = $false;
        foreach ($service in $services)
        {
           #if there is more than 1 only one can be running
           if ($service.Status -eq "Running")
           {
                $AtLeastOneRunning = $true
           }
        }
        $AtLeastOneRunning | Should Be $true
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
        } | Should Not Throw
    }
    It "Docker is registered in the EventLog service" {
        (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\docker") -or (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\DockerService") | Should Be $true
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
     It "Do not have FDVDenyWriteAccess set to 1" {
         $regvalue = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Policies\Microsoft\FVE" -Name FDVDenyWriteAccess -ErrorAction Ignore
         if ($regvalue) {
             $regvalue.FDVDenyWriteAccess | Should Be 0
         }
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
   Start-Process -NoNewWindow `
                 -Wait `
                 -FilePath docker.exe `
                 -ArgumentList "network ls" `
                 -RedirectStandardError err.txt `
                 -RedirectStandardOutput dockernetworkls.txt
   $filesToDump["docker network ls"] = "dockernetworkls.txt"

   $networksListOutput = Get-Content .\dockernetworkls.txt

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

   # Get all Transparent networks
   $transparentNetworks = $networks | Where-Object { ($_.Driver -eq "transparent")}

   # Get all l2bridge networks
   $l2bridgeNetworks = $networks | Where-Object { ($_.Driver -eq "l2bridge")}

   $hostips = @()
   if ($natNetworks -ne $null)
   {
      # Get VMSwitch for NAT network
      if ($natNetworks[0].NetName -eq "nat")
      {
         $natVMSwitchName = "nat"
      }
      else
      {
         $natVMSwitchName = docker.exe network inspect --format="{{.Id}}" $natNetworks[0].NetName
      }

      $natGatewayIP = docker.exe network inspect --format="{{range .IPAM.Config }}{{.Gateway}}{{end}}" $natNetworks[0].NetName

      #$switchType = (Get-VMSwitch -SwitchName $natNetworks[0].NetName).SwitchType
      $switchType = (Get-VMSwitch -SwitchName $natVMSwitchName).SwitchType

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
      $hostips = Get-NetIPAddress -AddressFamily IPv4 | where { $_.InterfaceAlias -notmatch "Loopback"  -And $_.InterfaceAlias -notmatch "HNS" -And $_.InterfaceAlias -notmatch "NAT" } | Select IPAddress
   }

   It "At least one local container network is available" {
      $localNetworks = $networks | Where-Object { ($_.Scope -eq "local")}
      ($localNetworks | Measure-Object).Count | Should Not BeNullOrEmpty
   }

   # Either need NAT, L2bridge, or Transparent for for external network access.
   It "At least one NAT, Transparent, or L2Bridge Network exists" {
      $totalnets = 0
      if ($natNetworks -ne $null)
      {
         $totalnets += ($natNetworks | Measure-Object).Count
      }

      if ($transparentNetworks -ne $null)
      {
         $totalnets += ($transparentNetworks | Measure-Object).Count
      }

      if ($l2bridgeNetworks -ne $null)
      {
         $totalnets += ($l2bridgeNetworks | Measure-Object).Count
      }

      $totalnets | Should BeGreaterThan 0
   }

   # TODO: Need a way to skip these next two tests if no NAT networks exist on the system
   It "NAT Network's vSwitch is internal" {
      $switchType | Should Be "Internal"
   }

   It "A Windows NAT is configured if a Docker NAT network exists" {
       $winnatCount = (Get-NetNat | Measure-Object).Count
       $natCount = 0
       if ($natNetworks -ne $null)
       {
           $natCount += ($natNetworks | Measure-Object).Count
       }
       $winnatCount | Should Not BeLessThan $natCount
   }

   It "Specified Network Gateway IP for NAT network is assigned to Host vNIC" {
      $natGatewayIP | Should Not BeNullOrEmpty

      $vmnicIps = Get-NetIPAddress -AddressFamily IPv4 | where { $_.InterfaceAlias -notmatch "Loopback"  -And $_.InterfaceAlias -match "vEthernet" } | Select IPAddress

      $vmNicGatewayIPExists = $false
      $vmnicIps | Foreach-object {
         if ($_ -match $natGatewayIP) {
            $vmNicGatewayIPExists = $true
         }
      }
      $vmNicGatewayIPExists | Should Be $true

   }

   It "NAT Network's internal prefix does not overlap with external IP'" {
      if ( ($hostips | measure-object).Count -gt 0)
      {
         $hostips | Foreach-object {
             $testip = [Net.IPAddress]::Parse( ($_.IPAddress) )
             $BinaryIP = [String]::Join('', $( $testip.GetAddressBytes() | %{
                [Convert]::ToString($_, 2).PadLeft(8, '0') } ))

             $BinaryIP.Substring(0, $Length) | Should Not Be $BinaryIPSubnet.Substring(0, $Length)
         }
      }
      else
      {
        $hostips.Count | Should BeGreaterThan 0
      }
   }

   # TODO: Add a test to validate the Host vNIC exists with NAT Network's Default Gateawy IP assigned.
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

Write-Output "Getting Warnings & errors in the Windows event logs from the last 24 hours"
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
Write-Host "Logs saved to $($PWD)\$($eventCsv)`n`n"

Write-Output "Getting Docker for Windows daemon logs from the last execution"
Write-Output "    Note: More logs may be available at $($ENV:LOCALAPPDATA)\Docker. Only showing the latest 100 lines."
if (Test-Path "$($ENV:LOCALAPPDATA)\Docker\log.txt")
{
	Get-Content -Tail 100 "$($ENV:LOCALAPPDATA)\Docker\log.txt" | Select-String "WindowsDockerDaemon"
}
else {
	Write-Output "   $($ENV:LOCALAPPDATA)\Docker\log.txt does not exist."
}