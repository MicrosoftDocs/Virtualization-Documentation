---
title: Create your custom Quick Create VM gallery
description: Learn how to create your own custom virtual machine gallery using Quick Create on JSON files.
author: mattbriggs
ms.author: mabrigg
date:       2017-11-08 02:41:52
ms.date: 11/08/2017
categories: hyper-v
---
# Create your custom Quick Create VM gallery

Have you ever wondered whether it is possible to add your own custom images to the list of available VMs for [Quick Create](https://blogs.technet.microsoft.com/virtualization/2017/07/26/hyper-v-virtual-machine-gallery-and-networking-improvements/)? The answer is: Yes, you can! Since quite a few people have been asking us, this post will give you a quick example to get started and add your own custom image while we're working on the official documentation. The following two steps will be described in this blog post: 

  1. Create JSON document describing your image
  2. Add this JSON document to the list of galleries to include

<!--[![](https://msdnshared.blob.core.windows.net/media/2017/11/customquickcreategallery-500x295.png)](https://msdnshared.blob.core.windows.net/media/2017/11/customquickcreategallery.png)-->

### Step 1: Create JSON document describing your image

The first thing you will need is a JSON document which describes the image you want to have showing up in quick create. The following snippet is a sample JSON document which you can adapt to your own needs. We will publish more documentation on this including a JSON schema to run validation as soon as it is ready.  To calculate the SHA256 hashes for the linked files you can use different tools. Since it is already available on Windows 10 machines, I like to use a quick PowerShell call: `Get-FileHash -Path .\contoso_logo.png -Algorithm SHA256` The values for `logo`, `symbol`, and `thumbnail` are optional, so if there are no images at hand, you can just remove these values from the JSON document. 

### Step 2: Add this JSON document to the list of galleries to include

To have your custom gallery image show up on a Windows 10 client, you need to set the `GalleryLocations` registry value under `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization`. There are multiple ways to achieve this, you can adapt the following PowerShell snippet to set the value:  If you don't want to include the official Windows 10 developer evaluation images, just remove the fwlink from the GalleryLocations value. Have fun creating your own VM galleries and stay tuned for our official documentation. We're looking forward to see what you create! Lars Update: The official documentation is now live as well -- for more detail on the gallery functionality and how to create your own gallery: This way please: [Create a custom virtual machine gallery](/virtualization/hyper-v-on-windows/user-guide/custom-gallery)
