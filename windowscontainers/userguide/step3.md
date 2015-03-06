ms.ContentId: D50E5834-85A4-4BD7-819C-EC3B31198BE2
title: Step 3: Install Client Hyper-V

# Install Client Hyper-V #

If you are just getting started with Client Hyper-V, you probably want to use the Programs and Features tool to install Client Hyper-V. But, you can also install using Windows Powershell.



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


# Next Step #