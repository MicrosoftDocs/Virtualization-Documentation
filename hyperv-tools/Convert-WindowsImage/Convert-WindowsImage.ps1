Function
Convert-WindowsImage
{

  <#
    .NOTES
        Copyright (c) Microsoft Corporation.  All rights reserved.

        Use of this sample source code is subject to the terms of the Microsoft
        license agreement under which you licensed this sample source code. If
        you did not accept the terms of the license agreement, you are not
        authorized to use this sample source code. For the terms of the license,
        please see the license agreement between you and Microsoft or, if applicable,
        see the LICENSE.RTF on your install media or the root of your tools installation.
        THE SAMPLE SOURCE CODE IS PROVIDED "AS IS", WITH NO WARRANTIES.
    
    .SYNOPSIS
        Creates a bootable VHD(X) based on Windows 7 or Windows 8 installation media.

    .DESCRIPTION
        Creates a bootable VHD(X) based on Windows 7 or Windows 8 installation media.

    .PARAMETER SourcePath
        The complete path to the WIM or ISO file that will be converted to a Virtual Hard Disk.
        The ISO file must be valid Windows installation media to be recognized successfully.

    .PARAMETER VHDPath
        The name and path of the Virtual Hard Disk to create.
        Omitting this parameter will create the Virtual Hard Disk is the current directory, (or,
        if specified by the -WorkingDirectory parameter, the working directory) and will automatically 
        name the file in the following format:

        <build>.<revision>.<architecture>.<branch>.<timestamp>_<skufamily>_<sku>_<language>.<extension>
        i.e.:
        8250.0.amd64chk.winmain_win8beta.120217-1520_client_professional_en-us.vhd(x)

    .PARAMETER WorkingDirectory
        Specifies the directory where the VHD(X) file should be generated.  
        If specified along with -VHDPath, the -WorkingDirectory value is ignored.
        The default value is the current directory ($pwd).

    .PARAMETER SizeBytes
        The size of the Virtual Hard Disk to create.
        For fixed disks, the VHD(X) file will be allocated all of this space immediately.
        For dynamic disks, this will be the maximum size that the VHD(X) can grow to.
        The default value is 40GB.

    .PARAMETER VHDFormat
        Specifies whether to create a VHD or VHDX formatted Virtual Hard Disk.
        The default is VHD.

    .PARAMETER VHDType
        Specifies whether to create a fixed (fully allocated) VHD(X) or a dynamic (sparse) VHD(X).
        The default is dynamic.

    .PARAMETER UnattendPath
        The complete path to an unattend.xml file that can be injected into the VHD(X).

    .PARAMETER Edition
        The name or image index of the image to apply from the WIM.

    .PARAMETER Passthru
        Specifies that the full path to the VHD(X) that is created should be
        returned on the pipeline.

    .PARAMETER BCDBoot
        By default, the version of BCDBOOT.EXE that is present in \Windows\System32
        is used by Convert-WindowsImage.  If you need to specify an alternate version,
        use this parameter to do so.

    .PARAMETER VHDPartitionStyle
        Partition style (MBR or GPT) for the newly created disk (VHDX or VHD). By default
        it will be partitioned with MBR partition style, used for older BIOS-based computers
        and Generation 1 Virtual Machines in Hyper-V. For modern UEFI-based computers
        and Generation 2 Virtual Machines, GPT partition layout is required.

    .PARAMETER BCDinVHD
        Specifies the purpose of the VHD(x). Use NativeBoot to skip cration of BCD store
        inside the VHD(x). Use VirtualMachine (or do not specify this option) to ensure
        the BCD store is created inside the VHD(x).

    .PARAMETER Driver
        Full path to driver(s) (.inf files) to inject to the OS inside the VHD(x).

    .PARAMETER ExpandOnNativeBoot
        Specifies whether to expand the VHD(x) to its maximum suze upon native boot.
        The default is True. Set to False to disable expansion.

    .PARAMETER RemoteDesktopEnable
        Enable Remote Desktop to connect to the OS inside the VHD(x) upon provisioning.
        Does not include Windows Firewall rules (firewall exceptions). The default is False.

    .PARAMETER Feature
        Enables specified Windows Feature(s). Note that you need to specify the Internal names
        understood by DISM and DISM CMDLets (e.g. NetFx3) instead of the "Friendly" names
        from Server Manager CMDLets (e.g. NET-Framework-Core).

    .PARAMETER Package
        Injects specified Windows Package(s). Accepts path to either a directory or individual
        CAB or MSU file.

    .PARAMETER ShowUI
        Specifies that the Graphical User Interface should be displayed.

    .PARAMETER EnableDebugger
        Configures kernel debugging for the VHD(X) being created.
        EnableDebugger takes a single argument which specifies the debugging transport to use.
        Valid transports are: None, Serial, 1394, USB, Network, Local.

        Depending on the type of transport selected, additional configuration parameters will become
        available.

        Serial:
            -ComPort   - The COM port number to use while communicating with the debugger.
                         The default value is 1 (indicating COM1).
            -BaudRate  - The baud rate (in bps) to use while communicating with the debugger.
                         The default value is 115200, valid values are:
                         9600, 19200, 38400, 56700, 115200
            
        1394:
            -Channel   - The 1394 channel used to communicate with the debugger.
                         The default value is 10.

        USB:
            -Target    - The target name used for USB debugging.
                         The default value is "debugging".

        Network:
            -IPAddress - The IP address of the debugging host computer.
            -Port      - The port on which to connect to the debugging host.
                         The default value is 50000, with a minimum value of 49152.
            -Key       - The key used to encrypt the connection.  Only [0-9] and [a-z] are allowed.
            -nodhcp    - Prevents the use of DHCP to obtain the target IP address.
            -newkey    - Specifies that a new encryption key should be generated for the connection.
   
    .EXAMPLE
        .\Convert-WindowsImage.ps1 -SourcePath D:\foo\install.wim -Edition Professional -WorkingDirectory D:\foo

        This command will create a 40GB dynamically expanding VHD in the D:\foo folder.
        The VHD will be based on the Professional edition from D:\foo\install.wim,
        and will be named automatically.

    .EXAMPLE
        .\Convert-WindowsImage.ps1 -SourcePath D:\foo\Win7SP1.iso -Edition Ultimate -VHDPath D:\foo\Win7_Ultimate_SP1.vhd

        This command will parse the ISO file D:\foo\Win7SP1.iso and try to locate
        \sources\install.wim.  If that file is found, it will be used to create a 
        dynamically-expanding 40GB VHD containing the Ultimate SKU, and will be 
        named D:\foo\Win7_Ultimate_SP1.vhd

    .EXAMPLE
        .\Convert-WindowsImage.ps1 -SourcePath D:\foo\install.wim -Edition Professional -EnableDebugger Serial -ComPort 2 -BaudRate 38400

        This command will create a VHD from D:\foo\install.wim of the Professional SKU.
        Serial debugging will be enabled in the VHD via COM2 at a baud rate of 38400bps.

    .OUTPUTS
        System.IO.FileInfo
  #>

   #region Data

        [CmdletBinding(DefaultParameterSetName="SRC",
        HelpURI="http://gallery.technet.microsoft.com/scriptcenter/Convert-WindowsImageps1-0fe23a8f")]

        param(
            [Parameter(ParameterSetName="SRC", Mandatory=$true, ValueFromPipeline=$true)]
            [Alias("WIM")]
            [string]
            [ValidateNotNullOrEmpty()]
            [ValidateScript({ Test-Path $(Resolve-Path $_) })]
            $SourcePath,

            [Parameter(ParameterSetName="SRC")]
            [Alias("SKU")]
            [string[]]
            [ValidateNotNullOrEmpty()]
            $Edition,

            [Parameter(ParameterSetName="SRC")]
            [Alias("WorkDir")]
            [string]
            [ValidateNotNullOrEmpty()]
            [ValidateScript({ Test-Path $_ })]
            $WorkingDirectory = $pwd,

            [Parameter(ParameterSetName="SRC")]
            [Alias("VHD")]
            [string]
            [ValidateNotNullOrEmpty()]
            $VHDPath,

            [Parameter(ParameterSetName="SRC")]
            [Alias("Size")]
            [UInt64]
            [ValidateNotNullOrEmpty()]
            [ValidateRange(512MB, 64TB)]
            $SizeBytes        = 40GB,

            [Parameter(ParameterSetName="SRC")]
            [Alias("Format")]
            [string]
            [ValidateNotNullOrEmpty()]
            [ValidateSet("VHD", "VHDX")]
            $VHDFormat        = "VHDX",

            [Parameter(ParameterSetName="SRC")]
            [Alias("DiskType")]
            [string]
            [ValidateNotNullOrEmpty()]
            [ValidateSet("Dynamic", "Fixed")]
            $VHDType          = "Dynamic",

            [Parameter(ParameterSetName="SRC")]
            [string]
            [ValidateNotNullOrEmpty()]
            [ValidateSet("MBR", "GPT")]
            $VHDPartitionStyle = "GPT",

            [Parameter(ParameterSetName="SRC")]
            [string]
            [ValidateNotNullOrEmpty()]
            [ValidateSet("NativeBoot", "VirtualMachine")]
            $BCDinVHD = "VirtualMachine",

            [Parameter(ParameterSetName="SRC")]
            [Parameter(ParameterSetName="UI")]
            [string]
            $BCDBoot          = "bcdboot.exe",

            [Parameter(ParameterSetName="SRC")]
            [Parameter(ParameterSetName="UI")]
            [string]
            [ValidateNotNullOrEmpty()]
            [ValidateSet("None", "Serial", "1394", "USB", "Local", "Network")]
            $EnableDebugger = "None",

            [Parameter(ParameterSetName="SRC")]
            [string[]]
            [ValidateNotNullOrEmpty()]
            $Feature,

            [Parameter(ParameterSetName="SRC")]
            [string[]]
            [ValidateNotNullOrEmpty()]
            [ValidateScript({ Test-Path $(Resolve-Path $_) })]
            $Driver
            ,
            [Parameter(ParameterSetName="SRC")]
            [string[]]
            [ValidateNotNullOrEmpty()]
            [ValidateScript({ Test-Path $(Resolve-Path $_) })]
            $Package
            ,
            [Parameter(ParameterSetName="SRC")]
            [Switch]
            $ExpandOnNativeBoot = $True,

            [Parameter(ParameterSetName="SRC")]
            [Switch]
            $RemoteDesktopEnable = $False,

            [Parameter(ParameterSetName="SRC")]
            [Alias("Unattend")]
            [string]
            [ValidateNotNullOrEmpty()]
            [ValidateScript({ Test-Path $(Resolve-Path $_) })]
            $UnattendPath,

            [Parameter(ParameterSetName="SRC")]
            [Parameter(ParameterSetName="UI")]
            [switch]
            $Passthru,

            [Parameter(ParameterSetName="UI")]
            [switch]
            $ShowUI
    
        )

   #endregion Data

   #region Code

        # Begin Dynamic Parameters
        # Create the parameters for the various types of debugging.
        DynamicParam {

            # Set up the dynamic parameters.
            # Dynamic parameters are only available if certain conditions are met, so they'll only show up
            # as valid parameters when those conditions apply.  Here, the conditions are based on the value of
            # the EnableDebugger parameter.  Depending on which of a set of values is the specified argument
            # for EnableDebugger, different parameters will light up, as outlined below.
    
            $parameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
 
            If
            (
                Test-Path -Path "Variable:\EnableDebugger"
            )
            {
                switch ($EnableDebugger) {
       
                    "Serial" {
                        #region ComPort
        
                        $ComPortAttr                   = New-Object System.Management.Automation.ParameterAttribute
                        $ComPortAttr.ParameterSetName  = "__AllParameterSets"
                        $ComPortAttr.Mandatory         = $false

                        $ComPortValidator              = New-Object System.Management.Automation.ValidateRangeAttribute(
                                                            1, 
                                                            10   # Is that a good maximum?
                                                         )

                        $ComPortNotNull                = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute

                        $ComPortAttrCollection         = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                        $ComPortAttrCollection.Add($ComPortAttr)
                        $ComPortAttrCollection.Add($ComPortValidator)
                        $ComPortAttrCollection.Add($ComPortNotNull)
        
                        $ComPort                       = New-Object System.Management.Automation.RuntimeDefinedParameter(
                                                            "ComPort",
                                                            [UInt16],
                                                            $ComPortAttrCollection
                                                         )

                        # By default, use COM1
                        $ComPort.Value                 = 1
                        $parameterDictionary.Add("ComPort", $ComPort)
                        #endregion ComPort

                        #region BaudRate
                        $BaudRateAttr                  = New-Object System.Management.Automation.ParameterAttribute
                        $BaudRateAttr.ParameterSetName = "__AllParameterSets"
                        $BaudRateAttr.Mandatory        = $false

                        $BaudRateValidator             = New-Object System.Management.Automation.ValidateSetAttribute(
                                                            9600, 19200,38400, 57600, 115200
                                                         )

                        $BaudRateNotNull               = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute

                        $BaudRateAttrCollection        = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                        $BaudRateAttrCollection.Add($BaudRateAttr)
                        $BaudRateAttrCollection.Add($BaudRateValidator)
                        $BaudRateAttrCollection.Add($BaudRateNotNull)

                        $BaudRate                      = New-Object System.Management.Automation.RuntimeDefinedParameter(
                                                             "BaudRate",
                                                             [UInt32],
                                                             $BaudRateAttrCollection
                                                         )

                        # By default, use 115,200.
                        $BaudRate.Value                = 115200
                        $parameterDictionary.Add("BaudRate", $BaudRate)
                        break
                        #endregion BaudRate

                    } 
        
                    "1394" {
                        $ChannelAttr                   = New-Object System.Management.Automation.ParameterAttribute
                        $ChannelAttr.ParameterSetName  = "__AllParameterSets"
                        $ChannelAttr.Mandatory         = $false

                        $ChannelValidator              = New-Object System.Management.Automation.ValidateRangeAttribute(
                                                            0,
                                                            62
                                                         )

                        $ChannelNotNull                = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute

                        $ChannelAttrCollection         = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                        $ChannelAttrCollection.Add($ChannelAttr)
                        $ChannelAttrCollection.Add($ChannelValidator)
                        $ChannelAttrCollection.Add($ChannelNotNull)

                        $Channel                       = New-Object System.Management.Automation.RuntimeDefinedParameter(
                                                             "Channel",
                                                             [UInt16],
                                                             $ChannelAttrCollection
                                                         )

                        # By default, use channel 10
                        $Channel.Value                 = 10
                        $parameterDictionary.Add("Channel", $Channel)
                        break
                    } 
        
                    "USB" {
                        $TargetAttr                    = New-Object System.Management.Automation.ParameterAttribute
                        $TargetAttr.ParameterSetName   = "__AllParameterSets"
                        $TargetAttr.Mandatory          = $false

                        $TargetNotNull                 = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute

                        $TargetAttrCollection          = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                        $TargetAttrCollection.Add($TargetAttr)
                        $TargetAttrCollection.Add($TargetNotNull)

                        $Target                        = New-Object System.Management.Automation.RuntimeDefinedParameter(
                                                             "Target",
                                                             [string],
                                                             $TargetAttrCollection
                                                         )

                        # By default, use target = "debugging"
                        $Target.Value                  = "Debugging"
                        $parameterDictionary.Add("Target", $Target)
                        break
                    }
        
                    "Network" {
                        #region IP
                        $IpAttr                        = New-Object System.Management.Automation.ParameterAttribute
                        $IpAttr.ParameterSetName       = "__AllParameterSets"
                        $IpAttr.Mandatory              = $true

                        $IpValidator                   = New-Object System.Management.Automation.ValidatePatternAttribute(
                                                            "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"
                                                         )
                        $IpNotNull                     = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute

                        $IpAttrCollection              = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                        $IpAttrCollection.Add($IpAttr)
                        $IpAttrCollection.Add($IpValidator)
                        $IpAttrCollection.Add($IpNotNull)

                        $IP                            = New-Object System.Management.Automation.RuntimeDefinedParameter(
                                                             "IPAddress",
                                                             [string],
                                                             $IpAttrCollection
                                                         )

                        # There's no good way to set a default value for this.
                        $parameterDictionary.Add("IPAddress", $IP)
                        #endregion IP

                        #region Port
                        $PortAttr                      = New-Object System.Management.Automation.ParameterAttribute
                        $PortAttr.ParameterSetName     = "__AllParameterSets"
                        $PortAttr.Mandatory            = $false

                        $PortValidator                 = New-Object System.Management.Automation.ValidateRangeAttribute(
                                                            49152,
                                                            50039
                                                         )

                        $PortNotNull                   = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute

                        $PortAttrCollection            = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                        $PortAttrCollection.Add($PortAttr)
                        $PortAttrCollection.Add($PortValidator)
                        $PortAttrCollection.Add($PortNotNull)


                        $Port                          = New-Object System.Management.Automation.RuntimeDefinedParameter(
                                                             "Port",
                                                             [UInt16],
                                                             $PortAttrCollection
                                                         )

                        # By default, use port 50000
                        $Port.Value                    = 50000
                        $parameterDictionary.Add("Port", $Port)
                        #endregion Port

                        #region Key
                        $KeyAttr                       = New-Object System.Management.Automation.ParameterAttribute
                        $KeyAttr.ParameterSetName      = "__AllParameterSets"
                        $KeyAttr.Mandatory             = $true

                        $KeyValidator                  = New-Object System.Management.Automation.ValidatePatternAttribute(
                                                            "\b([A-Z0-9]+).([A-Z0-9]+).([A-Z0-9]+).([A-Z0-9]+)\b"
                                                         )

                        $KeyNotNull                    = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute

                        $KeyAttrCollection             = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                        $KeyAttrCollection.Add($KeyAttr)
                        $KeyAttrCollection.Add($KeyValidator)
                        $KeyAttrCollection.Add($KeyNotNull)

                        $Key                           = New-Object System.Management.Automation.RuntimeDefinedParameter(
                                                             "Key",
                                                             [string],
                                                             $KeyAttrCollection
                                                         )

                        # Don't set a default key.
                        $parameterDictionary.Add("Key", $Key)
                        #endregion Key

                        #region NoDHCP
                        $NoDHCPAttr                    = New-Object System.Management.Automation.ParameterAttribute
                        $NoDHCPAttr.ParameterSetName   = "__AllParameterSets"
                        $NoDHCPAttr.Mandatory          = $false

                        $NoDHCPAttrCollection          = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                        $NoDHCPAttrCollection.Add($NoDHCPAttr)

                        $NoDHCP                        = New-Object System.Management.Automation.RuntimeDefinedParameter(
                                                             "NoDHCP",
                                                             [switch],
                                                             $NoDHCPAttrCollection
                                                         )

                        $parameterDictionary.Add("NoDHCP", $NoDHCP)
                        #endregion NoDHCP

                        #region NewKey
                        $NewKeyAttr                    = New-Object System.Management.Automation.ParameterAttribute
                        $NewKeyAttr.ParameterSetName   = "__AllParameterSets"
                        $NewKeyAttr.Mandatory          = $false

                        $NewKeyAttrCollection          = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                        $NewKeyAttrCollection.Add($NewKeyAttr)

                        $NewKey                        = New-Object System.Management.Automation.RuntimeDefinedParameter(
                                                             "NewKey",
                                                             [switch],
                                                             $NewKeyAttrCollection
                                                         )

                        # Don't set a default key.
                        $parameterDictionary.Add("NewKey", $NewKey)
                        break
                        #endregion NewKey

                    }
        
                    # There's nothing to do for local debugging.
                    # Synthetic debugging is not yet implemented.
        
                    default {
                       break
                    }
                }
            }
    
            return $parameterDictionary   
        }

        Begin {
            ##########################################################################################
            #                             Constants and Pseudo-Constants
            ##########################################################################################
            $PARTITION_STYLE_MBR    = 0x00000000                                   # The default value
            $PARTITION_STYLE_GPT    = 0x00000001                                   # Just in case...

            # Version information that can be populated by timebuild.
            $ScriptVersion = DATA {

            ConvertFrom-StringData -StringData @"
        Major     = 10
        Minor     = 0
        Build     = 9000
        QFE       = 0
        Branch    = fbl_core1_hyp_dev(mikekol)
        Timestamp = 141224-3000
        Flavor    = amd64fre
"@
        }

          # $vQuality               = "Release to Web"
            $vQuality               = "Beta"

            $myVersion              = "$($ScriptVersion.Major).$($ScriptVersion.Minor).$($ScriptVersion.Build).$($ScriptVersion.QFE).$($ScriptVersion.Flavor).$($ScriptVersion.Branch).$($ScriptVersion.Timestamp)"
            $scriptName             = "Convert-WindowsImage"                       # Name of the script, obviously.
            $sessionKey             = [Guid]::NewGuid().ToString()                 # Session key, used for keeping records unique between multiple runs.
            $logFolder              = "$($env:Temp)\$($scriptName)\$($sessionKey)" # Log folder path.
            $vhdMaxSize             = 2040GB                                       # Maximum size for VHD is ~2040GB.
            $vhdxMaxSize            = 64TB                                         # Maximum size for VHDX is ~64TB.
            $lowestSupportedVersion = New-Object Version "6.1"                     # The lowest supported *image* version; making sure we don't run against Vista/2k8.
            $lowestSupportedBuild   = 8250                                         # The lowest supported *host* build.  Set to Win8 CP.
            $transcripting          = $false

            # Since we use the VHDFormat in output, make it uppercase.
            # We'll make it lowercase again when we use it as a file extension.
            $VHDFormat              = $VHDFormat.ToUpper()
            ##########################################################################################
            #                                      Here Strings
            ##########################################################################################

            # Text used for flag file embedded in VHD(X)
            $flagText = @"
This $VHDFormat was created by Convert-WindowsImage.ps1 $myVersion $vQuality
on $([DateTime]::Now).
"@

            # Banner text displayed during each run.
            $header    = @"

Windows(R) Image to Virtual Hard Disk Converter for Windows(R) 10
Copyright (C) Microsoft Corporation.  All rights reserved.
Version $myVersion $vQuality

"@

            # Text used as the banner in the UI.
            $uiHeader  = @"
You can use the fields below to configure the VHD or VHDX that you want to create!
"@

            $code      = @"
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Xml.Linq;
using System.Xml.XPath;
using Microsoft.Win32.SafeHandles;

namespace WIM2VHD {

    /// <summary>
    /// P/Invoke methods and associated enums, flags, and structs.
    /// </summary>
    public class
    NativeMethods {

        #region Delegates and Callbacks
        #region WIMGAPI

        ///<summary>
        ///User-defined function used with the RegisterMessageCallback or UnregisterMessageCallback function.
        ///</summary>
        ///<param name="MessageId">Specifies the message being sent.</param>
        ///<param name="wParam">Specifies additional message information. The contents of this parameter depend on the value of the
        ///MessageId parameter.</param>
        ///<param name="lParam">Specifies additional message information. The contents of this parameter depend on the value of the
        ///MessageId parameter.</param>
        ///<param name="UserData">Specifies the user-defined value passed to RegisterCallback.</param>
        ///<returns>
        ///To indicate success and to enable other subscribers to process the message return WIM_MSG_SUCCESS.
        ///To prevent other subscribers from receiving the message, return WIM_MSG_DONE.
        ///To cancel an image apply or capture, return WIM_MSG_ABORT_IMAGE when handling the WIM_MSG_PROCESS message.
        ///</returns>
        public delegate uint
        WimMessageCallback(
            uint   MessageId,
            IntPtr wParam,
            IntPtr lParam,
            IntPtr UserData
        );

        public static void
        RegisterMessageCallback(
            WimFileHandle hWim,
            WimMessageCallback callback) {

            uint _callback = NativeMethods.WimRegisterMessageCallback(hWim, callback, IntPtr.Zero);
            int rc = Marshal.GetLastWin32Error();
            if (0 != rc) {
                // Throw an exception if something bad happened on the Win32 end.
                throw
                    new InvalidOperationException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "Unable to register message callback."
                ));
            }
        }

        public static void 
        UnregisterMessageCallback(
            WimFileHandle hWim,
            WimMessageCallback registeredCallback) {

            bool status = NativeMethods.WimUnregisterMessageCallback(hWim, registeredCallback);
            int rc = Marshal.GetLastWin32Error();
            if (!status) {
                throw
                    new InvalidOperationException(
                        string.Format(
                            CultureInfo.CurrentCulture,
                            "Unable to unregister message callback."
                ));
            }
        }

        #endregion WIMGAPI
        #endregion Delegates and Callbacks

        #region Constants

        #region VDiskInterop

        /// <summary>
        /// The default depth in a VHD parent chain that this library will search through.
        /// If you want to go more than one disk deep into the parent chain, provide a different value.
        /// </summary>
        public   const uint  OPEN_VIRTUAL_DISK_RW_DEFAULT_DEPTH   = 0x00000001;

        public   const uint  DEFAULT_BLOCK_SIZE                   = 0x00080000;
        public   const uint  DISK_SECTOR_SIZE                     = 0x00000200;

        internal const uint  ERROR_VIRTDISK_NOT_VIRTUAL_DISK      = 0xC03A0015;
        internal const uint  ERROR_NOT_FOUND                      = 0x00000490;
        internal const uint  ERROR_IO_PENDING                     = 0x000003E5;
        internal const uint  ERROR_INSUFFICIENT_BUFFER            = 0x0000007A;
        internal const uint  ERROR_ERROR_DEV_NOT_EXIST            = 0x00000037;
        internal const uint  ERROR_BAD_COMMAND                    = 0x00000016;
        internal const uint  ERROR_SUCCESS                        = 0x00000000;

        public   const uint  GENERIC_READ                         = 0x80000000;
        public   const uint  GENERIC_WRITE                        = 0x40000000;
        public   const short FILE_ATTRIBUTE_NORMAL                = 0x00000080;
        public   const uint  CREATE_NEW                           = 0x00000001;
        public   const uint  CREATE_ALWAYS                        = 0x00000002;
        public   const uint  OPEN_EXISTING                        = 0x00000003;
        public   const short INVALID_HANDLE_VALUE                 = -1;

        internal static Guid VirtualStorageTypeVendorUnknown      = new Guid("00000000-0000-0000-0000-000000000000");
        internal static Guid VirtualStorageTypeVendorMicrosoft    = new Guid("EC984AEC-A0F9-47e9-901F-71415A66345B");

        #endregion VDiskInterop

        #region WIMGAPI

        public   const uint  WIM_FLAG_VERIFY                      = 0x00000002;
        public   const uint  WIM_FLAG_INDEX                       = 0x00000004;

        public   const uint  WM_APP                               = 0x00008000;

        #endregion WIMGAPI

        #endregion Constants

        #region Enums and Flags

        #region VDiskInterop

        /// <summary>
        /// Indicates the version of the virtual disk to create.
        /// </summary>
        public enum CreateVirtualDiskVersion : int {
            VersionUnspecified         = 0x00000000,
            Version1                   = 0x00000001,
            Version2                   = 0x00000002
        }

        public enum OpenVirtualDiskVersion : int {
            VersionUnspecified         = 0x00000000,
            Version1                   = 0x00000001,
            Version2                   = 0x00000002
        }

        /// <summary>
        /// Contains the version of the virtual hard disk (VHD) ATTACH_VIRTUAL_DISK_PARAMETERS structure to use in calls to VHD functions.
        /// </summary>
        public enum AttachVirtualDiskVersion : int {
            VersionUnspecified         = 0x00000000,
            Version1                   = 0x00000001,
            Version2                   = 0x00000002
        }

        public enum CompactVirtualDiskVersion : int {
            VersionUnspecified         = 0x00000000,
            Version1                   = 0x00000001
        }

        /// <summary>
        /// Contains the type and provider (vendor) of the virtual storage device.
        /// </summary>
        public enum VirtualStorageDeviceType : int {
            /// <summary>
            /// The storage type is unknown or not valid.
            /// </summary>
            Unknown                    = 0x00000000,
            /// <summary>
            /// For internal use only.  This type is not supported.
            /// </summary>
            ISO                        = 0x00000001,
            /// <summary>
            /// Virtual Hard Disk device type.
            /// </summary>
            VHD                        = 0x00000002,
            /// <summary>
            /// Virtual Hard Disk v2 device type.
            /// </summary>
            VHDX                       = 0x00000003
        }

        /// <summary>
        /// Contains virtual hard disk (VHD) open request flags.
        /// </summary>
        [Flags]
        public enum OpenVirtualDiskFlags {
            /// <summary>
            /// No flags. Use system defaults.
            /// </summary>
            None                       = 0x00000000,
            /// <summary>
            /// Open the VHD file (backing store) without opening any differencing-chain parents. Used to correct broken parent links.
            /// </summary>
            NoParents                  = 0x00000001,
            /// <summary>
            /// Reserved.
            /// </summary>
            BlankFile                  = 0x00000002,
            /// <summary>
            /// Reserved.
            /// </summary>
            BootDrive                  = 0x00000004,
        }

        /// <summary>
        /// Contains the bit mask for specifying access rights to a virtual hard disk (VHD).
        /// </summary>
        [Flags]
        public enum VirtualDiskAccessMask {
            /// <summary>
            /// Only Version2 of OpenVirtualDisk API accepts this parameter
            /// </summary>
            None                       = 0x00000000,
            /// <summary>
            /// Open the virtual disk for read-only attach access. The caller must have READ access to the virtual disk image file.
            /// </summary>
            /// <remarks>
            /// If used in a request to open a virtual disk that is already open, the other handles must be limited to either
            /// VIRTUAL_DISK_ACCESS_DETACH or VIRTUAL_DISK_ACCESS_GET_INFO access, otherwise the open request with this flag will fail.
            /// </remarks>
            AttachReadOnly             = 0x00010000,
            /// <summary>
            /// Open the virtual disk for read-write attaching access. The caller must have (READ | WRITE) access to the virtual disk image file.
            /// </summary>
            /// <remarks>
            /// If used in a request to open a virtual disk that is already open, the other handles must be limited to either
            /// VIRTUAL_DISK_ACCESS_DETACH or VIRTUAL_DISK_ACCESS_GET_INFO access, otherwise the open request with this flag will fail.
            /// If the virtual disk is part of a differencing chain, the disk for this request cannot be less than the readWriteDepth specified
            /// during the prior open request for that differencing chain.
            /// </remarks>
            AttachReadWrite            = 0x00020000,
            /// <summary>
            /// Open the virtual disk to allow detaching of an attached virtual disk. The caller must have
            /// (FILE_READ_ATTRIBUTES | FILE_READ_DATA) access to the virtual disk image file.
            /// </summary>
            Detach                     = 0x00040000,
            /// <summary>
            /// Information retrieval access to the virtual disk. The caller must have READ access to the virtual disk image file.
            /// </summary>
            GetInfo                    = 0x00080000,
            /// <summary>
            /// Virtual disk creation access.
            /// </summary>
            Create                     = 0x00100000,
            /// <summary>
            /// Open the virtual disk to perform offline meta-operations. The caller must have (READ | WRITE) access to the virtual
            /// disk image file, up to readWriteDepth if working with a differencing chain.
            /// </summary>
            /// <remarks>
            /// If the virtual disk is part of a differencing chain, the backing store (host volume) is opened in RW exclusive mode up to readWriteDepth.
            /// </remarks>
            MetaOperations             = 0x00200000,
            /// <summary>
            /// Reserved.
            /// </summary>
            Read                       = 0x000D0000,
            /// <summary>
            /// Allows unrestricted access to the virtual disk. The caller must have unrestricted access rights to the virtual disk image file.
            /// </summary>
            All                        = 0x003F0000,
            /// <summary>
            /// Reserved.
            /// </summary>
            Writable                   = 0x00320000
        }

        /// <summary>
        /// Contains virtual hard disk (VHD) creation flags.
        /// </summary>
        [Flags]
        public enum CreateVirtualDiskFlags {
            /// <summary>
            /// Contains virtual hard disk (VHD) creation flags.
            /// </summary>
            None                       = 0x00000000,
            /// <summary>
            /// Pre-allocate all physical space necessary for the size of the virtual disk.
            /// </summary>
            /// <remarks>
            /// The CREATE_VIRTUAL_DISK_FLAG_FULL_PHYSICAL_ALLOCATION flag is used for the creation of a fixed VHD.
            /// </remarks>
            FullPhysicalAllocation     = 0x00000001
        }

        /// <summary>
        /// Contains virtual disk attach request flags.
        /// </summary>
        [Flags]
        public enum AttachVirtualDiskFlags {
            /// <summary>
            /// No flags. Use system defaults.
            /// </summary>
            None                       = 0x00000000,
            /// <summary>
            /// Attach the virtual disk as read-only.
            /// </summary>
            ReadOnly                   = 0x00000001,
            /// <summary>
            /// No drive letters are assigned to the disk's volumes.
            /// </summary>
            /// <remarks>Oddly enough, this doesn't apply to NTFS mount points.</remarks>
            NoDriveLetter              = 0x00000002,
            /// <summary>
            /// Will decouple the virtual disk lifetime from that of the VirtualDiskHandle.
            /// The virtual disk will be attached until the Detach() function is called, even if all open handles to the virtual disk are closed.
            /// </summary>
            PermanentLifetime          = 0x00000004,
            /// <summary>
            /// Reserved.
            /// </summary>
            NoLocalHost                = 0x00000008
        }

        [Flags]
        public enum DetachVirtualDiskFlag {
            None                       = 0x00000000
        }

        [Flags]
        public enum CompactVirtualDiskFlags {
            None                       = 0x00000000,
            NoZeroScan                 = 0x00000001,
            NoBlockMoves               = 0x00000002
        }

        #endregion VDiskInterop

        #region WIMGAPI

        [FlagsAttribute]
        internal enum 
        WimCreateFileDesiredAccess 
            : uint {
            WimQuery                   = 0x00000000,
            WimGenericRead             = 0x80000000
        }

        /// <summary>
        /// Specifies how the file is to be treated and what features are to be used.
        /// </summary>
        [FlagsAttribute]
        internal enum
        WimApplyFlags
            : uint {
            /// <summary>
            /// No flags.
            /// </summary>
            WimApplyFlagsNone          = 0x00000000,
            /// <summary>
            /// Reserved.
            /// </summary>
            WimApplyFlagsReserved      = 0x00000001,
            /// <summary>
            /// Verifies that files match original data.
            /// </summary>
            WimApplyFlagsVerify        = 0x00000002,
            /// <summary>
            /// Specifies that the image is to be sequentially read for caching or performance purposes.
            /// </summary>
            WimApplyFlagsIndex         = 0x00000004,
            /// <summary>
            /// Applies the image without physically creating directories or files. Useful for obtaining a list of files and directories in the image.
            /// </summary>
            WimApplyFlagsNoApply       = 0x00000008,
            /// <summary>
            /// Disables restoring security information for directories.
            /// </summary>
            WimApplyFlagsNoDirAcl      = 0x00000010,
            /// <summary>
            /// Disables restoring security information for files
            /// </summary>
            WimApplyFlagsNoFileAcl     = 0x00000020,
            /// <summary>
            /// The .wim file is opened in a mode that enables simultaneous reading and writing.
            /// </summary>
            WimApplyFlagsShareWrite    = 0x00000040,
            /// <summary>
            /// Sends a WIM_MSG_FILEINFO message during the apply operation.
            /// </summary>
            WimApplyFlagsFileInfo      = 0x00000080,
            /// <summary>
            /// Disables automatic path fixups for junctions and symbolic links.
            /// </summary>
            WimApplyFlagsNoRpFix       = 0x00000100,
            /// <summary>
            /// Returns a handle that cannot commit changes, regardless of the access level requested at mount time.
            /// </summary>
            WimApplyFlagsMountReadOnly = 0x00000200,
            /// <summary>
            /// Reserved.
            /// </summary>
            WimApplyFlagsMountFast     = 0x00000400,
            /// <summary>
            /// Reserved.
            /// </summary>
            WimApplyFlagsMountLegacy   = 0x00000800
        }

        public enum WimMessage : uint {
            WIM_MSG                    = WM_APP + 0x1476,                
            WIM_MSG_TEXT,
            ///<summary>
            ///Indicates an update in the progress of an image application.
            ///</summary>
            WIM_MSG_PROGRESS,
            ///<summary>
            ///Enables the caller to prevent a file or a directory from being captured or applied.
            ///</summary>
            WIM_MSG_PROCESS,
            ///<summary>
            ///Indicates that volume information is being gathered during an image capture.
            ///</summary>
            WIM_MSG_SCANNING,
            ///<summary>
            ///Indicates the number of files that will be captured or applied.
            ///</summary>
            WIM_MSG_SETRANGE,
            ///<summary>
            ///Indicates the number of files that have been captured or applied.
            ///</summary>
            WIM_MSG_SETPOS,
            ///<summary>
            ///Indicates that a file has been either captured or applied.
            ///</summary>
            WIM_MSG_STEPIT,
            ///<summary>
            ///Enables the caller to prevent a file resource from being compressed during a capture.
            ///</summary>
            WIM_MSG_COMPRESS,
            ///<summary>
            ///Alerts the caller that an error has occurred while capturing or applying an image.
            ///</summary>
            WIM_MSG_ERROR,
            ///<summary>
            ///Enables the caller to align a file resource on a particular alignment boundary.
            ///</summary>
            WIM_MSG_ALIGNMENT,
            WIM_MSG_RETRY,
            ///<summary>
            ///Enables the caller to align a file resource on a particular alignment boundary.
            ///</summary>
            WIM_MSG_SPLIT,
            WIM_MSG_SUCCESS            = 0x00000000,                
            WIM_MSG_ABORT_IMAGE        = 0xFFFFFFFF
        }

        internal enum 
        WimCreationDisposition 
            : uint {
            WimOpenExisting            = 0x00000003,
        }

        internal enum 
        WimActionFlags 
            : uint {
            WimIgnored                 = 0x00000000
        }

        internal enum 
        WimCompressionType 
            : uint {
            WimIgnored                 = 0x00000000
        }

        internal enum 
        WimCreationResult 
            : uint {
            WimCreatedNew              = 0x00000000,
            WimOpenedExisting          = 0x00000001
        }

        #endregion WIMGAPI

        #endregion Enums and Flags

        #region Structs

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct CreateVirtualDiskParameters {
            /// <summary>
            /// A CREATE_VIRTUAL_DISK_VERSION enumeration that specifies the version of the CREATE_VIRTUAL_DISK_PARAMETERS structure being passed to or from the virtual hard disk (VHD) functions.
            /// </summary>
            public CreateVirtualDiskVersion Version;

            /// <summary>
            /// Unique identifier to assign to the virtual disk object. If this member is set to zero, a unique identifier is created by the system.
            /// </summary>
            public Guid UniqueId;

            /// <summary>
            /// The maximum virtual size of the virtual disk object. Must be a multiple of 512.
            /// If a ParentPath is specified, this value must be zero.
            /// If a SourcePath is specified, this value can be zero to specify the size of the source VHD to be used, otherwise the size specified must be greater than or equal to the size of the source disk.
            /// </summary>
            public ulong MaximumSize;

            /// <summary>
            /// Internal size of the virtual disk object blocks.
            /// The following are predefined block sizes and their behaviors. For a fixed VHD type, this parameter must be zero.
            /// </summary>
            public uint BlockSizeInBytes;

            /// <summary>
            /// Internal size of the virtual disk object sectors. Must be set to 512.
            /// </summary>
            public uint SectorSizeInBytes;

            /// <summary>
            /// Optional path to a parent virtual disk object. Associates the new virtual disk with an existing virtual disk.
            /// If this parameter is not NULL, SourcePath must be NULL.
            /// </summary>
            public string ParentPath;

            /// <summary>
            /// Optional path to pre-populate the new virtual disk object with block data from an existing disk. This path may refer to a VHD or a physical disk.
            /// If this parameter is not NULL, ParentPath must be NULL.
            /// </summary>
            public string SourcePath;

            /// <summary>
            /// Flags for opening the VHD
            /// </summary>
            public OpenVirtualDiskFlags OpenFlags;

            /// <summary>
            /// GetInfoOnly flag for V2 handles
            /// </summary>
            public bool GetInfoOnly;

            /// <summary>
            /// Virtual Storage Type of the parent disk
            /// </summary>
            public VirtualStorageType ParentVirtualStorageType;

            /// <summary>
            /// Virtual Storage Type of the source disk
            /// </summary>
            public VirtualStorageType SourceVirtualStorageType;

            /// <summary>
            /// A GUID to use for fallback resiliency over SMB.
            /// </summary>
            public Guid ResiliencyGuid;
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct VirtualStorageType {
            public VirtualStorageDeviceType DeviceId;
            public Guid VendorId;
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct SecurityDescriptor {
            public byte revision;
            public byte size;
            public short control;
            public IntPtr owner;
            public IntPtr group;
            public IntPtr sacl;
            public IntPtr dacl;
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct
        OpenVirtualDiskParameters {
            public OpenVirtualDiskVersion Version;
            public bool GetInfoOnly;
            public Guid ResiliencyGuid;
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct VirtualDiskProgress {
            public int OperationStatus;
            public ulong CurrentValue;
            public ulong CompletionValue;
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct AttachVirtualDiskParameters {
            public AttachVirtualDiskVersion Version;
            public int Reserved;
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct CompactVirtualDiskParameters {
            public CompactVirtualDiskVersion Version;
            public uint Reserved;
        }

        #endregion Structs

        #region VirtDisk.DLL P/Invoke

        [DllImport("virtdisk.dll", CharSet = CharSet.Unicode)]
        public static extern uint
        CreateVirtualDisk(
            [In, Out] ref VirtualStorageType VirtualStorageType,
            [In]          string Path,
            [In]          VirtualDiskAccessMask VirtualDiskAccessMask,
            [In, Out] ref SecurityDescriptor SecurityDescriptor,
            [In]          CreateVirtualDiskFlags Flags,
            [In]          uint ProviderSpecificFlags,
            [In, Out] ref CreateVirtualDiskParameters Parameters,
            [In]          IntPtr Overlapped,
            [Out]     out SafeFileHandle Handle);

        [DllImport("virtdisk.dll", CharSet = CharSet.Unicode)]
        internal static extern uint
        OpenVirtualDisk(
            [In, Out] ref VirtualStorageType VirtualStorageType,
            [In]          string Path,
            [In]          VirtualDiskAccessMask VirtualDiskAccessMask,
            [In]          OpenVirtualDiskFlags Flags,
            [In, Out] ref OpenVirtualDiskParameters Parameters,
            [Out]     out SafeFileHandle Handle);

        /// <summary>
        /// GetVirtualDiskOperationProgress API allows getting progress info for the async virtual disk operations (ie. Online Mirror)
        /// </summary>
        /// <param name="VirtualDiskHandle"></param>
        /// <param name="Overlapped"></param>
        /// <param name="Progress"></param>
        /// <returns></returns>
        [DllImport("virtdisk.dll", CharSet = CharSet.Unicode)]
        internal static extern uint
        GetVirtualDiskOperationProgress(
            [In]          SafeFileHandle VirtualDiskHandle,
            [In]          IntPtr Overlapped,
            [In, Out] ref VirtualDiskProgress Progress);

        [DllImport("virtdisk.dll", CharSet = CharSet.Unicode)]
        public static extern uint
        AttachVirtualDisk(
            [In]          SafeFileHandle VirtualDiskHandle,
            [In, Out] ref SecurityDescriptor SecurityDescriptor,
            [In]          AttachVirtualDiskFlags Flags,
            [In]          uint ProviderSpecificFlags,
            [In, Out] ref AttachVirtualDiskParameters Parameters,
            [In]          IntPtr Overlapped);

        [DllImport("virtdisk.dll", CharSet = CharSet.Unicode)]
        public static extern uint
        DetachVirtualDisk(
            [In]          SafeFileHandle VirtualDiskHandle,
            [In]          NativeMethods.DetachVirtualDiskFlag Flags,
            [In]          uint ProviderSpecificFlags);

        [DllImport("virtdisk.dll", CharSet = CharSet.Unicode)]
        public static extern uint
        CompactVirtualDisk(
            [In]          SafeFileHandle VirtualDiskHandle,
            [In]          CompactVirtualDiskFlags Flags,
            [In, Out] ref CompactVirtualDiskParameters Parameters,
            [In]          IntPtr Overlapped);

        [DllImport("virtdisk.dll", CharSet = CharSet.Unicode)]
        public static extern uint
        GetVirtualDiskPhysicalPath(
            [In]          SafeFileHandle VirtualDiskHandle,
            [In, Out] ref uint DiskPathSizeInBytes,
            [Out]         StringBuilder DiskPath);

        #endregion VirtDisk.DLL P/Invoke

        #region Win32 P/Invoke

        [DllImport("advapi32", SetLastError = true)]
        public static extern bool InitializeSecurityDescriptor(
            [Out]     out SecurityDescriptor pSecurityDescriptor,
            [In]          uint dwRevision);

        /// <summary>
        /// CreateEvent API is used while calling async Online Mirror API
        /// </summary>
        /// <param name="lpEventAttributes"></param>
        /// <param name="bManualReset"></param>
        /// <param name="bInitialState"></param>
        /// <param name="lpName"></param>
        /// <returns></returns>
        [DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
        internal static extern IntPtr
        CreateEvent(
            [In, Optional]  IntPtr lpEventAttributes,
            [In]            bool bManualReset,
            [In]            bool bInitialState,
            [In, Optional]  string lpName);

        #endregion Win32 P/Invoke

        #region WIMGAPI P/Invoke

        #region SafeHandle wrappers for WimFileHandle and WimImageHandle

        public sealed class WimFileHandle : SafeHandle {

            public WimFileHandle(
                string wimPath)
                : base(IntPtr.Zero, true) {

                if (String.IsNullOrEmpty(wimPath)) {
                    throw new ArgumentNullException("wimPath");
                }

                if (!File.Exists(Path.GetFullPath(wimPath))) {
                    throw new FileNotFoundException((new FileNotFoundException()).Message, wimPath);
                }

                NativeMethods.WimCreationResult creationResult;

                this.handle = NativeMethods.WimCreateFile(
                    wimPath,
                    NativeMethods.WimCreateFileDesiredAccess.WimGenericRead,
                    NativeMethods.WimCreationDisposition.WimOpenExisting,
                    NativeMethods.WimActionFlags.WimIgnored,
                    NativeMethods.WimCompressionType.WimIgnored,
                    out creationResult
                );

                // Check results.
                if (creationResult != NativeMethods.WimCreationResult.WimOpenedExisting) {
                    throw new Win32Exception();
                }

                if (this.handle == IntPtr.Zero) {
                    throw new Win32Exception();
                }

                // Set the temporary path.
                NativeMethods.WimSetTemporaryPath(
                    this,
                    Environment.ExpandEnvironmentVariables("%TEMP%")
                );
            }

            protected override bool ReleaseHandle() {
                return NativeMethods.WimCloseHandle(this.handle);
            }

            public override bool IsInvalid {
                get { return this.handle == IntPtr.Zero; }
            }
        }

        public sealed class WimImageHandle : SafeHandle {
            public WimImageHandle(
                WimFile Container,
                uint ImageIndex)
                : base(IntPtr.Zero, true) {

                if (null == Container) {
                    throw new ArgumentNullException("Container");
                }

                if ((Container.Handle.IsClosed) || (Container.Handle.IsInvalid)) {
                    throw new ArgumentNullException("The handle to the WIM file has already been closed, or is invalid.", "Container");
                }

                if (ImageIndex > Container.ImageCount) {
                    throw new ArgumentOutOfRangeException("ImageIndex", "The index does not exist in the specified WIM file.");
                }

                this.handle = NativeMethods.WimLoadImage(
                    Container.Handle.DangerousGetHandle(),
                    ImageIndex);
            }

            protected override bool ReleaseHandle() {
                return NativeMethods.WimCloseHandle(this.handle);
            }

            public override bool IsInvalid {
                get { return this.handle == IntPtr.Zero; }
            }
        }

        #endregion SafeHandle wrappers for WimFileHandle and WimImageHandle

        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMCreateFile")]
        internal static extern IntPtr
        WimCreateFile(
            [In, MarshalAs(UnmanagedType.LPWStr)] string WimPath,
            [In]    WimCreateFileDesiredAccess DesiredAccess,
            [In]    WimCreationDisposition CreationDisposition,
            [In]    WimActionFlags FlagsAndAttributes,
            [In]    WimCompressionType CompressionType,
            [Out, Optional] out WimCreationResult CreationResult
        );

        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMCloseHandle")]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern bool
        WimCloseHandle(
            [In]    IntPtr Handle
        );

        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMLoadImage")]
        internal static extern IntPtr
        WimLoadImage(
            [In]    IntPtr Handle,
            [In]    uint ImageIndex
        );

        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMGetImageCount")]
        internal static extern uint
        WimGetImageCount(
            [In]    WimFileHandle Handle
        );

        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMApplyImage")]
        internal static extern bool
        WimApplyImage(
            [In]    WimImageHandle Handle,
            [In, Optional, MarshalAs(UnmanagedType.LPWStr)] string Path,
            [In]    WimApplyFlags Flags
        );

        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMGetImageInformation")]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern bool
        WimGetImageInformation(
            [In]        SafeHandle Handle,
            [Out]   out StringBuilder ImageInfo,
            [Out]   out uint SizeOfImageInfo
        );

        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMSetTemporaryPath")]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern bool
        WimSetTemporaryPath(
            [In]    WimFileHandle Handle,
            [In]    string TempPath
        );

        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMRegisterMessageCallback", CallingConvention = CallingConvention.StdCall)]
        internal static extern uint
        WimRegisterMessageCallback(
            [In, Optional] WimFileHandle      hWim,
            [In]           WimMessageCallback MessageProc,
            [In, Optional] IntPtr             ImageInfo
        );

        [DllImport("Wimgapi.dll", CharSet = CharSet.Unicode, SetLastError = true, EntryPoint = "WIMUnregisterMessageCallback", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.Bool)]
        internal static extern bool
        WimUnregisterMessageCallback(
            [In, Optional] WimFileHandle      hWim,
            [In]           WimMessageCallback MessageProc
        );


        #endregion WIMGAPI P/Invoke
    }

    #region WIM Interop

    public class WimFile {

        internal XDocument m_xmlInfo;
        internal List<WimImage> m_imageList;

        private static NativeMethods.WimMessageCallback wimMessageCallback;
        
        #region Events
        
        /// <summary>
        /// DefaultImageEvent handler
        /// </summary>
        public delegate void DefaultImageEventHandler(object sender, DefaultImageEventArgs e);

        ///<summary>
        ///ProcessFileEvent handler
        ///</summary>
        public delegate void ProcessFileEventHandler(object sender, ProcessFileEventArgs e);
                
        ///<summary>
        ///Enable the caller to prevent a file resource from being compressed during a capture.
        ///</summary>
        public event ProcessFileEventHandler ProcessFileEvent;

        ///<summary>
        ///Indicate an update in the progress of an image application.
        ///</summary>
        public event DefaultImageEventHandler ProgressEvent;

        ///<summary>
        ///Alert the caller that an error has occurred while capturing or applying an image.
        ///</summary>
        public event DefaultImageEventHandler ErrorEvent;

        ///<summary>
        ///Indicate that a file has been either captured or applied.
        ///</summary>
        public event DefaultImageEventHandler StepItEvent;

        ///<summary>
        ///Indicate the number of files that will be captured or applied.
        ///</summary>
        public event DefaultImageEventHandler SetRangeEvent;

        ///<summary>
        ///Indicate the number of files that have been captured or applied.
        ///</summary>
        public event DefaultImageEventHandler SetPosEvent;

        #endregion Events

        private
        enum
        ImageEventMessage : uint {
            ///<summary>
            ///Enables the caller to prevent a file or a directory from being captured or applied.
            ///</summary>
            Progress = NativeMethods.WimMessage.WIM_MSG_PROGRESS,
            ///<summary>
            ///Notification sent to enable the caller to prevent a file or a directory from being captured or applied.
            ///To prevent a file or a directory from being captured or applied, call WindowsImageContainer.SkipFile().
            ///</summary>
            Process = NativeMethods.WimMessage.WIM_MSG_PROCESS,
            ///<summary>
            ///Enables the caller to prevent a file resource from being compressed during a capture.
            ///</summary>
            Compress = NativeMethods.WimMessage.WIM_MSG_COMPRESS,
            ///<summary>
            ///Alerts the caller that an error has occurred while capturing or applying an image.
            ///</summary>
            Error = NativeMethods.WimMessage.WIM_MSG_ERROR,
            ///<summary>
            ///Enables the caller to align a file resource on a particular alignment boundary.
            ///</summary>
            Alignment = NativeMethods.WimMessage.WIM_MSG_ALIGNMENT,
            ///<summary>
            ///Enables the caller to align a file resource on a particular alignment boundary.
            ///</summary>
            Split = NativeMethods.WimMessage.WIM_MSG_SPLIT,
            ///<summary>
            ///Indicates that volume information is being gathered during an image capture.
            ///</summary>
            Scanning = NativeMethods.WimMessage.WIM_MSG_SCANNING,
            ///<summary>
            ///Indicates the number of files that will be captured or applied.
            ///</summary>
            SetRange = NativeMethods.WimMessage.WIM_MSG_SETRANGE,
            ///<summary>
            ///Indicates the number of files that have been captured or applied.
            /// </summary>
            SetPos = NativeMethods.WimMessage.WIM_MSG_SETPOS,
            ///<summary>
            ///Indicates that a file has been either captured or applied.
            ///</summary>
            StepIt = NativeMethods.WimMessage.WIM_MSG_STEPIT,
            ///<summary>
            ///Success.
            ///</summary>
            Success = NativeMethods.WimMessage.WIM_MSG_SUCCESS,
            ///<summary>
            ///Abort.
            ///</summary>
            Abort = NativeMethods.WimMessage.WIM_MSG_ABORT_IMAGE
        }

        ///<summary>
        ///Event callback to the Wimgapi events
        ///</summary>
        private        
        uint
        ImageEventMessagePump(
            uint MessageId,
            IntPtr wParam,
            IntPtr lParam,
            IntPtr UserData) {

            uint status = (uint) NativeMethods.WimMessage.WIM_MSG_SUCCESS;

            DefaultImageEventArgs eventArgs = new DefaultImageEventArgs(wParam, lParam, UserData);

            switch ((ImageEventMessage)MessageId) {

                case ImageEventMessage.Progress:
                    ProgressEvent(this, eventArgs);
                    break;

                case ImageEventMessage.Process:
                    if (null != ProcessFileEvent) {
                        string fileToImage = Marshal.PtrToStringUni(wParam);
                        ProcessFileEventArgs fileToProcess = new ProcessFileEventArgs(fileToImage, lParam);
                        ProcessFileEvent(this, fileToProcess);

                        if (fileToProcess.Abort == true) {
                            status = (uint)ImageEventMessage.Abort;
                        }
                    }
                    break;

                case ImageEventMessage.Error:
                    if (null != ErrorEvent) {
                        ErrorEvent(this, eventArgs);
                    }
                    break;
                    
                case ImageEventMessage.SetRange:
                    if (null != SetRangeEvent) {
                        SetRangeEvent(this, eventArgs);
                    }
                    break;

                case ImageEventMessage.SetPos:
                    if (null != SetPosEvent) {
                        SetPosEvent(this, eventArgs);
                    }
                    break;

                case ImageEventMessage.StepIt:
                    if (null != StepItEvent) {
                        StepItEvent(this, eventArgs);
                    }
                    break;

                default:
                    break;
            }
            return status;
            
        }

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="wimPath">Path to the WIM container.</param>
        public
        WimFile(string wimPath) {
            if (string.IsNullOrEmpty(wimPath)) {
                throw new ArgumentNullException("wimPath");
            }

            if (!File.Exists(Path.GetFullPath(wimPath))) {
                throw new FileNotFoundException((new FileNotFoundException()).Message, wimPath);
            }

            Handle = new NativeMethods.WimFileHandle(wimPath);

            // Hook up the events before we return.
            //wimMessageCallback = new NativeMethods.WimMessageCallback(ImageEventMessagePump);
            //NativeMethods.RegisterMessageCallback(this.Handle, wimMessageCallback);
        }

        /// <summary>
        /// Closes the WIM file.
        /// </summary>
        public void
        Close() {
            foreach (WimImage image in Images) {
                image.Close();
            }

            if (null != wimMessageCallback) {
                NativeMethods.UnregisterMessageCallback(this.Handle, wimMessageCallback);
                wimMessageCallback = null;
            }

            if ((!Handle.IsClosed) && (!Handle.IsInvalid)) {
                Handle.Close();
            }
        }

        /// <summary>
        /// Provides a list of WimImage objects, representing the images in the WIM container file.
        /// </summary>
        public List<WimImage>
        Images {
            get {
                if (null == m_imageList) {

                    int imageCount = (int)ImageCount;
                    m_imageList = new List<WimImage>(imageCount);
                    for (int i = 0; i < imageCount; i++) {

                        // Load up each image so it's ready for us.
                        m_imageList.Add(
                            new WimImage(this, (uint)i + 1));
                    }
                }

                return m_imageList;
            }
        }

        /// <summary>
        /// Provides a list of names of the images in the specified WIM container file.
        /// </summary>
        public List<string>
        ImageNames {
            get {
                List<string> nameList = new List<string>();
                foreach (WimImage image in Images) {
                    nameList.Add(image.ImageName);
                }
                return nameList;
            }
        }

        /// <summary>
        /// Indexer for WIM images inside the WIM container, indexed by the image number.
        /// The list of Images is 0-based, but the WIM container is 1-based, so we automatically compensate for that.
        /// this[1] returns the 0th image in the WIM container.
        /// </summary>
        /// <param name="ImageIndex">The 1-based index of the image to retrieve.</param>
        /// <returns>WinImage object.</returns>
        public WimImage
        this[int ImageIndex] {
            get { return Images[ImageIndex - 1]; }
        }

        /// <summary>
        /// Indexer for WIM images inside the WIM container, indexed by the image name.
        /// WIMs created by different processes sometimes contain different information - including the name.
        /// Some images have their name stored in the Name field, some in the Flags field, and some in the EditionID field.
        /// We take all of those into account in while searching the WIM.
        /// </summary>
        /// <param name="ImageName"></param>
        /// <returns></returns>
        public WimImage
        this[string ImageName] {
            get {
                return
                    Images.Where(i => (
                        i.ImageName.ToUpper()  == ImageName.ToUpper() ||
                        i.ImageFlags.ToUpper() == ImageName.ToUpper() ))
                    .DefaultIfEmpty(null)
                        .FirstOrDefault<WimImage>();
            }
        }

        /// <summary>
        /// Returns the number of images in the WIM container.
        /// </summary>
        internal uint
        ImageCount {
            get { return NativeMethods.WimGetImageCount(Handle); }
        }

        /// <summary>
        /// Returns an XDocument representation of the XML metadata for the WIM container and associated images.
        /// </summary>
        internal XDocument
        XmlInfo {
            get {

                if (null == m_xmlInfo) {
                    StringBuilder builder;
                    uint bytes;
                    if (!NativeMethods.WimGetImageInformation(Handle, out builder, out bytes)) {
                        throw new Win32Exception();
                    }

                    // Ensure the length of the returned bytes to avoid garbage characters at the end.
                    int charCount = (int)bytes / sizeof(char);
                    if (null != builder) {
                        // Get rid of the unicode file marker at the beginning of the XML.
                        builder.Remove(0, 1);
                        builder.EnsureCapacity(charCount - 1);
                        builder.Length = charCount - 1;

                        // This isn't likely to change while we have the image open, so cache it.
                        m_xmlInfo = XDocument.Parse(builder.ToString().Trim());
                    } else {
                        m_xmlInfo = null;
                    }
                }

                return m_xmlInfo;
            }
        }

        public NativeMethods.WimFileHandle Handle {
            get;
            private set;
        }
    }

    public class
    WimImage {

        internal XDocument m_xmlInfo;

        public
        WimImage(
            WimFile Container,
            uint ImageIndex) {

            if (null == Container) {
                throw new ArgumentNullException("Container");
            }

            if ((Container.Handle.IsClosed) || (Container.Handle.IsInvalid)) {
                throw new ArgumentNullException("The handle to the WIM file has already been closed, or is invalid.", "Container");
            }

            if (ImageIndex > Container.ImageCount) {
                throw new ArgumentOutOfRangeException("ImageIndex", "The index does not exist in the specified WIM file.");
            }

            Handle = new NativeMethods.WimImageHandle(Container, ImageIndex);            
        }

        public enum
        Architectures : uint {
            x86   = 0x0,
            ARM   = 0x5,
            IA64  = 0x6,
            AMD64 = 0x9
        }

        public void
        Close() {
            if ((!Handle.IsClosed) && (!Handle.IsInvalid)) {
                Handle.Close();
            }
        }

        public void
        Apply(
            string ApplyToPath) {

            if (string.IsNullOrEmpty(ApplyToPath)) {
                throw new ArgumentNullException("ApplyToPath");
            }

            ApplyToPath = Path.GetFullPath(ApplyToPath);

            if (!Directory.Exists(ApplyToPath)) {
                throw new DirectoryNotFoundException("The WIM cannot be applied because the specified directory was not found.");
            }

            if (!NativeMethods.WimApplyImage(
                this.Handle,
                ApplyToPath,
                NativeMethods.WimApplyFlags.WimApplyFlagsNone
            )) {
                throw new Win32Exception();
            }
        }

        public NativeMethods.WimImageHandle
        Handle {
            get;
            private set;
        }

        internal XDocument
        XmlInfo {
            get {

                if (null == m_xmlInfo) {
                    StringBuilder builder;
                    uint bytes;
                    if (!NativeMethods.WimGetImageInformation(Handle, out builder, out bytes)) {
                        throw new Win32Exception();
                    }

                    // Ensure the length of the returned bytes to avoid garbage characters at the end.
                    int charCount = (int)bytes / sizeof(char);
                    if (null != builder) {
                        // Get rid of the unicode file marker at the beginning of the XML.
                        builder.Remove(0, 1);
                        builder.EnsureCapacity(charCount - 1);
                        builder.Length = charCount - 1;

                        // This isn't likely to change while we have the image open, so cache it.
                        m_xmlInfo = XDocument.Parse(builder.ToString().Trim());
                    } else {
                        m_xmlInfo = null;
                    }
                }

                return m_xmlInfo;
            }
        }

        public string 
        ImageIndex {
            get { return XmlInfo.Element("IMAGE").Attribute("INDEX").Value; }
        }

        public string
        ImageName {
            get { return XmlInfo.XPathSelectElement("/IMAGE/NAME").Value; }
        }

        public string
        ImageEditionId {
            get { return XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/EDITIONID").Value; }
        }

        public string
        ImageFlags {
            get { return XmlInfo.XPathSelectElement("/IMAGE/FLAGS").Value; }
        }

        public string
        ImageProductType {
            get {
                return XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/PRODUCTTYPE").Value;
            }
        }

        public string
        ImageInstallationType {
            get { return XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/INSTALLATIONTYPE").Value; }
        }

        public string
        ImageDescription {
            get { return XmlInfo.XPathSelectElement("/IMAGE/DESCRIPTION").Value; }
        }

        public ulong
        ImageSize {
            get { return ulong.Parse(XmlInfo.XPathSelectElement("/IMAGE/TOTALBYTES").Value); }
        }

        public Architectures
        ImageArchitecture {
            get {
                int arch = -1;
                try {
                    arch = int.Parse(XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/ARCH").Value);
                } catch { }

                return (Architectures)arch;
            }
        }

        public string
        ImageDefaultLanguage {
            get {
                string lang = null;
                try {
                    lang = XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/LANGUAGES/DEFAULT").Value;
                } catch { }

                return lang;
            }
        }

        public Version
        ImageVersion {
            get {
                int major = 0;
                int minor = 0;
                int build = 0;
                int revision = 0;

                try {
                    major = int.Parse(XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/VERSION/MAJOR").Value);
                    minor = int.Parse(XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/VERSION/MINOR").Value);
                    build = int.Parse(XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/VERSION/BUILD").Value);
                    revision = int.Parse(XmlInfo.XPathSelectElement("/IMAGE/WINDOWS/VERSION/SPBUILD").Value);
                } catch { }

                return (new Version(major, minor, build, revision));
            }
        }

        public string
        ImageDisplayName {
            get { return XmlInfo.XPathSelectElement("/IMAGE/DISPLAYNAME").Value; }
        }

        public string
        ImageDisplayDescription {
            get { return XmlInfo.XPathSelectElement("/IMAGE/DISPLAYDESCRIPTION").Value; }
        }
    }

    ///<summary>
    ///Describes the file that is being processed for the ProcessFileEvent.
    ///</summary>
    public class
    DefaultImageEventArgs : EventArgs {
        ///<summary>
        ///Default constructor.
        ///</summary>
        public
        DefaultImageEventArgs(
            IntPtr wideParameter, 
            IntPtr leftParameter, 
            IntPtr userData) {
            
            WideParameter = wideParameter;
            LeftParameter = leftParameter;
            UserData      = userData;
        }

        ///<summary>
        ///wParam
        ///</summary>
        public IntPtr WideParameter {
            get;
            private set;
        }

        ///<summary>
        ///lParam
        ///</summary>
        public IntPtr LeftParameter {
            get;
            private set;
        }

        ///<summary>
        ///UserData
        ///</summary>
        public IntPtr UserData {
            get;
            private set;
        }
    }

    ///<summary>
    ///Describes the file that is being processed for the ProcessFileEvent.
    ///</summary>
    public class
    ProcessFileEventArgs : EventArgs {
        ///<summary>
        ///Default constructor.
        ///</summary>
        ///<param name="file">Fully qualified path and file name. For example: c:\file.sys.</param>
        ///<param name="skipFileFlag">Default is false - skip file and continue.
        ///Set to true to abort the entire image capture.</param>
        public
        ProcessFileEventArgs(
            string file, 
            IntPtr skipFileFlag) {

            m_FilePath = file;
            m_SkipFileFlag = skipFileFlag;
        }

        ///<summary>
        ///Skip file from being imaged.
        ///</summary>
        public void
        SkipFile() {
            byte[] byteBuffer = {
                    0
            };
            int byteBufferSize = byteBuffer.Length;
            Marshal.Copy(byteBuffer, 0, m_SkipFileFlag, byteBufferSize);
        }

        ///<summary>
        ///Fully qualified path and file name.
        ///</summary>
        public string 
        FilePath {
            get {
                string stringToReturn = "";
                if (m_FilePath != null) {
                    stringToReturn = m_FilePath;
                }
                return stringToReturn;
            }
        }

        ///<summary>
        ///Flag to indicate if the entire image capture should be aborted.
        ///Default is false - skip file and continue. Setting to true will
        ///abort the entire image capture.
        ///</summary>
        public bool Abort {
            set { m_Abort = value; }
            get { return m_Abort;  }
        }

        private string m_FilePath;
        private bool m_Abort;
        private IntPtr m_SkipFileFlag;

    }

    #endregion WIM Interop

    #region VHD Interop
    // Based on code written by the Hyper-V Test team.
    /// <summary>
    /// The Virtual Hard Disk class provides methods for creating and manipulating Virtual Hard Disk files.
    /// </summary>
    public class
    VirtualHardDisk : IDisposable {

        #region Member Variables

        private SafeFileHandle m_virtualHardDiskHandle = null;
        private string m_filePath = null;
        private bool m_isDisposed;
        private NativeMethods.VirtualStorageDeviceType m_deviceType = NativeMethods.VirtualStorageDeviceType.Unknown;

        #endregion Member Variables

        #region IDisposable Members

        /// <summary>
        /// Disposal method for Virtual Hard Disk objects.
        /// </summary>
        public void
        Dispose() {
            this.Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Disposal method for Virtual Hard Disk objects.
        /// </summary>
        /// <param name="disposing"></param>
        public void
        Dispose(
            bool disposing) {
            // Check to see if Dispose has already been called.
            if (!this.m_isDisposed) {
                // If disposing equals true, dispose all managed
                // and unmanaged resources.
                if (disposing) {
                    // Dispose managed resources.
                    if (this.DiskIndex != 0) {
                        this.Close();
                    }
                }

                // Call the appropriate methods to clean up
                // unmanaged resources here.
                // If disposing is false,
                // only the following code is executed.

                // Note disposing has been done.
                m_isDisposed = true;
            }
        }

        #endregion IDisposable Members

        #region Constructor

        private VirtualHardDisk(
            SafeFileHandle Handle,
            string Path,
            NativeMethods.VirtualStorageDeviceType DeviceType) {
            if (Handle.IsInvalid || Handle.IsClosed) {
                throw new InvalidOperationException("The handle to the Virtual Hard Disk is invalid.");
            }

            m_virtualHardDiskHandle = Handle;
            m_filePath = Path;
            m_deviceType = DeviceType;
        }

        #endregion Constructor

        #region Gozer the Destructor
        /// <summary>
        /// Destroys a VHD object.
        /// </summary>
        ~VirtualHardDisk() {
            this.Dispose(false);
        }

        #endregion Gozer the Destructor

        #region Static Methods

        #region Sparse Disks

        /// <summary>
        /// Abbreviated signature of CreateSparseDisk so it's easier to use from WIM2VHD.
        /// </summary>
        /// <param name="virtualStorageDeviceType">The type of disk to create, VHD or VHDX.</param>
        /// <param name="path">The path of the disk to create.</param>
        /// <param name="size">The maximum size of the disk to create.</param>
        /// <param name="overwrite">Overwrite the VHD if it already exists.</param>
        /// <returns>Virtual Hard Disk object</returns>
        public static VirtualHardDisk
        CreateSparseDisk(
            NativeMethods.VirtualStorageDeviceType virtualStorageDeviceType,
            string path,
            ulong size,
            bool overwrite) {

            return CreateSparseDisk(
                path,
                size,
                overwrite,
                null,
                IntPtr.Zero,
                (virtualStorageDeviceType == NativeMethods.VirtualStorageDeviceType.VHD) 
                    ? NativeMethods.DEFAULT_BLOCK_SIZE
                    : 0,
                virtualStorageDeviceType,
                NativeMethods.DISK_SECTOR_SIZE);
        }

        /// <summary>
        /// Creates a new sparse (dynamically expanding) virtual hard disk (.vhd). Supports both sync and async modes.
        /// The VHD image file uses only as much space on the backing store as needed to store the actual data the VHD currently contains. 
        /// </summary>
        /// <param name="path">The path and name of the VHD to create.</param>
        /// <param name="size">The size of the VHD to create in bytes.  
        /// When creating this type of VHD, the VHD API does not test for free space on the physical backing store based on the maximum size requested, 
        /// therefore it is possible to successfully create a dynamic VHD with a maximum size larger than the available physical disk free space.
        /// The maximum size of a dynamic VHD is 2,040 GB.  The minimum size is 3 MB.</param>
        /// <param name="source">Optional path to pre-populate the new virtual disk object with block data from an existing disk
        /// This path may refer to a VHD or a physical disk.  Use NULL if you don't want a source.</param>
        /// <param name="overwrite">If the VHD exists, setting this parameter to 'True' will delete it and create a new one.</param>
        /// <param name="overlapped">If not null, the operation runs in async mode</param>
        /// <param name="blockSizeInBytes">Block size for the VHD.</param>
        /// <param name="virtualStorageDeviceType">VHD format version (VHD1 or VHD2)</param>
        /// <param name="sectorSizeInBytes">Sector size for the VHD.</param>
        /// <returns>Returns a SafeFileHandle corresponding to the virtual hard disk that was created.</returns>
        /// <exception cref="ArgumentOutOfRangeException">Thrown when an invalid size is specified</exception>
        /// <exception cref="FileNotFoundException">Thrown when source VHD is not found.</exception>
        /// <exception cref="SecurityException">Thrown when there was an error while creating the default security descriptor.</exception>
        /// <exception cref="Win32Exception">Thrown when an error occurred while creating the VHD.</exception>
        public static VirtualHardDisk
        CreateSparseDisk(
            string path,
            ulong size,
            bool overwrite,
            string source,
            IntPtr overlapped,
            uint blockSizeInBytes,
            NativeMethods.VirtualStorageDeviceType virtualStorageDeviceType,
            uint sectorSizeInBytes) {

            // Validate the virtualStorageDeviceType
            if (virtualStorageDeviceType != NativeMethods.VirtualStorageDeviceType.VHD && virtualStorageDeviceType != NativeMethods.VirtualStorageDeviceType.VHDX) {

                throw (
                    new ArgumentOutOfRangeException(
                        "virtualStorageDeviceType",
                        virtualStorageDeviceType,
                        "VirtualStorageDeviceType must be VHD or VHDX."
                ));
            }

            // Validate size.  It needs to be a multiple of DISK_SECTOR_SIZE (512)...
            if ((size % NativeMethods.DISK_SECTOR_SIZE) != 0) {

                throw (
                    new ArgumentOutOfRangeException(
                        "size", 
                        size, 
                        "The size of the virtual disk must be a multiple of 512."
                ));
            }

            if ((!String.IsNullOrEmpty(source)) && (!System.IO.File.Exists(source))) {

                throw (
                    new System.IO.FileNotFoundException(
                        "Unable to find the source file.",
                        source
                ));
            }

            if ((overwrite) && (System.IO.File.Exists(path))) {

                System.IO.File.Delete(path);
            }

            NativeMethods.CreateVirtualDiskParameters createParams = new NativeMethods.CreateVirtualDiskParameters();

            // Select the correct version.
            createParams.Version = (virtualStorageDeviceType == NativeMethods.VirtualStorageDeviceType.VHD)
                ? NativeMethods.CreateVirtualDiskVersion.Version1
                : NativeMethods.CreateVirtualDiskVersion.Version2;

            createParams.UniqueId                 = Guid.NewGuid();
            createParams.MaximumSize              = size;
            createParams.BlockSizeInBytes         = blockSizeInBytes;
            createParams.SectorSizeInBytes        = sectorSizeInBytes;
            createParams.ParentPath               = null;
            createParams.SourcePath               = source;
            createParams.OpenFlags                = NativeMethods.OpenVirtualDiskFlags.None;
            createParams.GetInfoOnly              = false;
            createParams.ParentVirtualStorageType = new NativeMethods.VirtualStorageType();
            createParams.SourceVirtualStorageType = new NativeMethods.VirtualStorageType();

            //
            // Create and init a security descriptor.
            // Since we're creating an essentially blank SD to use with CreateVirtualDisk
            // the VHD will take on the security values from the parent directory.
            //

            NativeMethods.SecurityDescriptor securityDescriptor;
            if (!NativeMethods.InitializeSecurityDescriptor(out securityDescriptor, 1)) {

                throw (
                    new SecurityException(
                        "Unable to initialize the security descriptor for the virtual disk."
                ));
            }

            NativeMethods.VirtualStorageType virtualStorageType = new NativeMethods.VirtualStorageType();
            virtualStorageType.DeviceId = virtualStorageDeviceType;
            virtualStorageType.VendorId = NativeMethods.VirtualStorageTypeVendorMicrosoft;

            SafeFileHandle vhdHandle;

            uint returnCode = NativeMethods.CreateVirtualDisk(
                ref virtualStorageType,
                    path,
                    (virtualStorageDeviceType == NativeMethods.VirtualStorageDeviceType.VHD)
                        ? NativeMethods.VirtualDiskAccessMask.All
                        : NativeMethods.VirtualDiskAccessMask.None,
                ref securityDescriptor,
                    NativeMethods.CreateVirtualDiskFlags.None,
                    0,
                ref createParams,
                    overlapped,
                out vhdHandle);

            if (NativeMethods.ERROR_SUCCESS != returnCode && NativeMethods.ERROR_IO_PENDING != returnCode) {

                throw (
                    new Win32Exception(
                        (int)returnCode
                ));
            }

            return new VirtualHardDisk(vhdHandle, path, virtualStorageDeviceType);
        }

        #endregion Sparse Disks

        #region Fixed Disks

        /// <summary>
        /// Abbreviated signature of CreateFixedDisk so it's easier to use from WIM2VHD.
        /// </summary>
        /// <param name="virtualStorageDeviceType">The type of disk to create, VHD or VHDX.</param>
        /// <param name="path">The path of the disk to create.</param>
        /// <param name="size">The maximum size of the disk to create.</param>
        /// <param name="overwrite">Overwrite the VHD if it already exists.</param>
        /// <returns>Virtual Hard Disk object</returns>
        public static VirtualHardDisk
        CreateFixedDisk(
            NativeMethods.VirtualStorageDeviceType virtualStorageDeviceType,
            string path,
            ulong size,
            bool overwrite) {

            return CreateFixedDisk(
                path,
                size,
                overwrite,
                null,
                IntPtr.Zero,
                0,
                virtualStorageDeviceType,
                NativeMethods.DISK_SECTOR_SIZE);
        }

        /// <summary>
        /// Creates a fixed-size Virtual Hard Disk. Supports both sync and async modes. This methods always calls the V2 version of the 
        /// CreateVirtualDisk API, and creates VHD2. 
        /// </summary>
        /// <param name="path">The path and name of the VHD to create.</param>
        /// <param name="size">The size of the VHD to create in bytes.  
        /// The VHD image file is pre-allocated on the backing store for the maximum size requested.
        /// The maximum size of a dynamic VHD is 2,040 GB.  The minimum size is 3 MB.</param>
        /// <param name="source">Optional path to pre-populate the new virtual disk object with block data from an existing disk
        /// This path may refer to a VHD or a physical disk.  Use NULL if you don't want a source.</param>
        /// <param name="overwrite">If the VHD exists, setting this parameter to 'True' will delete it and create a new one.</param>
        /// <param name="overlapped">If not null, the operation runs in async mode</param>
        /// <param name="blockSizeInBytes">Block size for the VHD.</param>
        /// <param name="virtualStorageDeviceType">Virtual storage device type: VHD1 or VHD2.</param>
        /// <param name="sectorSizeInBytes">Sector size for the VHD.</param>
        /// <returns>Returns a SafeFileHandle corresponding to the virtual hard disk that was created.</returns>
        /// <remarks>Creating a fixed disk can be a time consuming process!</remarks>  
        /// <exception cref="ArgumentOutOfRangeException">Thrown when an invalid size or wrong virtual storage device type is specified.</exception>
        /// <exception cref="FileNotFoundException">Thrown when source VHD is not found.</exception>
        /// <exception cref="SecurityException">Thrown when there was an error while creating the default security descriptor.</exception>
        /// <exception cref="Win32Exception">Thrown when an error occurred while creating the VHD.</exception>
        public static VirtualHardDisk
        CreateFixedDisk(
            string path,
            ulong size,
            bool overwrite,
            string source,
            IntPtr overlapped,
            uint blockSizeInBytes,
            NativeMethods.VirtualStorageDeviceType virtualStorageDeviceType,
            uint sectorSizeInBytes) {

            // Validate the virtualStorageDeviceType
            if (virtualStorageDeviceType != NativeMethods.VirtualStorageDeviceType.VHD && virtualStorageDeviceType != NativeMethods.VirtualStorageDeviceType.VHDX) {

                throw (
                    new ArgumentOutOfRangeException(
                        "virtualStorageDeviceType",
                        virtualStorageDeviceType,
                        "VirtualStorageDeviceType must be VHD or VHDX."
                ));
            }

            // Validate size.  It needs to be a multiple of DISK_SECTOR_SIZE (512)...
            if ((size % NativeMethods.DISK_SECTOR_SIZE) != 0) {

                throw (
                    new ArgumentOutOfRangeException(
                        "size",
                        size,
                        "The size of the virtual disk must be a multiple of 512."
                ));
            }

            if ((!String.IsNullOrEmpty(source)) && (!System.IO.File.Exists(source))) {

                throw (
                    new System.IO.FileNotFoundException(
                        "Unable to find the source file.",
                        source
                ));
            }

            if ((overwrite) && (System.IO.File.Exists(path))) {

                System.IO.File.Delete(path);
            }

            NativeMethods.CreateVirtualDiskParameters createParams = new NativeMethods.CreateVirtualDiskParameters();

            // Select the correct version.
            createParams.Version = (virtualStorageDeviceType == NativeMethods.VirtualStorageDeviceType.VHD)
                ? NativeMethods.CreateVirtualDiskVersion.Version1
                : NativeMethods.CreateVirtualDiskVersion.Version2;

            createParams.UniqueId                 = Guid.NewGuid();
            createParams.MaximumSize              = size;
            createParams.BlockSizeInBytes         = blockSizeInBytes;
            createParams.SectorSizeInBytes        = sectorSizeInBytes;
            createParams.ParentPath               = null;
            createParams.SourcePath               = source;
            createParams.OpenFlags                = NativeMethods.OpenVirtualDiskFlags.None;
            createParams.GetInfoOnly              = false;
            createParams.ParentVirtualStorageType = new NativeMethods.VirtualStorageType();
            createParams.SourceVirtualStorageType = new NativeMethods.VirtualStorageType();

            //
            // Create and init a security descriptor.
            // Since we're creating an essentially blank SD to use with CreateVirtualDisk
            // the VHD will take on the security values from the parent directory.
            //

            NativeMethods.SecurityDescriptor securityDescriptor;
            if (!NativeMethods.InitializeSecurityDescriptor(out securityDescriptor, 1)) {
                throw (
                    new SecurityException(
                        "Unable to initialize the security descriptor for the virtual disk."
                ));
            }

            NativeMethods.VirtualStorageType virtualStorageType = new NativeMethods.VirtualStorageType();
            virtualStorageType.DeviceId = virtualStorageDeviceType;
            virtualStorageType.VendorId = NativeMethods.VirtualStorageTypeVendorMicrosoft;

            SafeFileHandle vhdHandle;

            uint returnCode = NativeMethods.CreateVirtualDisk(
                ref virtualStorageType,
                    path,
                    (virtualStorageDeviceType == NativeMethods.VirtualStorageDeviceType.VHD)
                        ? NativeMethods.VirtualDiskAccessMask.All
                        : NativeMethods.VirtualDiskAccessMask.None,
                ref securityDescriptor,
                    NativeMethods.CreateVirtualDiskFlags.FullPhysicalAllocation,
                    0,
                ref createParams,
                    overlapped,
                out vhdHandle);

            if (NativeMethods.ERROR_SUCCESS != returnCode && NativeMethods.ERROR_IO_PENDING != returnCode) {

                throw (
                    new Win32Exception(
                        (int)returnCode
                ));
            }

            return new VirtualHardDisk(vhdHandle, path, virtualStorageDeviceType);
        }

        #endregion Fixed Disks

        #region Open

        /// <summary>
        /// Opens a virtual hard disk (VHD) using the V2 of OpenVirtualDisk Win32 API for use, allowing you to explicitly specify OpenVirtualDiskFlags, 
        /// Read/Write depth, and Access Mask information.
        /// </summary>
        /// <param name="path">The path and name of the Virtual Hard Disk file to open.</param>
        /// <param name="accessMask">Contains the bit mask for specifying access rights to a virtual hard disk (VHD).  Default is All.</param>
        /// <param name="readWriteDepth">Indicates the number of stores, beginning with the child, of the backing store chain to open as read/write. 
        /// The remaining stores in the differencing chain will be opened read-only. This is necessary for merge operations to succeed.  Default is 0x1.</param>
        /// <param name="flags">An OpenVirtualDiskFlags object to modify the way the Virtual Hard Disk is opened.  Default is Unknown.</param>
        /// <param name="virtualStorageDeviceType">VHD Format Version (VHD1 or VHD2)</param>
        /// <returns>VirtualHardDisk object</returns>
        /// <exception cref="FileNotFoundException">Thrown if the VHD at path is not found.</exception>
        /// <exception cref="Win32Exception">Thrown if an error occurred while opening the VHD.</exception>
        public static VirtualHardDisk
        Open(
            string path,
            NativeMethods.VirtualDiskAccessMask accessMask,
            uint readWriteDepth,
            NativeMethods.OpenVirtualDiskFlags flags,
            NativeMethods.VirtualStorageDeviceType virtualStorageDeviceType) {

            if (!File.Exists(path)) {
                throw new FileNotFoundException("The specified VHD was not found.  Please check your path and try again.", path);
            }

            NativeMethods.OpenVirtualDiskParameters openParams = new NativeMethods.OpenVirtualDiskParameters();

            // Select the correct version.
            openParams.Version = (virtualStorageDeviceType == NativeMethods.VirtualStorageDeviceType.VHD)
                ? NativeMethods.OpenVirtualDiskVersion.Version1
                : NativeMethods.OpenVirtualDiskVersion.Version2;

            openParams.GetInfoOnly = false;

            NativeMethods.VirtualStorageType virtualStorageType = new NativeMethods.VirtualStorageType();
            virtualStorageType.DeviceId = virtualStorageDeviceType;

            virtualStorageType.VendorId = (virtualStorageDeviceType == NativeMethods.VirtualStorageDeviceType.Unknown)
                ? virtualStorageType.VendorId = NativeMethods.VirtualStorageTypeVendorUnknown
                : virtualStorageType.VendorId = NativeMethods.VirtualStorageTypeVendorMicrosoft;

            SafeFileHandle vhdHandle;

            uint returnCode = NativeMethods.OpenVirtualDisk(
                ref virtualStorageType,
                    path,
                    accessMask,
                    flags,
                ref openParams,
                out vhdHandle);

            if (NativeMethods.ERROR_SUCCESS != returnCode) {
                throw new Win32Exception((int)returnCode);
            }

            return new VirtualHardDisk(vhdHandle, path, virtualStorageDeviceType);
        }

        #endregion Open

        #region Other

        /// <summary>
        /// Retrieves a collection of drive letters that are currently available on the system.
        /// </summary>
        /// <remarks>Drives A and B are not included in the collection, even if they are available.</remarks>
        /// <returns>A collection of drive letters that are currently available on the system.</returns>
        public static ReadOnlyCollection<Char>
        GetAvailableDriveLetters() {

            List<Char> availableDrives = new List<Char>();
            for (int i = (byte)'C'; i <= (byte)'Z'; i++) {
                availableDrives.Add((char)i);
            }

            foreach (string drive in System.Environment.GetLogicalDrives()) {
                availableDrives.Remove(drive.ToUpper(CultureInfo.InvariantCulture)[0]);
            }

            return new ReadOnlyCollection<char>(availableDrives);
        }

        /// <summary>
        /// Gets the first available drive letter on the current system.
        /// </summary>
        /// <remarks>Drives A and B will not be returned, even if they are available.</remarks>
        /// <returns>Char representing the first available drive letter.</returns>
        public static char
        GetFirstAvailableDriveLetter() {
            return GetAvailableDriveLetters()[0];
        }

        #endregion Other

        #endregion Static Methods

        #region AsyncHelpers

        /// <summary>
        /// Creates a NativeOverlapped object, initializes its EventHandle property, and pins the object to the memory.
        /// This overlapped objects are useful when executing VHD meta-ops in async mode.
        /// </summary>
        /// <returns>Returns the GCHandle for the pinned overlapped structure</returns>
        public static GCHandle
        CreatePinnedOverlappedObject() {
            NativeOverlapped overlapped = new NativeOverlapped();
            overlapped.EventHandle = NativeMethods.CreateEvent(IntPtr.Zero, true, false, null);

            GCHandle handleForOverllapped = GCHandle.Alloc(overlapped, GCHandleType.Pinned);

            return handleForOverllapped;
        }

        /// <summary>
        /// GetVirtualDiskOperationProgress API allows getting progress info for the async virtual disk operations (ie. Online Mirror)
        /// </summary>
        /// <param name="progress"></param>
        /// <param name="overlapped"></param>
        /// <returns></returns>
        /// <exception cref="Win32Exception">Thrown when an error occurred while mirroring the VHD.</exception>
        public uint
        GetVirtualDiskOperationProgress(
            ref NativeMethods.VirtualDiskProgress progress,
                IntPtr overlapped) {
            uint returnCode = NativeMethods.GetVirtualDiskOperationProgress(
                    this.m_virtualHardDiskHandle,
                    overlapped,
                ref progress);

            return returnCode;
        }

        #endregion AsyncHelpers

        #region Public Methods

        /// <summary>
        /// Closes all open handles to the Virtual Hard Disk object.
        /// If the VHD is currently attached, and the PermanentLifetime was not specified, this operation will detach it.
        /// </summary>
        public void
        Close() {
            m_virtualHardDiskHandle.Close();
        }

        /// <summary>
        /// Attaches a virtual hard disk (VHD) by locating an appropriate VHD provider to accomplish the attachment.
        /// </summary>
        /// <param name="attachVirtualDiskFlags">
        /// A combination of values from the attachVirtualDiskFlags enumeration which will dictate how the behavior of the VHD once mounted.
        /// </param>
        /// <exception cref="Win32Exception">Thrown when an error occurred while attaching the VHD.</exception>
        /// <exception cref="SecurityException">Thrown when an error occurred while creating the default security descriptor.</exception>
        public void
        Attach(
            NativeMethods.AttachVirtualDiskFlags attachVirtualDiskFlags) {

            if (!this.IsAttached) {

                // Get the current disk index.  We need it later.
                int diskIndex = this.DiskIndex;

                NativeMethods.AttachVirtualDiskParameters attachParameters = new NativeMethods.AttachVirtualDiskParameters();

                // For attach, the correct version is always Version1 for Win7 and Win8.
                attachParameters.Version = NativeMethods.AttachVirtualDiskVersion.Version1;
                attachParameters.Reserved = 0;

                NativeMethods.SecurityDescriptor securityDescriptor;
                if (!NativeMethods.InitializeSecurityDescriptor(out securityDescriptor, 1)) {

                    throw (new SecurityException("Unable to initialize the security descriptor for the virtual disk."));
                }

                uint returnCode = NativeMethods.AttachVirtualDisk(
                         m_virtualHardDiskHandle,
                    ref  securityDescriptor,
                         attachVirtualDiskFlags,
                         0,
                    ref  attachParameters,
                         IntPtr.Zero);

                switch (returnCode) {

                    case NativeMethods.ERROR_SUCCESS:
                        break;

                    default:
                        throw new Win32Exception((int)returnCode);
                }

                // There's apparently a bit of a timing issue here on some systems.
                // If the disk index isn't updated, keep checking once per second for five seconds.
                // If it's not updated after that, it's probably not our fault.
                short attempts = 5;
                while ((attempts-- >= 0) && (diskIndex == this.DiskIndex)) {
                    System.Threading.Thread.Sleep(1000);
                }
            }
        }

        /// <summary>
        /// Attaches a virtual hard disk (VHD) by locating an appropriate VHD provider to accomplish the attachment.
        /// </summary>
        /// <remarks>
        /// This method attaches the VHD with no flags.
        /// </remarks>
        /// <exception cref="Win32Exception">Thrown when an error occurred while attaching the VHD.</exception>
        /// <exception cref="SecurityException">Thrown when an error occurred while creating the default security descriptor.</exception>
        public void
        Attach() {

            this.Attach(NativeMethods.AttachVirtualDiskFlags.None);
        }

        /// <summary>
        /// Unsurfaces (detaches) a virtual hard disk (VHD) by locating an appropriate VHD provider to accomplish the operation.
        /// </summary>
        public void
        Detach() {

            if (this.IsAttached) {
                uint returnCode = NativeMethods.DetachVirtualDisk(
                    m_virtualHardDiskHandle,
                    NativeMethods.DetachVirtualDiskFlag.None,
                    0);

                switch (returnCode) {

                    case NativeMethods.ERROR_NOT_FOUND:
                    // There's nothing to do here.  The device wasn't found, which means there's a 
                    // really good chance that it wasn't attached to begin with.
                    // And, since we were asked to detach it anyway, we can assume that the system
                    // is already in the desired state.
                    case NativeMethods.ERROR_SUCCESS:
                        break;

                    default:
                        throw new Win32Exception((int)returnCode);
                }
            }
        }

        /// <summary>
        /// Reduces the size of the virtual hard disk (VHD) backing store file. Supports both sync and async modes.
        /// </summary>
        /// <param name="overlapped">If not null, the operation runs in async mode</param>
        public uint
        Compact(IntPtr overlapped) {
            return this.Compact(
                overlapped,
                NativeMethods.CompactVirtualDiskFlags.None);
        }

        /// <summary>
        /// Reduces the size of the virtual hard disk (VHD) backing store file. Supports both sync and async modes.
        /// </summary>
        /// <param name="overlapped">If not null, the operation runs in async mode</param>
        /// <param name="flags">Flags for Compact operation</param>
        public uint
        Compact(
            IntPtr overlapped,
            NativeMethods.CompactVirtualDiskFlags flags) {

            NativeMethods.CompactVirtualDiskParameters compactParams = new NativeMethods.CompactVirtualDiskParameters();
            compactParams.Version = NativeMethods.CompactVirtualDiskVersion.Version1;

            uint returnCode = NativeMethods.CompactVirtualDisk(
                m_virtualHardDiskHandle,
                flags,
            ref compactParams,
                overlapped);

            if ((overlapped == IntPtr.Zero && NativeMethods.ERROR_SUCCESS != returnCode) ||
                (overlapped != IntPtr.Zero && NativeMethods.ERROR_IO_PENDING != returnCode)) {
                throw new Win32Exception((int)returnCode);
            }

            return returnCode;
        }


        #endregion Public Methods

        #region Public Properties

        /// <summary>
        /// The SafeFileHandle object for the opened VHD.
        /// </summary>
        public SafeFileHandle
        VirtualHardDiskHandle {
            get {
                return m_virtualHardDiskHandle;
            }
        }

        /// <summary>
        /// Indicates the index of the disk when attached.
        /// If the virtual hard disk is not currently attached, -1 will be returned.
        /// </summary>
        public int
        DiskIndex {
            get {
                string path = PhysicalPath;

                if (null != path) {

                    Match match = Regex.Match(path, @"\d+$"); // look for the last digits in the path
                    return System.Convert.ToInt32(match.Value, CultureInfo.InvariantCulture);
                } else {

                    return -1;
                }
            }
        }

        /// <summary>
        /// Indicates whether the current Virtual Hard Disk is attached to the system.
        /// </summary>
        public bool
        IsAttached {
            get {
                return (this.DiskIndex != -1);
            }
        }

        /// <summary>
        /// Retrieves the path to the physical device object that contains a virtual hard disk (VHD), if the VHD is attached.
        /// If it is not attached, NULL will be returned.
        /// </summary>
        public string
        PhysicalPath {
            get {
                uint pathSize = 1024;  // Isn't MAX_PATH 255?
                StringBuilder path = new StringBuilder((int)pathSize);
                uint returnCode = 0;

                returnCode = NativeMethods.GetVirtualDiskPhysicalPath(
                        m_virtualHardDiskHandle,
                    ref pathSize,
                        path);

                if (NativeMethods.ERROR_ERROR_DEV_NOT_EXIST == returnCode) {

                    return null;
                } else if (NativeMethods.ERROR_SUCCESS == returnCode) {

                    return path.ToString();
                } else {

                    throw new Win32Exception((int)returnCode);
                }
            }
        }

        #endregion Public Properties
    }

    #endregion VHD Interop
}
"@

            #region Helper Functions

            ##########################################################################################
            #                                   Helper Functions
            ##########################################################################################

            <#
                Functions to mount and dismount registry hives.
                These hives will automatically be accessible via the HKLM:\ registry PSDrive.

                It should be noted that I have more confidence in using the RegLoadKey and
                RegUnloadKey Win32 APIs than I do using REG.EXE - it just seems like we should
                do things ourselves if we can, instead of using yet another binary. 

                Consider this a TODO for future versions.
            #>
            Function Mount-RegistryHive {
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
                    [System.IO.FileInfo]
                    [ValidateNotNullOrEmpty()]
                    [ValidateScript({ $_.Exists })]
                    $Hive
                )

                $mountKey = [System.Guid]::NewGuid().ToString()
                $regPath  = "REG.EXE"

                if (Test-Path HKLM:\$mountKey) {
                    throw "The registry path already exists.  I should just regenerate it, but I'm lazy."
                }

                $regArgs = (
                    "LOAD",
                    "HKLM\$mountKey",
                    $Hive.Fullname
                )
                try {

                    Run-Executable -Executable $regPath -Arguments $regArgs

                } catch {
                    throw
                }

                # Set a global variable containing the name of the mounted registry key
                # so we can unmount it if there's an error.
                $global:mountedHive = $mountKey

                return $mountKey
            }

            ##########################################################################################

            Function Dismount-RegistryHive {
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
                    [string]
                    [ValidateNotNullOrEmpty()]
                    $HiveMountPoint
                )

                $regPath = "REG.EXE"

                $regArgs = (
                    "UNLOAD",
                    "HKLM\$($HiveMountPoint)"
                )

                Run-Executable -Executable $regPath -Arguments $regArgs

                $global:mountedHive = $null
            }

            ##########################################################################################

            Function 
            Apply-BCDStoreChanges {
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $true)]
                    [string]
                    [ValidateNotNullOrEmpty()]
                    $BcdStoreFile,

                    [Parameter()]
                    [string]
                    [ValidateNotNullOrEmpty()]
                    [ValidateScript({ ($_ -eq $PARTITION_STYLE_MBR) -or ($_ -eq $PARTITION_STYLE_GPT) })]
                    $PartitionStyle = $PARTITION_STYLE_MBR,

                    [Parameter()]
                    [UInt64]
                    [ValidateScript({ $_ -ge 0 })]
                    $DiskSignature,

                    [Parameter()]
                    [UInt64]
                    [ValidateScript({ $_ -ge 0 })]
                    $PartitionOffset
                )

                #########  Set Constants #########
                $BOOTMGR_ID              = "{9DEA862C-5CDD-4E70-ACC1-F32B344D4795}"
                $DEFAULT_TYPE            = 0x23000003
                $APPLICATION_DEVICE_TYPE = 0x11000001
                $OS_DEVICE_TYPE          = 0x21000001
                ##################################

                Write-W2VInfo "Opening $($BcdStoreFile) for configuration..."
                Write-W2VTrace "Partition Style : $PartitionStyle"
                Write-W2VTrace "Disk Signature  : $DiskSignature"
                Write-W2VTrace "Partition Offset: $PartitionOffset"

                $conn    = New-Object Management.ConnectionOptions
                $scope   = New-Object Management.ManagementScope -ArgumentList "\\.\ROOT\WMI", $conn
                $scope.Connect()

                $path    = New-Object Management.ManagementPath `
                           -ArgumentList "\\.\ROOT\WMI:BCDObject.Id=`"$($BOOTMGR_ID)`",StoreFilePath=`"$($BcdStoreFile.Replace('\', '\\'))`""
                $options = New-Object Management.ObjectGetOptions
                $bootMgr = New-Object Management.ManagementObject -ArgumentList $scope, $path, $options

                try {
                    $bootMgr.Get()
                } catch {
                    throw "Could not get the BootMgr object from the Virtual Disks BCDStore."
                }
    
                Write-W2VTrace "Setting Qualified Partition Device Element for Virtual Disk boot..."
    
   
                $ret = $bootMgr.SetQualifiedPartitionDeviceElement($APPLICATION_DEVICE_TYPE, $PartitionStyle, $DiskSignature, $PartitionOffset)
                if (!$ret.ReturnValue) {
                    throw "Unable to set Qualified Partition Device Element in Virtual Disks BCDStore."
                }

                Write-W2VTrace "Getting the default boot entry..."
                $defaultBootEntryId = ($bootMgr.GetElement($DEFAULT_TYPE)).Element.Id

                Write-W2VTrace "Getting the OS Loader..."

                $path    = New-Object Management.ManagementPath `
                         -ArgumentList "\\.\ROOT\WMI:BCDObject.Id=`"$($defaultBootEntryId)`",StoreFilePath=`"$($BcdStoreFile.Replace('\', '\\'))`""

                $osLoader= New-Object Management.ManagementObject -ArgumentList $scope, $path, $options

                try {
                    $osLoader.Get()
                } catch {
                    throw "Could not get the OS Loader..."
                }

                Write-W2VTrace "Setting Qualified Partition Device Element in the OS Loader Application..."
                $ret = $osLoader.SetQualifiedPartitionDeviceElement($APPLICATION_DEVICE_TYPE, $PartitionStyle, $DiskSignature, $PartitionOffset)
                if (!$ret.ReturnValue) {
                    throw "Could not set Qualified Partition Device Element in the OS Loader Application."
                }

                Write-W2VTrace "Setting Qualified Partition Device Element in the OS Loader Device..."
                $ret = $osLoader.SetQualifiedPartitionDeviceElement($OS_DEVICE_TYPE, $PartitionStyle, $DiskSignature, $PartitionOffset)
                if (!$ret.ReturnValue) {
                    throw "Could not set Qualified Partition Device Element in the OS Loader Device."
                }

                Write-W2VInfo "BCD configuration complete. Moving on..."
            }

            ##########################################################################################

            function 
            Test-Admin {
                <#
                    .SYNOPSIS
                        Short function to determine whether the logged-on user is an administrator.

                    .EXAMPLE
                        Do you honestly need one?  There are no parameters!

                    .OUTPUTS
                        $true if user is admin.
                        $false if user is not an admin.
                #>
                [CmdletBinding()]
                param()

                $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
                $isAdmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
                Write-W2VTrace "isUserAdmin? $isAdmin"

                return $isAdmin
            }

            ##########################################################################################

            function
            Test-WindowsVersion {
              
              # This breaks on Windows 10

              # $os = Get-WmiObject -Class Win32_OperatingSystem
              # $isWin8 = (($os.Version -ge 6.2) -and ($os.BuildNumber -ge $lowestSupportedBuild))

              # New version check which works on Windows 10 an down-level
                
                $os = [System.Environment]::OSVersion.Version
                
                $isWin8 = (
                    (
                        $os -ge 6.2
                    ) -and
                    (
                        $os.Build -ge $lowestSupportedBuild
                    )
                )

                Write-W2VTrace "is Windows 8 or Higher? $isWin8"
                return $isWin8
            }

            ##########################################################################################

            function
            Write-W2VInfo {
            # Function to make the Write-Host output a bit prettier. 
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $False, ValueFromPipeline = $true)]
                    [string]
                    [ValidateNotNullOrEmpty()]
                    $text
                )
        
                If ( $text )
                {
                    Write-Host "INFO   : $($text)" -ForegroundColor White
                }
                Else
                {
                    Write-Host
                }
            }

            ##########################################################################################

            function
            Write-W2VTrace {
            # Function to make the Write-Verbose output... well... exactly the same as it was before.
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
                    [string]
                    [ValidateNotNullOrEmpty()]
                    $text
                )
                Write-Verbose $text
            }

            ##########################################################################################

            function
            Write-W2VError {
            # Function to make the Write-Host (NOT Write-Error) output prettier in the case of an error.
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
                    [string]
                    [ValidateNotNullOrEmpty()]
                    $text
                )
                Write-Host "ERROR  : $($text)" -ForegroundColor Red
            }

            ##########################################################################################

            function
            Write-W2VWarn {
            # Function to make the Write-Host (NOT Write-Warning) output prettier.
                [CmdletBinding()]
                param(
                    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
                    [string]
                    [ValidateNotNullOrEmpty()]
                    $text
                )
                Write-Host "WARN   : $($text)" -ForegroundColor Yellow
            }

            ##########################################################################################

            function
            Run-Executable {
                <#
                    .SYNOPSIS
                        Runs an external executable file, and validates the error level.

                    .PARAMETER Executable
                        The path to the executable to run and monitor.

                    .PARAMETER Arguments
                        An array of arguments to pass to the executable when it's executed.

                    .PARAMETER SuccessfulErrorCode
                        The error code that means the executable ran successfully.
                        The default value is 0.  
                #>

                [CmdletBinding()]
                param(
                    [Parameter(Mandatory=$true)]
                    [string]
                    [ValidateNotNullOrEmpty()]
                    $Executable,

                    [Parameter(Mandatory=$true)]
                    [string[]]
                    [ValidateNotNullOrEmpty()]
                    $Arguments,

                    [Parameter()]
                    [int]
                    [ValidateNotNullOrEmpty()]
                    $SuccessfulErrorCode = 0

                )

                Write-W2VTrace "Running $Executable $Arguments"
                $ret = Start-Process           `
                    -FilePath $Executable      `
                    -ArgumentList $Arguments   `
                    -NoNewWindow               `
                    -Wait                      `
                    -RedirectStandardOutput "$($env:temp)\$($scriptName)\$($sessionKey)\$($Executable)-StandardOutput.txt" `
                    -RedirectStandardError  "$($env:temp)\$($scriptName)\$($sessionKey)\$($Executable)-StandardError.txt"  `
                    -Passthru

                Write-W2VTrace "Return code was $($ret.ExitCode)."

                if ($ret.ExitCode -ne $SuccessfulErrorCode) {
                    throw "$Executable failed with code $($ret.ExitCode)!"
                }
            }

            ##########################################################################################
            Function Test-IsNetworkLocation {
                <#
                    .SYNOPSIS
                        Determines whether or not a given path is a network location or a local drive.
            
                    .DESCRIPTION
                        Function to determine whether or not a specified path is a local path, a UNC path,
                        or a mapped network drive.

                    .PARAMETER Path
                        The path that we need to figure stuff out about,
                #>
    
                [CmdletBinding()]
                param(
                    [Parameter(ValueFromPipeLine = $true)]
                    [string]
                    [ValidateNotNullOrEmpty()]
                    $Path
                )

                $result = $false
    
                if ([bool]([URI]$Path).IsUNC) {
                    $result = $true
                } else {
                    $driveInfo = [IO.DriveInfo]((Resolve-Path $Path).Path)

                    if ($driveInfo.DriveType -eq "Network") {
                        $result = $true
                    }
                }

                return $result
            }
            ##########################################################################################

            #endregion Helper Functions
        }

        Process {

            $openWim      = $null
            $openVhd      = $null
            $openIso      = $null
            $openImage    = $null
            $vhdFinalName = $null
            $vhdFinalPath = $null
            $mountedHive  = $null
            $isoPath      = $null
            $vhd          = @()

            Write-Host $header
            try {

                # Create log folder
                if (Test-Path $logFolder) {
                    $null = rd $logFolder -Force -Recurse
                }

                $null = md $logFolder -Force

                # Try to start transcripting.  If it's already running, we'll get an exception and swallow it.
                try {
                    $null = Start-Transcript -Path (Join-Path $logFolder "Convert-WindowsImageTranscript.txt") -Force -ErrorAction SilentlyContinue
                    $transcripting = $true
                } catch {
                    Write-W2VWarn "Transcription is already running.  No Convert-WindowsImage-specific transcript will be created."
                    $transcripting = $false
                }

                Add-Type -TypeDefinition $code -ReferencedAssemblies "System.Xml","System.Linq","System.Xml.Linq"

                # Check to make sure we're running as Admin.
                if (!(Test-Admin)) {
                    throw "Images can only be applied by an administrator.  Please launch PowerShell elevated and run this script again."
                }

                # Check to make sure we're running on Win8.
                if (!(Test-WindowsVersion)) {
                    throw "$scriptName requires Windows 8 Consumer Preview or higher.  Please use WIM2VHD.WSF (http://code.msdn.microsoft.com/wim2vhd) if you need to create VHDs from Windows 7."
                }
    
                # Resolve the path for the unattend file.
                if (![string]::IsNullOrEmpty($UnattendPath)) {
                    $UnattendPath = (Resolve-Path $UnattendPath).Path
                }

                if ($ShowUI) { 
        
                    Write-W2VInfo "Launching UI..."
                    Add-Type -AssemblyName System.Drawing,System.Windows.Forms

                    #region Form Objects
                    $frmMain                = New-Object System.Windows.Forms.Form
                    $groupBox4              = New-Object System.Windows.Forms.GroupBox
                    $btnGo                  = New-Object System.Windows.Forms.Button
                    $groupBox3              = New-Object System.Windows.Forms.GroupBox
                    $txtVhdName             = New-Object System.Windows.Forms.TextBox
                    $label6                 = New-Object System.Windows.Forms.Label
                    $btnWrkBrowse           = New-Object System.Windows.Forms.Button
                    $cmbVhdSizeUnit         = New-Object System.Windows.Forms.ComboBox
                    $numVhdSize             = New-Object System.Windows.Forms.NumericUpDown
                    $cmbVhdFormat           = New-Object System.Windows.Forms.ComboBox
                    $label5                 = New-Object System.Windows.Forms.Label
                    $txtWorkingDirectory    = New-Object System.Windows.Forms.TextBox
                    $cmbVhdType             = New-Object System.Windows.Forms.ComboBox
                    $label4                 = New-Object System.Windows.Forms.Label
                    $label3                 = New-Object System.Windows.Forms.Label
                    $label2                 = New-Object System.Windows.Forms.Label
                    $label7                 = New-Object System.Windows.Forms.Label
                    $txtUnattendFile        = New-Object System.Windows.Forms.TextBox
                    $btnUnattendBrowse      = New-Object System.Windows.Forms.Button
                    $groupBox2              = New-Object System.Windows.Forms.GroupBox
                    $cmbSkuList             = New-Object System.Windows.Forms.ComboBox
                    $label1                 = New-Object System.Windows.Forms.Label
                    $groupBox1              = New-Object System.Windows.Forms.GroupBox
                    $txtSourcePath          = New-Object System.Windows.Forms.TextBox
                    $btnBrowseWim           = New-Object System.Windows.Forms.Button
                    $openFileDialog1        = New-Object System.Windows.Forms.OpenFileDialog
                    $openFolderDialog1      = New-Object System.Windows.Forms.FolderBrowserDialog
                    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

                    #endregion Form Objects

                    #region Event scriptblocks.

                    $btnGo_OnClick                          = {
                        $frmMain.Close()
                    }

                    $btnWrkBrowse_OnClick                   = {
                        $openFolderDialog1.RootFolder       = "Desktop"
                        $openFolderDialog1.Description      = "Select the folder you'd like your VHD(X) to be created in."
                        $openFolderDialog1.SelectedPath     = $WorkingDirectory
        
                        $ret = $openFolderDialog1.ShowDialog()

                        if ($ret -ilike "ok") {
                            $WorkingDirectory = $txtWorkingDirectory = $openFolderDialog1.SelectedPath
                            Write-W2VInfo "Selected Working Directory is $WorkingDirectory..."
                        }
                    }

                    $btnUnattendBrowse_OnClick              = {
                        $openFileDialog1.InitialDirectory   = $pwd
                        $openFileDialog1.Filter             = "XML files (*.xml)|*.XML|All files (*.*)|*.*"
                        $openFileDialog1.FilterIndex        = 1
                        $openFileDialog1.CheckFileExists    = $true
                        $openFileDialog1.CheckPathExists    = $true
                        $openFileDialog1.FileName           = $null
                        $openFileDialog1.ShowHelp           = $false
                        $openFileDialog1.Title              = "Select an unattend file..."
        
                        $ret = $openFileDialog1.ShowDialog()

                        if ($ret -ilike "ok") {
                            $UnattendPath = $txtUnattendFile.Text = $openFileDialog1.FileName
                        }
                    }

                    $btnBrowseWim_OnClick                   = {
                        $openFileDialog1.InitialDirectory   = $pwd
                        $openFileDialog1.Filter             = "All compatible files (*.ISO, *.WIM)|*.ISO;*.WIM|All files (*.*)|*.*"
                        $openFileDialog1.FilterIndex        = 1
                        $openFileDialog1.CheckFileExists    = $true
                        $openFileDialog1.CheckPathExists    = $true
                        $openFileDialog1.FileName           = $null
                        $openFileDialog1.ShowHelp           = $false
                        $openFileDialog1.Title              = "Select a source file..."
        
                        $ret = $openFileDialog1.ShowDialog()

                        if ($ret -ilike "ok") {

                            if (([IO.FileInfo]$openFileDialog1.FileName).Extension -ilike ".iso") {
                    
                                if (Test-IsNetworkLocation $openFileDialog1.FileName) {
                                    Write-W2VInfo "Copying ISO $(Split-Path $openFileDialog1.FileName -Leaf) to temp folder..."
                                    Write-W2VWarn "The UI may become non-responsive while this copy takes place..."                        
                                    Copy-Item -Path $openFileDialog1.FileName -Destination $env:Temp -Force
                                    $openFileDialog1.FileName = "$($env:Temp)\$(Split-Path $openFileDialog1.FileName -Leaf)"
                                }
                    
                                $txtSourcePath.Text = $isoPath = (Resolve-Path $openFileDialog1.FileName).Path
                                Write-W2VInfo "Opening ISO $(Split-Path $isoPath -Leaf)..."
                    
                                $openIso     = Mount-DiskImage -ImagePath $isoPath -StorageType ISO -PassThru
                        
                                # Refresh the DiskImage object so we can get the real information about it.  I assume this is a bug.
                                $openIso     = Get-DiskImage -ImagePath $isoPath
                                $driveLetter = ($openIso | Get-Volume).DriveLetter

                                $script:SourcePath  = "$($driveLetter):\sources\install.wim"

                                # Check to see if there's a WIM file we can muck about with.
                                Write-W2VInfo "Looking for $($SourcePath)..."
                                if (!(Test-Path $SourcePath)) {
                                    throw "The specified ISO does not appear to be valid Windows installation media."
                                }
                            } else {
                                $txtSourcePath.Text = $script:SourcePath = $openFileDialog1.FileName
                            }

                            # Check to see if the WIM is local, or on a network location.  If the latter, copy it locally.
                            if (Test-IsNetworkLocation $SourcePath) {
                                Write-W2VInfo "Copying WIM $(Split-Path $SourcePath -Leaf) to temp folder..."
                                Write-W2VWarn "The UI may become non-responsive while this copy takes place..."
                                Copy-Item -Path $SourcePath -Destination $env:Temp -Force
                                $txtSourcePath.Text = $script:SourcePath = "$($env:Temp)\$(Split-Path $SourcePath -Leaf)"
                            }

                            $script:SourcePath = (Resolve-Path $SourcePath).Path

                            Write-W2VInfo "Scanning WIM metadata..."
        
                            $tempOpenWim = $null

                            try {

                                $tempOpenWim   = New-Object WIM2VHD.WimFile $SourcePath

                                # Let's see if we're running against an unstaged build.  If we are, we need to blow up.
                                if ($tempOpenWim.ImageNames.Contains("Windows Longhorn Client") -or
                                    $tempOpenWim.ImageNames.Contains("Windows Longhorn Server") -or
                                    $tempOpenWim.ImageNames.Contains("Windows Longhorn Server Core")) {
                                    [Windows.Forms.MessageBox]::Show(
                                        "Convert-WindowsImage cannot run against unstaged builds. Please try again with a staged build.",
                                        "WIM is incompatible!",
                                        "OK",
                                        "Error"
                                    )

                                    return
                                } else {

                                    $tempOpenWim.Images | %{ $cmbSkuList.Items.Add($_.ImageFlags) }
                                    $cmbSkuList.SelectedIndex = 0
                                }

                            } catch {

                                throw "Unable to load WIM metadata!"
                            } finally {

                                $tempOpenWim.Close()
                                Write-W2VTrace "Closing WIM metadata..."
                            }
                        }
                    }

                    $OnLoadForm_StateCorrection = {

                        # Correct the initial state of the form to prevent the .Net maximized form issue
                        $frmMain.WindowState      = $InitialFormWindowState
                    }

                    #endregion Event scriptblocks

                    # Figure out VHD size and size unit.
                    $unit = $null
                    switch ([Math]::Round($SizeBytes.ToString().Length / 3)) {
                        3 { $unit = "MB"; break }
                        4 { $unit = "GB"; break }
                        5 { $unit = "TB"; break }
                        default { $unit = ""; break }
                    }

                    $quantity = Invoke-Expression -Command "$($SizeBytes) / 1$($unit)"

                    #region Form Code
                    #region frmMain
                    $frmMain.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 579
                    $System_Drawing_Size.Width    = 512
                    $frmMain.ClientSize           = $System_Drawing_Size
                    $frmMain.Font                 = New-Object System.Drawing.Font("Segoe UI",10,0,3,1)
                    $frmMain.FormBorderStyle      = 1
                    $frmMain.MaximizeBox          = $False
                    $frmMain.MinimizeBox          = $False
                    $frmMain.Name                 = "frmMain"
                    $frmMain.StartPosition        = 1
                    $frmMain.Text                 = "Convert-WindowsImage UI"
                    #endregion frmMain

                    #region groupBox4
                    $groupBox4.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 10
                    $System_Drawing_Point.Y       = 498
                    $groupBox4.Location           = $System_Drawing_Point
                    $groupBox4.Name               = "groupBox4"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 69
                    $System_Drawing_Size.Width    = 489
                    $groupBox4.Size               = $System_Drawing_Size
                    $groupBox4.TabIndex           = 8
                    $groupBox4.TabStop            = $False
                    $groupBox4.Text               = "4. Make the VHD!"

                    $frmMain.Controls.Add($groupBox4)
                    #endregion groupBox4

                    #region btnGo
                    $btnGo.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 39
                    $System_Drawing_Point.Y       = 24
                    $btnGo.Location               = $System_Drawing_Point
                    $btnGo.Name                   = "btnGo"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 33
                    $System_Drawing_Size.Width    = 415
                    $btnGo.Size                   = $System_Drawing_Size
                    $btnGo.TabIndex               = 0
                    $btnGo.Text                   = "&Make my VHD"
                    $btnGo.UseVisualStyleBackColor = $True
                    $btnGo.DialogResult           = "OK"
                    $btnGo.add_Click($btnGo_OnClick)

                    $groupBox4.Controls.Add($btnGo)
                    $frmMain.AcceptButton = $btnGo
                    #endregion btnGo

                    #region groupBox3
                    $groupBox3.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 10
                    $System_Drawing_Point.Y       = 243
                    $groupBox3.Location           = $System_Drawing_Point
                    $groupBox3.Name               = "groupBox3"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 245
                    $System_Drawing_Size.Width    = 489
                    $groupBox3.Size               = $System_Drawing_Size
                    $groupBox3.TabIndex           = 7
                    $groupBox3.TabStop            = $False
                    $groupBox3.Text               = "3. Choose configuration options"

                    $frmMain.Controls.Add($groupBox3)
                    #endregion groupBox3

                    #region txtVhdName
                    $txtVhdName.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 25
                    $System_Drawing_Point.Y       = 150
                    $txtVhdName.Location          = $System_Drawing_Point
                    $txtVhdName.Name              = "txtVhdName"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 418
                    $txtVhdName.Size              = $System_Drawing_Size
                    $txtVhdName.TabIndex          = 10

                    $groupBox3.Controls.Add($txtVhdName)
                    #endregion txtVhdName

                    #region txtUnattendFile
                    $txtUnattendFile.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 25
                    $System_Drawing_Point.Y       = 198
                    $txtUnattendFile.Location     = $System_Drawing_Point
                    $txtUnattendFile.Name         = "txtUnattendFile"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 418
                    $txtUnattendFile.Size         = $System_Drawing_Size
                    $txtUnattendFile.TabIndex     = 11

                    $groupBox3.Controls.Add($txtUnattendFile)
                    #endregion txtUnattendFile

                    #region label7
                    $label7.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 23
                    $System_Drawing_Point.Y       = 180
                    $label7.Location              = $System_Drawing_Point
                    $label7.Name                  = "label7"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 23
                    $System_Drawing_Size.Width    = 175
                    $label7.Size                  = $System_Drawing_Size
                    $label7.Text                  = "Unattend File (Optional)"

                    $groupBox3.Controls.Add($label7)
                    #endregion label7

                    #region label6
                    $label6.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 23
                    $System_Drawing_Point.Y       = 132
                    $label6.Location              = $System_Drawing_Point
                    $label6.Name                  = "label6"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 23
                    $System_Drawing_Size.Width    = 175
                    $label6.Size                  = $System_Drawing_Size
                    $label6.Text                  = "VHD Name (Optional)"

                    $groupBox3.Controls.Add($label6)
                    #endregion label6

                    #region btnUnattendBrowse
                    $btnUnattendBrowse.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 449
                    $System_Drawing_Point.Y       = 199
                    $btnUnattendBrowse.Location   = $System_Drawing_Point
                    $btnUnattendBrowse.Name       = "btnUnattendBrowse"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 27
                    $btnUnattendBrowse.Size       = $System_Drawing_Size
                    $btnUnattendBrowse.TabIndex   = 9
                    $btnUnattendBrowse.Text       = "..."
                    $btnUnattendBrowse.UseVisualStyleBackColor = $True
                    $btnUnattendBrowse.add_Click($btnUnattendBrowse_OnClick)
    
                    $groupBox3.Controls.Add($btnUnattendBrowse)
                    #endregion btnUnattendBrowse

                    #region btnWrkBrowse
                    $btnWrkBrowse.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 449
                    $System_Drawing_Point.Y       = 98
                    $btnWrkBrowse.Location        = $System_Drawing_Point
                    $btnWrkBrowse.Name            = "btnWrkBrowse"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 27
                    $btnWrkBrowse.Size            = $System_Drawing_Size
                    $btnWrkBrowse.TabIndex        = 9
                    $btnWrkBrowse.Text            = "..."
                    $btnWrkBrowse.UseVisualStyleBackColor = $True
                    $btnWrkBrowse.add_Click($btnWrkBrowse_OnClick)
    
                    $groupBox3.Controls.Add($btnWrkBrowse)
                    #endregion btnWrkBrowse

                    #region cmbVhdSizeUnit
                    $cmbVhdSizeUnit.DataBindings.DefaultDataSourceUpdateMode = 0
                    $cmbVhdSizeUnit.FormattingEnabled = $True
                    $cmbVhdSizeUnit.Items.Add("MB") | Out-Null
                    $cmbVhdSizeUnit.Items.Add("GB") | Out-Null
                    $cmbVhdSizeUnit.Items.Add("TB") | Out-Null
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 409
                    $System_Drawing_Point.Y       = 42
                    $cmbVhdSizeUnit.Location      = $System_Drawing_Point
                    $cmbVhdSizeUnit.Name          = "cmbVhdSizeUnit"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 67
                    $cmbVhdSizeUnit.Size          = $System_Drawing_Size
                    $cmbVhdSizeUnit.TabIndex      = 5
                    $cmbVhdSizeUnit.Text          = $unit

                    $groupBox3.Controls.Add($cmbVhdSizeUnit)
                    #endregion cmbVhdSizeUnit

                    #region numVhdSize
                    $numVhdSize.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 340
                    $System_Drawing_Point.Y       = 42
                    $numVhdSize.Location          = $System_Drawing_Point
                    $numVhdSize.Name              = "numVhdSize"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 63
                    $numVhdSize.Size              = $System_Drawing_Size
                    $numVhdSize.TabIndex          = 4
                    $numVhdSize.Value             = $quantity

                    $groupBox3.Controls.Add($numVhdSize)
                    #endregion numVhdSize

                    #region cmbVhdFormat
                    $cmbVhdFormat.DataBindings.DefaultDataSourceUpdateMode = 0
                    $cmbVhdFormat.FormattingEnabled = $True
                    $cmbVhdFormat.Items.Add("VHD")  | Out-Null
                    $cmbVhdFormat.Items.Add("VHDX") | Out-Null
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 25
                    $System_Drawing_Point.Y       = 42
                    $cmbVhdFormat.Location        = $System_Drawing_Point
                    $cmbVhdFormat.Name            = "cmbVhdFormat"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 136
                    $cmbVhdFormat.Size            = $System_Drawing_Size
                    $cmbVhdFormat.TabIndex        = 0
                    $cmbVhdFormat.Text            = $VHDFormat

                    $groupBox3.Controls.Add($cmbVhdFormat)
                    #endregion cmbVhdFormat

                    #region label5
                    $label5.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 23
                    $System_Drawing_Point.Y       = 76
                    $label5.Location              = $System_Drawing_Point
                    $label5.Name                  = "label5"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 23
                    $System_Drawing_Size.Width    = 264
                    $label5.Size                  = $System_Drawing_Size
                    $label5.TabIndex              = 8
                    $label5.Text                  = "Working Directory"

                    $groupBox3.Controls.Add($label5)
                    #endregion label5

                    #region txtWorkingDirectory
                    $txtWorkingDirectory.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 25
                    $System_Drawing_Point.Y       = 99
                    $txtWorkingDirectory.Location = $System_Drawing_Point
                    $txtWorkingDirectory.Name     = "txtWorkingDirectory"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 418
                    $txtWorkingDirectory.Size     = $System_Drawing_Size
                    $txtWorkingDirectory.TabIndex = 7
                    $txtWorkingDirectory.Text     = $WorkingDirectory

                    $groupBox3.Controls.Add($txtWorkingDirectory)
                    #endregion txtWorkingDirectory

                    #region cmbVhdType
                    $cmbVhdType.DataBindings.DefaultDataSourceUpdateMode = 0
                    $cmbVhdType.FormattingEnabled = $True
                    $cmbVhdType.Items.Add("Dynamic") | Out-Null
                    $cmbVhdType.Items.Add("Fixed")   | Out-Null
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 176
                    $System_Drawing_Point.Y       = 42
                    $cmbVhdType.Location          = $System_Drawing_Point
                    $cmbVhdType.Name              = "cmbVhdType"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 144
                    $cmbVhdType.Size              = $System_Drawing_Size
                    $cmbVhdType.TabIndex          = 2
                    $cmbVhdType.Text              = $VHDType

                    $groupBox3.Controls.Add($cmbVhdType)
                    #endregion cmbVhdType

                    #region label4
                    $label4.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 340
                    $System_Drawing_Point.Y       = 21
                    $label4.Location              = $System_Drawing_Point
                    $label4.Name                  = "label4"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 27
                    $System_Drawing_Size.Width    = 86
                    $label4.Size                  = $System_Drawing_Size
                    $label4.TabIndex              = 6
                    $label4.Text                  = "VHD Size"

                    $groupBox3.Controls.Add($label4)
                    #endregion label4

                    #region label3
                    $label3.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 176
                    $System_Drawing_Point.Y       = 21
                    $label3.Location              = $System_Drawing_Point
                    $label3.Name                  = "label3"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 27
                    $System_Drawing_Size.Width    = 92
                    $label3.Size                  = $System_Drawing_Size
                    $label3.TabIndex              = 3
                    $label3.Text                  = "VHD Type"

                    $groupBox3.Controls.Add($label3)
                    #endregion label3

                    #region label2
                    $label2.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 25
                    $System_Drawing_Point.Y       = 21
                    $label2.Location              = $System_Drawing_Point
                    $label2.Name                  = "label2"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 30
                    $System_Drawing_Size.Width    = 118
                    $label2.Size                  = $System_Drawing_Size
                    $label2.TabIndex              = 1
                    $label2.Text                  = "VHD Format"

                    $groupBox3.Controls.Add($label2)
                    #endregion label2

                    #region groupBox2
                    $groupBox2.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 10
                    $System_Drawing_Point.Y       = 169
                    $groupBox2.Location           = $System_Drawing_Point
                    $groupBox2.Name               = "groupBox2"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 68
                    $System_Drawing_Size.Width    = 490
                    $groupBox2.Size               = $System_Drawing_Size
                    $groupBox2.TabIndex           = 6
                    $groupBox2.TabStop            = $False
                    $groupBox2.Text               = "2. Choose a SKU from the list"

                    $frmMain.Controls.Add($groupBox2)
                    #endregion groupBox2

                    #region cmbSkuList
                    $cmbSkuList.DataBindings.DefaultDataSourceUpdateMode = 0
                    $cmbSkuList.FormattingEnabled = $True
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 25
                    $System_Drawing_Point.Y       = 24
                    $cmbSkuList.Location          = $System_Drawing_Point
                    $cmbSkuList.Name              = "cmbSkuList"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 452
                    $cmbSkuList.Size              = $System_Drawing_Size
                    $cmbSkuList.TabIndex          = 2

                    $groupBox2.Controls.Add($cmbSkuList)
                    #endregion cmbSkuList

                    #region label1
                    $label1.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 23
                    $System_Drawing_Point.Y       = 21
                    $label1.Location              = $System_Drawing_Point
                    $label1.Name                  = "label1"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 71
                    $System_Drawing_Size.Width    = 464
                    $label1.Size                  = $System_Drawing_Size
                    $label1.TabIndex              = 5
                    $label1.Text                  = $uiHeader

                    $frmMain.Controls.Add($label1)
                    #endregion label1

                    #region groupBox1
                    $groupBox1.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 10
                    $System_Drawing_Point.Y       = 95
                    $groupBox1.Location           = $System_Drawing_Point
                    $groupBox1.Name               = "groupBox1"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 68
                    $System_Drawing_Size.Width    = 490
                    $groupBox1.Size               = $System_Drawing_Size
                    $groupBox1.TabIndex           = 4
                    $groupBox1.TabStop            = $False
                    $groupBox1.Text               = "1. Choose a source"

                    $frmMain.Controls.Add($groupBox1)
                    #endregion groupBox1

                    #region txtSourcePath
                    $txtSourcePath.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 25
                    $System_Drawing_Point.Y       = 24
                    $txtSourcePath.Location       = $System_Drawing_Point
                    $txtSourcePath.Name           = "txtSourcePath"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 418
                    $txtSourcePath.Size           = $System_Drawing_Size
                    $txtSourcePath.TabIndex       = 0

                    $groupBox1.Controls.Add($txtSourcePath)
                    #endregion txtSourcePath

                    #region btnBrowseWim
                    $btnBrowseWim.DataBindings.DefaultDataSourceUpdateMode = 0
                    $System_Drawing_Point         = New-Object System.Drawing.Point
                    $System_Drawing_Point.X       = 449
                    $System_Drawing_Point.Y       = 24
                    $btnBrowseWim.Location        = $System_Drawing_Point
                    $btnBrowseWim.Name            = "btnBrowseWim"
                    $System_Drawing_Size          = New-Object System.Drawing.Size
                    $System_Drawing_Size.Height   = 25
                    $System_Drawing_Size.Width    = 28
                    $btnBrowseWim.Size            = $System_Drawing_Size
                    $btnBrowseWim.TabIndex        = 1
                    $btnBrowseWim.Text            = "..."
                    $btnBrowseWim.UseVisualStyleBackColor = $True
                    $btnBrowseWim.add_Click($btnBrowseWim_OnClick)

                    $groupBox1.Controls.Add($btnBrowseWim)
                    #endregion btnBrowseWim

                    $openFileDialog1.FileName     = "openFileDialog1"
                    $openFileDialog1.ShowHelp     = $True

                    #endregion Form Code

                    # Save the initial state of the form
                    $InitialFormWindowState       = $frmMain.WindowState
    
                    # Init the OnLoad event to correct the initial state of the form
                    $frmMain.add_Load($OnLoadForm_StateCorrection)

                    # Return the constructed form.
                    $ret = $frmMain.ShowDialog()

                    if (!($ret -ilike "OK")) {
                        throw "Form session has been cancelled."
                    }

                    if ([string]::IsNullOrEmpty($SourcePath)) {
                        throw "No source path specified."
                    }

                    # VHD Format
                    $VHDFormat        = $cmbVhdFormat.SelectedItem

                    # VHD Size
                    $SizeBytes        = Invoke-Expression "$($numVhdSize.Value)$($cmbVhdSizeUnit.SelectedItem)"

                    # VHD Type
                    $VHDType          = $cmbVhdType.SelectedItem

                    # Working Directory
                    $WorkingDirectory = $txtWorkingDirectory.Text

                    # VHDPath
                    if (![string]::IsNullOrEmpty($txtVhdName.Text)) {
                        $VHDPath      = "$($WorkingDirectory)\$($txtVhdName.Text)"
                    }

                    # Edition
                    if (![string]::IsNullOrEmpty($cmbSkuList.SelectedItem)) {
                        $Edition      = $cmbSkuList.SelectedItem
                    }

                    # Because we used ShowDialog, we need to manually dispose of the form.
                    # This probably won't make much of a difference, but let's free up all of the resources we can
                    # before we start the conversion process.

                    $frmMain.Dispose()
                }

                # There's a difference between the maximum sizes for VHDs and VHDXs.  Make sure we follow it.
                if ("VHD" -ilike $VHDFormat) {
                    if ($SizeBytes -gt $vhdMaxSize) {
                        Write-W2VWarn "For the VHD file format, the maximum file size is ~2040GB.  We're automatically setting the size to 2040GB for you."
                        $SizeBytes = 2040GB
                    }
                }

                # Check if -VHDPath and -WorkingDirectory were both specified.
                if ((![String]::IsNullOrEmpty($VHDPath)) -and (![String]::IsNullOrEmpty($WorkingDirectory))) {
                    if ($WorkingDirectory -ne $pwd) {
                        # If the WorkingDirectory is anything besides $pwd, tell people that the WorkingDirectory is being ignored.
                        Write-W2VWarn "Specifying -VHDPath and -WorkingDirectory at the same time is contradictory."
                        Write-W2VWarn "Ignoring the WorkingDirectory specification."
                        $WorkingDirectory = Split-Path $VHDPath -Parent
                    }
                }

                if ($VHDPath) {
                    # Check to see if there's a conflict between the specified file extension and the VHDFormat being used.
                    $ext = ([IO.FileInfo]$VHDPath).Extension

                    if (!($ext -ilike ".$($VHDFormat)")) {
                        throw "There is a mismatch between the VHDPath file extension ($($ext.ToUpper())), and the VHDFormat (.$($VHDFormat)).  Please ensure that these match and try again."
                    }
                }

                # Create a temporary name for the VHD(x).  We'll name it properly at the end of the script.
                if ([String]::IsNullOrEmpty($VHDPath)) {
                    $VHDPath      = Join-Path $WorkingDirectory "$($sessionKey).$($VHDFormat.ToLower())"
                } else {
                    # Since we can't do Resolve-Path against a file that doesn't exist, we need to get creative in determining 
                    # the full path that the user specified (or meant to specify if they gave us a relative path).
                    # Check to see if the path has a root specified.  If it doesn't, use the working directory.
                    if (![IO.Path]::IsPathRooted($VHDPath)){
                        $VHDPath  = Join-Path $WorkingDirectory $VHDPath
                    }

                    $vhdFinalName = Split-Path $VHDPath -Leaf
                    $VHDPath      = Join-Path (Split-Path $VHDPath -Parent) "$($sessionKey).$($VHDFormat.ToLower())"
                }

                Write-W2VTrace "Temporary $VHDFormat path is : $VHDPath"
 
                # If we're using an ISO, mount it and get the path to the WIM file.
                if (([IO.FileInfo]$SourcePath).Extension -ilike ".ISO") { 

                    # If the ISO isn't local, copy it down so we don't have to worry about resource contention
                    # or about network latency.
                    if (Test-IsNetworkLocation $SourcePath) {
                        Write-W2VInfo "Copying ISO $(Split-Path $SourcePath -Leaf) to temp folder..."
                        Copy-Item -Path $SourcePath -Destination $env:Temp -Force
                        $SourcePath = "$($env:Temp)\$(Split-Path $SourcePath -Leaf)"
                    }

                    $isoPath = (Resolve-Path $SourcePath).Path

                    Write-W2VInfo "Opening ISO $(Split-Path $isoPath -Leaf)..."
                    $openIso     = Mount-DiskImage -ImagePath $isoPath -StorageType ISO -PassThru
                    # Refresh the DiskImage object so we can get the real information about it.  I assume this is a bug.
                    $openIso     = Get-DiskImage -ImagePath $isoPath
                    $driveLetter = ($openIso | Get-Volume).DriveLetter

                    $SourcePath  = "$($driveLetter):\sources\install.wim"

                    # Check to see if there's a WIM file we can muck about with.
                    Write-W2VInfo "Looking for $($SourcePath)..."
                    if (!(Test-Path $SourcePath)) {
                        throw "The specified ISO does not appear to be valid Windows installation media."
                    }
                }

                # Check to see if the WIM is local, or on a network location.  If the latter, copy it locally.
                if (Test-IsNetworkLocation $SourcePath) {
                    $SourceIsNetwork = $true
                    Write-W2VInfo "Copying WIM $(Split-Path $SourcePath -Leaf) to temp folder..."
                    Copy-Item -Path $SourcePath -Destination $env:Temp -Force
                    $SourcePath = "$($env:Temp)\$(Split-Path $SourcePath -Leaf)"
                }

                $SourcePath  = (Resolve-Path $SourcePath).Path
    
                # We're good.  Open the WIM container.
                $openWim     = New-Object WIM2VHD.WimFile $SourcePath

                # Let's see if we're running against an unstaged build.  If we are, we need to blow up.
                if ($openWim.ImageNames.Contains("Windows Longhorn Client") -or
                    $openWim.ImageNames.Contains("Windows Longhorn Server") -or
                    $openWim.ImageNames.Contains("Windows Longhorn Server Core")) {
                    throw "Convert-WindowsImage cannot run against unstaged builds. Please try again with a staged build."
                }

                # If there's only one image in the WIM, just selected that.
                if ($openWim.Images.Count -eq 1) { 
                    $Edition   = $openWim.Images[0].ImageFlags
                    $openImage = $openWim[$Edition]
                } else {

                    if ([String]::IsNullOrEmpty($Edition)) {
                        Write-W2VError "You must specify an Edition or SKU index, since the WIM has more than one image."
                        Write-W2VError "Valid edition names are:"
                        $openWim.Images | %{ Write-W2VError "  $($_.ImageFlags)" }
                        throw
                    } 
                }

                $Edition | ForEach-Object -Process {

                    $Edition = $PSItem
    
                    if ([Int32]::TryParse($Edition, [ref]$null)) {
                        $openImage = $openWim[[Int32]$Edition]    
                    } else {
                        $openImage = $openWim[$Edition]
                    }    

                    if ($null -eq $openImage) {
                        Write-W2VError "The specified edition does not appear to exist in the specified WIM."
                        Write-W2VError "Valid edition names are:"
                        $openWim.Images | %{ Write-W2VError "  $($_.ImageFlags)" }
                        throw
                    }

                    Write-W2VInfo
                    Write-W2VInfo "Image $($openImage.ImageIndex) selected ($($openImage.ImageFlags))..."

                    # Check to make sure that the image we're applying is Windows 7 or greater.
                    if ($openImage.ImageVersion -lt $lowestSupportedVersion) {
                        throw "Convert-WindowsImage only supports Windows 7 and Windows 8 WIM files.  The specified image does not appear to contain one of those operating systems."
                    }

                    <#
                        Create the VHD using the VirtDisk Win32 API.
                        So, why not use the New-VHD cmdlet here?
        
                        New-VHD depends on the Hyper-V Cmdlets, which aren't installed by default.
                        Installing those cmdlets isn't a big deal, but they depend on the Hyper-V WMI
                        APIs, which in turn depend on Hyper-V.  In order to prevent Convert-WindowsImage
                        from being dependent on Hyper-V (and thus, x64 systems only), we're using the 
                        VirtDisk APIs directly.
                    #>
                    if ($VHDType -eq "Dynamic") {
                        Write-W2VInfo "Creating sparse disk..."
                        $openVhd = [WIM2VHD.VirtualHardDisk]::CreateSparseDisk(
                            $VHDFormat,
                            $VHDPath,
                            $SizeBytes,
                            $true
                        )
                    } else {
                        Write-W2VInfo "Creating fixed disk..."
                        $openVhd = [WIM2VHD.VirtualHardDisk]::CreateFixedDisk(
                            $VHDFormat,
                            $VHDPath,
                            $SizeBytes,
                            $true
                        )
                    }

                    # Attach the VHD.
                    Write-W2VInfo "Attaching $VHDFormat..."
                    $openVhd.Attach()

                    if ($VHDPartitionStyle -eq "MBR" ) {
                        Initialize-Disk -Number $openVhd.DiskIndex -PartitionStyle MBR
                        Write-W2VInfo "Disk initialized with MBR..."
                    } elseif ($VHDPartitionStyle -eq "GPT" ) {
                        Initialize-Disk -Number $openVhd.DiskIndex -PartitionStyle GPT
                        Write-W2VInfo "Disk initialized with GPT..."
                    }
                
                    $disk      = Get-Disk -Number $openVhd.DiskIndex

                    if ( $VHDPartitionStyle -eq "MBR") {
                        $partition       = New-Partition -DiskNumber $openVhd.DiskIndex -Size $disk.LargestFreeExtent -MbrType IFS -IsActive
                        Write-W2VInfo "Disk partitioned..."
                    } elseif ( $VHDPartitionStyle -eq "GPT" ) {
                
                        Write-W2VInfo "Disk partitioned"

                        If
                        (
                            $BCDinVHD -eq "VirtualMachine"
                        )
                        {
                            $PartitionSystem = New-Partition -DiskNumber $openVhd.DiskIndex -Size 100MB -GptType '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}'
                            Write-W2VInfo "System Partition created"

                        }
                
                        $partition       = New-Partition -DiskNumber $openVhd.DiskIndex -UseMaximumSize -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}'
                        Write-W2VInfo "Boot Partition created"
                    }

                    if ( $VHDPartitionStyle -eq "MBR" ) {
                        $volume    = Format-Volume -Partition $partition -FileSystem NTFS -Force -Confirm:$false
                        Write-W2VInfo "Volume formatted..."
                    } elseif ( $VHDPartitionStyle -eq "GPT" ) {

                        If
                        (
                            $BCDinVHD -eq "VirtualMachine"
                        )
                        {
                
                          # The following line won't work. Thus we need to substitute it with DiskPart
                          # $volumeSystem    = Format-Volume -Partition $partitionSystem -FileSystem FAT32 -Force -Confirm:$false

                            @"
select disk $($disk.Number)
select partition $($partitionSystem.PartitionNumber)
format fs=fat32 label="System"
"@ | & $env:SystemRoot\System32\DiskPart.exe | Out-Null

                            Write-W2VInfo "System Volume formatted (with DiskPart)..."
                
                        }
              
                        $volume          = Format-Volume -Partition $partition -FileSystem NTFS -Force -Confirm:$false
                        Write-W2VInfo "Boot Volume formatted (with Format-Volume)..."
                    }
        
                    if ( $VHDPartitionStyle -eq "MBR") {
                        $partition       | Add-PartitionAccessPath -AssignDriveLetter
                        $drive           = $(Get-Partition -Disk $disk).AccessPaths[0]
                        Write-W2VInfo "Access path ($drive) has been assigned..."
                    } elseif ( $VHDPartitionStyle -eq "GPT" ) {

                        If
                        (
                            $BCDinVHD -eq "VirtualMachine"
                        )
                        {

                            $partitionSystem | Add-PartitionAccessPath -AssignDriveLetter
                            $driveSystem     = $(Get-Partition -Disk $disk).AccessPaths[1]
                            Write-W2VInfo "Access path ($driveSystem) has been assigned to the System Volume..."

                            $partition       | Add-PartitionAccessPath -AssignDriveLetter
                            $drive           = $(Get-Partition -Disk $disk).AccessPaths[2]
                            Write-W2VInfo "Access path ($drive) has been assigned to the Boot Volume..."
                        }
                        ElseIf
                        (
                            $BCDinVHD -eq "NativeBoot"
                        )
                        {
                            $partition       | Add-PartitionAccessPath -AssignDriveLetter
                            $drive           = $(Get-Partition -Disk $disk).AccessPaths[1]
                            Write-W2VInfo "Access path ($drive) has been assigned to the Boot Volume..."
                        }
                    }

                    Write-W2VInfo "Applying image to $VHDFormat. This could take a while..."

                    $openImage.Apply($drive)

                    if (![string]::IsNullOrEmpty($UnattendPath)) {
                        Write-W2VInfo "Applying unattend file ($(Split-Path $UnattendPath -Leaf))..."
                        Copy-Item -Path $UnattendPath -Destination (Join-Path $drive "unattend.xml") -Force
                    }

                    Write-W2VInfo "Signing disk..."
                    $flagText | Out-File -FilePath (Join-Path $drive "Convert-WindowsImageInfo.txt") -Encoding Unicode -Force

                    if ($openImage.ImageArchitecture -ne "ARM") {

                        if ( $BCDinVHD -eq "VirtualMachine" ) {
                        # We only need this if VHD is prepared for a VM.
                        # In this case VHD is "Self-Sustainable", i.e. contains a boot loader and does not depend on external files.
                        # (There's nothing "External" from the perspecitve of VM by definition).

                            Write-W2VInfo "Image applied. Making image bootable..."

                            if ( $VHDPartitionStyle -eq "MBR" ) {

                                $bcdBootArgs = @(
                                    "$($drive)Windows",    # Path to the \Windows on the VHD
                                    "/s $drive",           # Specifies the volume letter of the drive to create the \BOOT folder on.
                                    "/v"                   # Enabled verbose logging.
                                    "/f BIOS"              # Specifies the firmware type of the target system partition
                                )

                            } elseif ( $VHDPartitionStyle -eq "GPT" ) {

                                $bcdBootArgs = @(
                                    "$($drive)Windows",    # Path to the \Windows on the VHD
                                    "/s $driveSystem",     # Specifies the volume letter of the drive to create the \BOOT folder on.
                                    "/v"                   # Enabled verbose logging.
                                    "/f UEFI"              # Specifies the firmware type of the target system partition
                                )

                            }

                            Run-Executable -Executable $BCDBoot -Arguments $bcdBootArgs


                          # I'm commenting this out in order to workaround the bug in VMM diff disk handling.
                          # This turns out to affect the VM Role provisioning with Windows Azure Pack.
                          # Nowadays, everything is supposed to work even without specifying the Disk Signature.

                         <# if ( $VHDPartitionStyle -eq "MBR" ) {          

                                Apply-BcdStoreChanges                     `
                                    -BcdStoreFile    "$($drive)boot\bcd"  `
                                    -PartitionStyle  $PARTITION_STYLE_MBR `
                                    -DiskSignature   $disk.Signature      `
                                    -PartitionOffset $partition.Offset    

                            } #>

                          # The following is added to mitigate the VMM diff disk handling
                          # We're going to change from MBRBootOption to LocateBootOption.

                            if ( $VHDPartitionStyle -eq "MBR" ) {

                                Write-W2VInfo "Fixing the Device ID in the BCD store on $($VHDFormat)..."
                                Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                                    "/store $($drive)boot\bcd",
                                    "/set `{bootmgr`} device locate"
                                )
                                Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                                    "/store $($drive)boot\bcd",
                                    "/set `{default`} device locate"
                                )
                                Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                                    "/store $($drive)boot\bcd",
                                    "/set `{default`} osdevice locate"
                                )

                            }

                            Write-W2VInfo "Drive is bootable. Cleaning up..."

                        } elseif ( $BCDinVHD -eq "NativeBoot" ) {
                        # For Native Boot we don't need BCD store inside the VHD.
                        # Both Boot Loader and its configuration store live outside the VHD (on physical disk).

                            Write-W2VInfo "Image applied. It is not bootable without an external boot loader. Cleaning up..."

                        }

                        # Are we turning the debugger on?
                        if ($EnableDebugger -inotlike "None") {
                            Write-W2VInfo "Turning kernel debugging on in the $($VHDFormat)..."
                            Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                                "/store $($drive)\boot\bcd",
                                "/set `{default`} debug on"
                            )
                        }
            
                        # Configure the specified debugging transport and other settings.
                        switch ($EnableDebugger) {
                
                            "Serial" {
                                Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                                    "/store $($drive)\boot\bcd",
                                    "/dbgsettings SERIAL",
                                    "DEBUGPORT:$($ComPort.Value)",
                                    "BAUDRATE:$($BaudRate.Value)"
                                )
                                break
                            }
                
                            "1394" {
                                Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                                    "/store $($drive)\boot\bcd",
                                    "/dbgsettings 1394",
                                    "CHANNEL:$($Channel.Value)"
                                )
                                break
                            }
                
                            "USB" {
                                Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                                    "/store $($drive)\boot\bcd",
                                    "/dbgsettings USB",
                                    "TARGETNAME:$($Target.Value)"
                                )
                                break
                            }
                
                            "Local" {
                                Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                                    "/store $($drive)\boot\bcd",
                                    "/dbgsettings LOCAL"
                                )
                                break
                            }
             
                            "Network" {
                                Run-Executable -Executable "BCDEDIT.EXE" -Arguments (
                                    "/store $($drive)\boot\bcd",
                                    "/dbgsettings NET",
                                    "HOSTIP:$($IP.Value)",
                                    "PORT:$($Port.Value)",
                                    "KEY:$($Key.Value)"
                                )
                                break
                            }
                                
                            default {
                                # Nothing to do here - bail out.
                                break
                            }
                        }
            
                    } else {
                        # Don't bother to check on debugging.  We can't boot WoA VHDs in VMs, and 
                        # if we're native booting, the changes need to be made to the BCD store on the 
                        # physical computer's boot volume.
            
                        Write-W2VInfo "Not making VHD bootable, since WOA can't boot in VMs."
                    }

                    if (
                        ( 
                            $RemoteDesktopEnable -eq $True
                        ) -or (
                            $ExpandOnNativeBoot -eq $False
                        )
                    ) {
        
                        $hive         = Mount-RegistryHive -Hive (Join-Path $drive "Windows\System32\Config\System")
        
                        if ( $RemoteDesktopEnable -eq $True ) {

                            Write-W2VInfo -text "Enabling Remote Desktop"
                            Set-ItemProperty -Path "HKLM:\$($hive)\ControlSet001\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

                        }

                        if ( $ExpandOnNativeBoot -eq $False ) {
            
                            Write-W2VInfo -text "Disabling automatic $VHDFormat expansion for Native Boot"
                            Set-ItemProperty -Path "HKLM:\$($hive)\ControlSet001\Services\FsDepends\Parameters" -Name "VirtualDiskExpandOnMount" -Value 4
            
                        }

                        Dismount-RegistryHive -HiveMountPoint $hive

                    }

                    if ( $Driver ) {

                        Write-W2VInfo -text "Adding Windows Drivers to the Image"

                        $Driver | ForEach-Object -Process {

                            Write-W2VInfo -text "Driver path: $PSItem"
                            $Dism = Add-WindowsDriver -Path $drive -Recurse -Driver $PSItem
                        }
                    }

                    If ( $Feature ) {
            
                        Write-W2VInfo -text "Installing Windows Feature(s) $Feature to the Image"
                        $FeatureSourcePath = Join-Path -Path "$($driveLetter):" -ChildPath "sources\sxs"
                        Write-W2VInfo -text "From $FeatureSourcePath"
                        $Dism = Enable-WindowsOptionalFeature -FeatureName $Feature -Source $FeatureSourcePath -Path $drive -All

                    }

                    if ( $Package ) {

                        Write-W2VInfo -text "Adding Windows Packages to the Image"
            
                        $Package | ForEach-Object -Process {

                            Write-W2VInfo -text "Package path: $PSItem"
                            $Dism = Add-WindowsPackage -Path $drive -PackagePath $PSItem
                        }
                    }

                    if ([String]::IsNullOrEmpty($vhdFinalName)) {
                        # We need to generate a file name. 
                        Write-W2VInfo "Generating name for $($VHDFormat)..."
                        $hive         = Mount-RegistryHive -Hive (Join-Path $drive "Windows\System32\Config\Software")

                        $buildLabEx   = (Get-ItemProperty "HKLM:\$($hive)\Microsoft\Windows NT\CurrentVersion").BuildLabEx
                        $installType  = (Get-ItemProperty "HKLM:\$($hive)\Microsoft\Windows NT\CurrentVersion").InstallationType
                        $editionId    = (Get-ItemProperty "HKLM:\$($hive)\Microsoft\Windows NT\CurrentVersion").EditionID
                        $skuFamily    = $null

                        Dismount-RegistryHive -HiveMountPoint $hive

                        # Is this ServerCore?
                        # Since we're only doing this string comparison against the InstallType key, we won't get
                        # false positives with the Core SKU.
                        if ($installType.ToUpper().Contains("CORE")) {
                            $editionId += "Core"
                        }

                        # What type of SKU are we?
                        if ($installType.ToUpper().Contains("SERVER")) {
                            $skuFamily = "Server"
                        } elseif ($installType.ToUpper().Contains("CLIENT")) {
                            $skuFamily = "Client"
                        } else {
                            $skuFamily = "Unknown"
                        }

                        $vhdFinalName = "$($buildLabEx)_$($skuFamily)_$($editionId)_$($openImage.ImageDefaultLanguage).$($VHDFormat.ToLower())"
                        Write-W2VTrace "$VHDFormat final name is : $vhdFinalName"
                    }

                    $vhdFinalPathCurrent = Join-Path (Split-Path $VHDPath -Parent) $vhdFinalName
                    Write-W2VTrace "$VHDFormat final path is : $vhdFinalPathCurrent"

                    Write-W2VInfo "Closing $VHDFormat..."
                    $openVhd.Close()
                    $openVhd = $null
    
                    if (Test-Path $vhdFinalPathCurrent) {
                        Write-W2VInfo "Deleting pre-existing $VHDFormat : $(Split-Path $vhdFinalPathCurrent -Leaf)..."
                        Remove-Item -Path $vhdFinalPathCurrent -Force
                    }
            
                    $vhdFinalPath += $vhdFinalPathCurrent

                    Write-W2VTrace -Text "Renaming $VHDFormat at $VHDPath to $vhdFinalName"
                    Rename-Item -Path (Resolve-Path $VHDPath).Path -NewName $vhdFinalName -Force

                    $vhd += Get-DiskImage -ImagePath $vhdFinalPathCurrent

                    $vhdFinalName = $Null
                }

            } catch {
    
                Write-W2VError $_
                Write-W2VInfo "Log folder is $logFolder"

            } finally { 
 
                # If we still have a WIM image open, close it.
                if ($openWim -ne $null) {
                    Write-W2VInfo 
                    Write-W2VInfo "Closing Windows image..."
                    $openWim.Close()
                }

                # If we still have a registry hive mounted, dismount it.
                if ($mountedHive -ne $null) {
                    Write-W2VInfo "Closing registry hive..."
                    Dismount-RegistryHive -HiveMountPoint $mountedHive
                }

                # If we still have a VHD(X) open, close it.
                if ($openVhd -ne $null) {
                    Write-W2VInfo "Closing $VHDFormat..."
                    $openVhd.Close()
                }

                # If we still have an ISO open, close it.
                if ($openIso -ne $null) {
                    Write-W2VInfo "Closing ISO..."
                    Dismount-DiskImage $ISOPath
                }
 
                # Check to see if the WIM is local, or on a network location.  If the latter, remove the copy.
                if ( Test-Path -Path "Variable:\SourceIsNetwork" ) {

                    Remove-Item -Path $SourcePath
                }
    
                # Close out the transcript and tell the user we're done.
                Write-W2VInfo "Done."
                if ($transcripting) {
                    $null = Stop-Transcript
                }
            }
        }

        End {

            if ($Passthru) {
    
                return $vhd
            }
        }

   #endregion Code

}