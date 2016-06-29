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
                
    .PARAMETER Azure
        If passed, will prepare the VHD for Azure
        
    .PARAMETER DockerPath
        Path to a private Docker.exe.  Defaults to https://aka.ms/tp5/docker
        
    .PARAMETER DockerDPath
        Path to a private DockerD.exe.  Defaults to https://aka.ms/tp5/dockerd

    .PARAMETER Password
        Administrator password of VM   

    .PARAMETER VhdPath
        Path to VHD to be exported by this script
           
    .PARAMETER VmName
        Friendly name for VM to be exported.  Required.

    .EXAMPLE
        .\Export-ContainerHost.ps1 -SkipDocker
                
#>
#Requires -Version 5.0

[CmdletBinding(DefaultParameterSetName="VM")]
param(
    [switch]
    $Azure,

    [string]
    [ValidateNotNullOrEmpty()]
    $DockerPath = "https://aka.ms/tp5/b/docker",

    [string]
    [ValidateNotNullOrEmpty()]
    $DockerDPath = "https://aka.ms/tp5/b/dockerd",
         
    [switch]
    $NanoServer,
        
    [string]
    [ValidateNotNullOrEmpty()]
    $Password = "P@ssw0rd",

    [string]
    [ValidateNotNullOrEmpty()]
    $ScriptPath = "https://aka.ms/tp5/Install-ContainerHost",
        
    [Parameter(ParameterSetName="VHD",Mandatory=$true,Position=0)]
    [string]
    [ValidateNotNullOrEmpty()]
    $SourceVhdPath,

    [string]
    [ValidateNotNullOrEmpty()]
    $VhdPath,
        
    [Parameter(ParameterSetName="VM",Mandatory=$true,Position=0)]
    [string]
    [ValidateNotNullOrEmpty()]
    $VmName,

    [switch]
    $ZDP
)

if ($NanoServer)
{
    $global:imageName = "NanoServer"
}
else
{
    $global:imageName = "WindowsServerCore"
}

if (-not ($VhdPath))
{
    $VhdPath = "$($global:imageName)_en-us_TP5_Container.vhd"
}

$global:ErrorFile = "$($env:SystemDrive)\Export-ContainerHost.err"
$global:VhdMutex = New-Object System.Threading.Mutex($False, "3 $global:imageName");     

