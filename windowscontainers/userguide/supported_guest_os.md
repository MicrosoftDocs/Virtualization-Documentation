ms.ContentId: 7561B149-A147-4F71-9840-6AE149B9DED5
title: Supported Guest Operating Systems

#Supported Guest Operating Systems for Client Hyper-V in Windows 10#

Client Hyper-V includes integration services for supported guest operating systems that improves the integration between the physical computer and the virtual machine. Some operating systems have the integration services built-in, while others provide integration services through Windows Update.

The following table lists the operating systems supported in Windows
10 for use as guest operating systems in
Hyper-V virtual machines, as well as provides information about
integration services. For information about running Linux as a guest
operating system, see: **Linux Virtual Machines on Hyper-V**.

Microsoft provides support for guest operating systems in the following
manner:

- Issues found in Microsoft operating systems and in integration services are supported by Microsoft support.

- For issues found in other operating systems that have been certified by the operating system vendor to run on Hyper-V, support is provided by the vendor.

- For issues found in other operating systems, Microsoft submits the issue to the multi-vendor support community, [TSANet](http://www.tsanet.org/).
    \

## Supported Windows Server guest operating systems ##

+--------------------+--------------------+--------------------+--------------------+
| Guest operating    | Maximum number of  | Integration        | Notes              |
| system (server)    | virtual processors | Services           |                    |
+====================+====================+====================+====================+
| Windows Server     | 64                 | Built-in           |                    |
| 2012 R2            |                    |                    |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows Server     | 64                 | Built-in           |                    |
| 2012               |                    |                    |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows Server     | 64                 | Install the        | Datacenter,        |
| 2008 R2 with       |                    | integration        | Enterprise,        |
| Service Pack 1 (SP |                    | services after you | Standard and Web   |
| 1)                 |                    | set up the         | editions.          |
|                    |                    | operating system   |                    |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows Server     | 4                  | Install the        | Datacenter,        |
| 2008 with Service  |                    | integration        | Enterprise,        |
| Pack 2 (SP 2)      |                    | services after you | Standard and Web   |
|                    |                    | set up the         | editions (32-bit   |
|                    |                    | operating system   | and 64-bit).       |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows Home       | 4                  | Install the        |                    |
| Server 2011        |                    | integration        |                    |
|                    |                    | services after you |                    |
|                    |                    | set up the         |                    |
|                    |                    | operating system   |                    |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows Small      | Essentials         | Install the        | Essentials and     |
| Business Server    | edition - 2        | integration        | Standard editions. |
| 2011               |                    | services after you |                    |
|                    | Standard edition - | set up the         |                    |
|                    | 4                  | operating system   |                    |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows Server     | 2                  | Install the        | Standard, Web,     |
| 2003 R2 with       |                    | integration        | Enterprise, and    |
| Service Pack 2     |                    | services after you | Datacenter         |
| (SP2)              |                    | set up the         | editions (32-bit   |
|                    |                    | operating system   | and 64-bit).       |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows Server     | 2                  | Install the        | Standard, Web,     |
| 2003 with Service  |                    | integration        | Enterprise, and    |
| Pack 2             |                    | services after you | Datacenter         |
|                    |                    | set up the         | editions (32-bit   |
|                    |                    | operating system   | and 64-bit).       |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+



## Supported Windows client guest operating systems ##


+--------------------+--------------------+--------------------+--------------------+
| Guest operating    | Maximum number of  | Integration        | Notes              |
| system (client)    | virtual processors | Services           |                    |
+====================+====================+====================+====================+
| Windows 8.1        | 32                 | Built-in           |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows 8          | 32                 | Upgrade the        |                    |
|                    |                    | integration        |                    |
|                    |                    | services after you |                    |
|                    |                    | set up the         |                    |
|                    |                    | operating system   |                    |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows 7 with     | 4                  | Upgrade the        | Ultimate,          |
| Service Pack 1 (SP |                    | integration        | Enterprise, and    |
| 1)                 |                    | services after you | Professional       |
|                    |                    | set up the         | editions (32-bit   |
|                    |                    | operating system   | and 64-bit).       |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows 7          | 4                  | Upgrade the        | Ultimate,          |
|                    |                    | integration        | Enterprise, and    |
|                    |                    | services after you | Professional       |
|                    |                    | set up the         | editions (32-bit   |
|                    |                    | operating system   | and 64-bit).       |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows Vista with | 2                  | Install the        | Business,          |
| Service Pack 2     |                    | integration        | Enterprise, and    |
| (SP2)              |                    | services after you | Ultimate,          |
|                    |                    | set up the         | including N and KN |
|                    |                    | operating system   | editions.          |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows XP with    | 2                  | Install the        | Professional.      |
| Service Pack 3     |                    | integration        |                    |
| (SP3)              |                    | services after you |                    |
|                    |                    | set up the         |                    |
|                    |                    | operating system   |                    |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+
| Windows XP x64     | 2                  | Install the        | Professional.      |
| Edition with       |                    | integration        |                    |
| Service Pack 2 (SP |                    | services after you |                    |
| 2)                 |                    | set up the         |                    |
|                    |                    | operating system   |                    |
|                    |                    | in the virtual     |                    |
|                    |                    | machine.           |                    |
+--------------------+--------------------+--------------------+--------------------+



See also:

- **Linux Virtual Machines on Hyper-V**\

- **Supported Guest Operating Systems for Windows Server Technical Preview 2**

