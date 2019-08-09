---
title:      "Upgrading to Windows Server 2012 R2 with Hyper-V Replica"
date:       2013-12-02 07:46:00
categories: hvr
---
The TechNet article [**https://technet.microsoft.com/library/dn486799.aspx**](https://technet.microsoft.com/library/dn486799.aspx "https://technet.microsoft.com/library/dn486799.aspx") provides detailed guidance on migrating Hyper-V VMs from a Windows Server 2012 deployment to a Windows Server 2012 R2 deployment.

[ **https://technet.microsoft.com/library/dn486792.aspx**](https://technet.microsoft.com/library/dn486792.aspx "https://technet.microsoft.com/library/dn486792.aspx") calls out the various VM migration techniques which are available as part of upgrading your deployment. The section titled “Hyper-V Replica” calls out further guidance for deployments which have replicating virtual machines.

At a very high level, if you have a Windows Server 2012 setup containing replicating VMs, we recommend that you use the cross version live migration feature to migrate your replica VMs first. This is followed by fix-ups in the primary replicating VM (eg: changing replica server name). Once replication is back on track, you can migrate your primary VMs from a Windows Server 2012 server to a Windows Server 2012 R2 server without any VM downtime. The authorization table in the replica server may require to be updated once the primary VM migration is complete.

The above approach does not require you to re-IR your VMs, ensures zero downtime for your production VMs and gives you the flexibility to stagger the upgrade process on your replica and primary servers.
