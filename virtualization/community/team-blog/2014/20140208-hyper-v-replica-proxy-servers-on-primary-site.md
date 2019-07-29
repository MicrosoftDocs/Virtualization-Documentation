---
title:      "Hyper-V Replica & Proxy Servers on primary site"
date:       2014-02-08 16:00:00
categories: hvr
---
I was tinkering around with my lab setup which consists of a domain, proxy server, primary and replica servers. There are some gotchas when it comes to Hyper-V Replica and proxy servers and I realized that we did not have any posts around this. So here goes.

If the primary server is behind a proxy server (forward proxy) and if Kerberos based authentication is used to establish a connection between the primary and replica server, you might encounter an error: _Hyper-V cannot connect to the specified Replica server <servername> due to connection timed out. Verify if a network connection exists to the Replica server or if the proxy settings have been configured appropriately to allow replication traffic._

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image4_thumb_10CD0BA5.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image4_3870F71E.png)

I have a **Forefront TMG 2010** acting as a proxy server and the logs in the proxy server 

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_2AAF3CF4.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_387EF23E.png)

I also had _[netmon](http://www.microsoft.com/en-in/download/details.aspx?id=4865)_ running in my primary server and the logs didn’t indicate too much other than for the fact that the connection never made it to the replica server – something happened between the primary and replica server which caused the connection to be terminated. The primary server name in this deployment is prb8.hvrlab.com and the proxy server is w2k8r2proxy1.hvrlab.com. 

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image12_thumb_5A8395A8.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image12_4B4A9C2A.png)

If a successful connection goes through, you will see a spew of messages on netmon 

When I had observed the issue the first time when building the product, I had reached out to the Forefront folks @ Microsoft to understand this behavior. I came to understand that the Forefront TMG proxy server terminates any outbound (or upload) connections whose content length (request header) is > 4GB. 

Hyper-V Replica set a high content length as we expect to transfer large files (VHDs) and it would save us the effort to re-establish the connection each time. A closer inspection of a POST request shows the content length which is being set by Hyper-V Replica (ahem, ~500GB)

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_2A00A3C1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_6F16E046.png)

The proxy server returns a _what-uh?_ response in the form of a bad-request

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_7CA42F52.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_4FF8E4C8.png)

That isn’t superhelpful by any means and the error message unfortunately isn’t too specific either. But now you know the reason for the failure – the proxy server terminates the connection the connection request and it never reaches the replica server. 

So how do we work around it – there are two ways (1) Bypass the proxy server (2) Use cert based authentication (another blog for some other day).

The ability to by pass the proxy server is provided only in PowerShell in the _ByPassProxyServer_ parameter of the _Enable-VMReplication_ cmdlet - <https://technet.microsoft.com/library/jj136049.aspx>. When the flag is enabled, the request (for lack of better word) bypasses the proxy server. Eg:
    
    
    Enable-VMReplication -vmname NewVM5 -AuthenticationType Kerberos -ReplicaServerName prb2 -ReplicaServerPort 25000 -BypassProxyServer $true
    
    
     
    
    
    Start-VMInitialReplication -vmname NewVM5

This is not available in the Hyper-V Manager or Failover Cluster Manager UI. It’s supported only in PowerShell (and WMI). Running the above cmdlets will create the replication request and start the initial replication.
