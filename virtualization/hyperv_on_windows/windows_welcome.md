ms.ContentId: 09eacb3a-bcd2-4724-9c73-6d47ec06f385
title: Hyper-V on Windows 10


# Hyper-V on Windows 10 

Many versions of Windows 10 include the Hyper-V virtualization technology. Hyper-V enables running virtualized computer systems on top of a physical host. These virtualized systems can be used and managed just as if they were physical computer systems, however they exist in virtualized and isolated environment. Special software called a hypervisor manages access between the virtual systems and the physical hardware resources. Virtualization enables quick deployment of computer systems, a way to quickly restore systems to a previously known good state, and the ability to migrate systems between physical hosts.

Hyper-V on Windows 10 enables many scenarios such as deploying computers system for testing, simulation or development activities. Some common examples of where Hyper-V would be useful on top of a client laptop or workstation are:
- Lab deployment for training and simulation – Hyper-V on Windows 10 allows you to deploy Windows Server or Linux operating systems to simulate datacenter deployments and operations.
- Isolated development platforms – Application development is made easier in enabling you to host webserver and other application infrastructure in a virtual machine for development and testing purposes.
- Break Fix Testing – with a virtualized system you can test computer configurations and revert to a known good state once completed.

>Note - Hyper-V for Windows Server documentation can be found here - [Hyper-V on Windows Server 2012 R2](https://technet.microsoft.com/en-us/library/hh831531.aspx), [Hyper-V on Windows Server 2016 Technical Preview](https://technet.microsoft.com/en-us/library/mt126117.aspx) .

The following documents detail the Hyper-V feature in Windows 10, provide a guided quick start and also container links to further resources and community forums. 

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:100%" cellpadding="15" cellspacing="3">
	<tr valign="top">
		<td><center>![](./media/MeetsRequirements_65.png)</center></td>
		<td valign="top">
			<p><strong>About Hyper-V on Windows</strong></p>
			<p>The following articles provide an introduction to and information about Hyper-V on Windows.</p>
			<ul>
				<li class="unordered">[Introduction to Hyper-V](./about/hyperv_on_windows.md)<br /><br /></li>
				<li class="unordered">[What’s New in Hyper-V for Windows 10](./about/whats_new.md)<br /><br /></li>
				<li class="unordered">[Supported Guest Operating Systems](about\supported_guest_os.md)<br /><br /></li>
			</ul>	
		</td>
	</tr>
	<tr valign="top">
		<td><center>![](./media/All_ContentTypeIcons_VisualWalkthrough_65.png)</center></td>
		<td valign="top">
			<p><strong>Get started with Hyper-V</strong></p>
			<p>The following guided walkthrough will help you quickly learn how to deploy Hyper-V and Virtual Machines on Windows 10, and how to use many of the Hyper-V features.
			<ul>
				<li class="unordered">[Windows 10 Hyper-V Quick Start](./quick_start/walkthrough.md)<br /><br /></li>
			</ul>
				
				<p>Here are links to some of the individual quick start topics.</p>
				
			<ul>
				<li class="unordered">[Check system requirements](quick_start\walkthrough_compatibility.md)<br /><br /></li>
                <li class="unordered">[Install Hyper-V](quick_start\walkthrough_install.md)<br /><br /></li>
				<li class="unordered">[Create a switch](quick_start\walkthrough_virtual_switch.md)<br /><br /></li>
				<li class="unordered">[Create a virtual machine](quick_start\walkthrough_create_vm.md)<br /><br /></li>
				<li class="unordered">[Experiment with checkpoints](quick_start\walkthrough_checkpoints.md)<br /><br /></li>
				<li class="unordered">[Experiment with PowerShell](quick_start\walkthrough_powershell.md)<br /><br /></li>
			</ul>
		</td>
	</tr>
	<tr valign="top">
		<td><center>![](./media/Chat_65.png)</center></td>
		<td valign="top">
			<p><strong>Connect with Community and Support</strong></p>
			<p>Additional technical support and community resources.</p>
			<ul>
				<li class="unordered">[Hyper-V forums](https://social.technet.microsoft.com/Forums/windowsserver/en-US/home?forum=winserverhyperv)<br /><br /></li>
				<li class="unordered">[Community Resources for Hyper-V and Windows Containers](..\community\community_overview.md)<br /><br /></li>
			</ul>	
		</td>
	</tr>
</table>