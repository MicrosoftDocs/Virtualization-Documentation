---
title:      "What's new in Hyper-V for Windows 10 Fall Creators Update?"
date:       2017-11-13 18:00:46
categories: hyper-v
---
[Windows 10 Fall Creators Update](https://blogs.windows.com/windowsexperience/2017/10/17/whats-new-windows-10-fall-creators-update) has arrived! While we’ve been blogging about new features as they appear in Windows Insider builds, many of you have asked for a consolidated list of Hyper-V updates and improvements since Creators Update in April. Summary: 

  * Quick Create includes a gallery (and you can add your own images)
  * Hyper-V has a Default Switch for easy networking
  * It’s easy to revert virtual machines to their start state
  * Host battery state is visible in virtual machines
  * Virtual machines are easier to share




## Quick Create virtual machine gallery

The virtual machine gallery in Quick Create makes it easy to find virtual machine images in one convenient location. [![image](https://msdnshared.blob.core.windows.net/media/2017/11/image_thumb94.png)](https://msdnshared.blob.core.windows.net/media/2017/11/image109.png) You can also add your own virtual machine images to the Quick Create gallery. Building a custom gallery takes some time but, once built, makes creating virtual machines easy and consistent. [This blog post](https://blogs.technet.microsoft.com/virtualization/2017/11/08/create-your-custom-quick-create-vm-gallery/) walks through adding custom images to the gallery. ![](https://msdnshared.blob.core.windows.net/media/2017/11/customquickcreategallery.png) For images that aren’t in the gallery, select “Local Installation Source” to create a virtual machine from an .iso or vhd located somewhere in your file system. Keep in mind, while Quick Create and the virtual machine gallery are convenient, they are not a replacement for the New Virtual Machine wizard in Hyper-V manager. For more complicated virtual machine configuration, use that. 

## Default Switch

[![](https://msdnshared.blob.core.windows.net/media/2017/11/DefaultSwitch.png)](https://msdnshared.blob.core.windows.net/media/2017/11/DefaultSwitch.png) The switch named “Default Switch” allows virtual machines to share the host’s network connection using NAT (Network Address Translation). This switch has a few unique attributes: 

  1. Virtual machines connected to it will have access to the host’s network whether you’re connected to WIFI, a dock, or Ethernet. It will also work when the host is using VPN or proxy.
  2. It’s available as soon as you enable Hyper-V – you won’t lose internet setting it up.
  3. You can’t delete or rename it.
  4. It has the same name and device ID on all Windows 10 Fall Creator’s Update Hyper-V hosts. Name: Default Switch ID: c08cb7b8-9b3c-408e-8e30-5e16a3aeb444

Yes, the default switch does automatically assign an IP to the virtual machine (DNS and DHCP). I’m really excited to have a always-available network connection for virtual machines on Hyper-V. The Default Switch offers the best networking experience for virtual machines on a laptop. If you need highly customized networking, however, continue using Virtual Switch Manager. 

## Revert! (automatic checkpoints)

This is my personal favorite feature from Fall Creators Update. For a little bit of background, I mostly use virtual machines to build/run demos and to sandbox simple experiments. At least once a month, I accidently mess up my virtual machine. Sometimes I remember to make a checkpoint and I can roll back to a good state. Most of the time I don’t. Before automatic checkpoints, I’d have to choose between rebuilding my virtual machine or manually undoing my mistake. Starting in Fall Creators Update, Hyper-V creates a checkpoint when you start virtual machines. Say you’re learning about Linux and accidently `rm –rf /*` or update your guest and discover a breaking change, now you can simply revert back to when the virtual machine started. [![image](https://msdnshared.blob.core.windows.net/media/2017/11/image_thumb96.png)](https://msdnshared.blob.core.windows.net/media/2017/11/image111.png) Automatic checkpoints are enabled by default on Windows 10 and disabled by default on Windows Server. They are not useful for everyone. For people with automation or for those of you worried about the overhead of making a checkpoint, you can disable automatic checkpoints with PowerShell (Set-VM –Name VMwithAutomation –AutomaticCheckpointsEnabled) or in VM settings under “Checkpoints”. Here’s a [link](https://blogs.technet.microsoft.com/virtualization/2017/04/20/making-it-easier-to-revert/) to the original announcement with more information. 

## Battery pass-through

Virtual machines in Fall Creators Update are aware of the hosts battery state. [![image](https://msdnshared.blob.core.windows.net/media/2017/11/image_thumb128.png)](https://msdnshared.blob.core.windows.net/media/2017/11/image150.png)This is nice for a few reasons: 

  1. You can see how much battery life you have left in a full-screen virtual machine.
  2. The guest operating system knows the battery state and can optimize for low power situations.



## Easier virtual machine sharing

Sharing your Hyper-V virtual machines is easier with the new “Share” button. Share packages and compresses your virtual machine so you can move it to another Hyper-V host right from Virtual Machine Connection. [![image](https://msdnshared.blob.core.windows.net/media/2017/11/image_thumb129.png)](https://msdnshared.blob.core.windows.net/media/2017/11/image151.png) Share creates a “.vmcz” file with your virtual hard drive (vhd/vhdx) and any state the virtual machine will need to run. “Share” will not include checkpoints. If you would like to also export your checkpoints, you can use the “Export” tool, or the “Export-VM” PowerShell cmdlet. [![clip_image002](https://msdnshared.blob.core.windows.net/media/2017/07/clip_image002_thumb.png)](https://msdnshared.blob.core.windows.net/media/2017/07/clip_image002.png) Once you’ve moved your virtual machine to another computer with Hyper-V, double click the “.vmcz” file and the virtual machine will import automatically. \---- That’s the list! As always, please send us feedback via FeedbackHub. Curious what we’re building next? [Become a Windows Insider](https://insider.windows.com/) – almost everything here has benefited from your early feedback. Cheers, Sarah
