---
title:      "Hyper-V Replica Authorization entries–Windows Server 2012"
description: Hyper-V Replica Authorization entries–Windows Server 2012
author: mattbriggs
ms.author: mabrigg
date:       2012-07-08 04:36:00
ms.date: 07/08/2012
categories: hvr
---
# Hyper-V Replica Authorization entries–Windows Server 2012
While the concept of an “Authorization table” remains the same between Windows Server “8” Beta (as explained in an earlier [**post**](https://blogs.technet.com/b/virtualization/archive/2012/04/09/configure-your-replica-server-to-receive-replication-traffic-from-specific-primary-server-s.aspx)) and Windows Server 2012 RC, we have made some changes in the PowerShell cmdlet and UI surrounding this.

The phrase ‘Security Tag’ in Windows Server 8 Beta is now called **Trust Group.** We believe that the new phrase captures the concept better.

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3225.image_thumb_7C353F5B.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/0160.image_05FAA6D4.png)

Similarly, the PowerShell cmdlets to modify the Authorization entries have changed

  * Add an authorization entry


    
```powershell
    PS C:\Windows\system32> New-VMReplicationAuthorizationEntry -AllowedPrimaryServer "*.woodgrovebank.com" -ReplicaStorageLocation "C:\ClusterStorage\Volume1\WoodgroveBank" -TrustGroup Woodgrove
    
    
     
    
    
    AllowedPS           StorageLoc                              TrustGroup
    
    
    ---------           ----------                              ----------
    
    
    *.woodgrovebank.com C:\ClusterStorage\Volume1\WoodgroveBank Woodgrove
```
  * Get Authorization entries


    
```powershell
    PS C:\Windows\system32> Get-VMReplicationAuthorizationEntry
    
    
     
    
    
    AllowedPS                             StorageLoc                              TrustGroup
    
    
    ---------                             ----------                              ----------
    
    
    *.contoso.com                         C:\ClusterStorage\Volume1\Contoso       Contoso
    
    
    *.fabrikam.com                        C:\ClusterStorage\Volume1\Fabrikam      Fabrikam
    
    
    *.tailspintoys.com                    C:\ClusterStorage\Volume1\TailspinToys  Tailspin
    
    
    *.woodgrovebank.com                   C:\ClusterStorage\Volume1\WoodgroveBank Woodgrove
```
  * Remove authorization entry based on trust group


    
```powershell
    PS C:\Windows\system32> Remove-VMReplicationAuthorizationEntry -TrustGroup Tailspin
    
    
     
    
    
    PS C:\Windows\system32> Get-VMReplicationAuthorizationEntry
    
    
     
    
    
    AllowedPS                             StorageLoc                              TrustGroup
    
    
    ---------                             ----------                              ----------
    
    
    *.contoso.com                         C:\ClusterStorage\Volume1\Contoso       Contoso
    
    
    *.fabrikam.com                        C:\ClusterStorage\Volume1\Fabrikam      Fabrikam
    
    
    *.woodgrovebank.com                   C:\ClusterStorage\Volume1\WoodgroveBank Woodgrove
```