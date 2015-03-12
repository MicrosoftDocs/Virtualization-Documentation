ms.ContentId: e586a11a-870f-403b-8af8-4c2931589d26
title: VM management using PowerShell  

# Managing Virtual Machines with PowerShell #

## VM Sessions ##

** Windows 10 hosts to Windows 10 VMs only**

Windows 10 and later offer PowerShell remoting from the Hyper-V host directly to virtual machines running on the host.  VM Sessions work regardless of network configuration, remote management setting, etc. on either the host or the virtual machine.

To create a PowerShell session directly between the Hyper-V host and the virtual machines running on that host using the `-VMName` or `-VMguid` flags with several standard PowerShell remoting commands.

**Supported commands:**
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
	Enable-VMIntegrationService -VMName <YourVM’s Name> -Name "Guest Service Interface"
	```
	
	
2.  Start the VM Session service inside the VM.
  
  Connect to the virtual machine
  Open the services control window
  ![Starting the VM Session service](media\vm_start_VM_PowerShell_service.png)

3.	Enter a VM Session
  
   Open a PowerShell window as Administrator and supply credentials for the virtual machine.
	
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



## PS Remoting ##