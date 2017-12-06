# WHvTranslateVirtualAddress

## Syntax
```C
typedef UINT64 WHV_GUEST_VIRTUAL_ADDRESS; 
 
typedef enum { 
    WHvTranslateGvaFlagNone             = 0x00000000, 
    WHvTranslateGvaFlagValidateRead     = 0x00000001, 
    WHvTranslateGvaFlagValidateWrite    = 0x00000002, 
    WHvTranslateGvaFlagValidateExecute  = 0x00000004, 
    WHvTranslateGvaFlagPrivilegeExempt  = 0x00000008, 
    WHvTranslateGvaFlagSetPageTableBits = 0x00000010 
} WHV_TRANSLATE_GVA_FLAGS; 
 
typedef enum { 
    WhvTranslateGvaSuccess                 = 0; 
 
    // Translation failures 
    WHvTranslateGvaPageNotPresent          = 1, 
    WHvTranslateGvaPrivilegeViolation      = 2, 
    WHvTranslateGvaInvalidPageTableFlags   = 3, 
 
    // GPA access failures 
    WHvTranslateGvaGpaUnmapped             = 4, 
    WHvTranslateGvaGpaNoReadAccess         = 5, 
    WHvTranslateGvaGpaNoWriteAccess        = 6, 
    WHvTranslateGvaGpaIllegalOverlayAccess = 7, 
    WHvTranslateGvaIntercept               = 8 
} WHV_TRANSLATE_GVA_RESULT_CODE; 
 
typedef struct { 
    WHV_TRANSLATE_GVA_RESULT_CODE ResultCode; 
    UINT32 Reserved: 32; 
} WHV_TRANSLATE_GVA_RESULT; 

HRESULT 
WHvTranslateVirtualAddress( 
    _In_  WHV_PARTITION_HANDLE Partition, 
    _In_  UINT32 VpIndex, 
    _In_  WHV_GUEST_VIRTUAL_ADDRESS Gva, 
    _In_  WHV_TRANSLATE_GVA_FLAGS TranslateFlags, 
      _Out_ WHV_TRANSLATE_GVA_RESULT* TranslationResult, 
    _Out_ WHV_GUEST_PHYSICAL_ADDRESS* Gpa 
);  
```
### Parameters

`Partition`

Handle to the partition object in the VID

`VpIndex` 

Specifies the index of the virtual processor for which the virtual address is translated

`TranslateFlages` 

Specifies flags for the translation 

`GvaPageAddress` 

Specifies the virtual address that is translated

`TranslationResult` 

Receives the result of the translation

`GpaPageAddress` 

Receives the physical address if the translation was successful. 

## Return Value

If the operation completed successfully, the return value is `S_OK`. Note that a successful completion of the call just indicates that the TranslationResult output parameter is valid, the result of the translation is return in the ResultCode member of this struct. 

## Remarks

Translating a virtual address used by a virtual processor in a partition allows the virtualization stack to emulate a processor instruction for an I/O operation, using the results of the translation to read and write the memory operands of the instruction in the GPA space of the partition. 

The hypervisor performs the translating by walking the page table that is currently active for the virtual processor. The translation can fail if the page table is not accessible, in which case an appropriate page fault needs to be injected into the virtual processor by the virtualization stack. 
