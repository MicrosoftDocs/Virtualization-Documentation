---
title:      "Hyper-V virtual machine gallery and networking improvements"
date:       2017-07-26 01:42:39
categories: hyper-v
---
In January, [we added Quick Create](https://blogs.technet.microsoft.com/virtualization/2017/01/10/cool-new-things-for-hyper-v-on-desktop/ "Quick Create") to Hyper-V manager in Windows 10. Quick Create is a single-page wizard for fast, easy, virtual machine creation. Starting in the latest fast-track Windows Insider builds (16237+) we’re expanding on that idea in two ways. Quick Create now includes: 

  1. A virtual machine gallery with downloadable, pre-configured, virtual machines.
  2. A default virtual switch to allow virtual machines to share the host’s internet connection using NAT.

[![image](https://msdnshared.blob.core.windows.net/media/2017/07/image_thumb118.png)](https://msdnshared.blob.core.windows.net/media/2017/07/image139.png) To launch Quick Create, open Hyper-V Manager and click on the “Quick Create…” button (1). From there you can either create a virtual machine from one of the pre-built images available from Microsoft (2) or use a local installation source. Once you’ve selected an image or chosen installation media, you’re done! The virtual machine comes with a default name and a pre-made network connection using NAT (3) which can be modified in the “more options” menu. Click “Create Virtual Machine” and you’re ready to go – granted downloading the virtual machine will take awhile. 

### Details about the Default Switch

The switch named “Default Switch” or “Layered_ICS”, allows virtual machines to share the host’s network connection. Without getting too deep into networking (saving that for a different post), this switch has a few unique attributes compared to other Hyper-V switches: 

  1. Virtual machines connected to it will have access to the host’s network whether you’re connected to WIFI, a dock, or Ethernet.
  2. It’s available as soon as you enable Hyper-V – you won’t lose internet setting it up.
  3. You can’t delete it.
  4. It has the same name and device ID (GUID c08cb7b8-9b3c-408e-8e30-5e16a3aeb444) on all Windows 10 hosts so virtual machines on recent builds can assume the same switch is present on all Windows 10 Hyper-V host.

I’m really excited by the work we are doing in this area. These improvements make Hyper-V a better tool for people running virtual machines on a laptop. They don’t, however, replace existing Hyper-V tools. If you need to define specific virtual machine settings, New-VM or the new virtual machine wizard are the right tools. For people with custom networks or complicated virtual network needs, continue using Virtual Switch Manager. Also keep in mind that all of this is a work in progress. There are rough edges for the default switch right now and there aren't many images in the gallery. Please give us feedback! Your feedback helps us. Let us know what images you would like to see and share issues by commenting on this blog or submitting feedback through Feedback Hub. Cheers, Sarah
