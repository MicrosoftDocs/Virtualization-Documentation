---
title:      "How to Use Resource Metering With PowerShell"
author: sethmanheim
ms.author: sethm
ms.date: 08/20/2012
date:       2012-08-20 10:30:00
categories: cloud-computing
description: How to Use Resource Metering With PowerShell
---
# Use resource metering with PowerShell

Hey, it's Lalithra again. In the last [part](https://blogs.technet.com/b/virtualization/archive/2012/08/16/introduction-to-resource-metering.aspx), we talked about what resource metering is. Now, we'll get into how to use it with PowerShell. _A quick note: if this is your first foray into PowerShell, here are some resources you may find helpful to go through. First, a couple of posts from the Scripting Guy to give you a good overview:[An Introduction](https://blogs.technet.com/b/heyscriptingguy/archive/2009/04/20/windows-powershell-an-introduction.aspx) and [PowerShell and Pipelining](https://blogs.technet.com/b/heyscriptingguy/archive/2009/04/21/windows-powershell-and-pipelining.aspx). Also, check out the [Windows PowerShell for the Busy Admin](https://blogs.technet.com/b/heyscriptingguy/archive/2012/03/06/windows-powershell-for-the-busy-admin.aspx) series of webcasts by Scripting Guy Ed Wilson. Highly recommended._ Let 's get started. First, let's find the cmdlets we're looking for. 

PS C:> [Get-Command](https://technet.microsoft.com/library/hh849711.aspx) *VM* This prints out a list of cmdlets with VM in their names. If we look through this list for something related to resource metering, we'll find the cmdlets we're looking for.

PS C:> Get-Command *VMResourceMetering* If you want more details on a particular cmdlet, use Get-Help. Now, let's enable resource metering.

PS C:> [Enable-VMResourceMetering](https://technet.microsoft.com/library/hh848481.aspx) –VMName Greendale-VM We can see if a virtual machine has resource metering enabled by looking at its properties:

PS C:> [Get-VM](https://technet.microsoft.com/library/hh848479) –VMName Greendale | Format-Table Name, ResourceMeteringEnabled

Name                                                                        ResourceMeteringEnabled  
\----                                                                        \-----------------------  
Greendale-VM                                                                                   True Here, I'm piping the VM Object into the Format-Table cmdlet, which will print out a table with the name of the virtual machine and whether resource metering is enabled or not. In this case, I see that metering is enabled. If you want to disable metering, it's simple. Just swap out the verb:

PS C:> [Disable-VMResourceMetering](https://technet.microsoft.com/library/hh848498) –VMName Greendale-VM Let's see what the resource utilization is like so far.

PS C:> [Measure-VM](https://technet.microsoft.com/library/hh848471) –VMName Greendale-VM

VMName       AvgCPU(MHz) AvgRAM(M) MaxRAM(M) MinRAM(M) TotalDisk(M) NetworkInbound(M) NetworkOutbound(M)  
\------       \----------- --------- --------- --------- ------------ ----------------- ------------------  
Greendale-VM 86          1750      2608      1119      40960        9930              2945 Now I can see the CPU, memory, disk, and network utilization, as covered in the last post. If I want to see the utilization in greater detail…

PS C:> $report = Measure-VM –VMName Greendale-VM  
PS C:> $report | Format-List  
AvgCPU                      : 86  
AvgRAM                      : 1750  
MinRAM                      : 1119  
MaxRAM                      : 2608  
TotalDisk                   : 40960  
ComputerName                : LALITHRF-N1  
VMId                        : 2aeec321-08e2-47c6-a360-dfafecff4525  
VMName                      : VMM 2012 SP1  
MeteringDuration            : 19.03:57:44.2660000  
AverageProcessorUsage       : 86  
AverageMemoryUsage          : 1750  
MaximumMemoryUsage          : 2608  
MinimumMemoryUsage          : 1119  
TotalDiskAllocation         : 40960  
NetworkMeteredTrafficReport : {Microsoft.HyperV.PowerShell.VMNetworkAdapterPortAclMeteringReport,  
                              Microsoft.HyperV.PowerShell.VMNetworkAdapterPortAclMeteringReport,  
                              Microsoft.HyperV.PowerShell.VMNetworkAdapterPortAclMeteringReport,  
                              Microsoft.HyperV.PowerShell.VMNetworkAdapterPortAclMeteringReport} Here, I'm storing the output of Measure-VM into a variable, $report. I'm printing out everything in this report in list form. A quick aside, you may have noticed that we have seemingly redundant properties such as AvgCPU and AverageProcessorUsage. We use the shorter parameter names for the column headings in our tables, as seen above. This allows the table to fit on a PowerShell prompt. Since it is likely that you would use the names you see in the tables to access the various properties, we added the shorter names as aliases, so that the properties remain intuitive to work with. If I want more details on the network utilization, I'll want to look at the NetworkMeteredTrafficReport property:

PS C:> $report.NetworkMeteredTrafficReport

LocalAddress RemoteAddress Direction TotalTraffic(M)  
\------------ ------------- --------- ---------------  
             *.*           Outbound  308  
             *:*           Inbound   6047  
             *.*           Inbound   3883  
             *:*           Outbound  2637 What if I want to add another ACL? As we talked about on the last [post](https://blogs.technet.com/b/virtualization/archive/2012/08/16/introduction-to-resource-metering.aspx), ACLs, set on a virtual machine's network adapter, allow you measure traffic that uses your internet versus your intranet, or any other division you choose.

PS C:> [Add-VMNetworkAdapterAcl](https://technet.microsoft.com/library/hh848505) –VMName Greendale-VM –Action Meter –Direction Inbound –RemoteIpAddress 10.0.0.0/8 If I want to remove it, simply swap the verb:

PS C:> [Remove-VMNetworkAdapterAcl](https://technet.microsoft.com/library/hh848554) –VMName Greendale-VM –Action Meter –Direction Inbound –RemoteIpAddress 10.0.0.0/8 One side note: Disable-VMResourceMetering does not remove the default *.* and *:* metering ACLs. If you want to remove them, use the Remove-VMNetworkAdapterAcl cmdlet. If you want to use SR-IOV, you will want to remove them, as metering and SR-IOV are not compatible. Finally, now that I've measured the data I'm interested in, and saved it for your chargeback solution, I need to reset resource metering, so that it collects the data just for this next billing cycle.

PS C:> [Reset-VMResourceMetering](https://technet.microsoft.com/library/hh848558) –VMName Greendale-VM Now, if I measure again, I see that the values are reset:

PS C:> Measure-VM –VMName Greendale-VM

VMName       AvgCPU(MHz) AvgRAM(M) MaxRAM(M) MinRAM(M) TotalDisk(M) NetworkInbound(M) NetworkOutbound(M)  
\------       \----------- --------- --------- --------- ------------ ----------------- ------------------  
Greendale-VM 1557        1198      1198      1198      40960        2                 1 That's it! You should be able to put those pieces together for your own purposes. Please let us know how you're using it!
