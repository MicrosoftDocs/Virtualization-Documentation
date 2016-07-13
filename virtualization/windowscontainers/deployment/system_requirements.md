---
title: Windows Container Requirements
description: Windows Container Requirements.
keywords: metadata, containers
author: neilpeterson
manager: timlt
ms.date: 05/26/2016
ms.topic: deployment-article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 3c3d4c69-503d-40e8-973b-ecc4e1f523ed
---

# Windows container requirements

**This is preliminary content and subject to change.** 

This guides list the requirements for a Windows container Host.

## OS Requirements

- The Windows container role is only available on Windows Server 2016 TP5 (Full and Core), Nano Server, and Windows 10 (insiders build 14352 and up).
- If Hyper-V containers will be run, the Hyper-V role will need to be installed.
- Windows Server container hosts must have Windows installed to c:\\. If only Hyper-V containers will be deployed, this restriction does not apply.

## Virtualized Container Hosts

If a Windows container host will be run from a Hyper-V virtual machine, and will also be hosting Hyper-V containers, nested virtualization will need to be enabled. Nested virtualization has the following requirements:

- At least 4 GB RAM available for the virtualized Hyper-V host.
- Windows Server 2016 Technical Preview 5, or Windows 10 build 10565 on the host system, and Windows Server Technical Preview 5 (Full, Core) or Nano Server in the virtual machine.
- A processor with Intel VT-x (this feature is currently only available for Intel processors).
- The container host VM will also need at least 2 virtual processors.

## Supported OS images

Windows Server Technical Preview 5 is being offered with two container OS Images, Windows Server Core and Nano Server. Not all configurations support both OS images. This table details the supported configurations.

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:75%" cellpadding="5" cellspacing="5">
<thead>
<tr valign="top">
<th><center>Host Operating System</center></th>
<th><center>Windows Server Container</center></th>
<th><center>Hyper-V Container</center></th>
</tr>
</thead>
<tbody>
<tr valign="top">
<td><center>Windows Server 2016 with Desktop Experience</center></td>
<td><center>Server Core image<br>Nano Server image</center></td>
<td><center>Nano Server image</center></td>
</tr>
<tr valign="top">
<td><center>Windows Server 2016 Core</center></td>
<td><center>Server Core image<br>Nano Server image</center></td>
<td><center> Nano Server image</center></td>
</tr>
<tr valign="top">
<td><center>Windows Server 2016 Nano</center></td>
<td><center> Nano Server image</center></td>
<td><center>Nano Server image</center></td>
</tr>
<tr valign="top">
<td><center>Windows 10 Insider Releases</center></td>
<td><center>Not Available</center></td>
<td><center>Nano Server image</center></td>
</tr>
</tbody>
</table>
