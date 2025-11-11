---
title: VM Saved State Dump Provider Samples
description: Two samples written in C to demonstrate usage of the dump provider APIs.
ms.date: 04/19/2022
author: sethmanheim
ms.author: roharwoo
---

# VM Saved State Dump Provider Samples

We've provided two samples written in C to demonstrate usage of the dump provider APIs.

## 1. Dump Sample

This sample demonstrates how to open a VM saved state file and query it for a variety of things (virtual processor count, architecture, etc.)

You can find the source code for this sample on our [Github repo here](https://github.com/MicrosoftDocs/Virtualization-Documentation/blob/live/virtualization/api/vm-dump-provider/samples/dumpsample.cpp).

## 2. Memory-to-file Sample

This sample demonstrates how to extract a memory dump from a VM's saved state file and output it to a new binary file.

You can find the source code for this sample on our [Github repo here](https://github.com/MicrosoftDocs/Virtualization-Documentation/blob/live/virtualization/api/vm-dump-provider/samples/rawmemtofile.cpp).
