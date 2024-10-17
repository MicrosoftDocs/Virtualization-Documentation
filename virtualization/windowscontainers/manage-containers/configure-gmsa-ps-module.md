---
title: Configure gMSA on AKS with the PowerShell module
description: Configure gMSA on Azure Kubernetes service for Windows containers.
author: vrapolinario
ms.author: roharwoo
ms.date: 03/23/2022
ms.topic: how-to

---

# Configure gMSA on Azure Kubernetes Service with the PowerShell module

In this section we will cover how to set up gMSA on Azure Kubernetes Service using the gMSA on AKS PowerShell module. The steps below assume you have installed the gMSA on AKS PowerShell module, connected to your AKS clusters, and provided the required parameters. If you haven't already, make sure you follow the steps on the [first section of this tutorial](./gmsa-aks-ps-module.md).

## Confirm the AKS cluster has gMSA feature properly configured

Your AKS cluster might or might not be already configured for gMSA. To validate that the cluster is ready for utilization of gMSA, run the following command:

   ```powershell
    Confirm-AksGMSAConfiguration `
    -AksResourceGroupName $params["aks-cluster-rg-name"] `
    -AksClusterName $params["aks-cluster-name"] `
    -AksGMSADomainDnsServer $params["domain-dns-server"] `
    -AksGMSARootDomainName $params["domain-fqdn"]
   ```
After configuring your cluster, you can configure the remaining infrastructure necessary for gMSA to work.

## Configure your Active Directory environment

The first step in preparing your Active Directory, is to ensure the Key Distribution System is configured. For this step, the commands need to be executed with credentials with the proper delegation, against a Domain Controller. This task can be delegated to authorized people.

From a Domain Controller, run the following to enable the root key:

For production environments:

   ```powershell
# You will need to wait 10 hours before the KDS root key is
# replicated and available for use on all domain controllers.
Add-KdsRootKey -EffectiveImmediately
   ```

For testing environments:

   ```powershell
# For single-DC test environments ONLY.
Add-KdsRootKey -EffectiveTime (Get-Date).AddHours(-10)
   ```

For the following commands, you can either run them on your Domain Controller or on a remote PowerShell session. If running from your Domain Controller, remove the "DomainControllerAddress", "DomainUser", and "DomainPassword" parameters from the command.

If running remotely, make sure your Domain Controller is configured for remote management.

### Create the standard domain user

   ```powershell
    # Creates the standard domain user.
    New-GMSADomainUser `
    -Name $params["gmsa-domain-user-name"] `
    -Password $params["gmsa-domain-user-password"] `
    -DomainControllerAddress $params["domain-controller-address"] `
    -DomainAdmin "$($params["domain-fqdn"])\$($params["domain-admin-user-name"])" `
    -DomainAdminPassword $params["domain-admin-user-password"]
   ```

### Create the gMSA

   ```powershell
    # Creates the gMSA account, and it authorizes only the standard domain user.
    New-GMSA `
    -Name $params["gmsa-name"] `
    -AuthorizedUser $params["gmsa-domain-user-name"] `
    -DomainControllerAddress $params["domain-controller-address"] `
    -DomainAdmin "$($params["domain-fqdn"])\$($params["domain-admin-user-name"])" `
    -DomainAdminPassword $params["domain-admin-user-password"]
   ```

## Setup Azure Key Vault and Azure user-assigned Managed Identity

Azure Key Vault (AKV) will be used to store the credential used by the Windows nodes on AKS to communicate to the Active Directory Domain Controllers. A Managed Identity (MI) will be used to provide proper access to AKV for your Windows nodes.

### Create the Azure key vault

   ```powershell
    # The Azure key vault will have a secret with the credentials of the standard
    # domain user authorized to fetch the gMSA.
    New-GMSAAzureKeyVault `
    -ResourceGroupName $params["aks-cluster-rg-name"] `
    -Location $params["azure-location"] `
    -Name $params["akv-name"] `
    -SecretName $params["akv-secret-name"] `
    -GMSADomainUser "$($params["domain-fqdn"])\$($params["gmsa-domain-user-name"])" `
    -GMSADomainUserPassword $params["gmsa-domain-user-password"]
   ```

### Create the Azure user-assigned managed identity

   ```powershell
    New-GMSAManagedIdentity `
    -ResourceGroupName $params["aks-cluster-rg-name"] `
    -Location $params["azure-location"] `
    -Name $params["ami-name"]
   ```

### Grant AKV access to the AKS Windows hosts

   ```powershell
    # Appends the user-assigned managed identity to the AKS Windows agent pools given as input parameter.
    # Configures the AKV read access policy for the user-assigned managed identity.
    Grant-AkvAccessToAksWindowsHosts `
    -AksResourceGroupName $params["aks-cluster-rg-name"] `
    -AksClusterName $params["aks-cluster-name"] `
    -AksWindowsNodePoolsNames $params["aks-win-node-pools-names"] `
    -VaultResourceGroupName $params["aks-cluster-rg-name"] `
    -VaultName $params["akv-name"] `
    -ManagedIdentityResourceGroupName $params["aks-cluster-rg-name"] `
    -ManagedIdentityName $params["ami-name"]
   ```

### Setup gMSA credential spec with the RBAC resources

   ```powershell
    # Creates the gMSA credential spec.
    # Configures the appropriate RBAC resources (ClusterRole and RoleBinding) for the spec.
    # Executes AD commands to get the appropriate domain information for the credential spec.
    New-GMSACredentialSpec `
    -Name $params["gmsa-spec-name"] `
    -GMSAName $params["gmsa-name"] `
    -ManagedIdentityResourceGroupName $params["aks-cluster-rg-name"] `
    -ManagedIdentityName $params["ami-name"] `
    -VaultName $params["akv-name"] `
    -VaultGMSASecretName $params["akv-secret-name"] `
    -DomainControllerAddress $params["domain-controller-address"] `
    -DomainUser "$($params["domain-fqdn"])\$($params["gmsa-domain-user-name"])" `
    -DomainUserPassword $params["gmsa-domain-user-password"]
   ```
At this stage, the configuration of gMSA on AKS is completed. You can now deploy your workload on your Windows nodes.

## Next steps

> [!div class="nextstepaction"]
> [Validate gMSA on AKS with PowerShell module](./validate-gmsa-ps-module.md)
