# WHV_EMULATOR_MEMORY_ACCESS_INFO
**Note: These APIs are not yet publicly available and will be included in a future Windows release.**


## Syntax

```c
typedef struct _WHV_EMULATOR_MEMORY_ACCESS_INFO {
    UINT64 GpaAddress;
    UINT8 Direction; //0 for read, 1 for write
    UINT8 AccessSize; // 1 thru 8, TODO: odd numbers allowed?
    UINT8 Data[8]; // Little Endian (LE) byte encoding value for access size.
} WHV_EMULATOR_MEMORY_ACCESS_INFO;
```
## Remarks
Information about the requested memory access by the emulator. `GpaAddress` is the
guest physical address attempting to be accessed. `Direction` is 0 for a memory read access, 1 for a write access. `AccessSize` is how big this memory access is in bytes, with a valid size of 1 to 8. `Data` is a byte array with little endian encoding, to either be filled out by the virtualization stack for a read, or containing the data to write to memory for a write.
