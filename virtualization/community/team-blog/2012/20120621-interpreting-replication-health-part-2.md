---
title:      "Interpreting Replication Health - Part 2"
description: Describes how administrators can monitor the health of the replicating VM's using the Replication Health attribute - Part 2.
author: mattbriggs
ms.author: mabrigg
date:       2012-06-21 05:20:00
ms.date: 06/21/2012
categories: hvr
---
# Interpreting Replication Health – Part 2
#### Continuing from where we left off the last [time](https://blogs.technet.com/b/virtualization/archive/2012/06/15/interpreting-replication-health-part-1.aspx)…

#### Q1: The Replication Health pane has loads of information, how do I  interpret these attributes?

[![Monitoring-IIS-Normal-Primary_thumb4](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7510.Monitoring-IIS-Normal-Primary_thumb4_thumb_42C203DC.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3465.Monitoring-IIS-Normal-Primary_thumb4_7118F8D8.png) |   |   | [![image_thumb9](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3872.image_thumb9_thumb_4ADBC0E2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6507.image_thumb9_46CEE25F.png)  
---|---|---|---  
  
 

I thought you would never ask ![Smile](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4540.wlEmoticon-smile_20FB4CAD.png)

  1. On both the Primary and Replica VM, the following attributes are displayed:



> Replication State | Refers to the **current** state of the replicating VM. The set of values are captured in Q3 under the **UI** column, in the previous [post](https://blogs.technet.com/b/virtualization/archive/2012/06/15/interpreting-replication-health-part-1.aspx)  
> ---|---  
> Replication Type | Indicates whether the VM a Primary VM or a Replica VM  
> Current Primary Server | Provides the FQDN of the server on which the primary VM resides  
> Current Replica Server | Provides the FQDN of the destination server on which the replica VM resides  
> Replication Health | Refers to the health of the replicating VM. The set of possible values are Normal, Warning or Critical.  
> From Time | The start time for the **monitoring interval**  
> To Time | This calls out the current time or time at which this window was launched  
  
> The statistics below are collected between ‘From Time’ and ‘To Time’

> **Average size** |  The average size of the replica file (sent in every **replication interval** )  
> ---|---  
> **Maximum size** |  Maximum size of the replica file  
> **Average Latency** |  Average time taken to transfer the replica file in a replication interval  
> **Errors encountered** |  Number of errors encountered (eg: network disconnects, resynchronization etc.)  
> **Successful replication cycles** |  Hyper-V Replica attempts to send the replica file every 5 mins (=>the number of replication cycles in an hour is 12). This counter captures the number of successful replication attempts.  
  
  
  * **Last synchronized at:** This refers to the last time the replica was sent to the primary server (or) received and applied in the replica server. The difference between the current time and this value, indicates the loss of data (measured in time) if a failover is initiated.




   2\. On the **primary** VM:

  * **Size of data yet to be replicated:** This refers to the size of the replica file which is being tracked but not sent to the replica server yet. The value signifies the loss of data (measured in MBs) if a failover is initiated on the replica VM.



   3\. On the **Replica** VM:

  * **Test failover status:** If Test failover is enabled at the time of measuring the statistics, then this attribute is set to  ‘Running’ – else, it is set to ‘Not Running’
  * **Last Test Failover initiated at:** This refers to the wall-clock time when the last test-failover operation was initiated.




   4\. Buttons:

  * Refresh: Refreshes the statistics by updating the ‘To time’.
  * Reset Statistics: Zeros out the statistics for the current interval and starts afresh. You would typically used this option after rectifying a problem
  * Save As: Saves the monitoring information as a CSV file which can be archived



**Q2: Some follow-up questions – what is the replication interval? How can I change it?**

Hyper-V Replica tracks the writes to the VM in a log file. This log file is sent every 5mins which is also called the replication interval. Administrators **cannot** configure this interval.

Due to network or storage issues or due to excessive churn in the VM, the replica file transfer _might_ take more than 5mins to reach the destination server (and applied to the replica VM). Hyper-V Replica has inbuilt semantics to handle such situations by delaying the transfer of the next replica file.  This impacts the ‘ **Successful Replication Cycles** ’ and **Average Latency** statistics.

****  **Q3: What is the Monitoring Interval and Monitoring Start Time and how do I get/set this?**

The monitoring interval is a server level attribute which refers to the interval for which the replication statistics are captured and computed. This attribute can be viewed from **Get-VMReplicationServer**
    
```powershell
    PS C:\Windows\system32> Get-VMReplicationServer | select monitoringinterval, monitoringstarttime
```
The **MonitoringInterval** refers to the time interval for which the replication statistics should be collected. By default this is set to 12 hrs. The minimum value which can be set is 1hr and the maximum value is 7 days. It is recommended that a reasonably high value is used as smaller intervals might lead to incorrect conclusions.

The **MonitoringStartTime** refers to the time at which Hyper-V Replica should start monitoring the replicating VM. The input is denoted in a 24hr clock and is set to 9AM local time by default.

Both these values can be changed using the **Set-VMReplicationServer.** Eg: To modify the Monitoring interval to 12hrs and start time to 6AM, issue the following cmdlet:
    
```powershell
    Set-VMReplicationServer -MonitoringStartTime 06:00:00 -MonitoringInterval 12:00:00
```
In this example, when a VM is enabled for replication at 2pm, statistics are collected from 2pm to 6pm on the same day and health is reflected for this interval. The statistics are then reset and collected 6pm to 6am the next day and health is reflected for this interval.

#### Q4: Are the statistics from the previous monitoring intervals available?

Yes. In the event viewer, under the Hyper-V VMMS node, an Information message is recorded. The event ID for this is **29174**.

[![image_thumb1](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1715.image_thumb1_thumb_29813CA8.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3056.image_thumb1_15658F6E.png)

 

**Q5: Is the health attribute preserved when the VM migrates?**

Yes, when the VM migrates from one node to another, the replication statistics are preserved and used in the new node.

**Q6: I manage a N-node-cluster with many replicating VMs, I (obviously) cannot click on each VM to know it ’s health. Is there an easier way to manage from UI?**

Yes! From the Failover Cluster Manager you can run a query to get VMs with a specific replication Health. Under **Roles** , click on ‘ **Add Criteria** ’, choose ‘ **Replication Health** ’ and specify the criteria (Critical/Normal/Warning)

[![image_thumb51_thumb](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6661.image_thumb51_thumb_thumb_6CEE5F6C.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4442.image_thumb51_thumb_7ABE14B6.png) |   | [![image_thumb71_thumb](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3022.image_thumb71_thumb_thumb_6BAC573E.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2451.image_thumb71_thumb_5556B1F9.png)  
---|---|---  
  
>  

**Q7: Is there any such provision in the Hyper-V Manager?**

You can add the column ‘Replication Health’ from the Add/Remove Column option in Hyper-V Manager

[![image_thumb3](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3441.image_thumb3_thumb_060EDB07.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5001.image_thumb3_0201FC84.png) |   | [![image_thumb2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8228.image_thumb2_thumb_3562E142.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5516.image_thumb2_38090C42.png)  
---|---|---  
  
 

**Q8: Is there a PowerShell cmdlet to get all this information?**

Yup, **Measure-VMReplication** captures the health and state related information
    
```powershell
    PS E:\Windows\system32> Measure-VMReplication -vmname SampleVM | select ReplicationHealth, ReplicationHealthDetails | fl
    
    
     
    
    
     
    
    
    ReplicationHealth        : Critical
    
    
    ReplicationHealthDetails : {Replication  for virtual machine 'SampleVM' is in error. Fix the error(s) and resume
    
    
                               replication., More than 20 percent of replication cycles have been missed for virtual
    
    
                               machine 'SampleVM'. Replication might be encountering problems., Replica virtual machine
    
    
                               'SampleVM' is behind the primary by more than an hour.}
```
#### Q9: Is this sufficient to build an alerting mechanism?

Yes, using the cmdlet, you can set up custom warnings, send mail, run it frequently from Task scheduler etc. The options are limitless.

Our resident PS expert **Rahul Razdan,** has this nifty PS script which sends out a mail detailing the health of the replicating VM.

```powershell
    Add-PSSnapin Microsoft.Exchange.Management.Powershell.Admin -erroraction silentlyContinue
    
    
     
    
    
     
    
    
    ##### Configuration Section Starts ##### 
    
    
     
    
    
    $SMTPName = "TTExchange.TailspinToys.com"
    
    
    $EmailMessage = new-object Net.Mail.MailMessage
    
    
    $SMTPServer = new-object Net.Mail.SmtpClient($SMTPName)
    
    
    $EmailMessage.From = "TonyV@tailspintoys.com"
    
    
    $EmailMessage.To.Add("JimH@tailspintoys.com")
    
    
    $EmailMessage.To.Add("TonyV@tailspintoys.com")
    
    
     
    
    
    ##### Configuration Section Ends##### 
    
    
            
    
    
     
    
    
    #Build a nice file name
    
    
    $date = get-date -Format M_d_yyyy_hh_mm_ss
    
    
    $csvfile = ".\AllAttentionRequiringVMs_"+$date+".csv"
    
    
     
    
    
     
    
    
    #Build the header row for the CSV file
    
    
    $csv = "VM Name, Date, Server, Message `r`n"
    
    
     
    
    
     
    
    
    #Find all VMs that require your attention
    
    
    $VMList = get-vm | where {$_.ReplicationHealth -eq "Critical" -or $_.ReplicationHealth -eq "Warning"}
    
    
     
    
    
     
    
    
    #Loop through each VM to get the corresponding events
    
    
    ForEach ($VM in $VMList)
    
    
        {
    
    
            $VMReplStats = $VM | Measure-VMReplication
    
    
     
    
    
     
    
    
            #We should start getting events after last successful replication. Till then replication was happening.
    
    
            $FromDate = $VMReplStats.LastReplicationTime 
    
    
     
    
    
     
    
    
            #This string will filter for events for the current VM only
    
    
            $FilterString = "<QueryList><Query Id='0' Path='Microsoft-Windows-Hyper-V-VMMS-Admin'><Select Path='Microsoft-Windows-Hyper-V-VMMS-Admin'>*[UserData[VmlEventLog[(VmId='" + $VM.ID + "')]]]</Select></Query></QueryList>" 
    
    
     
    
    
            
    
    
            $EventList = Get-WinEvent -FilterXML $FilterString  | Where {$_.TimeCreated -ge $FromDate -and $_.LevelDisplayName -eq "Error"} | Select -Last 3
    
    
     
    
    
            
    
    
            #Dump relevant information to the CSV file
    
    
            foreach ($Event in $EventList)
    
    
                {
    
    
                    If ($VM.ReplicationMode -eq "Primary") 
    
    
                        {
    
    
                            $Server = $VMReplStats.PrimaryServerName
    
    
                        }
    
    
                    Else
    
    
                        {
    
    
                            $Server = $VMReplStats.ReplicaServerName
    
    
                        }
    
    
                    $csv +=$VM.Name + "," + $Event.TimeCreated + "," + $Server + "," + $Event.Message +"`r`n"
    
    
                }
    
    
        } 
    
    
     
    
    
     
    
    
    #Create a file and dump all information in CSV format
    
    
    $fso = new-object -comobject scripting.filesystemobject
    
    
    $file = $fso.CreateTextFile($csvfile,$true)
    
    
    $file.write($csv)
    
    
    $file.close()
    
    
     
    
    
     
    
    
    #If there are VMs in critical health state, send an email to me and my colleague
    
    
    If ($VMList -and $csv.Length -gt 33)
    
    
        {
    
    
            $Attachment = new-object Net.Mail.Attachment($csvfile)
    
    
            $EmailMessage.Subject = "[ATTENTION] Replication requires your attention!"
    
    
            $EmailMessage.Body = "The report is attached."
    
    
            $EmailMessage.Attachments.Add($Attachment)
    
    
            $SMTPServer.Send($EmailMessage)
    
    
            $Attachment.Dispose()
    
    
        }
    
    
    Else
    
    
        {
    
    
            $EmailMessage.Subject = "[NORMAL] All VMs replicating Normally!"
    
    
            $EmailMessage.Body = "All VMs are replicating normally. No further action is required at this point."
    
    
            $SMTPServer.Send($EmailMessage)
    
    
        }
```
The script which works for a standalone node can be easily extended to query across a cluster (using **Get-ClusterNode** ) **.** Give it a shot in your deployment!

In summary, it is extremely important to monitor the health of the replicating VMs. The system has inbuilt retry semantics to address transient issues (eg: network outage) but there are certain events which require your intervention (eg: disk issues). Analyzing the replication health from time to time will help you identify and fix these issues.
