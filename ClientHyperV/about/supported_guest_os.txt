ms.ContentId: 7561B149-A147-4F71-9840-6AE149B9DED5
title: Supported Guest Operating Systems

#Supported Guest Operating Systems for Client Hyper-V in Windows 10#

Client Hyper-V includes integration services for supported guest operating systems that improves the integration between the physical computer and the virtual machine. Some operating systems have the integration services built-in, while others provide integration services through Windows Update.

The following table lists the operating systems supported in Windows 10 for use as guest operating systems in Hyper-V virtual machines, as well as provides information about
integration services. For information about running Linux as a guest operating system, see: **Linux Virtual Machines on Hyper-V**.

Microsoft provides support for guest operating systems in the following
manner:

- Issues found in Microsoft operating systems and in integration services are supported by Microsoft support.

- For issues found in other operating systems that have been certified by the operating system vendor to run on Hyper-V, support is provided by the vendor.

- For issues found in other operating systems, Microsoft submits the issue to the multi-vendor support community, [TSANet](http://www.tsanet.org/).


## Supported Windows Server guest operating systems ##

<table>
<tr><th>Guest operating system</th><th>	Maximum number of virtual processors</th><th>Integration Services</th><th>Notes</th></tr>
<tr><td><p>Windows Server Technical Preview</p></td><td><p>64</p></td><td><p>Built-in</p></td><td><p></p></td></tr>
<tr><td><p>Windows Server 2012 R2</p></td><td><p>64</p></td><td><p>Built-in</p></td><td><p></p></td></tr>
<tr><td><p>Windows Server 2012</p></td><td><p>64</p></td><td><p>Built-in</p></td><td></td></tr>
<tr><td><p>Windows Server 2008 R2 with Service Pack 1 (SP 1)</p></td><td><p>64</p></td><td><p>Install the integration services after you set up the operating system in the virtual machine.</p></td><td><p>Datacenter, Enterprise, Standard and Web editions. </p></td></tr>
<tr><td><p>Windows Server 2008 with Service Pack 2 (SP 2)</p></td><td><p>4</p></td><td><p>Install the integration services after you set up the operating system in the virtual machine.</p></td><td><p>Datacenter, Enterprise, Standard and Web editions (32-bit and 64-bit). </p></td></tr>
<tr><td><p>Windows Home Server 2011</p></td><td><p>4</p></td><td><p>Install the integration services after you set up the operating system in the virtual machine.</p></td><td></td></tr>
<tr><td><p>Windows Small Business Server 2011</p></td><td><p>Essentials edition - 2</p><p>Standard edition - 4</p></td><td><p>Install the integration services after you set up the operating system in the virtual machine.</p></td><td><p>Essentials and Standard editions. </p></td></tr>
</table>

## Supported Windows client guest operating systems ##

<table><tr><th>Guest operating system</th><th>Maximum number of virtual processors</th><th>Integration Services</th><th>Notes</th></tr>
<tr><td><p>Windows 10</p></td><td><p>32</p></td><td><p>Built-in</p></td><td></td></tr>
<tr><td><p>Windows 8.1</p></td><td><p>32</p></td><td><p>Built-in</p></td><td></td></tr>
<tr><td><p>Windows 8</p></td><td><p>32</p></td><td><p>Upgrade the integration services after you set up the operating system in the virtual machine.</p></td><td></td></tr>
<tr><td><p>Windows 7 with Service Pack 1 (SP 1)</p></td><td><p>4</p></td><td><p>Upgrade the integration services after you set up the operating system in the virtual machine.</p></td><td><p>Ultimate, Enterprise, and Professional editions (32-bit and 64-bit). </p></td></tr><tr><td><p>Windows 7</p></td><td><p>4</p></td><td><p>Upgrade the integration services after you set up the operating system in the virtual machine.</p></td><td><p>Ultimate, Enterprise, and Professional editions (32-bit and 64-bit). </p></td></tr><tr><td><p>Windows Vista with Service Pack 2 (SP2)</p></td><td><p>2</p></td><td><p>Install the integration services after you set up the operating system in the virtual machine.</p></td><td><p>Business, Enterprise, and Ultimate, including N and KN editions. </p></td></tr><tr><td><p>Windows XP with Service Pack 3 (SP3)</p></td><td><p>2</p></td><td><p>Install the integration services after you set up the operating system in the virtual machine.</p></td><td><p>Professional. </p></td></tr><tr><td><p>Windows XP x64 Edition with Service Pack 2 (SP 2)</p></td><td><p>2</p></td><td><p>Install the integration services after you set up the operating system in the virtual machine.</p></td><td><p>Professional. </p></td></tr>
</table>



## See also: ##

- **Linux Virtual Machines on Hyper-V**

- **Supported Guest Operating Systems for Windows Server Technical Preview 2**

