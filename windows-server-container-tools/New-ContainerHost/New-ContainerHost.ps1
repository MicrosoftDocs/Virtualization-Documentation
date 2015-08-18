
############################################################
# Script assembled with makeps1.js from
# New-ContainerHost-Source.ps1
# ..\common\ContainerHost-Common.ps1
# Unattend-Source.ps1
# New-ContainerHost-Main.ps1
############################################################

<#
    .NOTES
        Copyright (c) Microsoft Corporation.  All rights reserved.
    
    .SYNOPSIS
        Create a VM as a new container host

    .DESCRIPTION
        Collects collateral required to create a container host
        Creates a VM
        Configures the VM as a new container host
        
    .PARAMETER DockerPath
        Path to a private Docker.exe.  Defaults to http://aka.ms/ContainerTools
        
    .PARAMETER Password 
        Password for the built-in Administrator account. 

    .PARAMETER ScriptPath
        Path to a private Install-ContainerHost.ps1.  Defaults to http://aka.ms/SetupContainers

    .PARAMETER SkipDocker
        If passed, skips Docker install
            
    .PARAMETER SwitchName
        Specify a switch to give the container host network connectivity
    
    .PARAMETER UnattendPath
        Path to custom unattend.xml for use in the container host VM.  If not passed, a default 
        unattend.xml will be used that contains a built-in Administrator account

    .PARAMETER VhdPath 
        Path to a private Windows Server image.  Defaults to http://aka.ms/containerhostvhd

    .PARAMETER VmName
        Friendly name for container host VM to be created.  Required.

    .PARAMETER WimPath
        Path to a private .wim file that contains the base package image.  Only required if -VhdPath is also passed

    .EXAMPLE
        .\Install-ContainerHost.ps1 -SkipDocker
                
#>
#Requires -Version 5.0

[CmdletBinding(DefaultParameterSetName="IncludeDocker")]
param(
    [Parameter(ParameterSetName="IncludeDocker")]
    [string]
    [ValidateNotNullOrEmpty()]
    $DockerPath = "http://aka.ms/ContainerTools",

    [Parameter(ParameterSetName="IncludeDocker", Mandatory=$true, Position=1)]
    [Parameter(ParameterSetName="SkipDocker", Mandatory=$true, Position=1)]
    [string]
    $Password = "P@ssw0rd",

    [string]
    [ValidateNotNullOrEmpty()]
    $ScriptPath = "http://aka.ms/SetupContainers",
    
    [Parameter(ParameterSetName="SkipDocker", Mandatory=$true)]
    [switch]
    $SkipDocker,

    [Parameter(ParameterSetName="Staging", Mandatory=$true)]
    [switch]
    $Staging,

    [string]
    $SwitchName,

    [string]
    [ValidateNotNullOrEmpty()]
    $UnattendPath,

    [Parameter(ParameterSetName="IncludeDocker")]
    [Parameter(ParameterSetName="SkipDocker")]
    [Parameter(ParameterSetName="Staging", Mandatory=$true)]
    [string]
    [ValidateNotNullOrEmpty()]
    $VhdPath = "http://aka.ms/containerhostvhd",

    [Parameter(Mandatory=$true, Position=0)]
    [string]
    [ValidateNotNullOrEmpty()]
    $VmName,

    [string]
    [ValidateNotNullOrEmpty()]
    $WimPath = "http://aka.ms/ContainerOsImage"
)

$global:PowerShellDirectMode = $true

$global:imageBrand = "WindowsServer_en-us_TP3_Container_VHD"
$global:imageVersion = "10514.2"

# Get the management service settings
$global:localVhdRoot = "$((Get-VMHost).VirtualHardDiskPath)".TrimEnd("\")
$global:freeSpaceGB = 0

#
# Define a default VHD name if not specified
#
$global:vhdBrandName = "Windows Server Core VHD"
if ($(Split-Path -Leaf $VhdPath) -match ".*\.vhdx?")
{
    $global:localVhdName = $(Split-Path -Leaf $VhdPath)
    $global:DeveloperMode = $true
}
else
{
    $global:localVhdName = "$($global:imageBrand).vhd"
    $global:DeveloperMode = $false
}
$global:localVhdPath = "$global:localVhdRoot\$global:localVhdName"
$global:localVhdVersion = "$global:localVhdRoot\ContainerVHDVersion.$($global:imageVersion).txt"

$global:localWimName = "ContainerBaseImage.wim"
$global:localWimVhdPath = "$global:localVhdRoot\ContainerBaseImage.vhdx"
$global:localWimVhdVersion = "$global:localVhdRoot\ContainerWIMVersion.$($global:imageVersion).txt"


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

    if (Test-Path $SourcePath)
    {
        Copy-Item -Path $SourcePath -Destination $DestinationPath
    }
    elseif (($SourcePath -as [System.URI]).AbsoluteURI -ne $null)
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
        throw "Cannot copy from $SourcePath"
    }
}


