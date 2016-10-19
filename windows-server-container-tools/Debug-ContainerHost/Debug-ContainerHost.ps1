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
    
    $service = Get-Service | Where-Object {($_.Name -eq "Docker") -or ($_.Name -eq "com.Docker.Service")}
    It "A Docker service is installed - 'Docker' or 'com.Docker.Service' " {
        $service | Should Not Be Null
    }
    It "Service is running" {
        $service.Status | Should Be Running
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