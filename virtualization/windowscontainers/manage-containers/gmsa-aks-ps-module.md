# gMSA on Azure Kubernetes Service

Group Managed Service Accounts (gMSA) can be used on Azure Kubernetes Service (AKS) to support applications that require Active Directory for authentication purposes. The configuration of gMSA on AKS requires you to properly set up the following services and settings: AKS, Azure Key Vault, Active Directory, credential specs, etc. In order to streamline this process, you can use the PowerShell module below. This module was tailor-made for simplifying the process of configuring gMSA on AKS by removing the complexity of setting up different services.

>[!Note]
>gMSA on AKS is currently in Public Preview. For more information on gMSA on AKS, please visit the [Azure Kubernetes Service documentation page](https://docs.microsoft.com/en-us/azure/aks/).

## Environment requirements

In order to deploy gMSA on AKS, you will need the following:

- An AKS cluster with Windows nodes up and running. If you don't have an AKS cluster ready, checkout the [Azure Kubernetes Service documentation](https://docs.microsoft.com/en-us/azure/aks/windows-container-cli).
    - Your cluster must be authorized for the gMSA on AKS [Public Preview](). 
- An Active Directory environment properly configured for gMSA. Details on how to configure your domain will provided below.
    - Your Windows nodes on AKS must be able to connect to your Active Directory Domain Controllers.
- Active Directory domain credentials with delegated authorization to setup the gMSA and a standard domain user. This task can be delegated to authorized people (if needed).

## Install the gMSA on AKS PowerShell Module

To get started, download the PowerShell Module from the PowerShell gallery:
   ```powershell
   Install-Module -Name AksGMSA -Repository PSGallery -Force
   ```

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

If you prefer to use the Azure CLI, you can use:

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

While using the gMSA on AKS PowerShell module, you will be connecting to the AKS cluster you want to configure. The gMSA on AKs PowerShell module relies on the kubectl connection. To connect your cluster, run the following: (Notice that because you provided the inputs above, you can simply copy and paste the command below into your PowerShell session)

   ```powershell
    Import-AzAksCredential -Force `
    -ResourceGroupName $params["aks-cluster-rg-name"] `
    -Name $params["aks-cluster-name"]
   ```

## Confirm the AKS cluster has gMSA feature properly configured

Your AKS cluster might or might not be already configured for gMSA. To validate that the cluster is ready for utilization of gMSA, run the following command:

   ```powershell
    Confirm-AksGMSAConfiguration `
    -AksResourceGroupName $params["aks-cluster-rg-name"] `
    -AksClusterName $params["aks-cluster-name"] `
    -AksGMSADomainDnsServer $params["aks-domain-dns-server"] `
    -AksGMSARootDomainName $params["aks-root-domain-name"]
   ```
After configuring your cluster, you can configure the remaining infrastructure necessary for gMSA to work.

## Configure your Active Directory environment

The first step in preparing your Active Directory, is to ensure the Key Distribution System is configured. For this step, the commands need to be executed with credentials with the proper delegation, against a Domain Controller. This task can be delegated to authorized people.

From a Domain Controller run the following to enable the root key:

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
    -DomainAdmin "$($params["domain-netbios-name"])\$($params["domain-admin-user-name"])" `
    -DomainAdminPassword $params["domain-admin-user-password"]
   ```

### Create the gMSA

   ```powershell
    # Creates the gMSA account, and it authorizes only the standard domain user.
    New-GMSA `
    -Name $params["gmsa-name"] `
    -AuthorizedUser $params["gmsa-domain-user-name"] `
    -DomainControllerAddress $params["domain-controller-address"] `
    -DomainAdmin "$($params["domain-netbios-name"])\$($params["domain-admin-user-name"])" `
    -DomainAdminPassword $params["domain-admin-user-password"]
   ```

## Setup Azure Key Vault and Azure user-assigned Managed Identity

Azure Key Vault (AKV) will be used to store the credential used by the Windows nodes on AKS to communicate to the Active Directory Domain Controllers. A Managed Identity (MI) will be used to provide proper access to AKV for your Windows Nodes.

### Create the Azure key vault

   ```powershell
    # The Azure key vault will have a secret with the credentials of the standard
    # domain user authorized to fetch the gMSA.
    New-GMSAAzureKeyVault `
    -ResourceGroupName $params["aks-cluster-rg-name"] `
    -Location $params["azure-location"] `
    -Name $params["akv-name"] `
    -SecretName $params["akv-secret-name"] `
    -GMSADomainUser "$($params["domain-netbios-name"])\$($params["gmsa-domain-user-name"])" `
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
    -DomainUser "$($params["domain-netbios-name"])\$($params["gmsa-domain-user-name"])" `
    -DomainUserPassword $params["gmsa-domain-user-password"]
   ```
At this stage, the configuration of gMSA on AKS is completed. You can now deploy your workload on your Windows nodes.

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

The logs will be copied from each Windows hosts to the local directory $params["logs-directory"]. The logs directory will have a subdirectory named after each Windows agent host. The CCG (Container Credential Guard) .evtx log file can be properly inspected in the Event Viewer, only after the following requirements are met:

- The Containers Windows feature is installed. It can be installed via PowerShell with:
 ```powershell
# Needs computer restart
Install-WindowsFeature -Name Containers
 ```
- The CCGEvents.man logging manifest file is registered via:
 ```powershell
wevtutil im CCGEvents.man
 ```
Note: The logging manifest file needs to be provided by Microsoft.

## Setup sample application using gMSA

In addition to streamlining the configuration of gMSA on AKS, the PowerShell module also provides a sample application for you to use for testing purposes. To install the sample application, run the following:

   ```powershell
   Get-GMSASampleApplicationYAML `
    -SpecName $params["gmsa-spec-name"] `
    -AksWindowsNodePoolsNames $params["aks-win-node-pools-names"] | kubectl apply -f -
   ```

## Module feedback

For feedback, questions, and suggestions for the gMSA on AKS PowerShell module, please visit the [Windows Containers repo on GitHub](https://github.com/microsoft/Windows-Containers/issues).