function
Cache-HostFiles
{
    if ($(Test-Path $global:localVhdPath) -and
        $(Test-Path $global:localVhdVersion))
    {
        Write-Output "The latest $global:vhdBrandName is already present on this system."
    }
    else  
    {
        if ($global:freeSpaceGB -le 20)
        {
            Write-Warning "You currently have only $global:freeSpaceGB GB of free space available; 20GB is required"
        }
        
        if ($(Test-Path $global:localVhdPath) -and 
            -not (Test-Path $global:localVhdVersion))
        {
            Write-Warning "There is a newer $global:vhdBrandName available."
        }

        if ($global:DeveloperMode)
        {
            Write-Output "Copying VHD from $VhdPath to $global:localVhdPath..."
            Copy-File -SourcePath $VhdPath -DestinationPath $global:localVhdPath
        }
        else
        {
            #
            # Combo VHD is zipped, so we need to unzip and deliver payload
            #
            if (Test-Path $global:localVhdPath)
            {
                Remove-Item $global:localVhdPath
            }

            $localZipPath = "$global:localVhdPath" -replace "\.vhdx?", ".zip"
            Write-Output "Copying VHD archive (6 GB) from $VhdPath to $localZipPath (this may take a few minutes)..."
            Copy-File -SourcePath $VhdPath -DestinationPath $localZipPath
            
            #
            # Expand .zip file, remove .zip file, move .vhd to final location, and remove temporary folder
            #
            Write-Output "Creating working directory..."
            $tempDirectory = New-Item -ItemType Directory -Force -Path "$global:localVhdRoot\$global:imageBrand"
                       
            Write-Output "Expanding archive..."
            Expand-Archive -Path $localZipPath -DestinationPath $tempDirectory
            
            Remove-Item $localZipPath

            Write-Output "Moving VHD to $global:localVhdPath..."
            Move-Item -Path "$tempDirectory\$global:localVhdName" -Destination $global:localVhdPath

            Write-Output "Removing working directory..."
            Remove-Item $tempDirectory -Recurse
        }

        "This file indicates the web version of the base VHD" | Out-File -FilePath $global:localVhdVersion       
    }

    if ($global:DeveloperMode -and ($global:localVhdName -match "\.th2_release\."))
    {
        Copy-File -SourcePath "http://aka.ms/containerzdp" -DestinationPath "$global:localVhdRoot\zdp.cab"
    }
    
    if ($global:DeveloperMode)
    {
        #
        # The combo VHD already contains the WIM.  Only cache if we are NOT using the combo VHD.
        #
        if ($(Test-Path $global:localWimVhdPath) -and
            $(Test-Path $global:localWimVhdVersion))
        {
            Write-Output "Windows Server Core WIM is already present on this system."
        }
        else
        {
            if ($(Test-Path $global:localWimVhdPath) -and 
                -not (Test-Path $global:localWimVhdVersion))
            {
                Write-Warning "Wrong version base WIM inside $global:localWimVhdPath..."
                Remove-Item $global:localWimVhdPath
            }

            Write-Output "Creating specialized Windows Server Core VHDX for the Containers Base Image WIM..."
            $dataVhdx = New-VHD -Path $global:localWimVhdPath -Dynamic -SizeBytes 8GB -BlockSizeBytes 1MB

            $disk = $dataVhdx | Mount-VHD -PassThru
        
            try
            {
                Write-Output "Initializing disk..."
                Initialize-Disk -Number $disk.Number -PartitionStyle MBR

                #
                # Create single partition 
                #
                Write-Output "Creating single partition..."
                $partition = New-Partition -DiskNumber $disk.Number -Size $disk.LargestFreeExtent -MbrType IFS -IsActive
    
                Write-Output "Formatting volume..."
                $volume = Format-Volume -Partition $partition -FileSystem NTFS -Force -Confirm:$false

                $partition | Add-PartitionAccessPath -AssignDriveLetter
                $driveRoot = $(Get-Partition -Volume $volume).AccessPaths[0].substring(0,2)

                Write-Output "Copying WIM into VHD (this may take a few minutes)..."
                Copy-File -SourcePath $WimPath -DestinationPath "$driveRoot\$global:localWimName"

                "This file indicates the web version of the image WIM VHD" | Out-File -FilePath $global:localWimVhdVersion  
            }
            catch 
            {
                throw $_
            }
            finally
            {
                Write-Output "Dismounting VHD..."
                Dismount-VHD -Path $dataVhdx.Path
            }
        }
    }
}


