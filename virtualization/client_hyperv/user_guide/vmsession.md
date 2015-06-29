ms.ContentId: e586a11a-870f-403b-8af8-4c2931589d26
title: Manage Windows 10 or Windows Server Technical Preview virtual machines with PowerShell Direct 

# Manage Windows 10 or Windows Server Technical Preview virtual machines with PowerShell Direct #
You can use PowerShell Direct to remotely manage a Windows 10 or Windows Server Technical Preview virtual machine from a Windows 10 or Windows Server Technical Preview Hyper-V host.  

If you're managing older virtual machines, see: `[this article about VMConnect or how to create a guest network or something`]

PowerShell Direct allows PowerShell management inside a virtual machine regardless of the network configuration or remote management settings on either the Hyper-V host or the virtual machine. This makes it easier for Hyper-V Administrators to automate and script virtual machine management and configuration.

There are two ways to run PowerShell Direct:  
1. As an interactive PowerShell connection using PSSession
2. With command (or script) execution using Invoke-Command

To get started, create an interactive PowerShell Direct connection with the virtual machine from the host.

## Create an interactive PowerShell Direct session ##

1. On the Hyper-V host, open Windows PowerShell as Administrator.
2. Run the following command to get your credentials:

    ```$cred = Get-Credential ```

3. Run the following command to enter a new interactive session.
   
   Connect using the virtual machine name:

    ```Enter-PSSession -VMName <VMName> -Credential $cred ```
    
   You can also connect using the virtual machine GUID:
    
    ```Enter-PSSession -VMGUID <VMGUID> -Credential $cred ```

4. Run whatever commands you need.
5. When you're done with the PowerShell Direct session, run the following command to close the session:

    ```Exit-PSSession ``` 

## Command execution with PowerShell Direct ##

You can use the cmdlet **Invoke-Command** to run a pre-determined set of commands on the virtual machine. Here is an example of how you can use the Invoke-Command cmdlet where PSTest is the virtual machine name and the script  to run (foo.ps1) is in the script folder on the C:/ drive:

 ```Invoke-Command -VMName PSTest -Credential $cred -FilePath C:\script\foo.ps1 ```

Single commands can be executed direclty as well:

 ```Invoke-Command -VMName PSTest -Credential $cred -ScriptBlock { cmdlet } ```


Note: The virtual machine that you want to connect to must be running locally on the host and booted. You must be running as a Hyper-V administrator to access VMs.  You can use the **Get-VM** cmdlet to check if you're running as Hyper-V administrator and to see which VMs are available.






	


	
	





