# Management Interoperability

For the most part, Windows Containers created with PowerShell need to be managed with PowerShell and those created with Docker need to be managed with Docker. That said, the Host Computing PowerShell module provides the ability to discover and stop containers regardless of how they have been created. This module performs like a 'task manage' for containers running on a container host.

> The HCS module is in early preview, functionality will change.

## Display all Containers

To return a list of containers use the `Get-ComputeProcess` command.

```powershell
Get-ComputeProcess
Id                                                               Name                                                             Owner       Type
--                                                               ----                                                             -----       ----
2088E0FA-1F7C-44DE-A4BC-1E29445D082B                             DEMO1                                                            VMMS   Container
373959AC-1BFA-46E3-A472-D330F5B0446C                             DEMO2                                                            VMMS   Container
d273c80b6ec1c461159074f4ccc0be0793cfedb02ab2f25225512a21e254646d d273c80b6ec1c461159074f4ccc0be0793cfedb02ab2f25225512a21e254646d docker Container
e49cd35542b3b750c743f7e319f1e92d434785acffe4a214c126734eb47ab219 e49cd35542b3b750c743f7e319f1e92d434785acffe4a214c126734eb47ab219 docker Container
```

## Stop a Container

To stop a container regardless if it was created using PowerShell or Docker, use the `Stop-ComputeProcess` command.

> At the time of writing, the VMMS service will need to be restarted in order for the containers to be shown as stopped when using the `Get-Container` command.

```powershell
Stop-ComputeProcess -Id 2088E0FA-1F7C-44DE-A4BC-1E29445D082B -Force
```
