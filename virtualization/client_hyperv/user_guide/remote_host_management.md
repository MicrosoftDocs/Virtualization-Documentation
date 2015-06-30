ms.ContentId: 7dcd6da0-dd72-422d-8752-5eccc8116e02
title: Manageing remote Hyper-V hosts

# Managing Remote Hyper-V Hosts with Hyper-V Manager #

Hyper-V Manager is Hyper-V's in-box management tool.  It provides a very minimal set of tools needed for diagnosing and managing a small number of local or remote hosts.

This document is a knitty-gritty reference on the various configuration details required for managing remote Hyper-V hosts with Hyper-V Manager.

To connect to a Hyper-V host with Hyper-V Manager, right click on the Hyper-V Manager icon in the left hand navigation bar (circled in red below) and select "Connect to Server..."

![](media/HyperVManager-ConnectToHost.png)

## Managing localhost ##
To add localhost to Hyper-V Manager as a Hyper-V host, select the "local computer" radio button (circled in black) from the "select Computer" dialogue box.

If a connection can't be established, try:
*  making sure the Hyper-V server role is enabled.  See `[link to quickstart guide`].
*  confirming your user account is part of the Hyper-V Administrator group.

## Managing a Hyper-V host in your domain ##
Combinations of connections with both Kerberos and CredSSP:
*  NetBIOS host name same user
*  NetBIOS, Alternte Credentials
*  IP, same name
*  IP, Alternate Credentials

## Managing a Hyper-V host outside your domain (or with no domain) ##
Local Hyper-V Host:
1.	Enable-PSRemoting
Came back with netowork set to public.
Ran
Set-NetConnectionProfile -Name "name" -NetworkCategory private
2. Set-Item WSMan:\localhost\Client\TrustedHosts * -Force
3. Enable-WSManCredSSP -Role client -DelegateComputer *

For workgroup only:
1. (should be done) Computer Policy\Administrative Templates\System\Credentials Delegation\Allow Delegating Fresh Credentials → Set to enabled and add WSMAN/* ].  To list of computers, check the box forConcatenate OS defaults with input above

2. Computer Policy\Administrative Templates\System\Credentials Delegation\Allow Delegating Fresh Credentials with NTLM-only server authentication → Set to enabled and add WSMAN/* to list of computers, check the box for Concatenate OS defaults with input above
3. Computer Policy\Administrative Templates\Windows Components\Windows Remote Management (WinRM)\WinRM Client\Allow CredSSP authentication → Set to enabled

Remote Hyper-V Host:
1. Disabled the firewall :)
2. Enable-PSRemoting
3. Set-Item WSMan:\localhost\Client\TrustedHosts * -Force
So that's the demo-only instructions I used.  Replace * and turn off firewall with a single computer and letting credssp and winRM through
