---
layout:     post
title:      "Replication Health-Windows Server 2012 R2"
date:       2014-05-05 09:00:36
categories: uncategorized
---
We have made improvements to the way we display Replication Health in Windows Server 2012 R2 to support Extend Replication. If you are new to measuring replication health, I would strongly suggest you to go through this [two part blog series on Interpreting Replication Health](http://blogs.technet.com/b/virtualization/archive/2012/06/15/interpreting-replication-health-part-1.aspx). I would discuss specifically on the additional changes we made in Windows Server 2012 R2.

#### Replication Tab in Replica Site Hyper-V Manager:

Replication tab in Replica Site now shows replication health information for both Primary Replication Relationship and Extended Replication relationship. It neatly captures the Health values separately for both primary and extend replication in a single pane separating them by a line.

[![Replication helath-Tab](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/Replication-helath-Tab_thumb_1AD08CF8.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/Replication-helath-Tab_172FE16A.png)

**Replication Health Screen in Replica Site:**

Replication Health information about Extend Replication can be captured through “ **Extended Replication** ” tab in Replication Health screen. To view Replication Health Screen, go to **Hyper-V Manager/Failover Cluster Manager** and right click on protected VM and choose “ **View Replication Health** ”.

Replication health information about primary replication relationship is shown in “Replication” tab while extended replication screen displays Replication Health information about extend replication. What’s more, Extended Replication tab looks exactly like Replication Health screen in Primary Server to give a consistent view while Replication tab continues to display the content the way it used to. You can even “Reset Statistics” or “Save as CSV file” on a relationship basis. 

[![rep heal-1](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/rep-heal-1_thumb_0DFB583C.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/rep-heal-1_413500F4.png)

[![rep-heal2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/rep-heal2_thumb_7C436FC3.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/rep-heal2_6FB331F6.png)

#### Replication Health through PowerShell:

I can get Replication Health details of Extended Replication through Powershell by setting “ **ReplicationRelationshipType** ” **** parameter to “ **Extended** ”. To view the health of Replication from primary to replica, use the value of “ **Simple** ” as input to ReplicationRelationshipType parameter.

_Measure-VMReplication –VMName <name> -ReplicationRelationshipType Extended_

While we have added support to display extended replication in our UI/PS, getting details about primary replication relationship remain same ![Smile](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/wlEmoticon-smile_300DF6C6.png)
