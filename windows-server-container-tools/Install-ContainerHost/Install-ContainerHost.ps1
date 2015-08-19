
############################################################
# Script assembled with makeps1.js from
# Install-ContainerHost-Source.ps1
# ..\common\ContainerHost-Common.ps1
# Install-ContainerHost-Docker.ps1
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
            
    .PARAMETER ExternalNetAdapter
        Specify a specific network adapter to bind to a DHCP switch
            
    .PARAMETER NoRestart
        If a restart is required the script will terminate and will not reboot the machine

    .PARAMETER SkipDocker
        If passed, skip Docker install
            
    .PARAMETER $UseDHCP
        If passed, use DHCP configuration

    .PARAMETER WimPath
        Path to .wim file that contains the base package image

    .EXAMPLE
        .\Install-ContainerHost.ps1 -SkipDocker
                
#>
#Requires -Version 5.0

[CmdletBinding(DefaultParameterSetName="IncludeDocker")]
param(
    [string]
    [ValidateNotNullOrEmpty()]
    $DockerPath = "http://aka.ms/ContainerTools",
      
    [string]
    $ExternalNetAdapter,
         
    [string]
    $NATSubnetPrefix = "172.16.0.0/12",
       
    [switch]
    $NoRestart,

    [Parameter(ParameterSetName="SkipDocker", Mandatory=$true)]
    [switch]
    $SkipDocker,

    [Parameter(ParameterSetName="Staging", Mandatory=$true)]
    [switch]
    $Staging,

    [switch]
    $UseDHCP,

    [string]
    [ValidateNotNullOrEmpty()]
    $WimPath = "http://aka.ms/ContainerOSImage"
)

$global:RebootRequired = $false

$global:ErrorFile = "$pwd\Install-ContainerHost.err"

$global:RegRunPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$global:RegDockerKey = "DockerService"

$global:RegRunOncePath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
$global:RegPowershellValue = (Join-Path $env:windir "system32\WindowsPowerShell\v1.0\powershell.exe")
$global:RegBootstrapFile = "$pwd\Install-ContainerHost-Bootstrap.ps1"

$global:SwitchName = "Virtual Switch"

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

    #
    # Command line is now too long for RunOnce, so use Out-File
    #
    $cmdLine = "$global:RegPowershellValue $scriptPath $argList"

    Write-Output "Registering the following command to run post-reboot: $cmdLine"
    
    "$cmdLine" | Out-File -FilePath $global:RegBootstrapFile 
    
    Set-ItemProperty -Path "$global:RegRunOncePath" -Name "Install-ContainerHost" -Value "$global:RegPowershellValue -NoExit $global:RegBootstrapFile"

    try
    {
        Restart-Computer
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

            if ((Get-WindowsEdition -Online).RestartNeeded)
            {
                $global:RebootRequired = $true;
            }
        }
    }
}


function
New-ContainerDhcpSwitch
{
    if ($ExternalNetAdapter)
    {
        $netAdapter = (Get-NetAdapter |? {$_.Name -eq "$ExternalNetAdapter"})[0]
    }
    else
    {
        $netAdapter = (Get-NetAdapter |? {($_.Status -eq 'Up') -and ($_.ConnectorPresent)})[0]
    }

    Write-Output "Creating container switch (DHCP)..."
    New-VmSwitch $global:SwitchName -NetAdapterName $netAdapter.Name | Out-Null
}


function
New-ContainerNatSwitch
{
    [CmdletBinding()]
    param(
        [string]
        [ValidateNotNullOrEmpty()]
        $SubnetPrefix
    )

    Write-Output "Creating container switch (NAT)..."
    New-VmSwitch $global:SwitchName -SwitchType NAT -NatSubnetAddress $SubnetPrefix | Out-Null
}


function
New-ContainerNat
{
    [CmdletBinding()]
    param(
        [string]
        [ValidateNotNullOrEmpty()]
        $SubnetPrefix
    )

    Write-Output "Creating NAT for $SubnetPrefix..."
    New-NetNat -Name ContainerNAT -InternalIPInterfaceAddressPrefix $SubnetPrefix | Out-Null
}


