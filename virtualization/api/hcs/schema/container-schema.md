# Container Creation Document Schema

The following section contains on overview of the JSON document schemas used by the Host Compute APIs. The complete set of document schemas will be included in the documentation of the APIs.

```json
{
    "Owner" : <string>,
    "SchemaVersion" : {
        "Major" : <uint32>,
        "Minor" : <uint32>
    },
    "Container" : {
        "Storage" : {
            "Layers" : [
                {
                    "Id" : <GUID>,
                    "Path" : <string>,
                    "Cache" : <enum>
                }
            ],
            "Path" : <string>,
            "StorageQoS" : {
                "IOPSMaximum" : <uint64>,
                "BandwidthMaximum" : <uint64>
            }
        },
        "MappedDirectories" : [
            {
                "HostPath" : <string>,
                "ContainerPath" : <string>,
                "ReadOnly" : <bool>
            }
        ],
        "MappedPipes" : [
            {
                "ContainerPipeName" : <string>,
                "HostPath" : <string>
            }
        ],
        "Memory" : {
            "Maximum" : <uint64>
        },
        "Processor" : {
            "Count" : <uint32>,
            "Maximum" : <uint64>,
            "Weight" : <uint64>
        },
        "Networking" : {
            "AllowUnqualifiedDnsQuery" : <bool>,
            "DNSSearchList" : <string>,
            "NetworkSharedContainerName" : <string>,
            "Namespace" : <string>,
            "NetworkAdapters" : [ <GUID> ]
        },
        "HvSocket" : {
            "Config" : {
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
            },
            "EnablePowerShellDirect" : <bool>,
            "EnableUtcRelay" : <bool>,
            "EnableAuditing" : <bool>
        },
        "CredentialGuard" : {
            "Cookie" : [ <uint8> ],
            "RpcEndpoint" : <string>
        },
        "RegistryChanges" : {
            "AddValues" : [
                {
                    "Key" : {
                        "Hive" : <enum>,
                        "Name" : <string>,
                        "Volatile" : <bool>
                    },
                    "Name" : <string>,
                    "Type" : <enum>,
                    "StringValue" : <string>,
                    "BinaryValue" : <bin-base64>,
                    "DWordValue" : <uint32>, // Optional
                    "QWordValue" : <uint64>, // Optional
                    "CustomType" : <uint32> // Optional
                }
            ],
            "DeleteKeys" : [
                {
                    "Hive" : <enum>,
                    "Name" : <string>,
                    "Volatile" : <bool>
                }
            ]
        }
    },
    "ShouldTerminateOnLastHandleClosed" : <bool>
}
```