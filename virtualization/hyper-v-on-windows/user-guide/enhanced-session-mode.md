---
title: Share devices with Windows virtual machines
description: See how to share devices with Hyper-V virtual machines. Find out how to give a virtual machine access to USB devices, audio, microphones, and mounted drives.
keywords: windows 10, windows 11, hyper-v
author: scooley
ms.author: roharwoo
ms.date: 03/04/2025
ms.topic: article
ms.assetid: d1aeb9cb-b18f-43cb-a568-46b33346a188
---

# Share devices with your virtual machine

When you use enhanced session mode in the Virtual Machine Connection tool (VMConnect), you can connect to Hyper-V virtual machines (VMs) by using remote desktop protocol (RDP). Not only does this capability improve your general VM viewing experience, using RDP also provides a way for the VM and your computer to share devices. This functionality is only available for Windows VMs.

Using RDP in enhanced session mode offers many benefits:

- Makes VMs resizable and high-DPI aware.
- Improves VM integration:
  - Shared clipboard
  - File sharing via dragging or copying and pasting
- Makes device sharing possible:
  - Microphone and speakers
  - USB devices
  - Data disks, including drive C
  - Printers

Because RDP is turned on by default in Windows 10, you probably already use RDP to connect to your Windows VMs. This article highlights some of the benefits and hidden options in the connection settings dialog. It shows you how to see your session type, enter enhanced session mode, and configure your session settings.

## Check the session type

You can check your connection type by using the enhanced session mode icon in the top of VMConnect. You can also use this button to switch between basic session mode and enhanced session mode.

:::image type="content" source="media/esm-button-location.png" alt-text="Screenshot of VMConnect. On the tool bar, an icon is highlighted that indicates whether enhanced session mode is turned on.":::

| Icon | Connection state |
|:-----|:---------|
|:::image type="icon" source="media/esm-basic.png" lightbox="media/esm-basic.png":::| You're currently running in enhanced session mode. Selecting this icon reconnects you to your VM in basic mode. |
|:::image type="icon" source="media/esm-connect.png" lightbox="media/esm-connect.png":::| You're currently running in basic session mode, but enhanced session mode is available. Selecting this icon reconnects you to your VM in enhanced session mode. |
|:::image type="icon" source="media/esm-stop.png" lightbox="media/esm-stop.png":::| You're currently running in basic session mode.  Enhanced session mode isn't available for this VM. |

## Configure VM for Remote Desktop

Enhanced session mode requires Remote Desktop to be turned on in the VM. In the Settings app or Start menu, search for **Remote Desktop settings**. Turn on the **Enable Remote Desktop** toggle.

:::image type="content" source="media/remote-desktop-settings.png" alt-text="Screenshot of the Remote Desktop page in the Settings app. The Enable Remote Desktop toggle is in the on position.":::

Windows 10, version 2004, and later versions require an extra setting. This requirement applies to Windows 11. If the background of the VMConnect window doesn't contain a sign-in prompt, you need to make one more change:

1. Sign in to the VM by using basic session mode.

1. In the Settings app or Start menu, search for **Sign-in options**.

1. On the **Sign-in options** page, turn off the toggle for requiring Windows Hello sign-in for Microsoft accounts.

   | Windows 11 | Windows 10 |
   |:----|:----|
   |:::image type="content" source="media/sign-in-options-win11.png" alt-text="Screenshot of the Sign-in options page in VMConnect in Windows 11. The toggle for requiring Windows Hello sign-in is highlighted." lightbox="media/sign-in-options-win11.png":::|:::image type="content" source="media/sign-in-options.png" alt-text="Screenshot of the Sign-in options page in Settings in Windows 10. The toggle for requiring Windows Hello sign-in is highlighted." lightbox="media/sign-in-options.png":::|

1. Sign out of the VM or reboot it before you close the VMConnect window.

## Share drives and devices

You can find the device sharing capabilities of enhanced session mode in the connection dialog that opens when you connect to a VM:

:::image type="content" source="media/esm-default-view.png" alt-text="Screenshot of the connection dialog. Below the size, which is set to 1366 by 768 pixels, a Show Options button is visible.":::

In enhanced session mode, VMs have access to the clipboard and printers by default. The VMs are also configured by default to transfer audio to your computer's speakers.

To share devices with your VM or to change the default settings:

1. In VMConnect, select the virtual machine that you want to connect to.

1. Select **Show Options**.

   :::image type="content" source="media/esm-show-options.png" alt-text="Screenshot of the connection dialog. The Show Options button is highlighted.":::

1. Select **Local Resources**, and then adjust the settings.

   :::image type="content" source="media/esm-local-resources.png" alt-text="Screenshot of the connection dialog. The Local Resources tab is highlighted.":::

### Share storage and USB devices

Besides the clipboard and printers, VMs have access to smart cards and other security devices in enhanced session mode. As a result, you can use more secure sign-in tools from your VM.

To share other devices with a VM, such as USB devices or drive C, take the following steps:

1. Under **Local devices and resources**, select **More**.

   :::image type="content" source="media/esm-more-devices.png" alt-text="Screenshot of the Local Resources tab of the connection dialog. Under local devices and resources, the More button is highlighted.":::

1. Select the devices that you want to share with the VM. The system drive, which is drive C on Windows, is especially helpful for file sharing.

   :::image type="content" source="media/esm-drives-usb.png" alt-text="Screenshot of the Local Resources page. In a list of devices, the line for Smart cards is selected.":::

### Share audio devices (speakers and microphones)

Because VMs transfer audio by default in enhanced session mode, you can hear audio from the VM on the host machine. The VM uses the audio device that's currently selected on the host machine.

To change these settings, or to add microphone pass-through so that you can record audio in a VM:

1. Select **Settings** to configure remote audio settings.

   :::image type="content" source="media/esm-audio.png" alt-text="Screenshot of the Local Resources tab of the connection dialog. Under Remote audio, the Settings button is highlighted.":::

1. Configure audio and microphone settings.

   :::image type="content" source="media/esm-audio-settings.png" alt-text="Screenshot of the Audio settings page. Remote audio is set to play on this computer, and remote audio recording is turned off.":::

   If your VM is running locally, the **play on this computer** and **play on remote computer** options yield the same results.

## Reopen the connection settings

If you don't see the **Display configuration** dialog or the **Show Options** button, try opening VMConnect independently from either the Windows menu or the command line as an administrator.

```PowerShell
vmconnect.exe
```
