---
title: Export and Import virtual machines
description: Export and Import virtual machines
keywords: windows 10, hyper-v
author: scooley
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-10-hyperv
ms.service: windows-10-hyperv
ms.assetid: 7fd996f5-1ea9-4b16-9776-85fb39a3aa34
---

# Export and Import virtual machines

You can use Hyper-V's export and import functionality to quickly duplicate virtual machines.  Exported virtual machines can be used for backup or as a way to move a virtual machine between Hyper-V hosts.  

Import allows you to restore virtual machines.  You don't need to export a virtual machine to be able to import it. Import will try to recreate the virtual machine from whatever is available.  Use the **Import Virtual Machine** wizard to specify the location of the files. This registers the virtual machine with Hyper-V and makes it available to be used.
 
This document walks through exporting and importing a virtual machine and some of the choices you can make when performing these tasks.

## Export a Virtual Machine

### Using Hyper-V Manager

When creating an export of a virtual machine, all associated files are bundled in the export. This includes configuration files, hard drive files and also any existing checkpoint files. To create a virtual machine export:

1. In Hyper-V Manager right click on the desired virtual machine and select **Export**.

2. Specify the location to store the exported files and click the **Export** button.

**Note:** this process can be run on a virtual machine that is in either a started or stopped state.

When the export has been completed you can see all exported files under the export location.

### Using PowerShell

To export a virtual machine using PowerShell use the **Export-VM** command. 

```powershell
Export-VM -Name <vm name> -Path <path>
```

For information about using Windows PowerShell to export virtual machines, see [Export-VM](https://technet.microsoft.com/library/hh848491.aspx)

## Import a Virtual Machine 

Importing a virtual machine registers the virtual machine with the Hyper-V host. A virtual machine export can be imported back into the host from which it was derived or new host. 

Hyper-V includes three import types:

- **Register in-place** – Export files have been placed in the location where the virtual machine should be run from. When imported, the virtual machine has the same ID as it did at the time of export. Because of this, If the virtual machine is already registered with Hyper-V it needs to be deleted before the import will work. When the import has completed, the export files become the running state files and cannot be removed.

- **Restore the virtual machine** – You are given an option to store the VM files in a specific location or use the locations default to Hyper-V. This import type creates a copy of the exported file and moves them to the selected location. When imported, the virtual machine has the same ID as it did at the time of export. Because of this, if the virtual machine is already running in Hyper-V it needs to be deleted before the import can be completed. When the import has completed the exported files remain untouched and can be removed and / or imported again.

- **Copy the virtual machine** – This import type is similar to the Restore type in that you select a location for the VM files. The difference is that when imported the virtual machine has a new unique ID. This allows for the Virtual Machine to be imported into the same host multiple time.


### Using Hyper-V Manager

To import a virtual machine into a Hyper-V host:

1. In Hyper-V Manager click **Import Virtual Machine** from the actions menu.

2. Click **Next** on Before you Begin screen.

3. Select the folder that contains the exported files and click **Next**.

4. Select the Virtual Machine to import, there will most likely only be one option.

5. Choose an import type from one of the three options and click next. 

6. Select **Finish** on the summary screen.

The Import Virtual Machine wizard also walks you through the steps of addressing incompatibilities when you import the virtual machine to the new host—so this wizard can help with configuration that is associated with physical hardware, such as memory, virtual switches, and virtual processors.

To import a virtual machine, the wizard does the following:  
1. Creates a copy of the virtual machine configuration file. This is done as a precaution in case an unexpected restart occurs on the host, such as from a power outage.  

2. Validates hardware. Information in the virtual machine configuration file is compared to hardware on the new host.

3. Compiles a list of errors. This list identifies what needs to be reconfigured and determines which pages appear next in the wizard.

4. Displays the relevant pages, one category at a time. The wizard explains each incompatibility to help you reconfigure the virtual machine so it is compatible with the new host.

5. Removes the copy of the configuration file. After the wizard does this, the virtual machine is ready to be started.


### Using PowerShell

To import a virtual machine using PowerShell, use the **Import-VM** command.  The following commands demonstrate an import of each of the three import types using PowerShell.

To complete an in place import of a virtual machine, the command would look similar to this. Recall that an in place import uses the files where they are stored at the time of import and retains the virtual machines id.

```powershell
Import-VM -Path 'C:\<vm export path>\2B91FEB3-F1E0-4FFF-B8BE-29CED892A95A.vmcx' 
```

To import the virtual machine specifying your own path for the virtual machine files, the command would look similar to this.

```powershell
Import-VM -Path ‘C:\<vm export path>\2B91FEB3-F1E0-4FFF-B8BE-29CED892A95A.vmcx' -Copy -VhdDestinationPath 'D:\Virtual Machines\WIN10DOC' -VirtualMachinePath 'D:\Virtual Machines\WIN10DOC'
```

To complete a copy import and move the virtual machine files to the default Hyper-V location, the command would be similar to this.

``` PowerShell
Import-VM -Path 'C:\<vm export path>\2B91FEB3-F1E0-4FFF-B8BE-29CED892A95A.vmcx' -Copy -GenerateNewId
```

For more information, see [Import-VM](https://technet.microsoft.com/library/hh848495.aspx).
