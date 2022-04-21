---
title:      "Application consistent recovery points with Windows Server 2008/2003 guest OS"
author: mattbriggs
ms.author: mabrigg
ms.date: 05/19/2014
date:       2014-05-19 22:00:00
categories: hvr
description: This article discusses errors in Hyper-V Replica.
---
# Errors in Hyper-V Replica

I recently had a conversation with a customer around a very interesting problem, and the insights that were gained there are worth sharing. The issue was about VSS errors popping up in the guest event viewer while Hyper-V Replica reported the successful creation of application-consistent (VSS-based) recovery points.

#### Deployment details

The customer had the following setup that was throwing errors:

  1. Primary site:   Hyper-V Cluster with Windows Server 2012 R2 
  2. Replica site:   Hyper-V Cluster with Windows Server 2012 R2 
  3. Virtual machines:   SQL server instances with SQL Server 2012 SP1, SQL Server 2005, and SQL Server 2008



At the time of enabling replication, the customer selected the option to create additional recovery points and have the “Volume Shadow Copy Service (VSS) snapshot frequency” as 1 hour. This means that every hour the VSS writer of the guest OS would be invoked to take an _application-consistent snapshot_. 

#### Symptoms

With this configuration, there was a contradiction in the output – the guest event viewer showed errors/failure during the VSS process, while the Replica VM showed application-consistent points in the recovery history. 

Here is an example of the error registered in the guest:
    
```markdown
SQLVM: Loc=SignalAbort. Desc=Client initiates abort. ErrorCode=(0). Process=2644. Thread=7212. Client. Instance=. VD=Global\*******
    
    
     
    
    
BACKUP failed to complete the command BACKUP DATABASE model. Check the backup application log for detailed messages.
    
    
     
    
    
BackupVirtualDeviceFile::SendFileInfoBegin:  failure on backup device '{********-63**-49**-BA**-5DB6********}1'. Operating system error 995(error not found).
```

#### Root cause and Dealing with the errors

The big question was:  _Why was Hyper-V Replica showing application-consistent recovery points if there are failures?_

The behavior seen by the customer is a _benign error_ caused because of the interaction between Hyper-V and VSS, **especially for older versions of the guest OS**. Details about this can be found in the KB article here: <https://support.microsoft.com/kb/2952783>

The Hyper-V requestor explicitly stops the VSS operation right after the _OnThaw_ phase. While this ensures application-consistency of the writes going to the disk, it also results in the VSS errors being logged. Meanwhile, Hyper-V returns the consistency correctly to Hyper-V Replica, which in turn makes sure that the recovery side shows application-consistent points.

A great way to validate whether the recovery point is application-consistent or not is to do a test failover on that recovery point. After the VM has booted up, the event viewer logs will have events pertaining to a rollback - and this would mean that the point is not application consistent. 

#### Key Takeaways

  1. All in all, you can rest assured that in the case of VMs with older operating systems, Hyper-V Replica is correctly taking an application-consistent snapshot of the virtual machine. 
  2. Although there are errors seen in the guest, they are benign and having a recovery history with application-consistent points is an expected behavior. 


