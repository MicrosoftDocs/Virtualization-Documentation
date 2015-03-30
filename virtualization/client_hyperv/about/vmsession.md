ms.ContentId: e586a11a-870f-403b-8af8-4c2931589d26
title: VM management using PowerShell  

# Managing Windows inside virtual machines with Windows PowerShell #

## VM Sessions ##

**Windows 10 hosts to Windows 10 VMs only**

Windows 10 introduces Windows PowerShell remote management from the Hyper-V host directly to virtual machines running on the host. These remote management sessions work regardless of network configuration or the remote management settings on the host or the virtual machine.

To create a Windows PowerShell session directly between the Hyper-V host and the virtual machines running on that host use the `-VMName` or `-VMguid` flags with the supported standard PowerShell remoting commands:

*  Enter-PSSession
*  Invoke-Command



### Enabling VM Sessions ###

These instructions were written against build 10035.  The hope is that it'll all be enabled by default before Technical Preview 2.

To enable VM Sessions in Technical Preview 2 builds:

1.  Enable the Guest Services IC in the VM settings.
  
  **Using the Hyper-V UI**

  ![Selecting the VM Settings](media\vm_edit_VM_settings.png)

  ![Enabling the Guest Services IC](media\vm_enable_guest_services_ic.png)
	
  **Using PowerShell on the Host**

  Make sure you're running PowerShell as an Administrator.
	
	```
	Enable-VMIntegrationService -VMName <YourVMsName> -Name "Guest Service Interface"
	```
	
	
2.  Start the VM Session service inside the VM.
  
  Connect to the virtual machine
  Open the services control window
  ![Starting the VM Session service](media\vm_start_VM_PowerShell_service.png)

3.	Enter a VM Session
  
   Open a Windows PowerShell prompt as Administrator and supply credentials for the virtual machine:
	
	```
	$cred = Get-Credential  #provide a valid guest credential
	```

  Enter a new PSSession using VMName or GUID.
	
	```	
	$session = New-PSSession -VMName PSTest -Credential $cred 
	```

  This also works with Invoke Command.

	```
	$job = Invoke-Command -VMName PSTest -Credential $cred  -ScriptBlock {Set-PSBreakpoint C:\script\foo.ps1 -Line 4; C:\script\foo.ps1} -AsJob -Debug
	
	Start-Sleep -Seconds 1
	Get-Job 
	Debug-Job -Job $job
	```

### Differences between VM Sessions and standard PS Session ###

VM sessions are connected directly through the local memory on the host machine while PS Sessions run over Win RM by default (requiring a network connection with remoting enabled and the correct firewall settings)  VM Sessions only require the VM be located on the box and that the VM Session IC is enabled.



## PS Remoting ##
