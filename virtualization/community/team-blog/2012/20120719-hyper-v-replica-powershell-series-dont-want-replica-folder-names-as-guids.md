---
layout:     post
title:      "Hyper-V Replica Powershell Series&#58; Don’t want Replica folder names as GUIDs!"
date:       2012-07-19 23:04:00
categories: authorization-table
---
When you enable replication on a virtual machine, the Replica virtual machine files are created under the location specified by you in the Replica server configuration on the Replica side. Under the specified location, the files are created under a folder structure that looks like:

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7127.image_thumb_04F85A16.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/0513.image_79AF45D8.png)

The folders are named using GUIDs.

> Why are GUIDs used to name the folders?
> 
> A fair question to ask. The same Replica server could be receiving replication from multiple primary servers and there is likelihood that two virtual machines being replicated from different primary servers could have same name, or have virtual hard disks with the same name. Hence, the folder names are used as GUIDs to ensure uniqueness is maintained.

Instead of this default folder structure, you may want to have a simpler folder structure as you are sure that you will not get such name conflicts in your setup. You may want a folder structure that looks like:

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8130.image_thumb_0EFCD574.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4314.image_5C0D450C.png)

The good news is that you can achieve this using simple steps ![Smile](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1754.wlEmoticon-smile_2647D9E5.png). Here are the steps that could accomplish this for you:

  1. Enable replication for the virtual machine, and ensure initial replication is not started immediately (You can choose to schedule the initial replication for a later time)

  2. Once Replica virtual machine is created, use the **Move** wizard to move the storage of the virtual machine to the path of your choice (Storage migration)

  3. Once the storage migration is complete, you can start the initial replication for the virtual machine




