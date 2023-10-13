---
title:      "Hyper-V Replica Certificate Based Authentication - makecert"
author: sethmanheim
ms.author: mabrigg
description: Hyper-V Replica Certificate Based Authentication - makecert
ms.date: 04/13/2013
date:       2013-04-13 03:01:38
categories: hvr
---
# Hyper-V Replica Certificate Based Authentication - makecert

We have had a number of queries on how to enable replication using certificates created from makecert. Though the Understanding and Troubleshooting guide for Hyper-V Replica discusses this aspect, I am posting a separate article on this. The below steps are applicable for a simple lab deployment consisting of two standalone servers – **PrimaryServer.domain.com** and **ReplicaServer.domain.com**. This can be easily extended to clustered deployments with the Hyper-V Replica Broker. 

Makecert is a certificate creation tool which generates certificates for testing purpose. Information on makecert is available [here](/previous-versions/dotnet/netframework-4.0/bfsktky3(v=vs.100)).

1\. Copy the **_makecert.exe_** tool to your primary server

2\. Run the following command from an **elevated command prompt** , on the primary server. This command creates a self-signed root authority certificate. The command also installs a test certificate in the root store of the local machine and is saved as a file locally

 makecert -pe -n "CN=MyTestRootCA" -ss root -sr LocalMachine -sky signature -r "MyTestRootCA.cer" 

3\. Run the following command couple of times, from an elevated command prompt to create new certificate(s) signed by the test root authority certificate
    
    
makecert -pe -n "CN=\<FQDN\>" -ss my -sr LocalMachine -sky exchange -eku 1.3.6.1.5.5.7.3.1,1.3.6.1.5.5.7.3.2 -in "MyTestRootCA" -is root -ir LocalMachine -sp "Microsoft RSA SChannel Cryptographic Provider" -sy 12 \<MachineName\>.cer 

Each time:

  * Replace < **FQDN** > with FQDN of primary, replica server(s) and Hyper-V Replica broker (if required, in a clustered deployment). 


  * Replace \<MachineName\>.cer with any name 



The command installs a test certificate in the Personal store of the local machine and is saved as a file locally. The certificate can be used for both Client and Server authentication 

4\. The certificates can be viewed by mmc->File->Add/Remove Snap in…->Certificates->Add->”Computer Account”->Next->Finish->Ok

You will find the Personal certificate (with the machine names) and the Root certificate (MyTestRootCA) in the highlighted folders:

<!-- [![You will find the Personal certificate (with the machine names) and the Root certificate (MyTestRootCA) in the highlighted folders](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4278.clip_image002_thumb_69DBCDF6.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6052.clip_image002_3F00D933.jpg)-->

5\. Export the replica server certificate **with the private key**. 

<!--[![Export the replica server certificate](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1464.image_thumb_63447B8B.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5707.image_18BAAD00.png) -->

<!--[![with the private key](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6505.image38_thumb_022010CC.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5226.image38_105BF90B.png) | [![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5460.image_thumb_008831E2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6278.image_2349699F.png)  -->

  
6\. Copy MyTestRootCA.cer and the above exported certificate (RecoveryServer.pfx) to the Replica server.

7\. Run the following command from an elevated prompt in ReplicaServer.domain.com
    
    
certutil -addstore -f Root "MyTestRootCA.cer" 

8\. Open the certificate mmc in ReplicaServer.domain.com and import the certificate (RecoveryServer.pfx) in the Personal store of the server. Provide the pfx file and password as input:

<!-- [![Provide the pfx file and password as input](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1200.image_thumb_4341FFB3.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7282.image_388217AD.png) -->

9\. In a clustered deployment, two certificates are required on each server:

  * Certificate with the subject name set to the server’s FQDN
  * Certificate with the subject name set to the Hyper-V Replica Broker’s FQDN. This is required as the Hyper-V Replica Broker is Highly Available and can migrate from one server to another. 



10\. By default, a certificate revocation check is mandatory and Self-Signed Certificates don’t support Revocation checks. To work around it, modify the following registry key on **Primary, Replica Servers**
    
 reg add  "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\Replication" /v DisableCertRevocationCheck /d 1 /t REG_DWORD /f
