# ProcessWMIJob is a generic function that waits for WMI job's to
#  complete and returns appropriate success/failure cases.
#  This function was originally written and documented on
#  Taylor Brown's blog at:
#  http://blogs.msdn.com/b/taylorb/archive/2008/06/18/hyper-v-wmi-rich-error-messages-for-non-zero-returnvalue-no-more-32773-32768-32700.aspx
filter ProcessWMIJob
{
    param
    (
        [WMI]$WmiClass = $null,
        [string]$MethodName = $null
    )
	$errorCode = 0
    $returnObject = $_

    if ($_.ReturnValue -eq 4096)
    {
        $Job = [WMI]$_.Job
        $returnObject = $Job

        while ($Job.JobState -eq 4)
        {
            Write-Progress -Activity $Job.Caption -Status ($Job.JobStatus + " - " + $Job.PercentComplete + "%") -PercentComplete $Job.PercentComplete
            Start-Sleep -seconds 1
            $Job.PSBase.Get()
        }
        if ($Job.JobState -ne 7)
        {
			if ($Job.ErrorDescription -ne "")
			{
            	Write-Error $Job.ErrorDescription
            	Throw $Job.ErrorDescription
			}
			else
			{
				$errorCode = $Job.ErrorCode
			}
        }
        Write-Progress -Activity $Job.Caption -Status $Job.JobStatus -PercentComplete 100 -Completed:$true

    }
	elseif($_.ReturnValue -ne 0)
	{
		$errorCode = $_.ReturnValue
	}

	if ($errorCode -ne 0)
    {
        Write-Error "Hyper-V WMI Job Failed!"
        if ($WmiClass -and $MethodName)
        {
            $psWmiClass = [WmiClass]("\\" + $WmiClass.__SERVER + "\" + $WmiClass.__NAMESPACE + ":" + $WmiClass.__CLASS)
            $psWmiClass.PSBase.Options.UseAmendedQualifiers = $TRUE
            $MethodQualifierValues = ($psWmiClass.PSBase.Methods[$MethodName].Qualifiers)["Values"]
            $indexOfError = [System.Array]::IndexOf(($psWmiClass.PSBase.Methods[$MethodName].Qualifiers)["ValueMap"].Value, [string]$errorCode)
            if (($indexOfError -ne "-1") -and $MethodQualifierValues)
            {
                Throw "ReturnCode: ", $errorCode, " ErrorMessage: '", $MethodQualifierValues.Value[$indexOfError], "' - when calling $MethodName"
            }
            else
            {
                Throw "ReturnCode: ", $errorCode, " ErrorMessage: 'MessageNotFound' - when calling $MethodName"
            }
        }
        else
        {
            Throw "ReturnCode: ", $errorCode, "When calling $MethodName - for rich error messages provide classpath and method name."
        }
    }
	return $returnObject
}


function Convert-VmBackupCheckpoint
{
    Param(
      [Parameter(Mandatory=$True)]
      [System.Management.ManagementObject]$BackupCheckpoint = $null
    )

    # Retrieve an instance of the snapshot management service
    $Msvm_VirtualSystemSnapshotService = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemSnapshotService

    # Convert the snapshot to a reference point, this function returns a job object.
    $job = $Msvm_VirtualSystemSnapshotService.ConvertToReferencePoint($BackupCheckpoint)

    # Wait for the job to complete.
    ($job | ProcessWMIJob -WmiClass $Msvm_VirtualSystemSnapshotService -MethodName "ConvertToReferencePoint") | Out-Null

    # The new reference point object is related to the job, GetReleated
    #   always returns an array in this case there is only one member
    $refPoint = (([WMI]$job.Job).GetRelated("Msvm_VirtualSystemReferencePoint") | % {$_})

    # Return the reference point object
    return $refPoint
}

function Export-VMBackupCheckpoint
{
    Param(
      [Parameter(Mandatory=$True)]
      [string]$VmName = [String]::Empty,

      [Parameter(Mandatory=$True)]
      [string]$DestinationPath = [String]::Empty,

      [Parameter(Mandatory=$True)]
      [System.Management.ManagementObject]$BackupCheckpoint = $null,

      [System.Management.ManagementObject]$ReferencePoint = $null,

      [bool]$noWait = $false
    )

    # Retrieve an instance of the virtual machine management service
    $Msvm_VirtualSystemManagementService = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemManagementService

    # Retrieve an instance of the virtual machine computer system that will be snapshoted
    $Msvm_ComputerSystem = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_ComputerSystem -Filter "ElementName='$vmName'"

    # Retrieve an instance of the Export Setting Data Class (this is used to inform the export operation)
    #  GetReleated always returns an array in this case there is only one member
    $Msvm_VirtualSystemExportSettingData = ($Msvm_ComputerSystem.GetRelated("Msvm_VirtualSystemExportSettingData","Msvm_SystemExportSettingData",$null,$null, $null, $null, $false, $null) | % {$_})

    # Specify the export options
        #   CopySnapshotConfiguration
        #      0: ExportAllSnapshots - All snapshots will be exported with the VM.
        #      1: ExportNoSnapshots - No snapshots will be exported with the VM.
        #      2: ExportOneSnapshot - The snapshot identified by the SnapshotVirtualSystem property will be exported with the VM.
        #      3: ExportOneSnapshotUseVmId  - The snapshot identified by the SnapshotVirtualSystem property will be exported with the VM. Using the VMs ID.
        $Msvm_VirtualSystemExportSettingData.CopySnapshotConfiguration = 3

        #   CopyVmRuntimeInformation
        #      Indicates whether the VM runtime information will be copied when the VM is exported. (i.e. saved state)
        $Msvm_VirtualSystemExportSettingData.CopyVmRuntimeInformation = $false

        #   CopyVmStorage
        #      Indicates whether the VM storage will be copied when the VM is exported.  (i.e. VHDs/VHDx files)
        $Msvm_VirtualSystemExportSettingData.CopyVmStorage = $true

        #   CreateVmExportSubdirectory
        #      Indicates whether a subdirectory with the name of the VM will be created when the VM is exported.
        $Msvm_VirtualSystemExportSettingData.CreateVmExportSubdirectory = $false

        #   SnapshotVirtualSystem
        #      Path to a Msvm_VirtualSystemSettingData instance that represents the snapshot to be exported with the VM.
        $Msvm_VirtualSystemExportSettingData.SnapshotVirtualSystem = $BackupCheckpoint

        #   DifferentialBase
        #      Base for differential export. This is either path to a Msvm_VirtualSystemReferencePoint instance that
        #         represents the reference point or path to a Msvm_VirtualSystemSettingData instance that
        #         represents the snapshot to be used as a base for differential export. If the CopySnapshotConfiguration
        #         property is not set to 3(ExportOneSnapshotUseVmId), this property is ignored."
        $Msvm_VirtualSystemExportSettingData.DifferentialBase = $ReferenceSnapshot

        #   StorageConfiguration
        #      Indicates what should be the VHD path in the exported configuration.
        #        0: StorageConfigurationCurrent - The exported configuration would point to the current VHD.
        #        1: StorageConfigurationBaseVhd - The exported configuration would point to the base VHD.
        $Msvm_VirtualSystemExportSettingData.StorageConfiguration = 1

    #Export the virtual machine snapshot, this method returns a job object.
    $job = $Msvm_VirtualSystemManagementService.ExportSystemDefinition($Msvm_ComputerSystem, $DestinationPath, $Msvm_VirtualSystemExportSettingData.GetText(1))

    if (!$noWait)
    {
        ($job | ProcessWMIJob -WmiClass $Msvm_VirtualSystemManagementService -MethodName "ExportSystemDefinition") | Out-Null
    }
}

function Get-VmBackupCheckpoints
{
    Param(
      [Parameter(Mandatory=$True)]
      [string]$VmName = [String]::Empty
    )

    # Retrieve an instance of the virtual machine computer system that contains recovery checkpoints
    $Msvm_ComputerSystem = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_ComputerSystem -Filter "ElementName='$VmName'"

    # Retrieve all snapshot associations for the virtual machine
    $allSnapshotAssociations = $Msvm_ComputerSystem.GetRelationships("Msvm_SnapshotOfVirtualSystem")

    # Enumerate across all of the instances and add all recovery snapshots to an array
    $virtualSystemSnapshots = @()
    $enum = $allSnapshotAssociations.GetEnumerator()
    $enum.Reset()
    while($enum.MoveNext())
    {
        if (([WMI] $enum.Current.Dependent).VirtualSystemType -eq "Microsoft:Hyper-V:Snapshot:Recovery")
        {
            $virtualSystemSnapshots += ([WMI] $enum.Current.Dependent)
        }
    }

    # Return the array of recovery snapshots
    $virtualSystemSnapshots
}

function Get-VmReferencePoints
{
    Param(
      [Parameter(Mandatory=$True)]
      [string]$VmName = [String]::Empty
    )

    # Retrieve an instance of the virtual machine computer system that contains reference points
    $Msvm_ComputerSystem = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_ComputerSystem -Filter "ElementName='$VmName'"

    # Retrieve all refrence associations of the virtual machine
    $allrefPoints = $Msvm_ComputerSystem.GetRelationships("Msvm_ReferencePointOfVirtualSystem")

    # Enumerate across all of the instances and add all recovery points to an array
    $virtualSystemRefPoint = @()
    $enum = $allrefPoints.GetEnumerator()
    $enum.Reset()
    while($enum.MoveNext())
    {
        $virtualSystemRefPoint += ([WMI] $enum.Current.Dependent)
    }

    # Return the array of recovery points
    $virtualSystemRefPoint
}

function New-VmBackupCheckpoint
{
    Param(
      [Parameter(Mandatory=$True)]
      [string]$VmName = [String]::Empty,
      [ValidateSet('ApplicationConsistent','CrashConsistent')]
      [string]$ConsistencyLevel = "Application Consistent"
    )

    # Retrieve an instance of the virtual machine management service
    $Msvm_VirtualSystemManagementService = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemManagementService

    # Retrieve an instance of the virtual machine snapshot service
    $Msvm_VirtualSystemSnapshotService = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemSnapshotService

    # Retrieve an instance of the virtual machine computer system that will be snapshotted
    $Msvm_ComputerSystem = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_ComputerSystem -Filter "ElementName='$vmName'"

    # Create an instance of the Msvm_VirtualSystemSnapshotSettingData, this class provides options on how the checkpoint will be created.
    $Msvm_VirtualSystemSnapshotSettingData = ([WMIClass]"\\.\root\virtualization\v2:Msvm_VirtualSystemSnapshotSettingData").CreateInstance()

    # Identify the consistency level for the snapshot.
    #  1:  Application Consistent
    #  2:  Crash Consistent
    switch ($ConsistencyLevel)
    {
        "ApplicationConsistent" {
        $Msvm_VirtualSystemSnapshotSettingData.ConsistencyLevel = 1
        }

        "CrashConsistent" {
        $Msvm_VirtualSystemSnapshotSettingData.ConsistencyLevel = 2
        }

        default {
        throw "Unexpected Consistancy Level Specified"
        }
    }

    # Specify the behavior for disks that cannot be snapshotted (i.e. pass-through, virtual fibre channel)
    $Msvm_VirtualSystemSnapshotSettingData.IgnoreNonSnapshottableDisks = $true

    # Create the virtual machine snapshot, this method returns a job object.
    $job = $Msvm_VirtualSystemSnapshotService.CreateSnapshot(
        $Msvm_ComputerSystem,
        $Msvm_VirtualSystemSnapshotSettingData.GetText(2),
        32768)

    # Waits for the job to complete and processes any errors.
    ($job | ProcessWMIJob -WmiClass $Msvm_VirtualSystemSnapshotService -MethodName "CreateSnapshot") | Out-Null

    # Retrieves the snapshot object resulting from the snapshot.
    $snapshot = (([WMI]$job.Job).GetRelated("Msvm_VirtualSystemSettingData") | % {$_})

    # Returns the snapshot instance
    return $snapshot
}

function Remove-VmReferencePoint
{
    Param(
      [Parameter(Mandatory=$True)]
      [System.Management.ManagementObject]$ReferencePoint = $null
    )


    # Retrieve an instance of the virtual machine refrence point service
    $Msvm_VirtualSystemReferencePointService = Get-WmiObject -Namespace root\virtualization\v2 -Class Msvm_VirtualSystemReferencePointService

    # Removes the virtual machine reference, this method returns a job object.
    $job = $Msvm_VirtualSystemReferencePointService.DestroyReferencePoint($ReferenceSnapshot)

    # Waits for the job to complete and processes any errors.
    ($job | ProcessWMIJob -WmiClass $Msvm_VirtualSystemReferencePointService -MethodName "DestroyReferencePoint") | Out-Null
}
