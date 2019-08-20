---
title: Group Managed Service Accounts for Windows containers
description: Group Managed Service Accounts for Windows containers
keywords: docker, containers, active directory, gmsa
author: rpsqrd
ms.date: 08/02/2019
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 9e06ad3a-0783-476b-b85c-faff7234809c
---
# Group Managed Service Accounts for Windows containers

Windows-based networks commonly use Active Directory (AD) to facilitate authentication and authorization between users, computers, and other network resources. Enterprise application developers often design their apps to be AD-integrated and run on domain-joined servers to take advantage of Integrated Windows Authentication, which makes it easy for users and other services to automatically and transparently sign in to the application with their identities.

Although Windows containers cannot be domain joined, they can still use Active Directory domain identities to support various authentication scenarios.

To achieve this, you can configure a Windows container to run with a [group Managed Service Account](https://docs.microsoft.com/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview) (gMSA), which is a special type of service account introduced in Windows Server 2012 designed to allow multiple computers to share an identity without needing to know its password.

When you run a container with a gMSA, the container host retrieves the gMSA password from an Active Directory domain controller and gives it to the container instance. The container will use the gMSA credentials whenever its computer account (SYSTEM) needs to access network resources.

This article explains how to start using Active Directory group managed service accounts with Windows containers.

## Prerequisites

To run a Windows container with a group managed service account, you will need the following:

- An Active Directory domain with at least one domain controller running Windows Server 2012 or later. There are no forest or domain functional level requirements to use gMSAs, but the gMSA passwords can only be distributed by domain controllers running Windows Server 2012 or later. For more information, see [Active Directory requirements for gMSAs](https://docs.microsoft.com/windows-server/security/group-managed-service-accounts/getting-started-with-group-managed-service-accounts#BKMK_gMSA_Req).
- Permission to create a gMSA account. To create a gMSA account, you'll need to be a Domain Administrator or use an account that has been delegated the *Create msDS-GroupManagedServiceAccount objects* permission.
- Access to the internet to download the CredentialSpec PowerShell module. If you're working in a disconnected environment, you can [save the module](https://docs.microsoft.com/powershell/module/powershellget/save-module?view=powershell-5.1) on a computer with internet access and copy it to your development machine or container host.

## One-time preparation of Active Directory

If you have not already created a gMSA in your domain, you'll need to generate the Key Distribution Service (KDS) root key. The KDS is responsible for creating, rotating, and releasing the gMSA password to authorized hosts. When a container host needs to use the gMSA to run a container, it will contact the KDS to retrieve the current password.

To check if the KDS root key has already been created, run the following PowerShell cmdlet as a domain administrator on a domain controller or domain member with the AD PowerShell tools installed:

```powershell
Get-KdsRootKey
```

If the command returns a key ID, you're all set and can skip ahead to the [create a group managed service account](#create-a-group-managed-service-account) section. Otherwise, continue on to create the KDS root key.

In a production environment or test environment with multiple domain controllers, run the following cmdlet in PowerShell as a Domain Administrator to create the KDS root key.

```powershell
# For production environments
Add-KdsRootKey -EffectiveImmediately
```

Although the command implies the key will be effective immediately, you will need to wait 10 hours before the KDS root key is replicated and available for use on all domain controllers.

If you only have one domain controller in your domain, you can expedite the process by setting the key to be effective 10 hours ago.

>[!IMPORTANT]
>Don't use this technique in a production environment.

```powershell
# For single-DC test environments ONLY
Add-KdsRootKey -EffectiveTime (Get-Date).AddHours(-10)
```

## Create a group Managed Service Account

Every container that uses Integrated Windows Authentication needs at least one gMSA. The primary gMSA is used whenever apps running as a System or a Network Service access resources on the network. The name of the gMSA will become the container's name on the network, regardless of the hostname assigned to the container. Containers can also be configured with additional gMSAs, in case you want to run a service or application in the container as a different identity from the container computer account.

When you create a gMSA, you also create a shared identity that can be used simultaneously across many different machines. Access to the gMSA password is protected by an Active Directory Access Control List. We recommend creating a security group for each gMSA account and adding the relevant container hosts to the security group to limit access to the password.

Finally, since containers don't automatically register any Service Principal Names (SPN), you will need to manually create at least a host SPN for your gMSA account.

Typically, the host or http SPN is registered using the same name as the gMSA account, but you may need to use a different service name if clients access the containerized application from behind a load balancer or a DNS name that's different from the gMSA name.

For example, if the gMSA account is named "WebApp01" but your users access the site at `mysite.contoso.com`, you should register a `http/mysite.contoso.com` SPN on the gMSA account.

Some applications may require additional SPNs for their unique protocols. For instance, SQL Server requires the `MSSQLSvc/hostname` SPN.

The following table lists the required attributes for creating a gMSA.

|gMSA property | Required value | Example |
|--------------|----------------|--------|
|Name | Any valid account name. | `WebApp01` |
|DnsHostName | The domain name appended to the account name. | `WebApp01.contoso.com` |
|ServicePrincipalNames | Set at least the host SPN, add other protocols as necessary. | `'host/WebApp01', 'host/WebApp01.contoso.com'` |
|PrincipalsAllowedToRetrieveManagedPassword | The security group containing your container hosts. | `WebApp01Hosts` |

Once you've decided on the name for your gMSA, run the following cmdlets in PowerShell to create the security group and gMSA.

> [!TIP]
> You'll need to use an account that belongs to the **Domain Admins** security group or has been delegated the **Create msDS-GroupManagedServiceAccount objects** permission to run the following commands.
> The [New-ADServiceAccount](https://docs.microsoft.com/powershell/module/addsadministration/new-adserviceaccount?view=win10-ps) cmdlet is part of the AD PowerShell Tools from [Remote Server Administration Tools](https://aka.ms/rsat).

```powershell
# Replace 'WebApp01' and 'contoso.com' with your own gMSA and domain names, respectively

# To install the AD module on Windows Server, run Install-WindowsFeature RSAT-AD-PowerShell
# To install the AD module on Windows 10 version 1809 or later, run Add-WindowsCapability -Online -Name 'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0'
# To install the AD module on older versions of Windows 10, see https://aka.ms/rsat

# Create the security group
New-ADGroup -Name "WebApp01 Authorized Hosts" -SamAccountName "WebApp01Hosts" -GroupScope DomainLocal

# Create the gMSA
New-ADServiceAccount -Name "WebApp01" -DnsHostName "WebApp01.contoso.com" -ServicePrincipalNames "host/WebApp01", "host/WebApp01.contoso.com" -PrincipalsAllowedToRetrieveManagedPassword "WebApp01Hosts"

# Add your container hosts to the security group
Add-ADGroupMember -Identity "WebApp01Hosts" -Members "ContainerHost01", "ContainerHost02", "ContainerHost03"
```

We recommend you create separate gMSA accounts for your dev, test, and production environments.

## Prepare your container host

Each container host that will run a Windows container with a gMSA must be domain joined and have access to retrieve the gMSA password.

1. Join your computer to your Active Directory domain.
2. Ensure your host belongs to the security group controlling access to the gMSA password.
3. Restart the computer so it gets its new group membership.
4. Set up [Docker Desktop for Windows 10](https://docs.docker.com/docker-for-windows/install/) or [Docker for Windows Server](https://docs.docker.com/install/windows/docker-ee/).
5. (Recommended) Verify the host can use the gMSA account by running [Test-ADServiceAccount](https://docs.microsoft.com/powershell/module/activedirectory/test-adserviceaccount). If the command returns **False**, consult the [troubleshooting](#troubleshooting) section for diagnostic steps.

    ```powershell
    # To install the AD module on Windows Server, run Install-WindowsFeature RSAT-AD-PowerShell
    # To install the AD module on Windows 10 version 1809 or later, run Add-WindowsCapability -Online -Name 'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0'
    # To install the AD module on older versions of Windows 10, see https://aka.ms/rsat

    Test-ADServiceAccount WebApp01
    ```

## Create a credential spec

A credential spec file is a JSON document that contains metadata about the gMSA account(s) you want a container to use. By keeping the identity configuration separate from the container image, you can change which gMSA the container uses by simply swapping the credential spec file, no code changes necessary.

The credential spec file is created using the [CredentialSpec PowerShell module](https://aka.ms/credspec) on a domain-joined container host.
Once you've created the file, you can copy it to other container hosts or your container orchestrator.
The credential spec file does not contain any secrets, such as the gMSA password, since the container host retrieves the gMSA on behalf of the container.

Docker expects to find the credential spec file under the **CredentialSpecs** directory in the Docker data directory. In a default installation, you'll find this folder at `C:\ProgramData\Docker\CredentialSpecs`.

To create a credential spec file on your container host:

1. Install the RSAT AD PowerShell tools
    - For Windows Server, run **Install-WindowsFeature RSAT-AD-PowerShell**.
    - For Windows 10, version 1809 or later, run **Add-WindowsCapability -Online -Name 'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0'**.
    - For older versions of Windows 10, see <https://aka.ms/rsat>.
2. Run the following cmdlet to install the latest version of the [CredentialSpec PowerShell module](https://aka.ms/credspec):

    ```powershell
    Install-Module CredentialSpec
    ```

    If you don't have internet access on your container host, run `Save-Module CredentialSpec` on an internet-connected machine and copy the module folder to `C:\Program Files\WindowsPowerShell\Modules` or another location in `$env:PSModulePath` on the container host.

3. Run the following cmdlet to create the new credential spec file:

    ```powershell
    New-CredentialSpec -AccountName WebApp01
    ```

    By default, the cmdlet will create a cred spec using the provided gMSA name as the computer account for the container. The file will be saved in the Docker CredentialSpecs directory using the gMSA domain and account name for the filename.

    You can create a credential spec that includes additional gMSA accounts if you're running a service or process as a secondary gMSA in the container. To do that, use the `-AdditionalAccounts` parameter:

    ```powershell
    New-CredentialSpec -AccountName WebApp01 -AdditionalAccounts LogAgentSvc, OtherSvc
    ```

    For a full list of supported parameters, run `Get-Help New-CredentialSpec`.

4. You can show a list of all credential specs and their full path with the following cmdlet:

    ```powershell
    Get-CredentialSpec
    ```

## Configure your application to use the gMSA

In the typical configuration, a container is only given one gMSA account which is used whenever the container computer account tries to authenticate to network resources. This means your app will need to run as **Local System** or **Network Service** if it needs to use the gMSA identity.

### Run an IIS app pool as Network Service

If you're hosting an IIS website in your container, all you need to do to leverage the gMSA is set your app pool identity to **Network Service**. You can do that in your Dockerfile by adding the following command:

```dockerfile
RUN %windir%\system32\inetsrv\appcmd.exe set AppPool DefaultAppPool -processModel.identityType:NetworkService
```

If you previously used static user credentials for your IIS App Pool, consider the gMSA as the replacement for those credentials. You can change the gMSA between dev, test, and production environments and IIS will automatically pick up the current identity without having to change the container image.

### Run a Windows service as Network Service

If your containerized app runs as a Windows service, you can set the service to run as **Network Service** in your Dockerfile:

```dockerfile
RUN sc.exe config "YourServiceName" obj= "NT AUTHORITY\NETWORK SERVICE" password= ""
```

### Run arbitrary console apps as Network Service

For generic console apps that are not hosted in IIS or Service Manager, it is often easiest to run the container as **Network Service** so the app automatically inherits the gMSA context. This feature is available as of Windows Server version 1709.

Add the following line to your Dockerfile to have it run as Network Service by default:

```dockerfile
USER "NT AUTHORITY\NETWORK SERVICE"
```

You can also connect to a container as Network Service on a one-off basis with `docker exec`. This is particularly useful if you're troubleshooting connectivity issues in a running container when the container does not normally run as Network Service.

```powershell
# Opens an interactive PowerShell console in the container (id = 85d) as the Network Service account
docker exec -it --user "NT AUTHORITY\NETWORK SERVICE" 85d powershell
```

## Run a container with a gMSA

To run a container with a gMSA, provide the credential spec file to the `--security-opt` parameter of [docker run](https://docs.docker.com/engine/reference/run):

```powershell
# For Windows Server 2016, change the image name to mcr.microsoft.com/windows/servercore:ltsc2016
docker run --security-opt "credentialspec=file://contoso_webapp01.json" --hostname webapp01 -it mcr.microsoft.com/windows/servercore:ltsc2019 powershell
```

>[!IMPORTANT]
>On Windows Server 2016 versions 1709 and 1803, the hostname of the container must match the gMSA short name.

In the previous example, the gMSA SAM Account Name is "webapp01," so the container hostname is also named "webapp01."

On Windows Server 2019 and later, the hostname field is not required, but the container will still identify itself by the gMSA name instead of the hostname, even if you explicitly provide a different one.

To check if the gMSA is working correctly, run the following cmdlet in the container:

```powershell
# Replace contoso.com with your own domain
PS C:\> nltest /sc_verify:contoso.com

Flags: b0 HAS_IP  HAS_TIMESERV
Trusted DC Name \\dc01.contoso.com
Trusted DC Connection Status Status = 0 0x0 NERR_Success
Trust Verification Status = 0 0x0 NERR_Success
The command completed successfully
```

If the Trusted DC Connection Status and Trust Verification Status are not `NERR_Success`, check the [Troubleshooting](#troubleshooting) section for tips on how to debug the problem.

You can verify the gMSA identity from within the container by running the following command and checking the client name:

```powershell
PS C:\> klist get krbtgt

Current LogonId is 0:0xaa79ef8
A ticket to krbtgt has been retrieved successfully.

Cached Tickets: (2)

#0>     Client: webapp01$ @ CONTOSO.COM
        Server: krbtgt/webapp01 @ CONTOSO.COM
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40a10000 -> forwardable renewable pre_authent name_canonicalize
        Start Time: 3/21/2019 4:17:53 (local)
        End Time:   3/21/2019 14:17:53 (local)
        Renew Time: 3/28/2019 4:17:42 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0
        Kdc Called: dc01.contoso.com

[...]
```

To open PowerShell or another console app as the gMSA account, you can ask the container to run under the Network Service account instead of the normal ContainerAdministrator (or ContainerUser for NanoServer) account:

```powershell
# NOTE: you can only run as Network Service or SYSTEM on Windows Server 1709 and later
docker run --security-opt "credentialspec=file://contoso_webapp01.json" --hostname webapp01 --user "NT AUTHORITY\NETWORK SERVICE" -it mcr.microsoft.com/windows/servercore:ltsc2019 powershell
```

When you're running as Network Service, you can test network authentication as the gMSA by trying to connect to SYSVOL on a domain controller:

```powershell
# This command should succeed if you're successfully running as the gMSA
PS C:\> dir \\contoso.com\SYSVOL


    Directory: \\contoso.com\sysvol


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----l        2/27/2019   8:09 PM                contoso.com
```

## Orchestrate containers with gMSA

In production environments, you'll often use a container orchestrator to deploy and manage your apps and services. Each orchestrator has its own management paradigms and is responsible for accepting credential specs to give to the Windows container platform.

When you're orchestrating containers with gMSAs, make sure that:

> [!div class="checklist"]
> * All container hosts that can be scheduled to run containers with gMSAs are domain joined
> * The container hosts have access to retrieve the passwords for all gMSAs used by containers
> * The credential spec files are created and uploaded to the orchestrator or copied to every container host, depending on how the orchestrator prefers to handle them.
> * Container networks allow the containers to communicate with the Active Directory Domain Controllers to retrieve gMSA tickets

### How to use gMSA with Service Fabric

Service Fabric supports running Windows containers with a gMSA when you specify the credential spec location in your application manifest. You'll need to create the credential spec file and place in the **CredentialSpecs** subdirectory of the Docker data directory on each host so that Service Fabric can locate it. You can run the **Get-CredentialSpec** cmdlet, part of the [CredentialSpec PowerShell module](https://aka.ms/credspec), to verify if your credential spec is in the correct location.

See [Quickstart: Deploy Windows containers to Service Fabric](https://docs.microsoft.com/azure/service-fabric/service-fabric-quickstart-containers) and [Set up gMSA for Windows containers running on Service Fabric](https://docs.microsoft.com/azure/service-fabric/service-fabric-setup-gmsa-for-windows-containers) for more information about how to configure your application.

### How to use gMSA with Docker Swarm

To use a gMSA with containers managed by Docker Swarm, run the [docker service create](https://docs.docker.com/engine/reference/commandline/service_create/) command with the `--credential-spec` parameter:

```powershell
docker service create --credential-spec "file://contoso_webapp01.json" --hostname "WebApp01" <image name>
```

See the [Docker Swarm example](https://docs.docker.com/engine/reference/commandline/service_create/#provide-credential-specs-for-managed-service-accounts-windows-only) for more information about how to use credential specs with Docker services.

### How to use gMSA with Kubernetes

Support for scheduling Windows containers with gMSAs in Kubernetes is available as an alpha feature in Kubernetes 1.14. See [Configure gMSA for Windows pods and containers](https://kubernetes.io/docs/tasks/configure-pod-container/configure-gmsa) for the latest information about this feature and how to test it in your Kubernetes distribution.

## Example uses

### SQL connection strings

When a service is running as Local System or Network Service in a container, it can use Windows Integrated Authentication to connect to a Microsoft SQL Server.

Here is an example of a connection string that uses the container identity to authenticate to SQL Server:

```sql
Server=sql.contoso.com;Database=MusicStore;Integrated Security=True;MultipleActiveResultSets=True;Connect Timeout=30
```

On the Microsoft SQL Server, create a login using the domain and gMSA name, followed by a $. Once you've created the login, you can add it to a user on a database and give it appropriate access permissions.

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

To see it in action, check out the [recorded demo](https://youtu.be/cZHPz80I-3s?t=2672) available from Microsoft Ignite 2016 in the session "Walk the Path to Containerization - transforming workloads into containers."

## Additional resources

- [group Managed Service Accounts overview](https://docs.microsoft.com/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview)
