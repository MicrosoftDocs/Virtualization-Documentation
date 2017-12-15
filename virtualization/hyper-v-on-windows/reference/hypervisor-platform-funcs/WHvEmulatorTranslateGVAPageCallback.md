# WHV_EMULATOR_TRANSLATE_GVA_PAGE_CALLBACK
**Note: These APIs are not yet publically available and will be included in a future Windows release.**

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
Callback requesting the virtualization stack to translate the Guest Virtual Address GvaPage that points to the start of a 4K page, with the specified TranslateFlags. The virtstack should return in TranslationResult exactly what [`WHvTranslateGva`](hypervisor-platform-funcs/WHvTranslateGva.md) returned, along with the resulting address in GpaPage.

**NOTE:** GpaPage must be 4K aligned or the current emulation call will fail, with extended status `TranslateGvaPageCallbackGpaPageIsNotAligned` bit set.