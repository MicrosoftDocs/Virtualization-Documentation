---
title: Update Windows Server containers
description: How Windows can run build and run containers across multiple versions
keywords: metadata, containers, version
author: heidilohr
ms. author: helohr
manager: lizross
---
# Update Windows Server containers

## Overview

Text text text. (Do we need to indicate the very first paragraph is an overview?)

## How to get Windows Server container updates

Text text text.

## Troubleshoot host and container image mismatches

Text text text.

| Windows Server version (floating tag) | Update version for 1/14/20 release| Update version for 2/11/20 release | Update version for 2/18/20 release |
|---|---|---|---|
| Windows Server 2016 (ltsc2016) | 10.0.14393.3443 | 10.0.14393.3504 | 10.0.14393.3506 |
| Windows Server, version 1803 (1803) | 10.0.17134.1246 | 10.0.17134.1304 | 10.0.17134.1305 |
| Windows Server 2019 (ltsc2019) | 10.0.17763.973 | 10.0.17763.1039 | 10.0.17763.1040 |
| Windows Server, version 1903 (1903) |10.0.18362.592 | 10.0.18362.657 | 10.0.18362.658 |
| Windows Server, version 1909 (1909) | 10.0.18363.592 | 10.0.18363.657 | 10.0.18363.658 |

## How to query versions

Method 1: In Windows Server, version 1709 or later, the cmd prompt and ver command now return the revision details.

```batch
Microsoft Windows [Version 10.0.16299.125]
(c) 2017 Microsoft Corporation. All rights reserved.

C:\>ver

Microsoft Windows [Version 10.0.16299.125]
```
