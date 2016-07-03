
############################################################
# Script assembled with makeps1.js from
# Install-ContainerHost-Source.ps1
# ..\common\ContainerHost-Common.ps1
# Install-ContainerHost-Main.ps1
############################################################

<#
    .NOTES
        Copyright (c) Microsoft Corporation.  All rights reserved.

        Use of this sample source code is subject to the terms of the Microsoft
        license agreement under which you licensed this sample source code. If
        you did not accept the terms of the license agreement, you are not
        authorized to use this sample source code. For the terms of the license,
        please see the license agreement between you and Microsoft or, if applicable,
        see the LICENSE.RTF on your install media or the root of your tools installation.
        THE SAMPLE SOURCE CODE IS PROVIDED "AS IS", WITH NO WARRANTIES.

    .SYNOPSIS
        Installs the prerequisites for creating Windows containers

    .DESCRIPTION
        Installs the prerequisites for creating Windows containers

    .PARAMETER DockerPath
        Path to Docker.exe, can be local or URI

    .PARAMETER DockerDPath
        Path to DockerD.exe, can be local or URI

    .PARAMETER ExternalNetAdapter
        Specify a specific network adapter to bind to a DHCP network

    .PARAMETER Force 
        If a restart is required, forces an immediate restart.
        
    .PARAMETER HyperV 
        If passed, prepare the machine for Hyper-V containers

    .PARAMETER NoRestart
        If a restart is required the script will terminate and will not reboot the machine

    .PARAMETER SkipImageImport
        Skips import of the base WindowsServerCore image.

    .PARAMETER TransparentNetwork
        If passed, use DHCP configuration.  Otherwise, will use default docker network (NAT). (alias -UseDHCP)

    .PARAMETER WimPath
        Path to .wim file that contains the base package image

    .EXAMPLE
        .\Install-ContainerHost.ps1

#>
#Requires -Version 5.0

[CmdletBinding(DefaultParameterSetName="Standard")]
param(
    [string]
    [ValidateNotNullOrEmpty()]
    $DockerPath = "https://aka.ms/tp5/b/docker",

    [string]
    [ValidateNotNullOrEmpty()]
    $DockerDPath = "https://aka.ms/tp5/b/dockerd",

    [string]
    $ExternalNetAdapter,

    [switch]
    $Force,
    
    [switch]
    $IgnoreClient,

    [switch]
    $HyperV,

    [switch]
    $NoRestart,

    [Parameter(DontShow)]
    [switch]
    $PSDirect,

    [switch]
    $SkipImageImport,

    [Parameter(ParameterSetName="Staging", Mandatory)]
    [switch]
    $Staging,

    [switch]
    [alias("UseDHCP")]
    $TransparentNetwork,

    [string]
    [ValidateNotNullOrEmpty()]
    $WimPath
)

$global:RebootRequired = $false

$global:ErrorFile = "$pwd\Install-ContainerHost.err"

$global:BootstrapTask = "ContainerBootstrap"

$global:HyperVImage = "NanoServer"

function
Restart-And-Run()
{
    Test-Admin

    Write-Output "Restart is required; restarting now..."

    $argList = $script:MyInvocation.Line.replace($script:MyInvocation.InvocationName, "")

    #
    # Update .\ to the invocation directory for the bootstrap
    #
    $scriptPath = $script:MyInvocation.MyCommand.Path

    $argList = $argList -replace "\.\\", "$pwd\"

    if ((Split-Path -Parent -Path $scriptPath) -ne $pwd)
    {
        $sourceScriptPath = $scriptPath
        $scriptPath = "$pwd\$($script:MyInvocation.MyCommand.Name)"

        Copy-Item $sourceScriptPath $scriptPath
    }

    Write-Output "Creating scheduled task action ($scriptPath $argList)..."
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoExit $scriptPath $argList"

    Write-Output "Creating scheduled task trigger..."
    $trigger = New-ScheduledTaskTrigger -AtLogOn

    Write-Output "Registering script to re-run at next user logon..."
    Register-ScheduledTask -TaskName $global:BootstrapTask -Action $action -Trigger $trigger -RunLevel Highest | Out-Null

    try
    {
        if ($Force)
        {
            Restart-Computer -Force
        }
        else
        {
            Restart-Computer
        }
    }
    catch
    {
        Write-Error $_

        Write-Output "Please restart your computer manually to continue script execution."
    }

    exit
}


