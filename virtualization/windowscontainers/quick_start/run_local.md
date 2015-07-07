ms.ContentId: 9dc57a6a-7104-4721-ba5c-3e246ee17f75 
title: Running Containers Locally

# Setting up Argons on your local machine #

<-- These instructions were created by Lars for selfhosters 7/7/2015. You might want to put instructions in hello_world.md instead of this file -->
 
1.  Prerequisites:  
Threshold host with Hyper-V enabled and capacity for an additional VM  

2.  Initial setup  
Copy the content of `\\vmstore\public\liwer\docker\scripts` to a local directory.  
Start an administrative PowerShell and CD into this directory.

	** Run the following commands: **
	
	`.\Copy-SourcesLocally.ps1 -CreateBuildSubdir`
	
	If the script finds a valid build it is copied to a local source directory. 
	
	The script ​will output the target directory after everything has been copied over. Use this directory in the following command. You can use any VM name.

	`.\New-ContainerHost.ps1 -localsourcedir C:\ContainerTest\LocalSources\10158.0.150628-1900\ -VMName "ContainerTest-10158.0.150628-1900"`

	Wait for the guest to boot until you see the desktop/cmd prompt (for server core) in the vmconnect window that is launched …

	`.\Configure-GuestForDockerUse.ps1 -VMName "ContainerTest-10158.0.150628-1900"`

	​Follow the instructions from the script

3.  First Steps  
	Log in to the VM which was created using the Password P@ssw0rd

	To start the docker daemon: Run a cmd, enter `docker -d -D`

	Run a second cmd - here you can run docker commands to build an image/run containers etc.

Some example Dockerfiles including installers can be found here:


\\vmstore\public\liwer\docker\build files ​
