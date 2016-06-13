## Install-ContainerHost.ps1

#### NAME
    Install-ContainerHost.ps1
    
#### SYNOPSIS
    Installs the prerequisites for creating Windows containers
    
#### SYNTAX
    Install-ContainerHost.ps1 [-DockerPath <String>] [-ExternalNetAdapter <String>] 
    [-Force] [-HyperV] [-NoRestart] [-PSDirect] [-SkipImageImport]  
    [-UseDHCP] [-WimPath <String>] [<CommonParameters>]
    
    Install-ContainerHost.ps1 [-DockerPath <String>] [-ExternalNetAdapter <String>] 
    [-Force] [-HyperV] [-NoRestart] [-PSDirect] 
    [-SkipImageImport] [-UseDHCP] [-WimPath <String>] [<CommonParameters>]
    
    Install-ContainerHost.ps1 [-DockerPath <String>] [-ExternalNetAdapter <String>] 
    [-Force] [-HyperV] [-NoRestart] [-PSDirect]  
    [-SkipImageImport] -Staging [-UseDHCP] [-WimPath <String>] [<CommonParameters>]
    
    
#### DESCRIPTION
    Installs the prerequisites for creating Windows containers
    

#### PARAMETERS
    -DockerPath <String>
        Path to Docker.exe, can be local or URI
        
        Required?                    false
        Position?                    named
        Default value                https://aka.ms/tp4/docker
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -ExternalNetAdapter <String>
        Specify a specific network adapter to bind to a DHCP switch
        
        Required?                    false
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Force [<SwitchParameter>]
        If a restart is required, forces an immediate restart.
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -HyperV [<SwitchParameter>]
        If passed, prepare the machine for Hyper-V containers
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -NoRestart [<SwitchParameter>]
        If a restart is required the script will terminate and will not reboot the machine
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -PSDirect [<SwitchParameter>]
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -SkipImageImport [<SwitchParameter>]
        Skips import of the base WindowsServerCore image.
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Staging [<SwitchParameter>]
        
        Required?                    true
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -UseDHCP [<SwitchParameter>]
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -WimPath <String>
        Path to .wim file that contains the base package image
        
        Required?                    false
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
        
#### NOTES
        Copyright (c) Microsoft Corporation.  All rights reserved.
        
        Use of this sample source code is subject to the terms of the Microsoft
        license agreement under which you licensed this sample source code. If
        you did not accept the terms of the license agreement, you are not
        authorized to use this sample source code. For the terms of the license,
        please see the license agreement between you and Microsoft or, if applicable,
        see the LICENSE.RTF on your install media or the root of your tools installation.
        THE SAMPLE SOURCE CODE IS PROVIDED "AS IS", WITH NO WARRANTIES.
    
#### Examples
    
    PS C:\>.\Install-ContainerHost.ps1
    
#### Prerequisites
Requires PowerShell version 5.0




