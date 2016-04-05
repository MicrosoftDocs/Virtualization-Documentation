# Sample - IIS with HTTPS
This builds another layer on top of the sample [iis-10.0](../iis-10.0/readme.md), which installs Internet Information Server on a Windows Server Core container. It adds a self-signed certificate and enables HTTPS for the default site.

## Steps to Build and Run
1. First, build the "iis" image (see [iis-10.0 sample readme](..\iis-10.0\readme.md))
2. Next, build this image: 
```none
docker build -t iis-contoso-https .
```
This will create a self-signed SSL certificate for demo.contoso.com, then bind it to the default website on port 443
3. Start the container as in iis-10.0, but add an additional -l 443:443 to forward the HTTPS port from the host
```none
docker run -it -p 80:80 -p 443:443 iis-contoso-https cmd
```
4. Access the SSL site at `https://(host IP):443`

## Known Issues & Warnings
### Workaround needed on Windows Server 2016 Technical Preview 5 (full install)
Both the Windows Server Container host and container should be running Windows Server Core. If the host is running Windows Server 2016 Technical Preview 5 as a full install instead of Windows Server Core, then use this workaround to avoid a bugcheck.

1. Download and install [SubInACL.exe](https://www.microsoft.com/en-us/download/details.aspx?id=23510)
2. Run this script in a Command Prompt (cmd.exe, not Windows PowerShell)
```none
"C:\Program Files (x86)\Windows Resource Kits\Tools\subinacl.exe" /subkeyreg "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\OSConfig" /setowner=Administrators
"C:\Program Files (x86)\Windows Resource Kits\Tools\subinacl.exe" /subkeyreg "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\OSConfig" /grant=Administrators=f
reg.exe ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\OSConfig" /v "Security Packages" /t REG_MULTI_SZ /d "kerberos\0msv1_0\0tspkg\0pku2u\0wdigest\0schannel\0cloudAP"
```
3. Reboot

### Keep Certificates Secure
Container images with private key certificates, such as this one, should not be redistributed for security reasons. Someone else could use the certificate to spoof the identity of the hosted website. 