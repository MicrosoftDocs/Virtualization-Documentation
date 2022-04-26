---
title:      "Hyper-V Replica Kerberos Error"
author: mattbriggs
ms.author: mabrigg
ms.date: 02/13/2013
date:       2013-02-13 22:55:00
categories: hvr
description: Hyper-V Replica Kerberos Error
---
# Kerberos Error in Hyper-V Replica

David is one of our Premier Field Engineers and he approached us with an interesting problem where the customer was encountering a Kerberos error when trying to create a replication relationship. On first glance, the setup looked very straight forward and all our standard debugging steps did not reveal anything suspicious. The error which was being encountered was "Hyper-V failed to authenticate using Kerberos authentication" and "The connection with the server was terminated abnormally (0x00002EFE)". 

David debugged the issue further and captured his experience and solution in this blog post -[ http://blogs.technet.com/b/davguents_blog/archive/2013/02/07/the-case-of-the-unexplained-windows-server-2012-replica-kerberos-errors-0x8009030c-0x00002efe.aspx.](https://blogs.technet.com/b/davguents_blog/archive/2013/02/07/the-case-of-the-unexplained-windows-server-2012-replica-kerberos-errors-0x8009030c-0x00002efe.aspx " http://blogs.technet.com/b/davguents_blog/archive/2013/02/07/the-case-of-the-unexplained-windows-server-2012-replica-kerberos-errors-0x8009030c-0x00002efe.aspx") This is a good read if you are planning to use Kerberos based authentication.
