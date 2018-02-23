# WHV_EMULATOR_MEMORY_ACCESS_INFO
**Note: A prerelease of this API is available starting in the Insiders Preview Build 17083**


## Syntax

```c
typedef struct _WHV_EMULATOR_MEMORY_ACCESS_INFO {
    UINT64 GpaAddress;
    UINT8 Direction; // 0 for read, 1 for write
    UINT8 AccessSize; // 1 thru 8
    UINT8 Data[8]; // Raw byte contents to be read from/written to memory
} WHV_EMULATOR_MEMORY_ACCESS_INFO;
```
## Remarks
Information about the requested memory access by the emulator.

`GpaAddress` is the guest physical address attempting to be accessed.

`Direction` is 0 for a memory read access, 1 for a write access.

`AccessSize` is how big this memory access is in bytes, with a valid size of 1 to 8.

`Data` is a byte array with the same layout as memory, to either be filled out by the virtualization stack for a read, or containing the data to write to memory for a write.
