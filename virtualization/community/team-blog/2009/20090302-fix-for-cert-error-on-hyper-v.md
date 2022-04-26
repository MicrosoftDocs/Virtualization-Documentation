---
title:      "Fix for Cert Error on Hyper-V"
description: A certificate error can occur for those of you running WS08 Hyper-V and connect using vmconnect. This error results in the inability to start or connect to VMs running on WS08 Hyper-V or MS Hyper-V Server 2008.
author: scooley
ms.author: scooley
date:       2009-03-02 20:08:00
ms.date: 03/02/2009
categories: hyper-v

---

# Fix for Cert Error on Hyper-V

Bryon over at the [Windows Server Division blog](https://blogs.technet.com/windowsserver/ "Windows Server Div blog") pointed out a certificate error that can occur for those of you running WS08 Hyper-V and connect using vmconnect. The cert error results in the inability to start or connect to VMs running on WS08 Hyper-V or MS Hyper-V Server 2008. Here's an excerpt: 

**Symptoms and resolution:**

§  You may be unable to start or connect to virtual machines running on Windows Server 2008 or Microsoft Hyper-V Server 2008. This occurs when connecting using vmconnect.  Connections made using Remote Desktop won't be affected.

§  KB Article [967902](https://support.microsoft.com/default.aspx?scid=kb;EN-US;967902) has been created that details the symptoms and resolution.  This KB article provides a direct link to download the quickfix to resolve this error.

 

**Important Notes:**

§  Though this error may occur, the Hyper-V service will continue to operate.   Neither the Hyper-V host nor the running virtual machines will go offline.

§  It is not expected that this issue can be exploited for malicious purposes.

§  Customers running Windows Server 2008 R2 Hyper-V beta won’t experience this error.

  Patrick
