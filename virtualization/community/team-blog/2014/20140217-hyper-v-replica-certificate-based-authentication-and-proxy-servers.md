---
title:      "Hyper-V Replica Certificate based authentication and Proxy servers"
author: mattbriggs
ms.author: mabrigg
ms.date: 02/17/2014
categories: hvr
description: This article explains how to resolve errors while using Hyper-V Replica Certificate based authentication and Proxy servers.
---
# Hyper-V Replica Errors

Continuing from where we left [off](https://blogs.technet.com/b/virtualization/archive/2014/02/09/proxy-server-on-primary-site.aspx), I have a small lab deployment which consists of a AD, DNS, Proxy server (Forefront TMG 2010 on WS 2008 R2 SP1), primary servers and replica servers. When the primary server is behind the proxy (forward proxy) and when I tried to enable replication using certificate based authentication, I got the following error message: _The handle is in the wrong state for the requested operation (0x00002EF3)_

[![Error 0x00002EF3](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_3E561634.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_6A708274.png)

That didn’t convey too much, did it? Fortunately I had _netmon_ running in the background and the only set of network traffic which was seen was between the primary server and the proxy. A particular HTTP response caught my eye:

[![H T T P response](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_584EF7B8.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_36CD3778.png)

The highlighted text indicated that the proxy was terminating the connection and returning a ‘Bad gateway’ error. Closer look at the TMG error log indicated that the error was encountered during https-inspect state. 

After some bing’ing of the errors and the pieces began to emerge. When HTTPS inspection is enabled, the TMG server terminates the connection and establishes a new connection (in our case to the replica server) acting as a trusted man-in-the-middle. This doesn’t work for Hyper-V Replica as we mutually authenticate the primary and replica server endpoints. To work around the situation, I disabled HTTPS inspection in the proxy server

[![H T T P S inspection disabled in proxy server](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_2D9B3EFB.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_72B17B80.png)

and things worked as expected. The primary server was able to establish the connection and replication was on track.
