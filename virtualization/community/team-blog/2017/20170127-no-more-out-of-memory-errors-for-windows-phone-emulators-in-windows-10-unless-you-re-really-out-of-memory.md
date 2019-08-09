---
title:      "No more &#34;out of memory&#34; errors for Windows Phone emulators in Windows 10 (unless you're really out of memory)"
date:       2017-01-27 20:24:48
categories: hyper-v
---
For those of you who run emulators in Visual Studio, you may be familiar with an annoying error: [![1A742E040AD543ACAF235D67681F6656](https://msdnshared.blob.core.windows.net/media/2017/01/1A742E040AD543ACAF235D67681F6656_thumb3.png)](https://msdnshared.blob.core.windows.net/media/2017/01/1A742E040AD543ACAF235D67681F6656_thumb3.png) It periodically pops up even when task manager reports enough available memory – this is especially true for machines with less than 8GB RAM. Most of the time, it’s because there genuinely isn’t enough memory available but sometimes it’s because of Hyper-V’s root memory reserve (discussed in [KB2911380](https://support.microsoft.com/en-us/help/2911380/-not-enough-memory-error-message-and-windows-phone-8-emulator-does-not-start-in-windows-8.1)). This blog will tell you what the root memory reserve is, why it exists, and why you shouldn’t need it on Windows 10 starting in build 15002 (original announcement [here](https://blogs.technet.microsoft.com/virtualization/2017/01/10/cool-new-things-for-hyper-v-on-desktop/)). I also wrote a [mini script](https://github.com/Microsoft/Virtualization-Documentation/tree/live/hyperv-tools/root-memory-reserve) to clear the registry key that controls root memory reserve if you think it may be set on your system. 

### So, What is the root memory reserve and why is it there?

Root memory reserve is the memory Hyper-V sets aside to make sure there will always be enough available for the host to run well. We change Hyper-V host memory management periodically based on feedback and new technology (things like dynamic memory and changes in clustering). The root memory reserve is only one piece of that equation and even calculating that piece has several factors. ********Modifying it is not supported** ****** but there is still a registry key available for times when the default isn’t appropriate for one reason or another. [KB2962295](https://support2.microsoft.com/kb/2962295) basically describes measuring, monitoring, and modifying the root reserve. [KB2911380](https://support.microsoft.com/en-us/help/2911380/-not-enough-memory-error-message-and-windows-phone-8-emulator-does-not-start-in-windows-8.1) tells you how to manually set it. And now I’m here to tell you to remove it! 

### 

### Why you don't need root memory reserve any more.

We stopped using a root memory reserve in favor of other memory management tools in Windows 10. The things that make it necessary are unique to server environments (clustering, service level agreements…). However, while the default memory management settings on server are now different from Hyper-V on Windows, if root reserve is set on Windows 10 Hyper-V will respect it -- you won’t see any of the memory management changes we made. Which is why now is the time to clear that custom root memory reserve.   Cheers, Sarah
