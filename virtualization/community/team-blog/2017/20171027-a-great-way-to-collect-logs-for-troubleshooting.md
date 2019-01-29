---
title:      "A great way to collect logs for troubleshooting"
date:       2017-10-27 23:30:39
categories: hyper-v
---
Did you ever have to troubleshoot issues within a Hyper-V cluster or standalone environment and found yourself switching between different event logs? Or did you repro something just to find out not all of the important Windows event channels had been activated? To make it easier to collect the right set of event logs into a single evtx file to help with troubleshooting we have published a [HyperVLogs PowerShell module](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/live/hyperv-tools/HyperVLogs) on GitHub.  In this blog post I am sharing with you how to get the module and how to gather event logs using the functions provided. 

### Step 1: Download and import the PowerShell module

First of all you need to download the PowerShell module and import it. 

### Step 2: Reproduce the issue and capture logs

Now, you can use the functions provided as part of the module to collect logs for different situations. For example, to investigate an issue on a single node, you can collect events with the following steps:  Using this module and its functions made it a lot easier for me to collect the right event data to help with investigations. Any feedback or suggestions are highly welcome. Cheers, Lars
