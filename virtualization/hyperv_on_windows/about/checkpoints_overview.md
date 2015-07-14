ms.ContentId: 1683647C-AD5D-4BD6-AEB4-7FF61EE41037
title: Checkpoints Overview

# Checkpoints Overview

This topic explains the new and changed checkpoint functionality in Client Hyper-V running on Windows 10®.


## Why do I need checkpoints?

Checkpoints can be helpful to use when you are about to make a change to a virtual machine and you want to be able to roll-back to the present state if the updates cause issues. There are two types of checkpoints:

-  **Production checkpoints**: Used mainly on servers in production environments 

-  **Standard checkpoints**: Used in development or testing environments 


## How are production checkpoints different from standard checkpoints?

Production checkpoints and standard checkpoints restore a virtual machine to a previous state. However, production checkpoints utilize the Volume Shadow Copy Service (VSS) to create an application-consistent checkpoint of a virtual machine. Standard checkpoints (formerly known as snapshots) capture the saved state of your virtual machine.

Standard checkpoints contain the memory state of a virtual machine, which may contain information about client connections, transactions, and the external network state. This information may not be valid when the checkpoint is applied. Applying a production checkpoint involves booting the guest operating system from an offline state. This means that no application state or security information is captured as part of the checkpoint process. 

## Which type of checkpoint should I use?

The following table shows when to use production checkpoints or standard checkpoints, depending on the state of the virtual machine.

|   **Virtual Machine State** | **Production Checkpoint** |  **Standard Checkpoint** |
|:-----|:-----|:-----|
|**Running with Integration Services**| Yes | Yes 
|**Running without Integration Services** | No | Yes 
|**Offline - no saved state**| Yes | Yes 
|**Offline - with saved state**| No | Yes 
|**Paused** | No| Yes |


## How are checkpoints stored?

Checkpoint files are stored in the following locations:

|   **Default Location** | **Contents** |
|:-----|:-----|
|**C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Machines**| Default folder for the virtual machine configuration file (.vmcx) and the virtual machine runtime state file (.vmrs). 
|**C:\ProgramData\Microsoft\Windows\Hyper-V\Snapshots** | Default folder for checkpoint files. Each time a virtual machine checkpoint is created, two additional files are added—a configuration file (.VMCX) and a runtime state file (.VMRS). 
|**C:\Users\Public\Documents\Hyper-V\Virtual hard disks**| Default folder for a virtual machine hard disk file (.VHDX). Default folder for the automatic virtual hard disk files (.AVHDX) associated with a production checkpoint.  |


# Understanding production checkpoints

Production checkpoints utilize the Volume Shadow Copy Service (VSS) to create a checkpoint (or image) of your virtual machine. When you first create a virtual machine, you create a virtual hard disk file (.VHDX), a virtual machine configuration file (.VMCX), and a virtual machine runtime state file (.VMRS). Each time you create a production checkpoint, you create a new automatic virtual hard disk file (.avhdx), an additional virtual machine configuration file (.VMCX), and a virtual machine runtime state file (.VMRS).

The default behavior in Windows 10 for new virtual machines is to create production checkpoints with fallback to standard checkpoints. If you want your checkpoint to contain system-state information, you need to change the checkpoint type to a standard checkpoint in the **Checkpoints** section of the virtual machine settings. 

You can control the option to fall back to standard checkpoints if the virtual machine is missing integration components or there is another reason that the system cannot create a production checkpoint. The following diagram illustrates how production checkpoints work: 

![](media\ProductionCheckpoints.png)


## Where do I use production checkpoints?
Production checkpoints are designed for use in production environments. You can use them prior to applying a patch, changing a server configuration, or performing some other potentially risky operation on your production server. If the operation is successful, the checkpoint can be deleted. If the operation fails, the virtual machine can be reverted to the production checkpoint. 

# Understanding standard checkpoints

Standard checkpoints allow you to develop and test software updates or configurations within a virtual a machine, but quickly roll back to a previous state if required. This ability saves recovery time and aids in faster software development and testing. 

Standard checkpoints are read-only, “point-in-time” images of a virtual machine. You can capture the configuration and state of a virtual machine at any point-in-time, and return the virtual machine to that state with minimal interruption. 

When you create a new virtual machine, it creates a virtual hard disk file (.VHDX), a virtual machine configuration file (.VMCX), and a virtual machine runtime state file (.VMRS). Like production checkpoints, each time you create a standard checkpoint you create a new automatic virtual hard disk file (.avhdx), an additional virtual machine configuration file (.VMCX), and virtual machine runtime state file (.VMRS). 

Standard checkpoints create larger runtime state files (.VMRS) than production checkpoints. This is because standard checkpoints are also storing saved state information (for example, memory state information). 

The following diagram illustrates how standard checkpoints work:

![](media\StandardCheckpoints.png)


## How are standard checkpoints different from production checkpoints?
 

Standard checkpoints and production checkpoints restore a virtual machine to a previous state. However, standard checkpoints and production checkpoints work differently. 

Standard checkpoints capture the saved state of your virtual machine to your hard disk, including a copy of the virtual machine's configuration, memory, and changes to the virtual hard disk. 
Production checkpoints utilize the Volume Shadow Copy Service (VSS) to create a checkpoint, and they don’t store a copy of the virtual machine's saved state. 

Standard checkpoints are not the default checkpoint option. Standard checkpoints can be configured for each virtual machine with the default location for your checkpoint files. 

## Where do I use standard checkpoints?


We recommend that you use standard checkpoints in a development or testing environment. For example, you can use standard checkpoints to test and verify software updates before you apply them directly to your production servers. 

Keep the following considerations in mind when you use standard checkpoints in your environment:

- The presence of a standard checkpoint for a virtual machine may impact the disk performance of the virtual machine.


- We do not recommend using standard checkpoints on virtual machines that provide time-sensitive services, or when performance or the availability of storage space is critical.




