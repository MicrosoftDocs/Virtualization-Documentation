---
layout:     post
title:      "Integration components&#58; How we determine Windows Update applicability"
date:       2014-11-24 08:48:06
categories: hyper-v
---
Last week we began [distributing integration components through Windows Update](/b/virtualization/archive/2014/11/11/hyper-v-integration-components-are-available-through-windows-update.aspx).  In the November rollup, integration components were made available to Windows Server 2012/2008R2 virtual machines along with Windows 8/7 virtual machines running on Windows Technical Preview hosts.

Ben wrote a great [blog post](http://blogs.msdn.com/b/virtual_pc_guy/archive/2014/11/12/updating-integration-components-over-windows-update.aspx) outlining how to update the integration components.

Using Windows Update to apply integration components brought to light an interesting set of challenges with our standard servicing tools.  Unlike other Windows Updates, integration components are tied to the host version not just the installed OS.  How should we check that Windows is running in a virtual machine on a Technical Preview Hyper-V host?

We settled on the KVP (Hyper-V data exchange) integration component.  KVP provides a shared registry key between the host and guest OS with some useful information about the VM.

See HKEY_LOCAL_MACHINE/SOFTWARE/Microsoft/Virtual Machine/Guest/Parameters:

 [![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/Picture1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/Picture1.png)

We were particularly interested in the HostSystemOSMajor and HostSystemOSMinor for determining integration component applicability.  Windows version is 6.4 is Technical Preview.

Cool.

So, if KVP is enabled, Windows Update checks the OS version, the HostSystemOSMajor, then the HostSystemOSMinor. If all that checks out, then Windows Update provides the integration components to that virtual machine.

This does have some interesting side effects.

First, if KVP has never been enabled, these keys will not exist and Windows Update will not know the host version and the integration components will not be offered.   
Second, these registry keys are all modifiable and thus easy to spoof :).

As soon as we started offering integration component updates through windows update, customers started asking me when they’d be available to VMs running on down-level hosts.  While it is no way supported, you can modify the values for HostSystemOSMajor and HostSystemOSMinor to receive integration component updates through windows update on down-level hosts right now.  
The integration component changes we distributed in November are compatible with Server 2012 R2/ Windows 8.1 hosts (in fact, they’re the exact integration components that shipped in Windows 2012 R2/Windows 8.1 hosts).

While I in no way endorse this and it certainly isn’t supported, if one were to run the following:

[![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/Picture2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/Picture2.png)

They may find that Windows Update updates the integration components in their VM to the correct version for Windows Server 2012 R2/Windows 8.1.

Cheers,  
Sarah
