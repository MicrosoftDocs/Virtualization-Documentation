---
layout:     post
title:      "Sneak Peek&#58; Taking a Spin with Enhanced Linux VMs"
date:       2018-02-28 22:31:29
categories: enhanced-session-mode
---
Whether you're a developer or an IT admin, virtual machines are familiar tools that allow users to run entirely separate operating system instances on a host. And despite being a separate OS, we feel there's a great importance in having a VM experience that feels tightly integrated with the host. We invested in making the Windows client VM experience first-class, and users really liked it. Our users asked us to go further: they wanted that same first-class experience on Linux VMs as well. As we thought about how we could deliver a better-quality experience--one that achieved closer parity with Windows clients--we found an opportunity to collaborate with the open source folks at [XRDP](https://github.com/neutrinolabs/xrdp), who have implemented Microsoft’s RDP protocol on Linux. We’re partnering with [Canonical](https://www.canonical.com/) on the upcoming Ubuntu 18.04 release to make this experience a reality, and we’re working to provide a solution that works out of the box. Hyper-V’s [Quick Create VM gallery](https://blogs.technet.microsoft.com/virtualization/2017/07/26/hyper-v-virtual-machine-gallery-and-networking-improvements/) is the perfect vehicle to deliver such an experience. With only 3 mouse clicks, users will be able to get an Ubuntu VM running that offers clipboard functionality, drive redirection, and much more. But you don’t have to wait until the release of Ubuntu 18.04 to try out the improved Linux VM experience. Read on to learn how you can get a sneak peek! _Disclaimer: **This feature is under development.** This tutorial outlines steps to have an enhanced Ubuntu experience in 16.04. Our TARGET experience will be with 18.04. There may be some bugs you discover in 16.04--and that's okay! We want to gather this data so we can make the 18.04 experience great. _ [![](https://msdnshared.blob.core.windows.net/media/2018/02/copy-paste.gif)](https://msdnshared.blob.core.windows.net/media/2018/02/copy-paste.gif)

## **A Call for Testing**

We've chosen Canonical's next LTS release, Bionic Beaver, to be the focal point of our investments. In the lead up to the official release of 18.04, we'd like to begin getting feedback on how satisfied users are with the general experience. The experience we’re working towards in Ubuntu 18.04 can be set up in Ubuntu 16.04 (with a few extra steps). We will walk through how to set up an Ubuntu 16.04 VM running in Hyper-V with Enhanced Session Mode. In the future, you can expect to be able to find an Ubuntu 18.04 image sitting in the Hyper-V Quick Create galley 😊 **NOTE: In order to participate in this tutorial, you need to be on Insider Builds, running at minimum Insider Build No. 17063**

## **Tutorial**

Grab the Ubuntu 16.04 ISO from Canonical's website, found at [releases.ubuntu.com](http://releases.ubuntu.com/16.04.3/ubuntu-16.04.3-desktop-amd64.iso). Provision the VM as you normally would and step through the installation process. We created a set of scripts to perform all the heavy lifting to set up your environment appropriately. Once your VM is fully operational, we'll be executing the following commands inside of it. `#Get the scripts from GitHub $ sudo apt-get update $ sudo apt install git $ git clone <https://github.com/Microsoft/linux-vm-tools.git> ~/linux-vm-tools $ cd ~/ linux-vm-tools/ubuntu/16.04/` `#Make the scripts executable and run them... $ sudo chmod +x install.sh $ sudo chmod +x config-user.sh $ sudo ./install.sh` **Install.sh will need to be run twice in order for the script to execute fully (it must perform a reboot mid-script)**. That is, once your VM reboots, you'll need to change dir into the location of the script and run again. Once you've finished running the install.sh script, you'll need to run config-user.sh `$ sudo ./config-user.sh` After you've run your scripts, shut down your VM. On your host machine in a powershell prompt, execute this command: `Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket` Now, when you boot your VM, you will be greeted with an option to connect and adjust your display size. This will be an indication that you're running in an enhanced session mode. Click "connect" and you're complete. [![](https://msdnshared.blob.core.windows.net/media/2018/02/enhancedmode.png)](https://msdnshared.blob.core.windows.net/media/2018/02/enhancedmode.png)

## What are the Benefits?

These are the features that you get with the new enhanced session mode: 

  * Better mouse experience
  * Integrated clipboard
  * Window Resizing
  * Drive Redirection

We encourage you to log any issues you discover [to GitHub](https://github.com/jterry75/xrdp-init/issues). This will also give you an idea of already identified issues. 

## How does this work?

The technology behind this mode is actually the same as how we achieve an enhanced session mode in Windows. It relies on the [RDP protocol](https://msdn.microsoft.com/en-us/library/aa383015\(v=vs.85\).aspx), implemented on Linux by the open source folks at XRDP, over Hyper-V sockets to light up all the great features that give the VM an integrated feel. Hyper-V sockets, or hv_sock, supply a byte-stream based communication mechanism between the host partition and the guest VM. Think of it as similar to TCP, except it's going over an optimized transport layer called VMBus. We contributed changes which would allow XRDP to utilize hv_sock. The scripts we executed did the following: 

  * Installs the "Linux-azure" kernel to the VM. This carries the hv_sock bits that we need.
  * Downloads the XRDP source code and compiles it with the hv_sock feature turned on (the published XRDP package in 16.04 doesn't have this set, so we must compile from source).
  * Builds and installs xorgxrdp.
  * Configures the user session for RDP
  * Launches the XRDP service

As we mentioned earlier, the steps described above are for Ubuntu 16.04, which will look a little different from 18.04. In fact, with Ubuntu 18.04 shipping with the 4.15 linux kernel (which already carries the hv_sock bits), we won’t need to apply the linux-azure kernel. The version of XRDP that ships as available in 18.04 is already compiled with hv_sock feature turned on, so there’s no more need to build xrdp/xorgxrdp—a simple “apt install” will bring in all the feature goodness! If you’re not flighting insider builds, **you can look forward to having this enhanced VM experience via the VM gallery when Ubuntu 18.04 is released at the end of April.** Leave a comment below on your experience or tweet me with your thoughts! ****Update: We've had a few delays getting the image configured correctly for the gallery. We will post a new blog post when the feature does land in the Quick Create Gallery. We appreciate your patience!**** Cheers, Craig Wilhite ([@CraigWilhite](https://twitter.com/CraigWilhite))
