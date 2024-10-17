---
title: What is Nested Virtualization for Hyper-V?
description: Learn about Nested Virtualization in Hyper-V, including what it is, how it works, and supported scenarios.
author: robinharwood
ms.author: roharwoo
ms.topic: concept-article
ms.date: 07/31/2024
#CustomerIntent: As a virtualization admin, I was to understand what Nested Virtualization is, so that I apply it to my own environment.
---

# What is Nested Virtualization?

Nested virtualization is a feature that lets you run Hyper-V inside a Hyper-V virtual machine (VM). Over the years hardware has improved and the use cases for Nested Virtualization have expanded. For example, Nested Virtualization can be useful for:

- Running applications or emulators in a nested VM
- Testing software releases on VMs
- Reducing deployment times for training environments
- Using Hyper-V isolation for containers

Modern processors include hardware features that make virtualization faster and more secure. Hyper-V relies on these processor extensions to run virtual machines, for example, Intel VT-x and AMD-V. Nested virtualization makes this hardware support available to guest virtual machines.

The following diagram shows Hyper-V without nesting.  The Hyper-V hypervisor takes full control of the hardware virtualization capabilities (orange arrow), and doesn't expose them to the guest operating system.

:::image type="content" source="media/HVNoNesting.PNG" alt-text="Diagram of the levels of Hyper V with Nested Virtualization disabled.":::

In contrast, the following diagram shows Hyper-V with Nested Virtualization enabled. In this case, Hyper-V exposes the hardware virtualization extensions to its virtual machines. With nesting enabled, a guest virtual machine can install its own hypervisor and run its own guest VMs.

:::image type="content" source="media/HVNesting.PNG" alt-text="Diagram of the levels of Hyper V with Nested Virtualization enabled.":::

## Dynamic Memory and Runtime Memory Resize

When Hyper-V is running inside a virtual machine, the virtual machine must be turned off to adjust its memory. Meaning that even if dynamic memory is enabled, the amount of memory doesn't fluctuate. Simply enabling nested virtualization has no effect on dynamic memory or runtime memory resize.

For virtual machines without dynamic memory enabled, attempting to adjust the amount of memory while running fails. The incompatibility only occurs while Hyper-V is running in the VM.

## Third party virtualization apps

Virtualization applications other than Hyper-V aren't supported in Hyper-V virtual machines, and are likely to fail. Virtualization applications include any software that requires hardware virtualization extensions.

## Supported scenarios

Using a nested Hyper-V VM in production is supported for both Azure and on-premises in the following scenarios. We also recommend you make sure that your services and applications are also supported.

Nested Virtualization isn't suitable for Windows Server Failover Clustering, and performance sensitive applications. We recommended you fully evaluate the services and applications.

### Hyper-V VMs on Hyper-V VMs

Running Hyper-V VMs nested on Hyper-V VMs is great for test labs and evaluation environments. Especially where configurations can be easily modified and saved states can be used to revert to specific configurations. Test labs don't typically require the same service level agreement (SLA) as production environments.

Production environments running Hyper-V VMs running on Hyper-V VMs are supported. However, it's recommended to make sure that your services and applications are also supported. If you use nested Hyper-V VM in production, it is recommended to fully evaluate whether the services or applications provide the expected behavior.

To learn more about setting up Nested Virtualization on Azure, see our Tech Community blog [How to Setup Nested Virtualization for Azure VM/VHD](https://techcommunity.microsoft.com/t5/itops-talk-blog/how-to-setup-nested-virtualization-for-azure-vm-vhd/ba-p/1115338).

### Third party virtualization on Hyper-V virtualization

Whilst it might be possible for third party virtualization to run on Hyper-V, Microsoft doesn't test this scenario. Third party virtualization on Hyper-V virtualization isn't supported, ensure your hypervisor vendor supports this scenario.

### Hyper-V virtualization on third party virtualization

Whilst it might be possible for Hyper-V virtualization to run on third party virtualization, Microsoft doesn't test this scenario. Hyper-V virtualization on third party virtualization isn't supported, ensure your hypervisor vendor supports this scenario.

### Azure Stack HCI nested on Hyper-V VMs

Azure Stack HCI is designed and tested to run on validated physical hardware. Azure Stack HCI can run nested in a virtual machine for evaluation, but production environments in a nested configuration aren't supported.

To learn more about Azure Stack HCI nested on Hyper-V VMs, see [Nested virtualization in Azure Stack HCI](/azure-stack/hci/concepts/nested-virtualization).

### Hyper-V isolated containers running nested on Hyper-V

Microsoft offers Hyper-V isolation for containers. This isolation mode offers enhanced security and broader compatibility between host and container versions. With Hyper-V isolation, multiple container instances run concurrently on a host. Each container runs inside of a highly optimized virtual machine and effectively gets its own kernel. Since a Hyper-V isolated container offers isolation through a hypervisor layer between itself and the container host, when the container host is a Hyper-V based virtual machine, there's performance overhead. The associated performance overhead occurs in terms of container start-up time, storage, network, and CPU operations.

When a Hyper-V isolated container is run in a Hyper-V VM, it's running nested. Using a Hyper-V VM opens many useful scenarios but also increases latency, as there are two levels of hypervisors running above the physical host.

Running Hyper-V isolated containers nested on Hyper-V is supported. One level of nested virtualization is supported in production, which allows for isolated container deployments.

To learn more about Nested Hyper-V Containers, see [Performance tuning Windows Server Containers](/windows-server/administration/performance-tuning/role/windows-server-container/).

### Running WSL2 in a Hyper-V VM running nested on Hyper-V

Windows Subsystem for Linux (WSL) is a feature of the Windows operating system that enables you to run a Linux file system, along with Linux command-line tools and GUI apps, directly on Windows.

Running WSL2 in a Hyper-V VM running nested on Hyper-V is supported.

To learn more about how to enabled WSL 2 to run in a VM, see [Frequently Asked Questions about Windows Subsystem for Linux](/windows/wsl/faq#can-i-run-wsl-2-in-a-virtual-machine-).

## Next step

- [Run Hyper-V in a Virtual Machine with Nested Virtualization](enable-nested-virtualization.md)
