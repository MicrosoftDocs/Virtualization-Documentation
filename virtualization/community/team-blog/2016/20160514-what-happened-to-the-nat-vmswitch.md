---
title: What Happened to the “NAT” VMSwitch?
description: Blog post that discusses the NAT Hyper-V Virtual Switch Type's removal and highlights the changes caused by the VMSwitch's removal.
author: scooley
ms.author: scooley
date: 2016-05-14 00:00:50
ms.date: 07/31/2019
categories: hyper-v
---
# What Happened to the "NAT" VMSwitch?

**Author: Jason Messer** 

Beginning in Windows Server Technical Preview 3, our users noticed a new Hyper-V Virtual Switch Type – “NAT” – which was introduced to simplify the process of connecting Windows containers to the host using a private network. This allowed network traffic sent to the host to be redirected to individual containers running on the host through network and port address translation (NAT and PAT) rules. Additional users began to use this new VM Switch type not only for containers but also for ordinary VMs to connect them to a NAT network. While this may have simplified the process of creating a NAT network and connecting containers or VMs to a vSwitch, it resulted in confusion and a layering violation in the network stack. Beginning in Windows Server Technical Preview 5 and with recent Windows Insider Builds, the “NAT” VM Switch Type has been removed to resolve this layering violation. In the OSI (Open Systems Interconnect) model, both physical network switches and virtual switches operate at Layer-2 of the network stack without any knowledge of IP addresses or ports. These switches simply forward packets based on the Ethernet headers (i.e. MAC addresses) in the Layer-2 frame. NAT and PAT operate at Layers-3 and 4 respectively of the network stack.  
|Layer | Function | Example |
|---|---|---|  
Application (7) | Network process | HTTP, SMTP, DNS  
Presentation (6) | Data representation and encryption | JPG, GIF, SSL, ASCII  
Session (5) | Interhost communication | NetBIOS  
Transport (4) | End-to-End Connections | TCP, UDP (Ports)  
Network (3) | Path determination and routing based on IP addresses | Routers  
Data Link (2) | Forward frames based on MAC addresses | 802.3 Ethernet, Switches  
Physical (1) | Send data through physical signaling | Network cables, NIC cards  
  Creating a “NAT” VM Switch type actually combined several operations into one which can still be done today (detailed instructions can be found [here](https://msdn.microsoft.com/virtualization/hyperv_on_windows/user_guide/setup_nat_network)): 

  * Create an “internal” VM Switch
  * Create a Private IP network for NAT
  * Assign the default gateway IP address of the private network to the internal VM switch Management Host vNIC

In Technical Preview 5 we have also introduced the Host Network Service (HNS) for containers which is a servicing layer used by both Docker and PowerShell management surfaces to creates the required network “plumbing” for new container networks. A user who wants to create a NAT container network through docker, will simply execute the following: 

`c:\> docker network create -d nat MyNatNetwork`

and HNS will take care of the details such as creating the internal vSwitch and NAT. Looking forward, we are considering how we can create a single arbitrator for all host networking (regardless of containers or VMs) so that these workflows and networking primitives will be consistent. ~ Jason
