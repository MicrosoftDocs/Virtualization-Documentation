---
title:      "Hyper-V R2 Import/Export – Part 2 - The New Import/Export APIs"
description: 
author: scooley
ms.author: scooley
date:       2009-05-21 12:51:00
ms.date: 05/21/2009
categories: hyper-v
---
# Hyper-V R2 Import/Export – Part 2 - The New Import/Export APIs

To enable the new functionality of Import/Export we now have new ‘Ex’ versions of the Import/Export APIs along with settings data objects that allow the user to tweak the necessary parameters upon export or import:

_Export:_

Before you run an export, you can get the export parameters associated with a VM in the form of a settings data object. They are populated with default values. You can modify the parameters you need and then call ExportVirtualSystemEx with the modified object passed in.

ExportVirtualSystemEx: [https://msdn.microsoft.com/library/dd379583(VS.85).aspx](https://msdn.microsoft.com/library/dd379583\(VS.85\).aspx)

Export Setting data: [https://msdn.microsoft.com/library/dd379576(VS.85).aspx](https://msdn.microsoft.com/library/dd379576\(VS.85\).aspx)

_Import:_

Before you run an import, you can get the import parameters for the directory the VM will be imported from. Here, you can tweak interesting parameters like the AzMan security scope, network connections and even paths to VHDs before calling ImportVirtualSystemEx with the modified parameters.

ImportVirtualSystemEx: [https://msdn.microsoft.com/library/dd379583(VS.85).aspx](https://msdn.microsoft.com/library/dd379583\(VS.85\).aspx)

Import Setting data: [https://msdn.microsoft.com/library/dd379577(VS.85).aspx](https://msdn.microsoft.com/library/dd379577\(VS.85\).aspx)

While I will not repeat the information in the MSDN documentation, there are some salient points about the API worth calling out:

**__**

**_Export Settings data (_**[ **Msvm_VirtualSystemExportSettingData**](https://msdn.microsoft.com/library/dd379576\(VS.85\).aspx) ** _):_**

Here is a dump of the parameters from powershell:
    
```
Caption                    : Virtual System Export Setting Data
    
    
CopySnapshotConfiguration  : 0
    
    
CopyVmRuntimeInformation   : True
    
    
CopyVmStorage              : True
    
    
CreateVmExportSubdirectory : False
    
    
Description                : Microsoft Virtual System Export Setting Data
    
    
ElementName                : Microsoft Virtual System Export Setting Data
    
    
InstanceID                 : Microsoft:4919C848-AA71-43B3-A1A5-988242D39FA2
    
    
SnapshotVirtualSystem      :
```

 

  * CopyVmRuntimeInformation: you can specify if you want to export your saved state files or not. This is particularly useful if you are interested only in the storage associated with VM or if you are moving a VM across processor vendors, the saved state files will be useless as a result and you could live without the 1 or 2 GB worth of memory data on the pipe. 
  * CopyVmStorage is the essential parameter that controls config-only export. That is the parameter you want to set to false if you want to do config-only export. 
  * CopySnapshotConfiguration and SnapshotVirtualSystem can be used together to export a single snapshot 



**__**

**_Import Settings data (_**[ **Msvm_VirtualSystemImportSettingData**](https://msdn.microsoft.com/library/dd379577\(VS.85\).aspx) ** _):_**

Here is the dump of the parameters from powershell: 
    
```
Caption                  : Virtual System Import Setting Data
    
    
CreateCopy               : True
    
    
CurrentResourcePaths     : {C:\7088\blog.vhd}
    
    
Description              : Microsoft Virtual System Import Setting Data
    
    
ElementName              : Microsoft Virtual System Import Setting Data
    
    
GenerateNewId            : True
    
    
InstanceID               : Microsoft:ADDB3F5B-17BF-4AB4-A21F-BF1EE41B0165
    
    
Name                     : blog
    
    
SecurityScope            :
    
    
SourceNetworkConnections :
    
    
SourceResourcePaths      : {C:\blog_VM\runtime\Virtual Hard Disks\blog.vhd}
    
    
SourceSnapshotDataRoot   :
    
    
SourceVhdDataRoot        :
    
    
SourceVmDataRoot         :
    
    
TargetNetworkConnections :
    
    
TargetResourcePaths      :
    
    
TargetSnapshotDataRoot   :
    
    
TargetVhdDataRoot        :
    
    
TargetVmDataRoot         :
```
  

_Source vs. Target:_

Over here, you can clearly see a larger number of parameters. In particular, there are a number of “Source…” prefixed and “Target...” prefixed parameters. Since we now do a copy on import, you could view the “Source…” prefixed parameters as specifying the “from” location of the copy and the “Target…” prefixed parameters as the “to” location of the copy. The SourceResourcePaths parameter is an array populated with the VHDs associated with the VM. Here the user can specify the locations of the VHDs to copy from. They do not necessarily need to be under the import folder. Correspondingly, the TargetResourcePaths parameter is an array with paths that specify where the VHDs are to be copied to.

However, if you do not want to do a copy on import, (ie: you set the CreateCopy parameter to false), you do not need to specify any of the “Target…” prefixed parameters. Hyper-V will use the “Source…” prefixed parameters to configure the VM upon import.

_Dataroots vs. ResourcePaths_

On another dimension, you have the dataroots (SourceSnapshotDataRoot, SourceVhdDataRoot, SourceVmDataRoot) and the resourcepaths (SourceResourcePaths and TargetResourcePaths). Say, if all your VHDs reside in a single directory that you want to import from, specifying the SourceVhdDataRoot will be sufficient. Also, if upon import you want all the VHDs to reside in a single folder, just specify the TargetVhdDataRoot and you are done. You do not need to specify each of the TargetResourcePaths. The same logic applies to the (Source/Target)SnapshotDataRoot and (Source/Target)VmDataRoot.
