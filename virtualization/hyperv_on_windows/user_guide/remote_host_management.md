ms.ContentId: 7dcd6da0-dd72-422d-8752-5eccc8116e02
title: Managing remote Hyper-V hosts

# Manage Remote Hyper-V Hosts with Hyper-V Manager #

Hyper-V Manager provides a very minimal set of tools needed for diagnosing and managing a small number of local or remote hosts.

This document is a reference on the various configuration details needed for managing remote Hyper-V hosts with Hyper-V Manager.

To connect to a Hyper-V host in Hyper-V Manager, make sure **Hyper-V Manager** is selected in the left hand pane and then select **Connect to Server...** in the right-hand pane.

![](media/HyperVManager-ConnectToHost.png)


## Manage localhost ##
To add localhost to Hyper-V Manager as a Hyper-V host, select the **Local computer** in the **Select Computer** dialogue box.
<!--Add screen shot w/ just that dialog with local computer radio button selected.-->
If a connection can't be established:
*  Make sure the Hyper-V server role is enabled.  See the [walkthrough section for checking compatability](../user_guide/walkthrough_compatability.md).
*  Confirm that your user account is part of the Hyper-V Administrator group.

## Manage a Hyper-V host in your domain ##
Windows 10 greatly expanded the possible combinations of remote connection types.  
Now you can connect to a remote Windows 10 or later host using either the host name or IP address.  Hyper-V Manager now supports alternate credentials as well.  

In order to manage remote Hyper-V hosts, remote management must be enabled on both computers.

You can do this through `System Properties -> Remote Management Settings` or through PowerShell.  
To enable remote management in PowerShell, run the following as Administrator:
``` PowerShell
winrm quickconfig
```



### Managing a remote host in Windows 8 and Windows 8.1



## Manage a Hyper-V host outside your domain (or with no domain) ##
<!--Assuming this isn't done yet...again needs context.-->
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

## Manage a downlevel host
