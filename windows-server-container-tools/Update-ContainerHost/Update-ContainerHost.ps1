
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
        Updates a container host with latest docker.exe

    .DESCRIPTION
        Collects collateral required to create a container host
        Creates a VM
        Configures the VM as a new container host
        
    .PARAMETER DockerPath
        Path to a private Docker.exe.  Defaults to http://aka.ms/ContainerTools

    .EXAMPLE
        .\Update-ContainerHost.ps1 -SkipDocker
                
#>
#Requires -Version 5.0

[CmdletBinding(DefaultParameterSetName="IncludeDocker")]
param(
    [Parameter(ParameterSetName="IncludeDocker")]
    [string]
    [ValidateNotNullOrEmpty()]
    $DockerPath = "http://aka.ms/ContainerTools"
)


function 
Update-ContainerHost()
{
    Test-Admin

    $serviceName = "Docker"
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

    if ($service -eq $null)
    {
        throw "Docker service is not running"
    }

    #
    # Stop service
    #
    Write-Output "Stopping docker..."
    Stop-Service -Name $serviceName

    #
    # Update service
    #
    Write-Output "Updating docker..."

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

    #
    # Start service
    #
    Write-Output "Starting docker..."
    Start-Service -Name $serviceName
}
$global:AdminPriviledges = $false

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
        
    Write-Output "Downloading nsmm..."

    $nssmUri = "http://nssm.cc/release/nssm-2.24.zip"            
    $nssmZip = "$($env:temp)\$(Split-Path $nssmUri -Leaf)"
            
    $tempDirectory = "$($env:temp)\nsmm"

    wget -Uri "http://nssm.cc/release/nssm-2.24.zip" -Outfile $nssmZip -UseBasicParsing
    #TODO Check for errors
            
    Write-Output "Extracting nssm from archive..."
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
try
{    
    Update-ContainerHost
}
catch 
{
    Write-Error $_
}
