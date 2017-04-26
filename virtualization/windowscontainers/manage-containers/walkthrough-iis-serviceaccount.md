


# Creating a test Active Directory domain on Azure

These steps will cover setting up a basic test environment in Azure. It will include:

- One VM serving as a domain controller
- Two VMs serving as Docker container hosts
- A non-admin user that will be used to test access to the website

If you have already have an Active Directory domain deployed you may skip running these steps. Be sure to read them so you can understand the domain and account names used in later steps and replace them with your own.


## Create a resource group
Create a resource group in Azure to hold all of the resources you'll be creating:

- Virtual Network
- Virtual Machines

## Create a VNet

- Don't use 172.* IPs. These will be used for internal IPs of containers. I used 10.3.0.0/24

## Deploy Azure VMs

Deploy 3x VMs using the "Windows Server 2016 Datacenter - with Containers" image from marketplace - "dc", "Host1", "Host2"

- Place them in the resource group above
- Use the existing VNet
- Assign a public IP
- Use a Network Security Group with
 - Inbound Rules
  - RDP (TCP/3389) allowed
  - Everything else blocked
 - Outbound Rules
  - Nothing 


> Security Badness: Don't give your domain controller RDP access with a public IP


## Create a domain

Connect to the domain controller VM to run these steps

1. ~~Assign a static IP address~~ - Azure already does this for you. Take note of it eg: `10.3.0.4`
2. Install role & create domain
```powershell
install-windowsfeature AD-Domain-Services
Import-Module ADDSDeployment
Install-ADDSForest -DomainName contoso.local -DomainNetbiosName contoso -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2012R2" -ForestMode "Win2012R2" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true
```
3. Reboot the DC when prompted
4. Reconnect with your domain admin account. This will be your original username prefixed with `contoso\`
5. Create a KDS master root key. Run `Get-KdsRootKey` as a domain administrator to check if one has already been created. If there isn't a master root key created for your domain, see [Create the Key Distribution Service KDS Root Key](https://technet.microsoft.com/en-us/library/jj128430(v=ws.11).aspx) for steps to create one. This is not the right thing to do in production but it will get a test environment up in the fewest steps.

In a test environment with only one DC, this will create a root key and make it effective immediately. __Do not use this for production environments.__
```powershell
Add-KdsRootKey –EffectiveTime ((get-date).addhours(-10))
```

> Note: this sample uses Azure's predefined static IPs for all machines instead of DHCP. In most environments, you would also need to configure DNS delegation or set up an authoritive DNS server for the domain. 


## Create a normal user account & security group for users to access the website

These steps are easiest done on the domain controller. This will create an account "User1" and a security group "WebUsers" which will be used to authenticate and authorize access to the website later.


```powershell
New-ADUser -Name User1 -PasswordNeverExpires $true -AccountPassword ("Password123!" | ConvertTo-SecureString -AsPlainText -Force) -Enabled $true
$user1 = Get-ADUser User1
$usergroup = New-ADGroup -GroupCategory Security -DisplayName "Web Authorized Users" -Name WebUsers -GroupScope Universal
$usergroup | Add-ADGroupMember -Members (Get-ADComputer -Identity host1)
```



## Join the compute hosts to domain

1. Fix up DNS servers so it can find the Windows domain
```powershell
$ifIndex = (get-netadapter -Name Ethernet*).ifIndex
$existingDns = (Get-DnsClientServerAddress -InterfaceIndex $ifIndex -AddressFamily ipv4).ServerAddresses
Set-DnsClientServerAddress -InterfaceIndex $ifIndex -ServerAddresses 10.3.0.4, $existingDns
```
2. Verify with `nslookup contoso.local`
3. `add-computer -DomainName contoso.local`, use domain admin credentials to join it
4. Reboot
5. Log back in using the domain admin credentials



## Update each Docker container host to latest Docker version

Do this on each host

```powershell
Install-Package -Name docker -ProviderName DockerMsftProvider -force
Start-Service Docker
docker.exe version
```



# Configuring and Creating Containers

Now that you have a test environment set up with a working Active Directory domain and machines ready to run containers, the next steps are:
- Create the Group Managed Service Account. This is the identity the container will run as
- 

## Create Group Managed Service account
These steps could be done using "Active Directory Users and Computers", or automated through Windows PowerShell. This guide focuses on Windows PowerShell.

For a more details on using Group Managed Service Accounts, see https://technet.microsoft.com/en-us/library/jj128431(v=ws.11).aspx



1. Create an Active Directory security group to hold the hosts. Add all of container hosts that should be able to run a container using the account.
```powershell
$group = New-ADGroup -GroupCategory Security -DisplayName "Container Hosts" -Name containerhosts -GroupScope Universal
$group | Add-ADGroupMember -Members (Get-ADComputer -Identity host1)
```


Verify it
```
PS C:\Users\patrick> $group | Get-ADGroupMember


