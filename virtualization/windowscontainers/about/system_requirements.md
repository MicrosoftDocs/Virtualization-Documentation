## Supported OS Images

Windows Server Technical Preview 4 is being offered with two container OS Images, Windows Server Core and Nano Server. Not all configurations support both OS images. This table details the supported configurations.

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:75%" cellpadding="5" cellspacing="5">
<tr valign="top">
<td><center>**Host Operating System**</center></td>
<td><center>**Windows Server Container**</center></td>
<td><center>**Hyper-V Contianer**</center></td>
<tr>
<tr valign="top">
<td><center>Windows Server 2016 Full UI</center></td>
<td><center>Core OS Image</center></td>
<td><center>Nano OS Image</center></td>
<tr>
<tr valign="top">
<td><center>Windows Server 2016 Core</center></td>
<td><center>Core OS Image</center></td>
<td><center> Nano OS Image</center></td>
<tr>
<tr valign="top">
<td><center>Windows Server 2016 Nano</center></td>
<td><center> Nano OS Image</center></td>
<td><center>Nano OS Image</center></td>
<tr>
</table>

<br />

## Hyper-V Container Requirements

Hyper-V containers require the Hyper-V role to be enabled.Hyper-V containers require the Hyper-V role to be enabled. Two configurations are possible.

- Physical System with Hyper-V role enabled.
- Hyper-V virtual machine with the Hyper-V role enables.

In order for the Hyper-V role to be enabled on a Hyper-V virtual machine, **both** the host operating system and the virtualized container host operating system must support nested virtualization. The following Operating systems support nested virtualization.

- System running Windows 10 build 1056 or later
- Windows Server Technical Preview 4 or later

