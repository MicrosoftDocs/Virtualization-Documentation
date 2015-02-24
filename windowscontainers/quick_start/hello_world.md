ms.ContentId: a3f19206-91e3-4013-b569-d4d8624a4ad0 
title: Hello World for Windows Containers

## Hello World for Windows Containers ###

Let's get you started with containers! Before we begin, you will need:

- a computer running Windows 10 or Windows Server
- an application with ....
- something else
- and another thing 

### Step 1: Install Hyper-V ###
Install Hyper-V using Windows Powershell. If you already have Hyper-V installed, you can skip this step and go on to [Step 2: Create a virtual machine](hello_world.md#Step2:Createthevirtualmachine).
	
- On Windows 10, type: `enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All` 
- On Windows Server, type: `Install-WindowsFeature –Name Hyper-V -IncludeManagementTools -Restart`
	
### Step 2: Create the virtual machine ##
You need to create a new virtual machine using a .vhdx of Windows 10 or Windows Server. 

1. Click the **Start** button and type **Hyper-V Manager**.
2. On the **Action** menu, select **Connect to Server**. 
3. Choose **Local computer** and then click **OK**.
4. On the **Action** menu, click **New** > **Virtual machine**
5. In the virtual machine wizard, make the following choices:
	
	<table>
	<tr><td>Name:</td> <td>Hello Containers</td></tr>
	<tr><td>Generation:</td> <td><b>Generation 2</b></td></tr>
	<tr><td>Startup Memory</td> <td><b>1024</b> and don't select dynamic memory</td></tr>
	<tr><td>Configure networking:</td> <td>select the virtual switch</td></tr>
	<tr><td>Connect virtual hard disk:</td> <td><b>Use and existing virtual hard disk</b> and enter the path the .vhdx</td></tr>
	</table>

6. The Summary page of the wizard should look like this:
	
	![](media\create_vm.png)

### Configure the virtual machine ###
1. Click on the Windows button and type note and then select Notepad
2. Copy the following lines in to Notepad and save it as configure.ps1:

	
    		set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0 
    	
    		set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 0
    	
    		Enable-NetFirewallRule -DisplayGroup "Remote Desktop" 
    	
    		dism /Online /Enable-Feature:Containers 
    	
    		siloservice -install 
    	
    		dism /Online /Enable-Feature:Microsoft-Hyper-V /all 
    	
    		dism /Online /Enable-Feature:Microsoft-Hyper-V-Management-PowerShell /all
    	
    		Pause  # Wait for user to acknowledge before rebooting the system
    	
    		shutdown -r -t 0 
    	
3. Click on the Windows button and type power and then select Windows Powershell. 
4. Type configure.ps1 to start the script.

### Start your container ###
1. At the Windows Powershell prompt or a command prompt, type:

   `Siloclient -start test1 -def \windows\system32\containers\cmdserver.def -server`

2. Then follow [these instructions](..\reference\networking.md) to set up your network.
3. You can now try to RDP into the container

	Note: You may need to disable the Windows firewall / open custom ports in the Windows firewall in order to have RDP to the container work.

### Next Steps ###
[Install using Docker](install_using_docker.md)