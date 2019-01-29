---
title:      "PSA&#58; VMs with saved state from builds 10560-10567 will not restore on 10568 and above."
date:       2015-10-30 11:30:00
categories: hyper-v
---
Windows Insiders might hit a bug if they try to restore a VM with recent saved state. This is especially true for VMs created on Windows 8.1 and Windows 10 hosts. We recommend that you take action before upgrading past 10567.

 **Problem**

Windows Insiders will not be able to restore VMs on build 10568 and above if the following conditions are met:

  1. The VM is configuration version 5 or 6.2. All other configuration versions are OK. Versions 5 and 6.2 are typically created on Windows 8.1/10 hosts. (You can check the configuration version by looking at the “Configuration Version” column in Hyper-V Manager.)
  2. The VM has saved state which was generated from builds 10560 through 10567



**Workaround**

If you haven’t upgraded past 10567, we recommend that you shut down your VMs before upgrading. You will then be able to start your VMs as usual after the upgrade.  If the upgrade is already complete, you must delete the saved state before starting the VM.

 **Note: Microsoft Emulator for Windows 10 Mobile**

If you use the Emulator for Windows 10 Mobile and are affected by this bug, we recommend that you delete the affected VMs and let Visual Studio recreate them on next launch.

Blog brought to you by 

Theo Thompson