distinguishedName : CN=HOST1,CN=Computers,DC=contoso,DC=local
name              : HOST1
objectClass       : computer
objectGUID        : 6dd3176c-906b-410f-9524-5a94919945bc
SamAccountName    : HOST1$
SID               : S-1-5-21-3262161174-1473910130-963080779-1103
```

2. Now, an Active Directory Domain Administrator can use `New-ADServiceAccount` to create a group Managed Service Account. `AccountName`, `DnsHostName`, and `ServicePrincipalName` must be passed in to uniquely identify the new account. You also need to specify what accounts can access the account after `PrincipalsAllowedToRetrieveManagedPassword`, such as a list of the container hosts or a security group containing all of container hosts that should be able to run a container using the account. In the example below "Server14362" is a container host that has already been joined to the domain. Security groups are easier to maintain if you have multiple hosts.
```
New-ADServiceAccount -name www -DnsHostName www.contoso.local  -ServicePrincipalNames http/www.contoso.local -PrincipalsAllowedToRetrieveManagedPassword containerhosts
```

> Tip: Create additional accounts for dev or preproduction use if needed – eg: "ProductionA" "PreprodA" "DevA"





## Configure the hosts to use the gMSA

Do this on each host

1. Install and load the ActiveDirectory PowerShell module
```
Add-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory
```

2. Verify the container host can access the gMSA
```powershell
Install-AdServiceAccount www
Test-AdServiceAccount www
```
This should return "True"

> bugbug - it doesn't
>
```
Install-AdServiceAccount : Cannot install service account. Error Message: '{Access Denied}
A process has requested access to an object, but has not been granted those access rights.'.
At line:1 char:1
+ Install-AdServiceAccount www
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : WriteError: (www:String) [Install-ADServiceAccount], ADException
    + FullyQualifiedErrorId : InstallADServiceAccount:PerformOperation:InstallServiceAcccountFailure,Microsoft.ActiveD
   irectory.Management.Commands.InstallADServiceAccount
```
>


## Creating CredentialSpecs

These steps need to be run on each container host.

1. Download the CredentialSpec module
```
Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/Microsoft/Virtualization-Documentation/live/windows-server-container-tools/ServiceAccounts/CredentialSpec.psm1 -OutFile CredentialSpec.psm1 
```

2. Load the CredentialSpec module.
```
Import-Module ./CredentialSpec.psm1
```

3. Create a credential spec for each account using `New-CredentialSpec`. This will retrieve the needed gMSA details, and automatically format them in the needed JSON credential spec format. The `Name` will be used when starting the container later, and does not need to match the name of the container, or that of the gMSA.
```
Import-Module .\CredentialSpec.psm1
New-CredentialSpec -Name www -AccountName www
```

## Test a container using the service account

The same `docker run` command is used to start containers, with an additional parameter `--security-opt "credentialspec=..."`. The host will use the details in the given credentialspec and start the container with the account automatically mapped. `-h <hostname>` is also needed so that the container's hostname will match that of the Group Managed Service Account. 

```
docker run -it -h www --security-opt "credentialspec=file://www.json" microsoft/windowsservercore cmd
```

You can run `nltest.exe /parentdomain` in a container to confirm that it is configured with a Group-Managed Service Account.

If it succeeds, it will return the full domain name:
```none
c:\>nltest.exe /parentdomain
contoso.com (1)
```

Next, verify end to end connectivity with `nltest.exe /query`

If it fails with
```

Flags: 0
Connection Status = 1786 0x6fa ERROR_NO_TRUST_LSA_SECRET
The command completed successfully
```
Then the service principal name is wrong when the container tries to contact the domain. There are two solutions to this:
- Start the container with a hostname matching the GMSA name. ex: `docker run -h www` - where www was the GMSA created earlier
> TODO: or Use setspn? In theory this should be possible but might need to be done for each container instance

If it fails with:
```
Flags: 0
Connection Status = 1311 0x51f ERROR_NO_LOGON_SERVERS
The command completed successfully
```
That's actually ok for now. Since it hasn't attempted to contact a login server yet, that's expected. Once a process tries to contact AD, you can run `nltest.exe /query` again.

Success:
```
PS C:\> nltest /query
Flags: 0
Connection Status = 0 0x0 NERR_Success
The command completed successfully
```

If it still fails, check the following:

- Make sure the right group was configured for access to the gMSA `Get-ADServiceAccount www -Properties PrincipalsAllowedToRetrieveManagedPassword`
- Make sure the host is in that group - `get-adgroup containerhosts | Get-ADGroupMember`



- `SetSPN -L www` shows an account matching the service principal name


> TODO: what error should be there on the host?


### TODO: more troubleshooting hints

This is from a working machine that can auth users via http:
```
PS C:\> nltest /query
Flags: 0
Connection Status = 0 0x0 NERR_Success
The command completed successfully
PS C:\> net config workstation
Computer name                        \\WWW
Full Computer name                   www
User name                            www$

