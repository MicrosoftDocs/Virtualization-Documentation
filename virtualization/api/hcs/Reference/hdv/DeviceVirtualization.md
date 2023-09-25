---
title: Device Virtualization
description: Device Virtualization
author: sethmanheim
ms.author: sethm
ms.topic: reference
ms.prod: virtualization
ms.date: 06/12/2023
api_name:
- Device Virtualization
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# Device Virtualization

## Overview

The Host Compute APIs allow applications to extend the Hyper-V platform with virtualization support for generic PCI devices. By leveraging these APIs, applications can create virtual machines and offer them virtual devices that are not natively supported by the Hyper-V platform, such as cameras or sensors. The host-side code that virtualizes the device is supplied by the application, and the application is in full control of the device behavior as observed from the guest.

The following section contains the definitions of the APIs for device virtualization in the HCS. The DLL exports a set of C-style Windows API functions, the functions return HRESULT error codes indicating the result of the function call.

## Device Virtualization Operations

|Function   |Description|
|---|---|
|[HdvCreateDeviceInstance](HdvCreateDeviceInstance.md)|Creates a device instance in the current host.|
|[HdvCreateGuestMemoryAperture](./HdvCreateGuestMemoryAperture.md)|Creates a guest RAM aperture in the address space of the calling process.|
|[HdvDeliverGuestInterrupt](./HdvDeliverGuestInterrupt.md)|Delivers a message signaled interrupt (MSI) to the guest partition.|
|[HdvDeviceType](HdvDeviceType.md)|Discriminator for the Emulated device type.|
|[HdvInitializeDeviceHost](HdvInitializeDeviceHost.md)|Initializes a device emulator host in the caller's process.|
|[HdvInitializeDeviceHostForProxy](HdvInitializeDeviceHostForProxy.md)|Initializes the device emulator host in the caller's process and associates it with the specified proxy.|
|[HdvPciBarSelector](HdvPciBarSelector.md)|Discriminator for the BAR selection.|
|[HdvPciDeviceGetDetails](HdvPciDeviceGetDetails.md)|Queries the PCI description of the emulated device.|
|[HdvPciDeviceInitialize](HdvPciDeviceInitialize.md)|Initializes the emulated device.|
|[HdvPciDeviceInterface](HdvPciDeviceInterface.md)|Device emulation callbacks for PCI devices.|
|[HdvPciDeviceSetConfiguration](HdvPciDeviceSetConfiguration.md)|Sets the configuration of the emulated device.|
|[HdvPciDeviceStart](HdvPciDeviceStart.md)|Notifies the emulated device that the virtual processors of the VM are about to start.|
|[HdvPciDeviceStop](HdvPciDeviceStop.md)|Notifies the emulated device that the virtual processors of the VM are about to stop.|
|[HdvPciDeviceTeardown](HdvPciDeviceTeardown.md)|Tears down the emulated device.|
|[HdvPciInterfaceVersion](HdvPciInterfaceVersion.md)|Discriminator for the PCI device version.|
|[HdvPciPnpId](HdvPciPnpId.md)|PnP ID definition for a virtual device.|
|[HdvPciReadConfigSpace](HdvPciReadConfigSpace.md)|Executes a read into the emulated device's PCI config space.|
|[HdvPciReadInterceptedMemory](HdvPciReadInterceptedMemory.md)|Executes an intercepted MMIO read for the emulated device.|
|[HdvPciWriteConfigSpace](HdvPciWriteConfigSpace.md)|Executes a write into the emulated device's PCI config space.|
|[HdvPciWriteInterceptedMemory](HdvPciWriteInterceptedMemory.md)|Executes an intercepted MMIO write for the emulated device.|
|[HdvProxyDeviceHost](HdvProxyDeviceHost.md)|Register a device host from another process with the compute system.|
|[HdvReadGuestMemory](./HdvReadGuestMemory.md)|Reads guest primary memory (RAM) contents into a buffer.|
|[HdvRegisterDoorbell](HdvRegisterDoorbell.md)|Registers a guest address to trigger an event on writes. The value of the write will be discarded.|
|[HdvTeardownDeviceHost](./HdvTeardownDeviceHost.md)|Tears down the device emulator host in the caller's process.|
|[HdvUnregisterDoorbell](HdvUnregisterDoorbell.md)|Unregisters a doorbell notification.|
|[HdvWriteGuestMemory](./HdvWriteGuestMemory.md)|Writes the contents of a specified buffer to guest primary memory (RAM).|