You can do the same steps using Powershell. Here is a sample script that accomplishes this task for you. This script assumes both primary and replica sides to be clustered setups. This script also assumes [certificate-based authentication](http://blogs.technet.com/b/virtualization/archive/2012/07/16/hyper-v-replica-certificate-based-authentication-in-windows-server-2012-rc.aspx) being used. You can easily customize the script if you have a different environment.
    
    
    Function Enable-VMReplicationCustomStorageOneLocationUsingCertificate
    
    
        {
    
    
            [CmdletBinding()]
    
    
            Param
    
    
                (
    
    
                    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)] [string]$VMName,
    
    
                    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)] [string]$PrimaryCluster,
    
    
                    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)] [string]$ReplicaCluster,
    
    
                    [Parameter(Mandatory=$FALSE,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)] [string]$AllowedPrimaryServer
    
    
                )
    
    
            PROCESS 
    
    
                {   
    
    
                    $PrimaryOwnerGroup = Get-ClusterResource -Cluster $PrimaryCluster | where {$_.ResourceType -eq "Virtual Machine Replication Broker"} 
    
    
                    $PrimaryBrokerName = Get-ClusterResource -Cluster $PrimaryCluster | where {$_.ResourceType -eq "Network Name" -and $_.OwnerGroup -eq $PrimaryOwnerGroup.OwnerGroup} | Get-ClusterParameter -name "DNSName"
    
    
                    $PrimaryBrokerDomain = get-item -path env:userdnsdomain
    
    
                    $PrimaryBrokerFQDN = $PrimaryBrokerName.Value + "." + $PrimaryBrokerDomain.Value
    
    
     
    
    
                    $ReplicaOwnerGroup = Get-ClusterResource -Cluster $ReplicaCluster | where {$_.ResourceType -eq "Virtual Machine Replication Broker"} 
    
    
                    $ReplicaBrokerName = Get-ClusterResource -Cluster $ReplicaCluster | where {$_.ResourceType -eq "Network Name" -and $_.OwnerGroup -eq $ReplicaOwnerGroup.OwnerGroup} | Get-ClusterParameter -name "DNSName"
    
    
                    $ReplicaBrokerDomain = get-item -path env:userdnsdomain
    
    
                    $ReplicaBrokerFQDN = $ReplicaBrokerName.Value + "." + $ReplicaBrokerDomain.Value
    
    
     
    
    
                    #Get the Primary VM object from the Primary Server
    
    
                    $PrimaryVM = Get-ClusterGroup -Cluster $PrimaryCluster | ?{ $_ | Get-ClusterResource | ?{ $_.ResourceType -like "Virtual Machine" } } | get-vm | where {$_.Name -eq $VMName}
    
    
     
    
    
                    #Get the Replica server configuration so that user doesnt have to explicitly provide the Replica port
    
    
                    $ReplicaServerConfig = Get-VMReplicationServer -ComputerName $ReplicaBrokerFQDN
    
    
                    
    
    
                    #Determine whether the Replica allows all servers to replicate, or specific ones
    
    
                    If ($ReplicaServerConfig.AllowAnyServer)
    
    
                        {
    
    
                            $ReplicaPath = $ReplicaServerConfig.DefaultStorageLocation + "\" + $VMName
    
    
                        }
    
    
                    Else
    
    
                        {
    
    
                            IF (!$AllowedPrimaryServer) {Throw "Allowed Primary Server of the Replication authorization entry on Replica cluster is required to decide the path on which Replica files should be created. You can find the Allowed Primary Server by following cmdlet: Get-VMReplicationAuthorizationEntry -ComputerName " + $ReplicaBrokerFQDN}
    
    
                            $ReplicaAuthEntry = Get-VMReplicationAuthorizationEntry -ComputerName $ReplicaBrokerFQDN -AllowedPrimaryServer $AllowedPrimaryServer
    
    
                            $ReplicaPath = $ReplicaAuthEntry.ReplicaStorageLocation + "\" + $VMName
    
    
                        }
    
    
                    
    
    
                    $PersonalCert = $NULL
    
    
                    $Date = Get-Date
    
    
                    $PersonalCert = Get-ChildItem -Path Cert:\LocalMachine\My | ?{$_.DNSNameList.Unicode -contains $PrimaryBrokerFQDN}
    
    
                    If (!$PersonalCert)
    
    
                        {
    
    
                            $PersonalCertList = Get-ChildItem -Path Cert:\LocalMachine\My | where {$_.subject -like "*"+$PrimaryBrokerFQDN+"*" -and $_.EnhancedKeyUsageList.friendlyname -contains "Server Authentication" -and $_.EnhancedKeyUsageList.friendlyname -contains "Client Authentication" -and $_.NotAfter -gt $Date -and $_.HasPrivateKey -eq $TRUE}
    
    
                            foreach ($PersonalCertIterator in $PersonalCertList)
    
    
                            {
    
    
                                $RootCert = Get-ChildItem -Path Cert:\LocalMachine\Root | where {$_.subject -like "*"+$PersonalCertIterator.Issuer+"*"}
    
    
                                If ($RootCert) 
    
    
                                    {
    
    
                                        "Found the cert: " + $PersonalCertIterator.Thumbprint
    
    
                                        $PersonalCert = $PersonalCertIterator
    
    
                                        Break
    
    
                                    } 
    
    
                            }
    
    
                        }
    
    
                    If (!$PersonalCert) {throw "Error: No valid certificate found."}
    
    
                                    
    
    
                    #Enable replication using Kerberos authentication
    
    
                    Enable-VMReplication -VM $PrimaryVM -ReplicaServerName $ReplicaBrokerFQDN -ReplicaServerPort $ReplicaServerConfig.CertificateAuthenticationPort -AuthenticationType Certificate -CertificateThumbprint $PersonalCert.Thumbprint
    
    
     
    
    
                    #Get the Replica VMs object. This is the VM whose storage needs to be migrated
    
    
                    $ReplicaVM = Get-ClusterGroup -Cluster $ReplicaCluster | ?{ $_ | Get-ClusterResource | ?{ $_.ResourceType -like "Virtual Machine" } } | get-vm | where {$_.Name -eq $VMName}
    
    
                                    
    
    
                    #Move the Replica VHDs to chosen locations
    
    
                    $ReplicaVM | Move-VMStorage -DestinationStoragePath $ReplicaPath
    
    
                    
    
    
                    #Now start the initial replication. This cmdlet uses online mode and starts initial replication immediately. You can modify it to choose any other mode, or schedule
    
    
                    Start-VMInitialReplication $PrimaryVM
    
    
     
    
    
                }
    
    
        }

 

Once you run this script on you primary cluster, you will get a function that can then be used to enable replication to get the desired folder structure on the Replica cluster. Here is an example usage for this script:
    
    
    Enable-VMReplicationCustomStorageOneLocationUsingCertificate -VMName MyVM -PrimaryCluster MySeattleCluster -ReplicaCluster MyLondonCluster -AllowedPrimaryServer MySeattleBroker.contoso.com

Here **MySeattleCluster** is the name of the primary cluster, **MyLondonCluster** is the name of the replica cluster, and **MyLondonCluster** authorizes **MySeattleCluster** to replicate by an authorization entry where **AllowedPrimaryServer** value is **MySeattleBroker.contoso.com**

The certificate for replication is queried from the installed certificates. The first certificate valid for replication is picked. If you want to explicitly specify a certificate, you can replace **$PersonalCert.Thumbprint** used in the **Enable-Replication** cmdlet to the thumbprint of the certificate you want to use.

