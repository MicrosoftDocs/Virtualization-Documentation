---
layout:     post
title:      "Hyper-V R2 Import/Export – Part 1 – The Case for New Import/Export Functionality"
date:       2009-05-20 00:13:00
categories: hyper-v
---
This is the first blog entry of a multi-part series of blogs that addresses Import/Export in Windows Server 2008 R2. This blog talks about the scenarios enabled by the changes made to import/export in R2. Ben Armstrong had blogged earlier about the intricacies of Import and Export with v1 Hyper-V in his blog posts:  
<http://blogs.msdn.com/virtual_pc_guy/archive/2008/08/26/hyper-v-export-import-part-1.aspx>   
<http://blogs.msdn.com/virtual_pc_guy/archive/2008/08/27/hyper-v-export-import-part-2.aspx> Now, the big problem with how import export worked in v1 was that it just did not give the user enough control over the process of exporting and more significantly, importing a VM. Additionally, it was rather unforgiving. I bet many a user has been burnt trying to import a VM a second time only to find out that since he/she had imported it once already, the import folder could not be used anymore. 

So, introducing the R2 version of Import Export: a lot more fine grained control on the entire process as well as added capabilities that are more in tune with user needs. Here is a list of capabilities enabled with the new Import Export functionality:

  1. _Copy on Import:_ The R2 Import/Export APIs now allow the user to specify a location to import to and not use the import directory as the VM's execution directory. Thus, the user can now create a "gold VM", export it once to a file share and then import it multiple times from that file share. This capability ends up enabling a number of scenarios as a result:  
a. Backup-restore: For the users who do not want to use a backup application to backup their VMs, they can use import/Export and can restore the same files multiple times. Additionally, they can now have their backup media as read-only.  
b. Moving/Cloning VMs: The users do not need to do a separate file copy operation in order to move a VM now. They just have to export to a file share and then import it. Additionally, at import time, the user can now specify where to place the VM on the target machine.
  2. _Export of a Snapshot_ : Picture this in the v1 days of Hyper-v: Tester Fred is running a number of tests using virtual machines. During the course of the tests, he takes snapshots at different points in time. Now, after snapshot #5 of 20, he sees a bug. So, he would like the developer to take a look at it. However, he would need to export the entire VM and all its snapshots in order to do that. In R2, he can export snapshot #5 as a separate and independent VM and send it to the developer to debug.   
Additionally, this functionality has enabled another scenario in the IT arena: IT Admin John has a staging environment where he experiments with a number of versions of software in a VM to determine which works best for his scenario. Using R2 Hyper-V, he can create snapshots for each version of the software being tried out. When he determines a version that would work best in his deployment, all he has to do is to export that snapshot and then import it as an independent VM in the production machines. 
  3. _Fine grained control_ : In R2, we have a much richer APIs for Export and Import, enabling the user to tweak parameters like VHD paths, network connections and AzMan during import. Additionally, these parameters can be modified regardless of how the export was carried out. In v1, if the users did a full export (ie: export with configuration as well as VHDs), there was little available to the user to tweak upon import. If they exported config only, they had to edit the config.xml file upon import. None of that in R2. All the parameters can now be tweaked via the import APIs. More on this in the following blog  



