---
title: Active Directory Service Accounts for Windows Containers
description: Active Directory Service Accounts for Windows Containers
keywords: docker, containers, active directory
author: PatrickLang
ms.date: 11/04/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 9e06ad3a-0783-476b-b85c-faff7234809c
---

# Active Directory Service Accounts for Windows Containers

Users and other services may need to make authenticated connections to your applications and services so you can keep data secure and prevent unauthorized usage. Windows Active Directory (AD) domains natively support both password and certificate authentication. When you build your application or service on a Windows domain-joined host, it uses the identity of the host by default if run as Local System or Network Service. Otherwise, you may configure another AD account for authentication instead.

Although Windows Containers cannot be domain-joined, they can also take advantage of Active Directory domain identities similar to when a device is realm-joined. With Windows Server 2012 R2 domain controllers, we introduced a new domain account called a group Managed Service Account (gMSA) which was designed to be shared by services. By using group Managed Service Accounts (gMSA), Windows Containers themselves and the services they host can be configured to use a specific gMSA as their domain identity. Any service running as Local System or Network Service will use the Windows Container's identity just like they use the domain-joined host's identity today. There is no password or certificate private key stored in the container image that could be inadvertently exposed, and the container can be redeployed to development, test, and production environments without being rebuilt to change stored passwords or certificates. 


# Glossary & References
- [Active Directory](http://social.technet.microsoft.com/wiki/contents/articles/1026.active-directory-services-overview.aspx) is a service used for discovery, search and replication of user, computer, and service account information on Windows. 
  - [Active Directory Domain Services](https://technet.microsoft.com/en-us/library/dd448614.aspx) provide a Windows Active Directory domain(s) used to authenticate computers and users. 
  - Devices are _domain-joined_ when they are a member of Active Directory domain. Domain-joined is a device state which not only provides the device with a domain computer identity, but also lights up various domain-joined services.
  - [Group Managed Service Accounts](https://technet.microsoft.com/en-us/library/jj128431(v=ws.11).aspx) , often abbreviated as gMSA, are a type of Active Directory account that makes it easy to secure services using Active Directory without sharing a password. Multiple machines or containers share the same gMSA as needed to authenticate connections between services.
- _CredentialSpec_ PowerShell Module - This module is used to configure Group Managed Service Accounts to be used with containers. The script module and example steps are available at [windows-server-container-tools](https://github.com/Microsoft/Virtualization-Documentation/tree/live/windows-server-container-tools), see ServiceAccount

# How it Works

Today, group Managed Service Accounts are often used to secure connections between one computer or service to another. The general steps to use one are:

1. Create a gMSA
2. Configure the service to run as the gMSA
3. Give the domain-joined host running the service access to the gMSA secrets in Active Directory
4. Allow access to gMSA on the other service such as a database or file Shares

When the service is launched, the domain-joined host automatically gets the gMSA secrets from Active Directory, and runs the service using that account. Since that service is running as the gMSA, it can access any resources the gMSA is allowed to.

Windows Containers follow a similar process:

1. Create a gMSA. By default, a domain administrator or account operator must do this. Otherwise they can delegate the privileges to create & manage gMSAs to admins who manage services which use them. See [gMSA Getting started](https://technet.microsoft.com/en-us/library/jj128431(v=ws.11).aspx)
2. Give the domain-joined container host access to the gMSA
3. Allow access to gMSA on the other service such as a database or file Shares
4. Use the CredentialSpec PowerShell module from 
[windows-server-container-tools](https://github.com/Microsoft/Virtualization-Documentation/tree/live/windows-server-container-tools) to store settings needed to use the gMSA
5. Start the container with an extra option `--security-opt "credentialspec=..."`

When the container is launched, the installed services running as Local System or Network Service will appear to run as the gMSA. This is similar to how those accounts work on a domain-joined hosts, except a gMSA is used instead of a computer account. 

![Diagram - Service Accounts](media/serviceaccount_diagram.png)


# Example Uses


## SQL Connection Strings
When a service is running as Local System or Network Service in a container, it can use Windows Integrated Authentication to connect to a Microsoft SQL Server.

Example:

```
Server=sql.contoso.com;Database=MusicStore;Integrated Security=True;MultipleActiveResultSets=True;Connect Timeout=30
```

On the Microsoft SQL Server, create a login using the domain and gMSA name, followed by a $. Once the login is created, it can be added to a user on a database and given appropriate access permissions.

Example: 

```sql
CREATE LOGIN "DEMO\WebApplication1$"
    FROM WINDOWS
    WITH DEFAULT_DATABASE = "MusicStore"
GO

USE MusicStore
GO
CREATE USER WebApplication1 FOR LOGIN "DEMO\WebApplication1$"
GO

EXEC sp_addrolemember 'db_datareader', 'WebApplication1'
EXEC sp_addrolemember 'db_datawriter', 'WebApplication1'
```

To see it in action, check out the [recorded demo](https://youtu.be/cZHPz80I-3s?t=2672) available from Microsoft Ignite 2016 in the session "Walk the Path to Containerization - transforming workloads into containers".
