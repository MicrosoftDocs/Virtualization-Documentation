---
title: Enable Hyper-V on Windows
description: Install Hyper-V on Windows 11.
keywords: windows 11, hyper-v
author: scooley
ms.author: scooley
ms.date: 07/29/2024
ms.topic: article
ms.assetid: 752dc760-a33c-41bb-902c-3bb2ecd9ac86
---

# Install Hyper-V on Windows 11

Enable Hyper-V to create virtual machines on Windows 11. Hyper-V can be enabled in many ways including using the Windows 11 control panel, PowerShell or using the Deployment Imaging Servicing and Management tool (DISM). This documents walks through each option.

> **Note:**  Hyper-V is built into Windows as an optional feature -- there's no Hyper-V download.

## Check requirements

* Windows 11 Enterprise, or Pro
* 64-bit Processor with Second Level Address Translation (SLAT).
* CPU support for VM Monitor Mode Extension (VT-c on Intel CPUs).
* Minimum of 4 GB memory.

The Hyper-V role **can't** be installed on Windows 11 Home.

Upgrade from Windows 11 Home edition to Windows 11 Pro by opening up **Settings** > **Update and Security** > **Activation**.

For more information and troubleshooting, see [Windows 11 Hyper-V System Requirements](../reference/hyper-v-requirements.md).

## Enable Hyper-V using PowerShell

1. Open a PowerShell console as Administrator.

1. Run the following command:

  ```powershell
  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
  ```

  If the command isn't found, make sure you're running PowerShell as Administrator.

1. When the installation completes, reboot.

## Enable Hyper-V with CMD and DISM

The Deployment Image Servicing and Management tool (DISM) helps configure Windows and Windows images.  Among its many applications, DISM can enable Windows features while the operating system is running.

To enable the Hyper-V role using DISM:

1. Open up a PowerShell or CMD session as Administrator.

1. Type the following command:

  ```powershell
  DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
  ```

  ![Console window showing Hyper-V being enabled.](media/dism_upd.png)

For more information about DISM, see the [DISM Technical Reference](/windows-hardware/manufacture/desktop/dism-reference--deployment-image-servicing-and-management?view=windows-11).

## Enable the Hyper-V role through Settings

1. Right-click on the Windows button and select ‘Apps and Features’.

1. Select **Programs and Features** on the right under related settings.

1. Select **Turn Windows Features on or off**.

1. Select **Hyper-V** and then select **OK**.

![Windows programs and features dialogue box](media/enable_role_upd.png)

When the installation completes you're prompted to restart your computer.

## Make virtual machines

[Create your first virtual machine](create-virtual-machine.md)
