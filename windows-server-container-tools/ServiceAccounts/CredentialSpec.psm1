# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

# Helper function to obtain credential spec directory
# Order: Docker Root Directory, Docker Graph Directory, Program Data
$Script:CredSpecRoot = $null
function GetCredSpecRoot {
    # Check if root already computed
    if ($Script:CredSpecRoot) {
        return $Script:CredSpecRoot
    }

    # Default location is Docker's Program Data folder
    $root = "$env:ProgramData\Docker"

    # First, try to query the Docker root directory
    try {
        $DockerRootDir = docker info --format "{{.DockerRootDir}}" | Convert-Path
        if (Test-Path $DockerRootDir) {
            $root = $DockerRootDir
        }
        else {
            $TryGraph = $true
        }
    }
    catch {
        $TryGraph = $true
    }

    # If the Docker root directory doesn't exist or couldn't be found, try the graph directory
    $DaemonFile = "$env:ProgramData\Docker\config\daemon.json"
    if ($TryGraph -and (Test-Path "$env:ProgramData\Docker\config\daemon.json")) {
        $config = Get-Content $DaemonFile | ConvertFrom-Json
        
        if ($config.graph -and (Test-Path $config.graph)) {
            $root = $config.graph | Convert-Path
        }
    }

    # Finally, build full path and check for credential spec folder
    $CredSpecRoot = Join-Path $root "\CredentialSpecs"
    
    if (Test-Path $CredSpecRoot) {
        $Script:CredSpecRoot = $CredSpecRoot
        return $CredSpecRoot
    }
    else {
        throw "Credential spec directory does not exist: $CredSpecRoot"
    }
}

function TestgMSAExistence($AccountName, $Domain, $AKV) {
    $gMSA = Get-ADServiceAccount -Identity $AccountName -Server $Domain -ErrorAction SilentlyContinue
    if (-not $gMSA) {
        Write-Error "The group managed service account `"$AccountName`" could not be found in the $Domain domain.`nIf the account belongs to a different domain, specify the correct domain using the -Domain parameter (or hashtable key for additional accounts) and ensure a trust has been established between this computer's domain and the gMSA's domain."
        return $false
    }
    elseif ((-not $AKV) -and -not (Test-ADServiceAccount -Identity $gMSA.DistinguishedName)) {
        Write-Warning "This computer is not authorized to use the group managed service account `"$AccountName`"`nRun `"Get-ADServiceAccount $AccountName -Properties PrincipalsAllowedToRetrieveManagedPassword`" and verify this computer object, or a security group to which the computer belongs, is allowed to retrieve the gMSA password.`nNote: if you recently added this computer account to a security group, you may need to restart the computer for the group membership to take effect."
    }

    return $true
}

