ms.ContentId: 248565F7-5EE6-46C6-B29E-8F1D44658563
title: Walkthrough Client Hyper-V on Windows 10 using the UI
 
These topics will help your get aquainted with Hyper-V Client on Windows 10. We will walk you through all of the steps needed to get a computer up and running with Client Hyper-V and check out some of the new features and old favorites.

Step 1: Get familiar with some virtualization terminology
Step 2: Make sure you can use your machine with Client Hyper-V
Step 3: Install Client Hyper-V
Step 4: Create a virtual switch <!-- this might be done when you install Hyper-V? -->
Step 5: Configure your host
Step 6: Create a Windows guest virtual machine
Step 7: Connect to the virtual machine and finish the installation
Step 8: Experiment with checkpoints
Step 9: Experiment with exporting and importing a virtual machine
Step 10: Create a Linux guest virtual machine

# Installing Client Hyper-V on Windows 10 Using the UI #
You can install Client Hyper-V on Windows 10 by Using Programs and Features or Using the Get-WindowsOptionalFeature cmdlet.

## Using Programs and Features ##
In the Control Panel, click Programs, and then click Programs and Features.

Click Turn Windows features on or off.

Select Hyper-V, click OK, and then click Close.


## Using the Get-WindowsOptionalFeature cmdlet ##
For more information, see Get-WindowsOptionalFeature and Using PowerShell to Set Up Hyper-V

Click on the Windows icon and search for Windows PowerShell. Right-click the shortcut for Windows PowerShell and then click Run as Administrator. To pin the Windows PowerShell shortcut to the Start menu, right-click the shortcut, and then click Pin to Start.

At the Windows Powerhshell prompt, type the following and then press Enter. 

  Copy Code 
enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All 
 

When the installation is finished, restart the computer. 


## Next Steps ##
Create a virtual switch
Create a virtual machine

Install a guest operating system

Connect to a virtual machine using VMConnect