---
layout:     post
title:      "A closer look at VM Quick Create"
date:       2017-01-20 22:19:32
categories: hyper-v
---
  


Author: Andy Atkinson

In the last Insiders build, we introduced Quick Create to quickly create virtual machines with less configuration (see [blog](https://blogs.technet.microsoft.com/virtualization/2017/01/10/cool-new-things-for-hyper-v-on-desktop/)).

[![image](https://msdnshared.blob.core.windows.net/media/2017/01/image_thumb433.png)](https://msdnshared.blob.core.windows.net/media/2017/01/image511.png)

We’re trying a few things to make it easier to set up a virtual machine, such as combining installation options to a single field for all supported file types, and adding a control to enable Windows Secure Boot more easily.

[![image](https://msdnshared.blob.core.windows.net/media/2017/01/image_thumb434.png)](https://msdnshared.blob.core.windows.net/media/2017/01/image512.png)

Quick Create can also help set up your network. If there’s no available switch, you’ll see a button to set up an “automatic network”, which will automatically configure an external switch for the virtual machine and connect it to the network.

To simplify the number of settings, we had to pick some good default settings for the virtual machine, which are currently:

  * Generation: 2
  * StartupRAM: 1024 MB
  * DynamicRAM: Enabled
  * Virtual Processors: 1



After the virtual machine is created, you will see the confirmation page with quick access to edit settings or to connect.

[![image](https://msdnshared.blob.core.windows.net/media/2017/01/image_thumb435.png)](https://msdnshared.blob.core.windows.net/media/2017/01/image513.png)

Are there other controls you want in Quick Create? Are we picking good defaults? 

This is still a work in progress, so let us know what you think!

\- Andy
