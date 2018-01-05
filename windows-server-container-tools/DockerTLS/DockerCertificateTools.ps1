<#
    .NOTES
        Copyright (c) Microsoft Corporation.  All rights reserved.

        Use of this sample source code is subject to the terms of the Microsoft
        license agreement under which you licensed this sample source code. If
        you did not accept the terms of the license agreement, you are not
        authorized to use this sample source code. For the terms of the license,
        please see the license agreement between you and Microsoft or, if applicable,
        see the LICENSE.RTF on your install media or the root of your tools installation.
        THE SAMPLE SOURCE CODE IS PROVIDED "AS IS", WITH NO WARRANTIES.
    
    .SYNOPSIS
        Provides CmdLets for Installing OpenSSL, Creating a certifcate authority, Creating Server/Client Certificates. 

    .DESCRIPTION
        Provides CmdLets for Installing OpenSSL, Creating a certifcate authority, Creating Server/Client Certificates.
                        
    .EXAMPLE
        . .\DockerCertificateTools.ps1
        Install-OpenSSL
        New-OpenSSLCertAuth
        New-ClientKeyandCert
        New-ServerKeyandCert -serverName "WIN-H3NPPMUM1U7" -serverIPAddresses @("10.0.0.5", "127.0.0.1")               
#>


$Global:PathToOpenSSL = "C:\Program Files\OpenSSL\bin\openssl.exe"
$Global:caPasskey = "pass:p@ssw0rd"

$Global:keyPath = "c:\myDockerKeys\"
$Global:caFile = ($keyPath + "ca.pem")
$Global:caKayFile = ($keyPath + "ca-key.pem")

<#    
    .SYNOPSIS
        Invokes the OpenSSL binary and if a failure occurs throws an exception.

    .DESCRIPTION
        Invokes the OpenSSL binary and if a failure occurs throws an exception.
        Requires:
            $Global:PathToOpenSSL

    .PARAMETER OpenSSLArguments 
        Arguments to the OpenSSL binary.
                        
    .EXAMPLE
       Inovke-OpenSSLCmd -OpenSSLArguments @("version")            
#>
function Invoke-OpenSSLCmd {
Param(
  [Parameter(Mandatory=$True)]
  [String[]] $OpenSSLArguments
)

    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $Global:PathToOpenSSL
    $processInfo.RedirectStandardError = $true
    $processInfo.RedirectStandardOutput = $true
    $processInfo.UseShellExecute = $false
    $processInfo.Arguments = $OpenSSLArguments

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo
    $process.Start() | Out-Null
    $process.WaitForExit()
    $stdout = $process.StandardOutput.ReadToEnd()

    if ($process.ExitCode -ne 0)
    {
        $errorString= $process.StandardError.ReadToEnd()
        Write-Error "OpenSSL Returned Nonzero results: $($process.ExitCode)"
        Write-Error "OpenSSL Error Out:  $errorString"
        throw "OpenSSL Returned Nonzero results: $($process.ExitCode)"
    }
}

<#    
    .NOTES
        The defaults in this command utalize open source and community mantained content.  Please review warnings:
            OpenSSL is software developed by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.openssl.org/)

            The OpenSSL installer is developed by Shining Light Productions who puts forth a lot of effort into developing Win32 OpenSSL. 
            As such, if you find it useful, a time-saver, or helps to solve a frustrating problem, 
            seriously consider giving a donation to continue developing this software.

    .SYNOPSIS
        Downloads and Installs OpenSSL

    .DESCRIPTION
        Downloads and Installs OpenSSL
        Requires:
            $Global:PathToOpenSSL

    .PARAMETER OpenSSLArguments 
        Arguments to the OpenSSL binary.
                        
    .EXAMPLE
       Inovke-OpenSSLCmd -OpenSSLArguments @("version")            
