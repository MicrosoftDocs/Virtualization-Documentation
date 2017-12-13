# Exit Context Data Types

## Syntax

```C
// Execution state of the virtual processor (HV_X64_VP_EXECUTION_STATE) 
typedef struct { 
    UINT16 Cpl : 2; 
    UINT16 Cr0Pe : 1; 
    UINT16 Cr0Am : 1; 
    UINT16 EferLma : 1; 
    UINT16 DebugActive : 1; 
    UINT16 InterruptionPending : 1; 
    UINT16 Reserved : 9; 
} WHV_VP_EXECUTION_STATE; 
 
// Instruction that caused an exit 
typedef struct { 
    UINT64 Rip; 
    UINT64 Rflags; 
    WHV_X64_SEGMENT_REGISTER Cs; // HV_X64_SEGMENT_REGISTER 
    UINT8 InstructionByteCount; 
    UINT8 InstructionBytes[16]; 
} WHV_VP_INSTRUCTION_CONTEXT; 
```
## Remarks

The context structures for several exit reasons share common definitions for the data that provides information about the processor instruction that caused the exit and the state of the virtual processor at the time of the exit. 
