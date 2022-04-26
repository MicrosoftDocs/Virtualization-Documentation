---
title: "Replicating fixed disks to dynamic disks in Hyper-V Replica"
author: mattbriggs
ms.author: mabrigg
ms.date: 09/24/2013
categories: hvr
description: Converting fixed virtual disks to dynamic disks to trim the size down.
---
# How to Convert Fixed Disks to Dynamic Disks

A recent conversation with a hosting provider using Hyper-V Replica brought an interesting question to the fore. The hosting provider’s services were aimed primarily towards Small and Medium Businesses (SMBs), with one service being DR-as-a-Service. A lot of the virtual disks being replicated were fixed, had sizes greater than 1 TB, and were mostly _empty_ as the space had been carved out and reserved for future growth. However this situation presented a pretty problem for our hosting provider – storing a whole bunch of large and empty virtual disks eats up real resources. It also means investment in physical resources is done upfront rather than gradually/over a period of time. Surely there had to be a better way, right? Well, this wouldn’t be a very good blog post if there wasn’t a better way! :)

A great way to trim those fat, fixed virtual disks is to convert them into dynamic disks, and use the dynamic disks on the Replica side. So the replication would happen between the SMB datacenter (fixed disk) to the hosting provider’s datacenter (dynamic disk). Dynamic disks take up only as much physical storage as is present inside the disk, making them very efficient for storage and very useful to hosting providers. The icing on the cake is that Hyper-V Replica works great in such a configuration!

But what about the network – does this method help save any bandwidth? At the time of enabling replication, the compression option is selected by default. This means that when Hyper-V Replica encounters large swathes of empty space in the virtual disk, it is able to compress this data and then send the data across. So the good news is that excessive bandwidth usage is not a concern to begin with.

One of the early decisions to be made is whether this change is done on the primary side by the customer, or on the replica side by the hosting provider. Asking each customer to change from fixed disks to dynamic disks would be a long drawn out process – and customers might want to keep their existing configuration. The more likely scenario is that the hosting provider will make the changes and it will be transparent to the customer that is replicating.

So let’s deep-dive into how to make this happen.

### Converting a disk from fixed to dynamic

This process is simple enough, and can be done through the **Edit Disk** wizard in the Hyper-V Manager UI. Choose the virtual disk that needs editing, choose **Convert** as the action to be taken, and pick **Dynamically expanding** __ as the target disk type. Continue till the end and your disk will be converted from fixed to dynamic.

**NOTE 1:** An important constraint to remember is that the target disk format should be the same as the source disk format. This means that you should pick the disk format as VHD if your fixed disk has a VHD extension, and you should pick VHDX if your fixed disk has a VHDX extension.

**NOTE 2:** The name of your dynamic disk should be _exactly the same_ as the name of your fixed disk.

[![Edit disk](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7612.Edit-disk_thumb_1C4532AE.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6761.Edit-disk_08298574.png)

_(The destination location has been changed so that the same filename can be kept)_

To get the same result using PowerShell, use the following command:

```markdown
    PS C:\> Convert-VHD –Path c:\FixedDisk.vhdx –DestinationPath f:\FixedDisk.vhdx –VHDType Dynamic
```

### Making it work with Hyper-V Replica

  1. Enable replication from the customer to the hosting provider using online IR or [out-of-band IR](https://blogs.technet.com/b/virtualization/archive/2013/06/28/save-network-bandwidth-by-using-out-of-band-initial-replication-method-in-hyper-v-replica.aspx).
  2. The hosting provider waits for the IR to complete.
  3. The hosting provider can then pause the replication at any time on the Replica server – this will prevent HRL log apply on the disk while it is being converted.
  4. The hosting provider can then convert the disk from fixed to dynamic using the technique mentioned above. Ensure that there is adequate storage space to hold both disks until the process is complete.
  5. The hosting provider then replaces the fixed disk with the dynamic disk _at the same path and with the same name._
  6. The hosting provider resumes replication on the Replica site.



Now Hyper-V Replica will use the dynamic disk seamlessly and the hosting provider’s storage consumption is reduced.

#### Additional optimization for out-of-band IR

In out-of-band IR, the data is transferred to the Replica site using an external medium like a USB device. It becomes possible to convert the disk from fixed to dynamic _before importing it on the Replica site._ The disks on the external medium are directly used as the source and removes the need to have additional storage while the conversion operation completes (for step 4 in the above process). Thus the hosting provider can import and store only the dynamic disk.

Do try this out and let us know the feedback!
