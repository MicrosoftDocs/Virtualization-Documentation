---
layout:     post
title:      "Requesting Hyper-V Replica certificates from a CA"
date:       2012-07-02 04:59:00
categories: hvr
---
The certificate requirements for Hyper-V Replica were discussed [earlier](/b/virtualization/archive/2012/03/13/hyper-v-replica-certificate-requirements.aspx) – this post provides details on how to request a certificate from a Certification Authority (CA), which can then be used for Hyper-V Replica for certificate based authentication.

**Step #1: Create an INF file**

Copy-paste the text below to a .inf file which specifies the settings for the certificate request. Modify the **Subject** attribute to the server name (FQDN if applicable).
    
    
    [Version] 
    
    
    Signature="$Windows NT$"
    
    
    [NewRequest] 
    
    
    Subject = "CN=SERVER.CONTOSO.COM"   
    
    
    Exportable = TRUE                   ; Private key is exportable 
    
    
    KeyLength = 2048                    ; Common key sizes: 512, 1024, 2048, 4096, 8192, 16384 
    
    
    KeySpec = 1                         ; AT_KEYEXCHANGE 
    
    
    KeyUsage = 0xA0                     ; Digital Signature, Key Encipherment 
    
    
    MachineKeySet = True                ; The key belongs to the local computer account 
    
    
    ProviderName = "Microsoft RSA SChannel Cryptographic Provider" 
    
    
    ProviderType = 12 
    
    
    RequestType = CMC
    
    
    [EnhancedKeyUsageExtension]
    
    
    OID=1.3.6.1.5.5.7.3.1 ;Server Authentication
    
    
    OID=1.3.6.1.5.5.7.3.2 ;Client Authentication

Save the above file as **HVR.inf**.

**Step #2: Create a request**

Issue the following command from an **elevated** command prompt, to create a certificate request from an .inf file.
    
    
    certreq –new HVR.inf HVR.req

A request file with the name **HVR.req** is created in the same directory.

**Step #3: Submit the request**

There are three possible outcomes here:

  * **Submit the certificate request to an internal CA**
    * Submit the certificate request using the following command 


    
    
    certreq –submit –config “corpca1.fabrikam.com\Corporate Policy CA1” HVR.req HVR.cer

    * The – **config** switch can be used (with certreq) to direct the request to a specific CA.  In the above command, this is “ _corpca1.fabrikam.com\Corporate Policy CA1”._
    * Ensure that RPC traffic is allowed between the computer requesting the certificate and the CA. 
    * It is assumed that the root CA certificate is already installed in the Trusted Root Certification Authorities store of the local computer 
  * **(OR) Submit the certificate request to an external CA**
    * Many external CAs take a Certificate Signing Request (CSR) block which contains information about your organization name, domain name etc. To get the CSR block from the req file, issue the following command: 



> 
>     certutil -encode HVR.req HVR.csr

    * Open the csr file in notepad and send the contents to your external CA through the preferred medium (mail/web page upload) as dictated by your CA. A sample csr file (which I have manually edited) would look as follows:




> 
>     -----BEGIN CERTIFICATE-----
>     
>     
>     LS0tLS1CRUdJTiBORVcgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tDQpNSUlETXpD
>     
>     
>     Q0Fwd0NBUUF3TURFdU1Dd0dBMVVFQXd3bGNISjJhV3BoZVhKak1pNW1ZWEpsWVhO
>     
>     
>     VElGSUNBVEUgTURFdU1Dd0dBMVVFQXd3bGNISjJhV3BoZVhKak1pNW1ZWEpsWVhO
>     
>     
>     URFdU1Dd0dBMVVFQXdRVcgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tDQpNSUlETW
>     
>     
>     MVVFQXdRVcgQ0VSVElGSUNBVEUQ0VSVElGSUNBVEUgURFdU1Dd0dBMVVFQXd3bGN
>     
>     
>     RSBSRVFVRVNULS0tLS0NCg==
>     
>     
>     -----END CERTIFICATE-----

**Step #4: Finishing up…**

Once the certificate is issued, issue the following command to install the certificate
    
    
    certreq -accept HVR.cer

This command imports the certificate into the appropriate store.

**Notes:**

  * In a clustered configuration, ensure that the certificate with the Hyper-V Replica Broker’s CAP name is installed on all the nodes of the cluster. 
  * **Wildcard certificate:** If you wish to deploy wildcard certificates, modify the subject attribute in the INF file to indicate the wildcard (eg: *.department.contoso.com) and follow the same steps as mentioned earlier 
  * **SAN certificate:** If you wish to deploy Subject Alternate Name certificates, use the following INF file and follow the same steps as mentioned earlier. 


    
    
    [Version] 
    
    
           Signature="$Windows NT$"
    
    
     
    
    
           [NewRequest] 
    
    
           Subject = "CN=dc.contoso.com"   
    
    
           Exportable = TRUE                   ; Private key is exportable 
    
    
           KeyLength = 2048                    ; Common key sizes: 512, 1024, 2048, 4096, 8192, 16384 
    
    
           KeySpec = 1                         ; AT_KEYEXCHANGE 
    
    
           KeyUsage = 0xA0                     ; Digital Signature, Key Encipherment 
    
    
           MachineKeySet = True                ; The key belongs to the local computer account 
    
    
           ProviderName = "Microsoft RSA SChannel Cryptographic Provider" 
    
    
           ProviderType = 12
    
    
           RequestType = CMC
    
    
     
    
    
           [RequestAttributes]
    
    
           SAN="dns=server1.dept.contoso.com&dns=server2.dept.contoso.com&dns=hvrbroker.dept.contoso.com"    ;Include the Hyper-V Replica Broker CAP name 
    
    
     
    
    
           [EnhancedKeyUsageExtension] 
    
    
           OID=1.3.6.1.5.5.7.3.1 ;Server Authentication
    
    
           OID=1.3.6.1.5.5.7.3.2 ;Client Authentication

  * After the certificate is installed, run the following command from the command prompt on both the primary and replica server: 


    
    
    certutil –store my 

At least one of the certificates in your output should resemble the following sample output such that **the Encryption test (not just Signature)** has passed **.**
    
    
     
    
    
    ==============================Certificate 1 =====================================================
    
    
    Serial Number: 6c028cf0d47c0db8490dbd18191eaeb1
    
    
    Issuer: CN=corp-DC1-CA, DC=corp, DC=contoso, DC=com
    
    
    NotBefore: 2/7/2012 9:39 PM
    
    
    NotAfter: 12/31/2039 3:59 PM
    
    
    Subject: CN=CLIENT1.corp.contoso.com
    
    
    Non-root Certificate
    
    
    Cert Hash(sha1): ba 20 b0 1a c1 dd d8 5c c9 4a 73 0f 61 e2 f0 ca a5 8d ed 6d
    
    
    Key Container = 6199522e-cbe4-4a69-b27d-edcbdf06911e
    
    
    Unique container name: b2c457fabbb5acb7fbac1c3585f8c079_2176a3a0-cd09-417b-87d7-826e858f5461
    
    
    Provider = Microsoft RSA SChannel Cryptographic Provider
    
    
    Encryption test passed
    
    
    ================================================================================================
    
    
     