function
Install-Feature
{
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string]
        $FeatureName
    )

    Write-Output "Querying status of Windows feature: $FeatureName..."
    if (Get-Command Get-WindowsFeature -ErrorAction SilentlyContinue)
    {
        if ((Get-WindowsFeature $FeatureName).Installed)
        {
            Write-Output "Feature $FeatureName is already enabled."
        }
        else
        {
            Test-Admin

            Write-Output "Enabling feature $FeatureName..."
        }

        $featureInstall = Add-WindowsFeature $FeatureName

        if ($featureInstall.RestartNeeded -eq "Yes")
        {
            $global:RebootRequired = $true;
        }
    }
    else
    {
        if ((Get-WindowsOptionalFeature -Online -FeatureName $FeatureName).State -eq "Disabled")
        {
            if (Test-Nano)
            {
                throw "This NanoServer deployment does not include $FeatureName.  Please add the appropriate package"
            }

            Test-Admin

            Write-Output "Enabling feature $FeatureName..."
            $feature = Enable-WindowsOptionalFeature -Online -FeatureName $FeatureName -All -NoRestart

            if ($feature.RestartNeeded -eq "True")
            {
                $global:RebootRequired = $true;
            }
        }
        else
        {
            Write-Output "Feature $FeatureName is already enabled."

            if (Test-Nano)
            {
                #
                # Get-WindowsEdition is not present on Nano.  On Nano, we assume reboot is not needed
                #
            }
            elseif ((Get-WindowsEdition -Online).RestartNeeded)
            {
                $global:RebootRequired = $true;
            }
        }
    }
}


function
New-ContainerTransparentNetwork
{
    if ($ExternalNetAdapter)
    {
        $netAdapter = (Get-NetAdapter |? {$_.Name -eq "$ExternalNetAdapter"})[0]
    }
    else
    {
        $netAdapter = (Get-NetAdapter |? {($_.Status -eq 'Up') -and ($_.ConnectorPresent)})[0]
    }

    Write-Output "Creating container network (Transparent)..."
    New-ContainerNetwork -Name "Transparent" -Mode Transparent -NetworkAdapterName $netAdapter.Name | Out-Null
}