#>
function Install-OpenSSL {
Param(
  [String] $OpenSSLDownloadPath = "https://slproweb.com/download/Win64OpenSSL_Light-1_0_2L.exe",
  [String] $DownloadLocation = $env:TEMP,
  [String] $InstallLocation = $Global:PathToOpenSSL.Replace("bin\openssl.exe", "")
  )
    Write-Host "Installing OpenSSL"
    
    Write-Warning "OpenSSL is software developed by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.openssl.org/)"
    Write-Warning "The OpenSSL installer is developed by Shining Light Productions who puts forth a lot of effort into developing Win32 OpenSSL. As such, if you find it useful, a time-saver, or helps to solve a frustrating problem, seriously consider giving a donation to continue developing this software."
    
    $YesNoChoiceList= New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]
    $YesNoChoiceList.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList "&No"))
    $YesNoChoiceList.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList "&Yes"))
    
    $Continue = [boolean]$Host.ui.PromptForChoice($null, "Would you like to proceeed with installation of OpenSSL?", $YesNoChoiceList, 0)

    if ($Continue)
    {
        New-Item -Path $InstallLocation -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
        wget -uri $OpenSSLDownloadPath -OutFile ($DownloadLocation + "Win64OpenSSL_Light-1_0_2L.exe")
        Start-Process -FilePath ($DownloadLocation + "Win64OpenSSL_Light-1_0_2L.exe") -ArgumentList @("/VERYSILENT", ("/DIR=`"" + $InstallLocation + "`"")) -Wait
    }
}

<#    
    .SYNOPSIS
        Creates a new OpenSSL Certifcate Authority.

    .DESCRIPTION
        Creates a new OpenSSL Certifcate Authority.
        Requires:
            $Global:keyPath
            $Global:caPasskey
            $Global:caKayFile
                        
    .EXAMPLE
       New-OpenSSLCertAuth           
#>
function New-OpenSSLCertAuth{
    Write-Host "Creating Certificate Authority Keys"

    if (Get-Item $Global:keyPath -ErrorAction SilentlyContinue)
    {
        Write-Error "Key directory exists"
        throw "Key directory exisits"
    }
    else
    {
        New-Item -p $Global:keyPath -ItemType Directory | Out-Null
    }

    Write-Host "-Creating CA private key"
    #generate CA private keys
    $openSSLCmd = @("genrsa", "-aes256", "-passout", $Global:caPasskey, "-out", $Global:caKayFile,  "4096" )
    Invoke-OpenSSLCmd -OpenSSLArguments $openSSLCmd

    Write-Host "-Creating CA public key"
    #generate CA public keys
    $subLine = "/C=US/ST=Washington/L=Redmond/O=./OU=."   #CommonName?
    $openSSLCmd = @("req", "-subj", $subLine, "-new", "-x509", "-days", "365", "-passin", $Global:caPasskey, "-key", $Global:caKayFile, "-sha256", "-out", $Global:caFile)
    Invoke-OpenSSLCmd -OpenSSLArguments $openSSLCmd

    Write-Host "-Certificate Authority Keys Generated"
}

<#    
    .SYNOPSIS
        Creates a new Server Key and Certifcate

    .DESCRIPTION
        Downloads and Installs OpenSSL
        Requires:
            $Global:keyPath
            $Global:caPasskey
            $Global:caKayFile

    .PARAMETER serverName 
        The Server Name for the Key
    
    .PARAMETER serverIPAddresses 
        Ip Addresses of the Server, these will be used as Subject Alternate Names

    .PARAMETER serverKeyFile 
        The Key File that will be geneated, defautls to the key path and the servers name _"server-key.pem"

    .PARAMETER serverCSRFile 
        The cerficate request file that will be geneated, defautls to the key path and the servers name _"server.csr"  this will be deleted.

    .PARAMETER serverCert 
        The cerficate file that will be geneated, defautls to the key path and the servers name _"server-cert.pem"
                                
    .EXAMPLE
       New-ServerKeyandCert -serverName "WIN-H3NPPMUM1U7" -serverIPAddresses @("10.0.0.5", "127.0.0.1")           
#>
function New-ServerKeyandCert {
Param(
  [String]
  $serverName = $env:COMPUTERNAME,

  [Parameter(Mandatory=$True)]
  [String[]]
  $serverIPAddresses,

  [String]
  $serverKeyFile = ($Global:keyPath + $serverName + "_server-key.pem"),
  
  [String]
  $serverCSRFile = ($Global:keyPath + $serverName + "_server.csr"),
  
  [String]
  $serverCert = ($Global:keyPath + $serverName + "_server-cert.pem"),

  [String]
  $openSSLExtFile = ($Global:keyPath + "extfile.cnf")
)
    Write-Host "Creating Server Key and Certifcate"

    Write-Host "-Verifying CA Keys"
    if (!(Get-Item $Global:caFile -ErrorAction SilentlyContinue))
    {
        Write-Error "CA Public Key Not Found"
        throw "CA Public Key Not Found"
    }

    if (!(Get-Item $Global:caKayFile -ErrorAction SilentlyContinue))
    {
        Write-Error "CA Private Key Not Found"
        throw "CA Private Key Not Found"
    }

    Write-Host "-Creating Server key"
    #create a server key
    $openSSLCmd =   @("genrsa", "-out", $serverKeyFile, "4096")
    Invoke-OpenSSLCmd -OpenSSLArguments $openSSLCmd

    Write-Host "-Creating Server certificate request"
    #create certificate signing request
    $subLine = ("/CN=" + $serverName + "/")

    $openSSLCmd =  @("req", "-subj", $subLine, "-sha256", "-new", "-key", $serverKeyFile, "-out",  $serverCSRFile )
    Invoke-OpenSSLCmd -OpenSSLArguments $openSSLCmd

    Write-Host "-Creating extended key use extention file"
    #created a extendedkeyusage file and sign the public key with our CA
    "subjectAltName = " | Out-File -FilePath $openSSLExtFile -NoNewline -Encoding ascii

    for ($c = 0; $c -lt $serverIPAddresses.count; $c++)
    {
        ("IP:" + $serverIPAddresses[$c]) | Out-File -FilePath $openSSLExtFile -Append -NoNewline -Encoding ascii
        if (($c + 1) -lt $serverIPAddresses.count) { "," | Out-File -FilePath $openSSLExtFile -Append -NoNewline -Encoding ascii}
    }

    Write-Host "-Signing Server request and generating certificate"
    #sign the public key with our CA
    $openSSLCmd =  @("x509", "-req", "-days", "365", "-passin", $Global:caPasskey, "-sha256", "-in",  $serverCSRFile, "-CA", $Global:caFile, "-CAkey", $Global:caKayFile, "-CAcreateserial",  "-out", $serverCert, "-extfile", $openSSLExtFile)
    Invoke-OpenSSLCmd -OpenSSLArguments $openSSLCmd

    Write-Host "-Cleaning up extention file and cerficate request file"
    #Remove Client ExtFile
    Remove-Item $openSSLExtFile
    Remove-Item $serverCSRFile

    Write-Host "-Done Creating Server Certifcates!"
}

<#    
    .SYNOPSIS
        Creates a new client key and certifcate

    .DESCRIPTION
        Downloads and Installs OpenSSL
        Requires:
            $Global:keyPath
            $Global:caPasskey
            $Global:caKayFile

    .PARAMETER clientKeyFile 
        The Key File that will be geneated, defautls to the key path and "key.pem"

    .PARAMETER clientCSRFile 
        The cerficate request file that will be geneated, defautls to the key path and "client.csr"  this will be deleted.

    .PARAMETER clientCert 
        The cerficate file that will be geneated, defautls to the key path "cert.pem"
                                
    .EXAMPLE
       New-ClientKeyandCert      
#>
function New-ClientKeyandCert {
Param(
  [String]
   $clientKeyFile = ($Global:keyPath + "key.pem"),
  
  [String]
  $clientCSRFile = ($Global:keyPath + "client.csr"),
  
  [String]
  $clientCert = ($Global:keyPath + "cert.pem"),
    
  [String]
  $openSSLExtFile = ($Global:keyPath + "extfile.cnf"),

  [String]
  $pfxFile = ($Global:keyPath + "key.pfx")
)
    Write-Host "Creating Client Key and Certifcate"

    Write-Host "-Verifying CA Keys"
    if (!(Get-Item $Global:caFile -ErrorAction SilentlyContinue))
    {
        Write-Error "CA Public Key Not Found"
        throw "CA Public Key Not Found"
    }

    if (!(Get-Item $Global:caKayFile -ErrorAction SilentlyContinue))
    {
        Write-Error "CA Private Key Not Found"
        throw "CA Private Key Not Found"
    }

    Write-Host "-Creating client key"
    #create a client key
    $openSSLCmd = @("genrsa", "-passout", $Global:caPasskey, "-out", $clientKeyFile, "4096")
    Invoke-OpenSSLCmd -OpenSSLArguments $openSSLCmd

    Write-Host "-Creating cient certificate request"
    #create certificate signing request
    $openSSLCmd =  @("req", "-subj", "/CN=client", "-new",  "-passin", $Global:caPasskey, "-key", $clientKeyFile, "-out",  $clientCSRFile)
    Invoke-OpenSSLCmd -OpenSSLArguments $openSSLCmd

    Write-Host "-Creating extended key use extention file"
    #created a extendedkeyusage file and sign the public key with our CA
    "extendedKeyUsage = clientAuth" | Out-File -FilePath $openSSLExtFile -NoNewline -Encoding ascii

    Write-Host "-Signing client request and generating certificate"
    $openSSLCmd =  @("x509", "-req", "-days", "365", "-passin", $Global:caPasskey, "-sha256", "-in",  $clientCSRFile, "-CA", $Global:caFile, "-CAkey", $Global:caKayFile, "-CAcreateserial",  "-out", $clientCert, "-extfile", $openSSLExtFile)
    Invoke-OpenSSLCmd -OpenSSLArguments $openSSLCmd

    Write-Host "-Creating PFX file for Windows"
    $openSSLCmd = @("pkcs12", "-export", "-inkey", $clientKeyFile, "-in", $clientCert, "-out", $pfxFile, "-password", $Global:caPasskey)
    Invoke-OpenSSLCmd -OpenSSLArguments $openSSLCmd

    Write-Host "-Clening up extention file and cerficate request file"
    #Remove Client ExtFile
    Remove-Item $openSSLExtFile
    Remove-Item $clientCSRFile

    Write-Host "-Done Creating Client Certifcates!"
}