Here is a sample script for stand-alone primary replicating to stand-alone replica server using kerberos authentication:
    
    
    Function Enable-VMReplicationCustomStorageOneLocation
    
    
        {
    
    
            [CmdletBinding()]
    
    
            Param
    
    
                (
    
    
                    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)] [string]$VMName,
    
    
                    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)] [string]$PrimaryServer,
    
    
                    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)] [string]$ReplicaServer,
    
    
                    [Parameter(Mandatory=$FALSE,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)] [string]$AllowedPrimaryServer
    
    
                )
    
    
            PROCESS 
    
    
                {   
    
    
                    #Get the Primary VM object from the Primary Server
    
    
                    $PrimaryVM = get-VM $VMName -ComputerName $PrimaryServer
    
    
     
    
    
                    #Get the Replica server configuration so that user doesnt have to explicitly provide the Replica port
    
    
                    $ReplicaServerConfig = Get-VMReplicationServer -ComputerName $ReplicaServer
    
    
     
    
    
                    #Determine whether the Replica allows all servers to replicate, or specific ones
    
    
                    If ($ReplicaServerConfig.AllowAnyServer)
    
    
                        {
    
    
                            $ReplicaPath = $ReplicaServerConfig.DefaultStorageLocation + "\" + $VMName
    
    
                        }
    
    
                    Else
    
    
                        {
    
    
                            IF (!$AllowedPrimaryServer) {Throw "Allowed Primary Server of the Replication authorization entry on Replica server is required to decide the path on which Replica files should be created. You can find the Allowed Primary Server by following cmdlet: Get-VMReplicationAuthorizationEntry -ComputerName " + $ReplicaServer}
    
    
                            $ReplicaAuthEntry = Get-VMReplicationAuthorizationEntry -ComputerName $ReplicaServer -AllowedPrimaryServer $AllowedPrimaryServer
    
    
                            $ReplicaPath = $ReplicaAuthEntry.ReplicaStorageLocation + "\" + $VMName
    
    
                        }
    
    
                    
    
    
                    #Enable replication using Kerberos authentication
    
    
                    Enable-VMReplication -VM $PrimaryVM -ReplicaServerName $ReplicaServer -ReplicaServerPort $ReplicaServerConfig.KerberosAuthenticationPort -AuthenticationType Kerberos
    
    
     
    
    
                    #Get the Replica VMs object. This is the VM whose storage needs to be migrated
    
    
                    $ReplicaVM = get-VM $VMName -ComputerName $ReplicaServer                         
    
    
                                    
    
    
                    #Move the Replica VHDs to chosen locations
    
    
                    $ReplicaVM | Move-VMStorage -DestinationStoragePath $ReplicaPath
    
    
                    
    
    
                    #Now start the initial replication. This cmdlet uses online mode and starts initial replication immediately. You can modify it to choose any other mode, or schedule
    
    
                    Start-VMInitialReplication $PrimaryVM
    
    
     
    
    
                }
    
    
        }

 

For both these scripts, if your Replica side allows any authenticated server to replicate, as opposed to allowing specific servers, you should skip the **AllowedPrimaryServer** parameter. The script will then use the default storage location returned by the Get-VMReplicationServer cmdlet as the base path for creating the Replica virtual machine files.

Here are some cmdlets that will help you query how you have set up the Replica side for allowing incoming replication:

> On the Replica side, you could have authorized all authenticated servers to replicate, in which case the location where Replica virtual machine files will get created can be queried using the Get-VMReplicationServer cmdlet:
>     
>     
>     Get-VMReplicationServer -ComputerName MySeattle.contoso.com | Select ReplicationAllowedFromAnyServer, DefaultStorageLocation | fl
> 
> If the ReplicationAllowedFromAnyServer value returned by this cmdlet is **FALSE** , then you have chosen to allow only specific primary servers to replicate to the given Replica server (or cluster). In this case, the default location for creating Replica virtual machine files can be queried using the Get-VMReplicationAuthorizationEntry:
>     
>     
>     Get-VMReplicationAuthorizationEntry -ComputerName MySeattle.contoso.com
> 
> This will return all authorization entries on the specified Replica server. To query the authorization entry corresponding to a specific primary server, you can filter the query using the –AllowedPrimaryServer parameter. Specify the value that corresponds to the primary server from which you would be replicating virtual machines, e.g., 
>     
>     
>     Get-VMReplicationAuthorizationEntry -ComputerName MySeattle -AllowedPrimaryServer MyLondon.contoso.com

 

You can customize the scripts are per your specific setup. Keep watching this space for more such utility scripts.
