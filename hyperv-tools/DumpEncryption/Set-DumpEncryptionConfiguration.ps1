<#
 .SYNOPSIS
 Set-DumpEncryptionConfiguration

 .DESCRIPTION
 Allows to configure dump encryption based on a certificate

 .PARAMETER Certificate
 A X509Certificate2 object

 .PARAMETER WriteGroupPolicyPreferenceXml
 Writes a group policy preference registry configuration XML file which can be used with the group policy management console.

 .PARAMETER WriteRegistryFile
 Writes a .REG file which can be imported using reg.exe or regedit

 .PARAMETER Filepath
 The file path the output should be written to

 .PARAMETER WriteLocalRegistry
 Directly writes the registry configuration to the local system's registry

#>

Param(
    [Parameter(Mandatory=$True)]
    [System.Security.Cryptography.X509Certificates.X509Certificate2]
    $Certificate,

    [Parameter(ParameterSetName = "WriteGroupPolicyPreferenceXml")]
    [switch]$WriteGroupPolicyPreferenceXml,
    [Parameter(ParameterSetName = "WriteRegistryFile")]
    [switch]$WriteRegistryFile,

    [Parameter(Mandatory=$True,ParameterSetName = "WriteGroupPolicyPreferenceXml")]
    [Parameter(Mandatory=$True,ParameterSetName = "WriteRegistryFile")]
    [string]$Filepath,

    [Parameter(ParameterSetName = "WriteLocalRegistry")]
    [switch]$WriteLocalRegistry,

    [switch]$Force
)

#######################################################################################
# Initialization of variables and parameter check
#######################################################################################

$Script:RegFileTemplate=@"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl]
"DumpEncryptionEnabled"=dword:00000001

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates\Certificate.1]
"Thumbprint"="%thumbprint%"
"PublicKey"=%publickey%

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting]
"Disabled"=dword:00000001
"@

$Script:GroupPolicyPreferencesXMLTemplate=[xml]@"
<?xml version="1.0" encoding="utf-8"?>
<RegistrySettings clsid="{A3CCFC41-DFDB-43a5-8D26-0FE8B954DA51}">
	<Registry clsid="{9CD4B2F4-923D-47f5-A062-E897DD1DAD50}" name="Dump Encryption Public Key" descr="Registry settings for dump encryption" image="17">
		<Properties action="U" hive="HKEY_LOCAL_MACHINE" key="SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates\Certificate.1" name="PublicKey" default="0" type="REG_BINARY" displayDecimal="0" value="PublicKey"/>
	</Registry>
	<Registry clsid="{9CD4B2F4-923D-47f5-A062-E897DD1DAD50}" name="Dump Encryption Thumbprint" descr="Registry settings for dump encryption" image="7">
		<Properties action="U" hive="HKEY_LOCAL_MACHINE" key="SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates\Certificate.1" name="Thumbprint" default="0" type="REG_SZ" displayDecimal="0" value="Thumbprint"/>
	</Registry>
	<Registry clsid="{9CD4B2F4-923D-47f5-A062-E897DD1DAD50}" name="Disable Windows Error Reporting" descr="Registry settings for dump encryption" image="12">
		<Properties action="U" hive="HKEY_LOCAL_MACHINE" key="SOFTWARE\Microsoft\Windows\Windows Error Reporting" name="Disabled" default="0" type="REG_DWORD" displayDecimal="0" value="00000001"/>
	</Registry>
	<Registry clsid="{9CD4B2F4-923D-47f5-A062-E897DD1DAD50}" name="Enable Dump Encryption" descr="Registry settings for dump encryption" image="12">
		<Properties action="U" hive="HKEY_LOCAL_MACHINE" key="SYSTEM\CurrentControlSet\Control\CrashControl" name="DumpEncryptionEnabled" default="0" type="REG_DWORD" displayDecimal="0" value="00000001"/>
	</Registry>
</RegistrySettings>
"@

if (($Certificate.PublicKey.Key.KeySize -ne 2048) -or ($Certificate.PublicKey.Key.KeyExchangeAlgorithm -ne "RSA-PKCS1-KeyEx"))
{
    throw "2048 Bit RSA key expected"
}

#######################################################################################
# Functions
#######################################################################################
function Write-RegFile 
{
    Param(
        $filepath,
        $keyblob,
        $thumbprint
    )
    # Format the binary key blob properly for a .REG file 
    $keyblobstring = "hex:" + $([BitConverter]::ToString($keyblob)).toLower() -replace "-",","

    # Replace placeholders in template string
    $regfilecontent = $Script:RegFileTemplate -replace "%thumbprint%", $thumbprint
    $regfilecontent = $regfilecontent -replace "%publickey%", $keyblobstring

    # Write content to file path
    $regfilecontent | Out-File -FilePath $filepath -Force
}

