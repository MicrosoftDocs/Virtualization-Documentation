---
layout:     post
title:      "Guest post&#58; &#34;Setting the Record Straight - 9 Reasons Why Hyper-V is a Great Choice for Enterprises&#34;"
date:       2010-01-18 13:21:00
categories: disaster-recovery
---
Hi, my name is Chris Steffen, architect with Kroll Factual Data. You may have read one of my [prior guest posts](http://blogs.technet.com/virtualization/archive/2008/04/03/disaster-recovery-not-a-nightmare-with-virtualization.aspx "Chris Steffen post on DR").

 

Recently, I came across an [InformationWeek Analytics Weblog](http://www.informationweek.com/blog/main/archives/2009/12/9_reasons_enter.html;jsessionid=CL13EAE2BDN05QE1GHPCKH4ATMY32JVN "InformationWeek blog") that asserted a bunch of half truths and misinformation about Microsoft’s Hyper-V virtualization solution. Usually, I can just let it go (everyone’s entitled to their own opinion, right?), but in this case, the article was so skewed and so misleading that I felt that I needed to respond.  
  
Full disclosure – I am a Microsoft MVP for virtualization and a very happy Microsoft Hyper-V customer. Over the years, I have written about and presented many times on the topic of virtualization in general (including Hyper-V, ESX and Xen), and the benefits my company has experienced implementing the of the Microsoft virtualization solution. I certainly recognize my particular biases, but my biases originate from the ability of Microsoft’s virtualization solutions working in my enterprise environment.   
  
In my position as a technology architect, I try to stay on top of all of the latest advances in technologies that could benefit our business. As my company is heavily invested in virtualization, I am keenly aware of the constantly changing virtualization platforms and their continued claims of superiority over each other. But some of these arguments from VMWare are just getting old. I will try to separate some of the “myths” from the reality of the debate.  
  
1\. Breadth of OS support  
  
Myth: Hyper-V has no support / limited support for Linux.  
  
Reality: Microsoft supports more than just the Windows server platforms, including versions of Linux from Red Hat and Novell.   
  
VMWare claims to support 4x more OSes that Hyper-V, but what does that really mean? When Microsoft lists an OS as supported, they COMPLETELY support the actual OS installation in the VM and you can call Microsoft support on that OS. Microsoft has support agreements with Red Hat and Novell specifically for this purpose. VMware provides no support for the actual OS, telling customer to refer to the vendor. Also, many of the OSes that VMWare claims to support are only supported by the Linux community - not taking a shot at the Linux community here, but most do not have a formal support organization. This leads me to question why they would be used in an enterprise environment. Also, those Linux distributions can be run under Hyper-V, using the Linux Integration Components Microsoft has available for download and the drivers which are in the 2.6.32 Linux kernel release. In this case, customers wouldn’t be able to call Microsoft for support for the OS, but would work with the Linux community, just as they would with VMware.  
  
2\. Memory management  
  
Myth: VMWare allows for memory over subscription and this is a good thing.  
  
Reality: The Microsoft solution does not allow for over subscription of critical resources, but you shouldn’t do it anyway.  
  
First, there is nothing poor about the way that Hyper-V manages memory – it works exactly as designed. It was designed with system performance and stability as the paramount priorities, whereas the VMWare solution appears to have been designed to allow a customer to cram as many instances on to the VM host as possible, regardless of the consequences.  
  
The core of the VMWare argument is that you can somehow get “something for nothing” – that there is some kind of magic that comes with the over subscription of RAM using VMWare that is the silver bullet regarding memory management. To leverage memory management in ESX to the fullest, one would have to fully burden the host beyond the physical memory. If you don’t, you really aren’t using memory overcommit. If you do, one of the most risky uses is the disaster recovery scenario. Relying on a host to overcommit memory to support failover hosts is potentially dangerous and incorrect oversubscription leads to all VMs suffering from performance.   
  
I would also contend that there are some instances where a company might choose to use over subscription for noncritical environments, such as a test or a dev lab. But I would not classify disaster recovery as one of those environments, and I would never over commit my VM hosts in production.  
  
3\. Security  
  
Myth: The design of Hyper-V makes it somehow unsecure.  
  
Reality: Hyper-V is more stable than and at least as secure as VMWare.  
  
One of the oldest arguments in the book – one that VMWare evangelists continually bring up – is the scare tactic that there are millions of hackers trying to hack the latest version of any Windows operating systems, therefore, VMWare (or any other operating system or application) is more secure than any offering by Microsoft. While it may be true that there are versions of Windows everywhere, it is also true that no other commercially available operating systems or applications are more forthcoming about their flaws and their efforts to fix them. As far as install footprint is concerned, the total size for ESX systems after all the patches have been downloaded and applied was 45 times greater (4.0GB compared to 73 MB) than the size of the patches for a Windows Server Core system during an 18 month period. Further, if the actual number of patches is more relevant to you (as it is to me), ESX 3.5 had 168 total patches, compared to 19 for Windows Server Core (34 if you are using the complete install of Windows Server). Either way – which is more stable?  
  
4\. Live Migration  
  
Myth: Hyper-V does not have a live migration feature.  
  
Reality: Live migration of virtual machines was released with Hyper-V R2  
  
One of the largest pieces of misinformation that continues to pass around the virtualization circles is that Microsoft does not have a live migration feature. Literally, at a recent VMWorld event, I stopped counting at 200 different folks who believed (or were told by someone) that this was the case. To be absolutely clear:  
  
Microsoft Hyper-V R2 has a live migration feature!  
  
Most of the folks from VMWare have come to accept this, so now they are touting that their LM solution is better because you can migrate multiple VMs simultaneously. While it is true that the VMWare solution can migrate multiple VMs at the same time, is this actually better?  
  
Let’s go back to Basic Computer Architecture 101, and the example of the water pipe. There are limits to how much water you can push through a pipe at any given time, and the more taps that you add to the pipe, the longer it will take to fill up a bucket at each of the pipes. Hyper-V uses the best practice of moving a single VM as quickly as possible, using the entire bandwidth available to complete the transfer. Also, it is important to point out that without a modification of the host setting, VMWare would limit the migration to 4 VMs at a time (presumably for the same bandwidth considerations). The idea of moving 40 VMs all at the same time (as mentioned in the article) is not something that would be recommended, ever, regardless of platform.  
  
5\. VM Priority Restarts  
  
Myth: Hyper-V does not start VMs and VM Hosts in specific order.  
  
Reality: Hyper-V can be configured to restart with specific delay and specific order.  
  
Some analysts are quick to point out the major differences between the virtualization solutions. This is hardly on that I would call a major difference, but this is something that Hyper-V does not have an automatic, automated solution for. That said, in practical use, Hyper-V VMs can be configured to restart on specific hosts, with specific delays allowing for prioritization (and even non-automatic restarts, for less important VMs). Also keep in mind that using the System Center suite, the Microsoft solution can Live Migrate VMs to other hosts due to situations that VMware servers cannot even monitor, such as CPU Power, Power Supply Failures, and Fibre Channel congestion.  
  
6\. Fault Tolerance.  
  
Myth: vSphere is THE solution for high availability systems.   
  
Reality: Read the label…

Again, this sounded a little too good to be true. First, vSphere is limited to a very small subset of the CPUs available, therefore limiting the different kind of hosts that are able to use this technology. Then, there are limits to the kind of virtual machines that can be created in vSphere to use this technology (uniprocessor VMs, limited thin disks). Then, you would need to create a second complete infrastructure for the fault tolerant environment.  
  
There are certainly applications that you might consider putting into this kind of fault tolerant environment (Exchange and SQL Server come to mind). But you would never want these as network limited, processor starved virtual machines.  
  
7\. Hot-Adds  
  
Myth: VMWare has Hot Add capabilities.  
  
Reality: Hyper-V does have some hot-add support, and the VMWare solution has some limits as well.  
  
While VMware vSphere has hot-add, it is not that ANY VM can perform Hot-Add. While you can perform a Hot Add to the VM, it is only actually useful if the Guest OS supports Hot Add to recognize the new hardware. If not, you would need to reboot the VM see the Hot Add devices, which is almost the same as simply shutting down the VM and adding it cold. Many do not, especially with Hot Add CPU and Hot Add Memory. Also, Hyper-V does support Hot-Add disk in supported VMs.  
  
8\. Third Party Vendor Support  
  
Myth: Hyper-V lags behind VMWare for third party tools support.  
  
Reality: Hyper-V gains third party support every day.  
  
Which solution offers the greater support? Obviously, this is a very subjective matter. In this particular instance, there are many third party tools out there that support the VMWare solution. But those same third party companies are jumping onto the Hyper-V bandwagon every day. While VMWare may lead in quantity, it has been my personal experience that the support for the Hyper-V solution is world class, and one of the top priorities for Microsoft.  
  
9\. Maturity.  
  
Myth: VMWare is more "mature" than Hyper-V.  
  
Reality: vSphere is just as new as Hyper-V, and Hyper-V is very much ready for prime time.  
  
There is really no evidence that Hyper-V is any less mature than vSphere. Regardless of the virtualization solution, an enterprise IT department will need to properly evaluate both solutions. When they do, they will find that this "maturity" issue is really a bunch of bunk, and that the solutions should be judged on their merits. Literally hundreds of companies (including mine) have embraced the Microsoft virtualization solution for our enterprise environments. No amount of disinformation from will change the fact that Hyper-V works, works well, and is a top tier (if not the top tier) virtualization solution for enterprise class environments.  
  
10\. Costs  
  
Myth: Hyper-V is cheaper, but a lesser product.  
  
Reality: Hyper-V IS cheaper, and is a stable, cost effective, robust and competitive virtualization solution.  
  
Sometimes, it does come down to cost. The folks at VMWare would like you to think that you get additional bang for your buck by selecting the VMWare virtualization solution. But that is just not the case. As we have discussed with the previous 9 points, the Microsoft solution matches up with VMWare point for point. And the differences that exist between the two solutions are often a matter of interpretation of subjective analysis, not concrete facts. But despite any facts or points that you may or may not believe, even the folks at VMWare will admit (grudgingly) that the Microsoft virtualization solution and management systems cost less than the comparable VMWare solution.

Overall, it has always been one of my goals for companies to look at the benefits that a virtualization solution would bring to their enterprise environments, and there are many good solutions to choose from. I have no particular animus towards VMWare or any of the other virtualization vendors out there – quite the opposite, in fact. I believe that the competition between Microsoft, VMWare and the others makes a better end product for everyone. But I also do not believe that it makes sense to discount the abilities of any one of these vendors over the other.  
  
As I have stated in numerous blogs previously, the best way to evaluate a virtualization solution is to get it into your environment and take it for a spin. Give Hyper-V a chance, and I think you will find that it can be a great choice for your enterprise virtualization needs.

 

 

Thanks…

 

Chris Steffen