function
Add-Unattend
{
    [CmdletBinding()]
    param(
        [string]
        $DriveLetter
    )

    $unattendFilePath = "$($DriveLetter):\unattend.xml"
    
    if ($UnattendPath -ne "")
    {
        Copy-File -SourcePath $UnattendPath -DestinationPath $unattendFilePath

        $unattendFile = New-Object XML
        $unattendFile.Load($unattendFilePath)

        Write-Output "Writing custom unattend.xml..."
    }
    else
    {
        $unattendFile = $unattendSource.Clone()

        Write-Output "Writing default unattend.xml..."    
    }
    
    if (-not $global:PowerShellDirectMode)
    {
        Write-Output "Configuring Install-ContainerHost.ps1 to run at first launch..."    

        $installCommand = "%SystemDrive%\Install-ContainerHost.ps1 "

        if ($SkipDocker)
        {
            $installCommand += '-SkipDocker '
        }
        elseif ($Staging)
        {
            $installCommand += '-Staging '
        }
        else
        {
            $installCommand += '-DockerPath %SystemRoot%\System32\docker.exe '
        }

        if ($global:DeveloperMode)
        {
            $installCommand += "-WimPath 'D:\$global:localWimName' "
        }

        try
        {            
            [System.Xml.XmlNamespaceManager]$nsmgr = $unattendFile.NameTable

            $nsmgr.AddNamespace('urn', "urn:schemas-microsoft-com:unattend")
            $nsmgr.AddNamespace('wcm', "http://schemas.microsoft.com/WMIConfig/2002/State")

            $firstLogonElement = $unattendFile.CreateElement("FirstLogonCommands", $nsmgr.LookupNamespace("urn"))

            $synchronousCommandElement = $unattendFile.CreateElement("SynchronousCommand", $nsmgr.LookupNamespace("urn"))
            $synchronousCommandElement.SetAttribute("action", $nsmgr.LookupNamespace("wcm"), "add") | Out-Null

            $commandLineElement = $unattendFile.CreateElement("CommandLine", $nsmgr.LookupNamespace("urn"))
            $commandLineElement.InnerText = "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell -NoLogo -NonInteractive -ExecutionPolicy Unrestricted -Command ""& { $installCommand } "" "

            $descriptionElement = $unattendFile.CreateElement("Description", $nsmgr.LookupNamespace("urn"))
            $descriptionElement.InnerText = "Running Containers Host setup script"

            $orderElement = $unattendFile.CreateElement("Order", $nsmgr.LookupNamespace("urn"))
            $orderElement.InnerText = "1"

            $synchronousCommandElement.AppendChild($commandLineElement) | Out-Null
            $synchronousCommandElement.AppendChild($descriptionElement) | Out-Null
            $synchronousCommandElement.AppendChild($orderElement) | Out-Null

            $firstLogonElement.AppendChild($synchronousCommandElement) | Out-Null
            
            $oobeSystemNode = $unattendFile.unattend.settings |? pass -eq "oobeSystem"
            $shellSetupNode = $oobeSystemNode.component |? name -eq "Microsoft-Windows-Shell-Setup"

            $shellSetupNode.AppendChild($firstLogonElement) | Out-Null
        }
        catch 
        {
            Write-Warning "Failed to modify unattend.xml.  Please manually run 'powershell $installCommand' in the VM"
        }
        
    }
    
    $unattendFile.Save($unattendFilePath)
}


