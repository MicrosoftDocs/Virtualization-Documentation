$virtualHardDiskToUpdate="D:\client_professional_en-us_vl.vhd"
$integrationServicesCabPath="C:\Users\sarah\Downloads\windows6.2-hypervintegrationservices-x86.cab"

#Mount the VHD
$diskNo=(Mount-VHD -Path $virtualHardDiskToUpdate –Passthru).DiskNumber

#Get the driver letter associated with the mounted VHD, note this assumes it only has one partition if there are more use the one with OS bits
$driveLetter=(Get-Disk $diskNo | Get-Partition).DriveLetter

#Check to see if the disk is online if it is not online it
if ((Get-Disk $diskNo).OperationalStatus -ne 'Online')
{Set-Disk $MountedVHD.Number -IsOffline:$false -IsReadOnly:$false}

#Install the patch
Add-WindowsPackage -PackagePath $integrationServicesCabPath -Path ($driveLetter + ":\")

#Dismount the VHD
Dismount-VHD-Path $virtualHardDiskToUpdate