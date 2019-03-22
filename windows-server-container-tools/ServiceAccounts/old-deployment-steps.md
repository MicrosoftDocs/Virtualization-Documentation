> **NOTICE**
>
> This doc is no longer being maintained.
> For the most up-to-date instructions on how to use gMSAs with Windows Containers, see the official docs at https://aka.ms/containers/identity

## Deployment Overview
Deploying containers with an emulated domain identity is simple, and based around existing workflows using Windows Server and Active Directory.

Deploying this feature requires:
- An existing Active Directory domain, with at least one domain controller running Windows Server 2012. There is no specific domain or forest functional level requirement.
- Windows Server 2016 or later with the Container role and Docker installed. This will be referred to as a **Container host**. These hosts need to be joined to the domain.

This guide will cover the following steps to deploy a container in detail:

1. Create a group Managed Service Account in the Active Directory for each application/service
2. Give each container host access to use the group Managed Service Account
3. Add configuration files on each container host that store details about the group Managed Service Accounts. These will be referred to as **Credential Specs**  
4. Start containers with a parameter telling which credential spec to use


### Active Directory Setup Steps
These steps could be done using "Active Directory Users and Computers", or automated through Windows PowerShell. This guide focuses on Windows PowerShell.

For a more details on using Group Managed Service Accounts, see https://technet.microsoft.com/en-us/library/jj128431(v=ws.11).aspx

1. Before you can create the first gMSA, the domain needs a master root key. Run `Get-KdsRootKey` as a domain administrator to check if one has already been created. If there isn't a master root key created for your domain, see [Create the Key Distribution Service KDS Root Key](https://technet.microsoft.com/en-us/library/jj128430(v=ws.11).aspx) for steps to create one.

In a test environment with only one DC, this will create a root key and make it effective immediately. Do not use this for production environments.
```powershell
Add-KdsRootKey –EffectiveTime ((get-date).addhours(-10))
```

2. Now, an Active Directory Domain Administrator can use `New-ADServiceAccount` to create a group Managed Service Account. `AccountName`, `DnsHostName`, and `ServicePrincipalName` must be passed in to uniquely identify the new account. You also need to specify what accounts can access the account after `PrincipalsAllowedToRetrieveManagedPassword`, such as a list of the container hosts or a security group containing all of container hosts that should be able to run a container using the account. In the example below "Server14362" is a container host that has already been joined to the domain. Security groups are easier to maintain if you have multiple hosts.
```
New-ADServiceAccount -name WebApplication1 -DnsHostName wa1-production.contoso.com  -ServicePrincipalNames http/wa1-production.contoso.com -PrincipalsAllowedToRetrieveManagedPassword Server14362$
```
> Tip: Create additional accounts for dev or preproduction use if needed – eg: "ProductionA" "PreprodA" "DevA"


