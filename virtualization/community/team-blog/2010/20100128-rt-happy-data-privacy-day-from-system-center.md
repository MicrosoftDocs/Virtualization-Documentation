---
layout:     post
title:      "RT&#58; Happy Data Privacy Day from System Center"
date:       2010-01-28 10:45:00
categories: disaster-recovery
---
As many of you are using Hyper-V to host Exchange, SQL and Sharepoint, I'm sure many of you think about backup and recovery of those workloads. If you do, then you'll be interested to read [Jason's blog post](http://blogs.technet.com/systemcenterexperts/archive/2010/01/28/happy-data-privacy-day-from-system-center.aspx "Jason Buffington blog") in honor of Data Privacy Day, which is today if you didn't already have parties planned ;-). Jason's post asks the question "how private is your backup?" and the ways System Center Data Protection Manager 2010 can help. Here's an excerpt:

> **Is your data protected on Tape?    Are the tapes encrypted?**  
> 
> It seems like a simple question, and the process is straightforward.  You check the box that says “Encrypt Tapes”.  But so many folks forget or choose not to.  Sometimes, these kinds of settings are mandated at corporate, but seem to be forgotten by the time that the backup administrator actually is clicking the boxes.
> 
> Thankfully, DPM 2007 and DPM 2010 are PowerShell controllable.  So, consider running a PowerShell script that reaches out to the list of DPM servers and setting the “Encrypt Tape” option after the fact.  This way, no matter how the initial jobs are done, you can push out corporate policies to ensure that your backup tapes are private.
> 
> We covered this and several other easy PowerShell DPM management scenarios in a webcast quite a while ago at <http://msevents.microsoft.com/cui/WebCastEventDetails.aspx?EventID=1032353820> 

Patrick
