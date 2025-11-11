---
title: Validate gMSA on AKS with the PowerShell module
description: Validate gMSA on Azure Kubernetes service for Windows containers.
author: vrapolinario
ms.author: roharwoo
ms.date: 01/23/2025
ms.topic: how-to
---

# Validate gMSA on AKS with the PowerShell module

Once you configure gMSA on AKS with the PowerShell module, your application is ready to be deployed on your Windows nodes on AKS. However, if you want to further validate that the configuration is set-up correctly, you can use the instructions below to confirm if your deployment is properly configured.

## Validation

The gMSA on AKS PowerShell module provides a command to validate if the settings for your environment are properly configured. Validate that the gMSA credential spec works with the following command:

   ```powershell
    Start-GMSACredentialSpecValidation `
    -SpecName $params["gmsa-spec-name"] `
    -AksWindowsNodePoolsNames $params["aks-win-node-pools-names"]
   ```

## Collect gMSA logs from your Windows nodes

The following command can be used to extract logs from the Windows hosts:

   ```powershell
    # Extracts the following logs from each Windows host:
    # - kubelet logs.
    # - CCG (Container Credential Guard) logs (as a .evtx file).
    Copy-WindowsHostsLogs -LogsDirectory $params["logs-directory"]
   ```

The logs will be copied from each Windows hosts to the local directory `$params["logs-directory"]`. The logs directory will have a subdirectory named after each Windows agent host. The CCG (Container Credential Guard) .evtx log file can be properly inspected in the Event Viewer, only after the following requirements are met:

- The Containers Windows feature is installed. It can be installed via PowerShell using the following command:

 ```powershell
# Needs computer restart
Install-WindowsFeature -Name Containers
 ```

- The CCGEvents.man logging manifest file is registered via:

 ```powershell
wevtutil im CCGEvents.man
 ```

> [!NOTE]
> The logging manifest file needs to be provided by Microsoft.

## Setup sample application using gMSA

In addition to streamlining the configuration of gMSA on AKS, the PowerShell module also provides a sample application for you to use for testing purposes. To install the sample application, run the following:

   ```powershell
   Get-GMSASampleApplicationYAML `
    -SpecName $params["gmsa-spec-name"] `
    -AksWindowsNodePoolsNames $params["aks-win-node-pools-names"] | kubectl apply -f -
   ```

## Validate AKS agent pool access to Azure Key Vault

Your AKS node pools need to be able to access the Azure Key Vault secret in order to use the account that can retrieve the gMSA on Active Directory. It's important that you have configured this access correctly so your nodes can communicate with your Active Directory Domain Controller. Fail to access the secrets means your application won't be able to authenticate. On the other hand, you might want to ensure no access is given to node pools that don't necessarily need it.

The gMSA on AKS PowerShell module allows you to validate which node pools have access to which secrets on Azure Key Vault.

   ```powershell
   Get-AksAgentPoolsAkvAccess `
    -AksResourceGroupName $params["aks-cluster-rg-name"] `
    -AksClusterName $params["aks-cluster-name"] `
    -VaultResourceGroupNames $params["aks-cluster-rg-name"]
   ```

## Share feedback

For feedback, questions, and suggestions on the gMSA on AKS PowerShell module, please visit the [Windows Containers repo on GitHub](https://github.com/microsoft/Windows-Containers/issues).
