---
title: Create gMSAs for Windows containers
description: How to create Group Managed Service Accounts (gMSAs) for Windows containers.
keywords: docker, containers, active directory, gmsa, group managed service account, group managed service accounts
author: rpsqrd
ms.date: 01/03/2019
ms.topic: how-to
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 9e06ad3a-0783-476b-b85c-faff7234809c
---
# Create gMSAs for Windows containers

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
Add-ADGroupMember -Identity "WebApp01Hosts" -Members "ContainerHost01$", "ContainerHost02$", "ContainerHost03$"
```

We recommend you create separate gMSA accounts for your dev, test, and production environments.

## Prepare your container host

Each container host that will run a Windows container with a gMSA must be domain joined and have access to retrieve the gMSA password.

1. Join your computer to your Active Directory domain.
2. Ensure your host belongs to the security group controlling access to the gMSA password.
3. Restart the computer so it gets its new group membership.
4. Set up [Docker Desktop for Windows 10](https://docs.docker.com/docker-for-windows/install/) or [Docker for Windows Server](https://docs.docker.com/install/windows/docker-ee/).
5. (Recommended) Verify the host can use the gMSA account by running [Test-ADServiceAccount](https://docs.microsoft.com/powershell/module/activedirectory/test-adserviceaccount). If the command returns **False**, follow the [troubleshooting instructions](gmsa-troubleshooting.md#make-sure-the-host-can-use-the-gmsa).

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

    If you want to save the file to another directory, use the `-Path` parameter:

    ```powershell
    New-CredentialSpec -AccountName WebApp01 -Path "C:\MyFolder\WebApp01_CredSpec.json"
    ```

    You can also create a credential spec that includes additional gMSA accounts if you're running a service or process as a secondary gMSA in the container. To do that, use the `-AdditionalAccounts` parameter:

    ```powershell
    New-CredentialSpec -AccountName WebApp01 -AdditionalAccounts LogAgentSvc, OtherSvc
    ```

    For a full list of supported parameters, run `Get-Help New-CredentialSpec -Full`.

4. You can show a list of all credential specs and their full path with the following cmdlet:

    ```powershell
    Get-CredentialSpec
    ```

## Next steps

Now that you've set up your gMSA account, you can use it to:

- [Configure apps](gmsa-configure-app.md)
- [Run containers](gmsa-run-container.md)
- [Orchestrate containers](gmsa-orchestrate-containers.md)

If you run into any issues during setup, check our [troubleshooting guide](gmsa-troubleshooting.md) for possible solutions.

## Additional resources

- To learn more about gMSAs, see the [group Managed Service Accounts overview](https://docs.microsoft.com/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview).
- For a video demonstration, watch our [recorded demo](https://youtu.be/cZHPz80I-3s?t=2672) from Ignite 2016.
