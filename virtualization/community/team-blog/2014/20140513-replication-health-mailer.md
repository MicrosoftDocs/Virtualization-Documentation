---
title:      "Replication Health Mailer"
author: mattbriggs
ms.author: mabrigg
ms.date: 05/13/2014
date:       2014-05-13 05:13:14
categories: uncategorized
description: This article shares a script used to mail replication health in a cluster in a dashboard format.
---
# Replication Health Mailer

One of our Engineers, **Sangeeth** , has come up with a nifty PowerShell script which mails the replication health in a host or  in a cluster in a nice dashboard format. We thought it would be of help to our customers to get the status of the replicating VMs and their foot print on CPU and in Memory. You can download the script [here.](https://gallery.technet.microsoft.com/Replication-Health-Mailer-4066632c#content)

The sample output from the script looks like this. You can add as many recipients as you wish ![Smile](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/wlEmoticon-smile_2664E472.png)

[![Capture](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/Capture_thumb_3A145EB7.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/Capture_7D5CD626.png)

On a cluster, you can run this script on one of the cluster nodes to get information about all Cluster VMs. You can even run this script to get information from remote host and remote Cluster using “ **HostorClusterName** ” parameter. In case of cluster use **“isCluster** ” parameter to tell the script to get information from Cluster rather than on the local node.

Isn’t it simple and easy to get the replication information about VMs?
