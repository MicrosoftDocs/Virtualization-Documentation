---
title:      "Hyper-V Replica Powershell Series&#58; Creating Hyper-V Replica Broker"
author: sethmanheim
ms.author: sethm
ms.date: 08/14/2012
date:       2012-08-14 23:09:00
categories: hvr
description: Hyper-V Replica Powershell Series&#58; Creating Hyper-V Replica Broker
---
# Creating Hyper-V Replica Broker using Powershell

We have seen multiple queries on the steps required to create the Hyper-V Replica Broker using Powershell, a [previous post](https://blogs.technet.com/b/virtualization/archive/2012/03/27/why-is-the-quot-hyper-v-replica-broker-quot-required.aspx) describes the process but adding more details on the end to end workflow.

To create a Hyper-V Replica Broker in a DHCP environment, use the following cmdlets:
    
```markdown
 1: #Specify the name for the Broker and static IP address
    
    
 2: $BrokerName = "ReplicaBroker"
    
    
 3:   
    
    
 4: #These are derived parameters and need not be specified
    
    
 5: $BrokerResourceName = "Virtual Machine Replication Broker"
    
    
 6: $TempBrokerGroupName = $BrokerName + "Group"
    
    
 7:   
    
    
 8: #Creating a cluster server role to create the Broker CAP
    
    
 9: Add-ClusterServerRole -Name $BrokerName | Out-Null
    
    
 10:   
    
    
 11: #Creating Hyper-V Replica Broker Group using WMI
    
    
 12: ([wmiclass]"root\MSCluster:MSCluster_ResourceGroup").CreateGroup($TempBrokerGroupName, 115) | Out-Null
    
    
 13: Add-ClusterResource -Name $BrokerResourceName -Group $TempBrokerGroupName -ResourceType "Virtual Machine Replication Broker" | Out-Null
    
    
 14:   
    
    
 15: #Moving the Broker CAP to the right group"
    
    
 16: Move-ClusterResource -name $BrokerName  -Group $TempBrokerGroupName | Out-Null 
    
    
 17: Add-ClusterResourceDependency  $BrokerResourceName $BrokerName | Out-Null
    
    
 18:   
    
    
 19: #Moving the temoporary group used to create the Broker CAP"
    
    
 20: Remove-ClusterGroup -name  $BrokerName -RemoveResources -Force | Out-Null
    
    
 21:   
    
    
 22: #Rename cluster group to get parity in name between the group and CAP"
    
    
 23: Get-ClusterGroup $TempBrokerGroupName | %{ $_.Name = $BrokerName }
    
    
 24:   
    
    
 25: #Starting Hyper-V Replica Broker Resource"
    
    
 26: Start-ClusterGroup -Name $BrokerName | Out-Null
```

To specify a static IP address for the Hyper-V Replica Broker, specify the IP address in the StaticAddress parameter of the [Add-ClusterServerRole](https://technet.microsoft.com/library/ee461053)
    
```markdown
 1: #Specify the name for the Broker and static IP address
    
    
 2: $BrokerName = "ReplicaBroker"
    
    
 3: $IPAddressOfBroker = "172.22.57.87"
    
    
 4:   
    
    
 5: #These are derived parameters and need not be specified
    
    
 6: $BrokerResourceName = "Virtual Machine Replication Broker"
    
    
 7: $TempBrokerGroupName = $BrokerName + "Group"
    
    
 8:   
    
    
 9: #Creating a cluster server role to create the Broker CAP
    
    
 10: Add-ClusterServerRole -Name $BrokerName -StaticAddress $IPAddressOfBroker | Out-Null
    
    
 11:   
    
    
 12: #Creating Hyper-V Replica Broker Group using WMI
    
    
 13: ([wmiclass]"root\MSCluster:MSCluster_ResourceGroup").CreateGroup($TempBrokerGroupName, 115) | Out-Null
    
    
 14: Add-ClusterResource -Name $BrokerResourceName -Group $TempBrokerGroupName -ResourceType "Virtual Machine Replication Broker" | Out-Null
    
    
 15:   
    
    
 16: #Moving the Broker CAP to the right group"
    
    
 17: Move-ClusterResource -name $BrokerName  -Group $TempBrokerGroupName | Out-Null 
    
    
 18: Add-ClusterResourceDependency  $BrokerResourceName $BrokerName | Out-Null
    
    
 19:   
    
    
 20: #Moving the temoporary group used to create the Broker CAP"
    
    
 21: Remove-ClusterGroup -name  $BrokerName -RemoveResources -Force | Out-Null
    
    
 22:   
    
    
 23: #Rename cluster group to get parity in name between the group and CAP"
    
    
 24: Get-ClusterGroup $TempBrokerGroupName | %{ $_.Name = $BrokerName }
    
    
 25:   
    
    
 26: #Starting Hyper-V Replica Broker Resource"
    
    
 27: Start-ClusterGroup -Name $BrokerName | Out-Null
```

Once the Hyper-V Replica Broker is created, enable the cluster to receive replication traffic by using the [Set-VMReplicationServer](https://technet.microsoft.com/library/hh848598) cmdlet.
