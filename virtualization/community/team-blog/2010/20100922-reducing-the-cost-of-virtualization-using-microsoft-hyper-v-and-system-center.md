---
title:      "Reducing the cost of virtualization using Microsoft Hyper-V and System Center"
description: The \"War on Cost team\" works to understand the recurring labor costs in managing and operating Microsoft Hyper-V versus VMware’s competing platforms.
author: scooley
ms.author: scooley
date:       2010-09-22 11:23:00
ms.date: 09/22/2010
categories: esx
---
# Reducing the cost of virtualization using Microsoft Hyper-V and System Center

My name is [Elliott Morris](https://blogs.technet.commailto:elliott.morris@microsoft.com?subject=Contacting%20you%20about%20your%20virtualization%20blog%20post), manager of what's known within Microsoft’s Server and Tools Business as the "War on Cost team." The team’s role is to collect operational data from business and public sector customers to understand their costs for deploying, operating and managing Microsoft server and desktop software. We use this information to improve our products, and we also use the opportunity to share our findings, as appropriate, with our customers and partners, such as this [whitepaper on optimizing desktops](https://download.microsoft.com/download/a/4/4/a4474b0c-57d8-41a2-afe6-32037fa93ea6/IDC_windesktop_IO_whitepaper.pdf) and [this whitepaper on managing servers](https://partner.microsoft.com/40097421). Why do I tell you this? To help you understand our role within Microsoft and to demonstrate Microsoft’s commitment to help our customers operate Microsoft software as efficiently as possible.

One of our recent studies was to understand the recurring labor costs in managing and operating Microsoft Hyper-V versus VMware’s competing platforms. The licensing costs of these products are an important consideration for customers, as are the benefits of physical-to-virtual server consolidations. Both items are often discussed to some length in the industry. However, I’ve seen no significant published research that compared the more important recurring operational costs of managing production virtual servers. Our study was originally intended to be used internally within Microsoft to feed into our product planning process, but the results were so eye-opening that they have been made public, which you can download [here](https://download.microsoft.com/download/1/F/8/1F8BD4EF-31CC-4059-9A65-4A51B3B4BC98/Hyper-V-vs-VMware-ESX-and-vShpere-WP.pdf). 

 

I would recommend reviewing the methodology of the study as the findings will be more meaningful. Here are some key points:

·        The respondents were located in the U.S. and were surveyed by an outside market research firm using a [double-blind](http://en.wikipedia.org/wiki/Double-blind#Double-blind_trials) survey.

·        We focused on Hyper-V and ESX/vSphere only.

·        Respondents represent organizations having 500 PCs or more. 

·        The one-time costs were either assumed to be well known (e.g., licensing) or similar enough (e.g., planning, setup) that these costs were out of scope.

·        The statistical “[confidence interval](http://en.wikipedia.org/wiki/Confidence_interval)” is 7.76% with a confidence level of 95%.

 

Here are a few summary points from the study:

·        The IT labor costs varied widely based on the customer’s IT process maturity, but the average costs were $10,357 per guest when hosted on Hyper-V versus $13,629 per guest when hosted on VMware, **a 24% savings for Hyper-V versus VMware,** and Hyper-V customers at every maturity level showed lower costs

·        The average density of Windows Server guests per server was **30% greater for Hyper-V (7.9) than VMware (6.1** ) 

·        Customers using Microsoft system management products to manage their hosts had **15.6% lower annual IT labor costs ($9,486) per  virtual machine than customers using VMware vCenter ($11,238)** and **36.7% lower costs than customers using management products from a mix of vendors ($14,988)

**

 

So what should you make of these results? First, don’t ignore the cost to operate, manage and support the products you are using or are considering to use. The acquisition costs are usually just a piece of the overall total cost of ownership. Second, be careful when reviewing claims, such as VM guest densities, from vendors. Our study used a statistically significant sample size of 154 companies, yet we have seen vendors make bold claims (example, see this [whitepaper](http://www.vmware.com/pdf/TCO.pdf) from VMware) when using a sample size of only 3 companies. _

_

 

You should also know that we don’t have all the answers to where the cost savings originate. Microsoft focuses on building products that are well integrated and easy to use, and thus reduce recurring operational costs. I'm confident that this explains much of what the study found. However, I'm in the process of studying, at a detailed level, how Hyper-V and System Center save customers time and thus money. Stay tuned.

 

Feel free to leave questions in the comments section below, and I’ll do my best to answer your questions.

 

Elliott 

Team's blog: <https://blogs.technet.com/b/itbizval/>

 

 

 

 
