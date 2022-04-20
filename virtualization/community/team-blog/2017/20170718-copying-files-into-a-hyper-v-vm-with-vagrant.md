---
title: Copying Files into a Hyper-V VM with Vagrant
description: Learn about using Vagrant to enable coping virtual machine files into a Hyper-V environment.
author: mattbriggs
ms.author: mabrigg
date:       2017-07-18 21:50:09
ms.date: 07/18/2017
categories: hyper-v
---
# Copying Files into a Hyper-V VM with Vagrant

A couple of weeks ago, I published a [blog](https://blogs.technet.microsoft.com/virtualization/2017/07/06/vagrant-and-hyper-v-tips-and-tricks/) with tips and tricks for getting started with Vagrant on Hyper-V. My fifth tip was to "Enable Nifty Hyper-V Features," where I briefly mentioned stuff like differencing disks and virtualization extensions. While those are useful, I realized later that I should have added one more feature to my list of examples: the "guest_service_interface" field in "vm_integration_services." It's hard to know what that means just from the name, so I usually call it the "the thing that lets me copy files into a VM." Disclaimer: this is _not_ a replacement for [Vagrant's synced folders](https://www.vagrantup.com/docs/synced-folders/). Those are super convienent, and should really be your default solution for sharing files. This method is more useful in one-off situations. 

## Enabling Copy-VMFile

Enabling this functionality requires a simple change to your Vagrantfile. You need to set "guest_service_interface" to true within "vm_integration_services" configuration hash. Here's what my Vagrantfile looks like for CentOS 7:

```code
    # -*- mode: ruby -*-
    # vi: set ft=ruby :
    
    Vagrant.configure("2") do |config|
      config.vm.box = "centos/7"
      config.vm.provider "hyperv"
      config.vm.network "public_network"
      config.vm.synced_folder ".", "/vagrant", disabled: true
      config.vm.provider "hyperv" do |h|
        h.enable_virtualization_extensions = true
        h.differencing_disk = true
        h.vm_integration_services = {
          guest_service_interface: true  #<---------- this line enables Copy-VMFile
      }
      end
    end
```

You can check that it's enabled by running `Get-VMIntegrationService` in PowerShell on the host machine:

```code
  PS C:\vagrant_selfhost\centos>  Get-VMIntegrationService -VMName "centos-7-1-1.x86_64"
    VMName              Name                    Enabled PrimaryStatusDescription SecondaryStatusDescription
    ------              ----                    ------- ------------------------ --------------------------
    centos-7-1-1.x86_64 Guest Service Interface True    OK
    centos-7-1-1.x86_64 Heartbeat               True    OK
    centos-7-1-1.x86_64 Key-Value Pair Exchange True    OK                       The protocol version of...
    centos-7-1-1.x86_64 Shutdown                True    OK
    centos-7-1-1.x86_64 Time Synchronization    True    OK                       The protocol version of...
    centos-7-1-1.x86_64 VSS                     True    OK                       The protocol version of...
```

_Note_ : not all integration services work on all guest operating systems. For example, this functionality will not work on the "Precise" Ubuntu image that's used in Vagrant's "Getting Started" guide. The full compatibility list various Windows and Linux distrobutions can be found [here](/windows-server/virtualization/hyper-v/supported-linux-and-freebsd-virtual-machines-for-hyper-v-on-windows). Just click on your chosen distrobution and check for "File copy from host to guest." 

## Using Copy-VMFile

Once you've got a VM set up correctly, copying files to and from arbitrary locations is as simple as running `Copy-VMFile` in PowerShell. Here's a sample test I used to verify it was working on my CentOS VM: `Copy-VMFile -Name 'centos-7-1-1.x86_64' -SourcePath '.\Foo.txt' -DestinationPath '/tmp' -FileSource Host`
    

Full details can found in the [official documentation](https://technet.microsoft.com/itpro/powershell/windows/hyper-v/copy-vmfile). Unfortunately, you can't yet use it to copy files from your VM to your host. If you're running a Windows Guest, you can use `Copy-Item` with PowerShell Direct to make that work; see [this document](/virtualization/hyper-v-on-windows/user-guide/powershell-direct#copy-files-with-new-pssession-and-copy-item) for more details. 

## How Does It Work?

The way this works is by running Hyper-V integration services within the guest operating system. Full details can be found in the [official documentation](/virtualization/hyper-v-on-windows/reference/integration-services). The short version is that integration services are Windows Services (on Windows) or Daemons (on Linux) that allow the guest operating system to communicate with the host. In this particular instance, the integration service allows us to copy files to the VM over the VM Bus (no network required!). 

## Conclusion

Hope you find this helpful -- let me know if there's anything you think I missed. John Slack Program Manager Hyper-V Team 
