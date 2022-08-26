---
title: Introducing VMConnect dynamic resize
description: Blog post that introduces and describes the resize display option when in a session in Virtual Machine Connection.
author: scooley
ms.author: scooley
date: 2017-01-27 20:59:02
ms.date: 03/20/2019
categories: hyper-v
ms.service: virtual-machines
---

# Introducing VMConnect dynamic resize

Starting in the latest Insider's build, you can resize the display for a session in Virtual Machine Connection just by dragging the corner of the window. <!---[![dynamic_resize](https://msdnshared.blob.core.windows.net/media/2017/01/dynamic_resize.gif)](https://msdnshared.blob.core.windows.net/media/2017/01/dynamic_resize.gif)--> When you connect to a VM, you'll still see the normal options which determine the size of the window and the resolution to pass to the virtual machine: <!--[![vmconnectclassic](https://msdnshared.blob.core.windows.net/media/2017/01/vmconnectCLASSIC.png)](https://msdnshared.blob.core.windows.net/media/2017/01/vmconnectCLASSIC.png)--> Once you log in, you can see that the guest OS is using the specified resolution, in this case 1366 x 768. <!--[![vmconnect4](https://msdnshared.blob.core.windows.net/media/2017/01/vmconnect4.png)](https://msdnshared.blob.core.windows.net/media/2017/01/vmconnect4.png)--> Now, if we resize the window, the resolution in the guest OS is automatically adjusted. Neat! <!--[![dynamic_resize](https://msdnshared.blob.core.windows.net/media/2017/01/dynamic_resize.gif)](https://msdnshared.blob.core.windows.net/media/2017/01/dynamic_resize.gif)--> Additionally, the system DPI settings are passed to the VM. If I change my scaling factor on the host, the VM display will scale as well. There are 2 requirements for dynamic resizing to work: 

  * You must be running in **Enhanced session mode**
  * You must be fully **logged in** to the guest OS (it won't work on the lockscreen)

  This remains a work in progress, so we would love to hear your thoughts. -Andy        
