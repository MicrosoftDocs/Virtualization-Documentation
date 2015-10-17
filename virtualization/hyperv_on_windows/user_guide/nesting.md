ms.ContentId: a772cbbf-f825-4465-b048-0ca066e4ded7
title: Insiders - Nesting Hyper-V

# Windows Insiders Preview - Nested Virtualization

> **Note:** This feature is only available to Windows Insiders running Build 10565 or later.  
  It is an early preview with no performance or stability guarantees.
  
  If you run into issues, please report them through the Windows feedback app, the [virtualization forums](https://social.technet.microsoft.com/Forums/windowsserver/En-us/home?forum=winserverhyperv), or through [GitHub](https://github.com/Microsoft/Virtualization-Documentation).

Nested virtualization is running virtualization inside a virtualized environment.  In other words, nesting allows you to run the Hyper-V server role inside a virtual machine.

## Enable nested virtualization

1. Create a virtual machine -- [instructions here](../quick_start/walkthrough_create_vm.md).

2. Run this script on the Hyper-V host.
  
  In this early preview, nesting comes with a few configuration requirements.  To make things easier, those requirements are set using this PowerShell script.
  
  The script will check your configuration, change anything which is incorrect (with permission), and enable nested virtualization for the specified virtual machine.
  
  ``` PowerShell
  Invoke-WebRequest https://raw.githubusercontent.com/Microsoft/Virtualization-Documentation/master/hyperv-tools/Nested/Enable-NestedVm.ps1 -OutFile ~/Enable-NestedVm.ps1 
  ~/Enable-NestedVm.ps1 -VmName <VmName>
  ```

3. Install Hyper-V in the virtual machine

  ``` PowerShell
  Invoke-Command -VMName "myVM" -ScriptBlock { Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online; Restart-Computer }
  ```
  
4. Create nested virtual machines!

## How does this work?
Hyper-V relies on hardware virtualization support (e.g. Intel VT-x and AMD-V) to run virtual machines. Typically, once Hyper-V is installed, the hypervisor hides this capability from guest virtual machines, preventing guests virtual machines from installing Hyper-V (and many other hypervisors, for that matter).

Nested virtualization exposes hardware virtualization support to guest virtual machines. This allows you to install Hyper-V in a guest virtual machine, and create more virtual machines “within” that underlying virtual machine.

In the image below, you can see a host machine running a virtual machine, which in turn is running its own guest virtual machine. This is made possible by nested virtualization. Behold, three levels of Cortana!