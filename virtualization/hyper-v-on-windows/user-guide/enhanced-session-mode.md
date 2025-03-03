---
title: Share devices with Windows virtual machines
description: Walks you through sharing devices with Hyper-V virtual machines (USB, audio, microphone, and mounted drives).
keywords: windows 10, windows 11, hyper-v
author: scooley
ms.author: roharwoo
ms.date: 10/20/2017
ms.topic: article
ms.assetid: d1aeb9cb-b18f-43cb-a568-46b33346a188
---

# Share devices with your virtual machine

In enhanced session mode, you can connect to Hyper-V virtual machines (VMs) by using remote desktop protocol (RDP). Not only does this capability improve your general VM viewing experience, using RDP also provides a way for the VM and your computer to share devices. This functionality is only available for Windows VMs.

Because RDP is turned on by default in Windows 10, you probably already use RDP to connect to your Windows VMs. This article highlights some of the benefits and hidden options in the connection settings dialog.

RDP/Enhanced Session mode does the following:

- Makes VMs resizable and high DPI aware.
- Improves VM integration
  - Shared clipboard
  - File sharing via drag drop and copy paste
- Allows device sharing
  - Microphone/Speakers
  - USB devices
  - Data disks (including C:)
  - Printers

This article shows you how to see your session type, enter enhanced session mode, and configure your session settings.

## Check session type

You can check your connection type by using the enhanced session mode icon in the top of the Virtual Machine Connection tool (VMConnect). You can also use this button to switch between basic session mode and enhanced session mode.

![Screenshot of the Enhanced Session mode icon emphasized in the VM Connect tool bar.](media/esm-button-location.png)

| Icon | Connection state |
|:-----|:---------|
|:::image type="icon" source="media/esm-basic.png" lightbox="media/esm-basic.png":::| You're currently running in enhanced session mode. Selecting this icon reconnects you to your VM in basic mode. |
|:::image type="icon" source="media/esm-connect.png" lightbox="media/esm-connect.png":::| You're currently running in basic session mode, but enhanced session mode is available. Selecting this icon reconnects you to your VM in enhanced session mode. |
|:::image type="icon" source="media/esm-stop.png" lightbox="media/esm-stop.png":::| You're currently running in basic session mode.  Enhanced session mode isn't available for this VM. |

## Configure VM for Remote Desktop

Enhanced session mode requires Remote Desktop to be turned on in the VM. In the Settings app or Start menu, search for **Remote Desktop settings**. Turn on the **Enable Remote Desktop** toggle.

![Enable Remote Desktop](media/remote-desktop-settings.png)

Windows 10, version 2004, and later versions require an extra setting. This requirement applies to Windows 11. If the background of the VMConnect window doesn't contain a sign-in prompt, you need to make one more change:

1. Sign in to the VM by using basic session mode.

1. In the Settings app or Start menu, search for **Sign-in options**.

1. On the **Sign-in options** page, turn off the toggle for requiring Windows Hello sign-in for Microsoft accounts.

   | Windows 11 | Windows 10 |
   |:----|:----|
   |[ ![Disable Require Windows Hello sign-in Win 11](media/sign-in-options-win11.png) ](media/sign-in-options-win11.png#lightbox)|[ ![Disable Require Windows Hello sign-in](media/sign-in-options.png) ](media/sign-in-options.png#lightbox) |

1. Sign out of the VM or reboot it before you close the VMConnect window.

## Share drives and devices

You can find the device sharing capabilities of enhanced session mode in the Display configuration window that opens when you connect to a VM:

![Screenshot of the connection pop up with a Display configuration of 1366 by 768 pixels.](media/esm-default-view.png)

In enhanced session mode, VMs have access to the clipboard and printers by default. The VMs are also configured by default to transfer audio to your computer's speakers.

To share devices with your VM or to change the default settings:

1. In VMConnect, select the virtual machine that you want to connect to.

1. Select **Show Options**.

   ![Screenshot of the connection pop up with the Show Options drop down emphasized.](media/esm-show-options.png)

1. Select **Local Resources**, and then adjust the settings.

   ![Screenshot of the connection pop up with the Local Resources tab emphasized.](media/esm-local-resources.png)

### Share storage and USB devices

Besides the clipboard and printers, VMs have access to smart cards and other security devices in enhanced session mode. As a result, you can use more secure sign-in tools from your VM.

To share other devices with a VM, such as USB devices or drive C, take the following steps:

1. Under **Local devices and resources**, select **More**.

   ![Screenshot of the More button emphasized in the Local devices and resources section.](media/esm-more-devices.png)

1. Select the devices that you want to share with the VM. The system drive, which is drive C on Windows, is especially helpful for file sharing.

   ![Screenshot of Smart cards selected in the Local Resources dialog.](media/esm-drives-usb.png)

### Share audio devices (speakers and microphones)

Because VMs transfer audio by default in enhanced session mode, you can hear audio from the VM on the host machine. The VM uses the audio device that's currently selected on the host machine.

To change these settings, or to add microphone pass-through so that you can record audio in a VM:

1. Select **Settings** to configure remote audio settings.

   ![Screenshot of the Settings button emphasized in the Remote audio section.](media/esm-audio.png)

1. Configure audio and microphone settings.

   ![Screenshot of Remote audio playback set to Play on this computer and disabling Remote audio recording.](media/esm-audio-settings.png)

   If your VM is running locally, the **play on this computer** and **play on remote computer** options yield the same results.

## Reopen the connection settings

If you don't see the **Display configuration** dialog or the **Show Options** button, try opening VMConnect independently from either the Windows menu or the command line as an administrator.

```PowerShell
vmconnect.exe
```
