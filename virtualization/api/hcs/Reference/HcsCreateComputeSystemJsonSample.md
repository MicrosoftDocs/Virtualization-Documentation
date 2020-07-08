`HcsCreateComputeSystem`'s `configuration` parameter expects a valid [`ComputeSystem`](../SchemaReference.md#ComputeSystem) JSON document. Properties `VirtualMachine` and `Container` are mutually exclusive since HCS supports, as of today, creating one of two [compute system types](../SchemaReference.md#SystemType).

# Virtual Machine

```JSON
{
    "Owner": <string>,
    "SchemaVersion": {
        "Major": <uint32>,
        "Minor": <uint32>
    },
    "HostingSystemId": <string>,
    "HostedSystem": <Any???>,
    "VirtualMachine": {
        "Chipset": {
            "Uefi": {
                "BootThis": {
                    "DevicePath": <string>,
                    "DiskNumber": <uint16>,
                    "DeviceType": <UefiBootDevice enum>
                        // "ScsiDrive"
                        // "VmbFs"
                        // "Network"
                        // "File"
                }
            }
        },
        "ComputeTopology": {
            "Memory": {
                "Backing": <MemoryBackingType enum>,
                    // "Physical"
                    // "Virtual"
                "SizeInMB": <uint64>
            },
            "Processor": { 
                "Count": <uint32>
            }
        },
        "Devices": {
            "Scsi": { <string, Scsi>Map
                "Primary disk": {
                    "Attachments": {
                        "0": {
                            "Type": <AttachmentType enum>,
                                // "VirtualDisk"
                                // "Iso"
                                // "PassThru"
                            "Path": <string>
                        }
                    }
                }
            }
        }
    },
    "ShouldTerminateOnLastHandleClosed": <bool>
}
```

# Container

```JSON
{
    "Owner": <string>,
    "SchemaVersion": {
        "Major": <uint32>,
        "Minor": <uint32>
    },
    "HostingSystemId": <string>,
    "HostedSystem": <Any???>,
    "Container": {
        "Storage": {
            "Layers": [
                {
                    "Id" : <Guid>,
                    "Path" : <string>,
                },
            ],
            "Path": <string>
        }
    },
    "ShouldTerminateOnLastHandleClosed": <bool>
}
```