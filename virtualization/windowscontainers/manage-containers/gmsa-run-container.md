---
title: Run a container with a gMSA
description: How to run a Windows container with a group Managed Service Account (gMSA).
author: rpsqrd
ms.author: roharwoo
ms.date: 09/10/2019
ms.topic: how-to
ms.assetid: 9e06ad3a-0783-476b-b85c-faff7234809c
---

# Run a container with a gMSA

> Applies to: Windows Server 2022, Windows Server 2019

To run a container with a Group Managed Service Account (gMSA), provide the credential spec file to the `--security-opt` parameter of [docker run](https://docs.docker.com/engine/reference/run):

```powershell
docker run --security-opt "credentialspec=file://contoso_webapp01.json" --hostname webapp01 -it mcr.microsoft.com/windows/server:ltsc2022 powershell
```

>[!IMPORTANT]
>On Windows Server 2016 versions 1709 and 1803, the hostname of the container must match the gMSA short name.

In the previous example, the gMSA SAM Account Name is *webapp01*, so the container hostname is also named *webapp01*.

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

If the Trusted DC Connection Status and Trust Verification Status are not `NERR_Success`, follow the [troubleshooting instructions](gmsa-troubleshooting.md#check-the-container) to debug the problem.

You can verify the gMSA identity from within the container by running the following command and checking the client name:

```powershell
PS C:\> klist get webapp01

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

## Next steps

In addition to running containers, you can also use gMSAs to:

- [Configure apps](gmsa-configure-app.md)
- [Orchestrate containers](gmsa-orchestrate-containers.md)
- With [gMSA on Azure Kubernetes Service](./gmsa-aks-ps-module.md)

If you run into any issues during setup, check our [troubleshooting guide](gmsa-troubleshooting.md) for possible solutions.
