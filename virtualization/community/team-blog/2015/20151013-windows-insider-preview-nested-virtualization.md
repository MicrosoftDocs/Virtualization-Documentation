---
title: Windows Insider Preview - Nested Virtualization
description: Learn more about the upcoming build release that supports nested virtualization in a Hyper-V virtual machine.
author: mattbriggs
ms.author: mabrigg
date:       2015-10-13 12:55:00
ms.date: 10/13/2015
categories: hyper-v
---
# Windows Insider Preview - Nested Virtualization

Earlier in the year, we announced that we will be building nested virtualization so that people could run [Hyper-V Containers ](/b/server-cloud/archive/2015/04/08/microsoft-announces-new-container-technologies-for-the-next-generation-cloud.aspx)in Hyper-V virtual machines. In preparation for the first public preview of Hyper-V Containers, we are releasing a preview of nested virtualization. This feature allows you to run Hyper-V in a virtual machine (note that this is Hyper-V on Hyper-V only… other hypervisors will fail). Although Hyper-V Containers have not been released yet, for now you can try out this feature with Hyper-V virtual machines. 

### Build 10565 -- It is a very early preview

Yesterday, we announced the release of [build 10565](http://blogs.windows.com/windowsexperience/2015/10/12/announcing-windows-10-insider-preview-build-10565/) to Windows Insiders on the Fast ring. This build contains an early preview of nested virtualization. When I say it is an “early” preview, I mean it – there are plenty of known issues, and there is functionality which we still need to build. We wanted to share this feature with Insiders as soon as possible though, even if that meant things are still rough around the edges. This post will give a quick overview of what nested virtualization is, and briefly cover how it works. The end of this post will explain how to enable it, so you can try it out. **Please read the “known issues” section before trying this feature.** **documentation available here:<https://msdn.microsoft.com/virtualization/hyperv_on_windows/user_guide/nesting>**

## What is nested virtualization?

In essence, this feature virtualizes certain hardware features that are required to run a hypervisor in a virtual machine. Hyper-V relies on hardware virtualization support (e.g. Intel VT-x and AMD-V) to run virtual machines. Typically, once Hyper-V is installed, the hypervisor hides this capability from guest virtual machines, preventing guests virtual machines from installing Hyper-V (and many other hypervisors, for that matter). Nested virtualization exposes hardware virtualization support to guest virtual machines. This allows you to install Hyper-V in a guest virtual machine, and create more virtual machines “within” that underlying virtual machine. In the image below, you can see a host machine running a virtual machine, which in turn is running its own guest virtual machine. This is made possible by nested virtualization. Behold, three levels of Cortana! [![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/nestedVM.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/nestedVM.png)

## Under the hood

Consider the diagram below, which shows the “normal” (i.e. non-nested) case. The Hyper-V hypervisor takes full control of virtualization extensions (orange arrow), and does not expose them to the guest OS. ![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/nestedDiagram.png) Contrast this with the nested diagram below. In this case, Hyper-V has been configured to expose virtualization extensions to its guest VM. A guest VM can take advantage of this, and install its own hypervisor. It can then run its own guest VMs. [![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/nestedDiagram2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/nestedDiagram2.png)

## Known issues: important!

Like I said earlier – this is still just a “preview” of this feature. Obviously, this feature should not be used in production environments. Below is a list of known issues: 

  * **Both hypervisors need to be the latest versions of Hyper-V. Other hypervisors will not work. Windows Server 2012R2, or even builds prior to 10565 will not work.**
  * Once nested virtualization is enabled in a VM, the following features are no longer compatible with that VM. These actions will either fail, or cause the virtual machine not to start if it is hosting other virtual machines:


  * Dynamic memory must be OFF. This will prevent the VM from booting.
  * Runtime memory resize will fail.
  * Applying checkpoints to a running VM will fail.
  * Live migration will fail -- in other words, a VM which hosts other VMs cannot be live migrated.
  * Save/restore will fail. **Note:** these features still work in the “innermost” guest VM. The restrictions only apply to the first layer VM.


  * Once nested virtualization is enabled in a VM, MAC spoofing must be enabled for networking to work in its guests.
  * Hosts with Device Guard enabled cannot expose virtualization extensions to guests. You must first disable VBS in order to preview nested virtualization.
  * Hosts with Virtualization Based Security (VBS) enabled cannot expose virtualization extensions to guests. You must first disable VBS in order to preview nested virtualization.
  * This feature is currently Intel-only. Intel VT-x is required.
  * Beware: nested virtualization requires a good amount of memory. I managed to run a VM in a VM with 4 GB of host RAM, but things were tight.



## How to enable nested virtualization

**Step 1: Create a VM** **Step 2: Run the[ enablement script](https://github.com/Microsoft/Virtualization-Documentation/blob/master/hyperv-tools/Nested/Enable-NestedVm.ps1)** Given the configuration requirements (e.g. dynamic memory must be off), we’ve tried to make things easier by providing [a PowerShell script](https://github.com/Microsoft/Virtualization-Documentation/blob/master/hyperv-tools/Nested/Enable-NestedVm.ps1). This script will check your configuration, change anything which is incorrect (with permission), and enable nested virtualization for a VM. Note that the VM must be off. 

Invoke-WebRequest https://raw.githubusercontent.com/Microsoft/Virtualization-Documentation/master/hyperv-tools/Nested/Enable-NestedVm.ps1 -OutFile ~/Enable-NestedVm.ps1 ~/Enable-NestedVm.ps1 -VmName <VmName>

**Step 3: Install Hyper-V in the guest** From here, you can install Hyper-V in the guest VM. 

Invoke-Command -VMName "myVM" -ScriptBlock { Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online; Restart-Computer }

**Step 4: Create nested VMs**

## Give us feedback!

If you discover any issues, or have any suggestions, please consider submitting feedback with the Windows Feedback app, through the [virtualization forums](https://social.technet.microsoft.com/Forums/windowsserver/En-us/home?forum=winserverhyperv), or through [GitHub](https://github.com/Microsoft/Virtualization-Documentation). We are also very interested to hear how people are using nested virtualization. Please tell us about your scenario by dropping us a line at [VirtualPCGuy@microsoft.com](mailto:VirtualPCGuy@microsoft.com). Go build VMs in VMs! Cheers, Theo Thompson **Updated:<https://msdn.microsoft.com/virtualization/hyperv_on_windows/user_guide/nesting> is where you go to find the most up-to-date documentation.**
