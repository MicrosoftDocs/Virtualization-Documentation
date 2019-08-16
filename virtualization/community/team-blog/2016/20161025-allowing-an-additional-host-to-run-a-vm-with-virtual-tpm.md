---
title:      "Allowing an additional host to run a VM with virtual TPM"
date:       2016-10-25 18:36:53
categories: guarded-fabric
---

Recently a colleague got a new PC and asked me how he could migrate his existing virtual machines to his new system. Because he had enabled a virtual [Trusted Platform Module](https://technet.microsoft.com/itpro/windows/keep-secure/trusted-platform-module-overview) (TPM) on these VMs, he wasn’t sure how to proceed. This is also a common scenario when moving VMs to a [guarded fabric](https://docs.microsoft.com/en-us/windows-server/security/guarded-fabric-shielded-vm/guarded-fabric-and-shielded-vms). TPMs are an established and standardized technology which can be used for different purposes around system trustworthiness and identity. For example, they can be used to ensure the OSes boot loader and boot configuration has not been tampered with before unsealing a BitLocker encrypted disk, or to have a strong system identity based on hardware. Virtual TPMs bring these great capabilities to virtual machines running on Windows 10 1511 and Windows Server 2016 hosts or newer. To protect the virtual TPM’s state, it is stored encrypted. This means, some keys must be updated so the VM can run on the destination system. The overall process involves two basic steps before moving the VM to the new host: 


  1. Importing the destination system’s guardian information on the source host
  2. Updating the virtual machine’s key protector



## Importing the destination system’s guardian

First, the guardian information for the destination system or fabric must be exported. If you plan to authorize a guarded fabric, please make sure the destination hosts are properly configured with the Host Guardian Service information. Also, note that if you run this on a host in a guarded fabric, each host that is part of this guarded fabric will be able to run the virtual machine once the key protector is updated. If in doubt, ask your administrator. The following script snippet can be used to export guardian information from a destination host by simply running it on this host.  If the destination host is part of a guarded fabric, the Host Guardian Service’s data is written to the file. Otherwise, a local guardian is created if it does not exist with the default name and exported. On the source host, run this command in an administrative PowerShell to import the guardian information which was previously exported. 

## Updating the virtual machine’s key protector

With the destination system’s guardian information present on the source system, each virtual machine’s key protector can now be updated to include the new guardian. For this step, the assumption is that the source system is running in local mode and the right guardian information is present. If you are running on Windows 10 and can start your VM with a virtual TPM, this should be the case.  The script loops through all VMs with an enabled vTPM and adds the guardian for the destination system exported above. 

## Finishing up

Finally, the virtual machines can be exported on the source and imported on the destination host. You should be good to start the VMs. Hope this helps, Lars
