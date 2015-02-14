ms.ContentId: 9dc57a6a-7104-4721-ba5c-3e246ee17f75 
title: Running Containers Locally

# Setting up Argons on your local machine #

These instructions were created for the 2/6/2015 review.
 
1. Install the latest build -- VHD available from
    `\winbuilds\release\FBL_KPG_CORE_XENON_LITE\<<build_number>>\amd64fre\vhd\vhd_server_serverdatacenter_en-us`
	
2. Create a VM with this VHD
3. When the VM comes up, go to the Server Manager and
    1.  Enable Remote Desktop
	2.  Install the “Windows Containers” feature
	3.	Install the siloservice: SiloService –install
	4.  Enable the “Hyper-V” role and PowerShell management
	5.  Reboot

	Alternatively use the same steps as above in a PowerShell script (copy instructions into a .ps1 file, open Powershell and run the script) :
	
	`set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0` 
	`set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 0`
	`Enable-NetFirewallRule -DisplayGroup "Remote Desktop"` 
	`dism /Online /Enable-Feature:Containers` 
	`siloservice -install` 
	`dism /Online /Enable-Feature:Microsoft-Hyper-V /all` 
	`dism /Online /Enable-Feature:Microsoft-Hyper-V-Management-PowerShell /all`
	`Pause  # Wait for user to acknowledge before rebooting the system`
	`shutdown -r -t 0 `

4. Now start a container via the following command line:
   `Siloclient –start test1 –def \windows\system32\containers\cmdserver.def –server`

5. Then follow [these instructions](..\reference\networking.md) to set up your network.

6. You can now try to TS into the container

