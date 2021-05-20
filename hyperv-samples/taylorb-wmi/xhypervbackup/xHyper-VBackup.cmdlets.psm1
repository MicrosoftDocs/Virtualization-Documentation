# Original Author: Taylor Brown
# Updated Author: Shalin Mehta
# The following functions provide an example for how one could create a backup and a reference point of a VM in Hyper-V

<#
.SYNOPSIS
    Helper function that processes a CIMMethodResult/Msvm_ConcreteJob.

.DESCRIPTION
    Helper function that processes a CIMMethodResult/Msvm_ConcreteJob.

.PARAMETER WmiClass
    Supplies the WMI class object from where the method is being called.

.PARAMETER MethodName
    Supplies the method name that the job called.

.INPUTS
    Input a CIMMethodResult object through the pipeline, or any object with
    a ReturnValue property and optionally a Job property that is an Msvm_ConcreteJob.

.OUTPUTS
    Returns the input object on success; throws on error.

.EXAMPLE
    $job | Trace-CimMethodExecution -WmiClass $VMMS -MethodName ExportSystemDefinition
        Processes a job for the given class and method, shows progress until it reaches completion.
#>
filter Trace-CimMethodExecution {
    param (
        [Alias("WmiClass")]
        [Microsoft.Management.Infrastructure.CimInstance]$CimInstance = $null,
        [string] $MethodName = $null
    )

    $errorCode = 0
    $returnObject = $_
    $job = $null
    $shouldProcess = $true

    if ($_.CimSystemProperties.ClassName -eq "Msvm_ConcreteJob") {
        $job = $_
    }
    elseif ((Get-Member -InputObject $_ -name "ReturnValue" -MemberType Properties)) {
        if (($_.ReturnValue -ne 0) -and ($_.ReturnValue -ne 4096)) {
            # An error occurred
            $errorCode = $_.ReturnValue
            $shouldProcess = $false
        }
        elseif ($_.ReturnValue -eq 4096) {
            if ((Get-Member -InputObject $_ -name "Job" -MemberType Properties) -and $_.Job) {
                # CIM does not seem to actually populate the non-key fields on a reference, so we need
                # to go get the actual instance of the job object we got.
                $job = ($_.Job | Get-CimInstance)
            }
            else {
                throw "ReturnValue of 4096 with no Job object!"
            }
        }
        else {
            # No job and no error, just exit.
            return $returnObject
        }
    }
    else {
        throw "Pipeline input object is not a job or CIM method result!"
    }

    if ($shouldProcess) {
        $caption = if ($job.Caption) { $job.Caption } else { "Job in progress (no caption available)" }
        $jobStatus = if ($job.JobStatus) { $job.JobState } else { "No job status available" }
        $percentComplete = if ($job.PercentComplete) { $job.PercentComplete } else { 0 }
        while ($job.JobState -eq 4) {
            Write-Progress -Activity $caption -Status ("{0} - {1}%" -f $jobStatus, $percentComplete) -PercentComplete $percentComplete
            Start-Sleep -seconds 1
            $job = $job | Get-CimInstance
        }

        if ($job.JobState -ne 7) {
            if (![string]::IsNullOrEmpty($job.ErrorDescription)) {
                Throw $job.ErrorDescription
            }
            else {
                $errorCode = $job.ErrorCode
            }
        }
        Write-Progress -Activity $caption -Status $jobStatus -PercentComplete 100 -Completed:$true
    }

    if ($errorCode -ne 0) {
        if ($CimInstance -and $MethodName) {
            $cimClass = Get-CimClass -ClassName $CimInstance.CimSystemProperties.ClassName `
                -Namespace $CimInstance.CimSystemProperties.Namespace -ComputerName $CimInstance.CimSystemProperties.ServerName

            $methodQualifierValues = ($cimClass.CimClassMethods[$MethodName].Qualifiers["ValueMap"].Value)
            $indexOfError = [System.Array]::IndexOf($methodQualifierValues, [string]$errorCode)
            if (($indexOfError -ne "-1") -and $methodQualifierValues) {
                Throw "ReturnCode: ", $errorCode, " ErrorMessage: '", $cimClass.CimClassMethods[$MethodName].Qualifiers["Values"].Value[$indexOfError], "' - when calling $MethodName"
            }
            else {
                Throw "ReturnCode: ", $errorCode, " ErrorMessage: 'MessageNotFound' - when calling $MethodName"
            }
        }
        else {
            Throw "ReturnCode: ", $errorCode, "When calling $MethodName - for rich error messages provide classpath and method name."
        }
    }

    return $returnObject
}

<#
.SYNOPSIS
    Get the __PATH property from a CIMInstance object.

.DESCRIPTION
    The Get-CIMInstance cmdlet by default doesn't display the WMI system properties
    like __SERVER. The properties are available in the CimSystemProperties property
    except for __PATH. This function will construct the __PATH property and return it.

.EXAMPLE
    get-ciminstance win32_memorydevice | get-ciminstancepath

    \\SERVER01\root\cimv2:Win32_MemoryDevice.DeviceID="Memory Device 0"
    \\SERVER01\root\cimv2:Win32_MemoryDevice.DeviceID="Memory Device 1"

.INPUTS
    A CIMInstance object

.OUTPUTS
    String representing the path of the input object
#>
function Get-CimInstancePath {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline = $True)]
        [ValidateNotNullorEmpty()]
        [Microsoft.Management.Infrastructure.CimInstance]$CimInstance
    )

    $key = $CimInstance.CimClass.CimClassProperties |
        Where-Object { $_.Qualifiers.Name -contains "key" } |
        Select-Object -ExpandProperty Name

    $path = ('\\{0}\{1}:{2}{3}' -f $CimInstance.CimSystemProperties.ServerName.ToUpper(),
        $CimInstance.CimSystemProperties.Namespace.Replace("/", "\"),
        $CimInstance.CimSystemProperties.ClassName,
        $(if ($key -is [array]) {
                # Need a string with every key in the array, keys separated by commas
                $sep = ""
                $s = [string]"."
                foreach ($k in $key) {
                    $s += "$($sep)$($k)=""$($CimInstance.($k))"""
                    $sep = ","
                }
                $s
            }
            elseif ($key) {
                # just a single key
                ".$($key)=""$($CimInstance.$key)"""
            }
            else {
                #no key
                '=@'
            }).Replace('\', '\\')
    )

    return $path
}

<#
.SYNOPSIS
    Helper function that converts a CIM instancce to an embedded Unicode string.

.DESCRIPTION
    Helper function that converts a CIM instancce to an embedded Unicode string.
    Useful to pass to Hyper-V WMI cmdlets that expect string versions of MSVM
    classes as parameters.

.PARAMETER CimInstance
    Supplies the CIM instance object to stringify.

.INPUTS
    Input a CIM instance object through the pipeline.

.OUTPUTS
    Returns the Unicode string version of the CIM instance.

.EXAMPLE


#>
function ConvertTo-CimEmbeddedString {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [Microsoft.Management.Infrastructure.CimInstance]$CimInstance
    )

    if ($null -eq $CimInstance) {
        return ""
    }

    $cimSerializer = [Microsoft.Management.Infrastructure.Serialization.CimSerializer]::Create()
    $serializedObj = $cimSerializer.Serialize($CimInstance, [Microsoft.Management.Infrastructure.Serialization.InstanceSerializationOptions]::None)

    return [System.Text.Encoding]::Unicode.GetString($serializedObj)
}

function Convert-VmBackupCheckpoint
{
    Param(
      [Parameter(Mandatory=$True)]
      [Microsoft.Management.Infrastructure.CimInstance]$BackupCheckpoint = $null
    )

    # Retrieve an instance of the snapshot management service
    $Msvm_VirtualSystemSnapshotService = Get-CimInstance -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemSnapshotService

    # Convert the snapshot to a reference point, this function returns a job object.
    $job = ($Msvm_VirtualSystemSnapshotService | Invoke-CimMethod -MethodName "ConvertToReferencePoint" -Arguments @{
        AffectedSnapshot = $BackupCheckpoint
    })

    # Wait for the job to complete.
    $job | Trace-CimMethodExecution | Out-Null

    # The new reference point object is related to the job
    # always returns an array in this case there is only one member
    $refPoint = ($job.Job | Get-CimAssociatedInstance -ResultClassName "Msvm_VirtualSystemReferencePoint" | % {$_})

    # Return the reference point object
    return $refPoint
}

function Export-VMBackupCheckpoint
{
    [CmdletBinding(DefaultParametersetname="vmname")]
    Param(
      [Parameter(Mandatory=$True, ParameterSetName="vmname")]
      [string]$VmName = [String]::Empty,
      [Parameter(Mandatory=$True, ParameterSetName="vmid")]
      [string]$VmId = [String]::Empty,

      [Parameter(Mandatory=$True)]
      [string]$DestinationPath = [String]::Empty,

      [Parameter(Mandatory=$True)]
      [Microsoft.Management.Infrastructure.CimInstance]$BackupCheckpoint = $null,

      [Microsoft.Management.Infrastructure.CimInstance]$ReferencePoint = $null,

      [bool]$noWait = $false
    )

    # Retrieve an instance of the virtual machine management service
    $Msvm_VirtualSystemManagementService = Get-CimInstance -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemManagementService

    if ($PsCmdlet.ParameterSetName -eq "vmname"){
        $filter = "ElementName='$vmName'"
    } else {
        $filter = "Name='$VmId'"
    }
    # Retrieve an instance of the virtual machine computer system that will be snapshotted
    $Msvm_ComputerSystem = Get-CimInstance -Namespace root\virtualization\v2 -Class Msvm_ComputerSystem -Filter $filter

    # Retrieve an instance of the Export Setting Data Class (this is used to inform the export operation)
    $Msvm_VirtualSystemExportSettingData = ($Msvm_ComputerSystem | Get-CimAssociatedInstance -ResultClassName "Msvm_VirtualSystemExportSettingData" -Association "Msvm_SystemExportSettingData" | % {$_})

    # Specify the export options
    # CopySnapshotConfiguration
    # 0: ExportAllSnapshots - All snapshots will be exported with the VM.
    # 1: ExportNoSnapshots - No snapshots will be exported with the VM.
    # 2: ExportOneSnapshot - The snapshot identified by the SnapshotVirtualSystem property will be exported with the VM.
    # 3: ExportOneSnapshotUseVmId - The snapshot identified by the SnapshotVirtualSystem property will be exported with the VM. Using the VMs ID.
    $Msvm_VirtualSystemExportSettingData.CopySnapshotConfiguration = 3

    # CopyVmRuntimeInformation
    # Indicates whether the VM runtime information will be copied when the VM is exported. (i.e. saved state)
    $Msvm_VirtualSystemExportSettingData.CopyVmRuntimeInformation = $false

    # CopyVmStorage
    # Indicates whether the VM storage will be copied when the VM is exported. (i.e. VHDs/VHDx files)
    $Msvm_VirtualSystemExportSettingData.CopyVmStorage = $true

    # CreateVmExportSubdirectory
    # Indicates whether a subdirectory with the name of the VM will be created when the VM is exported.
    $Msvm_VirtualSystemExportSettingData.CreateVmExportSubdirectory = $false

    # SnapshotVirtualSystem
    # Path to a Msvm_VirtualSystemSettingData instance that represents the snapshot to be exported with the VM.
    $Msvm_VirtualSystemExportSettingData.SnapshotVirtualSystem = (Get-CimInstancePath -CimInstance $BackupCheckpoint)

    # DifferentialBackupBase
    # Base for differential export. This is either path to a Msvm_VirtualSystemReferencePoint instance that
    # represents the reference point or path to a Msvm_VirtualSystemSettingData instance that
    # represents the snapshot to be used as a base for differential export. If the CopySnapshotConfiguration
    # property is not set to 3(ExportOneSnapshotUseVmId), this property is ignored."
    if ($null -eq $ReferencePoint) {
        $Msvm_VirtualSystemExportSettingData.DifferentialBackupBase = $ReferencePoint
    }
    else {
        $Msvm_VirtualSystemExportSettingData.DifferentialBackupBase = (Get-CimInstancePath -CimInstance $ReferencePoint)
    }

    # BackupIntent
    # Indicates what should be the VHD path in the exported configuration.
    # 0: The exported configuration would point to the current VHD.
    # 1: The exported configuration would point to the base VHD.
    $Msvm_VirtualSystemExportSettingData.BackupIntent = 1

    #Export the virtual machine snapshot, this method returns a job object.
    $job = ($Msvm_VirtualSystemManagementService | Invoke-CimMethod -MethodName "ExportSystemDefinition" -Arguments @{
        ComputerSystem = $Msvm_ComputerSystem;
        ExportDirectory = $DestinationPath;
        ExportSettingData = ($Msvm_VirtualSystemExportSettingData | ConvertTo-CimEmbeddedString)
    })

    if (!$noWait)
    {
        $job | Trace-CimMethodExecution | Out-Null
    }
}

function Get-VmBackupCheckpoints
{
    [CmdletBinding(DefaultParametersetname="vmname")]
    Param(
      [Parameter(Mandatory=$True, ParameterSetName="vmid")]
      [string]$VmId = [String]::Empty,
      [Parameter(Mandatory=$True, ParameterSetName="vmname")]
      [string]$VmName = [String]::Empty
    )

    if ($PsCmdlet.ParameterSetName -eq "vmname"){
        $filter = "ElementName='$vmName'"
    } else {
        $filter = "Name='$VmId'"
    }

    # Retrieve an instance of the virtual machine computer system that contains recovery checkpoints
    $Msvm_ComputerSystem = Get-CimInstance -Namespace root\virtualization\v2 -Class Msvm_ComputerSystem -Filter $filter

    # Retrieve all snapshot associations for the virtual machine
    $allSnapshotAssociations = ($Msvm_ComputerSystem | Get-CimAssociatedInstance -ResultClassName "CIM_VirtualSystemSettingData" -Association "Msvm_SnapshotOfVirtualSystem" | % {$_})

    # find all recovery snapshots
    $virtualSystemSnapshots = $allSnapshotAssociations | Where-Object { $_.VirtualSystemType -eq "Microsoft:Hyper-V:Snapshot:Recovery" }

    # Return the array of recovery snapshots
    return $virtualSystemSnapshots
}

function Get-VmReferencePoints
{
    [CmdletBinding(DefaultParametersetname="vmname")]
    Param(
      [Parameter(Mandatory=$True, ParameterSetName="vmid")]
      [string]$VmId = [String]::Empty,
      [Parameter(Mandatory=$True, ParameterSetName="vmname")]
      [string]$VmName = [String]::Empty
    )

    if ($PsCmdlet.ParameterSetName -eq "vmname"){
        $filter = "ElementName='$vmName'"
    } else {
        $filter = "Name='$VmId'"
    }

    # Retrieve an instance of the virtual machine computer system that contains reference points
    $Msvm_ComputerSystem = Get-CimInstance -Namespace root\virtualization\v2 -Class Msvm_ComputerSystem -Filter $filter

    # Retrieve all refrence associations of the virtual machine
    $allRefPoints = ($Msvm_ComputerSystem | Get-CimAssociatedInstance -ResultClassName "Msvm_VirtualSystemReferencePoint" -Association "Msvm_ReferencePointOfVirtualSystem" | % {$_})

    $virtualSystemRefPoints = $allRefPoints

    # Return the array of recovery points
    return $virtualSystemRefPoints
}

function New-VmBackupCheckpoint
{
    [CmdletBinding(DefaultParametersetname="vmname")]
    Param(
      [Parameter(Mandatory=$True, ParameterSetName="vmid")]
      [string]$VmId = [String]::Empty,
      [Parameter(Mandatory=$True, ParameterSetName="vmname")]
      [string]$VmName = [String]::Empty,

      [ValidateSet('ApplicationConsistent','CrashConsistent')]
      [string]$ConsistencyLevel = "ApplicationConsistent"
    )

    # Retrieve an instance of the virtual machine management service
    $Msvm_VirtualSystemManagementService = Get-CimInstance -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemManagementService

    # Retrieve an instance of the virtual machine snapshot service
    $Msvm_VirtualSystemSnapshotService = Get-CimInstance -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemSnapshotService

    if ($PsCmdlet.ParameterSetName -eq "vmname"){
        $filter = "ElementName='$vmName'"
    } else {
        $filter = "Name='$VmId'"
    }

    $consistencyLevelSetter = -1

    # Identify the consistency level for the snapshot.
    # 1: Application Consistent
    # 2: Crash Consistent
    switch ($ConsistencyLevel)
    {
        "ApplicationConsistent" {
            $consistencyLevelSetter = 1
        }

        "CrashConsistent" {
            $consistencyLevelSetter = 2
        }

        default {
            throw "Unexpected Consistency Level Specified"
        }
    }

    # Retrieve an instance of the virtual machine computer system that will be snapshotted
    $Msvm_ComputerSystem = Get-CimInstance -Namespace root\virtualization\v2 -Class Msvm_ComputerSystem -Filter $filter

    # Create an instance of the Msvm_VirtualSystemSnapshotSettingData, this class provides options on how the checkpoint will be created.
    $Msvm_VirtualSystemSnapshotSettingData = (Get-CimClass -Namespace "root\virtualization\v2" -ClassName "Msvm_VirtualSystemSnapshotSettingData" | New-CimInstance -ClientOnly -Property @{ConsistencyLevel = $consistencyLevelSetter; IgnoreNonSnapshottableDisks = $true})

    # Create the virtual machine snapshot, this method returns a job object.
    $job = ($Msvm_VirtualSystemSnapshotService | Invoke-CimMethod -MethodName "CreateSnapshot" -Arguments @{
        AffectedSystem = $Msvm_ComputerSystem;
        SnapshotSettings = ($Msvm_VirtualSystemSnapshotSettingData | ConvertTo-CimEmbeddedString);
        SnapshotType = 32768;
    })

    # Waits for the job to complete and processes any errors.
    $job | Trace-CimMethodExecution | Out-Null

    # Retrieves the snapshot object resulting from the snapshot.
    $snapshot = ($job.Job | Get-CimAssociatedInstance -ResultClassName "Msvm_VirtualSystemSettingData" | % {$_})

    # Returns the snapshot instance
    return $snapshot
}

function Remove-VmReferencePoint
{
    Param(
      [Parameter(Mandatory=$True)]
      [Microsoft.Management.Infrastructure.CimInstance]$ReferencePoint = $null
    )

    # Retrieve an instance of the virtual machine refrence point service
    $Msvm_VirtualSystemReferencePointService = Get-CimInstance -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemReferencePointService

    # Removes the virtual machine reference, this method returns a job object.
    $job = ($Msvm_VirtualSystemReferencePointService | Invoke-CimMethod -MethodName "DestroyReferencePoint" -Arguments @{
        AffectedReferencePoint = $ReferencePoint
    })

    # Waits for the job to complete and processes any errors.
    $job | Trace-CimMethodExecution | Out-Null
}