function
Install-ContainerHost
{
    "If this file exists when Install-ContainerHost.ps1 exits, the script failed!" | Out-File -FilePath $global:ErrorFile

    #
    # Validate required Windows features
    #
    Install-Feature -FeatureName Containers

    if ($global:RebootRequired)
    {
        if ($NoRestart)
        {
            Write-Warning "A reboot is required; stopping script execution"
            exit
        }

        Restart-And-Run
    }

    if (Test-Path "$($env:SystemDrive)\zdp.cab")
    {
        Write-Output "Applying ZDP..."
        Add-WindowsPackage -Online -PackagePath "$($global:localVhdRoot)\zdp.cab" -NoRestart

        if ((Get-WindowsEdition -Online).RestartNeeded)
        {
            Write-Warning "Restart Needed."
        }
    }

    #
    # Configure networking
    #
    if ($($PSCmdlet.ParameterSetName) -ne "Staging")
    {
        $switchCollection = Get-VmSwitch

        if ($switchCollection.Count -eq 0)
        {
            Write-Output "Enabling container networking..."
            
            if ($UseDHCP)
            {
                New-ContainerDhcpSwitch
            }
            else
            {   
                New-ContainerNatSwitch $NATSubnetPrefix

                New-ContainerNat $NATSubnetPrefix
            }    
        }
        else
        {
            Write-Output "Networking is already configured.  Confirming configuration..."

            if ($UseDHCP)
            {
                $dhcpSwitchCollection = $switchCollection |? { $_.SwitchType -eq "External" }

                if ($dhcpSwitchCollection -eq $null)
                {
                    Write-Output "We didn't find a configured external switch; configuring now..."
                    New-ContainerDhcpSwitch
                }
                else
                {
                    if ($($dhcpSwitchCollection |? { $_.SwitchName -eq $global:SwitchName }) -eq $null)
                    {
                        throw "One or more external switches are configured, but none match the expected switch name ($global:SwitchName)"
                    }
                }
            }
            else
            {
                $subnetPrefix = $NATSubnetPrefix
                $natSwitchExists = $false

                foreach ($switch in $($switchCollection |? { $_.SwitchType -eq "NAT" }))
                {
                    if (($switch.Name -eq $global:SwitchName) -and
                        ($switch.NATSubnetAddress -ne ""))
                    {
                        $subnetPrefix = $switch.NATSubnetAddress
                        $natSwitchExists = $true
                        break
                    }
                }

                if (-not $natSwitchExists)
                {
                    Write-Output "We didn't find a configured NAT switch; configuring now..."
                    New-ContainerNatSwitch $subnetPrefix
                }

                $existingNat = Get-NetNat

                if ($existingNat -eq $null)
                {
                    Write-Output "We didn't find a configured NAT; configuring now..."
                    New-ContainerNat $subnetPrefix
                }
                elseif ($existingNat.InternalIPInterfaceAddressPrefix -ne $subnetPrefix)
                {
                    throw "Unexpected NAT configuration.  Switch subnet ($subnetPrefix) does not match NAT subnet ($($existingNat.InternalIPInterfaceAddressPrefix))"
                }
            }
        }
    }

    #
    # Install the base package
    #
    $imageCollection = Get-ContainerImage

    if ($imageCollection -eq $null)
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
            
            #
            # We disable progress display because it kills performance for large downloads (at least on 64-bit PowerShell)
            #
            $ProgressPreference = 'SilentlyContinue'
            Write-Output "Downloading Container OS image (WIM) from $WimPath to $localWimPath..."
            wget -Uri $WimPath -OutFile $localWimPath -UseBasicParsing
            $ProgressPreference = 'Continue'   

            $WimPath = $localWimPath
        }
        else
        {
            throw "Cannot copy from invalid WimPath $WimPath"
        }

        Install-ContainerOsImage -WimPath $WimPath -Force
        
        while ($imageCollection -eq $null)
        {
            #
            # Sleeping to ensure VMMS has restarted to workaround TP3 issue
            #
            Write-Output "Waiting for VMMS to return image at ($(get-date))..."

            Start-Sleep -Sec 2
                
            $imageCollection = Get-ContainerImage
        }

        Write-Output "Container base image install complete.  Querying container images..."            
    }

    $baseImage = $imageCollection |? IsOSImage
    
    if ($baseImage -eq $null)
    {
        throw "No Container OS image installed!"
    }

    Write-Output "The following images are present on this machine:"
    foreach ($image in $imageCollection)
    {
        Write-Output "    $($image).Name"
    }
    Write-Output ""
    
    #
    # Install, register, and start Docker
    #
    if ($($PSCmdlet.ParameterSetName) -eq "IncludeDocker")
    {    
        if (Test-Path "$env:windir\System32\docker.exe")
        {
            Write-Output "Docker is already installed."
        }
        else
        {
            Test-Admin

            Write-Output "Installing Docker..."

            if (Test-Path $DockerPath)
            {
                Copy-Item -Path $DockerPath -Destination $env:windir\System32\
            }
            elseif (($DockerPath -as [System.URI]).AbsoluteURI -ne $null)
            {
                wget -Uri $DockerPath -OutFile $env:windir\System32\docker.exe -UseBasicParsing
            }
            else
            {
                throw "Cannot copy from $DockerPath"
            }
        }

        $serviceName = "Docker"
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

        if ($service -ne $null)
        {
            Write-Output "Docker service is already installed."
        }
        else
        {
            Test-Admin
            
            if (Test-Path "$($env:SystemRoot)\System32\nssm.exe")
            {
                Write-Output "NSSM is already installed"
            }
            else
            {
                Get-Nsmm -Destination "$($env:SystemRoot)\System32" -WorkingDir "$env:temp"
            }

            $dockerData = "$($env:ProgramData)\docker"
            $dockerLog = "$dockerData\daemon.log"

            if (-not (Test-Path $dockerData))
            {
                Write-Output "Creating Docker program data..."
                New-Item -ItemType Directory -Force -Path $dockerData | Out-Null
            }

            $dockerDaemonScript = "$dockerData\runDockerDaemon.cmd"

            $runDockerDaemon | Out-File -FilePath $dockerDaemonScript -Encoding ASCII
                        
            Write-Output "Configuring NSSM for $serviceName service..."
            Start-Process -Wait "nssm" -ArgumentList "install $serviceName $($env:SystemRoot)\System32\cmd.exe /s /c $dockerDaemonScript"
            Start-Process -Wait "nssm" -ArgumentList "set $serviceName DisplayName Docker Daemon"
            Start-Process -Wait "nssm" -ArgumentList "set $serviceName Description The Docker Daemon provides management capabilities of containers for docker clients"
            # Pipe output to daemon.log
            Start-Process -Wait "nssm" -ArgumentList "set $serviceName AppStderr $dockerLog"
            Start-Process -Wait "nssm" -ArgumentList "set $serviceName AppStdout $dockerLog"
            # Allow 15 seconds for graceful shutdown before process is terminated
            Start-Process -Wait "nssm" -ArgumentList "set $serviceName AppStopMethodConsole 15000"
            
            #Should the script prompt for creds for the service in some way?
            Start-Service -Name $serviceName
            
            #
            # Waiting for docker to come to steady state
            #
            Write-Output "Waiting for Docker daemon..."
            $dockerReady = $false
            $startTime = Get-Date

            while (-not $dockerReady)
            {
                try
                {
                    Invoke-RestMethod -Uri http://127.0.0.1:2375/info -Method GET | Out-Null
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

            #
            # Register the base image with Docker
            #
            Write-Output "Tagging new base image..."
            docker tag (docker images -q) "$($baseImage.Name.tolower()):latest"
        }
    }
    
    Remove-Item $global:ErrorFile
    Write-Output "Script complete!"
}$global:AdminPriviledges = $false

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
    
    Write-Output "This script uses a third party tool: NSSM service manager. For more information, see https://nssm.cc/usage"       
    Write-Output "Downloading NSSM..."

    $nssmUri = "http://nssm.cc/release/nssm-2.24.zip"            
    $nssmZip = "$($env:temp)\$(Split-Path $nssmUri -Leaf)"
            
    $tempDirectory = "$($env:temp)\nssm"

    wget -Uri "http://nssm.cc/release/nssm-2.24.zip" -Outfile $nssmZip -UseBasicParsing
    #TODO Check for errors
            
    Write-Output "Extracting NSSM from archive..."
    Expand-Archive -Path $nssmZip -DestinationPath $tempDirectory
    Remove-Item $nssmZip

    Copy-Item -Path "$tempDirectory\nssm-2.24\win64\nssm.exe" -Destination "$Destination"

    Remove-Item $tempDirectory -Recurse
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
$runDockerDaemon = @"

@echo off
set certs=%ProgramData%\docker\certs.d

if exist %ProgramData%\docker (goto :run)
mkdir %ProgramData%\docker

:run
if exist %certs%\server-cert.pem (goto :secure)
 
docker daemon -D -b "$global:SwitchName"
goto :eof
 
:secure
docker daemon -D -b "$global:SwitchName" -H 0.0.0.0:2376 --tlsverify --tlscacert=%certs%\ca.pem --tlscert=%certs%\server-cert.pem --tlskey=%certs%\server-key.pem

"@
try
{
    Install-ContainerHost
}
catch 
{
    Write-Error $_
}
