---
title: Cool new things for Hyper-V on Windows 10
description: Blog post that discusses the Insider build 15002 availability for Fast Ring Windows Insiders and discusses improvements and changes included in the update.
author: scooley
ms.author: scooley
date: 2017-01-10 02:05:14
ms.date: 03/20/2019
categories: hyper-v
---

# Cool new things for Hyper-V on Windows 10

Insider build 15002 is now available for Fast Ring Windows Insiders. In it, you’ll find a few improvements in Hyper-V for Windows 10 users: 

* A new virtual machine Quick Create experience (work in progress).
* More aggressive memory allocation for starting virtual machines. This is especially useful for anyone using emulators in Visual Studio or static memory virtual machines.

Check it out and send feedback! 

## Virtual machine Quick Create

<!--[![msohtmlclipclip_image001](https://msdnshared.blob.core.windows.net/media/2017/01/msohtmlclipclip_image001_thumb.png)](https://msdnshared.blob.core.windows.net/media/2017/01/msohtmlclipclip_image001.png)--> Hyper-V Manager has a new single-page wizard that makes it faster and easier to create virtual machines. You can access it through a new “Quick Create…” button (1). Quick Create focuses on getting the guest operating system up and running. It automatically creates virtual hardware necessary to run the guest operating system (2). Including a virtual switch! Since many desktop users see internet in the virtual machine as essential, we added the option to create an external switch (3) directly to the new virtual machine experience. **Quick Create is still under active development – try it out and please leave feedback!**

## Changes in memory allocation

Starting in build 15002, we changed how Hyper-V on Windows 10 allocates memory for starting virtual machines. In the past, when you started a virtual machine, Hyper-V allocated memory very conservatively. As an example, we maintained reserved memory for the Hyper-V host (root memory reserve) so even if task manager showed 2 GB available memory, Hyper-V wouldn’t use all of it for starting virtual machines. Hyper-V also wouldn’t ask for applications to release unused memory (trim). Conservative memory allocation makes sense in a hosting environment where very few applications run on the Hyper-V host and the ones that do are high priority – it doesn’t make much sense for Windows 10 and desktop virtualization. In Windows 10, you’re probably running several applications (web browsers, text editors, chat clients, etc) and most of them will reserve more memory than they’re actively using. With these changes, Hyper-V starts allocating memory in small chunks (to give the operating system a chance to trim memory from other applications) and will use all available memory (no root reserve). Which isn’t to say you’ll never run out of memory but now the amount of memory shown in task manager accurately reflects the amount available for starting virtual machines. **Note:** For people using Hyper-V with device emulators in Visual Studio – the emulator does have overhead so you will need at least 200MB more RAM available than the emulator you’re starting suggests (i.e. a 512MB emulator actually needs closer to 700MB available to start successfully). I’ll post a follow up blog going into more nitty gritty details on this later. Have fun making virtual machines! Cheers, Sarah
