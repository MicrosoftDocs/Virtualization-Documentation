# WHvTranslateGva
**Note: A prerelease of this API is available starting in the Insiders Preview Build 17083**

## Syntax
```C
// Guest virtual address
typedef UINT64 WHV_GUEST_VIRTUAL_ADDRESS;

// Flags used by WHvTranslateGva
typedef enum WHV_TRANSLATE_GVA_FLAGS
{
    WHvTranslateGvaFlagNone             = 0x00000000,
    WHvTranslateGvaFlagValidateRead     = 0x00000001,
    WHvTranslateGvaFlagValidateWrite    = 0x00000002,
    WHvTranslateGvaFlagValidateExecute  = 0x00000004,
    WHvTranslateGvaFlagPrivilegeExempt  = 0x00000008,
    WHvTranslateGvaFlagSetPageTableBits = 0x00000010
} WHV_TRANSLATE_GVA_FLAGS;

DEFINE_ENUM_FLAG_OPERATORS(WHV_TRANSLATE_GVA_FLAGS);

// Result of an attempt to translate a guest virtual address
typedef enum WHV_TRANSLATE_GVA_RESULT_CODE
{
    WHvTranslateGvaResultSuccess                 = 0,

    // Translation failures
    WHvTranslateGvaResultPageNotPresent          = 1,
    WHvTranslateGvaResultPrivilegeViolation      = 2,
    WHvTranslateGvaResultInvalidPageTableFlags   = 3,

    // GPA access failures
    WHvTranslateGvaResultGpaUnmapped             = 4,
    WHvTranslateGvaResultGpaNoReadAccess         = 5,
    WHvTranslateGvaResultGpaNoWriteAccess        = 6,
    WHvTranslateGvaResultGpaIllegalOverlayAccess = 7,
    WHvTranslateGvaResultIntercept               = 8
} WHV_TRANSLATE_GVA_RESULT_CODE;

// Output buffer of WHvTranslateGva
typedef struct WHV_TRANSLATE_GVA_RESULT
{
    WHV_TRANSLATE_GVA_RESULT_CODE ResultCode;
    UINT32 Reserved;
} WHV_TRANSLATE_GVA_RESULT;

HRESULT
WINAPI
WHvTranslateGva(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_ WHV_GUEST_VIRTUAL_ADDRESS Gva,
    _In_ WHV_TRANSLATE_GVA_FLAGS TranslateFlags,
    _Out_ WHV_TRANSLATE_GVA_RESULT* TranslationResult,
    _Out_ WHV_GUEST_PHYSICAL_ADDRESS* Gpa
    );
```
### Parameters

`Partition`

Handle to the partition object in the VID

`VpIndex`

Specifies the index of the virtual processor for which the virtual address is translated

`Gva`

Specifies the virtual address that is translated

`TranslateFlages`

Specifies flags for the translation 


`TranslationResult`

Receives the result of the translation

`Gpa`

Receives the physical address if the translation was successful. 

## Return Value

If the operation completed successfully, the return value is `S_OK`. Note that a successful completion of the call just indicates that the `TranslationResult` output parameter is valid, the result of the translation is return in the `ResultCode` member of this struct. 

## Remarks

Translating a virtual address used by a virtual processor in a partition allows the virtualization stack to emulate a processor instruction for an I/O operation, using the results of the translation to read and write the memory operands of the instruction in the GPA space of the partition. 

The hypervisor performs the translating by walking the page table that is currently active for the virtual processor. The translation can fail if the page table is not accessible, in which case an appropriate page fault needs to be injected into the virtual processor by the virtualization stack. 
