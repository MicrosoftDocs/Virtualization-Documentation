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

## Compute System Operations

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HdvInitializeDeviceHost](./HdvPciDeviceInitialize.md)|Initializes a device emulator host in the caller's process.|
|[HdvTeardownDeviceHost](./HdvTeardownDeviceHost.md)|Tears down the device emulator host in the caller's process.|
|[HdvCreateDeviceInstance](./HdvCreateDeviceInstance.md)|Creates a device instance in the current host.|
|[HdvReadGuestMemory](./HdvReadGuestMemory.md)|Reads guest primary memory (RAM) contents into a buffer.|
|[HdvWriteGuestMemory](./HdvWriteGuestMemory.md)|Writes the contents of a specified buffer to guest primary memory (RAM).|
|[HdvCreateGuestMemoryAperture](./HdvCreateGuestMemoryAperture.md)|Creates a guest RAM aperture in the address space of the calling process.|
|[HdvDeliverGuestInterrupt](./HdvDeliverGuestInterrupt.md)|Delivers a message signaled interrupt (MSI) to the guest partition.|
