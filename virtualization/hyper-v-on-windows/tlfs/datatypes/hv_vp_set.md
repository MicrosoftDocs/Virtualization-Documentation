---
title: HV_VP_SET
description: HV_VP_SET
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference

---

# HV_VP_SET

A virtual processor set represents a collection of virtual processors, and can be used as an input for some hypercalls.

## Syntax

```c
typedef struct
{
    UINT64 Format;
    UINT64 ValidBanksMask;
    UINT64 BankContents[];
} HV_VP_SET;
 ```

A processor set has two modes, which are specified by the format field. Processor sets with a format “1” represent all virtual processors for the given partition. Processor sets with a format “0” describe a sparse set of virtual processors.

| Format value  | Set behavior                                                |
|---------------|-------------------------------------------------------------|
| 0             | A sparse subset of VPs                                      |
| 1             | All VPs (belonging to a partition)                          |

### Sparse Virtual Processor Set

The following section describes how to construct a sparse set of virtual processors.

The total set of virtual processors is split up into chunks of 64, known as a “bank”. For example, processors 0-63 are in bank 0, 64-127 are in bank 1, and so on.

To describe an individual processor, its bank is specified with ValidBanksMask. Each bit in ValidBanksMask represents a particular bank.

```
bank = VPindex / 64
```
For every bit that is set with ValidBanksMask, there must be an element in the BanksContents array. This element is a mask describing the bank itself.

If a bit in ValidBankMask is 0, there is no corresponding element in BanksContents. Furthermore, for a bit 1 in ValidBankMask, it is valid state for the corresponding element in BanksContents can be all 0s, meaning no processors are specified in this bank.

#### Processor Set Example

Suppose a partition has 200 VPs, and we wish to specify the following set: { 0,5,130 }

First, the format is 0, since this is a sparse set. Next, the corresponding banks (and therefore the set bits of ValidBanksMask) are { 0,0,2 }. Thus, ValidBanksMask is 0x05.

Bank 0 sets bits 0 and 5 to specify the VPs within that bank. Therefore, the corresponding element in the BankContents mask is 0x21.

Since bit 1 is not set in ValidBanksMask, there is no corresponding element in BankContents. Bank 2 represents VP indices 128-191. To describe index 130, bit 2 of the corresponding mask is set. Thus, BankContents is: { 0x21,0x04 }.