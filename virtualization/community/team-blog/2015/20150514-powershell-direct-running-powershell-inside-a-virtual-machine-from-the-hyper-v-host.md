---
title: PowerShell Direct – Running PowerShell inside a virtual machine from the Hyper-V host
description: Learn about running a Powershell command prompt inside a Hyper-V virtual machine host.
author: sethmanheim
ms.author: mabrigg
date:       2015-05-14 13:01:00
ms.date: 05/14/2015
categories: automation
---
# PowerShell Direct – Running PowerShell inside a virtual machine from the Hyper-V host

Official PS Direct documentation is located here (<https://msdn.microsoft.com/virtualization/hyperv_on_windows/user_guide/vmsession.html>).

At Ignite we announced PowerShell Direct, and briefly demoed it’s capabilities in the [“What’s New in Hyper-V” session](https://channel9.msdn.com/Events/Ignite/2015/BRK3461 ""What's New in Hyper-V" session").  This is a follow up so you can get started using PowerShell Direct in your own environment.

## What is PowerShell Direct?

It is a new way of running PowerShell commands inside a virtual machine from the host operating system easily and reliably.

There are no network/firewall requirements or configurations.  
It works regardless of Remote Management configuration.  
You still need guest credentials.

For people who want to try it out immediately, go ahead and (as Administrator) run either of these commands on a Windows10 Hyper-V host where VMName refers to a VM running Windows10:

Enter-PSSession -VMName VMName

Invoke-Command -VMName VMName -ScriptBlock { Commands }

***** Note: This only works from Windows 10/Windows Server Technical Preview Hosts to Windows 10/Windows Server Technical Preview guests.**  
 Please let me know what guest/host operating system combinations you’d like to see and why.

 

## Here is why I think this is really cool

Honestly, because it’s incredibly convenient.   I’ve been using PowerShell Direct for everything from scripted virtual machine configuration and deployment where each virtual machine has different roles and requirements through checking the state of my virtual machine (aka, has the guest operating system booted yet?).

Today, Hyper-V administrators rely on two categories of tools for connecting to a virtual machine on their Hyper-V host:

  * Remote management tools such as PowerShell or Remote Desktop
  * Hyper-V Virtual Machine Connection (VM Connect)



  
Both of these technologies work well but have tradeoffs as the Hyper-V deployment grows.  VMConnect is reliable but hard to automate while remote PowerShell is a brilliant automation and scripting tool but can be difficult to maintain/setup in some cases.  I sometimes hear customers lament domain security policies, firewall configurations, or a lack of shared network preventing the Hyper-V host from communicating with the virtual machines running on it.  
I’m also sure we’ve all had that moment where you're using remote PowerShell to modify a network setting and accidently make it so you can no longer connect to the virtual machine in the process…I know I have.

PowerShell Direct provides the scripting and automation experience available with remote PowerShell but with the zero configuration experience you get through VMConnect.

With that said, there are some PowerShell tools not available yet in PowerShell Direct.  This is the first step.  If you expected something to work and it didn’t, leave a comment.

 

## Getting started and a few common issues

I decided to make a picture of the most basic usage imaginable.

<!-- [![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/3580.PSSessionAndInvokeCommand.PNG)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/3580.PSSessionAndInvokeCommand.PNG) -->

  
**.5 – Dependencies**  
 You must be connected to a Windows 10/Windows Server Technical Preview Host with Windows 10/Windows Server Technical Preview virtual machine(s).  
 You need to be running as Hyper-V Administrator (launch PowerShell as Administrator).  
 You need user credentials in the virtual machine.

The virtual machine you want to connect to must be running locally (on this host) and booted.  
 I use Get-VM as a sanity check.

 

**1 – Enter-PSSession -VMName works.  So does Enter-PSSession –VMGuid**

Enter-PSSession -VMName VMName

Notice this is an interactive session.  I am running PowerShell commands on the virtual machine directly (same behavior as Enter-PSSession usually has).

 

**2 – Invoke-Command -VMName works.  So does Invoke-Command -VMGuid**

Invoke-Command -VMName VMName -ScriptBlock { Commands }

Notice this locally interprets the command(s) or script you pass in then performs those actions on the virtual machine (same behavior as Invoke-Command usually has).

 

It's that easy.

 

I look forward to seeing what you all build with this tool!  Happy scripting.

Cheers,  
Sarah

Edit:  Read more here <https://msdn.microsoft.com/virtualization/hyperv_on_windows/user_guide/vmsession> 
