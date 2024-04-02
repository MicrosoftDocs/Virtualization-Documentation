---
title: Quick Create handles emoji in virtual machine names and splices them into simple Unicode
description: Blog post that discusses the Quick Create option's emoji implementation and how they can be spliced into Unicode.
author: scooley
ms.author: scooley
date: 2017-02-03 02:11:37
ms.date: 03/20/2019
categories: hyper-v
---
# Fun Fact: Quick Create handles emoji in virtual machine names and splices them into simple Unicode

I was playing with Windows 10’s on screen keyboard and discovered the emoticons section. Specifically, I found this awesome set of cat emojis. <!--[![clip_image001\[10\]](https://msdnshared.blob.core.windows.net/media/2017/02/clip_image00110_thumb.png)](https://msdnshared.blob.core.windows.net/media/2017/02/clip_image00110.png)--> WindowsKitty definitely needed to be a VM Name. It even has a laptop! Luckily, it turns out, the Quick Create option we added recently handles emoji beautifully. <!--[![clip_image001\[5\]](https://msdnshared.blob.core.windows.net/media/2017/02/clip_image0015_thumb.png)](https://msdnshared.blob.core.windows.net/media/2017/02/clip_image0015.png)--> Not only does the VM name look great in Quick Create with the Windows 10 emoji, Windows also splices them into simpler Unicode representations for Hyper-V Manager and the file system. I was really enjoying seeing what the simplified Unicode would be – in this case, cat + computer. <!--[![clip_image001\[14\]](https://msdnshared.blob.core.windows.net/media/2017/02/clip_image00114_thumb.png)](https://msdnshared.blob.core.windows.net/media/2017/02/clip_image00114.png)--> Which begs the question, how do emoji VM names look in PowerShell? <!--[![clip_image001\[16\]](https://msdnshared.blob.core.windows.net/media/2017/02/clip_image00116_thumb.png)](https://msdnshared.blob.core.windows.net/media/2017/02/clip_image00116.png)--> Unfortunately, not so good – maybe someday. In conclusion, if you don’t need PowerShell scripting (or love referencing VMs via GUID) maybe emoji names are for you. It makes me smile, at least. For further reading, checkout [this blog post](https://blogs.windows.com/windowsexperience/2016/08/04/project-emoji-the-complete-redesign/) about how Windows 10 rethinks how we treat emoji. Have fun! Sarah
