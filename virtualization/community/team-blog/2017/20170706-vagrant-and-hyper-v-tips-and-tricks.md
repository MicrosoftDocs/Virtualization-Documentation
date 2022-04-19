---
title: "Vagrant and Hyper-V -- Tips and Tricks"
description: Blog post that includes various tips, including how to install and use various features within Hyper-V.
date: 2017-07-06 22:22:02
author: scooley
ms.author: scooley
ms.date: 08/07/2020
categories: hyper-v
---
# Learning to Use Vagrant on Windows 10

A few months ago, I went to [DockerCon](https://2017.dockercon.com/) as a Microsoft representative. While I was there, I had the chance to ask developers about their favorite tools. The most common tool mentioned (outside of Docker itself) was [Vagrant](https://www.vagrantup.com/). This was interesting -- I was familiar with Vagrant, but I'd never actually used it. I decided that needed to change. Over the past week or two, I took some time to try it out. I got everything working eventually, but I definitely ran into some issues on the way. My pain is your gain -- here are my tips and tricks for getting started with Vagrant on Windows 10 and Hyper-V. **NOTE: This is a supplement for Vagrant's "[Getting Started](https://www.vagrantup.com/intro/getting-started/index.html)" guide, not a replacement.**

## Tip 0: Install Hyper-V

For those new to Hyper-V, make sure you've got Hyper-V running on your machine. Our [official docs](/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v) list the exact steps and requirements.

## Tip 1: Set Up Networking Correctly

Vagrant doesn't know how to set up networking on Hyper-V right now (unlike other providers), so it's up to you to get things working the way you like them. There are a few NAT networks already created on Windows 10 (depending on your specific build). Layered_ICS should work (but is under active development), while Layered_NAT [doesn't have DHCP](https://github.com/mitchellh/vagrant/issues/8573). If you're a Windows Insider, you can try Layered_ICS. If that doesn't work, the safest option is to create an external switch via Hyper-V Manager. This is the approach I took. If you go this route, a friendly reminder that the external switch is tied to a specific network adapter. So if you make it for WiFi, it won't work when you hook up the Ethernet, and vice versa. [caption id="attachment_10175" align="aligncenter" width="879"][![You can also do this with PowerShell](https://msdnshared.blob.core.windows.net/media/2017/07/New-vSwitch-Vagrant-Blog1-1024x606.png)](https://msdnshared.blob.core.windows.net/media/2017/07/New-vSwitch-Vagrant-Blog1.png) Instructions for adding an external switch in Hyper-V manager[/caption].

## Tip 2: Use the Hyper-V Provider

Unfortunately, the [Getting Started](https://www.vagrantup.com/intro/getting-started/index.html) guide uses VirtualBox, and you can't run other virtualization solutions alongside Hyper-V. You need to change the "[provider](https://www.vagrantup.com/intro/getting-started/providers.html)" Vagrant uses at a few different points. When you install your first box, add --provider:

`vagrant box add hashicorp/bionic64 --provider hyperv`


And when you boot your first Vagrant environment, again, add --provider. Note: you might run into the error mentioned in Trick 4, so skip to there if you see something like "mount error(112): Host is down".


`vagrant up --provider hyperv`


## Tip 3: Add the basics to your Vagrantfile

Adding the provider flag is a pain to do every single time you run `vagrant up`. Fortunately, you can set up your Vagrantfile to automate things for you. After running `vagrant init`, modify your vagrant file with the following:

```csharp
Vagrant.configure(2) do |config|
    config.vm.box = "hashicorp/bionic64"
    config.vm.provider "hyperv"
    config.vm.network "public_network"
    end
```
One additional trick here: `vagrant init` will create a file that will appear to be full of commented out items. However, there is one line not commented out: [caption id="attachment_10185" align="aligncenter" width="879"]
![asdf](https://msdnshared.blob.core.windows.net/media/2017/07/VagrantFile_Blog-1024x784.png)](https://msdnshared.blob.core.windows.net/media/2017/07/VagrantFile_Blog.png) There is one line not commented.[/caption] Make sure you delete that line! Otherwise, you'll end up with an error like this:

```csharp
    Bringing machine 'default' up with 'hyperv' provider...
    ==> default: Verifying Hyper-V is enabled...
    ==> default: Box 'base' could not be found. Attempting to find and install...
        default: Box Provider: hyperv
        default: Box Version: >= 0
    ==> default: Box file was not detected as metadata. Adding it directly...
    ==> default: Adding box 'base' (v0) for provider: hyperv
        default: Downloading: base
        default:
    An error occurred while downloading the remote file. The error
    message, if any, is reproduced below. Please fix this error and try
    again.
```

## Trick 4: Shared folders uses SMBv1 for hashicorp/bionic64

For the image used in the "Getting Started" guide (hashicorp/bionic64), Vagrant tries to use SMBv1 for shared folders. However, if you're like me and have [SMBv1 disabled](https://blogs.technet.microsoft.com/filecab/2016/09/16/stop-using-smb1/), this will fail:

```csharp
    Failed to mount folders in Linux guest. This is usually because
    the "vboxsf" file system is not available. Please verify that
    the guest additions are properly installed in the guest and
    can work properly. The command attempted was:

    mount -t cifs -o uid=1000,gid=1000,sec=ntlm,credentials=/etc/smb_creds_e70609f244a9ad09df0e760d1859e431 //10.124.157.30/e70609f244a9ad09df0e760d1859e431 /vagrant

    The error output from the last command was:

    mount error(112): Host is down
    Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
```

You can check if SMBv1 is enabled with this PowerShell Cmdlet:


`Get-SmbServerConfiguration`


If you can live without synced folders, here's the line to add to the vagrantfile to disable the default synced folder.


`config.vm.synced_folder ".", "/vagrant", disabled: true`

If you can't, you can try installing cifs-utils in the VM and re-provision. You could also try [another synced folder method](https://www.vagrantup.com/docs/synced-folders/). For example, rsync works with Cygwin or MinGW. Disclaimer: I personally didn't try either of these methods.

## Tip 5: Enable Nifty Hyper-V Features

Hyper-V has some useful features that improve the Vagrant experience. For example, a pretty substantial portion of the time spent running `vagrant up` is spent cloning the virtual hard drive. A faster way is to use differencing disks with Hyper-V. You can also turn on virtualization extensions, which allow nested virtualization within the VM (i.e. Docker with Hyper-V containers). Here are the lines to add to your Vagrantfile to add these features:

```csharp
    config.vm.provider "hyperv" do |h|
      h.enable_virtualization_extensions = true
      h.linked_clone = true
    end
```
There are a many more customization options that can be added here (i.e. VMName, CPU/Memory settings, integration services). You can find the details in the [Hyper-V provider documentation](https://www.vagrantup.com/docs/hyperv/configuration.html).

## Tip 6: Filter for Hyper-V compatible boxes on Vagrant Cloud

You can find more boxes to use in the Vagrant Cloud (formally called Atlas). They let you filter by provider, so it's easy to find all of the [Hyper-V compatible boxes](https://app.vagrantup.com/boxes/search?provider=hyperv).

## Tip 7: Default to the Hyper-V Provider

While adding the default provider to your Vagrantfile is useful, it means you need to remember to do it with each new Vagrantfile you create. If you don't, Vagrant will trying to download VirtualBox when you `vagrant up` the first time for your new box. Again, VirtualBox doesn't work alongside Hyper-V, so this is a problem.

```csharp
    PS C:\vagrant> vagrant up
    ==>  Provider 'virtualbox' not found. We'll automatically install it now...
         The installation process will start below. Human interaction may be
         required at some points. If you're uncomfortable with automatically
         installing this provider, you can safely Ctrl-C this process and install
         it manually.
    ==>  Downloading VirtualBox 5.0.10...
         This may not be the latest version of VirtualBox, but it is a version
         that is known to work well. Over time, we'll update the version that
         is installed.
```

You can set your default provider on a user level by using the VAGRANT_DEFAULT_PROVIDER environmental variable. For more options (and details), [this](https://www.vagrantup.com/docs/providers/basic_usage.html) is the relevant page of Vagrant's documentation. Here's how I set the user-level environment variable in PowerShell:


    [Environment]::SetEnvironmentVariable("VAGRANT_DEFAULT_PROVIDER", "hyperv", "User")


Again, you can also set the default provider in the Vagrant file (see Trick 3), which will prevent this issue on a per project basis. You can also just add `--provider hyperv` when running `vagrant up`. The choice is yours.

## Wrapping Up

Those are my tips and tricks for getting started with Vagrant on Hyper-V. If there are any you think I missed, or anything you think I got wrong, let me know in the comments. Here's the complete version of my simple starting Vagrantfile:

```csharp
    # -*- mode: ruby -*-
    # vi: set ft=ruby :

    # All Vagrant configuration is done below. The "2" in Vagrant.configure
    # configures the configuration version (we support older styles for
    # backwards compatibility). Please don't change it unless you know what
    # you're doing.
    Vagrant.configure("2") do |config|
      config.vm.box = "hashicorp/bionic64"
      config.vm.provider "hyperv"
      config.vm.network "public_network"
      config.vm.synced_folder ".", "/vagrant", disabled: true
      config.vm.provider "hyperv" do |h|
        h.enable_virtualization_extensions = true
        h.linked_clone = true
      end
    end
```