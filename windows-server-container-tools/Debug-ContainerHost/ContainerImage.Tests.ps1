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