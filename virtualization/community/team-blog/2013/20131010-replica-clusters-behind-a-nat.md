---
title:      "Replica Clusters behind a NAT"
author: sethmanheim
ms.author: mabrigg
ms.date: 10/10/2013
categories: hvr
description: Reaching the Replica server in a port based NAT environment.
---
# How to Redirect Traffic with a NAT

When a Hyper-V Replica Broker is configured in your DR site to accept replication traffic, Hyper-V along with Failover Clustering intelligently percolates these settings to all the nodes of the clusters. A network listener is started in each node of the cluster on the configured port.

<!-- [![TN Blogs FS image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1425.image_thumb_1B90E806.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2627.image_22AD93CD.png) -->

While this seamless configuration works for a majority of our customers, we have heard from customers on the need to bring up the network listener in different ports in **each** of the replica server (eg: port 8081 in R1.contoso.com, port 8082 in R2.contoso.com and so on). One such scenario is around placing a NAT in front of the Replica cluster which has port based rules to redirect traffic to appropriate servers. 

Before going any further, a quick refresher on how the placement logic and traffic redirection happens in Hyper-V Replica. 

1) When the primary server contacts the Hyper-V Replica Broker, it (the broker) finds a replica server on which the replica VM can reside and returns the FQDN of the replica server (eg: R3.contoso.com) and the port to which the replication traffic needs to be sent.

2) Any subsequent communication happens between the primary server and the replica server (R3.contoso.com) without the Hyper-V Replica Broker’s involvement.

3) If the VM migrates from R3.contoso.com to R2.contoso.com, the replication between the primary server and R3.contoso.com fails as the VM is unavailable on R3.contoso.com. After retrying a few time, the primary server contacts the Hyper-V Replica Broker indicating that it is unable to find the VM on the replica server (R3.contoso.com). In response, the Hyper-V Replica broker looks into the cluster and returns the information that the replica-VM now resides in R2.contoso.com. It also provides the port number as part of this response. Replication is now established to R2.contoso.com. 

It’s worth calling out that the above steps happen without any manual intervention.

In a NAT environment where port-based-address translation is used (i.e traffic is routed to a particular server based on the destination ports) the above communication mechanism fails. This is due to the fact that the network listener on each of the servers (R1, R2,..Rn.contoso.com) comes up on the **same port**. As the Hyper-V Replica broker returns the same port number in each of it’s response (to the primary server), any incoming request which hits the NAT server cannot be uniquely identified.

Needless to say, if there is an one to one mapping between the ‘public’ IP address exposed by the NAT and the ‘private’ IP address of the servers (R1, R2…Rn.contoso.com), the default configuration works fine.

So, how do we address this problem – Consider the following 3 node cluster with the following names and IP address: R1.contoso.com @ 192.168.1.2, R2.contoso.com @ 192.168.1.3 and R3.contoso.com @ 192.168.1.4.

1) Create the Hyper-V Replica Broker resource using the following cmdlets with a static IP address of your choice (192.168.1.5 in this example)
    
    
    $BrokerName = “HVR-Broker”
    
    
    Add-ClusterServerRole -Name $BrokerName –StaticAddress 192.168.1.5
    
    
    Add-ClusterResource -Name “Virtual Machine Replication Broker” -Type "Virtual Machine Replication Broker" -Group $BrokerName
    
    
    Add-ClusterResourceDependency “Virtual Machine Replication Broker” $BrokerName
    
    
     
    
    
    Start-ClusterGroup $BrokerName

2) **Hash table of server name, port:** Create a hash table map table of the server name and the port on which the listener should come up in the particular server. 
    
    
    $portmap=@{"R1.contoso.com"=8081; “R2.contoso.com"=8082; "R3.contoso.com"=8003, “HVR-Broker.contoso.com”=8080}

3) Enable the replica server to receive replication traffic by providing the hash table as an input 
    
    
    Set-VMReplicationServer -ReplicationEnabled $true -ReplicationAllowedFromAnyServer $true 
    
    
    -DefaultStorageLocation "C:\ClusterStorage\Volume1" 
    
    
    -AllowedAuthenticationType Kerberos
    
    
    -KerberosAuthenticationPortMapping $portmap

4) **NAT Table:** Configure the NAT device with the same mapping as provided in the enable replication server cmdlet. The below picture is applicable for a RRAS based NAT device – similar configuration can be done in any vendor of your choice. The screen shot below captures the mapping for the Hyper-V Replica Broker. Similar mapping needs to be done for each of the replica servers.

<!-- [![Image from TN Blogs FS](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1680.image_thumb_728E2FB8.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5751.image_37A46C3E.png) -->

5) Ensure that the primary server can resolve the replica servers and broker to the public IP address of the NAT device and ensure that the appropriate firewall rules have been enabled.

That’s it – you are all set! Replication works seamlessly as before and now you have the capability to reach the Replica server in a port based NAT environment.
