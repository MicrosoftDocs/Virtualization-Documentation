Describe "Docker is installed" {
    
    $service = Get-Service | Where-Object {($_.Name -eq "Docker") -or ($_.Name -eq "com.Docker.Service")}
    It "A Docker service is installed - 'Docker' or 'com.Docker.Service' " {
        $service | Should Not Be Null
    }
    It "Service is running" {
        $service.Status | Should Be Running
    }
    It "Docker.exe is in path" {
        { Start-Process -NoNewWindow `
                        -Wait `
                        -FilePath docker.exe `
                        -ArgumentList "info" `
                        -RedirectStandardError err.txt `
                        -RedirectStandardOutput out.txt 
        } | Should Not Throw
    }
}

Describe "User has permissions to use Docker daemon" {
    It "docker.exe should not return access denied" {
        "err.txt" | Should Not Contain "access is denied"
    }
}

if (Test-Path err.txt) { Remove-Item err.txt}
if (Test-Path out.txt) { Remove-Item out.txt}