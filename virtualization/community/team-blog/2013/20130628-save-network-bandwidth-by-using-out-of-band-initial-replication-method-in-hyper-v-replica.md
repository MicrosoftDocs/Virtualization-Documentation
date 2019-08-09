---
title:      "Save network bandwidth by using Out-of-Band Initial Replication method in Hyper-V Replica"
date:       2013-06-28 07:41:00
categories: hvr
---
In our recent conversation with customers about Hyper-V Replica, the questions that came up from a few customers was –

  * Is there a way to perform the Initial Replication (IR) for VMs without stressing our organizations internet bandwidth?
  * Initial replication of our VMs take weeks to complete, is there a faster way to get the data across to our secondary datacenter?



The answer is “ **Yes** ”. Hyper-V Replica supports an option where you can transport the initial copy of your VM to the Replica site using an external storage medium - like a USB drive. This method of seeding the Replica site is known is Out-of-Band Initial Replication (OOB IR) and is the focus of this blog post.

OOB IR is especially helpful if you have a large amounts of data to be replicated and the datacenters are not connected using a very high speed network. As an example, it will take around 20 days to complete initial replication on 2 TB of data if the network link between the Primary site and Replica site is 10 Mbps.

The following steps walk you through the process of using OOB IR.  

### Steps to take on the Primary Site

  1. Connect your external storage medium (e.g. USB drive) to the Hyper-V Host where the VM is running. In the example below the USB drive on the Hyper-V Host is mounted under the drive letter F:\\.  If your Primary Server is a
    * **Standalone Hyper-V Host** \- ensure that you connect the external media directly to the Hyper V Host on which the virtual machine is hosted.
    * **Failover Hyper-V Cluster** – ensure you connect the external medial directly to the **Owner Node** for the VM. The owner node for a VM can be identified through the Failover Cluster Manager MMC. For e.g. In the below screen shot the Owner Node for the SQLDB_MyApplication VM is HV-CLUS-01
    * [![Img4](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1145.Img4_thumb_5DC1ADC3.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6471.Img4_452F7FC2.jpg)
  2. Initiate replication wizard by right-clicking on the VM and selecting ‘ **Enable Replication ’**
  3. Go through the wizard till you reach the ‘ **Choose Initial Replication Method ’** screen.
  4. This page allows you to choose how you want to transfer the initial copy of the virtual machine to the Replica site. The 3 options here are:
    * Send initial copy over the network
    * Send initial copy using external media
    * Use an existing virtual machine on the Replica server as the initial copy.
    * [![Img1](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7343.Img1_thumb_6F372FFD.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1007.Img1_7D73183C.jpg)
  5. Choose the second option - ‘ **Send initial copy using external media** ’ – and specify a location where the initial copy should be stored. In our example, we have chosen a location in the USB drive.
  6. On the summary screen click **Finish**
  7. The virtual machine will be enabled for replication and initial replica will be created in the folder mentioned in step 5. A placeholder VM is created on the Replica site as a part of the enable replication process.
    * [![Img2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2783.Img2_thumb_649BF34C.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5460.Img2_60FB47BE.jpg)
  8. Once ‘ **Sending Initial Replica** ’ finishes for all the replication-enabled VMs, the external storage medium can be shipped to the Replica site.



From this point onwards the changes that happen to the VM will be replicated over and will be applied on to the placeholder VM on the Replica site. These changes will be merged with the OOB IR data once it is imported at the replica site.  

**Note** : For security of the data, it is recommended that the external storage media be encrypted using encryption technologies like BitLocker.

The same steps can be achieved using PowerShell:

First enable replication for the VM using the following command-let
    
    
    Enable-VMReplication –VMName SQLDB_MyApplication –ReplicaServerName ReplicaServer.Contoso.com –ReplicaServerPort 80 –AuthenticationType Kerberos 

Then export the Initial Replica using the following command-let
    
    
    Start-VMInitialReplication –VMName SQLDB_MyApplication –DestinationPath F:\VirtualMachineData\ 

### Steps to take on the Replica Site

  1. Once the external storage medium is received at the Replica site, request the site administrator to do one of the following   
If your Replica Server is a
    * **Standalone Hyper-V Host** \- ensure that the external media is connected directly to the Hyper V Host or copy the data from the external media into a local folder on the Hyper V Host.
    * **Failover Hyper-V Cluster** –ensure the external media is connected directly to the **Owner Node** of the replica VM or copy the data from the external media to cluster shared volume.
  2. On the Replica VM, complete the OOB IR process by choosing **Replication - > Import Initial Replica…** from the context menu as shown below
    * [![Img3](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2100.Img3_thumb_618C2608.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4885.Img3_044D5DC6.jpg)
  3. Provide the location of the VM’s initial copy. You can recognize the folder in which the replica is stored by checking for the folder name which starts with the name of your VM. In my case the VM was called **SQLDB_MyApplication** and the folder name is    D:\VMInitialReplica\ **SQLDB_MyApplication** _A60B7520-724D-4708-8C09-56F6438930D9.
  4. Click on ‘ **Complete Initial Replication** ’ to import the initial copy and merge it with the placeholder VM. Once the import is completed the Replica VM has been created.
  5. From this point onwards your VM is protected and will allow you to perform operations like Failover and Test Failover.



The same steps can be achieved using PowerShell   
Copy the Initial Replica onto a local drive on the replica server (say D:\VirtualMachineData\\) and then run the below command-let to import the initial replica.
    
    
    Import-VMInitialReplication –VMName SQLDB_Application_Payroll  -Path D:\VirtualMachineData\ SQLDB_MyApplication_A60B7520-724D-4708-8C09-56F6438930D9 

Hyper V Replica offers one more method for Initial Replication that utilizes a backup copy of the VM to seed the replication, will cover that in our next blog post.