function
Install-ContainerHost
{
    "If this file exists when Install-ContainerHost.ps1 exits, the script failed!" | Out-File -FilePath $global:ErrorFile

    if (Test-Client)
    {
        if (-not $IgnoreClient)
        {
            Write-Warning "We recommend that you use the steps outlined in our documentation at https://aka.ms/windowscontainers/hypervonwin10. If you would like to proceed with this script, include the flag -IgnoreClient."
            throw "Ran on client without -IgnoreClient flag."
        }
        else
        {
            if (-not $HyperV)
            {
                Write-Output "Enabling Hyper-V containers by default for Client SKU"
                $HyperV = $true
            }
        }  
    }
    #
    # Validate required Windows features
    #
    Install-Feature -FeatureName Containers

    if ($HyperV)
    {
        Install-Feature -FeatureName Hyper-V
    }

    if ($global:RebootRequired)
    {
        if ($NoRestart)
        {
            Write-Warning "A reboot is required; stopping script execution"
            exit
        }

        Restart-And-Run
    }

    #
    # Unregister the bootstrap task, if it was previously created
    #
    if ((Get-ScheduledTask -TaskName $global:BootstrapTask -ErrorAction SilentlyContinue) -ne $null)
    {
        Unregister-ScheduledTask -TaskName $global:BootstrapTask -Confirm:$false
    }    

    #
    # Configure networking
    #
    if ($($PSCmdlet.ParameterSetName) -ne "Staging")
    {
        Write-Output "Configuring ICMP firewall rules for containers..."
        netsh advfirewall firewall add rule name="ICMP for containers" dir=in protocol=icmpv4 action=allow | Out-Null
        netsh advfirewall firewall add rule name="ICMP for containers" dir=out protocol=icmpv4 action=allow | Out-Null

        if ($TransparentNetwork)
        {
            Write-Output "Waiting for Hyper-V Management..."
            $networks = $null

            try
            {
                $networks = Get-ContainerNetwork -ErrorAction SilentlyContinue
            }
            catch
            {
                #
                # If we can't query network, we are in bootstrap mode.  Assume no networks
                #
            }

            if ($networks.Count -eq 0)
            {
                Write-Output "Enabling container networking..."
                New-ContainerTransparentNetwork
            }
            else
            {
                Write-Output "Networking is already configured.  Confirming configuration..."
                
                $transparentNetwork = $networks |? { $_.Mode -eq "Transparent" }

                if ($transparentNetwork -eq $null)
                {
                    Write-Output "We didn't find a configured external network; configuring now..."
                    New-ContainerTransparentNetwork
                }
                else
                {
                    if ($ExternalNetAdapter)
                    {
                        $netAdapters = (Get-NetAdapter |? {$_.Name -eq "$ExternalNetAdapter"})

                        if ($netAdapters.Count -eq 0)
                        {
                            throw "No adapters found that match the name $ExternalNetAdapter"
                        }

                        $netAdapter = $netAdapters[0]
                        $transparentNetwork = $networks |? { $_.NetworkAdapterName -eq $netAdapter.InterfaceDescription }

                        if ($transparentNetwork -eq $null)
                        {
                            throw "One or more external networks are configured, but not on the requested adapter ($ExternalNetAdapter)"
                        }

                        Write-Output "Configured transparent network found: $($transparentNetwork.Name)"
                    }
                    else
                    {
                        Write-Output "Configured transparent network found: $($transparentNetwork.Name)"
                    }
                }
            }
        }
    }

    #
    # Install, register, and start Docker
    #
    if (Test-Docker)
    {
        Write-Output "Docker is already installed."
    }
    else
    {
        Install-Docker -DockerPath $DockerPath -DockerDPath $DockerDPath
    }

    $newBaseImages = @()

    if (-not $SkipImageImport)
    {        
        if ($WimPath -eq "")
        {
            $imageName = "WindowsServerCore"

            if ($HyperV -or (Test-Nano))
            {
                $imageName = "NanoServer"
            }

            #
            # Install the base package
            #
            if (Test-InstalledContainerImage $imageName)
            {
                Write-Output "Image $imageName is already installed on this machine."
            }
            else
            {
                Test-ContainerImageProvider

                $hostBuildInfo = (gp "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLabEx.Split(".")
                $version = $hostBuildInfo[0]

                $InstallParams = @{
                    ErrorAction = "Stop"
                    Name = $imageName
                }

                if ($version -eq "14300")
                {
                    $InstallParams.Add("MinimumVersion", "10.0.14300.1000")
                    $InstallParams.Add("MaximumVersion", "10.0.14300.1010")
                    $versionString = "-MinimumVersion 10.0.14300.1000 -MaximumVersion 10.0.14300.1010"
                }
                else
                {
                    if (Test-Client)
                    {
                        $versionString = " [latest version]"
                    }
                    else
                    {
                        $qfe = $hostBuildInfo[1]

                        $InstallParams.Add("RequiredVersion", "10.0.$version.$qfe")
                        $versionString = "-RequiredVersion 10.0.$version.$qfe"
                    }                    
                }

                Write-Output "Getting Container OS image ($imageName $versionString) from OneGet (this may take a few minutes)..."
                #
                # TODO: expect the follow to have default ErrorAction of stop
                #
                Install-ContainerImage @InstallParams
            
                Write-Output "Container base image install complete."
                $newBaseImages += $imageName
            }
        }
        else
        {
            Write-Output "Installing Container OS image from $WimPath (this may take a few minutes)..."

            if (Test-Path $WimPath)
            {
                #
                # .wim is present and local
                #
            }
            elseif (($WimPath -as [System.URI]).AbsoluteURI -ne $null)
            {
                #
                # .wim is on a URI and must be downloaded
                #
                $localWimPath = "$pwd\ContainerBaseImage.wim"

                Copy-File -SourcePath $WimPath -DestinationPath $localWimPath

                $WimPath = $localWimPath
            }
            else
            {
                throw "Cannot copy from invalid WimPath $WimPath"
            }

            $imageName = (get-windowsimage -imagepath $WimPath -LogPath ($env:temp+"dism_$(random)_GetImageInfo.log") -Index 1).imagename

            if ($PSDirect -and (Test-Nano))
            {
                #
                # This is a gross hack for TP5 to avoid a CoreCLR issue
                #
                $modulePath = "$($env:Temp)\Containers2.psm1"

                $cmdletContent = gc $env:windir\System32\WindowsPowerShell\v1.0\Modules\Containers\1.0.0.0\Containers.psm1

                $cmdletContent = $cmdletContent.replace('Set-Acl $fileToReAcl -AclObject $acl', '[System.IO.FileSystemAclExtensions]::SetAccessControl($fileToReAcl, $acl)')
                $cmdletContent = $cmdletContent.replace('function Install-ContainerOSImage','function Install-ContainerOSImage2')

                $cmdletContent | sc $modulePath

                Import-Module $modulePath -DisableNameChecking
                Install-ContainerOSImage2 -WimPath $WimPath -Force
                Remove-Item $modulePath
            }
            else
            {
                Install-ContainerOsImage -WimPath $WimPath -Force
            }

            $newBaseImages += $imageName
        }

        #
        # Optionally OneGet the Hyper-V container image if it isn't just installed
        #
        if ($HyperV -and (-not (Test-Nano)))
        {
            if ((Test-InstalledContainerImage $global:HyperVImage))
            {
                Write-Output "OS image ($global:HyperVImage) is already installed."
            }
            else
            {
                Test-ContainerImageProvider

                Write-Output "Getting Container OS image ($global:HyperVImage) from OneGet (this may take a few minutes)..."
                Install-ContainerImage $global:HyperVImage

                $newBaseImages += $global:HyperVImage
            }
        }
    }

    if ($newBaseImages.Count -gt 0)
    {
        foreach ($baseImage in $newBaseImages)
        {
            Write-DockerImageTag -BaseImageName $baseImage
        }
    }

    Remove-Item $global:ErrorFile

    Write-Output "Script complete!"
}$global:AdminPriviledges = $false
$global:DockerData = "$($env:ProgramData)\docker"
$global:DockerServiceName = "docker"

function
Copy-File
{
    [CmdletBinding()]
    param(
        [string]
        $SourcePath,
        
        [string]
        $DestinationPath
    )
    
    if ($SourcePath -eq $DestinationPath)
    {
        return
    }
          
    if (Test-Path $SourcePath)
    {
        Copy-Item -Path $SourcePath -Destination $DestinationPath
    }
    elseif (($SourcePath -as [System.URI]).AbsoluteURI -ne $null)
    {
        if (Test-Nano)
        {
            $handler = New-Object System.Net.Http.HttpClientHandler
            $client = New-Object System.Net.Http.HttpClient($handler)
            $client.Timeout = New-Object System.TimeSpan(0, 30, 0)
            $cancelTokenSource = [System.Threading.CancellationTokenSource]::new() 
            $responseMsg = $client.GetAsync([System.Uri]::new($SourcePath), $cancelTokenSource.Token)
            $responseMsg.Wait()

            if (!$responseMsg.IsCanceled)
            {
                $response = $responseMsg.Result
                if ($response.IsSuccessStatusCode)
                {
                    $downloadedFileStream = [System.IO.FileStream]::new($DestinationPath, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
                    $copyStreamOp = $response.Content.CopyToAsync($downloadedFileStream)
                    $copyStreamOp.Wait()
                    $downloadedFileStream.Close()
                    if ($copyStreamOp.Exception -ne $null)
                    {
                        throw $copyStreamOp.Exception
                    }      
                }
            }  
        }
        elseif ($PSVersionTable.PSVersion.Major -ge 5)
        {
            #
            # We disable progress display because it kills performance for large downloads (at least on 64-bit PowerShell)
            #
            $ProgressPreference = 'SilentlyContinue'
            wget -Uri $SourcePath -OutFile $DestinationPath -UseBasicParsing
            $ProgressPreference = 'Continue'
        }
        else
        {
            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($SourcePath, $DestinationPath)
        } 
    }
    else
    {
        throw "Cannot copy from $SourcePath"
    }
}


function 
Expand-ArchiveNano
{
    [CmdletBinding()]
    param 
    (
        [string] $Path,
        [string] $DestinationPath
    )

    [System.IO.Compression.ZipFile]::ExtractToDirectory($Path, $DestinationPath)
}


function 
Expand-ArchivePrivate
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory=$true)]
        [string] 
        $Path,

        [Parameter(Mandatory=$true)]        
        [string] 
        $DestinationPath
    )
        
    $shell = New-Object -com Shell.Application
    $zipFile = $shell.NameSpace($Path)
    
    $shell.NameSpace($DestinationPath).CopyHere($zipFile.items())
    
}


