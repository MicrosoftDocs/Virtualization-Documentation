---
title:      "Using SMB shares with Hyper-V Replica"
author: sethmanheim
ms.author: sethm
description: Using SMB shares with Hyper-V Replica
ms.date: 06/14/2013
date:       2013-06-14 05:48:00
categories: hvr
---
# Using SMB shares with Hyper-V Replica

SMB is getting a lot of attention with Windows Server 2012, and we've had questions from a few customers regarding the inter-play between SMB shares and Hyper-V Replica. In this post we'll share our experience around setting up and using various configurations involving SMB shares and Hyper-V Replica. The issue we were expecting to run into is the apparent lack of authorization to use the SMB share, when using remote management.

In all the scenarios that are investigated, we will start from a remote management node ( _mgmtnode.contoso.com_ ). We will try to set up the scenario from this management node, and work through the errors encountered. In order to visualize what this means, all the scenarios will look roughly like this:

<!-- [![001 base architecture](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2313.001-base-architecture_thumb_62A79642.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6661.001-base-architecture_654DC142.png) -->

## Scenario #1: Single Replica server with SMB share

#### The building blocks

  * A single Hyper-V server ( _aashish-server.contoso.com_ ) on the Replica site
  * A single server ( _aashish-server3.contoso.com_ ) hosting an SMB share <!--\\\aashish-server3\Replica-Site--> that will be used to store the Replica VMs.
  * A single remote management server ( _mgmtnode.contoso.com_ )



#### Setting up the infrastructure

To start with, we will try using the Hyper-V Manager UI. On the management node ( _mgmtnode.contoso.com_ ), open the Hyper-V Manager UI and add the server _aashish-server_ on the left-side pane using _"Connect to Server…"_. Now enable _aashish-server_ as a Replica server using the Hyper-V Settings on the right-side pane. As expected, we run into an error:

<!--[![002 single server UI failure](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6076.002-single-server-UI-failure_thumb_7A880E7A.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2870.002-single-server-UI-failure_3F9E4B00.png) -->

The error encountered is _"Failed to add authorization entry. Unable to open specified location to store Replica files '\\\aashish-server3\Replica-Site\'. Error: 0x80070005 (General access denied error)."_ , and it is not a very helpful error message. Hopefully this blog can help alleviate that situation.

#### Fixing the error

While the standard answer to fixing this error will be to setup constrained delegation, this is not something that is always optimal. Yes, the core issue is around delegation of credentials when there is an additional hop ( _mgmtnode_ – > _aashish-server_ – > _aashish-server3_ ). However, depending on your setup and how often you plan to change the Replica server settings, there are simpler solutions.

  1. Remote into _aashish-server_ directly as set up the Replica server – this eliminate the hop that causes problems. With just one server to configure, this will be the simplest solution for your needs.
  2. Use CredSSP and PowerShell to delegate credentials and set up the Replica server, and we will be exploring this later in the blog post. This is an excellent option for users where:
    1. No domain controller access is possible. 
    2. No Remote access is possible.
    3. The Windows Server UI is not present on any node other than the management node.
  3. Set up constrained delegation in your domain controller. This option has been explored extensively by others and there is ample material on this available [online](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj134187(v=ws.11)).



## Scenario #2: Multiple Replica servers (unclustered) with SMB share

For all practical purposes this is like the single Replica server scenario discussed above, except that you will have to remote into each server and setup replication. At even 5 servers, this is a painful exercise. Constrained Delegation starts to look like an increasingly attractive option. Yet, without access to the domain controller perhaps the realistic route is that of CredSSP and PowerShell – and that will be something we will cover in detail in this post.

## Scenario #3: Replica cluster with SMB share

#### The building blocks

  * A failover cluster ( _AAR-130612_ ) on the Replica site having the _.contoso.com_ domain. This consists of two servers ( _aashish-s1_ , _aashish-s2_ ), and a Replica Broker ( _AARBrk-130612_ ). The broker can be present on either node, but in this example we will assume that it resides on _aashish-s2_. 
  * A single server ( _aashish-server3.contoso.com_ ) hosting an SMB share <!--[\\\aashish-server3\Replica-Site]--> that will be used to store the Replica VMs.
  * A single remote management server ( _mgmtnode.contoso.com_ )


<!-- [![003 cluster](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4705.003-cluster_thumb_72958D7A.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/0574.003-cluster_753BB87A.png) -->

#### Setting up the infrastructure

As with the non-clustered scenarios, you will run into the _General access denied error_ when you use the Failover Cluster UI to change the replication settings. 

<!-- [![004 replicabroker failure](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4174.004-replicabroker-failure_thumb_2E7740D2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5287.004-replicabroker-failure_1AC7C68D.png) -->

Trying this through PowerShell will give you a similar error:

Set-VMReplicationServer : Failed to add authorization entry. Unable to open specified location to store Replica files '\\\aashish-server3\Replica-Site'. Error: 0x80070005 (General access denied error). You do not have permission to perform the operation. Contact your administrator if you believe you should have permission to perform this operation.   
At line:1 char:1   
\+ Set-VMReplicationServer -ComputerName AARBrk-130612 -AllowedAuthenticationType ...   
\+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
\+ CategoryInfo : PermissionDenied: (Microsoft.HyperV.PowerShell.VMTask:VMTask) [Set-VMReplicationServer], VirtualizationOperationFailedException   
\+ FullyQualifiedErrorId : AccessDenied,Microsoft.HyperV.PowerShell.Commands.SetReplicationServerCommand   


#### Fixing the error

Although the cluster has multiple nodes, the scenario is similar to that of a single Replica server. When using clusters, it is sufficient to make the changes to the Hyper-V Replica Broker ( _AARBrk-130612_ in this case), and the replication settings will be propagated to the rest of the cluster nodes. So depending on your setup and how often you plan to change the Replica Broker settings, there are a few options to consider:

  1. Remote into the server on which the Replica Broker is running ( _aashish-s2_ in this case), use the Failover Cluster UI and directly set up the Replica – eliminate the hop that is causing problems. In most cases, the replication configuration is a one-time operation, so this could be the simplest solution for your needs.
  2. Remote into __any__ server in the cluster and use the PowerShell command-let _Set-VMReplicationServer._ There is no need to use – _ComputerName_ in the parameters as the command-let itself is cluster-aware.
  3. Use CredSSP and PowerShell to delegate credentials and set this up if options 1 and 2 are not for you.
  4. Set up constrained delegation in your domain controller.



#### Using CredSSP and PowerShell

This option is interesting from many angles. The big attraction is PowerShell; with administrators increasingly moving to PowerShell to automate and manage their infrastructure, getting things done through PowerShell is sometimes more important than through a UI. Just as important is the fact that remoting into a Replica server is not always feasible or advisable – and hence the management node from where all actions are performed. The CredSSP-based solution fits neatly into such a scenario.

For enabling the delegation of credentials, run the following commands on the management node:

  * Enable-WSManCredSSP –Role Client –DelegateComputer aashish-s1.contoso.com
  * Invoke-Command –ComputerName aashish-s1.contoso.com –ScriptBlock { Enable-WSManCredSSP –Role Server }



Once this is done, you follow-up with _Set-VMReplicationServer_ but run on the cluster host that you have just delegated to:

  * Invoke-Command –ComputerName aashish-s1.contoso.com –Authentication Credssp –Credential DOMAIN1\user1 –ScriptBlock { Set-VMReplicationServer …}



where DOMAIN1 and user1 are authenticated on _aashish-s1.contoso.com_. Note that you do not need to use –ComputerName with the Set-VMReplicationServer command because it is cluster aware!

#### Adding a node to this cluster

So what happens if you add a new node to this Replica cluster? No worries! The replication settings are propagated to this node also with no additional steps on your part. If you need to change the replication settings, you can use the same steps outlined without worrying about the new server.

### Concluding note

Hopefully this will set you back on track with Hyper-V Replica and SMB shares. Give this a go and share your experience with us – we would love to hear your feedback! 
