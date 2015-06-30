ms.ContentId: 2964B9FA-FBA4-4F8C-BEF2-A3F3E2FEC6E4
title: Step 2: Install Client Hyper-V

# Install Client Hyper-V #

If you are just getting started with Client Hyper-V, you probably want to use the Programs and Features tool to install Client Hyper-V. But, you can also install using [Windows Powershell](#Using-the-Get-WindowsOptionalFeature-cmdlet).


## Using Programs and Features ##
1. Right-click the **Windows** button and then click **Programs and Features**.

![](media\ProgramsAndFeatures.png)

2. Click **Turn Windows features on or off**.

3. Select **Hyper-V**, click **OK**

![](media\hyper-v_feature_selected1.png)

4. When the installation is finished, you will need  to restart the computer.

![](media\restart.png)

## Using the Get-WindowsOptionalFeature cmdlet ##
For more information, see Get-WindowsOptionalFeature and Using PowerShell to Set Up Hyper-V

1. Click on the **Windows** button and search for **Windows PowerShell**. 
2. Right-click on **Windows PowerShell** and then click **Run as Administrator**.
3. At the Windows Powerhshell prompt, type the following and then press the **Enter** key: 
```enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All``` 
4. When the installation is finished, restart the computer. 

## How do I know it installed?##
After you restart your computer, check to see if you can start the Hyper-V Manager too.

1. Click on the **Windows** button and type **Hyper-V**.
2. Click on **Hyper-V Manager** in the list.

The Hyper-V Manager should start and look like this:
<!-- need screenshot -->

# Next Step #
[Step 3: Create a virtual switch](step3.md)