function
Edit-BootVhd
{
    [CmdletBinding()]
    param(
        [string]
        $BootVhdPath,

        [bool]
        $IncludeDocker
    )

    #
    # Protect this with a mutex
    #
    $mutex = New-Object System.Threading.Mutex($False, "New-ContainerHost");     
       
    $bootVhd = Get-Vhd $BootVhdPath

    try
    {
        Write-Output "Waiting for boot VHD mount mutex..."
        $mutex.WaitOne() | Out-Null;
        Write-Output "Mutex acquired."
        
        Write-Output "Mounting VHD for offline processing..."
        $disk = $bootVhd | Mount-VHD -PassThru | Get-Disk        
    
        #
        # We can assume there is one partition/volume
        #
        $driveLetter = ($disk | Get-Partition | Get-Volume).DriveLetter
            
        if ($global:PowerShellDirectMode)
        {
            #
            # Enable containers feature.  This saves a reboot
            #
            Write-Output "Enabling containers feature on drive $driveLetter..."
            Enable-WindowsOptionalFeature -FeatureName Containers -Path "$($driveLetter):"  | Out-Null
        }
        else
        {
            # Windows 8.1 DISM cannot operate on TP3 guests.  
        }

        if ($IncludeDocker)
        {
            #
            # Copy docker
            #
            Write-Output "Copying Docker into VHD..."
            Copy-File -SourcePath $DockerPath -DestinationPath "$($driveLetter):\Windows\System32\docker.exe"

            Write-Output "Copying nssm into VHD..."
            Get-Nsmm -Destination "$($driveLetter):\Windows\System32"
        }

        #
        # Add unattend
        #
        Add-Unattend $driveLetter

        #
        # Add Install-ContainerHost.ps1
        #
        Write-Output "Copying Install-ContainerHost.ps1 into VHD..."
        Copy-File -SourcePath $ScriptPath -DestinationPath "$($driveLetter):\Install-ContainerHost.ps1"

        #
        # Below allows servicing fixes
        #
        if ($global:DeveloperMode -and ($global:localVhdName -match "\.th2_release\."))
        {
            Write-Output "Applying ZDP..."
            Add-WindowsPackage -PackagePath "$($global:localVhdRoot)\zdp.cab" -Path "$($driveLetter):"  | Out-Null
            #Write-Output "Copying ZDP into VHD..."
            #Copy-File -SourcePath "$global:localVhdRoot\zdp.cab" "$($driveLetter):\zdp.cab"
        }
    }
    catch 
    {
        throw $_
    }
    finally
    {
        Write-Output "Dismounting VHD..."
        Dismount-VHD -Path $bootVhd.Path    

        $mutex.ReleaseMutex()
    }
}