function 
Compress-ArchivePrivate
{
    [CmdletBinding()]
    param 
    (
        [string] $SourceDirectoryPath,
        [string] $DestinationZipFilePath
    )

    $filePath = Get-ChildItem $env:systemroot System.IO.Compression.FileSystem.dll -Recurse -ErrorAction SilentlyContinue

    Import-Module $filePath.FullName -Force

    [System.IO.Compression.ZipFile]::CreateFromDirectory($SourceDirectoryPath, $DestinationZipFilePath)
}
      
        
function 
Export-ContainerHost()
{
    $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PsCredential("Administrator", $securePassword)  
        
    if ($Azure)
    {
        #
        # Run Azure-specific steps
        #
        $VhdPath = $VhdPath -replace "\.vhd","_Azure-$(Get-Date -format yyyyMMdd).vhd"
    }
    
    if ($PSCmdlet.ParameterSetName -eq "VM")
    {        
        if ($(Get-VM $VmName -ea SilentlyContinue) -eq $null)
        {
            throw "VM $VmName does not exist on this host"
        }

        $guestScriptBlock = 
        {
            [CmdletBinding()]
            param(
                [Parameter(Position=0)]
                [string]
                $ErrorFile,

                [Parameter(Position=1)]
                [bool]
                $NanoServer
                )
              
            "If this file exists when Install-ContainerHost.ps1 exits, the script failed!" | Out-File -FilePath $ErrorFile
                
            if (Test-Path "$($env:SystemDrive)\unattend.xml")
            {
                Write-Output "Removing previous unattend..."    
                Remove-Item "$($env:SystemDrive)\unattend.xml"
            }

            if ($NanoServer)
            {
                Write-Output "Removing previous setup logs..."    
                Remove-Item "$($env:windir)\Panther" -Recurse
                        
                #
                # TODO - must restore pristene registry state
                #
            
            }
            else
            {
                Write-Output "Running sysprep..." 
                Start-Process -FilePath "$($env:windir)\System32\Sysprep\Sysprep.exe" -Wait -ArgumentList "/quiet /generalize /oobe /quit /mode:vm"
               
                if (-not (Test-Path "$($env:windir)\System32\Sysprep\Sysprep_succeeded.tag"))
                {
                    Write-Output "File not found... $($env:windir)\System32\Sysprep\Sysprep_succeeded.tag"
                    throw "Sysprep failed"
                }

                Write-Output "Sysprep succeeded."
            }

            Remove-Item $ErrorFile
        }

        #
        # Sysprep
        #
        Write-Output "Preparing to generalize the VM..."    
        Invoke-Command -VMName $VmName -Credential $credential -ScriptBlock $guestScriptBlock -ArgumentList $global:ErrorFile,$NanoServer
    
        #
        # After sysprep, PowerShell Direct no longer works
        #

        #
        # Stop VM
        #
        Write-Output "Stopping VM $VmName..."    
        Stop-Vm $VmName

        $bootVhdDrive = Get-VMHardDiskDrive -VMName $VmName |? { ($_.ControllerType -eq "IDE") -and ($_.ControllerNumber -eq 0) -and ($_.ControllerLocation -eq 0) }
    
        $bootVhd = Get-Vhd $bootVhdDrive.Path
        
        try
        {
            Write-Output "Waiting for boot VHD mount mutex..."
            $global:VhdMutex.WaitOne() | Out-Null;
            Write-Output "Mutex acquired."
        
            Write-Output "Mounting VHD for offline processing..."
            $disk = $bootVhd | Mount-VHD -PassThru | Get-Disk        
    
            #
            # We can assume there is one partition/volume
            #
            $driveLetter = ($disk | Get-Partition | Get-Volume).DriveLetter
        
            #
            # Confirm export script success
            #
            if (Test-Path "$($driveLetter):\Export-ContainerHost.err")
            {
                throw "Export-ContainerHost.ps1 failed in the VM"
            }

            #
            # Delete unnecessary files
            #
            $logFile = "$($driveLetter):\Install-ContainerHost.log"
            if (Test-Path $logFile)
            {
                Write-Output "Deleting log file..."
                Remove-Item $logFile -Force
            }

            $pageFile = "$($driveLetter):\pagefile.sys"
            if (Test-Path $pageFile)
            {
                Write-Output "Deleting pagefile..."
                Remove-Item $pageFile -Force
            }

            $hiberFile = "$($driveLetter):\hiberfil.sys"
            if (Test-Path $hiberFile)
            {
                Write-Output "Deleting hiberfil..."
                Remove-Item $hiberFile -Force
            }

            Write-Host "Pausing for manual preparation steps.  Press any key after manual steps are completed."
            $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
        }
        catch 
        {
            throw $_
        }
        finally
        {
            Write-Output "Dismounting VHD..."
            Dismount-VHD -Path $bootVhd.Path    

            $global:VhdMutex.ReleaseMutex()
        }

        $SourceVhdPath = $bootVhd.Path
    }

    #
    # Convert boot VHD
    #
    if (Test-Path $VhdPath)
    {
        Write-Output "Deleting existing file $VhdPath."
        Remove-Item $VhdPath
    }

    Write-Output "Converting boot VHD..."
    Convert-VHD -Path $SourceVhdPath -DestinationPath $VhdPath -VHDType Dynamic -BlockSizeBytes 512KB
    
    $exportVhd = Get-Vhd $VhdPath

    if ($Azure)
    {
        #
        # Expand VHD to 127 GB
        #
        # TODO: re-enable
        #Resize-VHD -Path $VhdPath -SizeBytes 127GB
    }

    if ($Azure -or $ZDP)
    { 
        try
        {
            Write-Output "Waiting for boot VHD mount mutex..."
            $global:VhdMutex.WaitOne() | Out-Null;
            Write-Output "Mutex acquired."
        
            Write-Output "Mounting VHD for offline processing..."
            $disk = $exportVhd | Mount-VHD -PassThru | Get-Disk        
    
            #
            # We can assume there is one partition/volume
            #
            $driveLetter = ($disk | Get-Partition | Get-Volume).DriveLetter

            if ($Azure)
            {
                #
                # Extend partition/volume
                #     
                $partition = $disk | Get-Partition

                Write-Output "Getting max partition size..."
                $size = $partition | Get-PartitionSupportedSize
                Write-Output "Max partition size is $($size.SizeMax)..."
            
                Write-Output "Setting max partition size..."
                #$partition | Resize-Partition -Size $size.SizeMax
                
                #
                # Add optional packages
                #
                if ($NanoServer)
                {
                    #
                    # We assume Microsoft-NanoServer-Guest-Package is already installed
                    #
                    $packages = @("Microsoft-NanoServer-Containers-Package")
                    
                    foreach ($packageName in $packages)
                    {
                        Write-Output "Adding $packageName..."
                        Add-WindowsPackage -Path "$($driveLetter):" -PackagePath "$($driveLetter):\Packages\$($packageName).cab"  | Out-Null

                        Write-Output "Adding $packageName (en-us)..."
                        Add-WindowsPackage -Path "$($driveLetter):" -PackagePath "$($driveLetter):\Packages\en-us\$($packageName).cab"  | Out-Null
                    }
                }

                #
                # Copy Install-ContainerHost.ps1
                #
                Write-Output "Copying Install-ContainerHost.ps1 into VHD..."
                Copy-File -SourcePath $ScriptPath -DestinationPath "$($driveLetter):\Install-ContainerHost.ps1"
                        
                #
                # Copy docker
                #
                Write-Output "Copying Docker into VHD..."
                try
                {
                    Copy-File -SourcePath $DockerPath -DestinationPath "$($driveLetter):\Windows\System32\docker.exe"
                    Copy-File -SourcePath $DockerDPath -DestinationPath "$($driveLetter):\Windows\System32\dockerd.exe"
                }
                catch
                {
                    Copy-File -SourcePath $DockerPath -DestinationPath "$($driveLetter):\Windows\System32\docker.exe"

                    try
                    {
                        Copy-File -SourcePath $DockerDPath -DestinationPath "$($driveLetter):\Windows\System32\dockerd.exe"
                    }
                    catch 
                    {
                        Write-Warning "DockerD not yet present."
                    }
                }

                #
                # Set Azure post-specialize script to launch Install-ContainerHost.ps1
                #
                Write-Output "Creating Azure setupcomplete.cmd script..."
                       
                if ($NanoServer)
                {
                    #
                    # Copy private modules from Sergey
                    #
                    Write-Output "Copying Sergey's private modules into VHD..."
                    Copy-Item "\\scratch2\scratch\sbabkin\docker\DockerHelper.psm1" "$($driveLetter):\DockerHelper.psm1"                
                    Copy-Item "\\scratch2\scratch\sbabkin\docker\PsPreload.psm1" "$($driveLetter):\PsPreload.psm1"
                
                    New-Item -ItemType Directory -Force -Path "$($driveLetter):\Windows\Setup\Scripts" | Out-Null
                    $specializeFile = "$($driveLetter):\Windows\Setup\Scripts\setupcomplete.cmd"
                }
                else
                {
                    New-Item -ItemType Directory -Force -Path "$($driveLetter):\Windows\OEM" | Out-Null
                    $specializeFile = "$($driveLetter):\Windows\OEM\setupcomplete2.cmd"
                }

                New-SetupCompleteText -NanoServer $NanoServer | Out-File $specializeFile -Encoding ASCII -Append

                $dockerCerts = "$($driveLetter):\ProgramData\Docker\certs.d"

                if (-not (Test-Path $dockerCerts))
                {
                    Write-Output "Creating Docker program data..."
                    New-Item -ItemType Directory -Force -Path $dockerCerts | Out-Null
                }
            }
        
            if ($ZDP)
            {
                Write-Output "Adding 12C package..."
                Add-WindowsPackage -Path "$($driveLetter):" -PackagePath "$pwd\Windows10.0-KB3124200-x64.cab" | Out-Null
            }
        }
        catch 
        {
            throw $_
        }
        finally
        {
            Write-Output "Dismounting VHD..."
            Dismount-VHD -Path $exportVhd.Path    

            $global:VhdMutex.ReleaseMutex()
        }
    }

    Write-Output "Script complete."
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
        
    $certsPath = "$global:DockerData\certs.d"

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



function
New-SetupCompleteText
{
    
    [CmdletBinding()]
    param 
    (             
        [bool]
        $NanoServer
    )

    $setupComplete = @"

"@

    if ($NanoServer)
    {
        # assume input image has what we need
        
        $setupComplete += @"
PowerShell.exe -Command "Import-Module %SystemDrive%\PsPreload.psm1; Import-DefaultModules; try { %SystemDrive%\Install-ContainerHost.ps1 -DockerPath %SystemRoot%\System32\Docker.exe -DockerDPath %SystemRoot%\System32\DockerD.exe } catch { `$_ | Out-String } " >%SystemDrive%\Install-ContainerHost.log 2>&1

"@
    }
    else
    {    
        # Activate
        $setupComplete += @"
cscript %SystemRoot%\System32\slmgr.vbs -ato

PowerShell.exe -Command "& { %SystemDrive%\Install-ContainerHost.ps1 -DockerPath %SystemRoot%\System32\Docker.exe -DockerDPath %SystemRoot%\System32\DockerD.exe | Tee-Object -FilePath %SystemDrive%\Install-ContainerHost.log }"

"@
    }

    return $setupComplete
}
$global:MinimumSupportedBuild = 10240


function 
Test-Version()
{
    $os = Get-WmiObject -Class Win32_OperatingSystem

    if ([int]($os.BuildNumber) -lt $global:MinimumSupportedBuild)
    {
        throw "This script is not supported.  Upgrade to build $global:MinimumSupportedBuild or higher."
    }
}


try
{
    Test-Version
    
    Test-Admin
    
    Export-ContainerHost
}
catch 
{
    Write-Error $_
}
