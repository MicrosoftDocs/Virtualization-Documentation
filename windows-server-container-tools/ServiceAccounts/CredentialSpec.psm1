# This requires the ActiveDirectory module. Run Add-WindowsFeature rsat-ad-powershell to install it
Import-Module ActiveDirectory
$Script:CredentialSpecPath="$($env:ProgramData)\Docker\CredentialSpecs"

try
{
  $Script:CredentialSpecPath= "$($(docker info --format '{{json .DockerRootDir}}').Replace('"',''))\CredentialSpecs"
}
catch
{
  $Script:CredentialSpecPath="$($env:ProgramData)\Docker\CredentialSpecs"
  $next=$true
}

if ($next){
  try
  {
    if (Test-Path "$env:ProgramData\docker\config\daemon.json")
    {
      $Script:CredentialSpecPath="$($(get-content "$($env:ProgramData)\docker\config\daemon.json" | out-string | convertfrom-json).graph)\CredentialSpecs"
    }
  }
  catch
  {  
    $Script:CredentialSpecPath="$($env:ProgramData)\Docker\CredentialSpecs"
  }
}

<#
 .Synopsis
  Creates and stores a credential specification file

 .Description
  Windows containers are able to run with an Active Directory identity. This enables applications running
  in the container to use Windows authentication instead of stored username/password combinations.

  Each credential spec contains:
  - A default account used that will be mapped to LocalSystem & Network Service in the container
  - (Optional) Additional group Managed Service Accounts that may be used in the container

  .Parameter Name
   The name for the new credential specification

  .Parameter AccountName
   The group Managed Service Account name used for the default account


  .Parameter Domain
   The Active Directory domain used for the default account. If not specified, will use the domain of the host.

  
  .Parameter AdditionalAccounts
   A list of additional group Managed Service Accounts that will be available to running services


  .Example
   # Create a new credential spec named "ContainerApp1"
   New-CredentialSpec -Name "ContainerApp1" -Domain (Get-ADDomain) -AccountName "AppAccount1"

  .Example
   # Create a new credential spec named "CS1"
   # - with default account "WebApp1"
   # - and an additional account "acct1" on domain "domain1"
   New-CredentialSpec -Name CS1 -AccountName WebApp1 -AdditionalAccounts @{DomainName = "domain1"; AccountName = "acct1" }, @{DomainName = "domain1"; AccountName="acct2"}

#>
function New-CredentialSpec
{
param(
    [Parameter(Mandatory=$true)] [String] $Name,
    [Parameter(Mandatory=$true)] [String] $AccountName,
    [Parameter(Mandatory=$false)] [Microsoft.ActiveDirectory.Management.ADDomain] $Domain = (Get-ADDomain),
    [Parameter(Mandatory=$false)] $AdditionalAccounts
     )


    # TODO: verify $Script:CredentialSpecPath exists

    # Start hash table for output
    $output = @{}



    # Create ActiveDirectoryConfig Object
    $output.ActiveDirectoryConfig = @{}
    $output.ActiveDirectoryConfig.GroupManagedServiceAccounts = @( @{"Name" = $AccountName; "Scope" = $Domain.DNSRoot } )
    $output.ActiveDirectoryConfig.GroupManagedServiceAccounts += @{"Name" = $AccountName; "Scope" = $Domain.NetBIOSName }
    if ($AdditionalAccounts) {
        $AdditionalAccounts | ForEach-Object {
            $output.ActiveDirectoryConfig.GroupManagedServiceAccounts += @{"Name" = $_.AccountName; "Scope" = $_.DomainName }
        }
    }
    
    # Create CmsPlugins Object
    $output.CmsPlugins = @("ActiveDirectory")


    # Create DomainJoinConfig Object
    $output.DomainJoinConfig = @{}
    $output.DomainJoinConfig.DnsName = $Domain.DNSRoot
    $output.DomainJoinConfig.Guid = $Domain.ObjectGUID
    $output.DomainJoinConfig.DnsTreeName = $Domain.Forest
    $output.DomainJoinConfig.NetBiosName = $Domain.NetBIOSName
    $output.DomainJoinConfig.Sid = $Domain.DomainSID.Value
    $output.DomainJoinConfig.MachineAccountName = $AccountName


    $output | ConvertTo-Json -Depth 5 | Out-File -FilePath "$($Script:CredentialSpecPath)\\$($Name).json" -encoding ascii

}



<#
 .Synopsis
  Gets all credential specs on current system

 .Description
  Windows containers are able to run with an Active Directory identity. This enables applications running
  in the container to use Windows authentication instead of stored username/password combinations.
#>
function Get-CredentialSpec
{
    Get-ChildItem $Script:CredentialSpecPath | Select-Object @{ 
            Name='Name'
            Expression = { $_.BaseName }
        },
        @{
            Name='Path'
            Expression = { $_.FullName }
        } 
}