function 
New-ContainerHost()
{
    if ((-not $global:PowerShellDirectMode) -and $global:DeveloperMode)
    {
        throw "This script cannot be used in developer mode on Windows 8.1"
    }

    Write-Output "Using VHD path $global:localVhdRoot"
    try
    {
        $global:freeSpaceGB = [float]((Get-Volume -DriveLetter $global:localVhdRoot[0]).SizeRemaining / 1GB)
    }
    catch
    {
        Write-Warning "Cannot detect volume free space at $global:localVhdRoot"
    }

    #
    # Get prerequisites
    #
    Cache-HostFiles

    if ($(Get-VM $VmName -ea SilentlyContinue) -ne $null)
    {
        throw "VM name $VmName already exists on this host"
    }

    #
    # Prepare VHDs
    # 
    Write-Output "Creating VHD files for VM $VmName..."

    if ($global:DeveloperMode)
    {
        $wimVhdPath = "$global:localVhdRoot\$VmName-WIM.vhdx"    
        if (Test-Path $wimVhdPath)
        {
            Remove-Item $wimVhdPath
        }
        $wimVhd = New-VHD -Path "$wimVhdPath" -ParentPath $global:localWimVhdPath -Differencing -BlockSizeBytes 1MB
    }
                
    if ($global:freeSpaceGB -le 10)
    {
        Write-Warning "You currently have only $global:freeSpaceGB GB of free space available at $global:localVhdRoot)"
    }

    $bootVhdPath = "$global:localVhdRoot\$VmName.vhd"
    if (Test-Path $bootVhdPath)
    {
        Remove-Item $bootVhdPath
    }
    $bootVhd = New-VHD -Path "$bootVhdPath" -ParentPath $global:localVhdPath -Differencing
    
    Edit-BootVhd -BootVhdPath $bootVhdPath -IncludeDocker $($($PSCmdlet.ParameterSetName) -eq "IncludeDocker")
    
    #
    # Create VM
    #
    Write-Output "Creating VM $VmName..."

    $vm = New-VM -Name $VmName -VHDPath $bootVhd.Path -Generation 1

    Write-Output "Configuring VM..."
    $vm | Get-VMDvdDrive | Remove-VMDvdDrive
    $vm | Set-VM -DynamicMemory | Out-Null
    
    if ($SwitchName -ne "")
    {
        $vm | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "$SwitchName"
    }

    if ($global:DeveloperMode)
    {
        #
        # Add WIM VHD
        #
        $wimHardDiskDrive = $vm | Add-VMHardDiskDrive -Path $wimVhd.Path -ControllerType SCSI
    }

    Write-Output "Starting VM $($vm.Name)..."
    $vm | Start-VM | Out-Null

    Write-Output "Waiting for VM $($vm.Name) to boot..."
    do 
    {
        Start-Sleep -sec 1
    } 
    until (($vm | Get-VMIntegrationService |? Id -match "84EAAE65-2F2E-45F5-9BB5-0E857DC8EB47").PrimaryStatusDescription -eq "OK")

    Write-Output "Heartbeat IC connected."

    if ($global:PowerShellDirectMode)
    {
        $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PsCredential("Administrator", $securePassword)  
        
        $psReady = $false

        Write-Output "Waiting for specialization to complete (this may take a few minutes)..."
        $startTime = Get-Date

        do 
        {
            $timeElapsed = $(Get-Date) - $startTime

            if ($($timeElapsed).TotalMinutes -ge 10)
            {
                throw "Could not connect to PS Direct after 10 minutes"
            } 

            Start-Sleep -sec 1
            $psReady = Invoke-Command -VMName $($vm.Name) -Credential $credential -ScriptBlock { $True } -ErrorAction SilentlyContinue
        } 
        until ($psReady)

        Write-Output "PowerShell Direct connected."
    
        $guestScriptBlock = 
        {
            [CmdletBinding()]
            param(
                [Parameter(Position=0)]
                [string]
                $WimName,

                [Parameter(Position=1)]
                [string]
                $ParameterSetName
                )

            Write-Output "Onlining disks..."
            Get-Disk | ? IsOffline | Set-Disk -IsOffline:$false

            Write-Output "Completing container install..."
            $installCommand = "$($env:SystemDrive)\Install-ContainerHost.ps1 "

            if ($ParameterSetName -eq "SkipDocker")
            {
                $installCommand += "-SkipDocker "
            }
            elseif ($ParameterSetName -eq "Staging")
            {
                $installCommand += "-Staging "
            }
            else
            {
                $installCommand += "-DockerPath ""$($env:SystemRoot)\System32\docker.exe"" "
            }

            if ($WimName -ne "")
            {
                $installCommand += "-WimPath ""D:\$WimName"" "
            }

            #
            # This is required so that Install-ContainerHost.err goes in the right place
            #
            $pwd = "$($env:SystemDrive)\"
                
            $installCommand += "*>&1 | Tee-Object -FilePath ""$($env:SystemDrive)\Install-ContainerHost.log"" -Append"

            Invoke-Expression $installCommand
        }
    
        Write-Output "Executing Install-ContainerHost.ps1 inside the VM..."
        $wimName = ""
        if ($global:DeveloperMode)
        {
            $wimName = $global:localWimName
        }
        Invoke-Command -VMName $($vm.Name) -Credential $credential -ScriptBlock $guestScriptBlock -ArgumentList $wimName,$($PSCmdlet.ParameterSetName)
    
        $scriptFailed = Invoke-Command -VMName $($vm.Name) -Credential $credential -ScriptBlock { Test-Path "$($env:SystemDrive)\Install-ContainerHost.err" }
    
        if ($scriptFailed)
        {
            throw "Install-ContainerHost.ps1 failed in the VM"
        }

        #
        # Cleanup
        #
        if ($global:DeveloperMode)
        {
            Write-Output "Cleaning up temporary WIM VHD"
            $vm | Get-VMHardDiskDrive |? Path -eq $wimVhd.Path | Remove-VMHardDiskDrive 
            Remove-Item $wimVhd.Path
        }
    
        Write-Output "VM $($vm.Name) is ready for use as a container host."
        Write-Output "This VM is not connected to the network. To connect it, run the following:"  
        Write-Output "  Get-VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -Switchname <switchname>"  
    }
    else
    {
        Write-Output "VM $($vm.Name) will be ready to use as a container host when Install-ContainerHost.ps1 completes execution inside the VM."
    }
    
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
$unattendSource = [xml]@"
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <servicing></servicing>
    <settings pass="generalize">
        <component name="Microsoft-Windows-PnpSysprep" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <PersistAllDeviceInstalls>true</PersistAllDeviceInstalls>
            <DoNotCleanUpNonPresentDevices>true</DoNotCleanUpNonPresentDevices>
        </component>
        <component name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <SkipRearm>1</SkipRearm>
        </component>
    </settings>"
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <AutoLogon>
               <Password>
                  <Value>$Password</Value>
                  <PlainText>true</PlainText>
               </Password>
               <Enabled>true</Enabled>
               <LogonCount>999</LogonCount>
               <Username>Administrator</Username>
            </AutoLogon>
            <ComputerName>*</ComputerName>
        </component>
        <component name="Microsoft-Windows-TerminalServices-LocalSessionManager" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
             <fDenyTSConnections>false</fDenyTSConnections> 
         </component> 
         <component name="Microsoft-Windows-TerminalServices-RDP-WinStationExtensions" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
             <UserAuthentication>0</UserAuthentication> 
         </component> 
         <component name="Networking-MPSSVC-Svc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
             <FirewallGroups> 
                 <FirewallGroup wcm:action="add" wcm:keyValue="RemoteDesktop"> 
                     <Active>true</Active> 
                     <Profile>all</Profile> 
                     <Group>@FirewallAPI.dll,-28752</Group> 
                 </FirewallGroup> 
             </FirewallGroups> 
         </component> 
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <NetworkLocation>Work</NetworkLocation>
                <ProtectYourPC>1</ProtectYourPC>
            </OOBE>
            <UserAccounts>
                <AdministratorPassword>
                    <Value>$Password</Value>
                    <PlainText>True</PlainText>
                </AdministratorPassword>
            </UserAccounts>
        </component>
        <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InputLocale>en-us</InputLocale>
            <SystemLocale>en-us</SystemLocale>
            <UILanguage>en-us</UILanguage>
            <UILanguageFallback>en-us</UILanguageFallback>
            <UserLocale>en-us</UserLocale>
        </component>
    </settings>
</unattend>
"@
$global:MinimumPowerShellBuild = 10240
$global:MinimumSupportedBuild = 9600


function 
Approve-Eula
{   
    $choiceList = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]

    $choiceList.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList "&No"))
    $choiceList.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList "&Yes"))
    
    $eulaText = @"
