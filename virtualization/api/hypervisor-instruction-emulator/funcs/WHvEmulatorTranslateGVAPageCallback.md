---
title: WHV_EMULATOR_TRANSLATE_GVA_PAGE_CALLBACK method
description: Learn about the WHV_EMULATOR_TRANSLATE_GVA_PAGE_CALLBACK method. 
author: sethmanheim
ms.author: sethm
ms.date: 04/19/2022
---

# WHV_EMULATOR_TRANSLATE_GVA_PAGE_CALLBACK


## Syntax

```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_TRANSLATE_GVA_PAGE_CALLBACK)(
    _In_ VOID* Context,
    _In_ WHV_GUEST_VIRTUAL_ADDRESS GvaPage,
    _In_ WHV_TRANSLATE_GVA_FLAGS TranslateFlags,
    _Out_ WHV_TRANSLATE_GVA_RESULT_CODE* TranslationResult,
    _Out_ WHV_GUEST_PHYSICAL_ADDRESS* GpaPage // NOTE: This pointer _must_ be 4K page aligned
    );
```

## Remarks
Callback requesting the virtualization stack to translate the Guest Virtual Address `GvaPage` that points to the start of a 4K page, with the specified `TranslateFlags`. The virtstack should return in `TranslationResult` exactly what [`WHvTranslateGva`](/virtualization/api/hypervisor-platform/funcs/WHvTranslateGva) returned, along with the resulting address in GpaPage.

**NOTE:** `GpaPage` must be 4K aligned or the current emulation call will fail, with extended status `TranslateGvaPageCallbackGpaPageIsNotAligned` bit set.
