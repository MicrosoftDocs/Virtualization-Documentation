ms.ContentId: e586a11a-870f-403b-8af8-4c2931589d26
title: Manage Windows 10 or Windows Server Technical Preview virtual machines with PowerShell Direct 

# Manage Windows 10 or Windows Server Technical Preview virtual machines with PowerShell Direct #
You can use PowerShell Direct to remotely manage a Windows 10 or Windows Server Technical Preview virtual machine from a Windows 10 or Windows Server Technical Preview Hyper-V host. These PowerShell Direct sessions work regardless of the network configuration or remote management settings on the host or virtual machine. This makes it easier to automate and script virtual machine management in Hyper-V. To get started, create a PowerShell Direct session with the virtual machine from the host.

## Create a PowerShell Direct session##

1. On the Hyper-V host, open Windows PowerShell as an administrator.
2. Run the following command to get your credentials:

    ```$cred = Get-Credential  ```

3. Run the following command to create the session by using the virtual machine name:

    ```Enter-PSSession -VMName <VMName> -Credential $cred  ```

Or you can create the session by using the virtual machine GUID:

    ```Enter-PSSession -VMGUID <VMGUID> -Credential $cred ```

You can also use the cmdlet **Invoke-Command** to do the same thing. Here is an example of how you can use the Invoke-Command cmdlet where PSTest is the virtual machine name and the script to run is in the script folder on the C:/ drive:


    ```Invoke-Command -VMName PSTest -Credential $cred  -FilePath C:\script\foo.ps1  ```

Note: The virtual machine that you want to connect to must be running locally on the host and booted. You can use the **Get-VM** cmdlet to check..

## Exit a PowerShell Direct session##
When you're done with the PowerShell Direct session, run the following command to close the session:

 ```Exit-PSSession  ```






	


	
	