function
Test-InstalledContainerImage
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        [ValidateNotNullOrEmpty()]
        $BaseImageName
    )

    $path = Join-Path (Join-Path $env:ProgramData "Microsoft\Windows\Images") "*$BaseImageName*"
    
    return Test-Path $path
}


function 
Test-Admin()
{
    # Get the ID and security principal of the current user account
    $myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
    $myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
  
    # Get the security principal for the Administrator role
    $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
  
    # Check to see if we are currently running "as Administrator"
    if ($myWindowsPrincipal.IsInRole($adminRole))
    {
        $global:AdminPriviledges = $true
        return
    }
    else
    {
        #
        # We are not running "as Administrator"
        # Exit from the current, unelevated, process
        #
        throw "You must run this script as administrator"   
    }
}


function 
Test-ContainerImageProvider()
{
    if (-not (Get-Command Install-ContainerImage -ea SilentlyContinue))
    {   
        Wait-Network

        Write-Output "Installing ContainerImage provider..."
        Install-PackageProvider ContainerImage -Force | Out-Null
    }

    if (-not (Get-Command Install-ContainerImage -ea SilentlyContinue))
    {
        throw "Could not install ContainerImage provider"
    }
}


function 
Test-Client()
{
    return (-not ((Get-Command Get-WindowsFeature -ErrorAction SilentlyContinue) -or (Test-Nano)))
}


