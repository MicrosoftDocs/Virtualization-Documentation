---
title: Configure your app to use a Group Managed Service Account
description: How to configure apps to use Group Managed Service Accounts (gMSAs) for Windows containers.
keywords: docker, containers, active directory, gmsa, apps, applications, group managed service account, group managed service accounts, configuration
author: rpsqrd
ms.date: 09/10/2019
ms.topic: how-to
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 9e06ad3a-0783-476b-b85c-faff7234809c
---
# Configure your app to use a gMSA

In the typical configuration, a container is only given one Group Managed Service Account (gMSA) that is used whenever the container computer account tries to authenticate to network resources. This means your app will need to run as **Local System** or **Network Service** if it needs to use the gMSA identity.

## Run an IIS app pool as Network Service

If you're hosting an IIS website in your container, all you need to do to leverage the gMSA is set your app pool identity to **Network Service**. You can do that in your Dockerfile by adding the following command:

```dockerfile
RUN %windir%\system32\inetsrv\appcmd.exe set AppPool DefaultAppPool -processModel.identityType:NetworkService
```

If you previously used static user credentials for your IIS App Pool, consider the gMSA as the replacement for those credentials. You can change the gMSA between dev, test, and production environments and IIS will automatically pick up the current identity without having to change the container image.

## Run a Windows service as Network Service

If your containerized app runs as a Windows service, you can set the service to run as **Network Service** in your Dockerfile:

```dockerfile
RUN sc.exe config "YourServiceName" obj= "NT AUTHORITY\NETWORK SERVICE" password= ""
```

## Run arbitrary console apps as Network Service

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

## Next steps

In addition to configuring apps, you can also use gMSAs to:

- [Run containers](gmsa-run-container.md)
- [Orchestrate containers](gmsa-orchestrate-containers.md)

If you run into any issues during setup, check our [troubleshooting guide](gmsa-troubleshooting.md) for possible solutions.
