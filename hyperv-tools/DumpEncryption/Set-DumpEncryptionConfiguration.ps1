Param(
    [Parameter(Mandatory=$True)]
    [System.Security.Cryptography.X509Certificates.X509Certificate2]
    $Certificate,

    [switch]$Force
)

if (($Certificate.PublicKey.Key.KeySize -ne 2048) -or ($Certificate.PublicKey.Key.KeyExchangeAlgorithm -ne "RSA-PKCS1-KeyEx"))
{
    throw "2048 Bit RSA key expected"
}

if ((-not $Force) -and (Get-Item -Path HKLM:\\SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates))
{
    throw "HKEY_LOCAL_MACHINE:\\SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates structure already exists. Use -Force to continue."
}

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

Write-Output "Writing registry keys for dump encryption"
Write-Output "Certificate Thumbprint: $($Certificate.Thumbprint)"
Write-Output "Public Key Blob:"
Write-Output "$([BitConverter]::ToString($keyblob))"
Write-Output 

# Writing registry keys / values
Set-ItemProperty -Name DumpEncryptionEnabled -Path HKLM:\\SYSTEM\CurrentControlSet\Control\CrashControl -Type Dword -Value 1 | Out-Null

# Creating registry keys for certificate
New-Item -Name EncryptionCertificates -Path HKLM:\\SYSTEM\CurrentControlSet\Control\CrashControl -Force | Out-Null
New-Item -Name Certificate.1 -Path HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates -Force | Out-Null

# Setting public key and thumbprint registry values
Set-ItemProperty -Name PublicKey -Path HKLM:\\SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates\Certificate.1 -Type Binary -Value $keyblob
Set-ItemProperty -Name Thumbprint -Path HKLM:\\SYSTEM\CurrentControlSet\Control\CrashControl\EncryptionCertificates\Certificate.1 -Type String -Value $Certificate.Thumbprint

Write-Output "Disabling Windows Error Reporting - WER can't open encrypted crash dumps"
Set-ItemProperty -Name Disabled -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Type DWord -Value 1 | Out-Null

If ((Get-ItemProperty -Name GuardedHost -Path HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl\ForceDumpsDisabled) -eq 1)
{
    Write-Warning "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl\ForceDumpsDisabled::GuardedHosts is currently set to 1. No dumps will be generated."
    Write-Output "Change this value to 0 to allow dumps to be generated"
}

Write-Output 
Write-Output "If you are using a Host Guardian Service in your environment, please configure this hash HGS Policy:"
Write-Output "$($sha256hash)"
