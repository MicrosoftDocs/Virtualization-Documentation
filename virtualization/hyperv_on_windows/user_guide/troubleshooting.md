ms.ContentId: D1D4969F-52FD-43A2-982B-B531B0343D2B 
title: Troubleshooting

# Troubleshoot Hyper-V on Windows 10

## I changed the checkpoint type, but it is still taking the wrong type of checkpoint
If you are taking the checkpoint from VMConnect and you change the checkpoint type in Hyper-V manager the checkpoint taken be whatever checkpoint type was specified when VMConnect was opened.

Close VMConnect and reopen it to make it take the correct type of checkpoint.

## When I try to create a virtual hard disk on a flash drive, an error message is displayed
Hyper-V does not support FAT/FAT32 formatted disk drives since these file systems do not provide access control lists (ACLs) and do not support files larger than 4GB. ExFAT formatted disks only provide limited ACL functionality and are therefore also not supported for security reasons.
The error message displayed in PowerShell is "The system failed to create '\[path to VHD\]': The requested operation could not be completed due to a file system limitation (0x80070299)."

Use a NTFS formatted drive instead. 

## I get this message when I try to install: "Hyper-V cannot be installed: The processor does not support second level address translation (SLAT)."
Hyper-V requires SLAT in order to run virtual machines. If you computer does not support SLAT, then it cannot be a host for virtual mahchines.

If you are only trying to install the management tools, unselect **Hyper-V Platform** in **Programs and Features** > **Turn Windows features on or off**.
