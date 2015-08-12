## Description 

`Convert-WindowsImage` is a command-line tool that allows you to create generalized (“sysprepped”) VHD and VHDX images from any official build (ISO or WIM image) of Windows.  
**Note: **  It is the new version of `WIM2VHD`.

This script was updated for Windows 10. It also runs on Windows 8 and Windows 8.1.

The Convert-WindowsImage script will build VHD and VHDX images from any official build (ISO or WIM image) of Windows 7, Windows Server 2008 R2, Windows 8, Windows Server 2012, Windows 8.1 and Windows Server 2012 R2.

New in version 10 is support for Windows 10 (and Windows Server 2016) VMs and images. (Full change log below).
 
Images created by `Convert-WindowsImage` will boot directly to the Out Of Box Experience (OOBE), ready for your first-use customizations. So you can think of it as of replacement for your daddy's “Deploy-Sysprep-and-Capture” approach. You can also use these images for automation by supplying your own `unattend.xml` file, making the possibilities limitless. Fresh squeezed, organically grown, free-range VHDs—just like Mom used to make—that work with Virtual PC (Windows 7 only), Virtual Server (Windows 7 only), Microsoft Hyper-V, or Windows' Native VHD-Boot functionality!

`Convert-WindowsImage` (just like its precessor, `WIM2VHD` tool) was originally created by [Mike Kolitz](http://social.technet.microsoft.com/profile/mike kolitz) while he was a Microsoft Employee and worked on Windows. The tool is now maintained and evolved by his friends from Microsoft Consulting Services (MCS).

## Change Log

### Version 10 (June 2015) Note: Multiple breaking changes!

Works on (and with) Windows 10! (Also fully tested on Windows 8.1 with August 2014 and November 2014 updates).

The script is now a Function! You have to load it first (aka “dot-source”) and then call by its name, without extension.  Please refer to the Examples section below for a code sample.
* `-Feature` parameter now supports multiple input (array of strings).
* `-Edition` parameter now supports multiple input (array of stings). Output will be multiple separate VHD(x)'es.
* New `-Package` parameter to inject Windows packages (e.g. updates or language packs) into the image.
* `-PassThru` returns object(s) instead of a path.
* Fix. If the source is remote (UNC path), the script copies it locally into the user's temp directory. Previously the local copy was not removed afterwards. Now we correctly delete it when no longer needed.
* Fix. The function now works as expected with Powershell's Strict Mode.
VHDX is the new default (Sorry Azure!). Use -VhdFormat to explicitly specify “VHD”.
* GPT is the new default (Sorry Generation 1 virtual machines!). Use - VhdPartitionStyle to explicitly specify “MBR”.
* UI is deprecated. This was a tough decition but I don't have enough skills and time to maintain it and support with the new features I added over time. Probably the old -ShowUi option still works. But I cannot commit it to work with any of the new features or at all. Sorry about this folks. If anyone has suggestions and ready to help, please reach out to me and I will be happy to include your contributions.


### Version 6.3 QFE 7 (February 17, 2014)

* Fix. QFE5 has introduced a bug in GTP handling.

### Version 6.3 QFE 6 (February 16, 2014)

* New. Option to enable Windows Features for the OS inside the VHD(x). Use the `-Feature` parameter. Note that you need to specify the internal names as understood by DISM and DISM CmdLets (e.g. `NetFx3`), instead of the "friendly" names from Server Manager CmdLets (e.g. `NET-Framework-Core`). There's no need to specify the source since we already have full sources inside the ISO.

### Version 6.3 QFE 5

* Fix. VM Provisioning with VMM using the Differencing Disk feature was failing. A particular case of this scenario is provisioning a VM Role Gallery Item with Windows Azure Pack. (Note that so-called Standalone VMs were not affected since they're not using Differencing disks).

### Version 6.3 for Windows 8.1 and Windows Server 2012 R2

* Support for Windows 8.1 and Windows Server 2012 R2.
* Fix Now works correctly on UEFI-based systems (like your modern laptop or new server, as well as inside Generation 2 VMs).
* New Support for GPT partitioning inside VHD(x)es.  
Use the new `-VHDPartitionStyle` parameter. By default we still create MBR-partitioned VHD(x)es for backward compatibility. (I.e. your older commands will produce the same effect as before).  
This is particularly handful for the following two scenarios:
 * Native VHD(x) Boot on UEFI-based system.
 * Generation 2 Virtual Machines in Hyper-V with Windows Server 2012 R2 (more details on [this blog]( http://blogs.technet.com/b/jhoward/archive/2013/10/24/hyper-v-generation-2-virtual-machines-part-1.aspx).
* New Specific features to better support Native VHD(x) Boot scenarios.
 * An option to skip BCD store creation inside the VHD(x). That’s because with Native Boot, the BCD store and the boot loader itself should be stored off the VHD(x), on the physical disk. Thus no need to pollute the root of your C:\ drive. Use the new `-BCDinVHD` parameter.
 * A switch to disable automatic expansion of VHD(x) in case of Native Boot.  
For usage guidance, see `-ExpandOnNativeBoot` in the help section.
 * An option to inject drivers into the OS inside the VHD(x). Good for OEM mass storage drivers which are required for native boot on common server-class hardware.  
 Use the new `-Driver` parameter.
* New A switch to enable Remote Desktop for the OS inside the VHD(x).  
Use the new `-RemoteDesktopEnable` switch.
 * **Note: ** you still need to enable relevant Firewall rules (using Group Policy or manually). That might be a subject for further improvements.
* Improvement Added link to online help (this page). Use the `-Online` switch for `Get-Help`.


### Version 6.2 for Windows 8 and Windows Server 2012

First, we should stop calling it "WIM2VHD".  
The WIM2VHD name has been discontinued with this version of the script.  Because it's been completely rewritten in PowerShell, I opted to give it a more PowerShell-esque name, that name being "Convert-WindowsImage".  "WIM2VHD8" has been the working codename for the project during development.

* Convert-WindowsImage has been completely rewritten in PowerShell.
* Support for the new VHDX file format has been added!
* Support for creating VHD and VHDX images from .ISO files has been added!
* A new (and completely optional) graphical user interface has been added, making the creation of VHD and VHDX images as simple as a few mouse clicks!
* Closer integration with the storage stack, so there's no more need to automate `DISKPART.EXE` and hope that it works!
* Fewer binary dependencies!
  WIM2VHD required the use of up to 8 external binaries, some of which were only available as part of the Windows AIK/OPK, requiring a 1.7GB download just to get a few EXE files.  
  Convert-WindowsImage requires the use of only 3 external binaries, all of which are included in-box with Windows 8.

## System Requirements

** What OSes can I run Convert-WindowsImage on? **  
Convert-WindowsImage supports pre-release versions of Windows 8 and higher. Windows 8.1 and Windows Server 2012 R2 is the recommended and most tested platform.  
Convert-WindowsImage cannot be run on Windows 7 or Windows Server 2008 R2.

** What OSes can Convert-WindowsImage make VHDs and VHDXs of? **  
Convert-WindowsImage only supports creating VHD and VHDX images from Windows 7/R2 and higher.  
Windows Vista/Windows Server 2008 and previous versions of Windows are not supported.

** Which OSes can I use VHDX files with? **  
The new VHDX file format can only be used with Windows 8/Server 2012 and above, and the version of Hyper-V that ships with those platforms. You can create a VHDX which has Windows 7 or Windows Server 2008 R2 installed in it, but they will only run on Windows 8/Server 2012 Hyper-V and above.


## FAQ

** Are there any changes from the way WIM2VHD worked? **  
Yes.  Here's a list of WIM2VHD features that have not been implemented in `Convert-WindowsImage.ps1`. 
* `/QFE*`  
Provided support for hotfix installation into the VHD during creation.
* `/REF`  
Provided support for multi-part WIM files.
* `/MergeFolder*`   
Merged a specified folder structure into the root of the VHD.
* `/SignDisk`   
Created a file with the creation date, time, and `Convert-WindowsImage` version used to create the VHD in the root of the VHD file system.  This is now the default behavior, so the switch has been removed.
* `/Trace`   
Displayed verbose output.  This is now handled by the `-Verbose` switch.
* `FastFixed` is no longer a valid value for the `-DiskType` parameter.
* `/CopyLocal`   
Copied all necessary EXEs to a single directory.  No longer needed in `Convert-WindowsImage.`
* `/Metadata`
* `/HyperV`
* `/ClassicMount`  
Specified that `WIM2VHD` should use drive letters instead of the NTFS mount points.  This is now the default behavior, so the switch has been removed.

These features may be implemented in a later release.


** Are there any known issues? **  
In the initial release of `Convert-WindowsImage.ps1`, there was a bug which prevented the creation of Hyper-V Server VHD and VHDX files.  This bug has since been fixed in the .1 revision which was released on 6/12/2012.  
If you are not affected by this issue, there is no need for you to upgrade to the current release.

There are currently no known issues with this build of `Convert-WindowsImage.ps1`.

## Usage  
Use the function (New in version 10). Also highlights some of the new features.

``` PowerShell
# Load (aka "dot-source) the Function 
. .\Convert-WindowsImage.ps1 
# Prepare all the variables in advance (optional) 
$ConvertWindowsImageParam = @{  
    SourcePath          = "9600.17053.WINBLUE_REFRESH.141120-0031_X64FRE_SERVER_EN-US_VL-IR5_SSS_X64FREV_EN-US_DV9.ISO"  
    RemoteDesktopEnable = $True  
    Passthru            = $True  
    Edition    = @(  
        "ServerDataCenter"  
        "ServerDataCenterCore"  
    )  
    Package = @(  
        "C:\Users\artemp\Downloads\November\Windows8.1-KB3012997-x64-en-us-server.cab"  
        "C:\Users\artemp\Downloads\VMguest\windows6.2-hypervintegrationservices-x64.cab"  
    )  
}  
# Produce the images 
$VHDx = Convert-WindowsImage @ConvertWindowsImageParam
```

Create a VHDX using GPT partition layout (for UEFI boot and Hyper-V Generation 2 VMs).

``` PowerShell
.\Convert-WindowsImage.ps1 -SourcePath "9477.0.FBL_PARTNER_OUT31.130803-0736_X64FRE_SERVER_EN-US-IRM_SSS_X64FRE_EN-US_DV5.ISO" -VHDFormat VHDX -Edition ServerDataCenterCore -VHDPartitionStyle GPT -Verbose
```

Create a VHDX using MBR (old school) partition layout (which is still the default). Prepare the VHDX for Native Boot on BIOS-based computer: skip BCD creation, disable VHDX expansion on Native Boot, enable Remote Desktop and add a custom driver.

``` PowerShell
.\Convert-WindowsImage.ps1 -SourcePath "9600.16384.WINBLUE_RTM.130821-1623_X64FRE_SERVER_EN-US-IRM_SSS_X64FRE_EN-US_DV5.ISO" -VHDFormat VHDX -Edition "ServerDataCenterCore" -SizeBytes 8GB -VHDPartitionStyle MBR -BCDinVHD NativeBoot -ExpandOnNativeBoot:$false -RemoteDesktopEnable -Driver "F:\Custom Driver" -Verbose
```

Show the graphical user interface. Note that this feature does not support all of the options that present in command-line interface:

``` PowerShell
.\Convert-WindowsImage.ps1 -ShowUI
```

Create a VHD using all default settings from D:\sources\install.wim.

``` PowerShell
.\Convert-WindowsImage.ps1 -SourcePath D:\sources\install.wim 
# Since no edition is being specified, the command will succeed if there is only one image in the specified WIM file.  If there are multiple images, the command will fail and it will list the possible editions.
```

Create a VHD using all default settings from D:\sources\install.wim while specifying an edition.
``` PowerShell
.\Convert-WindowsImage.ps1 -SourcePath D:\sources\install.wim -Edition Professional
```

Create a 60GB VHDX, using all default settings, from D:\Windows8RPx64.iso.
``` PowerShell
.\Convert-WindowsImage.ps1 -SourcePath D:\Windows8RPx64.iso -VHDFormat VHDX -SizeBytes 60GB
```

Create a 48TB VHDX from D:\WindowsRPx64.iso with a custom file name.
``` PowerShell
.\Convert-WindowsImage.ps1 -SourcePath D:\Windows8RPx64.iso -VHDFormat VHDX -SizeBytes 48TB -VHDPath .\MyCustomName.vhdx
```

Use WIM2VHD-style argument names to create a 20GB fixed VHDX with a custom name and an unattend file from `D:\foo.wim`, and return the path to the created VHDX on the pipeline.
``` PowerShell
.\Convert-WindowsImage.ps1 -WIM D:\foo.wim -Size 20GB -DiskType Fixed -VHDFormat VHDX -Unattend D:\myUnattend.xml -VHD D:\scratch\foo.vhdx -passthru
```

Enable serial debugging in the VHD, using COM2 at 19200bps.
``` PowerShell
"D:\foo.wim" | .\Convert-WindowsImage.ps1 -Edition Professional -EnableDebugger Serial -ComPort 2 -BaudRate 19200
```