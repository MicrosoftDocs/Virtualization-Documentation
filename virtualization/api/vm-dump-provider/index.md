---
title: VM (Virtual Machine) Saved State Dump Provider API
description: The saved state format of a VM can be accessed via VmSavedStateDumpProvider DLL.
ms.date: 04/18/2022
author: sethmanheim
ms.author: roharwoo
---
# VM (Virtual Machine) Saved State Dump Provider API

**Note: These APIs are not yet publicly available and will be available in the latest release of the Windows SDK.**

The saved state format of a VM can be accessed via VmSavedStateDumpProvider DLL, which abstracts away the format to provide an API to extract dump-related content from a virual machine's saved state. The DLL exports a set of C-style Windows API functions.
