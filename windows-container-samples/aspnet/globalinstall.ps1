Param (
	[Parameter(ParameterSetName='InstallPath')]
	[string]$InstallPath='c:\ProgramData\Microsoft DNX\bin'
)

if (!(Test-Path $InstallPath)) { md $InstallPath | Out-Null }

$dnvmPs1Path = Join-Path $InstallPath "dnvm.ps1"
$dnvmCmdPath = Join-Path $InstallPath "dnvm.cmd"

$webClient = New-Object System.Net.WebClient
Write-Host "Downloading DNVM.ps1 to $dnvmPs1Path"
$webClient.DownloadFile('https://raw.githubusercontent.com/aspnet/Home/dev/dnvm.ps1', $dnvmPs1Path)
Write-Host "Downloading DNVM.cmd to $dnvmCmdPath"
$webClient.DownloadFile('https://raw.githubusercontent.com/aspnet/Home/dev/dnvm.cmd', $dnvmCmdPath)

$oldPath = [Environment]::GetEnvironmentVariable("PATH", "MACHINE")
[Environment]::SetEnvironmentVariable("PATH", "$oldPath;$InstallPath", "MACHINE")
