---
title:      "Guest Post&#58; The Green Benefits We've Experienced with a Virtualized Data Center"
description: A guest post by Chris Steffen, Principal Technical Architect with Kroll Factual Data, about green benefits with a virtualized data center.
author: sethmanheim
ms.author: sethm
date:       2009-02-04 12:54:00
ms.date: 02/04/2009
categories: hyper-v
---
# Guest Post: The Green Benefits We've Experienced with a Virtualized Data Center

Greetings! I'm Chris Steffen, Principal Technical Architect with Kroll Factual Data and you may have seen some guest posts from me before. At Kroll Factual Data, we've done a lot of work with virtualization and while flexibility and cost savings were major considerations for initiating our virtualization efforts, I also wanted to share some of the green benefits we've experienced through virtualization technologies.

The most simple and obvious benefit of virtualization is server consolidation and utilization.  For the most part, stand alone servers do not utilize anything near 100% of their resources.  Virtualization is a great technology for enabling you to move and combine stand alone servers onto on a single Hyper-V host.  Ultimately your Hyper-V host configuration will determine the number of Virtual Machines (VMs) that you can run, but we're running about 30 VMs on a single, beefy Hyper-V host.  Today we are running about 650 VMs on 22 Hyper-V hosts, which completely make up our production environment, with each of our VM hosts running at about 90% utilization.

From a numbers perspective:  if you figure that a 1U rackmount stand alone server uses about 10,000 kWh annually, it would take approximately 6,500,000 kWh to run our entire production environment annually on standalone servers.  Using Hyper-V virtualization, we are able to reduce our power consumption to about 700,000 kWh per year, for a savings of nearly 90%.

Keep in mind that this is only a reflection of computer hardware operating costs: it does not include the additional "green" savings that we get from reduced cooling, data center real estate, and computer hardware purchase and maintenance.

Kroll Factual Data commitment to energy awareness extends beyond the data center:  the KFD campus in Loveland, Colorado is run entirely on renewable, wind powered energy.  Kroll Factual Data is serious about environmental stewardship and taking responsibility for our impact on the environment in which we do business. As a technology company, virtualization is a critical component in utilizing technology in an environmentally friendly way.

I recently provided an overview of our green benefits as part of the Microsoft Live and Virtualized Live Meeting series in a session titled "Green IT and Virtualization".  You can listen to the playback of the session and as part of it you'll also hear from Francois Ajenstat, Director, Environmental Sustainability at Microsoft and Ward Ralston, Group Product Manager Windows Server at Microsoft.  Another great tool Microsoft recently made available is the Hyper-Green site, which helps companies calculate their potential green savings through server consolidation on Hyper-V.  I urge you to check out the Live Meeting and the Hyper-Green site when you have a chance.

For KFD, going "green" was not only the right thing for our company to do, virtualization also made it the most cost effective and flexible technology solution.

Thanks – Chris
