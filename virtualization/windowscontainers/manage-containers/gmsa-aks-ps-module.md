---
title: Use gMSA on Azure Kubernetes Service in Windows Containers
description: Learn how to use gMSA on Azure Kubernetes Service in Windows Containers.
keywords: gMSA, containers, PowerShell
author: vrapolinario
ms.author: viniap
ms.date: 04/09/2022
ms.topic: how-to

---

# gMSA on Azure Kubernetes Service

Group Managed Service Accounts (gMSA) can be used on Azure Kubernetes Service (AKS) to support applications that require Active Directory for authentication purposes. The configuration of gMSA on AKS requires you to properly set up the following services and settings: AKS, Azure Key Vault, Active Directory, credential specs, etc. In order to streamline this process, you can use the PowerShell module below. This module was tailor-made for simplifying the process of configuring gMSA on AKS by removing the complexity of setting up different services.

## Environment requirements

In order to deploy gMSA on AKS, you will need the following:

- An AKS cluster with Windows nodes up and running. If you don't have an AKS cluster ready, checkout the [Azure Kubernetes Service documentation](/azure/aks/windows-container-cli).
    - Your cluster must be authorized for the gMSA on AKS. For more information, see [Enable Group Managed Service Accounts (GMSA) for your Windows Server nodes on your Azure Kubernetes Service (AKS) cluster](/azure/aks/use-group-managed-service-accounts). 
- An Active Directory environment properly configured for gMSA. Details on how to configure your domain will provided below.
    - Your Windows nodes on AKS must be able to connect to your Active Directory Domain Controllers.
- Active Directory domain credentials with delegated authorization to setup the gMSA and a standard domain user. This task can be delegated to authorized people (if needed).

## Install the gMSA on AKS PowerShell Module

To get started, download the PowerShell Module from the PowerShell gallery:
   ```powershell
   Install-Module -Name AksGMSA -Repository PSGallery -Force
   ```

>[!Note]
>The gMSA on AKS PowerShell module is constantly updated. If you ran the steps on this tutorial before and is now checking back on new configurations, make sure you update the module to the latest version. More information on the module can be found on the [PowerShell Gallery page](https://www.powershellgallery.com/packages/AksGMSA/).

## Module requirements

The gMSA on AKS PowerShell module relies on different modules and tools. In order to install these requirements, run the following on an elevated session:

   ```powershell
   Install-ToolingRequirements
   ```


## Login with your Azure credential

You will need to be logged in to Azure with your credentials for the gMSA on AKS PowerShell module to properly configure your AKS cluster. To log into Azure via PowerShell, run the following:

   ```powershell
   Connect-AzAccount -DeviceCode -Subscription "<SUBSCRIPTION_ID>"
   ```

You also need to log in with the Azure CLI, as the PowerShell module also uses that in the background:

   ```powershell
   az login --use-device-code
   az account set --subscription "<SUBSCRIPTION_ID>"
   ```

## Setting up required inputs for gMSA on AKS module

Throughout the configuration of gMSA on AKS many inputs will be needed, such as: Your AKS cluster name, Azure Resource Group name, region to deploy the necessary assets, Active Directory domain name, and much more. To streamline the process below, we created an input command that will gather all the necessary values and store it on a variable that will then be used on the commands below.

To start, run the following:

   ```powershell
   $params = Get-AksGMSAParameters
   ```
After running the command, provide the necessary inputs until the command finishes. From now on, you can simply copy and paste the commands as shown in this page.

## Connect to your AKS cluster

While using the gMSA on AKS PowerShell module, you will be connecting to the AKS cluster you want to configure. The gMSA on AKs PowerShell module relies on the kubectl connection. To connect your cluster, run the following: (Notice that because you provided the inputs above, you can simply copy and paste the command below into your PowerShell session).

   ```powershell
    Import-AzAksCredential -Force `
    -ResourceGroupName $params["aks-cluster-rg-name"] `
    -Name $params["aks-cluster-name"]
   ```

## Next steps

> [!div class="nextstepaction"]
> [Configure gMSA on AKS with PowerShell module](./configure-gmsa-ps-module.md)
