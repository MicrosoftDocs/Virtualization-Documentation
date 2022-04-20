---
title: Setting up Linux Operating System Clusters on Hyper-V (3 of 3)
description: Follow along with part 3 of this three-part walk-through about setting up Linux operating system clusters on Hyper-V.
author: mattbriggs
ms.author: mabrigg
date:       2016-03-02 20:22:21
ms.date: 03/02/2016
categories: clustering
---
# Setting up Linux Operating System Clusters on Hyper-V (3 of 3)

Author: Dexuan Cui [Link to Part 2: Setting up Linux Operating System Clusters on Hyper-V ](https://blogs.technet.microsoft.com/virtualization/2016/02/23/setting-up-linux-operating-system-clusters-on-hyper-v-2-of-3/ "Setting up Linux Operating System Clusters on Hyper-V \(2 of 3\)")[Link to Part 1: Setting up Linux Operating System Clusters on Hyper-V](https://blogs.technet.microsoft.com/virtualization/2016/02/19/setting-up-linux-operating-system-clusters-on-hyper-v-1-of-3/ "Setting up Linux Operating System Clusters on Hyper-V \(1 of 3\)")

## **Background**

This blog post is the third in a series of three that walks through setting up Linux operating system clusters on Hyper-V. The walk-through uses [Red Hat Cluster Suite (RHCS)](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Cluster_Suite_Overview/s1-rhcs-intro-CSO.html) as the clustering storage and Hyper-V’s [Shared VHDX](https://technet.microsoft.com/library/dn281956.aspx) as the shared storage needed by the cluster software. Part 1 of the series showed how to set up a Hyper-V host cluster and a shared VHDX. Then it showed how to set up five CentOS 6.7 VMs in the host cluster, all using the shared VHDX. Part 2 of the series showed how to set up the Linux OS cluster with the CentOS 6.7 VMs, running RHCS and the [GFS2 file system](https://en.wikipedia.org/wiki/GFS2). The GFS2 file system is specifically designed to be used on shared disks accessed by multiple node in a Linux cluster, and so is a natural example to use. This post now makes use of the Linux OS cluster to provide high availability. A web server is set up on one of the CentOS 6.7 nodes, and various failover cases are demonstrated. Let’s get started!  

## **Setup a web server running on a node and experiment with the failover case**

Note: this is actually an “Active-Passive” cluster ([A cluster where only one node runs a given service at a time, and the other nodes are in stand-by to take over, should the need arise](http://haifux.org/lectures/168/linux-ha-clusters.html)). Setting up an “Active-Active” cluster is much more complex, because it requires great awareness of the underlying applications, thus one mostly sees this with very specific applications - e.g. database servers that are designed to support multiple database servers accessing the same database disk storage.  

  1. [Add a Failover Domain ](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Cluster_Administration/s1-config-failover-domain-conga-CA.html#s2-config-add-failoverdm-conga-CA)“A failover domain is a named subset of cluster nodes that are eligible to run a cluster service in the event of a node failure”. With the below configuration (priority 1 is of the highest priority and priority 5 is of the lowest priority), by default the web server runs on node 1. If node 1 fails, node 2 will take over and run the web server. If node 2 fails, node 3 will take over, etc.[![image1](https://msdnshared.blob.core.windows.net/media/2016/03/image11.png)](https://msdnshared.blob.core.windows.net/media/2016/03/image11.png)
  2. Install & configure Apache **on every node**


    
```code
    # yum install httpd
    # chkconfig httpd off   # By Default, Apache doesn’t automatically start.
```

  3. On node 1, make the minimal change to the default Apache config file /etc/httpd/conf/httpd.conf:
(Note: **/mydata** is in the shared GFS2 partition) 

    
```code
    -DocumentRoot "/var/www/html"
    +DocumentRoot "/ **mydata** /html"
    
    
    -<Directory "/var/www/html">
    +<Directory "/ **mydata** /html">
```

And scp /etc/httpd/conf/httpd.conf to the other 4 nodes.

Next, add a simple html file /mydata/html/index.html with the below content:
    
```code
    **< html> <body> <h1> "Hello, World" (test page)</h1>  </body> </html>
    
    **
```

  4. Define the “Resources” and “Service Group” of the cluster
Note: here 10.156.76.58 is the “floating IP” (a.k.a. virtual IP). An end user uses <http://10.156.76.58> to access the web server, but the web server httpd daemon can be running on any node of the cluster according to the fail over configuration, when some of the nodes fail. 

<!--
[![image2](https://msdnshared.blob.core.windows.net/media/2016/03/image21.png)](https://msdnshared.blob.core.windows.net/media/2016/03/image21.png)

[![image3](https://msdnshared.blob.core.windows.net/media/2016/03/image31.png)](https://msdnshared.blob.core.windows.net/media/2016/03/image31.png)

[![image4](https://msdnshared.blob.core.windows.net/media/2016/03/image4.png)](https://msdnshared.blob.core.windows.net/media/2016/03/image4.png)
-->
  5. Test the Web Server from another host
Use a browser to access [http://10.156.76.58/ ](http://10.156.76.58/)<!--[![image5](https://msdnshared.blob.core.windows.net/media/2016/03/image5.png)](https://msdnshared.blob.core.windows.net/media/2016/03/image5.png)[ ](http://10.156.76.58/)--> Keep pressing “F5” to refresh the page and everything works fine. We can verify the web server is actually running on node1: 

```code
        [root@my-vm1 ~]# ps aux | grep httpd
    
    root     13539  0.0  0.6 298432 12744 ?        S<s  21:38   0:00 /usr/sbin/httpd -Dmy_apache -d /etc/httpd -f /etc/cluster/apache/apache:my_apache/httpd.conf -k start
```

  6. Test Fail Over
Shutdown node 1 by “shutdown -h now” and the end user will detect this failure immediately by keeping pressing F5. <!--[![image6](https://msdnshared.blob.core.windows.net/media/2016/03/image6.png)](https://msdnshared.blob.core.windows.net/media/2016/03/image6.png)-->In ~15 seconds, the end user finds the web server backs to normal. <!--[![image5](https://msdnshared.blob.core.windows.net/media/2016/03/image5.png)](https://msdnshared.blob.core.windows.net/media/2016/03/image5.png)--> Now, we can verify the web server is running on node 2:

```code
          [root@my-vm2 ~]# ps aux | grep http

        root     13879  0.0  0.6 298432 12772 ?        S<s  21:58   0:00 /usr/sbin/httpd -Dmy_apache -d /etc/httpd -f /etc/cluster/apache/apache:my_apache/httpd.conf -k start
```

And we can check the cluster status: 

```code
        [root@my-vm2 ~]# clustat
    Cluster Status for my-cluster @ Thu Oct 29 21:59:40 2015
    
    Member Status: Quorate 
     Member Name                                   ID   Status
     ------ ----                                   ---- ------
     my-vm1                                           1 Offline
     my-vm2                                           2 Online, Local, rgmanager
     my-vm3                                           3 Online, rgmanager
     my-vm4                                           4 Online, rgmanager
     my-vm5                                           5 Online, rgmanager
     /dev/block/8:33                                  0 Online, Quorum Disk
    
    Service Name                        Owner (Last)          State
    ------- ----                        ----- ------          -----
    service:my_service_group            my-vm2                started
```

  7. Now we power off node 2 by clicking Virtual Machine Connection’s “Turn Off” icon.
Similarly, we’ll find out node 3 will take over node 2 and the end user can still notice the webserver backs to normal after a transient black-out. 

```code
        [root@my-vm3 ~]# clustat
    Cluster Status for my-cluster @ Thu Oct 29 22:03:57 2015
    
    Member Status: Quorate 
     Member Name                                      ID   Status
     ------ ----                                      ---- ------
     my-vm1                                              1 Offline
     my-vm2                                              2 Offline
     my-vm3                                              3 Online, Local, rgmanager
     my-vm4                                              4 Online, rgmanager
     my-vm5                                              5 Online, rgmanager
     /dev/block/8:33                                     0 Online, Quorum Disk
    
     Service Name                            Owner (Last)      State
     ------- ----                            ----- ------      ------          
     service:my_service_group                my-vm3            started
```

  8. Now we power off node 3 and 4 and later we’ll find the web server will be running in node 5, the last node, in ~20 seconds.
  9. Now let’s power on node 1 and after node 1 re-joins the cluster, the web server will be moved from node 5 to node 1.



## **Summary and conclusions**

We’ve often been asked whether Linux OS clusters can be created for Linux guests running on Hyper-V. The answer is “Yes!” This series of 3 blog posts shows how to set up Hyper-V and make use of the Shared VHDX feature to provide shared storage for the cluster nodes. Then it shows how to set up Red Hat Cluster Suite and a shared GFS2 file system. Finally, we wrapped up with a demonstration of a web server that fails over from one cluster node to another. Other cluster software is available for other Linux distros and versions, so the process for your particular environment may be different, but the fundamental requirement for shared storage is typically the same across different cluster packages. Hyper-V and Shared VHDX provide the core infrastructure you need, and then you can install and configure your Linux OS clustering software to meet your particular requirements. Thank you for following this series, Dexuan Cui