Before installing and using the Windows Server Technical Preview 3 with Containers virtual machine you must: 
    1.	Review the license terms by navigating to this link: http://aka.ms/WindowsServerTP3ContainerVHDEula
    2.	Print and retain a copy of the license terms for your records.
By downloading and using the Windows Server Technical Preview 3 with Containers virtual machine you agree to such license terms. Please confirm you have accepted and agree to the license terms.
"@

    return [boolean]$Host.ui.PromptForChoice($null, $eulaText, $choiceList, 0) 
    
}  


function 
Test-Version()
{
    $os = Get-WmiObject -Class Win32_OperatingSystem

    if ([int]($os.BuildNumber) -lt $global:MinimumSupportedBuild)
    {
        throw "This script is not supported.  Upgrade to build $global:MinimumSupportedBuild or higher."
    }
    
    if ([int]($os.BuildNumber) -lt $global:MinimumPowerShellBuild)
    {
        Write-Warning "PowerShell Direct is not supported on this version of Windows."
        $global:PowerShellDirectMode = $false
    }

    if (-not (Get-Module Hyper-V))
    {
        throw "Hyper-V must be enabled on this machine."
    }
}


try
{
    Test-Version
    
    Test-Admin
    
    if (-not $(Approve-Eula))
    {
        throw "The EULA must be accepted to continue."
    }
    
    New-ContainerHost
}
catch 
{
    Write-Error $_
}
