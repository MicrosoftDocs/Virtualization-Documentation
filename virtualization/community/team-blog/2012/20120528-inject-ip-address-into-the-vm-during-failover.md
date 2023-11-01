---
title:      "Inject IP address into the VM during failover"
description: Post discussing how to configure the static IP address of the Replica VM before it has failed over.
author: sethmanheim
ms.author: mabrigg
date:       2012-05-28 22:11:00
ms.date: 05/28/2012
categories: hvr
---
# Inject IP address into the Replica VM before it has failed over
Hyper-V Replica reduces the Recovery Time Objective (RTO) providing the ability to configure the static IP address of the Replica VM before it is failed over. This IP address setting is injected into the failed over VM. This post written by **Vinod** **Atal** who is one of the developers in the Hyper-V team demonstrates this feature.

## Network Adapter status on Replica VM

When replication is enabled for a VM, the replica VM's network adapters are disconnected by default.

  
**Inject IP address from UI**

Administrators need to connect the replica VM to the appropriate switch in the Replica server. The IP address which needs to be used in the guest VM during failover can be configured now.

Open the Hyper-V manager and open the settings of the replica VM. Click on **Network Adapter** and click on the **Failover TCP/IP** below the setting.



Enter the IP (v4/v6) details including the address, subnet mask and DNS server(s) information. To verify the settings, invoke the "Test Failover" operation. It is recommended that this operation is run in an isolated network which can be achieved by using the **Test Failover** setting under the Replica VM’s network adapter setting. In the picture below, the replica VM is connected to one such private network.


By default, the network settings under **Test Failover** is not-connected to any switch. Once the above step is performed, when a test failover is invoked, the newly created VM will be connected to "Private Test Network" switch and the IP address provided under " **Failover TCP/IP** " will be injected into the test VM.

**How does Guest IP injection work?**

The Replica VM is blocked from starting unless the Failover workflow is initiated. The **Failover TCP/IP** settings which are provided are stored in the VM configuration file till then. When the replica VM is failed over, the KVP (Key Value Pair) Exchange integration component running within guest operating system picks up the staged settings and applies it inside the VM. Any failure to apply the settings is logged on root partition event viewer.

Few points to note:

  * This feature is available only when the latest integration services installed for the VM.
  * At the time of writing this article, this feature is available for Windows Guest OS'es only.
  * This feature is supported only for synthetic network adapters.
  * This feature cannot be used to inject IP addresses into non-replicated VMs



**Inject IP address using PowerShell**

The above functionality can be achieved using PowerShell as well. To set a IPv4 **Failover TCP/IP** settings on the replica VM, issue the following cmdlet:  
    
```powershell
    Set-VMNetworkAdapterFailoverConfiguration 'Windows 8 SQL Server' 
    
    
    -IPv4Address 192.168.1.1 
    
    
    -IPv4SubnetMask 255.255.255.0 
    
    
    -IPv4DefaultGateway 192.168.31.1
```
 

To connect the VM to a different switch which would be used for Test Failover, use the following cmdlet:
    
```powershell
    Set-VMNetworkAdapter 'Windows 8 SQL Server' 
    
    
    -TestReplicaSwitchName 'Private Test Network'
```
where ‘Private Test Network’ is the name of a virtual switch which provides an isolated network environment.

**Inject IP address using WMI**

A frequent question which we get is around providing the ability to inject **multiple** IP addresses on the same network adapter.

Though this cannot be achieved using UI or PowerShell, the same can be achieved in WMI. This address set is represented by WMI class [Msvm_FailoverNetworkAdapterSettingData](/windows/win32/hyperv_v2/msvm-failovernetworkadaptersettingdata). A WMI snippet is given below which allows you to achieve the above functionality:

```wmi
    #Get vm object 
    
    
    $vm = Get-WmiObject -Namespace 'root\virtualization\v2' -Class 'Msvm_ComputerSystem' | Where-Object { $_.ElementName -eq 'Windows 8 SQL Server' } 
    
    
     
    
    
     
    
    
    # Get active settings 
    
    
    $vmSettings = $vm.GetRelated('Msvm_VirtualSystemSettingData') | Where-Object { $_.VirtualSystemType -eq 'Microsoft:Hyper-V:System:Realized' } 
    
    
     
    
    
     
    
    
    # Get all network adapters 
    
    
    $nwAdapters = $vmSettings.GetRelated('Msvm_SyntheticEthernetPortSettingData') 
    
    
     
    
    
     
    
    
    # Find associated failover network settings 
    
    
    $failoverNetworkSettings = @() 
    
    
     
    
    
    foreach($nwAdapter in $nwAdapters) 
    
    
    { 
    
    
         $failoverNetworkSettings = $failoverNetworkSettings + $nwAdapters.GetRelated("Msvm_FailoverNetworkAdapterSettingData") 
    
    
    }   
    
    
     
    
    
     
    
    
    #Set two IPv4 addresses for first network adapter 
    
    
    $settingForFirstAdapter = $failoverNetworkSettings[0] 
    
    
     
    
    
     
    
    
    #Each field is an array so multiple inputs can be given 
    
    
    $settingForFirstAdapter.IPAddresses = {'192.168.1.1', '192.168.1.2'} 
    
    
    $settingForFirstAdapter.Subnets = {'255.255.255.0', '255.255.255.0'} 
    
    
    $settingForFirstAdapter.DefaultGateways = {'192.168.31.1'}   
    
    
     
    
    
     
    
    
    # Address family values for settings IPv4 , IPv6 Or Boths 
    
    
    # For IPv4:   ProtocolIFType = 4096; 
    
    
    # For IPv6:   ProtocolIFType = 4097; 
    
    
    # For IPv4/V6:ProtocolIFType = 4098; 
    
    
     
    
    
    $settingForFirstAdapter.ProtocolIFType = 4096
    
    
     
    
    
     
    
    
    #Set the failover IP address using replication service object 
    
    
    $replicationService = $vm.GetRelated('Msvm_ReplicationService') 
    
    
     
    
    
    $replicationService.SetFailoverNetworkAdapterSettings($vm.Path, {$settingForFirstAdapter.GetText(1)}) 
    
```


 

The post demonstrates the ease with which IP addresses can be injected during failover. If you wish to inject IP address into a running VM from the root partition, [SetGuestNetworkAdapterConfiguration](/windows/win32/hyperv_v2/setguestnetworkadapterconfiguration-msvm-virtualsystemmanagementservice) is a new API which allows you to achieve this.
