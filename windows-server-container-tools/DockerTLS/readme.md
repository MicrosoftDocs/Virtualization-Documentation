---
author: taylorb-microsoft
---

# Protect the Docker daemon socket on Windows
This is an initial set of PowerShell scripts that utilize OpenSSL to automate creating self signed keys and certificates for Docker on Windows.  These scripts follow the directions at https://docs.docker.com/engine/security/https/.


## Example Workflow:
On your client machine run:
```powershell
  . .\DockerCertificateTools.ps1
  Install-OpenSSL
  New-OpenSSLCertAuth
  New-ClientKeyandCert
```

Then either run:
```powershell 
New-ServerKeyandCert -serverName "WIN-H3NPPMUM1U7" -serverIPAddresses @("10.0.0.5", "127.0.0.1")
``` 
Where you provide the container hosts name/IP Address and then copy the server-cert.pem/server-key.pem and ca.pem file to the c:\programdata\docker\certs.d directory and create a tag.txt file in c:\programdata\docker directory.

or
```powershell 
.\CreateAndUpdateDockerCertsInVMs.ps1 -VmName "VM1" -GuestUserName "administrator" -GuestPassword (ConvertTo-SecureString -String "p@ssw0rd" -AsPlainText -Force)
``` 
Which uses the Hyper-V intergration components to do all the stuff above for you.  As currently coded this only works on a local machine (remote support could be added) and does require the PS session to be running as administrator.
