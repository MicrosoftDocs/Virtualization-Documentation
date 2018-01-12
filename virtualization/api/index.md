---
title: Windows Hypervisor Platform
description: Windows Hypervisor Platform
keywords: windows 10, hypervisor
author: jterry75
ms.date: 12/19/2017
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.assetid: 05269ce0-a54f-4ad8-af75-2ecf5142b866
---

# Windows Hypervisor Platform

The Windows Hypervisor Platform adds an extended user-mode API for third-party virtualization stacks and applications to create and manage partitions at the hypervisor level, configure memory mappings for the partition, and create and control execution of virtual processors.

> Ex: A client such as QEMU can run on the hypervisor while maintaining its management, configuration, guest/host protocols and guest supported drivers. All while running alongside a Hyper-V managed partition with no overlap.

The following diagram provides a high-level overview of the third-party architecture.

![](./media/hypervisor-platform-architecture.png)
> For more information see: [Windows Hypervisor Platform API](./hypervisor-platform/hypervisor-platform.md)
**Note: These APIs are not yet publicly available and will be included in a future Windows release.**

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:100%" cellpadding="15" cellspacing="3">
	<tr valign="top">
		<td><center>![](../hyper-v-on-windows/media/MeetsRequirements_65.png)</center></td>
		<td valign="top">
			<p><strong>About Hyper-V on Windows</strong></p>
			<p>The following articles provide an introduction to and information about Hyper-V on Windows.</p>
			<ul>
				<li class="unordered">[Introduction to Hyper-V](../hyper-v-on-windows/about/index<br /><br /></li>
				<li class="unordered">[Supported Guest Operating Systems](../hyper-v-on-windows/about/supported-guest-os)<br /><br /></li>
			</ul>
		</td>
	</tr>
	<tr valign="top">
		<td><center>![](../hyper-v-on-windows/media/All_ContentTypeIcons_VisualWalkthrough_65.png)</center></td>
		<td valign="top">
			<p><strong>Get started with Hyper-V</strong></p>
			<p>The following documents provide a quick and guided introduction to Hyper-V on Windows 10.</p>
			<ul>
			    <li class="unordered">[Install Hyper-V](../hyper-v-on-windows/quick-start/enable-hyper-v.md)<br /><br /></li>
                <li class="unordered">[Create a Virtual Machine](../hyper-v-on-windows/quick-start/create-virtual-machine.md)<br /><br /></li>
				<li class="unordered">[Create a Virtual Switch](../hyper-v-on-window/quick-start/connect-to-network.md)<br /><br /></li>
				<li class="unordered">[Hyper-V and PowerShell](../hyper-v-on-windows/quick-start/try-hyper-v-powershell.md)<br /><br /></li>
			</ul>
		</td>
	</tr>
	<tr valign="top">
		<td><center>![](../hyper-v-on-windows/media/Chat_65.png)</center></td>
		<td valign="top">
			<p><strong>Connect with Community and Support</strong></p>
			<p>Additional technical support and community resources.</p>
			<ul>
				<li class="unordered">[Hyper-V forums](https://social.technet.microsoft.com/Forums/windowsserver/en-US/home?forum=winserverhyperv)<br /><br /></li>
				<li class="unordered">[Community Resources for Hyper-V and Windows Containers](/virtualization/community/index.md)<br /><br /></li>
			</ul>
		</td>
	</tr>
</table>