---
title: Microsoft Software EULA Windows Containers
description: License agreement for Windows container base images.
keywords: docker, containers, eula
author: cwilhit
ms.author: cwilhit
ms.date: 08/11/2020
ms.topic: deployment
---
# MICROSOFT SOFTWARE SUPPLEMENTAL LICENSE FOR WINDOWS CONTAINER BASE IMAGE

This Supplemental License is for the Windows Container Base Image (“Container Image”). If you comply with the terms of this Supplemental License you may use the Container Image as described below.

## CONTAINER OS IMAGE
The Container Image may only be used with a validly licensed copy of:

Windows Server Standard or Windows Server Datacenter software (collectively “Server Host Software”), or
Microsoft Windows Operating System (version 10) software (“Client Host Software”), or
Windows 10 IoT Enterprise and Windows 10 IoT Core (collectively “IoT Host Software”).
The Server Host Software, Client Host Software, and IoT Host Software are collectively referred to as the “Host Software” and a license for Host Software is a "Host License".

You may not use the Container Image if you do not have a corresponding version and edition of the Host License. Certain restrictions and additional terms may apply, which are described herein. If licensing terms herein conflict with Host License, then this Supplemental License shall govern with respect to the Container Image. BY ACCEPTING THIS SUPPLEMENTAL LICENSE OR USING THE CONTAINER IMAGE, YOU AGREE TO ALL OF THESE TERMS. IF YOU DO NOT ACCEPT AND COMPLY WITH THESE TERMS, YOU MAY NOT USE THE CONTAINER IMAGE.

## DEFINITIONS
**Windows Server Container** (without Hyper-V isolation) is a feature of Microsoft Windows Server software.

**Windows Server Container with Hyper-V isolation.** Section 2(k) of the Microsoft Windows Server license terms is hereby deleted in its entirety and replaced with the revised terms as shown in “UPDATED” below.

UPDATED: Windows Server Container with Hyper-V isolation (formerly known as Hyper-V Container) is a container technology in Windows Server which utilizes a virtual operating system environment to host one or more Windows Server Container(s). Each Hyper-V isolation instance used to host one or more Windows Server Container(s) is considered one virtual operating system environment.

## LICENSE TERMS
**Host License.** The Host License terms apply to your use of the Container Image and any Windows container(s) created with the Container Image which are distinct and separate from a virtual machine.

**Use Rights.** The Container Image may be used to create an isolated virtualized Windows operating system environment that includes at least one application that adds primary and significant functionality. You may use the Container Image only to create, build, and run Windows container(s) on Host Software. Updates to the Host Software may not update the Container Image so you may re-create any Windows containers based on an updated Container Image.

**Restrictions.** You may not remove this Supplemental License document file from the Container Image. You may not enable remote access to the application(s) you run within your container to avoid applicable license fees. You may not reverse engineer, decompile, or disassemble the Container Image, or attempt to do so, except and only to the extent required by third party licensing terms governing the use of certain open-source components that may be included with the software. Additional restrictions in the Host License may apply.

## ADDITIONAL TERMS
**Client Host Software.** When running a Container Image on Client Host Software you may run any number of the Container Image instantiated as Windows containers for test or development purposes only. You may not use these Windows containers in a production environment on Client Host Software.

**IoT Host Software.** When running a Container Image on IoT Host Software you may run any number of the Container Image instantiated as Windows containers for test or development purposes only. You may only use the Container Image in a production environment if you have agreed to the Microsoft Commercial Terms of Use for Windows 10 Core Runtime Images or the Windows 10 IoT Enterprise Device License (“Windows IoT Commercial Agreement”). Additional terms and restrictions in the Windows IoT Commercial Agreements apply to your use of Container Image in a production environment.

**Third Party Software.** The Container Image may include third party applications that are licensed to you under this Supplemental License or under their own terms. License terms, notices, and acknowledgements, if any, for the third-party applications may be accessible online at <https://aka.ms/thirdpartynotices> or in an accompanying notices file. Even if such applications are governed by other agreements, the disclaimer, limitations on, and exclusions of damages in the Host License also apply to the extent allowed by applicable law.

**Open Source Components.** The Container Image may contain third party copyrighted software licensed under open source licenses with source code availability obligations. Copies of those licenses are included in the ThirdPartyNotices file or other accompanying notices file. You may obtain the complete corresponding source code from Microsoft if and as required under the relevant open source license by sending a money order or check for $5.00 to: Source Code Compliance Team, Microsoft Corporation, 1 Microsoft Way, Redmond, WA 98052, USA. Please include the name “Microsoft Software Supplemental License for Windows Container base image,“ the open source component name and version number in the memo line of your payment. You may also find a copy of the source at <https://aka.ms/getsource>.
