ms.ContentId: c0da5ae7-69b6-49a5-934a-6315b5538d6c
title: Managing integration services

# Managing integration service
Welcome to the in-depth reference for everything integration service related.

## Integration services and what they do
Integration services (often called integration components) are services that allow virtual machines to communicate with the Hyper-V host.  
Some of the tasks integration services provide include:
* Time synchronization
* Operating system shutdown
* Data exchange (KVP)
* Backup (Volume Shadow Copy)
* Heartbeat 
* Guest Services
  * Guest File Copy
  * PowerShell Direct

Many of these services are conviniences (such as guest services) while others can be quite important to the guest operating system's ability to fucntion correctly (time synchronization) -- the list above is loosely organized by importance on a fresh Hyper-V installation.

Most of the coplexity in integration service management comes from spanning the boundary between Hyper-V host and the guest operating systems that run on it.  Some integration service management actions require Hyper-V Administrator permissions on the host, others require Administrator credentials in the guest. Integration services also have different availability and behavior depeding on both the guest and host operating systems.  They are the only item in the guest operating system that is aware of the host operating system; historically, they had to be matched to the host operating system.

With all of this in mind, installing, updating, and enabling/disabling integration services can be difficult to understand.  This article aims to demystify the finer points of managing integration services on any supported Hyper-V environment.

## What is "up to date" for integration services


## Enable or disable integration services from the Hyper-V host


### Managing integration services with Hyper-V Manager

### Managing integration services with PowerShell

IC Version is deprecated in Windows 10 and Server 16.

## Disable integration services from the guest operating system
![](media/HVServices.png) 

## Getting integration services

## Install integration components on offline virtual machines

