---
title: Hyper-V symbols for debugging
keywords: virtualization, containers, windows containers, dda, devices, blog
description: Learn about the different Hyper-V symbols for debugging.
author: cwilhit
ms.author: scooley
ms.date: 4/25/2018
ms.topic: article
ms.prod: virtualization
ms.assetid: 
---

# Hyper-V symbols for debugging

Having access to debugging symbols can be very handy, for example when you are 

  * A partner building solutions leveraging Hyper-V, 
  * Trying to debug a specific issue, or
  * Searching for bugs to participate in the [Microsoft Hyper-V Bounty Program](https://technet.microsoft.com/mt784431.aspx).

Starting with symbols for Windows Server 2016 with an installed April 2018 cumulative update, we are now providing access to most Hyper-V-related symbols through the public symbol servers. Here are some of the symbols that are available right now: 

``` 
SYMCHK: vmbuspipe.dll [10.0.14393.2007 ] PASSED - PDB: vmbuspipe.pdb DBG: SYMCHK: vmbuspiper.dll [10.0.14393.2007 ] PASSED - PDB: vmbuspiper.pdb DBG:
SYMCHK: vmbusvdev.dll [10.0.14393.2007 ] PASSED - PDB: vmbusvdev.pdb DBG:
SYMCHK: vmchipset.dll [10.0.14393.2007 ] PASSED - PDB: VmChipset.pdb DBG:
SYMCHK: vmcompute.dll [10.0.14393.2214 ] PASSED - PDB: vmcompute.pdb DBG:
SYMCHK: vmcompute.exe [10.0.14393.2214 ] PASSED - PDB: vmcompute.pdb DBG:
SYMCHK: vmconnect.exe [10.0.14393.0 ] PASSED - PDB: vmconnect.pdb DBG:
SYMCHK: vmdebug.dll [10.0.14393.2097 ] PASSED - PDB: vmdebug.pdb DBG:
SYMCHK: vmdynmem.dll [10.0.14393.2007 ] PASSED - PDB: vmdynmem.pdb DBG:
SYMCHK: vmemulateddevices.dll [10.0.14393.2007 ] PASSED - PDB: VmEmulatedDevices.pdb DBG:
SYMCHK: VmEmulatedNic.dll [10.0.14393.2007 ] PASSED - PDB: VmEmulatedNic.pdb DBG:
SYMCHK: VmEmulatedStorage.dll [10.0.14393.2214 ] PASSED - PDB: VmEmulatedStorage.pdb DBG:
SYMCHK: vmicrdv.dll [10.0.14393.2007 ] PASSED - PDB: vmicrdv.pdb DBG:
SYMCHK: vmictimeprovider.dll [10.0.14393.2007 ] PASSED - PDB: vmictimeprovider.pdb DBG:
SYMCHK: vmicvdev.dll [10.0.14393.2214 ] PASSED - PDB: vmicvdev.pdb DBG:
SYMCHK: vmms.exe [10.0.14393.2214 ] PASSED - PDB: vmms.pdb DBG:
SYMCHK: vmrdvcore.dll [10.0.14393.2214 ] PASSED - PDB: vmrdvcore.pdb DBG:
SYMCHK: vmserial.dll [10.0.14393.2007 ] PASSED - PDB: vmserial.pdb DBG:
SYMCHK: vmsif.dll [10.0.14393.2214 ] PASSED - PDB: vmsif.pdb DBG:
SYMCHK: vmsifproxystub.dll [10.0.14393.82 ] PASSED - PDB: vmsifproxystub.pdb DBG:
SYMCHK: vmsmb.dll [10.0.14393.2007 ] PASSED - PDB: vmsmb.pdb DBG:
SYMCHK: vmsp.exe [10.0.14393.2214 ] PASSED - PDB: vmsp.pdb DBG: SYMCHK: vmsynthfcvdev.dll [10.0.14393.2007 ] PASSED - PDB: VmSynthFcVdev.pdb DBG:
SYMCHK: VmSynthNic.dll [10.0.14393.2007 ] PASSED - PDB: VmSynthNic.pdb DBG:
SYMCHK: vmsynthstor.dll [10.0.14393.2007 ] PASSED - PDB: VmSynthStor.pdb DBG:
SYMCHK: vmtpm.dll [10.0.14393.2007 ] PASSED - PDB: vmtpm.pdb DBG:
SYMCHK: vmuidevices.dll [10.0.14393.2007 ] PASSED - PDB: VmUiDevices.pdb DBG:
SYMCHK: vmusrv.dll [10.0.14393.2007 ] PASSED - PDB: vmusrv.pdb DBG:
SYMCHK: vmwp.exe [10.0.14393.2214 ] PASSED - PDB: vmwp.pdb DBG:
SYMCHK: vmwpctrl.dll [10.0.14393.2007 ] PASSED - PDB: vmwpctrl.pdb DBG:
SYMCHK: hvhostsvc.dll [10.0.14393.2007 ] PASSED - PDB: hvhostsvc.pdb DBG:
SYMCHK: vpcivsp.sys [10.0.14393.2214 ] PASSED - PDB: vpcivsp.pdb DBG:
SYMCHK: vhdmp.sys [10.0.14393.2097 ] PASSED - PDB: vhdmp.pdb DBG:
SYMCHK: vmprox.dll [10.0.14393.2007 ] PASSED - PDB: vmprox.pdb DBG:
SYMCHK: vid.dll [10.0.14393.2007 ] PASSED - PDB: vid.pdb DBG:
SYMCHK: Vid.sys [10.0.14393.2007 ] PASSED - PDB: Vid.pdb DBG:
```

There is a limited set of virtualization-related symbols that are currently not available: storvsp.pdb, vhdparser.pdb, passthroughparser.pdb, hvax64.pdb, hvix64.pdb, and hvloader.pdb.

If you have a scenario where you need access to any of these symbols, please let us know in the comments below or through the [Feedback Hub](https://support.microsoft.com/help/4021566/windows-10-send-feedback-to-microsoft-with-feedback-hub-app) app. Please include some detail on the specific scenario which you are looking at. With newer releases, we are evaluating whether we can make even more symbols available. 

Alles Gute,  
Lars

[update 2018-04-26]: symbols for vid.sys, vid.dll, and vmprox.dll are now available as well -- updated the post to include them as well.
