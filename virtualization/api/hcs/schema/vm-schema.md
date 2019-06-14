# VM Creation Document Schema

The following section contains on overview of the JSON document schemas used by the Host Compute APIs. The complete set of document schemas will be included in the documentation of the APIs.

```json
{
    "Owner" : <string>,
    "SchemaVersion" : {
        "Major" : <uint32>,
        "Minor" : <uint32>
    },
    "VirtualMachine" : {
        "Chipset" : {
            "UEFI" : {
                "EnableDebugger" : <bool>,
                "SecureBootTemplateId" : <GUID>,
                "BootThis" : {
                    "uefi_device" : <enum>,
                    "device_path" : <string>,
                    "disk_number" : <uint16>,
                    "optional_data" : <string>
                },
                "Console" : <enum>
            },
            "IsNumLockDisabled" : <bool>
        },
        "ComputeTopology" : {
            "Memory" : {
                "Startup" : <uint32>,
                "Backing" : <enum>, // AsString; Values: "" (0), "Physical" (1), "Virtual" (2)
                "DirectFileMappingMB" : <int64>,
                "SharedMemoryMB" : <int64>,
                "DisableSharedMemoryMapping" : <bool>,
                "SharedMemoryAccessSids" : [ <string> ],
                "Regions" : [
                    {
                        "SectionName" : <string>,
                        "StartOffset" : <uint64>,
                        "Length" : <uint64>,
                        "AllowGuestWrite" : <bool>,
                        "HiddenFromGuest" : <bool>
                    }
                ]
            },
            "Processor" : {
                "Count" : <uint32>,
                "ExposeVirtualizationExtensions" : <bool>
            }
        },
        "Devices" : {
            "COMPorts" : {
                "Port1" : <string>,
                "Port2" : <string>,
                "DebuggerMode" : <bool>
            },
            "SCSI" : { // Name - object map
                "<string>" : {
                    "Attachments" : { // Key-value map, key type <uint32>
                        "<uint32>" : {
                            "Type" : <enum>,
                            "Path" : <string>,
                            "IgnoreFlushes" : <bool>,
                            "CachingMode" : <enum>,
                            "NoWriteHardening" : <bool>,
                            "DisableExpansionOptimization" : <bool>,
                            "IgnoreRelativeLocator" : <bool>,
                            "CaptureIoAttributionContext" : <bool>,
                            "ReadOnly" : <bool>
                        }
                    },
                    "ChannelInstanceGuid" : <GUID>
                }
            },
            "VPMem" : {
                "Devices" : { // LUN - object map
                    "<uint8>" : {
                        "HostPath" : <string>,
                        "ReadOnly" : <bool>,
                        "ImageFormat" : <enum>
                    }
                },
                "MaximumCount" : <uint8>,
                "MaximumSizeBytes" : <uint64>
            },
            "NIC" : { // Name - object map
                "<string>" : {
                    "EndpointID" : <GUID>,
                    "MacAddress" : <MacAddress>,
                    "ChannelInstanceGuid" : <GUID>
                }
            },
            "VideoMonitor" : {
                "HorizontalResolution" : <uint16>,
                "VerticalResolution" : <uint16>
            },
            "Keyboard" : { },
            "Mouse" : { },
            "GuestInterface" : {
                "ConnectToBridge" : <bool>,
                "BridgeFlags" : <enum>,
                "HvSocketConfig" : {
                    "DefaultBindSecurityDescriptor" : <string>,
                    "DefaultConnectSecurityDescriptor" : <string>,
                    "ServiceTable" : { // ID - object map
                        "<GUID>" : {
                            "BindSecurityDescriptor" : <string>,
                            "ConnectSecurityDescriptor" : <string>,
                            "AllowWildcardBinds" : <bool>,
                            "Disabled" : <bool>
                        }
                    }
                }
            },
            "Rdp" : {
                "AccessSids" : [ <string> ]
            },
            "GuestCrashReporting" : {
                "WindowsCrashSettings" : {
                    "DumpFileName" : <string>,
                    "MaxDumpSize" : <int64>,
                    "DumpType" : <enum>
                }
            },
            "VirtualSMBShares" : [
                {
                    "Name" : <string>,
                    "Path" : <string>,
                    "Flags" : <enum>, 
                    "AllowedFiles" : [ <string> ],
                    "AllowedFsctls" : [ <uint32> ],
                    "AutoCreateAlternateDataStreams" : [
                        {
                            "Name" : <string>,
                            "Contents" : <bin-base64>
                        }
                    ]
                }
            ],
            "Plan9Shares" : [
                {
                    "Name" : <string>,
                    "Path" : <string>,
                    "Port" : <uint32>,
                    "Flags" : <enum>
                }
            ],
            "Battery" : { },
            "FlexIo" : { // Name - object map
                "<string>" : {
                    "EmulatorId" : <GUID>,
                    "HostingModel" : <enum>,
                    "Configuration" : [ <string> ]
                }
            }
        },
        "GuestState" : { 
            "GuestStateFilePath" : <string>,
            "RuntimeStateFilePath" : <string>,
            "ForceTransientState" : <bool>
        },
        "RestoreState" : {
            "RuntimeStateFilePath" : <string>,
            "TemplateSystemId" : <string>
        },
        "DebugOptions" : {
            "BugcheckSavedStateFileName" : <string>
        }
    },
    "StopOnReset" : <bool>,   
    "ShouldTerminateOnLastHandleClosed" : <bool>
}
```