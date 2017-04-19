Param(
  [Parameter(Mandatory=$True)]
  [string]$vhdPath,
  
  [Parameter(Mandatory=$True)]
  [string]$cabPath,
)

#Mount the VHD
$diskNo=(Mount-VHD -Path $vhdPath -Passthru).DiskNumber

#Get the driver letter associated with the mounted VHD, note this assumes it only has one partition if there are more use the one with OS bits
$driveLetter=(Get-Disk $diskNo | Get-Partition).DriveLetter

#Check to see if the disk is online if it is not online it
if ((Get-Disk $diskNo).OperationalStatus -ne 'Online')
{Set-Disk $MountedVHD.Number -IsOffline:$false -IsReadOnly:$false}

#Install the patch
Add-WindowsPackage -PackagePath $cabPath -Path ($driveLetter + ":\")

#Dismount the VHD
Dismount-VHD -Path $vhdPath
