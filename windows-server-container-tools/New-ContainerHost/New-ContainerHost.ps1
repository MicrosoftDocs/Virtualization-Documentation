
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
        Path to a private Docker.exe.  Defaults to https://aka.ms/tp5/docker

    .PARAMETER DockerDPath
        Path to a private DockerD.exe.  Defaults to https://aka.ms/tp5/dockerd

    .PARAMETER Password 
        Password for the built-in Administrator account. 

    .PARAMETER HyperV 
        If passed, prepare the machine for Hyper-V containers

    .PARAMETER ScriptPath
        Path to a private Install-ContainerHost.ps1.  Defaults to https://aka.ms/tp5/Install-ContainerHost
            
    .PARAMETER SwitchName
        Specify a switch to give the container host network connectivity
    
    .PARAMETER UnattendPath
        Path to custom unattend.xml for use in the container host VM.  If not passed, a default 
        unattend.xml will be used that contains a built-in Administrator account

    .PARAMETER VhdPath 
        Path to a private Windows Server image. 

    .PARAMETER VmName
        Friendly name for container host VM to be created.  Required.

    .PARAMETER WimPath
        Path to a private .wim file that contains the base package image.  Only required if -VhdPath is also passed

    .PARAMETER WindowsImage
        Image to use for the VM.  One of NanoServer, ServerDatacenter, or ServerDatacenterCore [default]

    .EXAMPLE
        .\Install-ContainerHost.ps1 
                
#>
#Requires -Version 4.0

[CmdletBinding(DefaultParameterSetName="Deploy")]
param(
    [string]
    [ValidateNotNullOrEmpty()]
    $DockerPath = "https://aka.ms/tp5/docker",

    [string]
    [ValidateNotNullOrEmpty()]
    $DockerDPath = "https://aka.ms/tp5/dockerd",

    [switch]
    $HyperV,
    
    [Parameter(ParameterSetName="Deploy")]
    [string]
    [ValidateNotNullOrEmpty()]
    $IsoPath = "https://aka.ms/tp5/serveriso",  

    [Parameter(ParameterSetName="Deploy", Mandatory, Position=1)]
    [Security.SecureString]
    $Password = ("P@ssw0rd" | ConvertTo-SecureString -AsPlainText -Force),
      
    [Parameter(ParameterSetName="Prompt", Mandatory)]
    [switch]
    $Prompt,

    [string]
    [ValidateNotNullOrEmpty()]
    $ScriptPath = "https://aka.ms/tp5/Install-ContainerHost",

    [Parameter(ParameterSetName="Staging", Mandatory)]
    [switch]
    $Staging,

    [string]
    $SwitchName,

    [string]
    [ValidateNotNullOrEmpty()]
    $UnattendPath,

    [string]
    [ValidateNotNullOrEmpty()]
    $VhdPath,

    [Parameter(ParameterSetName="Deploy", Mandatory, Position=0)]
    [Parameter(ParameterSetName="Staging", Mandatory, Position=0)]
    [string]
    [ValidateNotNullOrEmpty()]
    $VmName,

    [string]
    [ValidateNotNullOrEmpty()]
    $WimPath,
         
    [string]
    [ValidateSet("NanoServer", "ServerDatacenter", "ServerDatacenterCore")]
    $WindowsImage = "ServerDatacenterCore"
)

if ($Prompt)
{
    if ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V).State -ne "Enabled")
    {
        throw "Hyper-V must be enabled to continue"
    }
    
    $VmName = Read-Host 'Please specify a name for your VM'

    #
    # Do we require nesting?
    #
    $nestedChoiceList = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]

    $nestedChoiceList.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList "&No"))
    $nestedChoiceList.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList "&Yes"))
    
    $HyperV = [boolean]$Host.ui.PromptForChoice($null, "Would you like to enable Hyper-V containers?", $nestedChoiceList, 0)    
        
    #
    # Which image?
    #
    $imageChoiceList = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]

    $imageChoiceList.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList "&NanoServer"))
    $imageChoiceList.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList "&ServerDatacenter"))
    $imageChoiceList.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList "ServerDatacenter&Core"))

    $imageIndex = $Host.ui.PromptForChoice($null, "Select your container host image", $imageChoiceList, 2)

    switch ($imageIndex)
    {
        0 {$WindowsImage = "NanoServer"}
        1 {$WindowsImage = "ServerDatacenter"}
        2 {$WindowsImage = "ServerDatacenterCore"}
    }
    
    #
    # Administrator password?
    #
    $Password = Read-Host 'Please specify Administrator password' -AsSecureString
    
    $global:ParameterSet = "Deploy"
}
else
{
    $global:ParameterSet = $PSCmdlet.ParameterSetName
}

