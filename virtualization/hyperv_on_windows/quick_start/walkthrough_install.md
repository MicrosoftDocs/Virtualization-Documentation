ms.ContentId: A6DD6776-614C-4D28-9B83-CB2EDFD263A3
title: Step 2 - Install Hyper-V on Windows 10

# Install Hyper-V on Windows 10

Before you can begin using virtual machines on Windows 10 you will need to enable the Hyper-V role. This can be done using the Windows 10 control panel, PowerShell or DISM. This documents will walk through each of these.

## Manually Enable the Hyper-V Role

1. Right click on the Windows button and select ‘Programs and Features’.

2. Select **Turn Windows Features on or off**.

3. Select **Hyper-V** and click **OK**.  

![](media/enable_role_upd.png)

When the installation has completed you will be prompted to restart your computer.

![](media/restart_upd.png)

## Enable Hyper-V with PowerShell

1. Open a PowerShell console as Administrator.

2. Enter the following command:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All
```
When the installation has completed you will need to reboot the computer.

## Enable Hyper-V with DISM

The Deployment Image Servicing and Management tool or DISM is used to service Windows images and prepare Windows Pre installation Evironments. DISM can also be used to enable Windows features in running instances of an operating system. More information about DISM can be found on the [DISM Technical Reference](https://technet.microsoft.com/en-us/library/hh824821.aspx).

To enable the Hyper-V role using DISM:

1. Open up a PowerShell or CMD session as Administrator.

2. Type the following command:

```powershell
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
```

Once completed you will be prompted to reboot.

![](media/dism_upd.png)


## Next Step - Create a Virtual Switch
[Create a Virtual Switch](walkthrough_virtual_switch.md) 