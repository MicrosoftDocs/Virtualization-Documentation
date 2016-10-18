# This dockerfile utilizes components licensed by their respective owners/authors.

# This builds on top of the IIS sample
FROM iis

RUN powershell.exe -Command " \
    Import-Module IISAdministration; \
    $cert = New-SelfSignedCertificate -DnsName demo.contoso.com -CertStoreLocation cert:\LocalMachine\My; \
    $certHash = $cert.GetCertHash(); \
    $sm = Get-IISServerManager; \
    $sm.Sites[\"Default Web Site\"].Bindings.Add(\"*:443:\", $certHash, \"My\", \"0\"); \
    $sm.CommitChanges();"
