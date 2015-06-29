ms.ContentId: e586a11a-870f-403b-8af8-4c2931589d26
title: Manage Windows 10 or Windows Server Technical Preview virtual machines with PowerShell Direct 

# Manage Windows 10 or Windows Server Technical Preview virtual machines with PowerShell Direct #
You can use PowerShell Direct to remotely manage a Windows 10 or Windows Server Technical Preview virtual machine from a Windows 10 or Windows Server Technical Preview Hyper-V host. PowerShell Direct allows PowerShell management inside a virtual machine regardless of the network configuration or remote management settings on either the Hyper-V host or the virtual machine. This makes it easier for Hyper-V Administrators to automate and script virtual machine management and configuration.

There are two ways to run PowerShell Direct:  
* Create and exit an PowerShell Direct session using PSSession cmdlets
* Run script or command with Invoke-Command cmdlet

If you're managing older virtual machines, use Virtual Machine Connection (VMConnect) or create a guest network. 

## Create and exit an PowerShell Direct session using PSSession cmdlets ##

1. On the Hyper-V host, open Windows PowerShell as Administrator.
2. Run the following command to get your credentials:

    ```$cred = Get-Credential ```

3. Run the following command to enter a new session.
   
   Connect using the virtual machine name:

    ```Enter-PSSession -VMName <VMName> -Credential $cred ```
    
   You can also connect using the virtual machine GUID:
    
    ```Enter-PSSession -VMGUID <VMGUID> -Credential $cred ```

4. Run whatever commands you need to.
5. When you're done with the PowerShell Direct session, run the following command to close the session:

    ```Exit-PSSession ``` 

## Run script or command with Invoke-Command cmdlet##

You can use the cmdlet **Invoke-Command** to run a pre-determined set of commands on the virtual machine. Here is an example of how you can use the Invoke-Command cmdlet where PSTest is the virtual machine name and the script to run (foo.ps1) is in the script folder on the C:/ drive:

 ```Invoke-Command -VMName PSTest -Credential $cred -FilePath C:\script\foo.ps1 ```

To run a single command, use the -ScriptBlock parameter:

 ```Invoke-Command -VMName PSTest -Credential $cred -ScriptBlock { cmdlet } ```

## What's required to use PowerShell Direct?
* The virtual machine that you want to connect to must be running locally on the host and booted. 
* You must use credentials with Hyper-V administrator role to access the virtual machines.  
You can use the **Get-VM** cmdlet to check that the credentials you're using have the Hyper-V administrator role and to see which VMs are running locally on the host and booted.






	


	
	





