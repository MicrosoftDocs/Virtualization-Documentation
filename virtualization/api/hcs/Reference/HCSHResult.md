---
title: HCS Error Code
description: HCS Error Code
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# HCS Error Code

Most of the the HCS functions use `HRESULT` return codes. These return codes can be found in the [Winerror.h](https://docs.microsoft.com/en-us/windows/win32/api/winerror/) header file. The following table shows HCS specific error codes:



|Name|Description|Value|
|---|---|---|
|`S_OK`|Success|`0x00000000`|
|`HCS_E_TERMINATED_DURING_START`|The virtual machine or container exited unexpectedly while starting|`0x80370100`|
|`HCS_E_IMAGE_MISMATCH`|The container operating system does not match the host operating system|`0x80370101`|
|`HCS_E_HYPERV_NOT_INSTALLED`|The virtual machine could not be started because a required feature is not installed|`0x80370102`|
|`HCS_E_INVALID_STATE`|The requested virtual machine or container operation is not valid in the current state|`0x80370105`|
|`HCS_E_UNEXPECTED_EXIT`|The virtual machine or container exited unexpectedly|`0x80370106`|
|`HCS_E_TERMINATED`|The virtual machine or container was forcefully exited|`0x80370107`|
|`HCS_E_CONNECT_FAILED`|A connection could not be established with the container or virtual machine|`0x80370108`|
|`HCS_E_CONNECTION_TIMEOUT`|The operation timed out because a response was not received from the virtual machine or container|`0x80370109`|
|`HCS_E_CONNECTION_CLOSED`|The connection with the virtual machine or container was closed|`0x8037010A`|
|`HCS_E_UNKNOWN_MESSAGE`|An unknown internal message was received by the virtual machine or container|`0x8037010B`|
|`HCS_E_UNSUPPORTED_PROTOCOL_VERSION`|The virtual machine or container does not support an available version of the communication protocol with the host|`0x8037010C`|
|`HCS_E_INVALID_JSON`|The virtual machine or container JSON document is invalid|`0x8037010D`|
|`HCS_E_SYSTEM_NOT_FOUND`|A virtual machine or container with the specified identifier does not exist|`0x8037010E`|
|`HCS_E_SYSTEM_ALREADY_EXISTS`|A virtual machine or container with the specified identifier already exists.|`0x8037010F`|
|`HCS_E_SYSTEM_ALREADY_STOPPED`|The virtual machine or container with the specified identifier is not running|`0x80370110`|
|`HCS_E_PROTOCOL_ERROR`|A communication protocol error has occurred between the virtual machine or container and the host|`0x80370111`|
|`HCS_E_INVALID_LAYER`|The container image contains a layer with an unrecognized format|`0x80370112`|
|`HCS_E_WINDOWS_INSIDER_REQUIRED`|To use this container image, you must join [the Windows Insider Program](https://go.microsoft.com/fwlink/?linkid=850659)|`0x80370113`|
|`HCS_E_SERVICE_NOT_AVAILABLE`|The operation could not be started because a required feature is not installed|`0x80370114`|
|`HCS_E_OPERATION_NOT_STARTED`|The operation has not started|`0x80370115`|
|`HCS_E_OPERATION_ALREADY_STARTED`|The operation is already running|`0x80370116`|
|`HCS_E_OPERATION_PENDING`|The operation is still running|`0x80370117`|
|`HCS_E_OPERATION_TIMEOUT`|The operation did not complete in time|`0x80370118`|
|`HCS_E_OPERATION_SYSTEM_CALLBACK_ALREADY_SET`|An event callback has already been registered on this handle|`0x80370119`|
|`HCS_E_OPERATION_RESULT_ALLOCATION_FAILED`|Not enough memory available to return the result of the operation|`0x8037011A`|
|`HCS_E_ACCESS_DENIED`|Insufficient privileges. Only administrators or users that are members of the Hyper-V Administrators user group are permitted to access virtual machines or containers. To add yourself to the Hyper-V Administrators user group, please see https://aka.ms/hcsadmin for more information.|`0x8037011B`|
|`HCS_E_GUEST_CRITICAL_ERROR`|The virtual machine or container reported a critical error and was stopped or restarted|`0x8037011C`|
|`HCS_E_PROCESS_INFO_NOT_AVAILABLE`|The process information is not available|`0x8037011D`|
|`HCS_E_SERVICE_DISCONNECT`|The host compute system service has disconnected unexpectedly|`0x8037011E`|
|`HCS_E_PROCESS_ALREADY_STOPPED`|The process has already exited|`0x8037011F`|