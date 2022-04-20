---
title: What's new in Hyper-V for the Windows 10 Creators Update?
description: Learn about the new Hyper-V features in the Windows 10 Creators Update and how they can help your virtual machine management.
author: mattbriggs
ms.author: mabrigg
date:       2017-04-13 00:21:53
ms.date: 04/13/2017
categories: hyper-v
---
# What's new in Hyper-V for the Windows 10 Creators Update

Microsoft just released the [Windows 10 Creators Update](https://blogs.windows.com/windowsexperience/2017/04/11/whats-new-in-the-windows-10-creators-update). Which means Hyper-V improvements! New and improved features in Creators Update: 

  * Quick Create
  * Checkpoint and Save for nested Hyper-V
  * Dynamic resize for VM Connect
  * Zoom for VM Connect
  * Networking improvements (NAT)
  * Developer-centric memory management

Keep reading for more details. Also, if you want to try new Hyper-V things as we build them, become a [Windows Insider](https://insider.windows.com/). 

#### Faster VM creation with Quick Create

[![clip_image001](https://msdnshared.blob.core.windows.net/media/2017/04/clip_image001_thumb4.png)](https://msdnshared.blob.core.windows.net/media/2017/04/clip_image0016.png) Hyper-V Manager has a new option for quickly and easily creating virtual machines, aptly named “Quick Create”. [Introduced in build 15002](https://blogs.technet.microsoft.com/virtualization/2017/01/10/cool-new-things-for-hyper-v-on-desktop/), Quick Create focuses on getting the guest operating system up and running as quickly as possible -- including creating and connecting to a virtual switch. When we first released Quick Create, there were a number of issues mostly centered on our default virtual machine settings ([read more](https://blogs.technet.microsoft.com/virtualization/2017/01/20/a-closer-look-at-vm-quick-create/)). In response to your feedback, we have updated the Quick Create defaults. Creators Update Quick Create defaults: 

  * Generation: 2
  * Memory: 2048 MB to start, Dynamic Memory enabled
  * Virtual Processors: 4
  * VHD: dynamic resize up to 100GB



#### Checkpoint and save work on nested Hyper-V host

Last year we added the ability to run Hyper-V inside of Hyper-V (a.k.a. nested virtualization). This has been a very popular feature, but it initially came with a number of limitations. We have continued to work on the performance, compatibility and feature integration of nested virtualization. In the Creator update for Windows 10 you can now take checkpoints and saved states on virtual machines that are acting as nested Hyper-V hosts. 

#### Dynamic resize for Enhanced Session Mode VMs

[![dynamic_resize](https://msdnshared.blob.core.windows.net/media/2017/04/dynamic_resize_thumb.gif)](https://msdnshared.blob.core.windows.net/media/2017/04/dynamic_resize.gif) The picture says it all. If you are using Hyper-V’s Enhanced Session Mode, you can dynamically resize your virtual machine. Right now, this is only available to virtual machines that support Hyper-V’s Enhanced Session mode. That includes: 

  * Windows Client: Windows 8.1, Windows 10 and later
  * Windows Server: Windows Server 2012 R2, Windows Server 2016 and later

Read [blog](https://blogs.technet.microsoft.com/virtualization/2017/01/27/introducing-vmconnect-dynamic-resize/) announcement. 

#### Zoom for VM Connect

Is your virtual machine impossible to read? Alternately, do you suffer from scaling issues in legacy applications? **VMConnect** now has the option to adjust **Zoom Level** under the **View** Menu. [![image](https://msdnshared.blob.core.windows.net/media/2017/04/image_thumb302.png)](https://msdnshared.blob.core.windows.net/media/2017/04/image312.png)

#### Multiple NAT networks and IP pinning

NAT networking is vital to both Docker and Visual Studio’s UWP device emulators. When we released Windows Containers, developers discovered number of networking differences between containers on Linux and containers on Windows. Additionally, introducing another common developer tool that uses NAT networking presented new challenges for our networking stack. In the Creators Update, there are two significant improvements to NAT: 

  1. Developers can now use for multiple NAT networks (internal prefixes) on a single host. That means VMs, containers, emulators, et. al. can all take advantage of NAT functionality from a single host.
  2. Developers are also able to build and test their applications with industry-standard tooling directly from the container host using an overlay network driver (provided by the Virtual Filtering Platform (VFP) Hyper-V switch extension) as well as having direct access to the container using the Host IP and exposed port.



#### Improved memory management

Until recently, Hyper-V has allocated memory very conservatively. While that is the right behavior for Windows Server, UWP developers faced out of memory errors starting device emulators from Visual Studio ([read more](https://blogs.technet.microsoft.com/virtualization/2017/01/27/no-more-out-of-memory-errors-for-windows-phone-emulators-in-windows-10-unless-youre-really-out-of-memory/)). In the Creators Update, Hyper-V gives the operating system a chance to trim memory from other applications and uses all available memory. You may still run out of memory, but now the amount of memory shown in task manager accurately reflects the amount available for starting virtual machines. Introduced in [build 15002](https://blogs.technet.microsoft.com/virtualization/2017/01/10/cool-new-things-for-hyper-v-on-desktop/). As always, please send us feedback! Once more, because I can’t emphasize this enough, [become a Windows Insider](https://insider.windows.com/) – almost everything here has benefited from your early feedback. Cheers, Sarah
