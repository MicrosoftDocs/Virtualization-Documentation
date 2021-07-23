---
title: Device Virtualization
description: Device Virtualization
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name: Device Virtualization
api_location: computecore.dll
api_type: DllExport
topic_type: apiref
---
# Device Virtualization

## Overview
The Host Compute APIs allow applications to extend the Hyper-V platform with virtualization support for generic PCI devices. By leveraging these APIs, applications can create virtual machines and offer them virtual devices that are not natively supported by the Hyper-V platform, such as cameras or sensors. The host-side code that virtualizes the device is supplied by the application, and the application is in full control of the device behavior as observed from the guest.

The following section contains the definitions of the APIs for device virtualization in the HCS. The DLL exports a set of C-style Windows API functions, the functions return HRESULT error codes indicating the result of the function call.


## Compute System Opterations
|Function   |Description|
|---|---|---|---|---|---|---|---|
|[HdvInitializeDeviceHost](reference/HdvInitializeDeviceHost.md)|Create a compute system|
|[HdvTeardownDeviceHost](reference/HdvTeardownDeviceHost.md)| Query a compute system's properties|
|[HdvCreateDeviceInstance](reference/HdvCreateDeviceInstance.md)|Modify a compute system|
|[HdvReadGuestMemory](reference/HdvReadGuestMemory.md)|Open a compute system|
|[HdvWriteGuestMemory](reference/HdvWriteGuestMemory.md)|Pause a compute system|
|[HdvCreateGuestMemoryAperture](reference/HdvCreateGuestMemoryAperture.md)|Resume a compute system|
|[HdvDeliverGuestInterrupt](reference/HdvDeliverGuestInterrupt.md)|Save a compute system|
