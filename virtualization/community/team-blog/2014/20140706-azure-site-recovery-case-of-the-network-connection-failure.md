---
title:      "Azure Site Recovery – case of the “network connection failure”"
author: sethmanheim
ms.author: mabrigg
ms.date: 07/06/2014
date:       2014-07-06 21:55:00
categories: asr
description: This article discusses the network connection error in Azure Site Recovery.
---
# Network connection failure error

**Luís Caldeira** is one of our early adopters who had pinged us with an interesting error. Thanks for reaching out to us Luís and sharing the details of your setup. I am sure this article will come handy to folks who hit this error at some point.

Some days back, Luís sent us a mail informing that his enable-protection workflow was consistently failing with a “network connection failure” error message. He indicated that he had followed the steps listed in the tutorial. He had:

  * Setup SCVMM 2012 R2

  * Created the Site Recovery vault, uploaded the required certificate

  * Installed & configured the **Microsoft Azure Site Recovery Provider** in the VMM server

  * Registered the VMM server

  * And finally installed the **Microsoft Azure Recovery Services** agent in **each** of his Hyper-V servers.




He was able to view his on-prem cloud in the Azure portal and could configure protection policies on it as well. However, when he tried to enable protection on a VM, the workflow failed and he saw the following set of tasks in the portal:

<!--[![Tasks in the portal](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_522E0D64.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_22DA0729.png)-->

Clicking on ‘Error Details’ showed the following information:

<!--[![Information after clicking Error Details](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_3BFD1374.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_4EAF7C7A.png) -->

Hmm, not too helpful? Luís thought as much as he reached out to us with the information through our internal DL. We did some basic debugging by looking at the Hyper-V VMMS event viewer logs and the Microsoft Azure Recovery Services event viewer log. Both of them pointed to a failure in the network with the following error message”

<!--[![Error message](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_2874D535.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_62618770.png)-->

A snip of the error message (after removing the various Id’s): “ ** _The error message read “Could not replicate changes for virtual machine VMName due to a network communication failure. (Virtual Machine ID VMid, Data Source ID sourceid, Task ID taskid)”_**

The message was less cryptic but still did not provide a solution. The network connection from the Hyper-V server seemed okay as Luis was able to access different websites from the box. He was able to TS into other servers, firewall looked ok and inbound connection looked good as well. The Azure portal was able to enumerate the VMs running on the Hyper-V server – but the enable replication call was failing. 

You are bound to see more granular error messages @ _C:\Program Files\Microsoft Azure Recovery Services Agent\Temp\CBEngineCurr.errlog_   and we proceeded to inspect that file. The trace indicated that the name resolution to the Azure service happened as expected but “the remote server was timing out (or) connection did not happen”

Ok, so DNS was ruled out as well. We asked Luis to help us understand the network elements in his setup and he indicated that he had a TMG proxy server. We logged into the proxy server and enabled real time logs in the TMG proxy server. We retried the workflow and the workflow promptly failed – but interestingly, the proxy server did not register any traffic blip. That was definitely odd. So browsing from the server worked but connection to the service was failed. Hmm.

But the lack of activity in the TMG server indicated a local failure atleast. We were not dealing with an Azure service side issue and that ruled out 50% of potential problems. At a high level, the agent (Microsoft Azure Recovery Services) which is installed in the Hyper-V server acts as a “data mover” to Azure. It is also responsible for all the authentication and connection management when sending replica data to Azure. This component was built on top of a previously released component of the Windows Azure Online Backup solution and enhanced to support this scenario.

The good news is that the agent is quite network savvy and has a bunch of configurations to tinker around. One such configuration is the proxy server which is got by opening the “Microsoft Azure Backup” mmc. Click on the “Change properties” in the Actions menu. 

<!--[![Change properties in the Actions menu](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_2BABDE7F.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_3C244F7A.png)-->

We clicked on the “Proxy configuration” tab to set the proxy details in Luís’s setup. 

<!--[![Proxy configuration tab](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_780602D1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_217A4412.png)-->

After setting the proxy server, we retried the workflow… and it failed yet again. Luis then indicated that he was using an authenticated proxy server. Now things got interesting – as the Microsoft Azure Recovery Services agent runs in System context (unlike, say IE which runs in the user context), we needed to set the proxy authentication parameters. In the same proxy configuration page as above, we now provided the user id and password. 

<!--[![User id and password](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_126B174B.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_7EBB9D05.png)-->

Now, when we retried the replication - voila! the workflow went through and initial replication was on it’s way. The same can be done using the Set-OBMachineSetting cmdlet (<https://technet.microsoft.com/library/hh770409.aspx>)

Needless to say, once the issue was fixed, Luís took the product out on a full tour and he totally loved it (ok, I just made up the last part). 

I encourage you to try out ASR and share your feedback. It’s extremely easy to set it up and provides a great cloud based DR solution.

You can find more details about the service @ <https://azure.microsoft.com/services/site-recovery/>. The documentation explaining the end to end workflows is available. And if you have questions when using the product, post them @ <https://social.msdn.microsoft.com/Forums/windowsazure/en-US/home?forum=hypervrecovmgr> or in this blog. You can also share your feedback on your favorite features/gaps @ <https://feedback.azure.com/forums/256299-site-recovery>