## Container Host Setup Steps
1. First, Container hosts should be set up using the existing [deployment guide](https://msdn.microsoft.com/virtualization/windowscontainers/deployment/deployment)
2. Join the container host to the Active Directory domain
3. Verify the container host can access the gMSA
```powershell
Install-AdServiceAccount WebApplication1
Test-AdServiceAccount WebApplication1
```
This should return "True"

### Creating CredentialSpecs
1. Install and load the ActiveDirectory PowerShell module
```
Add-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory
```
2. Load the CredentialSpec module. It should be provided along with this document.
```
Import-Module ./CredentialSpec.psm1
```
3. Create a credential spec for each account using `New-CredentialSpec`. This will retrieve the needed gMSA details, and automatically format them in the needed JSON credential spec format. The `Name` will be used when starting the container later, and does not need to match the name of the container, or that of the gMSA. The `Domain` argument assumes the local computer is joined to the domain and provides support in case the joined domain is a subdomain. 
```
Import-Module .\CredentialSpec.psm1
New-CredentialSpec -Name WebApplication1 -AccountName WebApplication1 -Domain $(Get-ADDomain -Current LocalComputer)
```

### Viewing CredentialSpecs
The `Get-CredentialSpec` cmdlet will list the credential spec files stored on the container host.

```
Name            Path
----            ----
WebApplication1 C:\ProgramData\Docker\CredentialSpecs\WebApplication1.json
```

For reference, here is an example of the contents of WebApplication1.json
```
{"CmsPlugins":["ActiveDirectory"],"DomainJoinConfig":{"DnsName":"contoso.com","Guid":"244818ae-87ca-4fcd-92ec-e79e5252348a","DnsTreeName":"contoso.com","NetBiosName":"DEMO","Sid":"S-1-5-21-2126729477-2524075714-3094792973","MachineAccountName":"WebApplication1"},"ActiveDirectoryConfig":{"GroupManagedServiceAccounts":[{"Name":"WebApplication1","Scope":"DEMO"},{"Name":"WebApplication1","Scope":"contoso.com"}]}}
```
This is the information needed to identify the group Managed Service Account.

## Running Containers
The same `docker run` command is used to start containers, with an additional parameter `--security-opt "credentialspec=..."`. The host will use the details in the given credentialspec and start the container with the account automatically mapped.
```
docker run -it --security-opt "credentialspec=file://WebApplication1.json" microsoft/windowsservercore cmd
```

You can run `nltest.exe /parentdomain` in a container to confirm that it can reach the Active Directory domain.

If it succeeds, it will return the full domain name:
```
c:\>nltest.exe /parentdomain
contoso.com (1)
```

If it fails, then a connection couldn't be made. Be sure that it was launched with the right options, and make sure the host can access the gMSA.

```
C:\>nltest.exe /parentdomain
Getting parent domain failed: Status = 1722 0x6ba RPC_S_SERVER_UNAVAILABLE
```

Additionaly, to verify the container can actually query the domain, run `nltest /query`. This should result in the following:

```
PS c:\>nltest /query
Flags: 0
Connection Status = 0 0x0 NERR_Success
The command completed successfully
```

If it fails with the error `ERROR_NO_TRUST_SAM_ACCOUNT` it is possible that the `-Domain`-argument in the Get-CredentialSpec command was not properly set or the specified domain is not the domain the gMSA resides in. Check the generated credentialSpec JSON-file for correctness. It can be found in the subdirectory `credentialspecs` in the Docker base directory.

```
C:\>nltest.exe /query
Connection Status = 1787 0x6fb ERROR_NO_TRUST_SAM_ACCOUNT
```

## Configuring other services to accept connections from containers
Services and other processes running as 'Local System' or 'Network Service' in the container will now use the gMSA as they authenticate to other resources.

For example, an ASP.NET app running as the 'Local System' account could be reconfigured from using SQL authentication:
```
"ConnectionString": "Server=192.168.5.18;Database=MusicStore;Integrated Security=False;User Id=sa;Password=Password1;MultipleActiveResultSets=True;Connect Timeout=30"
```
To using Windows Integrated Authentication:
```
"ConnectionString": "Server=192.168.5.18;Database=MusicStore;Integrated Security=True;MultipleActiveResultSets=True;Connect Timeout=30"
```

After rebuilding the container image with the new connection string in place, a container instance can be run using a credential spec file which allows the web app to authenticate with the SQL server as if it were the gMSA account.

```powershell
docker run -p 80:80 -h WebApplication1 --security-opt "credentialspec=file://WebApplication1.json" -it musicstore-iis cmd
```

> [!IMPORTANT]
> The container hostname (-h parameter) must match the name of the gMSA account in order for the container to be able to communicate with the domain controller.

At this point, SQL would see a login from the gMSA included in that credentialspec. Following the examples above - this would be "contoso\WebApplication1"


## Additional group Managed Service Accounts
In addition to the default account that will be mapped to 'Local System' and 'Network Service' in the container, additional group Managed Service Accounts can also be added to a credentialspec. Once this is done, additional services can be configured to use this account inside the container instead of the default account.

Here's an example where two additional accounts - 'LogApp' and 'AuditApp' are added:

```powershell
New-CredentialSpec –Name "App2" –Domain (Get-ADDomain) –AccountName "ProductionApp" –AdditionalAccounts @{DomainName="domain.contoso.com";AccountName="LogApp"}, @{DomainName="domain.contoso.com";AccountName="AuditApp"}
```

A scheduled task or service can now be configured to use these accounts.

Example scheduled task:

```powershell
$action = New-ScheduledTaskAction "c:\myLogApp\runTask.cmd"
$trigger = New-ScheduledTaskTrigger -At 22:00 -Daily
$principal = New-ScheduledTaskPrincipal -UserID contoso\LogApp$ -LogonType Password
Register-ScheduledTask myLogTask –Action $action –Trigger $trigger –Principal $principal
```

> Tip: If you are using additional gMSA, the container will need to be rebuilt to use a different account name later. It may be better to share an image without the extra gMSAs, then have a shorter Dockerfile to build a layer that adds the right users for each deployment.
