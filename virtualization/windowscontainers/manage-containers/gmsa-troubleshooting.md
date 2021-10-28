---
title: Troubleshoot gMSAs for Windows containers
description: How to troubleshoot Group Managed Service Accounts (gMSAs) for Windows containers.
keywords: docker, containers, active directory, gmsa, group managed service account, group managed service accounts, troubleshooting, troubleshoot
author: rpsqrd
ms.author: jgerend
ms.date: 10/03/2019
ms.topic: troubleshooting
ms.assetid: 9e06ad3a-0783-476b-b85c-faff7234809c
---
# Troubleshoot gMSAs for Windows containers

> Applies to: Windows Server 2022, Windows Server 2019

## Known issues

### Container hostname must match the gMSA name for Windows Server 2016 and Windows 10, versions 1709 and 1803

If you're running Windows Server 2016, version 1709 or 1803, the hostname of your container must match your gMSA SAM Account Name.

When the hostname doesn't match the gMSA name, inbound NTLM authentication requests and name/SID translation (used by many libraries, like the ASP.NET membership role provider) will fail. Kerberos will continue to function normally even if the hostname and gMSA name don't match.

This limitation was fixed in Windows Server 2019, where the container will now always use its gMSA name on the network regardless of the assigned hostname.

### Using a gMSA with more than one container simultaneously leads to intermittent failures on Windows Server 2016 and Windows 10, versions 1709 and 1803

Because all containers are required to use the same hostname, a second issue affects versions of Windows prior to Windows Server 2019 and Windows 10, version 1809. When multiple containers are assigned the same identity and hostname, a race condition may occur when two containers talk to the same domain controller simultaneously. When another container talks to the same domain controller, it will cancel communication with any prior containers using the same identity. This can lead to intermittent authentication failures and can sometimes be observed as a trust failure when you run `nltest /sc_verify:contoso.com` inside the container.

We changed the behavior in Windows Server 2019 to separate the container identity from the machine name, allowing multiple containers to use the same gMSA simultaneously.

### You can't use gMSAs with Hyper-V isolated containers on Windows 10 versions 1703, 1709, and 1803

Container initialization will hang or fail when you try to use a gMSA with a Hyper-V isolated container on Windows 10 and Windows Server versions 1703, 1709, and 1803.

This bug was fixed in Windows Server 2019 and Windows 10, version 1809. You can also run Hyper-V isolated containers with gMSAs on Windows Server 2016 and Windows 10, version 1607.

## General troubleshooting guidance

If you're encountering errors when running a container with a gMSA, the following instructions may help you identify the root cause.

### Domain joined hosts: Make sure the host can use the gMSA

1. Verify the host is domain joined and can reach the domain controller.
2. Install the AD PowerShell Tools from RSAT and run [Test-ADServiceAccount](/powershell/module/activedirectory/test-adserviceaccount) to see if the computer has access to retrieve the gMSA. If the cmdlet returns **False**, the computer does not have access to the gMSA password.

    ```powershell
    # To install the AD module on Windows Server, run Install-WindowsFeature RSAT-AD-PowerShell
    # To install the AD module on Windows 10 version 1809 or later, run Add-WindowsCapability -Online -Name 'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0'
    # To install the AD module on older versions of Windows 10, see https://aka.ms/rsat

    Test-ADServiceAccount WebApp01
    ```

3. If **Test-ADServiceAccount** returns **False**, verify the host belongs to a security group that can access the gMSA password.

    ```powershell
    # Get the current computer's group membership
    Get-ADComputer $env:computername | Get-ADPrincipalGroupMembership | Select-Object DistinguishedName

    # Get the groups allowed to retrieve the gMSA password
    # Change "WebApp01" for your own gMSA name
    (Get-ADServiceAccount WebApp01 -Properties PrincipalsAllowedToRetrieveManagedPassword).PrincipalsAllowedToRetrieveManagedPassword
    ```

4. If your host belongs to a security group authorized to retrieve the gMSA password but is still failing **Test-ADServiceAccount**, you may need to restart your computer to obtain a new ticket reflecting its current group memberships.

