---
layout:     post
title:      "Editing VMConnect session settings"
date:       2017-02-02 21:00:39
categories: hyper-v
---
When you connect to a VM with Virtual Machine Connection in enhanced session mode, you're prompted to choose some settings for display and local resources. [![VMConnect Session Settings](https://msdnshared.blob.core.windows.net/media/2017/02/Capture.png)](https://msdnshared.blob.core.windows.net/media/2017/02/Capture.png) The main thing that changes between sessions is usually display configuration. But since you can now [resize after connecting](https://blogs.technet.microsoft.com/virtualization/2017/01/27/introducing-vmconnect-dynamic-resize/) starting in the latest Insider build, you might not want to see this page each time you connect. You can select "Save my settings for future connections to this virtual machine" and you won't see this page for future sessions.  [![VMConnect save session settings](https://msdnshared.blob.core.windows.net/media/2017/02/Capture77.png)](https://msdnshared.blob.core.windows.net/media/2017/02/Capture77.png)   However, you might want to occasionally configure local resources like audio and devices, so there are 2 easy ways to get back to these settings: 

  1. In Hyper-V Manager, you will see an option to " **Edit Session Settings...** " for any VM for which you have saved settings. [ ](https://msdnshared.blob.core.windows.net/media/2017/02/Capture22.png)[![VMConnect edit session settings](https://msdnshared.blob.core.windows.net/media/2017/02/Capture22.png) ](https://msdnshared.blob.core.windows.net/media/2017/02/Capture22.png)
  2. Open VMConnect from command line or Powershell, and specify the **/edit** flag to open the session settings. 

[![capture33](https://msdnshared.blob.core.windows.net/media/2017/02/Capture33.png) ](https://msdnshared.blob.core.windows.net/media/2017/02/Capture33.png) Cheers, Andy
