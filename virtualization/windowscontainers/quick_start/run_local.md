ms.ContentId: 9dc57a6a-7104-4721-ba5c-3e246ee17f75 
title: Running Containers Locally

# Setting up Argons on your local machine #

<-- These instructions were created for the 2/6/2015 review. You might want to put instructions in hello_world.md instead of this file -->
 
1. Install the latest build -- VHD available from
    `\\winbuilds\release\FBL_KPG_CORE_XENON_LITE\<<build_number>>\amd64fre\vhd\vhd_server_serverdatacenter_en-us`
	
2. Create a VM with this VHD
3. When the VM comes up, go to the Server Manager and
    1.  Enable Remote Desktop
	2.  Install the “Windows Containers” feature
	3.	Install the siloservice: SiloService –install
	4.  Enable the “Hyper-V” role and PowerShell management.
	
		Note: You can only enabled Hyper-V inside a virtual machine using the command prompt.  Server Manager and PowerShell will check for the presence of SLAT and will block installation.  To install Hyper-V from the command line run:
		
			dism /Online /Enable-Feature:Microsoft-Hyper-V /all
			
		Hyper-V Powershell can be enabled with either Server Manager, PowerShell or DISM.
			  
	5.  Reboot

Alternatively use the same steps as above in a PowerShell script (copy instructions into a .ps1 file, open Powershell and run the script) :
	
		`set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0` 
	
		`set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 0`
	
		Enable-NetFirewallRule -DisplayGroup "Remote Desktop" 
	
		dism /Online /Enable-Feature:Containers
	
		siloservice -install
	
		dism /Online /Enable-Feature:Microsoft-Hyper-V /all
	
		dism /Online /Enable-Feature:Microsoft-Hyper-V-Management-PowerShell /all
	
		`Pause  # Wait for user to acknowledge before rebooting the system`
	
		`shutdown -r -t 0 `
	

4. Now start a container via the following command line:
   `Siloclient -start test1 -def \windows\system32\containers\cmdserver.def -server`

5. Then follow [these instructions](..\reference\networking.md) to set up your network.

6. You can now try to RDP into the container

	Note: You may need to disable the Windows firewall / open custom ports in the Windows firewall in order to have RDP to the container work.