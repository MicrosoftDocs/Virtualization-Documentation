---
title:      "Configure your Replica server to receive replication traffic from specific primary server(s)"
date:       2012-04-09 06:57:00
categories: hvr
---
Note: Update on 8th July 2012: This **cmdlets and UI** used in this article is applicable **only** for Windows Server "8" Beta. For Windows Server 2012 RC and beyond, see the updated post @ <http://blogs.technet.com/b/virtualization/archive/2012/07/08/hyper-v-replica-authorization-entries-windows-server-2012-rc.aspx>

 

Posting this article on behalf of **Rahul Razdan,** who is a PM with the Window Server Hyper-V team.  

 

As part of setting up a Replica server  in Windows Server  “8”  Beta, you can choose to receive replication traffic from authorized primary server(s)/clusters. This post explains how to configure this setting and the use cases for the same. We will also learn how to group authorized servers into ‘trust zones’ in this post. 

## Authorization

For better control and security, it is recommended to specify the list of authenticated servers that can replicate rather than allowing replication traffic from any authenticated server. While enabling a Replica server, there are two sets of inputs which are required - Authentication and Authorization. 

[![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/7455.image002.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/7455.image002.png)

When allowing replication from specific servers, each entry in the list is called an "authorization entry". An authorization entry contains:

·         Server(s) that are allowed to replicate ( **Primary Server** )

·         Default location where the Replica virtual hard disk files is to be created ( **Storage Location** )

·         Tag to group a set of such allowed primary servers into a trust zone ( **Security Tag** ). 

### Primary Server

The primary server can be one of the following: 

 

·         A single server identified by the Fully Qualified Domain Name (FQDN) (e.g., R2.constoso.com)

 

·         FQDN using wild-card (*.advertisement.contoso.com). Wild-card is supported only in the first octet, e.g., "*.advertisement.*", but not "advertisement*" 

 

·       If the primary server is part of a cluster, you should specify the FQDN of the CAP (Client Access Point) of the Hyper-V Replica Broker of the primary side cluster. This allows you to add or remove nodes from the primary cluster without having to change the authorization entry in the Replica server.

### Storage Location

The storage location specifies the folder where the virtual hard disk files for the Replica virtual machines will be created. If the Replica server is part of a cluster, then only a CSV or SMB file path can be provided. 

If the storage location for an authorization entry is changed **after** a replica VM has been created, only subsequent replica VMs will be created in the new location. 

###  Security Tag

A security tag needs to be specified for each authorization entry. A group of primary servers, with the same security tag can be considered to be part of a “trust zone”.

 

How is this useful? Hyper-V Replica allows replication to continue seamlessly when virtual machines are migrated either on the primary server/cluster or Replica server/cluster. Hence the replication traffic for a given Replica virtual machine cannot be tied **only** to the server that enabled replication of the virtual machine. 

 

For the Replica server to allow replication traffic for a Replica virtual machine from a set of primary servers (the servers amongst which the primary virtual machine can move), those set of primary servers should be grouped into the same trust zone i,e the same security tag. 

[![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0640.image003.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0640.image003.jpg)

The security tag can be used for another scenario - in the above picture, servers in **“ Trust Zone 2”** (say, security tag "TZ-2") will be able to send replication traffic for Replica virtual machines that were created by any of the servers in that trust zone. A server in **“ Trust Zone 2”** will **not** be able to send replication traffic for a Replica virtual machine that was created by a server in **“ Trust Zone 1”** (say, security tag "TZ-1"). This will ensure that in case a server from trust zone 2 gets compromised, the attacker cannot use replication to tamper the Replica virtual machine belonging to **“ Trust Zone 1”**.

 

Security tag is a plain text, and can be created on the fly. No meta-data needs to be created for the same.

**** 

**** 

**Using Powershell**

  * ****To add a new authorization entry




**New-VMReplicationAuthorizationEntry** -AllowedPrimaryServer  < _Server to be authorized_ > -ReplicaStorageLocation < _Location where Replica files should be created_ > -SecurityTag < _Tag_ >

Example: 

**New-VMReplicationAuthorizationEntry** -AllowedPrimaryServer *.constoso.com -ReplicaStorageLocation E:\Replica -SecurityTag Finance

  * To remove an existing authorization entry




**Remove-VMReplicationAuthorizationEntry** -AllowedPrimaryServer < _authorized primary server_ > 

Example:

**Remove-VMReplicationAuthorizationEntry** -AllowedPrimaryServer *.constoso.com

 

  * To add authorization entries, the "AllowAnyServer" property on the server should be set to FALSE. 




**Set-VMReplicationServer** -AllowAnyServer $FALSE

 

  * To query the current authorization entries, use the following cmdlet:




**Get-VMReplicationAuthorizationEntry**