$global:WimSaveMode = $true
$global:PowerShellDirectMode = $true

$global:VmGeneration = 2

#
# Image information
#
if ($HyperV -or ($WindowsImage -eq "NanoServer"))
{
    $global:imageName = "NanoServer"
}
else
{
    $global:imageName = "WindowsServerCore"
}

$global:imageVersion = "14300.1000"

#
# Branding strings
#
$global:brand = $WindowsImage
$global:imageBrand = "$($global:brand)_en-us_TP5_Container"
$global:isoBrandName = "$global:brand ISO"
$global:vhdBrandName = "$global:brand VHD"

#
# Get the management service settings
#
$global:localVhdRoot = "$((Get-VMHost).VirtualHardDiskPath)".TrimEnd("\")
$global:freeSpaceGB = 0

#
# Define a default VHD name if not specified
#
if ($VhdPath -and ($(Split-Path -Leaf $VhdPath) -match ".*\.vhdx?"))
{
    $global:localVhdName = $(Split-Path -Leaf $VhdPath)

    #
    # Assume this is an official Windows build VHD/X.  We parse the build number and QFE from the filename
    #
    if ($global:localVhdName -match "(\d{5})\.(\d{1,5}).(.*\.\d{6}-\d{4})_.*\.vhdx?")
    {
        $global:imageVersion = "$($Matches[1]).$($Matches[2])"

        if (-not $WimPath)
        {
            #
            # Register the private 
            #
            .\Register-TestContainerHost.ps1 -BuildName "$($Matches[1]).$($Matches[2]).$($Matches[3])"
        }
    }
}
else
{
    $global:localVhdName = "$($global:imageBrand).vhdx"
}

$global:localIsoName = "WindowsServerTP5.iso"
$global:localIsoPath = "$global:localVhdRoot\$global:localIsoName"
$global:localIsoVersion = "$global:localVhdRoot\ContainerISOVersion.$($global:imageVersion).txt"

$global:localVhdPath = "$global:localVhdRoot\$global:localVhdName"
$global:localVhdVersion = "$global:localVhdRoot\ContainerVHDVersion.$($global:imageVersion).txt"

$global:localWimName = "$global:imageName.wim"
$global:localWimVhdPath = "$global:localVhdRoot\$($global:imageName)-WIM-$($global:imageVersion).vhdx"
$global:localWimVhdVersion = "$global:localVhdRoot\$($global:imageName)Version.$($global:imageVersion).txt"


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

        if ($VhdPath)
        {
            Write-Output "Copying $global:vhdBrandName from $VhdPath to $global:localVhdPath..."
            Copy-File -SourcePath $VhdPath -DestinationPath $global:localVhdPath
        }
        else
        {
            if (Test-Path $global:localIsoPath)
            {
                Write-Output "The latest $global:isoBrandName is already present on this system."
            }
            else
            {
                Write-Output "Copying $global:isoBrandName from $IsoPath to $global:localIsoPath (this may take several minutes)..."
                Copy-File -SourcePath $IsoPath -DestinationPath $global:localIsoPath
            }

            try
            {
                $convertScript = $(Join-Path $global:localVhdRoot "Convert-WindowsImage.ps1")

                Write-Verbose "Copying Convert-WindowsImage..."
                Copy-File -SourcePath 'https://aka.ms/tp5/Convert-WindowsImage' -DestinationPath $convertScript

                #
                # Dot-source until this is a module
                #
                . $convertScript

                Write-Output "Mounting ISO..."
                $openIso = Mount-DiskImage $global:localIsoPath
                
                # Refresh the DiskImage object so we can get the real information about it.  I assume this is a bug.
                $openIso = Get-DiskImage -ImagePath $global:localIsoPath
                $driveLetter = ($openIso | Get-Volume).DriveLetter

                Write-Output "Converting WIM to VHD..."
                if ($WindowsImage -eq "NanoServer")
                {
                    #
                    # Workaround an issue in the RTM version of Convert-WindowsImage.ps1
                    #
                    if (Get-Module Hyper-V)
                    {
                        Add-WindowsImageTypes
                    }

                    Import-Module "$($driveLetter):\NanoServer\NanoServerImageGenerator.psm1"
                                        
                    if ($Staging)
                    {
                        New-NanoServerImage -ImageFormat "vhdx" -DeploymentType Guest -Edition Standard -MediaPath "$($driveLetter):\" -TargetPath $global:localVhdPath -Containers -AdministratorPassword $Password
                    }
                    else
                    {
                        New-NanoServerImage -ImageFormat "vhdx" -DeploymentType Guest -Edition Standard -MediaPath "$($driveLetter):\" -TargetPath $global:localVhdPath -Compute -Containers -AdministratorPassword $Password
                    }
                }
                else
                {
                    Convert-WindowsImage -DiskLayout UEFI -SourcePath "$($driveLetter):\sources\install.wim" -Edition $WindowsImage -VhdPath $global:localVhdPath
                }
            }
            catch 
            {
                throw $_
            }
            finally
            {
                Write-Output "Dismounting ISO..."
                Dismount-DiskImage $global:localIsoPath
            }
        }

        "This file indicates the web version of the base VHD" | Out-File -FilePath $global:localVhdVersion       
    }
    
    if ($global:WimSaveMode -or $WimPath)
    {
        $global:WimSaveMode = $true

        #
        # The combo VHD already contains the WIM.  Only cache if we are NOT using the combo VHD.
        #
        if ($(Test-Path $global:localWimVhdPath) -and
            $(Test-Path $global:localWimVhdVersion))
        {
            Write-Output "$global:brand Container OS Image (WIM) is already present on this system."
        }
        else
        {
            if ($(Test-Path $global:localWimVhdPath) -and 
                -not (Test-Path $global:localWimVhdVersion))
            {
                Write-Warning "Wrong version of Container OS Image (WIM) inside $global:localWimVhdPath..."
                Remove-Item $global:localWimVhdPath
            }

            Write-Output "Creating temporary VHDX for the Containers OS Image WIM..."
            $dataVhdx = New-VHD -Path $global:localWimVhdPath -Dynamic -SizeBytes 8GB -BlockSizeBytes 1MB

            $disk = $dataVhdx | Mount-VHD -PassThru
            
            try
            {
                Write-Output "Initializing disk..."
                Initialize-Disk -Number $disk.Number -PartitionStyle MBR

                #
                # Create single partition 
                #
                Write-Verbose "Creating single partition..."
                $partition = New-Partition -DiskNumber $disk.Number -Size $disk.LargestFreeExtent -MbrType IFS -IsActive
    
                Write-Verbose "Formatting volume..."
                $volume = Format-Volume -Partition $partition -FileSystem NTFS -Force -Confirm:$false 

                $partition | Add-PartitionAccessPath -AssignDriveLetter

                $driveLetter = (Get-Volume |? UniqueId -eq $volume.UniqueId).DriveLetter

                if ($WimPath)
                {
                    Write-Output "Saving private Container OS image ($global:imageName) (this may take a few minutes)..."
                    Copy-File -SourcePath $WimPath -DestinationPath "$($driveLetter):\$global:localWimName"  
                }
                else
                {
                    Test-ContainerImageProvider

                    $imageVersion = "10.0.$global:imageVersion"
                    Write-Output "Saving Container OS image ($global:imageName -MinimumVersion $imageVersion) from OneGet to $($driveLetter): (this may take a few minutes)..."
                    
                    #
                    # TODO: should be error action stop by default
                    #
                    Save-ContainerImage -Name $global:imageName -MinimumVersion $imageVersion -Path $env:TEMP -ErrorAction Stop | Out-Null

                    #
                    # TODO: don't use env:temp once OneGet supports mounted drives
                    #
                    Move-Item -Path (Resolve-Path "$env:TEMP\*-*.wim") -Destination "$($driveLetter):\$global:localWimName"  
                }

                if (-not (Test-Path "$($driveLetter):\$global:localWimName"))
                {
                    throw "Container image not saved successfully"
                }

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
        $credential = New-Object System.Management.Automation.PsCredential("Administrator", $Password)  

        $unattendFile = (Get-Unattend -Password $credential.GetNetworkCredential().Password).Clone()

        Write-Output "Writing default unattend.xml..."    
    }
    
    if (-not $global:PowerShellDirectMode)
    {
        Write-Output "Configuring Install-ContainerHost.ps1 to run at first launch..."    

        $installCommand = "%SystemDrive%\Install-ContainerHost.ps1 "

        if ($Staging)
        {
            $installCommand += '-Staging '
        }
        else
        {
            $installCommand += '-DockerPath %SystemRoot%\System32\docker.exe -DockerDPath %SystemRoot%\System32\dockerd.exe'
        }

        if ($global:WimSaveMode)
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
        $BootVhdPath
    )

    #
    # Protect this with a mutex
    #
    $mutex = New-Object System.Threading.Mutex($False, $global:imageName);     
       
    $bootVhd = Get-Vhd $BootVhdPath

    try
    {
        Write-Output "VHD mount must be synchronized with other running instances of this script.  Waiting for exclusive access..."
        $mutex.WaitOne() | Out-Null;
        Write-Verbose "Mutex acquired."
        
        Write-Output "Mounting $global:vhdBrandName for offline processing..."
        $disk = $bootVhd | Mount-VHD -PassThru | Get-Disk        
    
        if ($disk.PartitionStyle -eq "GPT")
        {            
            #
            # Generation 2: we assume the only partition with a drive letter is the Windows partition
            #
            $driveLetter = ($disk | Get-Partition | Where-Object DriveLetter).DriveLetter
        }
        else
        {
            #
            # Generation 1: we will assume there is one partition/volume
            #
            $global:VmGeneration = 1
            $driveLetter = ($disk | Get-Partition | Get-Volume).DriveLetter
        }

        if ($WindowsImage -eq "NanoServer")
        {
            if ((Test-Path $global:localIsoPath) -and $Staging)
            {
                #
                # Add packages
                #
                try
                {
                    Write-Output "Mounting ISO..."
                    $openIso = Mount-DiskImage $global:localIsoPath
                
                    # Refresh the DiskImage object so we can get the real information about it.  I assume this is a bug.
                    $openIso = Get-DiskImage -ImagePath $global:localIsoPath
                    $isoDriveLetter = ($openIso | Get-Volume).DriveLetter

                    #
                    # Copy all packages into the image to make it easier to add them later (at the cost of disk space)
                    #
                    Write-Output "Copying Nano packages into image..."
                    Copy-Item "$($isoDriveLetter):\NanoServer\Packages" "$($driveLetter):\Packages" -Recurse
                }
                catch 
                {
                    throw $_
                }
                finally
                {
                    Write-Output "Dismounting ISO..."
                    Dismount-DiskImage $global:localIsoPath
                }
            }
        }
        else
        {
            if ($global:PowerShellDirectMode)
            {
                #
                # Enable containers feature.  This saves a reboot
                #
                Write-Output "Enabling Containers feature on drive $driveLetter..."
                Enable-WindowsOptionalFeature -FeatureName Containers -Path "$($driveLetter):"  | Out-Null

                if ($HyperV)
                {
                    Write-Output "Enabling Hyper-V feature on drive $driveLetter..."
                    Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Path "$($driveLetter):"  | Out-Null
                }
            }
            else
            {
                # Windows 8.1 DISM cannot operate on Windows 10 guests.  
            }
        }

        
        #
        # Copy docker
        #
        Write-Output "Copying Docker into $global:vhdBrandName..."
        Copy-File -SourcePath $DockerPath -DestinationPath "$($driveLetter):\Windows\System32\docker.exe"
        
        try
        {
            Write-Output "Copying Docker daemon into $global:vhdBrandName..."
            Copy-File -SourcePath $DockerDPath -DestinationPath "$($driveLetter):\Windows\System32\dockerd.exe"
        }
        catch 
        {
            Write-Warning "DockerD not yet present."
        }

        if ($WindowsImage -ne "NanoServer")
        {
            Write-Output "Copying NSSM into $global:vhdBrandName..."
            Get-Nsmm -Destination "$($driveLetter):\Windows\System32"
        }

        #
        # Add unattend
        #
        Add-Unattend $driveLetter

        #
        # Add Install-ContainerHost.ps1
        #
        Write-Output "Copying Install-ContainerHost.ps1 into $global:vhdBrandName..."
        Copy-File -SourcePath $ScriptPath -DestinationPath "$($driveLetter):\Install-ContainerHost.ps1"

        #
        # Copy test tools
        #
        if (Test-Path ".\Register-TestContainerHost.ps1")
        {
            Copy-Item ".\Register-TestContainerHost.ps1" "$($driveLetter):\"
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
    # Validate network configuration
    #
    if ($SwitchName -eq "")
    {
        $switches = (Get-VMSwitch |? SwitchType -eq "External")

        if ($switches.Count -gt 0)
        {
            $SwitchName = $switches[0].Name
        }
    }

    if ($SwitchName -ne "")
    {
        Write-Output "Using external switch $SwitchName"
    }
    elseif ($Staging)
    {
        Write-Output "No external virtual switch connectivity; OK for staging mode"
    }
    else
    {
        throw "This script requires an external virtual switch.  Please configure a virtual switch (New-VMSwitch) and re-run."
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

    if ($global:WimSaveMode)
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

    $global:localVhdPath -match "\.vhdx?" | Out-Null
    
    $bootVhdPath = "$global:localVhdRoot\$($VmName)$($matches[0])"
    if (Test-Path $bootVhdPath)
    {
        Remove-Item $bootVhdPath
    }
    $bootVhd = New-VHD -Path "$bootVhdPath" -ParentPath $global:localVhdPath -Differencing
    
    Edit-BootVhd -BootVhdPath $bootVhdPath 
    
    #
    # Create VM
    #
    Write-Output "Creating VM $VmName..."
    $vm = New-VM -Name $VmName -VHDPath $bootVhd.Path -Generation $global:VmGeneration

    Write-Output "Configuring VM $($vm.Name)..."
    $vm | Set-VMProcessor -Count ([Math]::min((Get-VMHost).LogicalProcessorCount, 64))
    $vm | Get-VMDvdDrive | Remove-VMDvdDrive
    $vm | Set-VM -DynamicMemory | Out-Null
    
    if ($SwitchName -eq "")
    {
        $switches = (Get-VMSwitch |? SwitchType -eq "External")

        if ($switches.Count -gt 0)
        {
            $SwitchName = $switches[0].Name
        }
    }

    if ($SwitchName -ne "")
    {
        Write-Output "Connecting VM to switch $SwitchName"
        $vm | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "$SwitchName"
    }

    if ($HyperV)
    {   
        #
        # Enable nested to support Hyper-V containers
        #
        $vm | Set-VMProcessor -ExposeVirtualizationExtensions $true
         
        #
        # Disable dynamic memory
        #
        $vm | Set-VMMemory -DynamicMemoryEnabled $false
    }

    if ($global:WimSaveMode)
    {
        #
        # Add WIM VHD
        #
        $wimHardDiskDrive = $vm | Add-VMHardDiskDrive -Path $wimVhd.Path -ControllerType SCSI
    }

    if ($Staging -and ($WindowsImage -eq "NanoServer"))
    {
        Write-Output "NanoServer VM is staged..."        
    }
    else
    {
        Write-Output "Starting VM $($vm.Name)..."
        $vm | Start-VM | Out-Null

        Write-Output "Waiting for VM $($vm.Name) to boot..."
        do 
        {
            Start-Sleep -sec 1
        } 
        until (($vm | Get-VMIntegrationService |? Id -match "84EAAE65-2F2E-45F5-9BB5-0E857DC8EB47").PrimaryStatusDescription -eq "OK")

        Write-Output "Connected to VM $($vm.Name) Heartbeat IC."

        if ($global:PowerShellDirectMode)
        {
            $credential = New-Object System.Management.Automation.PsCredential("Administrator", $Password)  
        
            $psReady = $false

            Write-Output "Waiting for specialization to complete (this may take a few minutes)..."
            $startTime = Get-Date

            do 
            {
                $timeElapsed = $(Get-Date) - $startTime

                if ($($timeElapsed).TotalMinutes -ge 30)
                {
                    throw "Could not connect to PS Direct after 30 minutes"
                } 

                Start-Sleep -sec 1
                $psReady = Invoke-Command -VMName $($vm.Name) -Credential $credential -ScriptBlock { $True } -ErrorAction SilentlyContinue
            } 
            until ($psReady)

            Write-Verbose "PowerShell Direct connected."
    
            $guestScriptBlock = 
            {
                [CmdletBinding()]
                param(
                    [Parameter(Position=0)]
                    [string]
                    $WimName,

                    [Parameter(Position=1)]
                    [string]
                    $ParameterSetName,

                    [Parameter(Position=2)]
                    [bool]
                    $HyperV
                    )

                Write-Verbose "Onlining disks..."
                Get-Disk | ? IsOffline | Set-Disk -IsOffline:$false

                Write-Output "Completing container install..."
                $installCommand = "$($env:SystemDrive)\Install-ContainerHost.ps1 -PSDirect "

                if ($ParameterSetName -eq "Staging")
                {
                    $installCommand += "-Staging "
                }
                else
                {
                    $installCommand += "-DockerPath ""$($env:SystemRoot)\System32\docker.exe"" -DockerDPath ""$($env:SystemRoot)\System32\dockerd.exe"""
                }

                if ($WimName -ne "")
                {
                    $installCommand += "-WimPath ""D:\$WimName"" "
                }

                if ($HyperV)
                {
                    $installCommand += "-HyperV "
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
            if ($global:WimSaveMode)
            {
                $wimName = $global:localWimName
            }
            Invoke-Command -VMName $($vm.Name) -Credential $credential -ScriptBlock $guestScriptBlock -ArgumentList $wimName,$global:ParameterSet,$HyperV
    
            $scriptFailed = Invoke-Command -VMName $($vm.Name) -Credential $credential -ScriptBlock { Test-Path "$($env:SystemDrive)\Install-ContainerHost.err" }
    
            if ($scriptFailed)
            {
                throw "Install-ContainerHost.ps1 failed in the VM"
            }

            #
            # Cleanup
            #
            if ($global:WimSaveMode)
            {
                Write-Output "Cleaning up temporary WIM VHD"
                $vm | Get-VMHardDiskDrive |? Path -eq $wimVhd.Path | Remove-VMHardDiskDrive 
                Remove-Item $wimVhd.Path
            }
    
            Write-Output "VM $($vm.Name) is ready for use as a container host."
        }
        else
        {
            Write-Output "VM $($vm.Name) will be ready to use as a container host when Install-ContainerHost.ps1 completes execution inside the VM."
        }
    }

    Write-Output "See https://msdn.microsoft.com/virtualization/windowscontainers/containers_welcome for more information about using Containers."
    Write-Output "The source code for these installation scripts is available here: https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-server-container-tools"
}
$global:AdminPriviledges = $false
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

    $dockerData = "$($env:ProgramData)\docker"
    $dockerLog = "$dockerData\daemon.log"

    if (-not (Test-Path $dockerData))
    {
        Write-Output "Creating Docker program data..."
        New-Item -ItemType Directory -Force -Path $dockerData | Out-Null
    }

    $dockerDaemonScript = "$dockerData\runDockerDaemon.cmd"

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

        Write-Output "Launching daemon..."
        Start-ScheduledTask -TaskName $global:DockerServiceName
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

        Start-Service -Name $global:DockerServiceName
    }

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
        Get-Process $global:DockerServiceName | Stop-Process -Force
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

function
Get-Unattend
{
    [CmdletBinding()]
    param(
        [string]
        $Password
    )

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
            <ProductKey>2KNJJ-33Y9H-2GXGX-KMQWH-G6H67</ProductKey>
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

    return $unattendSource
}

$global:MinimumWimSaveBuild = 10586
$global:MinimumPowerShellBuild = 10240
$global:MinimumSupportedBuild = 9600


function 
Approve-Eula
{   
    $choiceList = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]

    $choiceList.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList "&No"))
    $choiceList.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList "&Yes"))
    
    $eulaText = @"
Before installing and using the Windows Server Technical Preview 5 with Containers virtual machine you must: 
    1.	Review the license terms by navigating to this link: https://aka.ms/tp5/containerseula
    2.	Print and retain a copy of the license terms for your records.
By downloading and using the Windows Server Technical Preview 5 with Containers virtual machine you agree to such license terms. Please confirm you have accepted and agree to the license terms.
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
    
    if ([int]($os.BuildNumber) -lt $global:MinimumWimSaveBuild)
    {
        Write-Warning "Save-ContainerImage is not supported on this version of Windows."
        $global:WimSaveMode = $false
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
        throw "Read and accept the EULA to continue."
    }
    
    New-ContainerHost
}
catch 
{
    Write-Error $_
}
