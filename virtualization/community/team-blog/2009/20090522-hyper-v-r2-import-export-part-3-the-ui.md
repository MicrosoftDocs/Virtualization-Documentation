---
title:      "Hyper-V R2 Import/Export – Part 3 – The UI"
description: The Windows Server 2008 R2 UI has been modeled to enable a few new scenarios.
author: scooley
ms.author: scooley
date:       2009-05-22 12:56:00
ms.date: 05/22/2009
categories: uncategorized
---
# Hyper-V R2 Import/Export – Part 3 – The UI

Given the rather compressed schedule of Windows Server 2008 R2, we did not have time to get too ambitious with the UI. However, the UI has been modeled to enable the following 3 scenarios:

1\. Export VMs with data

2\. Import VMs with data

3\. Export a snapshot of a VM

4\. Provide the option for copy on import or in-place import

5\. Allow the user to import the VM with a newly generated ID.

_****_

_**Export UI:**_

Here is a screen capture of the Export UI you get when you right-click on a virtual machine in the Hyper-V Manager and click “Export…” :


It is still rather rudimentary and allows the user to specify the location to export the VM to. The VM will be exported along with its VHD files and saved state files to the specified folder. You might notice that the check-box for doing a configuration-only export is not there. This is by design, but we do support configuration-only export. More on this topic in a subsequent blogpost.

__

_**Exporting a snapshot:**_

To export a snapshot, right-click on the snapshot you want to export (in the snapshots pane that shows up for a selected virtual machine in Hyper-V) and click on “Export…”. It will bring up the Export UI above.


****

__

**_Import UI_ :**

The import UI is launched from the same spot under the Actions pane in Hyper-V manager:


In the import UI, check the highlighted checkbox and you will end up copying the VM on import, leaving files in the import directory good for a second import.



The other UI elements in the import UI follow the same pattern as in v1: the location for the import directory as well as the option for regenerating the VM’s unique ID. The import UI assumes that all the necessary files for the import to succeed are in the import directory. Ideally, given that the import process has so many fine grained options, we would have had an import wizard to allow the user the full range of choices. However, short of that, the user can script against the APIs to get the functionality they need. There will be a couple of blogs following this with sample scripts that would give the reader a good idea of how to use the APIs.
