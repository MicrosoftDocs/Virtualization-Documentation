ms.ContentId: B971C429-CEF0-4DAB-8456-3B08AEC0C233
title: Step 6 - Virtual Machine Export and Import

# Virtual Machine Export and Import 

Unlike a checkpoint where a snapshot file is created which can then be applied back to the virtual machine, exporting creates a full copy of all virtual machine files. An export can be used for backup, restoration, or a way to move a virtual machine between hosts. This document will walk through exporting and importing a virtual machine and some of the choices you can make when performing these tasks.

## Exporting a Virtual Machine in Hyper-V Manager

When creating an export of a virtual machine all associated files will be bundled in the export. This includes configuration files, hard drive files and also any existing checkpoint files. To create a virtual machine export:

1. In Hyper-V Manager right click on the desired virtual machine and select **Export**.

2. Specify the location where you will store the exported files and click the **Export** button.

**Note:** this process can be run on a virtual machine that is in either a started or stopped state.

Once the export has been completed you will be able to see all exported files under the export folder.

## Exporting a Virtual Machine with PowerShell

To export a virtual machine using PowerShell use the **Export-VM** command. More information can be found at the [Export-VM Reference](https://technet.microsoft.com/en-us/library/hh848491.aspx).

```powershell
Export-VM -Name <vm name> -Path <path>
```
## Importing a Virtual Machine with Hyper-V Manager

Importing a virtual machine will take the exported files and register the virtual machine with the Hyper-V host. A virtual machine export can be imported back into the host from which it was derived or new host.

To import a virtual machine into a Hyper-V host:

1. In Hyper-V Manager click **Import Virtual Machine** from the actions menu.

2. Click **Next** on Before you Begin screen.

3. Select the folder that contains the exported files and click **Next**.

4. Select the Virtual Machine to import, there will most likely only be one option.

5. Choose an import type from one of the three options (detailed below) and click next. 

6. Select **Finish** on the summary screen.

**Import Types**

- **Register in-place** – export files have been placed in the location where the virtual machine should be run from. Once imported the virtual machine will have the same ID as it did at the time of export. Because of this, If the virtual machine is already registered with Hyper-V it will need to be removed before the import will work. Once the import has completed, the export files have become the running state files and cannot be removed.

- **Restore the virtual machine** – when selecting to restore the export you will be given an option to store the VM files in a specific location or use the locations default to Hyper-V. This process will create a copy of the exported file and move them to the selected location. Once imported the virtual machine will have the same ID as it did at the time of export. Because of this, if the virtual machine is already registered with Hyper-V it will need to be removed before the import will work. Once the import has completed the exported files will remain untouched and can be removed and / or imported again.

- **Copy the virtual machine** – This import type is similar to the Restore type in that you will be able to select a location for the VM files. The difference is that once imported the virtual machine will have a new unique ID. This allows for the Virtual Machine to be imported into the same host multiple time.

## Importing a Virtual Machine with PowerShell

To import a virtual machine using PowerShell use the **Import-VM** command. More information can be found at the [Import-VM Reference](https://technet.microsoft.com/en-us/library/hh848495.aspx).

To complete an in place import of a virtual machine the command would look similar to this. Recall that an in place import will use the files where they are stored at the time of import and will retain the virtual machines id.

```powershell
Import-VM -Path 'C:\<emport path>\2B91FEB3-F1E0-4FFF-B8BE-29CED892A95A.vmcx' 
```
To perform a copy import and move the virtual machine files to the default Hyper-V location the command would be similar to this.

```powershll
Import-VM -Path 'C:\<vm export path>\2B91FEB3-F1E0-4FFF-B8BE-29CED892A95A.vmcx' –Copy -GenerateNewId
```

Finally, to import the virtual machine specifying your own path for the virtual machine files the command would look similar to this.

```powershell
Import-VM -Path ‘C:\<vm export path>\2B91FEB3-F1E0-4FFF-B8BE-29CED892A95A.vmcx' -Copy -VhdDestinationPath 'D:\Virtual Machines\WIN10DOC' -VirtualMachinePath 'D:\Virtual Machines\WIN10DOC' -GenerateNewId 
```

## Next Step
[Experiment with Windows Powershell](walkthrough_powershell.md)