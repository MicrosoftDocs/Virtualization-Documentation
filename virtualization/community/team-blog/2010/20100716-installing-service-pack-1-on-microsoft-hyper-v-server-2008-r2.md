---
title:      "Installing Service Pack 1 on Microsoft Hyper-V Server 2008 R2"
description: Install the Beta of Service Pack 1 on Microsoft Hyper-V Server 2008 R2 to get the new capabilities of Dynamic Memory and RemoteFX.
author: scooley
ms.author: scooley
date:       2010-07-16 13:09:00
ms.date: 07/16/2010
categories: calista-technologies
---
# Installing Service Pack 1 on Microsoft Hyper-V Server 2008 R2

**** With the release of Beta of Service Pack 1 for Windows Server 2008 R2 a number of you have asked about Service Pack 1 for the standalone [Microsoft Hyper-V Server 2008 R2](https://www.microsoft.com/download/details.aspx?id=20196), and whether the new capabilities of Dynamic Memory and RemoteFX will be available for it. Absolutely, both Dynamic Memory and [RemoteFX](/virtualization/community/team-blog/2010/20100317-explaining-microsoft-remotefx) have been developed for Microsoft Hyper-V Server 2008 R2 as well.  

In order to get these capabilities for the Microsoft Hyper-V Server 2008 R2, you will need to install the Beta of Service Pack 1 on Microsoft Hyper-V Server 2008 R2. Note that the first wave of the Service pack installer is only in 5 languages (English, French, German, Japanese and Spanish), so if you try and apply the package to Microsoft Hyper-V Server 2008 R2 (which has 11 language packs installed by default) you will rightly see the following screen


It’s pretty simple to uninstall these language packs to thereafter install the Service pack. In order to uninstall the language packs, there is nifty utility included (lpksetup.exe). Launch this from an administrator’s command prompt and select “Uninstall display languages”.  

On the next screen, select the all languages other than the five (English, French, German, Japanese and Spanish). Of course if you want to save some additional disk space, you can uninstall other languages as well and leave just the language that you use in your environment, Click next and let the tool do its job. Thereafter you can apply Service Pack 1. Enjoy!!

Vijay Tewari

Principal Program Manager, Windows Server Virtualization
