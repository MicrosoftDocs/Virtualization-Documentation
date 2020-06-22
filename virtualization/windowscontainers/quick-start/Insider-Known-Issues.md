---
title: Known issues for insider builds
description: Known issues for insider builds.
keywords: docker, containers
ms.topic: quickstart
ms.prod: windows-containers
ms.service: windows-containers
---

# Known issues for insider builds

## Build 16237

- Hyper-V isolation is not working properly. This workaround is needed to use Hyper-V isolation in build 16237. Run these commands in PowerShell:

```PowerShell
Get-ComputeProcess | ? IsTemplate -eq $true | Stop-ComputeProcess -Force
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\Containers\' -Name TemplateVmCount -Type dword -Value 0 -Force
```

- Nano Server now runs as user, so commands that require administrator privileges will fail. Including a line such as "RUN setx /M PATH" will cause the build to fail. For this scenario, you can use this alternative:

```dockerfile
RUN setx PATH <path>
```
