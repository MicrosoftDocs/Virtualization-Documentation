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
    It "microsoft/windowsservercore is installed" {
        # docker images --format '' |
        $serverCoreImages = $images | Where-Object { $_.Repository -eq "microsoft/windowsservercore"}
        $serverCoreImages | Should Not BeNullOrEmpty
    }
    It "microsoft/nanoserver is installed" {
        # docker images --format '' |
        $serverCoreImages = $images | Where-Object { $_.Repository -eq "microsoft/nanoserver"}
        $serverCoreImages | Should Not BeNullOrEmpty
    }
}