Workstation active on

Software version                     Windows Server 2016 Datacenter

Workstation domain                   contoso
Workstation Domain DNS Name          contoso.local
Logon domain                         contoso

COM Open Timeout (sec)               0
COM Send Count (byte)                16
COM Send Timeout (msec)              250
The command completed successfully.
```

It can also auth to services on the DC. This seems to get some kerberos tickets:
```
PS C:\> klist

Current LogonId is 0:0x4402c4a

Cached Tickets: (0)
PS C:\> dir \\dc\sysvol


    Directory: \\dc\sysvol


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d----l         2/2/2017   1:26 AM                contoso.local


PS C:\> klist

Current LogonId is 0:0x4402c4a

Cached Tickets: (3)

#0>     Client: www$ @ CONTOSO.LOCAL
        Server: krbtgt/CONTOSO.LOCAL @ CONTOSO.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x60a10000 -> forwardable forwarded renewable pre_authent name_canonicalize
        Start Time: 3/27/2017 23:35:02 (local)
        End Time:   3/28/2017 9:35:02 (local)
        Renew Time: 4/3/2017 23:35:02 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0x2 -> DELEGATION
        Kdc Called: dc.contoso.local

#1>     Client: www$ @ CONTOSO.LOCAL
        Server: krbtgt/CONTOSO.LOCAL @ CONTOSO.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40e10000 -> forwardable renewable initial pre_authent name_canonicalize
        Start Time: 3/27/2017 23:35:02 (local)
        End Time:   3/28/2017 9:35:02 (local)
        Renew Time: 4/3/2017 23:35:02 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0x1 -> PRIMARY
        Kdc Called: dc.contoso.local

#2>     Client: www$ @ CONTOSO.LOCAL
        Server: cifs/dc @ CONTOSO.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40a50000 -> forwardable renewable pre_authent ok_as_delegate name_canonicalize
        Start Time: 3/27/2017 23:35:02 (local)
        End Time:   3/28/2017 9:35:02 (local)
        Renew Time: 4/3/2017 23:35:02 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0
        Kdc Called: dc.contoso.local
```



## Build a container with IIS authentication & authorization Enabled


Make a dockerfile

```dockerfile
FROM microsoft/iis
RUN powershell.exe Add-WindowsFeature Web-Windows-Auth
RUN powershell.exe -NoProfile -Command \
  Set-WebConfigurationProperty -filter /system.WebServer/security/authentication/AnonymousAuthentication -name enabled -value false -PSPath IIS:\ ; \
  Set-WebConfigurationProperty -filter /system.webServer/security/authentication/windowsAuthentication -name enabled -value true -PSPath IIS:\ 
```

> TODO: set up[authorization for asp.net](https://msdn.microsoft.com/en-us/library/wce3kxhd.aspx) 

Build it
```
docker build -t iis-secure .
```


Start it up
```
docker run -it -p 80:80 -h www --security-opt "credentialspec=file://www.json" iis-secure
```

- `--security-opt "credentialspec=file://www.json"` - the credentialspec has everything Windows needs to find the GMSA, and pull the details from the domain controller as the container is started.
- `-h www` - this is setting the hostname of the container to match the gMSA name. This is needed so the container automatically uses the right service principal name to connect back to the domain controller and authenticate the user. If it's not set, authentication will fail.
> Alternate: use setspn?. I'm not sure how to use this instead of `-h` yet


Get the IP
```powershell
docker ps # copy the container ID
docker inspect  --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' containerID
```

Connect to it in a web browser. It should prompt for username & password. Use the "contoso\User1" account that you set up earlier




### TODO Checking user IIS running as
> ```
$proc = Get-CimInstance Win32_Process -Filter "name = ‘w3wp.exe'"
Invoke-CimMethod -InputObject $proc -MethodName GetOwner 
```
