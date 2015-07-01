ms.ContentId: 7561B149-A147-4F71-9840-6AE149B9DED5
title: Supported Windows Guest Operating Systems

# Supported Windows Guest Operating Systems for Client Hyper-V in Windows 10 #

Client Hyper-V includes integration services for supported guest operating systems which improves the integration between the host system and the virtual machine. Some operating systems have the integration services built-in, while others provide integration services through Windows Update.

The following table lists the Windows operating systems supported as guests in Windows Client Hyper-V, as well provides information about integration services. 

## Supported Windows Server guest operating systems ##

| Guest operating system| Maximum number of virtual processors| Integration Services | Notes |
|:-----|:-----|:-----|:-----|
|Windows Server Technical Preview|64|Built-in||
|Windows Server 2012 R2|64|Built-in||
|Windows Server 2012|64|Built-in||
|Windows Server 2008 R2 with Service Pack 1 (SP 1)|64|Install the integration services after you set up the operating system in the virtual machine.|Datacenter, Enterprise, Standard and Web editions. |
|Windows Server 2008 with Service Pack 2 (SP 2)|4|Install the integration services after you set up the operating system in the virtual machine.|Datacenter, Enterprise, Standard and Web editions (32-bit and 64-bit). |
|Windows Home Server 2011|4|Install the integration services after you set up the operating system in the virtual machine.||
|Windows Small Business Server 2011|Essentials edition - 2, Standard edition - 4|Install the integration services after you set up the operating system in the virtual machine.|Essentials and Standard editions. |

## Supported Windows client guest operating systems ##

| Guest operating system| Maximum number of virtual processors| Integration Services | Notes |
|:-----|:-----|:-----|:-----|
|Windows 10|32|Built-in||
|Windows 8.1|32|Built-in||
|Windows 8|32|Upgrade the integration services after you set up the operating system in the virtual machine.||
|Windows 7 with Service Pack 1 (SP 1)|4|Upgrade the integration services after you set up the operating system in the virtual machine.|Ultimate, Enterprise, and Professional editions (32-bit and 64-bit).|
|Windows 7|4|Upgrade the integration services after you set up the operating system in the virtual machine.|Ultimate, Enterprise, and Professional editions (32-bit and 64-bit).|
|Windows Vista with Service Pack 2 (SP2)|2|Install the integration services after you set up the operating system in the virtual machine.|Business, Enterprise, and Ultimate, including N and KN editions.| 
|Windows XP with Service Pack 3 (SP3)|2|Install the integration services after you set up the operating system in the virtual machine.|Professional.| 
|Windows XP x64 Edition with Service Pack 2 (SP 2)|2|Install the integration services after you set up the operating system in the virtual machine.|Professional.|

Microsoft provides support for guest operating systems in the following manner:

- Issues found in Microsoft operating systems and in integration services are supported by Microsoft support.
- For issues found in other operating systems that have been certified by the operating system vendor to run on Hyper-V, support is provided by the vendor.
- For issues found in other operating systems, Microsoft submits the issue to the multi-vendor support community, [TSANet](http://www.tsanet.org/).

## See also: ##

- [Linux and FreeBSD Virtual Machines on Hyper-V](https://technet.microsoft.com/library/dn531030.aspx)

- [Supported Guest Operating Systems for Windows Server Technical Preview](https://technet.microsoft.com/en-US/library/mt126119.aspx)