function New-CredentialSpec {

    <#
    .SYNOPSIS
    Creates and stores a credential spec file for Windows Containers.

    .DESCRIPTION
    Windows containers are able to run with an Active Directory identity. This enables applications running in the contianer to use Windows authentication instead of stored username/password combinations.
    
    Containers cannot join domains, but instead use group managed service accounts (gMSA) to act as the computer account on the network.
    This allows integrated Windows authentication to perform as it would on a traditional, domain-joined machine.
    The credential spec file defines which gMSA should be used when starting up a container.
    The gMSA account must already be provisioned in Active Directory and installed on the machine running the container before the container can use the identity.

    Each credential spec file contains:
    - A default account that will be mapped to Local System and Network Service in the container.
    - (Optional) Additional group managed service accounts that may be used inside the container.

    .PARAMETER AccountName
    The name of the group managed service account that should be used when the container communicates over the network.

    .PARAMETER Path
    The full path (*.json) to the file where the credential spec will be stored.

    .PARAMETER FileName
    The name of the file where the credential spec will be stored. If a value is not specified, the file name will default to DOMAIN_ACCOUNTNAME.json.
    The file will be located in the configured credential spec directory in Docker.
    To store the file in an arbitrary location on the filesystem (not in the Docker root directory), use the -Path parameter instead.

    .PARAMETER Domain
    The DNS name of the Active Directory domain where the gMSA account exists.
    If a domain name is not provided, the domain to which the current computer is joined will be used.

    .PARAMETER AdditionalAccounts
    The name of additional group managed service accounts that should be made available for use in the container.
    This parameter accepts a list of samAccountNames and hashtables with AccountName and Domain information for each additional gMSA.

    .PARAMETER NoClobber
    Determines whether New-CredentialSpec will overwrite existing credential specs in the event of a name collision.
    The default behavior is to overwrite existing files.

    .PARAMETER AKV
    Determines if Azure Key Vault is to be used for Credentials (CCGv2)

    .PARAMETER AkvObjectId
    If AKV is to be used, the ObjectId of the Secret in AKV.

    .PARAMETER AkvSecretUri
    If AKV is to be used, the URI of the Secret in AKV.

    .EXAMPLE
    New-CredentialSpec "FrontEndWeb01"

    Creates a credential spec using the default file name for a gMSA named "FrontEndWeb01".

    .EXAMPLE
    New-CredentialSpec "FrontEndWeb01" -FileName "credspec_for_webapp"

    Creates a credential spec for a gMSA named "FrontEndWeb01" and saves that file to "credspec_for_webapp.json"
    Note that .json is automatically appended to any file name if it is not already present.

    .EXAMPLE
    New-CredentialSpec -AccountName "BackEndWeb02" -Domain "dev.contoso.com"

    Create a credential spec for a gMSA named "BackEndWeb02" that belongs to the "dev.contoso.com" domain.

    .EXAMPLE
    New-CredentialSpec -AccountName "FrontEndWeb01" -AdditionalAccounts "LogAccount01", @{ AccountName = "gMSA3"; Domain = "dev.contoso.com" }

    Creates a credential spec for a gMSA named "FrontEndWeb01" and includes 2 additional gMSAs: LogAccount01 and gMSA3.
    gMSA3 comes from the dev.contoso.com domain, which may be different from the current computer's domain and that of the other gMSAs. 

    .EXAMPLE
    New-CredentialSpec -AccountName "FrontEndWeb01" -Path "C:\src\myapp\webapp01.json"
    
    Creates a credential spec for a gMSA named "FrontEndWeb01" and stores the file at "C:\src\myapp\webapp01.json"

    .EXAMPLE
    New-CredentialSpec -AccountName "FrontEndWeb01" -AKV -AkvObjectId "abcd-efabc-defab-cdef" -AkvSecretUri "https://contoso-key-vault.vault.azure.net"

    Creates a credential spec for gMSAv2 which incorporates Azure Key Valut credential information for the CCG plugin.
    #>

    [CmdletBinding(DefaultParameterSetName = "DefaultPath")]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [String]
        $AccountName,

        [Parameter(Mandatory = $true, ParameterSetName = "CustomPath")]
        [String]
        $Path,

        [Parameter(Mandatory = $false, ParameterSetName = "DefaultPath")]
        [Alias("Name")]
        [String]
        $FileName,

        [Parameter(Mandatory = $false)]
        [string]
        $Domain,

        [Parameter(Mandatory = $false)]
        [object[]]
        $AdditionalAccounts,

        [Parameter(Mandatory = $false)]
        [switch]
        $NoClobber = $false,

        [Parameter(Mandatory = $false)]
        [switch]
        $AKV = $false
    )

    DynamicParam
    {
        $portableParamDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        if($AKV)
        {
            $attributes = New-Object -Type System.Management.Automation.ParameterAttribute
            $attributes.Mandatory = $true
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)

            $AkvObjectId = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("AkvObjectId", [string], $attributeCollection)
            $AkvSecretUri = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("AkvSecretUri", [string], $attributeCollection)

            $portableParamDictionary.Add("AkvObjectId", $AkvObjectId)
            $portableParamDictionary.Add("AkvSecretUri", $AkvSecretUri)
        }
        return $portableParamDictionary
    }

    Process {

        # Check if computer is domain joined
        # TODO: Add support for AAD joined machines when an explicit domain name is specified
        $cs = Get-CimInstance -ClassName Win32_ComputerSystem -Property PartOfDomain
        if (-not $cs.PartOfDomain) {
            Write-Error "This computer is not joined to an Active Directory domain.`nNew-CredentialSpec is only supported on domain joined machines."
            return
        }

        # Import the AD PS module (required dependency to create new cred specs)
        try {
            Import-Module ActiveDirectory -Force -ErrorAction Stop
        }
        catch {
            # Generate instructions on how to obtain RSAT
            $os = Get-CimInstance -ClassName Win32_OperatingSYstem -Property OperatingSystemSKU, Version
            $installStep = "Check https://aka.ms/RSAT for more information on how to install the Active Directory Remote Server Administration Tools."
        
            # Check if Server SKU and provide Server Manager installation instructions
            if ($os.OperatingSystemSKU -in 7, 8, 12, 13, 64) {
                $installStep = "You can install the Active Directory PowerShell Module by running `"Install-WindowsFeature RSAT-AD-PowerShell`" in an elevated PowerShell window or by adding the feature using Server Manager or Windows Admin Center."
            }
            # Check if Win 10 1809 or greater and provide RSAT FOD installation instructions
            elseif ($os.Version -ge [System.Version]"10.0.17763") {
                $installStep = "You can install the Active Directory PowerShell module by adding the `"RSAT: Active Directory Domain Service and Lightweight Directory Services Tools`" optional feature in the Settings app or by running `"Install-WindowsCapability -Online 'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0'`" in an elevated PowerShell window."
            }

            Write-Error "The Active Directory PowerShell module is required to create a credential spec file.`n`n$installStep"
            return
        }

        # Ensure AD drive is present
        if (-not (Get-PSDrive -PSProvider ActiveDirectory)) {
            Write-Error "The Active Directory PowerShell Module cannot reach a domain controller.`nCheck your network configuration and try again."
            return
        }

        # Validate domain information
        if ($Domain) {
            $ADDomain = Get-ADDomain -Server $Domain -ErrorAction Continue

            if (-not $ADDomain) {
                Write-Error "The specified Active Directory domain ($Domain) could not be found.`nCheck your network connectivity and domain trust settings to ensure the current user can authenticate to a domain controller in that domain."
                return
            }
        }
        else {
            # Use the logged on user's domain if an explicit domain name is not provided
            $ADDomain = Get-ADDomain -Current LocalComputer -ErrorAction Continue

            if (-not $ADDomain) {
                Write-Error "An error ocurred while loading information for the computer account's domain.`nCheck your network connectivity to ensure the computer can authenticate to a domain controller in this domain."
                return
            }

            $Domain = $ADDomain.DNSRoot
        }

        # Clean up account names and validate formatting
        $AccountName = $AccountName.TrimEnd('$')

        if ($AdditionalAccounts) {
            $AdditionalAccounts = $AdditionalAccounts | ForEach-Object {
                if ($_ -is [hashtable]) {
                    # Check for AccountName and Domain keys
                    if (-not $_.AccountName -or -not $_.Domain) {
                        Write-Error "Invalid additional account specified: $_`nExpected a samAccountName or a hashtable containing AccountName and Domain keys."
                        return
                    }
                    else {

                        @{
                            AccountName = $_.AccountName.TrimEnd('$')
                            Domain = $_.Domain
                        }
                    }
                }
                elseif ($_ -is [string]) {
                    @{
                        AccountName = $_.TrimEnd('$')
                        Domain = $Domain
                    }
                }
                else {
                    Write-Error "Invalid additional account specified: $_`nExpected a samAccountName or a hashtable containing AccountName and Domain keys."
                    return
                }
            }
        }

        # Validate the accounts
        if (-not (TestgMSAExistence -AccountName $AccountName -Domain $Domain -AKV $AKV)) {
            return
        }
        if ($AdditionalAccounts) {
            foreach ($account in $AdditionalAccounts) {
                if (-not (TestgMSAExistence -AccountName $account.AccountName -Domain $account.Domain -AKV $AKV)) {
                    return
                }
            }
        }

        # Get the location to store the cred spec file either from input params or helper function
        if ($Path) {
            $CredSpecRoot = Split-Path $Path -Parent
            $FileName = Split-Path $Path -Leaf
        } else {
            $CredSpecRoot = GetCredSpecRoot
        }

        if (-not $FileName) {
            $FileName = "{0}_{1}" -f $ADDomain.NetBIOSName.ToLower(), $AccountName.ToLower()
        }

        $FullPath = Join-Path $CredSpecRoot "$($FileName.TrimEnd(".json")).json"
        if ((Test-Path $FullPath) -and $NoClobber) {
            Write-Error "A credential spec already exists with the name `"$FileName`".`nRemove the -NoClobber switch to overwrite this file or select a different name using the -FileName parameter."
            return
        }

        # Start hash table for output
        $output = @{}

        # Create ActiveDirectoryConfig Object
        $output.ActiveDirectoryConfig = @{}
        $output.ActiveDirectoryConfig.GroupManagedServiceAccounts = @( @{"Name" = $AccountName; "Scope" = $ADDomain.DNSRoot } )
        $output.ActiveDirectoryConfig.GroupManagedServiceAccounts += @{"Name" = $AccountName; "Scope" = $ADDomain.NetBIOSName }
        if ($AdditionalAccounts) {
            $AdditionalAccounts | ForEach-Object {
                $output.ActiveDirectoryConfig.GroupManagedServiceAccounts += @{"Name" = $_.AccountName; "Scope" = $_.Domain }
            }
        }

        if($AKV) {
            # Create HostAccountConfig Object
            $output.ActiveDirectoryConfig.HostAccountConfig = @{}
            $output.ActiveDirectoryConfig.HostAccountConfig.PortableCcgVersion = "1"
            $output.ActiveDirectoryConfig.HostAccountConfig.PluginGUID = "{CCC2A336-D7F3-4818-A213-272B7924213E}"
            $AkvObjectId = $AkvObjectId.Value.Trim()
            $AkvSecretUri = $AkvSecretUri.Value.Trim()
            $output.ActiveDirectoryConfig.HostAccountConfig.PluginInput = "ObjectId=$AkvObjectId;SecretUri=$AkvSecretUri"
        }
        
        # Create CmsPlugins Object
        $output.CmsPlugins = @("ActiveDirectory")

        # Create DomainJoinConfig Object
        $output.DomainJoinConfig = @{}
        $output.DomainJoinConfig.DnsName = $ADDomain.DNSRoot
        $output.DomainJoinConfig.Guid = $ADDomain.ObjectGUID
        $output.DomainJoinConfig.DnsTreeName = $ADDomain.Forest
        $output.DomainJoinConfig.NetBiosName = $ADDomain.NetBIOSName
        $output.DomainJoinConfig.Sid = $ADDomain.DomainSID.Value
        $output.DomainJoinConfig.MachineAccountName = $AccountName

        $output | ConvertTo-Json -Depth 5 | Out-File -FilePath $FullPath -Encoding ascii -NoClobber:$NoClobber

        Get-Item $FullPath | Select-Object @{
            Name       = 'Name'
            Expression = { $_.Name }
        },
        @{
            Name       = 'Path'
            Expression = { $_.FullName }
        }
    }
}

function Get-CredentialSpec {
    <#
    .SYNOPSIS
    Gets all file-based credential specs on current system

    .DESCRIPTION
    Windows containers are able to run with an Active Directory identity. This enables applications running
    in the container to use Windows authentication instead of stored username/password combinations.
    #>

    $CredSpecRoot = GetCredSpecRoot

    Get-ChildItem $CredSpecRoot | Select-Object @{
        Name       = 'Name'
        Expression = { $_.Name }
    },
    @{
        Name       = 'Path'
        Expression = { $_.FullName }
    }
}
