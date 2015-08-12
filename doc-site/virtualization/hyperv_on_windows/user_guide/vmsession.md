ms.ContentId: e586a11a-870f-403b-8af8-4c2931589d26
title: Manage Windows with PowerShell Direct 

# Manage Windows with PowerShell Direct #
You can use PowerShell Direct to remotely manage a Windows 10 or Windows Server Technical Preview virtual machine from a Windows 10 or Windows Server Technical Preview Hyper-V host. PowerShell Direct allows PowerShell management inside a virtual machine regardless of the network configuration or remote management settings on either the Hyper-V host or the virtual machine. This makes it easier for Hyper-V Administrators to automate and script virtual machine management and configuration.

There are two ways to run PowerShell Direct:  
* Create and exit a PowerShell Direct session using PSSession cmdlets
* Run script or command with the Invoke-Command cmdlet

If you're managing older virtual machines, use Virtual Machine Connection (VMConnect) or [configure a virtual network for the virtual machine](http://technet.microsoft.com/library/cc816585.aspx). 

## Create and exit a PowerShell Direct session using PSSession cmdlets
1. On the Hyper-V host, open Windows PowerShell as Administrator.

3. Run the one of the following commands to create a session by using the virtual machine name or GUID:  
``` PowerShell
Enter-PSSession -VMName <VMName>
Enter-PSSession -VMGUID <VMGUID>
```

4. Run whatever commands you need to. These commands run on the virtual machine that you created the session with.
5. When you're done, run the following command to close the session:  
``` PowerShell
Exit-PSSession 
``` 


> Note:  If you're session won't connect, make sure you're using credentials for the virtual machine you're connecting to -- not the Hyper-V host.

## Run script or command with Invoke-Command cmdlet

You can use the **Invoke-Command** cmdlet to run a pre-determined set of commands on the virtual machine. Here is an example of how you can use the Invoke-Command cmdlet where PSTest is the virtual machine name and the script to run (foo.ps1) is in the script folder on the C:/ drive:

 ``` PowerShell
 Invoke-Command -VMName PSTest -FilePath C:\script\foo.ps1 
 ```

To run a single command, use the **-ScriptBlock** parameter:

 ``` PowerShell
 Invoke-Command -VMName PSTest -ScriptBlock { cmdlet } 
 ```

## What's required to use PowerShell Direct?
To create a PowerShell Direct session on a virtual machine,
* The virtual machine must be running locally on the host and booted. 
* You must be logged into the host computer as a Hyper-V administrator.
* You must supply valid user credentials for the virtual machine.
* The host operating system must run Windows 10, Windows Server Technical Preview, or a higher version.  
* The virtual machine must run Windows 10, Windows Server Technical Preview, or a higher version.  

You can use the **Get-VM** cmdlet to check that the credentials you're using have the Hyper-V administrator role and to see which VMs are running locally on the host and booted.

## What can you do with PowerShell Direct?

See [PowerShell Direct snippets](../develop/powershell_snippets.md) for numerous examples of how to use PowerShell Direct in your environment as well as tips and tricks for writing Hyper-V scripts with PowerShell.


