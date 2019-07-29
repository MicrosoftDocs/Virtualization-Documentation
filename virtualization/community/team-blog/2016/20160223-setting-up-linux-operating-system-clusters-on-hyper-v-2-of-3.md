---
title:      "Setting up Linux Operating System Clusters on Hyper-V (2 of 3)"
date:       2016-02-23 01:22:56
categories: hyper-v
---
Author: Dexuan Cui [Link to Part 1 Setting up Linux Operating System Clusters on Hyper-V](https://blogs.technet.microsoft.com/virtualization/2016/02/19/setting-up-linux-operating-system-clusters-on-hyper-v-1-of-3/ "Setting up Linux Operating System Clusters on Hyper-V \(1 of 3\)")

## **Background**

This blog post is the second in a series of three that walks through setting up Linux operating system clusters on Hyper-V. The walk-through uses [Red Hat Cluster Suite (RHCS)](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Cluster_Suite_Overview/s1-rhcs-intro-CSO.html) as the clustering storage and Hyper-V’s [Shared VDHX](https://technet.microsoft.com/library/dn281956.aspx) as the shared storage needed by the cluster software. Part 1 of the series showed how to set up a Hyper-V host cluster and a shared VHDX. Then it showed how to set up five CentOS 6.7 VMs in the host cluster, all using the shared VHDX. This post will set up the Linux OS cluster with the CentOS 6.7 VMs, running RHCS and the [GFS2 file system](https://en.wikipedia.org/wiki/GFS2). RHCS is specifically for use with RHEL/CentOS 6.x; RHEL/CentOS 7.x uses a different clustering software package that is not covered by this walk through. The GFS2 file system is specifically designed to be used on shared disks accessed by multiple nodes in a Linux cluster, and so is a natural example to use. Let’s get started! **Setup a guest cluster with the five CentOS 6.7 VMs running RHCS + GFS2 file system**

  1. On one node of the Linux OS cluster, say, my-vm1, install the web-based HA configuration tool **luci**


    
    
    # yum groupinstall "High Availability Management"
    # chkconfig luci on; service luci start

  2. On all 5 nodes, install RHCS and make proper configuration change


    
    
    # yum groupinstall "High Availability" "Resilient Storage"
    # chkconfig iptables off
    # chkconfig ip6tables off
    # chkconfig NetworkManager off
    
    

Disable SeLinux by
    
    
    edit /etc/selinux/config: SELINUX=disabled
    # setenforce 0
    # passwd ricci        _[this user/password is to login the web-based HA configuration tool luci]_
    
    
    # chkconfig ricci on; service ricci start
    # chkconfig cman on; chkconfig clvmd on
    # chkconfig rgmanager on; chkconfig modclusterd on
    # chkconfig gfs2 on
    # reboot               _[Can also choose to start the above daemons manually without reboot]_

After 1 and 2, we should reboot all the nodes to make things take effect. Or we need to manually start or shut down the above service daemons on every node.

Optionally, remove the “rhgb quiet” kernel parameters for every node, so you can easily see which cluster daemon fails to start on VM bootup.

  3. Use a web browser to access <https://my-vm1:8084> (the web-based HA configuration tool luci -- first login with root and grant the user ricci the permission to administrator and create a cluster, then logout and login with ricci)

 
  4. Create a 5-node cluster “my-cluster” [![image1](https://msdnshared.blob.core.windows.net/media/2016/02/image121.png)](https://msdnshared.blob.core.windows.net/media/2016/02/image121.png) [![image2](https://msdnshared.blob.core.windows.net/media/2016/02/image210.png)](https://msdnshared.blob.core.windows.net/media/2016/02/image210.png) [![image3](https://msdnshared.blob.core.windows.net/media/2016/02/image310.png)](https://msdnshared.blob.core.windows.net/media/2016/02/image310.png) We can confirm the cluster is created properly by checking the status of the service daemons and checking the cluster status (clustat): 
    
        service modclusterd status
    service cman status
    service clvmd status
    service rgmanager status
    clustat
    
    

e.g., when we run the commands in my-vm3, we get: [![image4](https://msdnshared.blob.core.windows.net/media/2016/02/image410.png)](https://msdnshared.blob.core.windows.net/media/2016/02/image410.png)
  5. Add a fencing device (we use SCSI3 Persistent Registration) and associate all the VMs with it.
Fencing is used to prevent erroneous/unresponsive nodes from accessing the shared storage, so data consistency can be achieved. See the below for an excerpt of [IO fencing and SCSI3 PR](http://www.dba-oracle.com/real_application_clusters_rac_grid/io_fencing.html): _“SCSI-3 PR, which stands for Persistent Reservation, supports multiple nodes accessing a device while at the same time blocking access to other nodes. SCSI-3 PR reservations are persistent across SCSI bus resets or node reboots and also support multiple paths from host to disk. SCSI-3 PR uses a concept of registration and reservation. Systems that participate, register a key with SCSI-3 device. Each system registers its own key. Then registered systems can establish a reservation. With this method, blocking write access is as simple as removing registration from a device. **A system wishing to eject another system issues a preempt and abort command and that ejects another node. Once a node is ejected, it has no key registered so that it cannot eject others. This method effectively avoids the split-brain condition**.”_ This is how we add SCSI3 PR in RHCS: _[![image5](https://msdnshared.blob.core.windows.net/media/2016/02/image510.png)](https://msdnshared.blob.core.windows.net/media/2016/02/image510.png)_[![image6](https://msdnshared.blob.core.windows.net/media/2016/02/image610.png)](https://msdnshared.blob.core.windows.net/media/2016/02/image610.png) [![image7](https://msdnshared.blob.core.windows.net/media/2016/02/image710.png)](https://msdnshared.blob.core.windows.net/media/2016/02/image710.png) NOTE 1: in **/etc/cluster/cluster.conf** , we need to manually specify **devices="/dev/sdb"** and add a **< unfence>** for every VM **.** The web-based configuration tool doesn’t support this, but we do need this, otherwise cman can’t work properly. NOTE 2: when we change **/etc/cluster/cluster.conf** manually, remember to increase “config_version” by 1 and propagate the new configuration to other nodes by “[ **cman_tool version -r**](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Cluster_Administration/s1-admin-updating-config-CA.html)”. 
  6. Add a Quorum Disk to help to better cope with the Split-Brain issue. _“In RHCS,_[ _CMAN (Cluster MANager)_](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/High_Availability_Add-On_Overview/ch-cman.html) _keeps track of membership by monitoring messages from other cluster nodes. When cluster membership changes, the cluster manager notifies the other infrastructure components, which then take appropriate action. If a cluster node does not transmit a message within a prescribed amount of time, the cluster manager removes the node from the cluster and communicates to other cluster infrastructure components that the node is not a member. Other cluster infrastructure components determine what actions to take upon notification that node is no longer a cluster member. For example, Fencing would disconnect the node that is no longer a member._ _ _A cluster can only function correctly if there is general agreement between the members regarding their status. We say a cluster has quorum if a majority of nodes are alive, communicating, and agree on the active cluster members. For example,__ _in a thirteen-node cluster, quorum is only reached if seven or more nodes are communicating. If the seventh node dies, the cluster loses quorum and can no longer function._ _A cluster must maintain quorum to prevent split-brain issues. Quorum doesn't prevent split-brain situations, but it does decide who is dominant and allowed to function in the cluster. Quorum is determined by communication of messages among cluster nodes via Ethernet. Optionally, quorum can be determined by a combination of communicating messages via Ethernet and through a quorum disk. For quorum via Ethernet, quorum consists of a simple majority (50% of the nodes + 1 extra). When configuring a quorum disk, quorum consists of user-specified conditions.”_
In our 5-node cluster, if more than 2 nodes fail, the whole cluster will stop working. Here we’d like to keep the cluster working even if there is only 1 node alive, that is, the “Last Man Standing” functionality (see [How to Optimally Configure a Quorum Disk in Red Hat Enterprise Linux Clustering and High-Availability Environments](https://access.redhat.com/articles/216443)), so we’re going to set up a quorum disk. 
    * In my-vm1, use “fdisk /dev/sdc” to create a partition. Here we don’t run mkfs against it.
    * Run “mkqdisk -c /dev/sdc1 -l myqdisk” to initialize the qdisk partition and run “mkqdisk -L” to confirm it’s done successfully.
    * Use the web-based tool to configure the qdisk: [![image8](https://msdnshared.blob.core.windows.net/media/2016/02/image810.png)](https://msdnshared.blob.core.windows.net/media/2016/02/image810.png) Here a heuristics is defined to help to check the healthiness of every node. On every node, the ping command is run every 2 seconds. In (2*10 = 20) seconds, if 10 successful runs of ping aren’t achieved, the node itself thinks it has failed. As a consequence, it won’t vote, and it will be fenced, and the node will try to reboot itself. After we “apply” the configuration in the Web GUI, /etc/cluster/cluster.conf is updated with the new lines: 
        
                _< **cman expected_votes="9"** />
        __< quorumd label="myqdisk" min_score="1">
        __ <heuristic program="ping -c3 -t2 10.156.76.1" score="2" tko="10"/>
        __< /quorumd>_

And “ **clustat** ” and “ **cman_tool status** ” shows: 
        
                [root@my-vm1 ~]# **clustat** Cluster Status for my-cluster @ Thu Oct 29 14:11:16 2015
        
        Member Status: Quorate 
        Member Name                                                     ID   Status
        ------ ----                                                     ---- ------
        my-vm1                                                              1 Online, Local
        my-vm2                                                              2 Online
        my-vm3                                                              3 Online
        my-vm4                                                              4 Online
        my-vm5                                                              5 Online
        
        **/dev/block/8:33                                               0 Online, Quorum Disk**
        
                [root@my-vm1 ~]# **cman_tool status**
        
                Version: 6.2.0
        Config Version: 33
        Cluster Name: my-cluster
        Cluster Id: 25554
        Cluster Member: Yes
        Cluster Generation: 6604
        Membership state: Cluster-Member
        Nodes: 5
        **Expected votes: 9** **Quorum device votes: 4** Total votes: 9
        Node votes: 1
        Quorum: 5
        Active subsystems: 11
        Flags:
        Ports Bound: 0 11 177 178
        Node name: my-vm1
        Node ID: 1
        Multicast addresses: 239.192.99.54
        Node addresses: 10.156.76.74

Note 1: “Expected vote”: The expected votes value is used by cman to determine if the cluster has quorum. The cluster is quorate if the sum of votes of existing members is over half of the expected votes value. Here we have n=5 nodes. RHCS automatically specifies the vote value of the qdisk is n-1 = 4 and the expected votes value is n + (n -1) = 2n – 1 = 9. In the case only 1 node is alive, the effective vote value is: 1 + (n-1) = n, which is larger than (2n-1)/2 = n -1 (in C language), so the cluster will continue to function. Note 2: In practice, “ _ping -c3 -t2 10.156.76.1_ ” wasn’t always reliable – sometimes the ping failed after a timeout of 19 seconds and the related node was rebooted unexpectedly. Maybe it’s due to the firewall rule of the gateway server 10.156.76.1. In this case, replace “ _10.156.76.1_ ” with “127.0.0.1” as a workaround. 
  7. Create a GFS2 file system in the shared storage /dev/sdb and test IO fencing 
    * Create a 30GB LVM partition with fdisk 
        
                _[root@my-vm1 ~]# **fdisk /dev/sdb**_ _Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel_ _Building a new DOS disklabel with disk identifier 0x73312800._ _Changes will remain in memory only, until you decide to write them._ _After that, of course, the previous content won't be recoverable._ __
        
                _WARNING: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)_ __
        
                _WARNING: DOS-compatible mode is deprecated. It's strongly recommended to_ _switch off the mode (command 'c') and change display units to_ _sectors (command 'u')._
        
                _Command (m for help): n_
        
                _Command action_ _e   extended_ _p   primary partition (1-4)_
        
                _p_
        
                _Partition number (1-4): 1_ _First cylinder (1-13054, default 1):_ _Using default value 1_ _Last cylinder, +cylinders or +size{K,M,G} (1-13054, default 13054): +30G_
        
                _Command (m for help): p_ __
        
                _Disk /dev/sdb: 107.4 GB, 107374182400 bytes_ _255 heads, 63 sectors/track, 13054 cylinders_ _Units = cylinders of 16065 * 512 = 8225280 bytes_ _Sector size (logical/physical): 512 bytes / 512 bytes_ _I/O size (minimum/optimal): 512 bytes / 512 bytes_ _Disk identifier: 0x73312800_ __
        
                _Device Boot      Start         End      Blocks   Id  System_ _/dev/sdb1               1        3917    31463271   83  Linux_ __
        
                _Command (m for help): t_
        
                _Selected partition 1_ _Hex code (type L to list codes): 8e_ _Changed system type of partition 1 to 8e (Linux LVM)_
        
                _Command (m for help): w_
        
                _The partition table has been altered!_
        
                _Calling ioctl() to re-read partition table._ _Syncing disks._
        
                _[root@my-vm1 ~]#_ __

NOTE: the above fdisk command is run in node1. On nodes 2 through 4, we need to run “partprobe /dev/sdb” command to force the kernel to discover the new partition (another method is: we can simply reboot nodes 2 through 4).
    * Create physical & logical volumes, run mkfs.gfs2 and mount the file systemRun the following on node1:
        
                # pvcreate /dev/sdb1
        # vgcreate my-vg1 /dev/sdb1
        # lvcreate -L +20G -n my-store1 my-vg1
        # lvdisplay /dev/my-vg1/my-store1
        # 
        # mkfs.gfs2 -p lock_dlm -t **my-cluster** :storage -j5 /dev/mapper/my--vg1-my--store1

(Note: here “my-cluster” is the cluster name we used in Step 4.) Run the following on all the 5 notes: 
        
                # mkdir /mydata
        # echo '/dev/mapper/my--vg1-my--store1 /mydata  gfs2 defaults 0 0' >> /etc/fstab
        # mount /mydata

    * Test read/write on the GFS2 partition 
      * Create or write a file /mydata/a.txt on one node, say, node 1
      * On other nodes, say node 3, read /mydata/a.txt and we can immediately see what node 1 wrote
      * On node 3, append a line into the file and on node 1 and the other nodes, the change is immediately visible.
    * Test node failure and IO fencing First retrieve all the registrant keys and the registration information: 
        
                [root@my-vm1 mydata]# sg_persist -i -k -d /dev/sdb
         Msft      Virtual Disk      1.0
         Peripheral device type: disk
         PR generation=0x158, 5 registered reservation keys follow:
         0x63d20004
         0x63d20001
         0x63d20003
         0x63d20005
         0x63d20002
        
        [root@my-vm1 mydata]# sg_persist -i -r -d /dev/sdb
         Msft      Virtual Disk      1.0
         Peripheral device type: disk
         PR generation=0x158, 5 registered reservation keys follow:
            0x63d20004
            0x63d20001
            0x63d20003
            0x63d20005
            0x63d20002
        
                [root@my-vm1 mydata]# sg_persist -i -r -d /dev/sdb
         Msft      Virtual Disk      1.0
         Peripheral device type: disk
         PR generation=0x158, Reservation follows:
            Key=0x63d20005
        scope: LU_SCOPE,  type: Write Exclusive, registrants only
        
        

Then pause node 5 using Hyper-V Manager, so node 5 will be considered dead. In a few seconds, node 1 prints the kernel messages: 
        
                dlm: closing connection to node5
        GFS2: fsid=my-cluster:storage.0: jid=4: Trying to acquire journal lock...
        GFS2: fsid=my-cluster:storage.0: jid=4: Looking at journal...
        GFS2: fsid=my-cluster:storage.0: jid=4: Acquiring the transaction lock...
        GFS2: fsid=my-cluster:storage.0: jid=4: Replaying journal...
        GFS2: fsid=my-cluster:storage.0: jid=4: Replayed 3 of 4 blocks
        GFS2: fsid=my-cluster:storage.0: jid=4: Found 1 revoke tags
        GFS2: fsid=my-cluster:storage.0: jid=4: Journal replayed in 1s
        GFS2: fsid=my-cluster:storage.0: jid=4: Done
        
        

And nodes 2 through 4 print these messages: 
        
                dlm: closing connection to node5
        GFS2: fsid=my-cluster:storage.2: jid=4: Trying to acquire journal lock...
        GFS2: fsid=my-cluster:storage.2: jid=4: Busy, retrying...
            0x63d20004
            0x63d20001
            0x63d20003
            0x63d20005
            0x63d20002
        [root@my-vm1 mydata]# sg_persist -i -r -d /dev/sdb
          Msft      Virtual Disk      1.0

Now on nodes 1 through 4, “clustat” shows node 5 is offline and “cman_tool status” shows the current “Total votes: 8”. And the sg_persist command show the current SCSI owner of /dev/sdb is changed from node 5 to node 1 and there are only 4 registered keys: 

> [root@my-vm4 ~]# sg_persist -i -k -d /dev/sdb Msft Virtual Disk 1.0 Peripheral device type: disk PR generation=0x158, 4 registered reservation keys follow: 0x63d20002 0x63d20003 0x63d20001 0x63d20004 [root@my-vm4 ~]# sg_persist -i -r -d /dev/sdb Msft Virtual Disk 1.0 Peripheral device type: disk PR generation=0x158, Reservation follows: Key=0x63d20001 scope: LU_SCOPE, type: Write Exclusive, registrants only

In a word, the dead node 5 properly became offline and was fenced, and node1 has fixed a file system issue (“Found 1 revoke tags”) by replaying node 5’s GFS2 journal, so we have no data inconsistency issue. Now let’s resume node 5 and we’ll find the cluster still doesn’t accept the node 5 as an online cluster member before node 5 reboots and rejoins the cluster with a known-good state. Note: node 5 will be automatically rebooted by the qdisk daemon.



If we perform the above experiment by shutting down a node’s network (by “ifconfig eth0 down”), e.g., on node 3, we’ll get the same result, that is, node 3’s access to /mydata will be rejected and eventually the qdisk daemon will reboot node 3 automatically.

  **Wrap Up** Wow! That’s a lot of steps, but the result is worth it. You now have a 5 node Linux OS cluster with a shared GFS2 file system that can be read and written from all nodes. The cluster uses a quorum disk to prevent split-brain issues. These steps to set up a RHCS cluster are the same as you would use to set up a cluster of physical servers running CentOS 6.7, but the Hyper-V environment Linux is running in guest VMs, and shared storage is created on a Shared VHDX instead of a real physical shared disk. In the last blog post, we’ll show setting up a web server on one of the CentOS 6.7 nodes, and demonstrate various failover cases.    ~ Dexuan Cui
