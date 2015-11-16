# Windows Containers Documentation

Windows containers provide operating system level virtualization that allows multiple isolated applications to be run on a single system. Windows Containers provides two different types of container runtime, each with a different degree of application isolation. Windows Server Containers achieve isolation through namespace and process isolation and Hyper-V Containers encapsulates each container in a light weight virtual machine. In addition to two runtimes, both can be managed with either PowerShell or Docker. This documentation provides a quick start guide for both runtimes, management experiences as well details deployment and management operations.

> Windows Containers and the Windows Container documentation is in an early pre-release. Container functionality and documentation are subject to change.

# Documentation Notes

- The documentation has a left hand table of contents which can be used for document navigation. Note, the table of contents can be collapsed for a wider view of the documents.

- Each document has a contribute button in the upper right hand corner. This button will navigate to the specific document on GitHub. Feel free to create a pull request against the document or file a document bug.

- The container documentation team monitors the containers forum. Feel free to start or join a conversation at the [Windows Container Form]( https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

# Quick Links

<table border="1" style="background-color:FFFFCC;border-collapse:collapse;border:1px solid FFCC00;color:000000;width:100%" cellpadding="15" cellspacing="5">
<tr>
<td>**Quick Start**<br /><br />
Try Windows Server and Hyper-V containers with these guided quick start experiences.<br /><br />
<ul>
<li>[Azure Quick Start](quick_start/azure_setup.md)
<li>[On-Premise Quick Start](quick_start/container_setup.md)
<li>[PowerShell Quick Start](quick_start/manage_powershell.md)
<li>[Docker Quick Start](quick_start/manage_docker.md)
</td>
</tr>
<tr>
<td>**Deployment**<br /><br />
Read about deploying Windows Container in Windows Server 2016 and Nano Server.<br /><br />
<ul>
<li>[Deploy Container Host](deployment/deployment.md)
<li>[Deploy Docker on Windows](deployment/docker_windows.md)
</td>
</tr>
<tr>
<td>**Management**<br /><br />
Read about managing Windows Container in Windows Server 2016 and Nano Server.<br ><br />
<ul>
<li>[Manage Containers](management/manage_containers.md)
<li>[Manage Images](management/manage_images.md)
<li>[Manage Networking](management/container_networking.md)
<li>[Manage Container Data](management/manage_data.md)
<li>[Manage Hyper-V Containers](management/hyperv_container.md)
<li>[Manage Container Resources](management/manage_resources.md)
<li>[Container Interoperability](management/hcs_powershell.md)
</td>
</tr>
<tr>
<td>**Community**<br /><br />
Interact with the community, try samples, and find additional resources.<br ><br />
<ul>
<li>[Container Forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers)
<li>[Container Resources](https://msdn.microsoft.com/virtualization/community/community_overview)
<li>[Samples and Scripts](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-server-container-samples)
</td>
</tr>
</table>