function Write-GPPXmlFile
{
    Param(
        $filepath,
        $keyblob,
        $thumbprint
    )
    # Format the binary key blob properly for the XML file 
    $keyblobstring = $([BitConverter]::ToString($keyblob)).toLower() -replace "-",""

    $XMLDoc = $Script:GroupPolicyPreferencesXMLTemplate

    # Get parent XML nodes for placeholders
    $PublicKeyNode = $XMLDoc.RegistrySettings.Registry | Where {$_.Properties.name -eq "PublicKey" }
    $ThumbPrintNode = $XMLDoc.RegistrySettings.Registry | Where {$_.Properties.name -eq "Thumbprint" }

    # Replace placeholders in xml doc
    $PublicKeyNode.Properties.Value = $keyblobstring
    $ThumbPrintNode.Properties.Value = $thumbprint

    # Write XML doc to file path
    $XMLDoc.Save($filepath)
}

function Write-LocalRegistry
{
    Param(
        $keyblob,
        $thumbprint
    )

    # Writing registry keys / values
    Set-ItemProperty -Name DumpEncryptionEnabled -Path HKLM:\\SYSTEM\CurrentControlSet\Control\CrashControl -Type Dword -Value 1 | Out-Null

    # Creating registry keys for certificate
    New-Item -Name EncryptionCertificates -Path HKLM:\\SYSTEM\CurrentControlSet\Control\CrashControl -Force | Out-Null
    New-Item -Name Certificate.1 -Path HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates -Force | Out-Null

    # Setting public key and thumbprint registry values
    Set-ItemProperty -Name PublicKey -Path HKLM:\\SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates\Certificate.1 -Type Binary -Value $keyblob
    Set-ItemProperty -Name Thumbprint -Path HKLM:\\SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates\Certificate.1 -Type String -Value $thumbprint

    #Write-Output "Disabling Windows Error Reporting - WER can't open encrypted crash dumps"
    Set-ItemProperty -Name Disabled -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Type DWord -Value 1 | Out-Null

    If ((Get-ItemProperty -Name GuardedHost -Path HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl\ForceDumpsDisabled) -eq 1)
    {
        Write-Warning "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl\ForceDumpsDisabled::GuardedHosts is currently set to 1. No dumps will be generated."
        Write-Output "Change this value to 0 to allow dumps to be generated"
    }
}

#######################################################################################
# Start of script
#######################################################################################

# Exporting the raw public key from certificate
[xml]$exportedkey = ([xml]$Certificate.PublicKey.Key.ToXmlString($false))
$modulus = [System.Convert]::FromBase64String($exportedkey.RSAKeyValue.Modulus)
$exponent = [System.Convert]::FromBase64String($exportedkey.RSAKeyValue.Exponent)

# Preparing values for BCRYPT_RSAKEY_BLOB structure
# See https://msdn.microsoft.com/en-us/library/windows/desktop/aa375531(v=vs.85).aspx
[byte[]]$rsapublic_magic = [BitConverter]::GetBytes(0x31415352)
[byte[]]$bitlen = [BitConverter]::GetBytes([Convert]::ToUInt32($Certificate.PublicKey.Key.KeySize))
[byte[]]$cbmodulus = [BitConverter]::GetBytes([Convert]::ToUInt32($modulus.Length))
[byte[]]$cbpublicexp = [BitConverter]::GetBytes([Convert]::ToUInt32($exponent.Length))
[byte[]]$cbprime1 = (0x00, 0x00, 0x00, 0x00)
[byte[]]$cbprime2 = (0x00, 0x00, 0x00, 0x00)

# Merging byte arrays to single public key blob
[byte[]]$keyblob = $rsapublic_magic + $bitlen + $cbpublicexp + $cbmodulus + $cbprime1 + $cbprime2 +$exponent +$modulus

# Creating SHA256 hash for key blob - this hash is used for attestation
$sha256csp = New-Object System.Security.Cryptography.SHA256CryptoServiceProvider
$sha256hash = ([string]([System.BitConverter]::ToString($sha256csp.ComputeHash($keyblob)))).Replace("-","")
$sha256csp.Dispose()

If ((-not $Force) -and (Test-Path -Path $Filepath))
{
    throw "$filepath already exists. Use -Force to overwrite."
}

# Action based on active parameter set:
If ($WriteRegistryFile)
{
    Write-Output "Writing registry file for dump encryption"
    Write-RegFile -filepath $Filepath -keyblob $keyblob -thumbprint $Certificate.Thumbprint
    Write-Output "$filepath"
}

If ($WriteGroupPolicyPreferenceXml)
{
    Write-Output "Writing group policy preference XML file for dump encryption"
    Write-GPPXmlFile -filepath $Filepath -keyblob $keyblob -thumbprint $Certificate.Thumbprint
    Write-Output "$filepath"
}

If ($WriteLocalRegistry)
{
    if ((-not $Force) -and (Get-Item -Path HKLM:\\SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates))
    {
        throw "HKEY_LOCAL_MACHINE:\\SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates structure already exists. Use -Force to overwrite."
    }
    
    Write-Output "Writing registry keys for dump encryption"
    Write-LocalRegistry -keyblob $keyblob -thumbprint $Certificate.Thumbprint
}

Write-Output ""
Write-Output "If you are using a Host Guardian Service in your environment,`nplease configure this hash for dump encryption using HGS Policy:"
Write-Output "$($sha256hash)"
