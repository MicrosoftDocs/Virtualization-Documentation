# CredentialSpec PowerShell Module

## Looking for the container identity docs?
The container identity docs have been updated and moved to https://aka.ms/containers/identity.
If you're looking for the old instructions, they've been archived in [old-deployment-steps.md](./old-deployment-steps.md)

## Overview

The CredentialSpec PowerShell module helps Windows Container developers, admins, and orchestrators create credential specification files to run containers with an Active Directory identity.

Credential specs are JSON documents that contain information about the group managed service account (gMSA) that is used when the container computer account needs to access network resources.
By separating the container identity from the image configuration, you are able to use different accounts for the container computer account in your dev, test, and production environments without changing any code.

## Downloads

You can install a digitally signed copy of the CredentialSpec module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/CredentialSpec) by running the following command:

```powershell
Install-Module CredentialSpec
```

If you need to distribute the module to disconnected machines, follow these steps:
1.  On a computer with internet access, save the module to a network share, USB drive, or other media:
    
    ```powershell
    Save-Module CredentialSpec -Path ~\Downloads
    ```

2.  Copy the *CredentialSpec* folder to your disconnected machine. To install the module for all users on the system, copy it to `C:\Windows\System32\WindowsPowerShell\Modules\CredentialSpec`. To install it just for yourself, copy it to `C:\Users\YourName\Documents\WindowsPowerShell\Modules\CredentialSpec`.

3.  Run `Import-Module CredentialSpec` to confirm the module can be located and loaded successfully.

## Usage

To use the CredentialSpec PowerShell module, your computer must meet the following prerequisites:
-   [ ] Windows 10 version 1607/Windows Server 2016 or later
-   [ ] Computer must be joined to an Active Directory domain
-   [ ] [Docker Desktop for Windows 10](https://docs.docker.com/docker-for-windows/install/) or [Docker EE for Windows Server](https://docs.docker.com/install/windows/docker-ee/) must be installed
-   [ ] At least one [group managed service account](https://docs.microsoft.com/en-us/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview) already created in your domain

In its simplest form, the cmdlet takes the name of the gMSA and creates a credential spec file based on that account.
The cmdlet assumes the gMSA is in the same domain as the current computer (not the user's domain).

```powershell
New-CredentialSpec WebApp01
```

If the gMSA belongs to a different domain, you can specify the domain name.
The domain must be trusted by the current computer's domain for the cmdlet to retrieve information about the gMSA.

```powershell
New-CredentialSpec WebApp01 -Domain preprod.contoso.com
```

By default, the cmdlet will save the credential spec in a file named after the gMSA's domain and account names.
You can specify an alternative name (flat name, not a full path) to change this behavior.

```powershell
New-CredentialSpec WebApp01 -FileName dev_webapp01.json
```

You can also specify additional gMSA accounts to be made available to the container.
Only the account given to the `-AccountName` parameter is used by the container computer account.
These additional accounts can be used by IIS App Pools, Windows Services, and any other application that supports running as a gMSA.

```powershell
New-CredentialSpec WebApp01 -AdditionalAccounts 'LogAgentSvc'
```

If additional accounts come from different domains, you can specify them using a hashtable.

```powershell
New-CredentialSpec WebApp01 -AdditionalAccounts @{ AccountName = 'LogAgentSvc'; Domain = 'secinf.contoso.com' }
```

## Documentation
Check out the [Windows Container Identity](https://aka.ms/containers/identity) docs for instructions on how to set up your environment, generate a credential spec, and run a container using an Active Directory identity.

