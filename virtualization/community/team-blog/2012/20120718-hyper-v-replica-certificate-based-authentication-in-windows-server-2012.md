---
layout:     post
title:      "Hyper-V Replica–Certificate Based Authentication in Windows Server 2012"
date:       2012-07-18 13:18:00
categories: hvr
---
This post discusses a subtle change in the certificate workflow for Hyper-V Replica in Windows Server 2012 Release Candidate build and beyond.

**Note** :

  * The pre-requisites certificate based authentication remains unchanged (as seen in an earlier post “[ **Hyper-V Replica - Prerequisites for certificate based deployments**](http://blogs.technet.com/b/virtualization/archive/2012/03/13/hyper-v-replica-certificate-requirements.aspx)”)

  * Only the workflow for picking the certificate has changed – all other functionality (such as handling seamless replication during VM migration) and requirements (certificates, firewall rules) remain unchanged




**Windows Server “8” Beta Workflow:**

  * A post explaining the workflow in Beta was published [earlier](http://blogs.technet.com/b/virtualization/archive/2012/04/23/certificate-based-authentication-and-powershell.aspx). In summary, Hyper-V administrators picked a certificate from the **Trusted Root Certification Authorities** store of the Local Machine for certificate based authentication.

  * The certificate thumbprint was used to find an [appropriate](http://blogs.technet.com/b/virtualization/archive/2012/03/13/hyper-v-replica-certificate-requirements.aspx) certificate in the **Personal** store of the Local Machine.

  * While the functionality was well received, we also got feedback around two aspects in the workflow:
    * **Picking root** **certificates:** Many users felt that this was not intuitive and indicated that they were more comfortable dealing with Personal store certificates. Users wanted and expected the product to use the certificate which they picked.

    * **Error conditions** : In certain scenarios, the errors which stemmed from picking the root certificate did not help users debug the problem. As Hyper-V Replica attempted to use a certificate which was different from the user input, root-causing the error proved to be cumbersome.




**Summary of change:**

  * We listened to your feedback and introduced a minor change in the workflow which now requires you to pick the Personal store certificate.

  * This post discusses the new workflow by using a SAN certificate as an example. The same steps can be used for other supported certificates.




**Step #1: Enabling Replication on a Replica Cluster**

  * Let’s consider a clustered deployment on which a Hyper-V Replica Broker (called **RepBroker** ) has been created.

  * The administrator wants to allow the cluster to receive replication traffic and clicks on the **Replication Settings** of RepBroker. On a fresh cluster where the certificate have not been installed, the following error message is seen on clicking the **Select Certificate … **button.




> [![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1121.image_thumb_320CDE88.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6646.image_2E000005.png)

  * Using the information from the error message (and a little help from [this](http://blogs.technet.com/b/virtualization/archive/2012/07/10/requesting-hyper-v-replica-certificates-from-an-enterprise-ca.aspx) post ![Smile](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3426.wlEmoticon-smile_661865C0.png)), the administrator creates and installs a SAN certificate which meets the requirement.



  * Now, on clicking the **Select Certificate … **button, a **filtered list** (which matches the **[certificate pre-requisites](http://blogs.technet.com/b/virtualization/archive/2012/03/13/hyper-v-replica-certificate-requirements.aspx)) ** of certificates from the Personal Store of the Local Machine is shown:




> [![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4478.image_thumb_695439A9.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6064.image_65475B26.png)

**(OR)** To achieve the same from PowerShell, the following cmdlets can be used

  * Get a list of certificates from the Personal store and note the thumbprint



    
    
    PS C:\Windows\system32> cd cert:
    
    
    PS Cert:\> cd .\\LocalMachine\My
    
    
    PS Cert:\LocalMachine\My> dir
    
    
     
    
    
    Directory: Microsoft.PowerShell.Security\Certificate::LocalMachine\My
    
    
     
    
    
    Thumbprint                                Subject
    
    
    ----------                                -------
    
    
    0662D576C8726DBAD1CE029AFC20EB502990ADC2  CN=SANCert

 

    * To enable the cluster to receive replication traffic from **all authenticated servers** by using **certificate based authentication,** on port **4000** **,** the administrator should issue the following cmdlet:



    
    
     
    
    
    PS Cert:\LocalMachine\My> Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Certificate -CertificateAuthenticationPort 4000 -CertificateThumbprint "0662D576C8726DBAD1CE029AFC20EB502990ADC2" -ReplicationAllowedFromAnyServer $true -DefaultStorageLocation "C:\ClusterStorage\Volume1\Hyper-V Replica"

 

**Step #2: Enabling Replication on a VM**

  * On a fresh primary cluster, if the administrator tries to enable replication using certificate based authentication before configuring the certificates, he is shown an error message:



> [![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1055.image_thumb_2E90DE4F.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3000.image_2A83FFCC.png)

  * The administrator creates and installs a SAN certificate by following the same guidance as the replica server



  * When the administrator now clicks on the **Select Certificate … **button, a **filtered list** of certificates from the Personal Store of the Local Machine which matches the [certificate pre-requisites](http://blogs.technet.com/b/virtualization/archive/2012/03/13/hyper-v-replica-certificate-requirements.aspx).




> [![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7318.image_thumb_18CC1754.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3527.image_791AACDA.png)

**(OR)** To achieve the above using PowerShell, the administrator issues the following cmdlets:

  * Get certificate thumbprint which can be used to enable replication on a VM


    
    
    PS C:\Windows\system32> cd cert:
    
    
    PS Cert:\> cd .\\LocalMachine\My
    
    
    PS Cert:\LocalMachine\My> dir
    
    
     
    
    
    Directory: Microsoft.PowerShell.Security\Certificate::LocalMachine\My
    
    
     
    
    
     
    
    
    Thumbprint                                Subject
    
    
    ----------                                -------
    
    
    DF2383991B18DBC45D10F17A7AE39DED6AA8C7AF  CN=PrimarySAN

  * To enable replication on a VM (called SQLDB) to the configured replica cluster, the administrator should issue the following cmdlet.


    
    
     
    
    
    PS Cert:\LocalMachine\My> Enable-VMReplication -VMName "SQLDB" -AuthenticationType Certificate -CertificateThumbprint "DF2383991B18DBC45D10F17A7AE39DED6AA8C7AF" -ReplicaServerName "repbroker.FRTEST.nttest.microsoft.com" -ReplicaServerPort 4000

  * To complete initial replication over the network, the administrator should issue the following cmdlet


    
    
     
    
    
    PS Cert:\LocalMachine\My> Start-VMInitialReplication -VMName "SQLDB"
