---
layout:     post
title:      "Error 0x80090303 when enabling replication"
date:       2014-02-06 16:00:00
categories: hvr
---
When trying to enable replication on one of my VMs in my lab setup, I encountered the following error – **_Hyper-V failed to authenticate the Replica server <server name> using Kerberos authentication. Error: The specified target is unknown or unreachable (0x80090303)._**

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image3_thumb_1E7D8BC1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image3_3F023AC2.png)

Needless to say, I was able to reach the replica server ( _prb2.hvrlab.com_ in my case), firewall settings in the replica server looked ok and I was able to TS and login to the replica server as well. As the error message indicated that the failure was encountered when authenticating the replica server, I decided to check the event viewer logs on the replica server. A couple of errors caught my eye:

(1) SPN registration failures

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_5654F146.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_6B43E308.png)

(2) This was followed by an error message which indicated that the authentication had failed

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_37A0980C.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_3A46C30C.png)

I was getting somewhere, so I ran the “setspn –l” command to list down the currently registered SPNs for the computer and the Hyper-V Replica entry was conspicuously absent. 

I restarted the vmms service and when I re-ran the command, I could see the following (set of correct) entries

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_7C746E53.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_699AC947.png)

I have seen the SPN registration (b.t.w the following TechNet wiki gives more info on SPN registration <http://social.technet.microsoft.com/wiki/contents/articles/1340.hyper-v-troubleshooting-event-id-14050-vmms.aspx>) failures due to intermittent network blips. There are retry semantics to ensure that the SPN registration succeeds but there could be corner cases (like my messed up lab setup) where a manual intervention _may_ be required to make quicker progress. I also stumbled upon a SPN wiki article: <http://social.technet.microsoft.com/wiki/contents/articles/717.service-principal-names-spns-setspn-syntax-setspn-exe.aspx> which gives more info on how to manually register the SPN. I didn’t require the info today, but it’s a good read nevertheless. 

After fixing the replica server, the enable replication call went through as expected. Back to work…