function 
Test-Nano()
{
    $EditionId = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'EditionID').EditionId

    return (($EditionId -eq "ServerStandardNano") -or 
            ($EditionId -eq "ServerDataCenterNano") -or 
            ($EditionId -eq "NanoServer") -or 
            ($EditionId -eq "ServerTuva"))
}


function 
Wait-Network()
{
    $connectedAdapter = Get-NetAdapter |? ConnectorPresent

    if ($connectedAdapter -eq $null)
    {
        throw "No connected network"
    }
       
    $startTime = Get-Date
    $timeElapsed = $(Get-Date) - $startTime

    while ($($timeElapsed).TotalMinutes -lt 5)
    {
        $readyNetAdapter = $connectedAdapter |? Status -eq 'Up'

        if ($readyNetAdapter -ne $null)
        {
            return;
        }

        Write-Output "Waiting for network connectivity..."
        Start-Sleep -sec 5

        $timeElapsed = $(Get-Date) - $startTime
    }

    throw "Network not connected after 5 minutes"
}


function
Get-DockerImages
{
    return docker images
}

function
Find-DockerImages
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        [ValidateNotNullOrEmpty()]
        $BaseImageName
    )

    return docker images | Where { $_ -match $BaseImageName.tolower() }
}


function 
Install-Docker()
{
    [CmdletBinding()]
    param(
        [string]
        [ValidateNotNullOrEmpty()]
        $DockerPath = "https://aka.ms/tp5/docker",

        [string]
        [ValidateNotNullOrEmpty()]
        $DockerDPath = "https://aka.ms/tp5/dockerd"
    )

    Test-Admin

    Write-Output "Installing Docker..."
    Copy-File -SourcePath $DockerPath -DestinationPath $env:windir\System32\docker.exe
        
    Write-Output "Installing Docker daemon..."
    Copy-File -SourcePath $DockerDPath -DestinationPath $env:windir\System32\dockerd.exe

    #
    # Register the docker service.
    # Configuration options should be placed at %programdata%\docker\config\daemon.json
    #
    $daemonSettings = New-Object PSObject
        
    $certsPath = Join-Path $global:DockerData "certs.d"

    if (Test-Path $certsPath)
    {
        $daemonSettings | Add-Member NoteProperty hosts @("npipe://", "0.0.0.0:2376")
        $daemonSettings | Add-Member NoteProperty tlsverify true
        $daemonSettings | Add-Member NoteProperty tlscacert (Join-Path $certsPath "ca.pem")
        $daemonSettings | Add-Member NoteProperty tlscert (Join-Path $certsPath "server-cert.pem")
        $daemonSettings | Add-Member NoteProperty tlskey (Join-Path $certsPath "server-key.pem")
    }
    else
    {
        # Default local host
        $daemonSettings | Add-Member NoteProperty hosts @("npipe://")
    }

    & dockerd --register-service --service-name $global:DockerServiceName

    $daemonSettingsFile = "$global:DockerData\config\daemon.json"

    $daemonSettings | ConvertTo-Json | Out-File -FilePath $daemonSettingsFile -Encoding ASCII

    Start-Docker

    #
    # Waiting for docker to come to steady state
    #
    Wait-Docker

    Write-Output "The following images are present on this machine:"
    foreach ($image in (Get-DockerImages))
    {
        Write-Output "    $image"
    }
    Write-Output ""
}