### Non-domain-joined hosts: Make sure the host is configured to retrieve the gMSA account

Verify that a plug-in for using gMSA with a non--domain-joined container host is properly installed on the host. Windows does not include a built-in plug-in and requires you to provide a plugin that implements the [ICcgDomainAuthCredentials interface](/windows/win32/api/ccgplugins/nn-ccgplugins-iccgdomainauthcredentials). Installation details will be plug-in specific.

### Check the Credential Spec file

1. Run **Get-CredentialSpec** from the [CredentialSpec PowerShell module](https://aka.ms/credspec) to locate all credential specs on the machine. The credential specs must be stored in the "CredentialSpecs" directory under the Docker root directory. You can find the Docker root directory by running **docker info -f "{{.DockerRootDir}}"**.
2. Open the CredentialSpec file and make sure the following fields are filled out correctly:
    1. **For domain joined container hosts:**
        - **Sid**: the SID of your domain
        - **MachineAccountName**: the gMSA SAM Account Name (don't include full domain name or dollar sign)
        - **DnsTreeName**: the FQDN of your Active Directory forest
        - **DnsName**: the FQDN of the domain to which the gMSA belongs
        - **NetBiosName**: NETBIOS name for the domain to which the gMSA belongs
        - **GroupManagedServiceAccounts/Name**: the gMSA SAM account name (do not include full domain name or dollar sign)
        - **GroupManagedServiceAccounts/Scope**: one entry for the domain FQDN and one for the NETBIOS

        Your input should look like the following example of a complete credential spec:

        ```json
        {
            "CmsPlugins": [
                "ActiveDirectory"
            ],
            "DomainJoinConfig": {
                "Sid": "S-1-5-21-702590844-1001920913-2680819671",
                "MachineAccountName": "webapp01",
                "Guid": "56d9b66c-d746-4f87-bd26-26760cfdca2e",
                "DnsTreeName": "contoso.com",
                "DnsName": "contoso.com",
                "NetBiosName": "CONTOSO"
            },
            "ActiveDirectoryConfig": {
                "GroupManagedServiceAccounts": [
                    {
                        "Name": "webapp01",
                        "Scope": "contoso.com"
                    },
                    {
                        "Name": "webapp01",
                        "Scope": "CONTOSO"
                    }
                ]
            }
        }
        ```

    2. **For non-domain-joined hosts:** In addition to all of the non-domain-joined container host fields, make sure the **"HostAccountConfig"** section is present and that the fields below are defined correctly.
        - **PortableCcgVersion**: This should be set to "1".
        - **PluginGUID**: The COM CLSID for your ccg.exe plug-in. This is unique to the plug-in being used.
        - **PluginInput**: Plug-in specific input for retrieving the user account information from the secret store.

        Your input should look like the following example of a complete credential spec:

        ```json
        {
            "CmsPlugins": [
            "ActiveDirectory"
            ],
            "DomainJoinConfig": {
                "Sid": "S-1-5-21-702590844-1001920913-2680819671",
                "MachineAccountName": "webapp01",
                "Guid": "56d9b66c-d746-4f87-bd26-26760cfdca2e",
                "DnsTreeName": "contoso.com",
                "DnsName": "contoso.com",
                "NetBiosName": "CONTOSO"
            },
            "ActiveDirectoryConfig": {
                "GroupManagedServiceAccounts": [
                    {
                        "Name": "webapp01",
                        "Scope": "contoso.com"
                    },
                    {
                        "Name": "webapp01",
                        "Scope": "CONTOSO"
                    }
                ],
                "HostAccountConfig": {
                    "PortableCcgVersion": "1",
                    "PluginGUID": "{GDMA0342-266A-4D1P-831J-20990E82944F}",
                    "PluginInput": "contoso.com:gmsaccg:<password>"
                }
            }
        }
        ```

3. Verify the path to the credential spec file is correct for your orchestration solution. If you're using Docker, make sure the container run command includes `--security-opt="credentialspec=file://NAME.json"`, where "NAME.json" is replaced with the name output by **Get-CredentialSpec**. The name is a flat file name, relative to the CredentialSpecs folder under the Docker root directory.

### Check the network configuration

#### Check the firewall configuration

If you're using a strict firewall policy on the container or host network, it may block required connections to the Active Directory Domain Controller or DNS server.

| Protocol and port | Purpose |
|-------------------|---------|
| TCP and UDP 53 | DNS |
| TCP and UDP 88 | Kerberos |
| TCP 139 | NetLogon |
| TCP and UDP 389 | LDAP |
| TCP 636 | LDAP SSL |

You may need to allow access to additional ports depending on the type of traffic your container sends to a domain controller.
See [Active Directory and Active Directory Domain Services port requirements](/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/dd772723(v=ws.10)#communication-to-domain-controllers) for a full list of ports used by Active Directory.

#### Check the container host DNS configuration

If you're using gMSA with a domain joined container host, DNS should automatically be configured on the host so it can properly resolve and establish a connection to the domain. If you're using gMSA with a non-domain-joined host, this configuration will not automatically be set. You should verify that the host network is configured so it can resolve the domain. You can check that domain can be resolved from the host using:

```powershell
nltest /sc_verify:contoso.com
```

### Check the container

1. If you're running a version of Windows prior to Windows Server 2019 or Windows 10, version 1809, your container hostname must match the gMSA name. Ensure the `--hostname` parameter matches the gMSA short name (no domain component; for example, "webapp01" instead of "webapp01.contoso.com").

2. Check the container networking configuration to verify the container can resolve and access a domain controller for the gMSA's domain. Misconfigured DNS servers in the container are a common culprit of identity issues.

3. Check if the container has a valid connection to the domain by running the following cmdlet in the container (using `docker exec` or an equivalent):

    ```powershell
    nltest /sc_verify:contoso.com
    ```

    The trust verification should return `NERR_SUCCESS` if the gMSA is available and network connectivity allows the container to talk to the domain. If it fails, verify the network configuration of the host and container. Both need to be able to communicate with the domain controller.

4. Check if the container can obtain a valid Kerberos Ticket Granting Ticket (TGT):

    ```powershell
    klist get krbtgt
    ```

    This command should return "A ticket to krbtgt has been retrieved successfully" and list the domain controller used to retrieve the ticket. If you're able to obtain a TGT but `nltest` from the previous step fails, this may be an indication that the gMSA account is misconfigured. See [check the gMSA account](#check-the-gmsa-account) for more information.

    If you cannot obtain a TGT inside the container, this may indicate DNS or network connectivity issues. Ensure the container can resolve a domain controller using the domain DNS name and that the domain controller is routable from the container.

5. Ensure your app is [configured to use the gMSA](gmsa-configure-app.md). The user account inside the container doesn't change when you use a gMSA. Rather, the System account uses the gMSA when it talks to other network resources. This means your app will need to run as Network Service or Local System to leverage the gMSA identity.

    > [!TIP]
    > If you run `whoami` or use another tool to identify your current user context in the container, you won't see the gMSA name itself. This is because you always sign in to the container as a local user instead of a domain identity. The gMSA is used by the computer account whenever it talks to network resources, which is why your app needs to run as Network Service or Local System.

### Check the gMSA account

1. If your container seems to be configured correctly but users or other services are unable to automatically authenticate to your containerized app, check the SPNs on your gMSA account. Clients will locate the gMSA account by the name at which they reach your application. This may mean that you'll need additional `host` SPNs for your gMSA if, for example, clients connect to your app via a load balancer or a different DNS name.

2. For using gMSA with a domain joined container host, ensure the gMSA and container host belong to the same Active Directory domain. The container host will not be able to retrieve the gMSA password if the gMSA belongs to a different domain.

3. Ensure there is only one account in your domain with the same name as your gMSA. gMSA objects have dollar signs ($) appended to their SAM account names, so it's possible for a gMSA to be named "myaccount$" and an unrelated user account to be named "myaccount" in the same domain. This can cause issues if the domain controller or application has to look up the gMSA by name. You can search AD for similarly named objects with the following command:

    ```powershell
    # Replace "GMSANAMEHERE" with your gMSA account name (no trailing dollar sign)
    Get-ADObject -Filter 'sAMAccountName -like "GMSANAMEHERE*"'
    ```

4. If you've enabled unconstrained delegation on the gMSA account, ensure that the [UserAccountControl attribute](https://support.microsoft.com/help/305144/how-to-use-useraccountcontrol-to-manipulate-user-account-properties) still has the `WORKSTATION_TRUST_ACCOUNT` flag enabled. This flag is required for NETLOGON in the container to communicate with the domain controller, as is the case when an app has to resolve a name to a SID or vice versa. You can check if the flag is configured correctly with the following commands:

    ```powershell
    $gMSA = Get-ADServiceAccount -Identity 'yourGmsaName' -Properties UserAccountControl
    ($gMSA.UserAccountControl -band 0x1000) -eq 0x1000
    ```

    If the above commands return `False`, use the following to add the `WORKSTATION_TRUST_ACCOUNT` flag to the gMSA account's UserAccountControl property. This command will also clear the `NORMAL_ACCOUNT`, `INTERDOMAIN_TRUST_ACCOUNT`, and `SERVER_TRUST_ACCOUNT` flags from the UserAccountControl property.

    ```powershell
    Set-ADObject -Identity $gMSA -Replace @{ userAccountControl = ($gmsa.userAccountControl -band 0x7FFFC5FF) -bor 0x1000 }
    ```

### Non-domain-joined container hosts: Use event logs to identify configuration issues

Event logging for using gMSA with non-domain-joined container hosts can be used to identify configuration issues. Events are logged in the Microsoft-Windows-Containers-CCG log file and can be found in the Event Viewer under Applications and Services Logs\Microsoft\Windows\Containers-CCG\Admin. If you export this log file from the container host to reader it, you must have the containers feature enabled on the device where you are trying to read the log file and you must be on a Windows version that supports using gMSA with non-domain-joined container hosts.

#### Events and Descriptions

|Event Number| Event Text | Description |
|--------------|----------------|--------|
| 1 | Container Credential Guard instantiated the plug-in | This event indicates that the plug-in specified in the Credential Spec was installed and could be loaded. No action needed. |
| 2 | Container Credential Guard fetched gmsa credentials for %1 using plug-in: %2 | This is an informational event indicating that gMSA credentials were successfully fetched from AD. No action needed.  |
| 3 | Container Credential Guard failed to parse the credential spec. Error: %1 | This event indicates an issue with the credential specification. Please review [troubleshooting guidance for the credential specification](#check-the-credential-spec-file) to verify the formatting and contents of the credential specification. |
| 4 | Container Credential Guard failed to instantiate the plug-in: %1. Error: %2 | This event indicates that the plug-in could not be loaded. You should check that the plugin was installed correctly on the host |
| 6 | Container Credential Guard failed to fetch credentials from the plug-in: %1. Error: %2 | This event indicates that the plug-in loaded but could not retrieve credentials needed to fetch the gMSA password from AD. You should verify that the input to the plugin is formatted correctly in the credential specification and that the container host has the necessary permissions to access the secret store used by the plug-in.   |
| 7 | Container Credential Guard is refetching the credentials using the plug-in: %1 | This is an informational event. This event is generated when the gMSA password has expired and needs to be refreshed using the credentials fetched by the plug-in. |
| 8 | Container Credential Guard failed to fetch gmsa credentials for %1 using plugin %2. Error reason: %3 | This event indicates that the credentials fetched using the plugin could not be used to fetch gMSA credentials from AD. You should verify that the account being fetched from the plug-in has permissions in AD to retrieve the gMSA credentials. |
| 9 | Container Credential Guard failed to parse the plug-in GUID in the credential spec. Error: %1 |  Please make sure the GUID for the plug-in is correctly included in the credential specification. |
