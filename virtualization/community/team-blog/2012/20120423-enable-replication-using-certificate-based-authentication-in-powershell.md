---
title:      "Enable replication using certificate based authentication - in PowerShell"
date:       2012-04-23 04:49:00
categories: certificates
---
**Update in July 2012: This post is applicable only if you on Windows Server "8" Beta. For Windows Server 2012 RC and later, refer to the updated blog post @[ http://blogs.technet.com/b/virtualization/archive/2012/07/16/hyper-v-replica-certificate-based-authentication-in-windows-server-2012-rc.aspx](http://blogs.technet.com/b/virtualization/archive/2012/07/16/hyper-v-replica-certificate-based-authentication-in-windows-server-2012-rc.aspx)**

 

In an earlier post, we have discussed the [prerequisites for certificate based deployment](http://blogs.technet.com/b/virtualization/archive/2012/03/13/hyper-v-replica-certificate-requirements.aspx). This blog now captures the administrator workflow to enable replication using PowerShell in Windows Server “8” Beta.

 

If your primary or replica server is part of a cluster, configure the **Hyper-V Replica Broker** before following the instructions in this blog. The PS cmdlets in the blog "[Why is Hyper-V Replica Broker required](http://blogs.technet.com/b/virtualization/archive/2012/03/27/why-is-the-quot-hyper-v-replica-broker-quot-required.aspx)” enable you to configure the broker.  


### Configure Replica Server   


  1. From an elevated PowerShell cmdlet, run the following command to view the certificate thumbprint of the Trusted Root Certification Authorities



 

PS C:\Windows\system32> cd cert:

 

PS Cert:\> cd .\\\LocalMachine\Root

 

PS Cert:\LocalMachine\Root> dir

 

 

    Directory: Microsoft.PowerShell.Security\Certificate::LocalMachine\Root

 

 

Thumbprint                                Subject                             

\----------                                \-------                             

4BFFF00509B97C782603F1DF3AF8C0399778FD70  CN=IntRootCA                         

 

Copy the thumbprint of the certificate **which has issued the Personal store certificate** whose attributes match the criteria mentioned in the [Prerequisites for certificate based deployment](http://blogs.technet.com/b/virtualization/archive/2012/03/13/hyper-v-replica-certificate-requirements.aspx) post.

In this example, _IntRootCA_ has issued _BrokerHyd_ which meets the prerequisite in the blog article, hence we copy the thumbprint " 4BFFF00509B97C782603F1DF3AF8C0399778FD70"

[![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/7506.BrokerHyd.PNG)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/7506.BrokerHyd.PNG)

 

  


2\. To enable replication on the Replica server/cluster, issue the following PowerShell cmdlet, using the above thumbprint information in _< CertThumbprint>_:

_Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Certificate -ReplicationAllowedFromAnyServer $true -CertificateThumbprint " <CertThumbprint>” -DefaultStorageLocation “<Storage Location>” -CertificateAuthenticationPort <Listenerport>_

 PS C:\Windows\system32> Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Certificate -ReplicationAllowedFromAnyServer $true -CertificateThumbprint "4BFFF00509B97C782603F1DF3AF8C0399778FD70" -DefaultStorageLocation "C:\ClusterStorage\Volume2\Replica" -CertificateAuthenticationPort 5000 

 

PS C:\Windows\system32> Get-VMReplicationServer

 

RepEnabled AuthType IntAuth CertAuth AnyServer MonInterval MonStartTime

\---------- -------- ------- -------- --------- ----------- ------------

True       Cert     80      5000     True      12:00:00    10:00:00   

 

 

Hyper-V Replica finds a matching certificate and brings up an https listener on port 5000.

  


**3\. Verify:** To check if the listener is running, issue the following command from an elevated PowerShell or command prompt:

 

PS C:\Windows\system32> netsh http show servicestate

 

Snapshot of HTTP service state (Server Session View): 

\----------------------------------------------------- 

 

Server session ID: FF0000002001FC7F

    Version: 2.0

    State: Active

    Properties:

        Max bandwidth: 4294967295

        Timeouts:

            Entity body timeout (secs): 120

            Drain entity body timeout (secs): 120

            Request queue timeout (secs): 120

            Idle connection timeout (secs): 120

            Header wait timeout (secs): 120

            Minimum send rate (bytes/sec): 150

    URL groups:

    URL group ID: FD000000400216FA

        State: Active

        Request queue name: Request queue is unnamed.

        Properties:

            Max bandwidth: inherited

            Max connections: inherited

            Timeouts:

                Entity body timeout (secs): 300

                Drain entity body timeout (secs): 0

                Request queue timeout (secs): 0

                Idle connection timeout (secs): 300

                Header wait timeout (secs): 0

                Minimum send rate (bytes/sec): 0

            Number of registered URLs: 2

            Registered URLs:

                HTTPS://TECHED-HYD-01:5000/FRVROOT_{FED10A98-8CB9-41E2-8608-264B923C2623}/

                HTTPS://TECHED-HYD-01.FRTEST.NTTEST.MICROSOFT.COM:5000/FRVROOT_{FED10A98-8CB9-41E2-8608-264B923C2623}/

 

 

  


**Note:** If the node is part of a cluster *and* if the Hyper-V Replica Broker is running on this node, an extra entry can be seen in the output of the above command, which lists the Client Access Point of the Hyper-V Replica Broker. In this example _BrokerHyd_ is the Client Access Point of the Hyper-V Replica Broker in this cluster.

 

Server session ID: FC0000002001ED19

    Version: 2.0

    State: Active

    Properties:

        Max bandwidth: 4294967295

        Timeouts:

            Entity body timeout (secs): 120

            Drain entity body timeout (secs): 120

            Request queue timeout (secs): 120

            Idle connection timeout (secs): 120

            Header wait timeout (secs): 120

            Minimum send rate (bytes/sec): 150

    URL groups:

    URL group ID: FB0000004000000F

        State: Active

        Request queue name: Request queue is unnamed.

        Properties:

            Max bandwidth: inherited

            Max connections: inherited

            Timeouts:

                Entity body timeout (secs): 300

                Drain entity body timeout (secs): 0

                Request queue timeout (secs): 0

                Idle connection timeout (secs): 300

                Header wait timeout (secs): 0

                Minimum send rate (bytes/sec): 0

            Number of registered URLs: 2

            Registered URLs:

                HTTPS://BROKERHYD:5000/FRVROOT_{FED10A98-8CB9-41E2-8608-264B923C2623}/

                HTTPS://BROKERHYD.FRTEST.NTTEST.MICROSOFT.COM:5000/FRVROOT_{FED10A98-8CB9-41E2-8608-264B923C2623}/

 

  


4\. Ensure that the Firewall allows traffic on the configured port. In a clustered environment, if you are using Windows Firewall, issue the following command from one of the node’s in the cluster:

_ _

Get-ClusterNode | ForEach-Object  {Invoke-command -computername $_.name -scriptblock {Enable-Netfirewallrule -displayname "Hyper-V Replica HTTPS Listener (TCP-In)"}} 

 

The above cmdlet enables the _Hyper-V Replica HTTPS Listener (TCP-In)_ Windows Firewall rule in *all* the nodes of the cluster. The listener port is updated automatically based on the input provided in _Set-VMReplicationServer_ cmdlet.

 

If your Replica server is a standalone server, issue the following cmdlet:

 

Enable-Netfirewallrule -displayname "Hyper-V Replica HTTPS Listener (TCP-In)" 

 

# 

# 

# 

#   


# Enabling Replication for the virtual machine

1\. Repeat step (1) under "Configure Replica Server" section above.   
  
2\. Enable a replication relationship by issuing the following PowerShell cmdlet: __

  


_Set-VMReplication -VMName " <VM Name>" -ReplicaServerName "<Replica Server Name/Hyper-V Replica Broker>" -ReplicaServerPort <Port configured on the replica server> -AuthenticationType Certificate -CertificateThumbprint "<Root CA Thumbprint>" -CompressionEnabled $true_

  


 

PS C:\Windows\system32> Set-VMReplication -VMName "ProjectVM" -ReplicaServerName "Brokerhyd.FRTEST.nttest.microsoft.com" -ReplicaServerPort 5000 -AuthenticationType Certificate -CertificateThumbprint "4BFFF00509B97C782603F1DF3AF8C0399778FD70" -CompressionEnabled $true 

 

 

3\. To initiate “Initial-Replication” of the virtual machine, use the following cmdlet

  


   
 

PS C:\Windows\system32> Start-VMInitialReplication -VMName "ProjectVM"

 

 The initial replica is sent over the network at once.  Use the _get-help_ on _Start-VMInitialReplication_ to learn more about the different initial replication techniques and on how to schedule this operation.

 

4\. The Hyper-V Manager provides useful information for the replicating virtual machine

[![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0211.VMState.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0211.VMState.png)

 

You have now enabled replication using certificates! It’s also worth calling out that when the primary or replica virtual machine migrates from one clustered node to another, Hyper-V Replica will continue to send replication traffic **without** any manual intervention.
