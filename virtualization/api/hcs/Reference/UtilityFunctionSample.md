---
title: Virtual Machine Utilities Samples
description: Virtual Machine Utilities Samples
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- Virtual Machine Utilities Samples
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# Virtual Machine Utilities Samples

<a name = "CreateFilesGrantAccess"></a>
## Create the file and grant vm access to them

```cpp
// This assumes "Sample" has been used as the id for a compute system when created through HcsCreateComputeSystem
THROW_IF_FAILED(HcsCreateEmptyRuntimeStateFile(L"emptyfile.vmrs"));
THROW_IF_FAILED(HcsGrantVmAccess(L"Sample", L"emptyfile.vmrs"));
```
