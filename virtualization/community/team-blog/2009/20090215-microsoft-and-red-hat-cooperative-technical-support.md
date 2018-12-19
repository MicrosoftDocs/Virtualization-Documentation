---
layout:     post
title:      "Microsoft and Red Hat Cooperative Technical Support"
date:       2009-02-15 16:00:00
categories: application-virtualization
---
Hi, I’m Mike Neil, general manager of virtualization at Microsoft. It’s been a while since I’ve blogged here, but today’s post is worth a read.

Ever since we released Windows Server 2008 Hyper-V and Terminal Services, System Center Virtual Machine Manager 2008 and Microsoft App-V 4.5 last year, customers and partners have been getting [huge value](http://www.prnewswire.com/mnr/microsoft/36562/) from server consolidation projects, have been able to [increase business continuity](http://www.microsoft.com/casestudies/casestudy.aspx?casestudyid=4000003571) at much lower costs than with VMware, and have [decreased the time and cost](http://www.microsoft.com/casestudies/casestudy.aspx?casestudyid=4000003225) required to deliver applications to end users. And while doing this, they’ve been able to use a familiar set of system management tools for both their virtualized and non-virtualized systems and applications across the datacenter and desktops. In fact, [Chris from Kroll Factual Data wrote](http://blogs.technet.com/virtualization/archive/2008/04/03/disaster-recovery-not-a-nightmare-with-virtualization.aspx) about his DR project on this blog last year. So in many ways I’m pleased that we’ve been able to help so many customers and partners break down the barriers to enterprise-wide virtualization. 

But until today there’s been one barrier, not product related, that we haven’t been able to overcome to meet customer and partner demand: the ability to run and support Red Hat Enterprise Linux within a guest VM on WS08 Hyper-V and Hyper-V Server 2008. For all of those who have emailed me, my colleagues and your Microsoft account teams and partners, I’m pleased to say that today is the first big step to delivering that support.

Microsoft and Red Hat recently signed agreements to test and validate our server operating systems running on each other’s hypervisors. Customers with valid support agreements will be able to run these validated configurations and receive joint technical support for running Windows Server on Red Hat Enterprise virtualization, and for running Red Hat Enterprise Linux on Windows Server 2008 Hyper-V or Hyper-V Server 2008. You can see Red Hat’s news release [here](http://www.redhat.com/about/news/prarchive/2009/svvp.html "Red Hat news release"), and watch a [public webcast](http://www.redhat.com/promo/svvp/ "Red Hat webcast") discussing this news.

So how are we doing this? Red Hat has joined [Microsoft’s Server Virtualization Validation Program](http://www.windowsservercatalog.com/svvp.aspx), and Microsoft is now a Red Hat partner for virtualization interoperability and support. Microsoft will be listed in the [Red Hat Hardware Certification List](http://www.redhat.com/rhel/compatibility/hardware/) once we’ve completed the Red Hat certification process in H2. In addition to the agreements, Microsoft will publish Linux Integration Components for RHEL when the testing and validation is complete. The folks at Red Hat tell me that they’ll provide WHQL [[Windows Hardware Quality Labs](https://www.microsoft.com/whdc/winlogo/default.mspx)] drivers for a variety of Windows Server versions. So not only will you get cooperative technical support, you’ll also get high-performing enlightened VMs.

You might also be wondering – when can I get this? I don’t have a calendar date for you just yet, but I know that validations are now underway and will be as comprehensive as possible. Each company is doing its respective validations separately with the first validated configurations available at different times later this year. 

And I’m sure you’re wondering about tools to manage those RHEL guests running on Hyper-V? Good news there. We know virtualization projects aren’t successful unless the right management tools are in place to manage both the virtual and physical. System Center Operations Manager 2007 R2, which will be released in calendar Q2 2009, includes cross platform monitoring and support for Red Hat Enterprise Linux server versions 4 and 5 so that you can manage the applications and OS in the guest VM. Other Linux distros will be supported, too. This will allow you to monitor end-to-end data center applications that are distributed across both Windows Server and RHEL, whether these servers are physical or virtual. 

I suspect that you’re now as excited as me about these agreements. But maybe you’re wondering … what took so long? That’s a fair question given the number of customers and partners that have been asking for this result.

Let me say that I’m sure everyone reading this can appreciate the distance between Microsoft and Red Hat is measured in more than just the 2,900 miles between Redmond, WA and Raleigh, NC. Microsoft and Red Hat have competed for customers and partners for some time now and as platform vendors continue to compete in the marketplace.  Yet, our customers have told us that technical support for server virtualization is an area we must work together. And that’s certainly understandable when you consider the fact that roughly 80% of the primary guest (in a VM) operating systems on x86 servers today come from Microsoft or Red Hat.  Indeed, customer demand is the main driver behind these agreements with our competitor.

One thing I’d like to point out:  since these agreements are focused on joint technical support for Microsoft and Red Hat’s mutual customers using server virtualization, the activities included in these agreements do not require the sharing of IP.  Therefore, these agreements do not include any patent or other IP licensing rights. 

I want to leave you with the point that Microsoft is pragmatically focused on helping customers and partners be successful in a heterogeneous IT world. We’re committed to enable and support interoperability with non-Windows OSes.  As a result we take a multifaceted approach to interoperability, be it customer-driven industry collaborations, such as this  Server Virtualization Validation Program, be it standards that promote common technologies (e.g., device virtualization through the PCI-SIG), or proactive licensing of IP (e.g., [Microsoft’s Virtual Hard Disk format](http://www.microsoft.com/interop/osp/default.mspx), [Microsoft’s Hypercall APIs](http://blogs.technet.com/virtualization/archive/2007/10/24/windows-virtualization-hypercall-apis-available-via-open-specification-promise.aspx)), or the creation of technologies that bridge different systems (e.g., protocol licensing and documentation, [Integration Components for Linux](http://blogs.msdn.com/mikester/archive/2008/09/10/linux-integration-components-now-posted.aspx)). In the end, customers with mixed IT environments expect it all to work together and today’s announcement is one way of making that happen.

Below you can read an FAQ that is also on Red Hat's website. 

Mike

 

**FAQ**

**Q1: Is this a joint agreement between Red Hat and Microsoft?

**

A1: It’s not a joint agreement. Red Hat has signed an agreement to join Microsoft’s Server Virtualization Validation Program, while Microsoft has joined Red Hat’s Virtualization Certification Program .  Microsoft will be listed in the Red Hat Hardware Certification List once it has completed the Red Hat certification process.

**Q2: It seems like customers should have had this type of support some time ago. What took so long to provide customers with technical support?  

**

A2: Microsoft and Red Hat started hearing requests for bilateral validation soon after Microsoft’s Server Virtualization Validation Program went live in June 2008. Both companies quickly agreed to work together; finalizing the details around comprehensive, coordinated technical support has taken some time. As a result, customers will be able to confidently deploy Microsoft Windows Server and Red Hat Enterprise Linux, virtualized on Microsoft and Red Hat hypervisors, knowing that the solutions will be supported by both companies.

**Q3: Are there other components of the deal that have not been disclosed yet?

**

A3: No. The agreements are specific to establishing coordinated technical support for our mutual customers using server virtualization. The agreements have nothing to do with patents, and there are no patent rights or other open source licensing rights implications provided under these agreements. The agreements contain no financial clauses other than test fees for industry-standard certification and validation.

While Microsoft and Red Hat continue to compete in the marketplace, customers have told us that technical support for server virtualization is an area where we must work together. Now we have agreements to test and coordinate technical support and provide customers with a new level of mutual support between Red Hat Enterprise Linux and Windows Server for their heterogeneous IT environments.

**Q4: What versions of Red Hat Enterprise Linux and Red Hat Virtualization will be validated, to what versions of Windows and Hyper-V?

**

A4: Validations are now getting underway, and are planned to be comprehensive. Each company is doing its respective validations separately, with the first results expected later this year. 

As a participant in Microsoft’s Server Virtualization Validation Program, once Red Hat submits test logs indicating that Windows Server 2008 runs properly on the Red Hat Enterprise virtualization, the specific version of Red Hat used in the tests along with parameters of the virtual machine tested will be posted on Microsoft’s Server Virtualization Validation Program website. At that point customers can confidently deploy Windows Server 2008, Windows Server 2003 SP2, or Windows 2000 Server SP4 and later and receive coordinated technical support from both vendors. 

Red Hat Enterprise Linux SVVP completion is planned for calendar H2 2009.

Microsoft currently plans to validate Red Hat Enterprise Linux 5 as a guest on Windows Server Hyper-V.  Windows Server 2008 Hyper-V (all editions) and Microsoft Hyper-V Server 2008 will now support uni-processor virtual machines running:

·         Red Hat Enterprise Linux 5.2 (x86)

·         Red Hat Enterprise Linux 5.2 (x64)

·         Red Hat Enterprise Linux 5.3 (x86)

·         Red Hat Enterprise Linux 5.3 (x64)

 

**Q5: How do customers get support for the validated solutions?   Who do they call?

**

A5: Customers with valid support agreements with both companies call either Microsoft or Red Hat to have their issues resolved. If the first vendor contacted cannot resolve the issue they will work with the other vendor to come to a resolution for the mutual customer.

**Q6: What level of support agreement is required from Red Hat and Microsoft for a customer to receive support when running RHEL on Windows or Windows on RHEL?

**

A6: Customers with current Microsoft support agreements for Windows Server 2008 will be entitled to obtain support under this agreement. Where an existing agreement is not in place, customers can identify their willingness to purchase ‘per-call’ support. 

Any customer with a valid Red Hat Enterprise Linux subscription, and using Red Hat Enterprise Linux 5.2 or 5.3 guests will be entitled to support under this agreement. 

**Q7: How do these agreements compare to agreements you both have with VMware and/or Citrix?

**

A7: There is no change in Microsoft's or Red Hat's relationship with VMware. Note that both Windows Server and Red Hat Enterprise Linux can be deployed on VMware ESX.  Red Hat doesn’t have any virtualization agreements with Citrix at this time. Both VMware and Citrix have product configurations that have been validated through the Microsoft Server Virtualization Validation Program. 

 

**Q8: How do I find out what validations have been completed?

**

A8: Validations will be posted to the respective Microsoft and Red Hat web sites:

[http://www.redhat.com/rhel/compatibility/hardware/](http://www.redhat.com/rhel/compatibility/hardware/)

[http://www.windowsservercatalog.com/svvp.aspx](http://www.windowsservercatalog.com/svvp.aspx)

**Q9: Who will be the primary beneficiary of this agreement?

**

A9: The primary beneficiary of this agreement will be Microsoft and Red Hat customers. Of course, a secondary beneficiary will be the virtualization ecosystem because it will be more useful to customers, leading to wider deployments and faster technology development.
