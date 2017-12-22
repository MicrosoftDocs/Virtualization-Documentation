# WHV_EMULATOR_IO_ACCESS_INFO
**Note: These APIs are not yet publicly available and will be included in a future Windows release.**

## Syntax

```c
typedef struct _WHV_EMULATOR_IO_ACCESS_INFO {
    UINT8 Direction; //0 for in, 1 for out
    UINT16 Port;
    UINT16 AccessSize; // only 1, 2, 4
    UINT32 Data[4]; // LE byte encoding value for access size
} WHV_EMULATOR_IO_ACCESS_INFO;
```
## Remarks
Information about the requested Io Port access by the emulator. Direction is the same as for memory, a 0 for a read and 1 for a write. Port is the Io Port the emulator is attempting to access. `AccessSize` is the same as described above for memory, but limited to values of 1, 2 or 4. Data is also the same as for memory, a byte array with little endian encoding to store the data for a read, or the data for the device in the case of a write.