function 
Start-Docker()
{
    Start-Service -Name $global:DockerServiceName
}


function 
Stop-Docker()
{
    Stop-Service -Name $global:DockerServiceName
}


function 
Test-Docker()
{
    $service = Get-Service -Name $global:DockerServiceName -ErrorAction SilentlyContinue

    return ($service -ne $null)
}


function 
Wait-Docker()
{
    Write-Output "Waiting for Docker daemon..."
    $dockerReady = $false
    $startTime = Get-Date

    while (-not $dockerReady)
    {
        try
        {
            docker version | Out-Null

            if (-not $?)
            {
                throw "Docker daemon is not running yet"
            }

            $dockerReady = $true
        }
        catch 
        {
            $timeElapsed = $(Get-Date) - $startTime

            if ($($timeElapsed).TotalMinutes -ge 1)
            {
                throw "Docker Daemon did not start successfully within 1 minute."
            } 

            # Swallow error and try again
            Start-Sleep -sec 1
        }
    }
    Write-Output "Successfully connected to Docker Daemon."
}


function 
Write-DockerImageTag()
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $BaseImageName
    )

    $dockerOutput = Find-DockerImages $BaseImageName

    if ($dockerOutput.Count -gt 1)
    {
        Write-Output "Base image is already tagged:"
    }
    else
    {
        if ($dockerOutput.Count -lt 1)
        {
            #
            # Docker restart required if the image was installed after Docker was 
            # last started
            #
            Stop-Docker
            Start-Docker

            $dockerOutput = Find-DockerImages $BaseImageName

            if ($dockerOutput.Count -lt 1)
            {
                throw "Could not find Docker image to match '$BaseImageName'"
            }
        }

        if ($dockerOutput.Count -gt 1)
        {
            Write-Output "Base image is already tagged:"
        }
        else
        {
            #
            # Register the base image with Docker
            #
            $imageId = ($dockerOutput -split "\s+")[2]

            Write-Output "Tagging new base image ($imageId)..."
            
            docker tag $imageId "$($BaseImageName.tolower()):latest"
            Write-Output "Base image is now tagged:"

            $dockerOutput = Find-DockerImages $BaseImageName
        }
    }
    
    Write-Output $dockerOutput
}

try
{
    Install-ContainerHost
}
catch 
{
    Write-Error $_
}
