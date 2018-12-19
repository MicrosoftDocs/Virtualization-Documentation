---
layout:     post
title:      "Live Migration via Constrained Delegation with Kerberos in Windows Server 2016"
date:       2017-02-01 01:16:48
categories: hyper-v
---
#### Introduction

Many Hyper-V customers have run into new challenges when trying to use constrained delegation with Kerberos to Live Migrate VMs in Windows Server 2016. When attempting to migrate, they would see errors with messages like "no credentials are available in the security package," or "the Virtual Machine Management Service failed to authenticate the connection for a Virtual Machine migration at the source host: no suitable credentials available." After investigating, we have determined the root cause of the issue and have updated guidance for how to configure constrained delegation. 

#### Fixing This Issue

Resolving this issue is a simple configuration change in Active Directory when setting up constrained delegation. In [our documentation](https://technet.microsoft.com/en-us/windows-server-docs/compute/hyper-v/deploy/set-up-hosts-for-live-migration-without-failover-clustering), when you reach the fifth instruction in Step 1, select "use any authentication protocol" instead of "use Kerberos only." The other instructions have not changed. 

[![constrained_delegation](https://msdnshared.blob.core.windows.net/media/2017/02/constrained_delegation.png)](https://msdnshared.blob.core.windows.net/media/2017/02/constrained_delegation.png)

#### Root Cause
    
    
    Warning: the next two sections go a bit deep into the internal workings of Hyper-V.

The root cause of this issue is an under the hood change in Hyper-V remoting. Between Windows Server 2012R2 and Windows Server 2016, we shifted from using the Hyper-V WMI Provider *v1* over *DCOM* to the Hyper-V WMI Provider *v2* over *WinRM*. This is a good thing: it unifies Hyper-V remoting with other Windows remoting tools (e.g. PowerShell Remoting). This change matters for constrained delegation because: 

  1. WinRM runs as NETWORK SERVICE, while the Virtual Machine Management Service (VMMS) runs as SYSTEM.
  2. The way WinRM does inbound authentication stores the nice, forwardable Kerberos ticket in a location that is unavailable to NETWORK SERVICE.

The net result is the WinRM cannot access the forwardable Kerberos ticket, and the Live Migration fails on Windows Server 2016. After exploring possible solutions, the best (and fastest) option here is to change the configuration to enable "protocol transition" by changing the constrained delegation configuration as above. 

#### How does this impact security?

You may think this approach is less secure, but in practice, the impact is debatable. When Kerberos Constrained Delegation (KCD) is configured to “use Kerberos only,” the system performing delegation must possess a Kerberos service ticket from the delegated user as evidence that it is acting on behalf of that user. By switching KCD to “use any authentication protocol”, that requirement is relaxed such that a service ticket acquired via Kerberos S4U logon is acceptable. This means that the delegating service is able to delegate an account without direct involvement of the account owner. While enabling the use of any protocol — often referred to as “protocol transition” — is nominally less secure for this reason, the difference is marginal due to the fact that the disabling of protocol transition provides no security promise. Single-sign-on authentication between systems sharing a domain network is simply too ubiquitous to treat an inbound service ticket as proof of anything. With or without protocol transition, the only secure way to limit the accounts that the service is permitted to delegate is to mark those accounts with the “account is sensitive and cannot be delegated” bit. 

#### Documentation

We're working on modifying our documentation to reflect this change. 

John Slack Hyper-V Team PM
