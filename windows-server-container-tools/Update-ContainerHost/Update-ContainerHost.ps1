
############################################################
# Script assembled with makeps1.js from
# Update-ContainerHost-Source.ps1
# ..\common\ContainerHost-Common.ps1
# Update-ContainerHost-Main.ps1
############################################################

<#
    .NOTES
        Copyright (c) Microsoft Corporation.  All rights reserved.
    
    .SYNOPSIS
        Installs or updates a container host with latest docker.exe

    .DESCRIPTION
        Ensures the container host has the latest Docker
        
    .PARAMETER DockerPath
        Path to a private Docker.exe.  Defaults to https://aka.ms/tp5/docker
        
    .PARAMETER DockerDPath
        Path to a private DockerD.exe.  Defaults to https://aka.ms/tp5/dockerd

    .EXAMPLE
        .\Update-ContainerHost.ps1 -DockerPath "https://aka.ms/tp5/docker"
                
#>
#Requires -Version 5.0

param(
    [string]
    [ValidateNotNullOrEmpty()]
    $DockerPath = "https://aka.ms/tp5/docker",

    [string]
    [ValidateNotNullOrEmpty()]
    $DockerDPath = "https://aka.ms/tp5/dockerd"
)


function 
Update-ContainerHost()
{
    Test-Admin

    if (Test-Docker)
    {
        #
        # Stop service
        #
        Stop-Docker

        #
        # Update service
        #
        Write-Output "Updating $global:DockerServiceName..."
        Copy-File -SourcePath $DockerPath -DestinationPath $env:windir\System32\docker.exe

        try
        {
            Copy-File -SourcePath $DockerDPath -DestinationPath $env:windir\System32\dockerd.exe
        }
        catch 
        {
            Write-Warning "DockerD not yet present."
        }        

        #
        # Start service
        #
        Start-Docker
    }
    else
    {
        Install-Docker -DockerPath $DockerPath -DockerDPath $DockerDPath
    }    
}
$global:AdminPriviledges = $false
$global:DockerData = "$($env:ProgramData)\docker"
$global:DockerServiceName = "Docker"

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
Get-Nsmm
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        [ValidateNotNullOrEmpty()]
        $Destination,

        [string]
        [ValidateNotNullOrEmpty()]
        $WorkingDir = "$env:temp"
    )
    
    Write-Output "This script uses a third party tool: NSSM. For more information, see https://nssm.cc/usage"       
    Write-Output "Downloading NSSM..."

    $nssmUri = "https://nssm.cc/release/nssm-2.24.zip"            
    $nssmZip = "$($env:temp)\$(Split-Path $nssmUri -Leaf)"
            
    Write-Verbose "Creating working directory..."
    $tempDirectory = New-Item -ItemType Directory -Force -Path "$($env:temp)\nssm"
    
    Copy-File -SourcePath $nssmUri -DestinationPath $nssmZip
            
    Write-Output "Extracting NSSM from archive..."
    if (Test-Nano)
    {
        Expand-ArchiveNano -Path $nssmZip -DestinationPath $tempDirectory.FullName
    }
    elseif ($PSVersionTable.PSVersion.Major -ge 5)
    {
        Expand-Archive -Path $nssmZip -DestinationPath $tempDirectory.FullName
    }
    else
    {
        Expand-ArchivePrivate -Path $nssmZip -DestinationPath $tempDirectory.FullName
    }
    Remove-Item $nssmZip

    Write-Verbose "Copying NSSM to $Destination..."
    Copy-Item -Path "$($tempDirectory.FullName)\nssm-2.24\win64\nssm.exe" -Destination "$Destination"

    Write-Verbose "Removing temporary directory..."
    $tempDirectory | Remove-Item -Recurse
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

    try
    {
        Write-Output "Installing Docker daemon..."
        Copy-File -SourcePath $DockerDPath -DestinationPath $env:windir\System32\dockerd.exe
    }
    catch 
    {
        Write-Warning "DockerD not yet present."
    }

    $dockerLog = "$global:DockerData\daemon.log"

    if (-not (Test-Path $global:DockerData))
    {
        Write-Output "Creating Docker program data..."
        New-Item -ItemType Directory -Force -Path $dockerData | Out-Null
    }

    $dockerDaemonScript = "$global:DockerData\runDockerDaemon.cmd"

    New-DockerDaemonRunText | Out-File -FilePath $dockerDaemonScript -Encoding ASCII

    if (Test-Nano)
    {
        Write-Output "Creating scheduled task action..."
        $action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c $dockerDaemonScript > $dockerLog 2>&1"

        Write-Output "Creating scheduled task trigger..."
        $trigger = New-ScheduledTaskTrigger -AtStartup

        Write-Output "Creating scheduled task settings..."
        $settings = New-ScheduledTaskSettingsSet -Priority 5

        Write-Output "Registering Docker daemon to launch at startup..."
        Register-ScheduledTask -TaskName $global:DockerServiceName -Action $action -Trigger $trigger -Settings $settings -User SYSTEM -RunLevel Highest | Out-Null
    }
    else
    {
        if (Test-Path "$($env:SystemRoot)\System32\nssm.exe")
        {
            Write-Output "NSSM is already installed"
        }
        else
        {
            Get-Nsmm -Destination "$($env:SystemRoot)\System32" -WorkingDir "$env:temp"
        }

        Write-Output "Configuring NSSM for $global:DockerServiceName service..."
        Start-Process -Wait "nssm" -ArgumentList "install $global:DockerServiceName $($env:SystemRoot)\System32\cmd.exe /s /c $dockerDaemonScript < nul"
        Start-Process -Wait "nssm" -ArgumentList "set $global:DockerServiceName DisplayName Docker Daemon"
        Start-Process -Wait "nssm" -ArgumentList "set $global:DockerServiceName Description The Docker Daemon provides management capabilities of containers for docker clients"
        # Pipe output to daemon.log
        Start-Process -Wait "nssm" -ArgumentList "set $global:DockerServiceName AppStderr $dockerLog"
        Start-Process -Wait "nssm" -ArgumentList "set $global:DockerServiceName AppStdout $dockerLog"
        # Allow 30 seconds for graceful shutdown before process is terminated
        Start-Process -Wait "nssm" -ArgumentList "set $global:DockerServiceName AppStopMethodConsole 30000"
    }

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
New-DockerDaemonRunText
{
    return @"

@echo off
set certs=%ProgramData%\docker\certs.d

if exist %ProgramData%\docker (goto :run)
mkdir %ProgramData%\docker

:run
if exist %certs%\server-cert.pem (if exist %ProgramData%\docker\tag.txt (goto :secure))

if not exist %systemroot%\system32\dockerd.exe (goto :legacy)

dockerd -H npipe:// 
goto :eof

:legacy
docker daemon -H npipe:// 
goto :eof

:secure
if not exist %systemroot%\system32\dockerd.exe (goto :legacysecure)
dockerd -H npipe:// -H 0.0.0.0:2376 --tlsverify --tlscacert=%certs%\ca.pem --tlscert=%certs%\server-cert.pem --tlskey=%certs%\server-key.pem
goto :eof

:legacysecure
docker daemon -H npipe:// -H 0.0.0.0:2376 --tlsverify --tlscacert=%certs%\ca.pem --tlscert=%certs%\server-cert.pem --tlskey=%certs%\server-key.pem

"@

}


function 
Start-Docker()
{
    Write-Output "Starting $global:DockerServiceName..."
    if (Test-Nano)
    {
        Start-ScheduledTask -TaskName $global:DockerServiceName
        Start-Sleep -Seconds 5
    }
    else
    {
        Start-Service -Name $global:DockerServiceName
    }
}


function 
Stop-Docker()
{
    Write-Output "Stopping $global:DockerServiceName..."
    if (Test-Nano)
    {
        Stop-ScheduledTask -TaskName $global:DockerServiceName

        #
        # ISSUE: can we do this more gently?
        #
        Get-Process dockerd | Stop-Process -Force
    }
    else
    {
        Stop-Service -Name $global:DockerServiceName
    }
}


function 
Test-Docker()
{
    $service = $null

    if (Test-Nano)
    {
        $service = Get-ScheduledTask -TaskName $global:DockerServiceName -ErrorAction SilentlyContinue
    }
    else
    {
        $service = Get-Service -Name $global:DockerServiceName -ErrorAction SilentlyContinue
    }

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
    Update-ContainerHost
}
catch 
{
    Write-Error $_
}
