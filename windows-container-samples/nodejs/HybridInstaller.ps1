Param (
    [Parameter(ParameterSetName='ContainerNative')]
    [Switch]$RunNative,
    [Parameter(ParameterSetName='ContainerPowerShell')]
    [Switch]$CreateContainerImageUsingPowerShell,
    [Parameter(ParameterSetName='ContainerPowerShell')]
    [string]$InternetVirtualSwitchName = "Virtual Switch",
    [String]
    $LocalSourceRoot
)

$containerImageName = "NodeBase"
$containerImagePublisher = $env:Username
$containerImageVersion = "5.0.0"

$containerScript = {
    Param(
        [String]
        $LocalSourceRoot
    )
    $tempdir = Join-Path -Path $env:temp -ChildPath "$(Get-Date -format 'yyyyMMddhhmmss')"
    $sourceuri = "https://nodejs.org/dist/v5.0.0/node-v5.0.0-x64.msi"
    $installer = Split-Path $sourceuri -Leaf
    $installerpath = Join-Path -Path $tempdir -ChildPath $installer
	$log = Join-Path -Path $env:SystemDrive -ChildPath "log\$($installer).log"

    If (-not (Test-Path $tempdir))
    {
        Write-Output "[container] Creating Temp directory $tempdir"
        New-Item -Path $tempdir -ItemType Directory | Out-Null
    }
	New-Item -Path (Join-Path -Path $env:SystemDrive -ChildPath "log") -ItemType Directory | Out-Null

    # Wait for IP address - either manually assigned (e.g. through NAT) or via DHCP server
    Write-Output "[container] Waiting for network"
    While (((Get-NetIPAddress | ? AddressFamily -eq IPv4 | ? IPAddress -ne 127.0.0.1).SuffixOrigin -ne "Manual") -and ((Get-NetIPAddress | ? AddressFamily -eq IPv4 | ? IPAddress -ne 127.0.0.1).SuffixOrigin -ne "Dhcp")) {Sleep -Milliseconds 10}

    # download sources
    If ($LocalSourceRoot)
    {
	$sourceuri = "$($LocalSourceRoot.Trim("/"))/$installer" 
    }

    Write-Output "[container] Downloading sources from $sourceuri"
    Invoke-WebRequest -Uri $sourceuri -OutFile $installer -UseBasicParsing
    

    # run installer
    Write-Output "[container] Running installer: msiexec /i $installer /qn /l*v $log"
    Start-Process -FilePath msiexec -ArgumentList "/i $installer","/qn","/l*v $log" -NoNewWindow -Wait

    # wait for msiexec
    If (Get-Process msiexec -EA 0)
    {
        Write-Output "[container] Waiting for msiexec to finish"
        # If msiexec is still running, wait for all msiexec processes to finish.
        Wait-Process msiexec
    }

    # remove sources
    Write-Output "[container] Removing $tempdir"
    Remove-Item -Path $tempdir -Recurse
}

If ($RunNative)
{
    Write-Output "Running natively (or inside a Container) - simply executing the script block"
    Invoke-Command -ScriptBlock $containerScript -ArgumentList @($LocalSourceRoot, $ShareCredential)
}
ElseIf ($CreateContainerImageUsingPowerShell)
{
      If (Get-ContainerImage -Name $containerImageName -Version $containerImageVersion)
      {
        Throw "Container Image $containerImageName (version $containerImageVersion) already exists."
      }

      Write-Output "Creating new Container using PowerShell"
      $c1 = New-Container "$containerImageName BuildContainer" -ContainerImageName "WindowsServerCore" -Switch $internetVirtualSwitchName

      Write-Output "Starting $($c1.Name)"
      Start-Container $c1

      Write-Output "Running Script Block inside Container"
      Invoke-Command -ContainerId $c1.Id -RunAsAdministrator -ScriptBlock $containerScript -ArgumentList @($LocalSourceRoot, $ShareCredential)

      Write-Output "Stopping $($c1.Name)"
      Stop-Container $c1

      Write-Output "Creating new image $containerImageName from $($c1.Name)"
      Do {New-ContainerImage -Container $c1 -Publisher $containerImagePublisher -Name $containerImageName -Version $containerImageVersion -EA 0} Until ($?)

      Write-Output "Removing Container $($c1.Name)"
      Remove-Container $c1 -Force
}
Else
{
    Write-Output "Please specify either -RunNative or -CreateContainerImageUsingPowerShell"
}
