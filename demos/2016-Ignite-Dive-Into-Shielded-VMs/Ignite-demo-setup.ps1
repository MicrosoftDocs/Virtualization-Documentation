Param(
    [int]$StartFromStage = 5, # Always trying to start with the latest existing environment snapshop
    [int]$StopBeforeStage = 255,
    [int]$MemoryScaleFactor = 1,

    [ValidateSet("AllVMs","Baseimages","Everything")]
    [string]$Cleanup
)

#######################################################################################
# Initialization of variables
#######################################################################################

$VerbosePreference = "Continue"

# The following value needs to be set to /IACCEPTSQLSERVERLICENSETERMS
$IAcceptSqlLicenseTerms = ""

# The following value needs to be set to /iacceptsceula
$IAcceptSCEULA = "" 

# Source paths
$Script:sourcePath = "C:\IgniteSource"
$Script:sourceMediaPath = Join-Path $Script:sourcePath -ChildPath "\WindowsServer2016\"
$Script:sourceUpdatePath = Join-Path $Script:sourcePath -ChildPath "\WindowsServer2016Updates\"
$Script:sourceVMMWAPDependenciesPath = Join-Path $Script:sourcePath -ChildPath "\VMMWAPDependencies\" 

# Environment configuration
$Script:domainName = "relecloud.com"
$Script:hgsDomainName = "hgs.$($Script:domainName)"
$Script:clearTextPassword = "P@ssw0rd."
$Script:passwordSecureString = ConvertTo-SecureString -AsPlainText $Script:clearTextPassword -Force

$Script:internalSwitchName = "FabricInternal"
$Script:internalSubnet = "10.10.42."
$Script:externalSwitchName = "FabricExternal"
$Script:fabricSwitch = $Script:internalSwitchName

$Script:localAdminCred = New-Object System.Management.Automation.PSCredential ("administrator", $Script:passwordSecureString)
$Script:relecloudAdminCred = New-Object System.Management.Automation.PSCredential ("relecloud\administrator", $Script:passwordSecureString)
$Script:relecloudLarsCred = New-Object System.Management.Automation.PSCredential ("relecloud\lars", $Script:passwordSecureString)
$Script:hgsAdminCred = New-Object System.Management.Automation.PSCredential ("hgs\administrator", $Script:passwordSecureString)

$Script:basePath = "C:\Ignite"
$Script:vhdxServerCorePath = Join-Path $Script:basePath -ChildPath "\WindowsServer2016_ServerDataCenterCore.vhdx"
$Script:vhdxServerStandardPath = Join-Path $Script:basePath -ChildPath "\WindowsServer2016_ServerStandard.vhdx"
$Script:vhdxNanoServerPath = Join-Path $Script:basePath -ChildPath "\WindowsServer2016_ServerDataCenterNano.vhdx"
$Script:vhdxNanoServerGuardedHostPath = Join-Path $Script:basePath -ChildPath "\WindowsServer2016_ServerDataCenterNano_GuardedHost.vhdx"
$Script:vhdxVMMWAPDependenciesPath = Join-Path $Script:basePath -ChildPath "\VMMWAPDependencies.vhdx"
$Script:vhdxVMMShieldingHelperDiskPath = Join-Path $Script:basePath -ChildPath "\VMMShieldingHelperDisk.vhdx"

$Script:ImageConverterPath = Join-Path -Path $Script:sourceMediaPath -ChildPath "NanoServer\NanoServerImageGenerator\Convert-WindowsImage.ps1"
$Script:UnattendPath = Join-Path $Script:basePath -ChildPath "IgniteUnattend.xml"

$Script:VmNameDc = "Fabric - Domain Controller"
$Script:VmNameVmm = "Fabric - Virtual Machine Manager"
$Script:VmNameCompute = "Fabric - Guarded Host"
$Script:VmNameHgs = "HGS - Host Guardian Service"

$Script:EnvironmentVMs = @()

$Script:stagenames = (
    "Stage 0 Create VMs", 
    "Stage 1 Roles, Computernames, Static IPs",
    "Stage 2 Prepare HGS, configure DHCP, create fabric domain",
    "Stage 3 Configure HGS in AD mode, join compute nodes to domain",
    "Stage 4 Configure VMM",
    "Demo"
    )

$Script:stage = $StartFromStage
$Script:MemoryScaleFactor = $MemoryScaleFactor

$SCVMMSetupConfig =@"
[OPTIONS]
# ProductKey=xxxxx-xxxxx-xxxxx-xxxxx-xxxxx
ProgramFiles=C:\Program Files\Microsoft System Center 2016\Virtual Machine Manager
CreateNewSqlDatabase=1
SqlInstanceName=MSSQLServer
SqlDatabaseName=VirtualManagerDB
RemoteDatabaseImpersonation=1
# SqlMachineName=<sqlmachinename>
# IndigoTcpPort=8100
# IndigoHTTPSPort=8101
# IndigoNETTCPPort=8102
# IndigoHTTPPort=8103
# WSManTcpPort=5985
# BitsTcpPort=443
CreateNewLibraryShare=1
LibraryShareName=MSSCVMMLibrary
LibrarySharePath=D:\Library\Virtual Machine Manager Library Files
# LibraryShareDescription=Virtual Machine Manager Library Files
# SQMOptIn = 1
# MUOptIn = 0
# VmmServiceLocalAccount = 0
# TopContainerName = VMMServer
# HighlyAvailable = 0
# VmmServerName = <VMMServerName>
# VMMStaticIPAddress = <comma-separated-ip-for-HAVMM>
"@

# SQL Server configuration ini
$SQLServerSetupConfig = @"
;SQL Server 2014 Configuration File
[OPTIONS]
; Use the /ENU parameter to install the English version of SQL Server on your localized Windows operating system. 
ENU="True"

; Specify whether SQL Server Setup should discover and include product updates. The valid values are True and False or 1 and 0. By default SQL Server Setup will include updates that are found. 
UpdateEnabled="False"

; Specify if errors can be reported to Microsoft to improve future SQL Server releases. Specify 1 or True to enable and 0 or False to disable this feature. 
ERRORREPORTING="True"

; If this parameter is provided, then this computer will use Microsoft Update to check for updates. 
USEMICROSOFTUPDATE="False"

; Specifies features to install, uninstall, or upgrade. The list of top-level features include SQL, AS, RS, IS, MDS, and Tools. The SQL feature will install the Database Engine, Replication, Full-Text, and Data Quality Services (DQS) server. The Tools feature will install Management Tools, Books online components, SQL Server Data Tools, and other shared components. 
FEATURES=SQLENGINE,SSMS,ADV_SSMS

; Specify the location where SQL Server Setup will obtain product updates. The valid values are "MU" to search Microsoft Update, a valid folder path, a relative path such as .\MyUpdates or a UNC share. By default SQL Server Setup will search Microsoft Update or a Windows Update service through the Window Server Update Services. 
UpdateSource="MU"

; Displays the command line parameters usage 
HELP="False"

; Specifies that the detailed Setup log should be piped to the console. 
INDICATEPROGRESS="False"

; Specifies that Setup should install into WOW64. This command line argument is not supported on an IA64 or a 32-bit system. 
X86="False"

; Specify the root installation directory for shared components.  This directory remains unchanged after shared components are already installed. 
INSTALLSHAREDDIR="C:\Program Files\Microsoft SQL Server"

; Specify the root installation directory for the WOW64 shared components.  This directory remains unchanged after WOW64 shared components are already installed. 
INSTALLSHAREDWOWDIR="C:\Program Files (x86)\Microsoft SQL Server"

; Specify a default or named instance. MSSQLSERVER is the default instance for non-Express editions and SQLExpress for Express editions. This parameter is required when installing the SQL Server Database Engine (SQL), Analysis Services (AS), or Reporting Services (RS). 
INSTANCENAME="MSSQLSERVER"

; Specify that SQL Server feature usage data can be collected and sent to Microsoft. Specify 1 or True to enable and 0 or False to disable this feature. 
SQMREPORTING="True"

; Specify the Instance ID for the SQL Server features you have specified. SQL Server directory structure, registry structure, and service names will incorporate the instance ID of the SQL Server instance. 
INSTANCEID="MSSQLSERVER"

; Specify the installation directory. 
INSTANCEDIR="C:\Program Files\Microsoft SQL Server"

; Agent account name 
AGTSVCACCOUNT="NT Service\SQLSERVERAGENT"

; Auto-start service after installation.  
AGTSVCSTARTUPTYPE="Manual"

; CM brick TCP communication port 
COMMFABRICPORT="0"

; How matrix will use private networks 
COMMFABRICNETWORKLEVEL="0"

; How inter brick communication will be protected 
COMMFABRICENCRYPTION="0"

; TCP port used by the CM brick 
MATRIXCMBRICKCOMMPORT="0"

; Startup type for the SQL Server service. 
SQLSVCSTARTUPTYPE="Automatic"

; Level to enable FILESTREAM feature at (0, 1, 2 or 3). 
FILESTREAMLEVEL="0"

; Set to "1" to enable RANU for SQL Server Express. 
ENABLERANU="False"

; Specifies a Windows collation or an SQL collation to use for the Database Engine. 
SQLCOLLATION="SQL_Latin1_General_CP1_CI_AS"

; Account for SQL Server service: Domain\User or system account. 
SQLSVCACCOUNT="NT Service\MSSQLSERVER"

; Provision current user as a Database Engine system administrator for %SQL_PRODUCT_SHORT_NAME% Express. 
ADDCURRENTUSERASSQLADMIN="False"

; Specify 0 to disable or 1 to enable the TCP/IP protocol. 
TCPENABLED="1"

; Specify 0 to disable or 1 to enable the Named Pipes protocol. 
NPENABLED="0"

; Startup type for Browser Service. 
BROWSERSVCSTARTUPTYPE="Disabled"
"@

$UnattendFile = [xml]@"
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <servicing></servicing>

    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <ComputerName>*</ComputerName>
            <RegisteredOrganization>The Power Elite</RegisteredOrganization>
            <RegisteredOwner>Lars Iwer</RegisteredOwner>
            <TimeZone>Pacific Standard Time</TimeZone>
        </component>
        <component name="Microsoft-Windows-TerminalServices-LocalSessionManager" processorArchitecture="x86" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
          <fDenyTSConnections>false</fDenyTSConnections>
        </component>
        <component name="Microsoft-Windows-TerminalServices-RDP-WinStationExtensions" processorArchitecture="x86" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"> 
          <UserAuthentication>0</UserAuthentication>
        </component>
        <component name="Networking-MPSSVC-Svc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <FirewallGroups>
                <FirewallGroup wcm:action="add" wcm:keyValue="RemoteDesktop">
                    <Active>true</Active>
                    <Profile>all</Profile>
                    <Group>@FirewallAPI.dll,-28752</Group>
                </FirewallGroup>
            </FirewallGroups>
        </component>
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <NetworkLocation>Work</NetworkLocation>
                <ProtectYourPC>1</ProtectYourPC>
            </OOBE>
            <UserAccounts>
                <AdministratorPassword>
                    <Value>P@ssw0rd.</Value>
                    <PlainText>True</PlainText>
                </AdministratorPassword>
                <LocalAccounts>
                    <LocalAccount wcm:action="add">
                        <Password>
                            <Value>P@ssw0rd</Value>
                            <PlainText>True</PlainText>
                        </Password>
                        <DisplayName>Demo</DisplayName>
                        <Group>Administrators</Group>
                        <Name>demo</Name>
                    </LocalAccount>
                </LocalAccounts>
            </UserAccounts>
        </component>
        <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InputLocale>en-us</InputLocale>
            <SystemLocale>en-us</SystemLocale>
            <UILanguage>en-us</UILanguage>
            <UILanguageFallback>en-us</UILanguageFallback>
            <UserLocale>en-us</UserLocale>
        </component>
    </settings>
</unattend>
"@

#######################################################################################
# Helper Functions
#######################################################################################

function Write-TimeStamp {
    Param(
        [switch]$Dark
    )
    If ($Dark) {
        Write-Host (Get-Date -Format "yyyy-MM-dd HH:mm:ss") -ForegroundColor DarkCyan -NoNewline
    }
    else {
        Write-Host (Get-Date -Format "yyyy-MM-dd HH:mm:ss") -ForegroundColor Cyan -NoNewline
    }
    
    Write-Host " $("`t"*$Level)" -NoNewline
}

function Log-Message
{
    Param(
        [Parameter(Mandatory=$True)]
        [string] 
        $Message,

        [int]
        $Level = 0,

        [ValidateSet("Informational","Warning","Error","Verbose")]
        $MessageType = "Informational"
    )
    
    switch ($MessageType) {
        "Informational" { Write-TimeStamp; Write-Host $Message }
        "Warning" { Write-TimeStamp; Write-Host $Message -ForegroundColor Yellow }
        "Error" { Write-TimeStamp; Write-Host $Message -ForegroundColor Red }
        "Verbose" { If ($VerbosePreference -eq "Continue") { Write-TimeStamp -Dark; Write-Host $Message -ForegroundColor Gray } }
    }
}

function Reboot-VM {
    Param(
        [Microsoft.HyperV.PowerShell.VirtualMachine]$VM
    )
    If ($VM.State -eq "Running")
    {
        Log-Message -Level 1 -Message "Shutting down $($VM.VMName)"
        Stop-VM -VM $VM -ErrorAction SilentlyContinue | Out-Null
    }
    Log-Message -Level 1 -Message "Starting $($VM.VMName)"
    Start-VM -VM $VM
}

Function Cleanup-File {
    Param(
        [string]$path
    )
    If (Test-Path $path) {
        Log-Message -Message "Removing  $path"
        Remove-Item -Path $path -Force -ErrorAction Stop | Out-Null
    }
}

function Prepare-VM 
{
    Param(
        [Parameter(Mandatory=$True)]
        [string]$VMname,
        [Parameter(Mandatory=$True)]
        [string]$basediskpath,

        [int]$processorcount = 2,
        $startupmemory = 1GB,
        [bool]$dynamicmemory = $false,
        [string]$switchname = $Script:fabricSwitch,
        [bool]$startvm = $false,
        [bool]$enablevirtualizationextensions = $false,
        [bool]$enablevtpm = $false
    )

    $FabricPath = Join-Path $Script:basePath -ChildPath "\fabric\"
    $VMPath = $VHDXPath = Join-Path $FabricPath -ChildPath "$VMname"
    $VHDXPath = Join-Path $VMPath -ChildPath "Virtual Hard Disks\OSDisk.vhdx"

    $VM = Get-VM -VMName $VMname -ErrorAction SilentlyContinue
    If ($VM)
    {
        Log-Message -Level 1 -Message "[$VMname] Removing existing Virtual Machine"
        Stop-VM -VM $VM -TurnOff -Force -WarningAction SilentlyContinue | Out-Null
        Get-VMSnapshot -VM $VM | Remove-VMSnapshot -Confirm:$false | Out-Null
        Remove-VM -VM $VM -Force -WarningAction SilentlyContinue | Out-Null
    }

    Cleanup-File -Path $VHDXPath

    Log-Message -Level 1 -Message "[$VMname] Creating new differencing disk" 
    New-VHD -Differencing -Path $VHDXPath -ParentPath $basediskpath -ErrorAction Stop | Out-Null
    
    If ($Script:MemoryScaleFactor -ne 1) 
    {
        Log-Message -Message "[$VMname] Multiplying memory assignment with factor $Script:MemoryScaleFactor" -Level 1 -MessageType Verbose
        $startupmemory = $startupmemory * $Script:MemoryScaleFactor
    }

    Log-Message -Level 1 -Message "[$VMname] Creating Virtual Machine"
    $VM = New-VM -Name $VMname -MemoryStartupBytes $startupmemory -Path $FabricPath -VHDPath $VHDXPath -Generation 2 -SwitchName $switchname -ErrorAction Stop

    If ($processorcount -gt 1)
    {
        Log-Message -Message "[$VMname] Setting processor count to $processorcount" -Level 1 -MessageType Verbose
        Set-VMProcessor -VM $VM -Count $processorcount  | Out-Null
    }
    If (-not $dynamicmemory)
    {
        Log-Message -Message "[$VMname] Disabling Dynamic Memory" -Level 1 -MessageType Verbose
        Set-VMMemory -VM $VM -DynamicMemoryEnabled $false | Out-Null
    }
    If ($enablevirtualizationextensions)
    {
        Log-Message -Message "[$VMname] Enabling Virtualization Extensions" -Level 1 -MessageType Verbose
        Set-VMProcessor -VM $VM -ExposeVirtualizationExtensions $true | Out-Null
        Log-Message -Message "[$VMname] Enabling Mac Address Spoofing" -Level 1 -MessageType Verbose
        Get-VMNetworkAdapter -VM $VM | Set-VMNetworkAdapter -MacAddressSpoofing on
    }
    If ($enablevtpm)
    {
        Log-Message -Message "[$VMname] Enabling vTPM" -Level 1 -MessageType Verbose
        $keyprotector = New-HgsKeyProtector -Owner $Script:HgsGuardian -AllowUntrustedRoot
        Set-VMKeyProtector -VM $VM -KeyProtector $keyprotector.RawData -ErrorAction Stop | Out-Null
        Enable-VMTPM -VM $VM -ErrorAction Stop | Out-Null
    }

    if ($startvm)
    {
        Log-Message -Message "[$VMname] Starting VM" -Level 1
        Start-VM $VM -ErrorAction Stop | Out-Null
    }

    # return vm
    $VM
}

function Create-EnvironmentStageCheckpoint
{
    Param(
        [int]$Stage = $Script:stage,
        [Microsoft.HyperV.PowerShell.VirtualMachine[]]$VirtualMachines = $Script:EnvironmentVMs,
        [bool]$shutdown = $True
    )
    If ($shutdown)
    {
        Log-Message -Message "Shutting down VMs for environment checkpoint for $($Script:stagenames[$Stage])" -MessageType Verbose
        Stop-VM -VM $VirtualMachines -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
    Log-Message -Message "Creating environment checkpoint for $($Script:stagenames[$Stage])"
    Checkpoint-VM -SnapshotName $Script:stagenames[$Stage] -VM $VirtualMachines | Out-Null
}

function Reset-EnvironmentToStageCheckpoint
{
    Param(
        [int]$Stage,
        [Microsoft.HyperV.PowerShell.VirtualMachine[]]$VirtualMachines = $Script:EnvironmentVMs
    )
    Log-Message -Message "Resetting environment to latest available stage checkpoint"
    $success = $false
    Do  
    {
        Log-Message -Level 1 -Message "Searching checkpoints for $($Script:stagenames[$Stage])" 
        $Snapshots = Get-VMSnapshot -VM $VirtualMachines -Name $Script:stagenames[$Stage] -ErrorAction SilentlyContinue
        If ($Snapshots)
        {
            Stop-VM -VM $VirtualMachines -TurnOff -Force -WarningAction SilentlyContinue
            Log-Message -Level 1 -Message "Checkpoints found. Restoring."
            $Snapshots | Restore-VMSnapshot -Confirm:$false -ErrorAction Stop
            $success = $True
            $Script:stage = $Stage + 1
        }
        If ($Stage -gt 0 -and -not $success)
        {
            Log-Message -Level 1 -Message "Checkpoints not found." 
            $Stage--
        }
    } While (-not $success -and $Stage -ge -1)
    If (-not $success)
    {
        Log-Message -Level 1 -Message "Locating checkpoints not successful. Resetting current stage to 0"
        $Script:stage = 0
    }
    
    For ($i=$Stage+1; $i -lt ($Script:stagenames).Count; $i++)
    {
        $Snapshots = Get-VMSnapshot -VM $VirtualMachines -Name $Script:stagenames[$i] -ErrorAction SilentlyContinue 
        If ($Snapshots)
        {
            Log-Message -Level 1 -Message "Removing checkpoints for stage $($Script:stagenames[$i])"
            $Snapshots | Remove-VMSnapshot -Confirm:$false 
        }
    }
}

function Invoke-CommandWithPSDirect
{
    Param(
        [Parameter(Mandatory=$true)]
        [Microsoft.HyperV.PowerShell.VirtualMachine]
        $VirtualMachine,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        $Credential,
        
        [Parameter(Mandatory=$true)]
        [ScriptBlock]
        $ScriptBlock,

        [Object[]]
        $ArgumentList
    )
    If ($VirtualMachine.State -eq "Off")
    {
        Log-Message -Level 1 -Message "Starting VM $($VirtualMachine.VMName)"
        Start-VM $VirtualMachine -ErrorAction Stop | Out-Null
    }
    
    $heartbeatic = (Get-VMIntegrationService -VM $VirtualMachine |? Id -match "84EAAE65-2F2E-45F5-9BB5-0E857DC8EB47")
    If ($heartbeatic -and ($heartbeatic.Enabled -eq $true)) 
    {
        $startTime = Get-Date
        do 
        {
            $timeElapsed = $(Get-Date) - $startTime
            if ($($timeElapsed).TotalMinutes -ge 10)
            {
                Log-Message -Level 1 -Message "Integration components did not come up after 10 minutes" -MessageType Error
                throw
            } 
            Start-Sleep -sec 1
        } 
        until ($heartbeatic.PrimaryStatusDescription -eq "OK")
        Log-Message -Message "Heartbeat IC connected." -Level 1 -MessageType Verbose
    }

    Log-Message -Message "Waiting for PSDirect connection to $($VirtualMachine.VMName) for $($Credential.UserName)" -Level 1 -MessageType Verbose 
    $startTime = Get-Date
    do 
    {
        $timeElapsed = $(Get-Date) - $startTime
        if ($($timeElapsed).TotalMinutes -ge 10)
        {
            Log-Message -Message "Could not connect to PS Direct after 10 minutes" -MessageType Error -Level 1
            throw
        } 
        Start-Sleep -sec 1
        $psReady = Invoke-Command -VMId $VirtualMachine.VMId -Credential $Credential -ScriptBlock { $True } -ErrorAction SilentlyContinue
    } 
    until ($psReady)
    
    Log-Message -Message "Running Script Block" -Level 1
    If ($ArgumentList)
    {
        Invoke-Command -VMId $VirtualMachine.VMId -Credential $Credential -ScriptBlock $ScriptBlock -ArgumentList $ArgumentList -ErrorAction SilentlyContinue    
    }
    else 
    {
        Invoke-Command -VMId $VirtualMachine.VMId -Credential $Credential -ScriptBlock $ScriptBlock -ErrorAction SilentlyContinue    
    }
}

function Copy-ItemToVm
{
    Param(
        [Parameter(Mandatory=$true)]
        [Microsoft.HyperV.PowerShell.VirtualMachine]
        $VirtualMachine,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        $Credential,
        
        [Parameter(Mandatory=$true)]
        [String]
        $SourcePath,

        [Parameter(Mandatory=$true)]
        [String]
        $DestinationPath
    )
    If ($VirtualMachine.State -eq "Off")
    {
        Log-Message -Level 1 -Message "Starting VM $($VirtualMachine.VMName)"
        Start-VM $VirtualMachine -ErrorAction Stop | Out-Null
    }
    
    $startTime = Get-Date
    do 
    {
        $timeElapsed = $(Get-Date) - $startTime
        if ($($timeElapsed).TotalMinutes -ge 10)
        {
            Log-Message -Level 1 -Message "Integration components did not come up after 10 minutes" -MessageType Error
            throw
        } 
        Start-Sleep -sec 1
    } 
    until ((Get-VMIntegrationService -VM $VirtualMachine |? Id -match "84EAAE65-2F2E-45F5-9BB5-0E857DC8EB47").PrimaryStatusDescription -eq "OK")
    Log-Message -Message "Heartbeat IC connected." -Level 1 -MessageType Verbose

    Log-Message -Message "Waiting for PSDirect connection to $($VirtualMachine.VMName) to be available" -Level 1 -MessageType Verbose
    $startTime = Get-Date
    do 
    {
        $timeElapsed = $(Get-Date) - $startTime
        if ($($timeElapsed).TotalMinutes -ge 10)
        {
            Log-Message -Level 1 -Message "Could not connect to PS Direct after 10 minutes" -MessageType Error
            throw
        } 
        Start-Sleep -sec 1
        $psReady = Invoke-Command -VMId $VirtualMachine.VMId -Credential $Credential -ScriptBlock { $True } -ErrorAction SilentlyContinue
    } 
    until ($psReady)

    Log-Message -Message "Opening PowerShell session to VM $($VirtualMachine.Name)" -Level 1 -MessageType Verbose
    $s = New-PSSession -VMId $VirtualMachine.VMId -Credential $Credential
    Invoke-Command -Session $s -ScriptBlock {
        $path = Split-Path -Path $using:DestinationPath -Parent
        If (-not (Test-Path $path))
        {
            New-Item -ItemType Directory -Path $path | Out-Null
        } 
    }
    Log-Message -Level 1 -Message "Copying file to VM $($VirtualMachine.Name)"
    Copy-Item -ToSession $s -Path $SourcePath -Destination $DestinationPath  -Force | Out-Null
    Log-Message -Message "Closing PowerShell session" -Level 1 -MessageType Verbose
    Remove-PSSession $s | Out-Null

    #Copy-VMFile -VM $VirtualMachine -SourcePath $SourcePath -DestinationPath $DestinationPath -FileSource Host -CreateFullPath
}

Function WaitFor-ActiveDirectory {
    Param(
        [Parameter(Mandatory=$true)]
        [Microsoft.HyperV.PowerShell.VirtualMachine]
        $VirtualMachine,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    Log-Message -Level 1 -Message "Waiting for AD to be up and running"
    Invoke-CommandWithPSDirect -VirtualMachine $VirtualMachine -Credential $Credential -ScriptBlock {
        do {
            Write-Host "." -NoNewline -ForegroundColor Gray
            Start-Sleep -Seconds 5
            Get-ADComputer $env:COMPUTERNAME | Out-Null
        } until ($?)
        Write-Host "done."
    }
}

Function MountAndInitialize-VHDX {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$VHDXPath
    )
    Log-Message -Message "Mounting VHDX" -Level 1
    $mountedvhdx = Mount-VHD -Path $VHDXPath -Passthru -ErrorAction Stop
    $mounteddisk = $mountedvhdx | Get-Disk
    if ((Get-Disk -Number $mounteddisk.Number).PartitionStyle -eq "RAW")
    {
        Log-Message -Message "Raw disk - initializing, creating partition and formatting" -Level 1
        Log-Message -Message "Initializing disk" -MessageType Verbose -Level 1
        Initialize-Disk -Number $mounteddisk.Number -PartitionStyle MBR
    }

    $partition = Get-Partition -DiskNumber $mounteddisk.Number -ErrorAction SilentlyContinue
    If (-not ($partition)) {
        Log-Message -Message "Creating new partition" -MessageType Verbose -Level 1
        $partition = New-Partition -DiskNumber $mounteddisk.Number -Size $mounteddisk.LargestFreeExtent -MbrType IFS -IsActive
    }

    $volume = Get-Volume -Partition $partition -ErrorAction SilentlyContinue
    If (-not ($volume.FileSystem)) {
        Log-Message -Message "Formatting" -MessageType Verbose -Level 1
        $volume = Format-Volume -Partition $partition -FileSystem NTFS -Force -Confirm:$false 

        Log-Message -Message "Assigning drive letter" -MessageType Verbose -Level 1
        $partition | Add-PartitionAccessPath -AssignDriveLetter | Out-Null
    }

    $driveLetter = (Get-Volume |? UniqueId -eq $volume.UniqueId).DriveLetter
    Log-Message -Message "Drive letter: $driveletter" -MessageType Verbose -Level 1

    $driveletter
}


Function Begin-Stage {
    Param(
        $StartVMs = $true
    )
    Log-Message -Message "Begin $($Script:stagenames[$Script:stage])"
    $Script:StageStartTime = Get-Date
    If ($StartVMs) {
        Log-Message -Message "Starting all VMs" -Level 0 -MessageType Verbose 
        Start-VM -VM $Script:EnvironmentVMs -ErrorAction Stop | Out-Null
    }
}

Function End-Stage {
    Log-Message -Message "End of $($Script:stagenames[$Script:stage]) - Duration: $(((Get-Date) - $Script:StageStartTime))"
    Create-EnvironmentStageCheckpoint
    $Script:stage++
}

#######################################################################################
# Start of script 
#######################################################################################
$Script:ScriptStartTime = Get-Date
Log-Message -Message "Starting script"

#######################################################################################
# Explicit cleanup
#######################################################################################

If (($Cleanup -eq "AllVMs") -or ($Cleanup -eq "Everything"))
{
    Log-Message -Message "[Cleanup] Removing existing VMs"
    Get-VM | Stop-VM -TurnOff -Force -WarningAction SilentlyContinue | Out-Null
    Get-VM | Remove-VM -Force -WarningAction SilentlyContinue | Out-Null
    Get-ChildItem -Path (Join-Path $Script:basePath -ChildPath fabric) -Recurse | Remove-Item -Force -Recurse -WarningAction SilentlyContinue | Out-Null
}
If (($Cleanup -eq "Baseimages") -or ($Cleanup -eq "Everything"))
{
    Log-Message -Message "[Cleanup] Removing existing base VHDXs"
    Cleanup-File -path $Script:vhdxServerCorePath
    Cleanup-File -path $Script:vhdxServerStandardPath
    Cleanup-File -path $Script:vhdxNanoServerPath
}

#######################################################################################
# Preparation of base VHDXs
#######################################################################################

$Script:installWimPath = Join-Path $Script:sourceMediaPath -ChildPath "sources\Install.wim"

If (Test-Path $Script:sourceUpdatePath) {
    $Updates = @()
    Log-Message -Message "[Prepare] Found updates path"   
    foreach ($Update in (Get-ChildItem $Script:sourceUpdatePath -Recurse -include "*.cab" -Exclude WSUSSCAN.CAB))
    {
        Log-Message -Message "[Prepare] Found $($Update.Name)" -MessageType Verbose
        $Updates += $Update.FullName
    }
}

if (Test-Path $Script:ImageConverterPath)
{
    Log-Message -Message "[Prepare] Running Image converter script to get Convert-WindowsImage function"
    . $Script:ImageConverterPath
}

if (-Not (Test-Path $Script:UnattendPath))
{
    Log-Message -Message "Creating unattend file" 
    $UnattendFile.InnerXml | Set-Content -Path $Script:UnattendPath -Encoding UTF8
}

$buildServerCore = -Not (Test-Path $Script:vhdxServerCorePath)
$buildServerStandard = -Not (Test-Path $Script:vhdxServerStandardPath)
$buildNanoServer = -Not (Test-Path $Script:vhdxNanoServerPath)
$buildNanoServerGuardedHost = -Not (Test-Path $Script:vhdxNanoServerGuardedHostPath)
$buildShieldingHelperVhdx = -Not (Test-Path $Script:vhdxVMMShieldingHelperDiskPath)

If (($buildServerCore -or $buildServerStandard -or $buildNanoServer -or $buildNanoServerGuardedHost -or $buildShieldingHelperVhdx) -and (-not(Test-Path $Script:sourceMediaPath)))
{
    throw "Base media path not found"
}

If ($buildNanoServer -or $buildNanoServerGuardedHost) 
{
    Log-Message -Message "Importing Nano Server Image Generator PowerShell Module" -MessageType Verbose
    Import-Module (Join-Path $Script:sourceMediaPath -ChildPath "\NanoServer\NanoServerImageGenerator\NanoServerImageGenerator.psm1") | Out-Null
}

if ($buildServerCore)
{
    Log-Message -Message "[Prepare] Creating Server Datacenter Core base VHDX"
    If ($Updates) {
        Convert-WindowsImage -SourcePath ($Script:installWimPath) -VHDPath $Script:vhdxServerCorePath -DiskLayout UEFI -Edition SERVERDATACENTERCORE -UnattendPath $Script:UnattendPath -SizeBytes 40GB -Package $Updates | Out-Null
    } else {
        Convert-WindowsImage -SourcePath ($Script:installWimPath) -VHDPath $Script:vhdxServerCorePath -DiskLayout UEFI -Edition SERVERDATACENTERCORE -UnattendPath $Script:UnattendPath -SizeBytes 40GB | Out-Null
    }
}

if ($buildServerStandard)
{
    Log-Message -Message "[Prepare] Creating Server Standard Full UI base VHDX"
    If ($Updates) {
        Convert-WindowsImage -SourcePath ($Script:installWimPath) -VHDPath $Script:vhdxServerStandardPath -DiskLayout UEFI -Edition SERVERSTANDARD -UnattendPath $Script:UnattendPath -SizeBytes 40GB -Package $Updates | Out-Null
    } else {
        Convert-WindowsImage -SourcePath ($Script:installWimPath) -VHDPath $Script:vhdxServerStandardPath -DiskLayout UEFI -Edition SERVERSTANDARD -UnattendPath $Script:UnattendPath -SizeBytes 40GB | Out-Null    
    }
}

if ($buildNanoServer)
{
    Log-Message -Message "[Prepare] Creating Nano Server Datacenter base VHDX"
    
    If ($Updates) {
        New-NanoServerImage -DeploymentType Guest -Edition Datacenter -MediaPath $Script:sourceMediaPath -Package Microsoft-NanoServer-SecureStartup-Package,Microsoft-NanoServer-Guest-Package,Microsoft-NanoServer-SCVMM-Package,Microsoft-NanoServer-SCVMM-Compute-Package,Microsoft-NanoServer-ShieldedVM-Package -TargetPath $Script:vhdxNanoServerPath -EnableRemoteManagementPort -AdministratorPassword $Script:passwordSecureString -ServicingPackagePath $Updates | Out-Null
    } else {
        New-NanoServerImage -DeploymentType Guest -Edition Datacenter -MediaPath $Script:sourceMediaPath -Package Microsoft-NanoServer-SecureStartup-Package,Microsoft-NanoServer-Guest-Package,Microsoft-NanoServer-SCVMM-Package,Microsoft-NanoServer-SCVMM-Compute-Package,Microsoft-NanoServer-ShieldedVM-Package -TargetPath $Script:vhdxNanoServerPath -EnableRemoteManagementPort -AdministratorPassword $Script:passwordSecureString | Out-Null    
    }
}

if ($buildNanoServerGuardedHost)
{
    Log-Message -Message "[Prepare] Creating Nano Server Datacenter guarded host VHDX"

    If ($Updates) {
        New-NanoServerImage -DeploymentType Guest -Edition Datacenter -MediaPath $Script:sourceMediaPath -Package Microsoft-NanoServer-SecureStartup-Package,Microsoft-NanoServer-Guest-Package -TargetPath $Script:vhdxNanoServerGuardedHostPath -EnableRemoteManagementPort -AdministratorPassword $Script:passwordSecureString -ServicingPackagePath $Updates | Out-Null
    } else {
        New-NanoServerImage -DeploymentType Guest -Edition Datacenter -MediaPath $Script:sourceMediaPath -Package Microsoft-NanoServer-SecureStartup-Package,Microsoft-NanoServer-Guest-Package -TargetPath $Script:vhdxNanoServerGuardedHostPath -EnableRemoteManagementPort -AdministratorPassword $Script:passwordSecureString | Out-Null    
    }
}

If ($buildShieldingHelperVhdx)
{
    Log-Message -Message "Creating shielding helper disk"
    If (-Not (Test-Path $Script:sourceMediaPath))
    {
        throw "Base media path not found"
    }
    If ($Updates) {
        Convert-WindowsImage -SourcePath ($Script:installWimPath) -VHDPath $Script:vhdxVMMShieldingHelperDiskPath -DiskLayout UEFI -Edition SERVERDATACENTERCORE -UnattendPath $Script:UnattendPath -SizeBytes 40GB -Package $Updates | Out-Null
    } else {
        Convert-WindowsImage -SourcePath ($Script:installWimPath) -VHDPath $Script:vhdxVMMShieldingHelperDiskPath -DiskLayout UEFI -Edition SERVERDATACENTERCORE -UnattendPath $Script:UnattendPath -SizeBytes 40GB | Out-Null
    }

    $shieldingHelperDiskSpecializationVm = Prepare-VM -VMname ShieldingHelperDisk -processorcount 4 -startupmemory 6GB -basediskpath $Script:vhdxServerCorePath

    Log-Message -Message "[Prepare] Starting VM to prepare shielding helper disk"
    Start-VM -VM $shieldingHelperDiskSpecializationVm | Out-Null

    Invoke-CommandWithPSDirect -VirtualMachine $shieldingHelperDiskSpecializationVm -Credential $Script:localAdminCred -ScriptBlock { $true }

    Log-Message -Message "[Prepare] Shutting down shielding helper disk VM"
    Stop-VM -VM $shieldingHelperDiskSpecializationVm

    Log-Message -Message "[Prepare] Removing shielding helper disk VM"
    Remove-VM -VM $shieldingHelperDiskSpecializationVm -Force
}

if (-Not (Test-Path $Script:vhdxVMMWAPDependenciesPath)) 
{
    Log-Message -Message "[Prepare] Creating VMM/WAP installation Dependencies VHDX"
    If (-Not (Test-Path $Script:sourceVMMWAPDependenciesPath))
    {
        throw "Base VMM/WAP installation dependencies path not found"
    }

    Log-Message -Message "[Prepare] Creating new VHDX" -MessageType Verbose
    $dependenciesvhdx = New-VHD -Path $Script:vhdxVMMWAPDependenciesPath -SizeBytes 40GB -Dynamic

    $driveletter = MountAndInitialize-VHDX $Script:vhdxVMMWAPDependenciesPath -ErrorAction Stop
    
    Log-Message -Message "[Prepare] Copying files - this might take some time." -MessageType Verbose
    Copy-Item -Path $Script:sourceVMMWAPDependenciesPath -Destination "$($driveLetter):" -Recurse | Out-Null

    Log-Message -Message "[Prepare] Dismounting VHDX" -MessageType Verbose
    Dismount-VHD -Path $Script:vhdxVMMWAPDependenciesPath
}

#######################################################################################
# Initialization of additional variables
#######################################################################################

$Script:HgsGuardian = Get-HgsGuardian UntrustedGuardian -ErrorAction SilentlyContinue
if (!$Script:HgsGuardian) {
    Log-Message -Message "[Prepare] Local Guardian not found - creating UntrustedGuardian"
    $Script:HgsGuardian = New-HgsGuardian -Name UntrustedGuardian –GenerateCertificates -ErrorAction Stop
}

if (-not (Get-VMSwitch -Name $Script:fabricSwitch -ErrorAction SilentlyContinue)) {
    Log-Message -Message "[Prepare] Fabric Switch not found - creating internal switch"
    New-VMSwitch -Name $Script:fabricSwitch -SwitchType Internal -ErrorAction Stop | Out-Null
}

$hgs01 = Get-VM -VMName $Script:VmNameHgs -ErrorAction SilentlyContinue
$dc01 = Get-VM -VMName $Script:VmNameDc -ErrorAction SilentlyContinue
$vmm01 = Get-VM -VMName $Script:VmNameVmm -ErrorAction SilentlyContinue
$compute01 = Get-VM -VMName "$Script:VmNameCompute 01" -ErrorAction SilentlyContinue
$compute02 = Get-VM -VMName "$Script:VmNameCompute 02" -ErrorAction SilentlyContinue

if ($hgs01 -and $dc01 -and $vmm01 -and $compute01 -and $compute02)
{
    Log-Message -Message "[Prepare] Initializing variable storing environment VMs"
    $Script:EnvironmentVMs = $hgs01, $dc01, $vmm01, $compute01, $compute02    
}
else 
{
    Log-Message -Message "[Prepare] Starting from Stage 0 since not all VMs could be found"
    $StartFromStage = 0
    $Script:stage = 0
}

$FunctionDefs = "function Write-TimeStamp { ${Function:Write-TimeStamp} }; Function Log-Message { ${Function:Log-Message} }"

#######################################################################################
# Beginning of Environment Build
#######################################################################################

If ($StartFromStage -gt 1)
{
    Reset-EnvironmentToStageCheckpoint -Stage ($StartFromStage-1)
}

#######################################################################################
# Beginning of Stage 0: Create VMs
#######################################################################################
If ($Script:stage -eq 0 -and $Script:stage -lt $StopBeforeStage)
{
    Begin-Stage -StartVMs $false

    $hgs01 = Prepare-VM -vmname $Script:VmNameHgs -basediskpath $Script:vhdxServerCorePath -dynamicmemory $true
    $dc01 = Prepare-VM -vmname $Script:VmNameDc -basediskpath $Script:vhdxServerCorePath -dynamicmemory $true
    $vmm01 = Prepare-VM -vmname $Script:VmNameVmm -processorcount 4 -basediskpath $Script:vhdxServerStandardPath -startupmemory 8GB
    $compute01 = Prepare-VM -vmname "$Script:VmNameCompute 01" -processorcount 4 -startupmemory 6GB -enablevirtualizationextensions $true -enablevtpm $true -basediskpath $Script:vhdxServerCorePath
    $compute02 = Prepare-VM -vmname "$Script:VmNameCompute 02" -processorcount 4 -startupmemory 6GB -enablevirtualizationextensions $true -enablevtpm $true -basediskpath $Script:vhdxServerCorePath
    
    $Script:EnvironmentVMs = ($hgs01, $dc01, $vmm01, $compute01, $compute02)
    End-Stage
} 

#######################################################################################
# End of Stage 0: Create VMs
#######################################################################################

#######################################################################################
# Beginning of Stage 1: Initial VM Configuration: Roles, Computernames, Static IPs
#######################################################################################
If ($Script:stage -eq 1 -and $Script:stage -lt $StopBeforeStage)
{
    Begin-Stage

    $ScriptBlock_FeaturesComputerName = {
            Param(
                [hashtable]$param
            )
            . ([ScriptBlock]::Create($Using:FunctionDefs))

            If ($param["features"])
            {
                If ($param["featuresource"])
                {
                    Log-Message -Message "Installing Windows Features $($param["features"]) using source path $($param["featuresource"])" -Level 2
                    Install-WindowsFeature $param["features"] -IncludeManagementTools -Source $param["featuresource"] -ErrorAction Stop -WarningAction SilentlyContinue | Out-Null
                } else {
                    Log-Message -Message  "Intalling Windows Features $($param["features"])"  -Level 2
                    Install-WindowsFeature $param["features"] -IncludeManagementTools -ErrorAction Stop -WarningAction SilentlyContinue | Out-Null                    
                }
            }
            If ($param["ipaddress"])
            {
                Log-Message -Message "Setting Network configuration: IP $($param["ipaddress"])" -Level 2
                Get-NetAdapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $param["ipaddress"] -PrefixLength 24 | Out-Null
            }
            Get-DnsClientServerAddress | %{Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses "$($param["subnet"])1"}
            If ($param["computername"])
            {
                Log-Message -Message "Renaming computer to $($param["computername"])" -Level 2
                Rename-Computer $param["computername"] -WarningAction SilentlyContinue | Out-Null
            }
        }

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_FeaturesComputerName -ArgumentList @{
            features=("AD-Domain-Services","DHCP");
            ipaddress="$($Script:internalSubnet)1";
            computername="DC01";
            subnet=$Script:internalSubnet
        }

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_FeaturesComputerName -ArgumentList @{
            features="HostGuardianServiceRole";
            ipaddress="$($Script:internalSubnet)99";
            computername="HGS01";
            subnet=$Script:internalSubnet
        }

    Copy-ItemToVm -VirtualMachine $vmm01 -SourcePath (Join-Path $Script:sourceMediaPath -ChildPath "sources\sxs\microsoft-windows-netfx3-ondemand-package.cab") -DestinationPath C:\sxs\microsoft-windows-netfx3-ondemand-package.cab -Credential $Script:localAdminCred

    Invoke-CommandWithPSDirect -VirtualMachine $vmm01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_FeaturesComputerName -ArgumentList @{
            features=("NET-Framework-Features", "NET-Framework-Core", "Web-Server", "ManagementOData", "Web-Dyn-Compression", "Web-Basic-Auth", "Web-Windows-Auth", `
                      "Web-Scripting-Tools", "WAS", "WAS-Process-Model", "WAS-NET-Environment", "WAS-Config-APIs", "Hyper-V-Tools", "Hyper-V-PowerShell", "RSAT-Shielded-VM-Tools");
            featuresource="C:\sxs";
            computername="VMM01";
            subnet=$Script:internalSubnet
        }
    
    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_FeaturesComputerName -ArgumentList @{
            features=("Hyper-V","HostGuardian"); # Run this on server core only!
            computername="Compute01";
            subnet=$Script:internalSubnet
        }

    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_FeaturesComputerName -ArgumentList @{
            features=("Hyper-V","HostGuardian"); # Run this on server core only!
            computername="Compute02";
            subnet=$Script:internalSubnet
        }

    End-Stage
} 
# Defining all VMs that are part of the environment
#######################################################################################
# End of  Stage 1: Initial VM Configuration: Roles, Computernames, Static IPs
#######################################################################################

#######################################################################################
# Beginning of Stage 2 Prepare HGS, configure DHCP, create fabric domain
#######################################################################################
If ($Script:stage -eq 2 -and $Script:stage -lt $StopBeforeStage)
{
    Begin-Stage

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:localAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            . ([ScriptBlock]::Create($Using:FunctionDefs))

            Log-Message -Message "Setting PowerShell as default shell" -Level 2
            Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name Shell -Value "PowerShell.exe" | Out-Null

            Log-Message -Message "Configuring DHCP Server" -Level 2
            Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias Ethernet
            Add-DhcpServerv4Scope -Name "IPv4 network" -StartRange "$($param["subnet"])100" -EndRange "$($param["subnet"])200" -SubnetMask 255.255.255.0 | Out-Null
            Log-Message -Message "Creating fabric domain $($param["domainName"])" -Level 2
            Install-ADDSForest -DomainName $param["domainName"] -SafeModeAdministratorPassword $param["adminpassword"] `
                               -InstallDNS -NoDNSonNetwork -NoRebootOnCompletion -Force -WarningAction SilentlyContinue | Out-Null
        } -ArgumentList @{
            domainname=$Script:domainName;
            adminpassword=$Script:passwordSecureString;
            subnet=$Script:internalSubnet
        }

    Reboot-VM -vm $dc01 | Out-Null
    WaitFor-ActiveDirectory -VirtualMachine $dc01 -Credential $Script:relecloudAdminCred

    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:relecloudAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            . ([ScriptBlock]::Create($Using:FunctionDefs))

            Log-Message -Message "Creating AD Users and Groups" -Level 2
            Log-Message -Message "Creating User Lars" -Level 2
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline -ForegroundColor Gray
                New-ADUser -Name "Lars" -SAMAccountName "lars" -GivenName "Lars" -DisplayName "Lars" -AccountPassword $param["adminpassword"] -CannotChangePassword $true -Enabled $true  -ErrorAction SilentlyContinue | Out-Null
            } until ($?)
            Write-Host "done." 

            Log-Message -Message "Configuring Lars as Domain Admin" -Level 2
            Add-ADGroupMember "Domain Admins" "Lars"

            Log-Message -Message "Creating VMM service account user" -Level 2
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline -ForegroundColor Gray
                New-ADUser -Name "vmmserviceaccount" -SAMAccountName "vmmserviceaccount" -GivenName "System Center Virtual Machine Manager" -DisplayName "System Center Virtual Machine Manager" -AccountPassword $param["adminpassword"] -Enabled $true -ErrorAction SilentlyContinue | Out-Null
            } until ($?)
            Write-Host "done." 

            Log-Message -Message "Creating SQL admin user" -Level 2
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline -ForegroundColor Gray
                New-ADUser -Name "sqladmin" -SAMAccountName "sqladmin" -GivenName "SQL Server Administrator" -DisplayName "SQL Server Administrator" -AccountPassword $param["adminpassword"] -Enabled $true -ErrorAction SilentlyContinue | Out-Null
            } until ($?)
            Write-Host "done." 

            Log-Message -Message "Creating ComputeHosts group" -Level 2
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline -ForegroundColor Gray
                New-ADGroup -Name "ComputeHosts" -DisplayName "Hyper-V Compute Hosts" -GroupCategory Security -GroupScope Universal  -ErrorAction SilentlyContinue | Out-Null
            } until ($?)
            Write-Host "done." 

            Set-DhcpServerv4OptionValue -DnsDomain $param["domainname"] -DnsServer "$($param["subnet"]).1" | Out-Null
            Set-DhcpServerv4OptionValue -OptionId 6 -value "$($param["subnet"]).1"

            Log-Message -Message "Registering DHCP server with DC" -Level 2
            do {
                Start-Sleep -Seconds 3
                Write-Host "." -NoNewline -ForegroundColor Gray
                Add-DhcpServerInDC -ErrorAction Continue
            } until ($?) 
            Write-Host "done."
            
            Log-Message -Message "Creating VHDX SMB share" -Level 2
            New-Item -Path 'C:\vhdx' -ItemType Directory | Out-Null
            New-SmbShare -Name VHDX -Path C:\vhdx -FullAccess "$($param["domainname"])\administrator", "$($param["domainname"])\lars", "$($param["domainname"])\ComputeHosts" -ReadAccess "Everyone" | Out-Null
            Set-SmbPathAcl –ShareName VHDX | Out-Null

            Log-Message -Message "Creating Attestation SMB share" -Level 2
            New-Item C:\Attestation -ItemType Directory | Out-Null
            New-SmbShare -Name Attestation -Path C:\Attestation -FullAccess "$($param["domainname"])\administrator", "$($param["domainname"])\lars", "$($param["domainname"])\ComputeHosts" -ReadAccess "Everyone" | Out-Null
            Set-SmbPathAcl –ShareName Attestation | Out-Null
            
        } -ArgumentList @{
            domainname=$Script:domainName;
            adminpassword=$Script:passwordSecureString;
            subnet=$Script:internalSubnet
        }

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:localAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            . ([ScriptBlock]::Create($Using:FunctionDefs))

            Log-Message -Message "Setting PowerShell as default shell" -Level 2
            Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name Shell -Value "PowerShell.exe" | Out-Null

            Log-Message -Message "Preparing Host Guardian Service" -Level 2
            Install-HgsServer -HgsDomainName $param["hgsdomainname"] -SafeModeAdministratorPassword $param["adminpassword"] -WarningAction SilentlyContinue | Out-Null
        } -ArgumentList @{
            hgsdomainname=$Script:hgsDomainName;
            adminpassword=$Script:passwordSecureString
        }

    Reboot-VM $hgs01 | Out-Null
    WaitFor-ActiveDirectory -VirtualMachine $hgs01 -Credential $Script:hgsAdminCred | Out-Null

    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:hgsAdminCred -ScriptBlock {
        Param(
            [hashtable]$param
        )
        . ([ScriptBlock]::Create($Using:FunctionDefs))

        New-Item -Path 'C:\HgsCertificates' -ItemType Directory | Out-Null

        Log-Message -Message "Creating self-signed certificates for HGS configuration" -Level 2
        $signingCert = New-SelfSignedCertificate -DnsName "signing.$($param["hgsdomainname"])"
        Export-PfxCertificate -Cert $signingCert -Password $param["adminpassword"] -FilePath C:\HgsCertificates\signing.pfx | Out-Null
        $encryptionCert = New-SelfSignedCertificate -DnsName "encryption.$($param["hgsdomainname"])"
        Export-PfxCertificate -Cert $encryptionCert -Password $param["adminpassword"] -FilePath C:\HgsCertificates\encryption.pfx | Out-Null

        Log-Message -Message "Removing certificates from local store after exporting" -Level 2 
        Remove-Item $EncryptionCert.PSPath, $SigningCert.PSPath -DeleteKey -ErrorAction Continue | Out-Null

        Log-Message -Message "Configuring Host Guardian Service - AD-based trust" -Level 2
        Initialize-HgsServer -HgsServiceName service -TrustActiveDirectory `
            -SigningCertificatePath C:\HgsCertificates\signing.pfx -SigningCertificatePassword $param["adminpassword"] `
            -EncryptionCertificatePath C:\HgsCertificates\encryption.pfx -EncryptionCertificatePassword $param["adminpassword"] `
            -WarningAction SilentlyContinue | Out-Null

        Log-Message -Message "Speeding up DNS registration of cluster network name" -Level 2
        Get-ClusterResource -Name HgsClusterResource | Update-ClusterNetworkNameResource | Out-Null
        (Get-ClusterNetwork).Role = 3

    } -ArgumentList @{
        hgsdomainname=$Script:hgsDomainName
        adminpassword=$Script:passwordSecureString
    }

    End-Stage
} 
#######################################################################################
# End of Stage 2 Prepare HGS, configure DHCP, create fabric domain
#######################################################################################

#######################################################################################
# Beginning of Stage 3 Configure HGS in AD mode, join compute nodes to domain
#######################################################################################
If ($Script:stage -eq 3 -and $Script:stage -lt $StopBeforeStage)
{
    Begin-Stage

    $ComputeHostsSID = Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:relecloudAdminCred -ScriptBlock {
        . ([ScriptBlock]::Create($Using:FunctionDefs))

        Log-Message -Message "Retrieving SID for group ComputeHosts" -Level 2
        do {
            Write-Host "." -NoNewline -ForegroundColor Gray
            Start-Sleep -Seconds 2
            $sid = Get-ADGroup ComputeHosts -ErrorAction SilentlyContinue | select -ExpandProperty SID | select -ExpandProperty Value 
        } until ($?)
        Write-Host "done."
        Log-Message -Message "SID: $sid" -Level 2
        
        $sid 
    } # This also ensures that AD functionality is up and running before continuing.

    $ScriptBlock_ConfigureComputeHosts = {
            . ([ScriptBlock]::Create($Using:FunctionDefs))
            Log-Message -Message "Changing required platform security features for host $($env:COMPUTERNAME)" -Level 2
            Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\ -Name RequirePlatformSecurityFeatures -Type DWord -Value 1

            Log-Message -Message "Enabling File & Printer Sharing Firewall Rule"
            Enable-NetFirewallRule –Group "@FirewallAPI.dll,-28502"
        }
    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_ConfigureComputeHosts 
    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_ConfigureComputeHosts


    $ScriptBlock_DomainJoin = {
            Param(
                [hashtable]$param
            )
            . ([ScriptBlock]::Create($Using:FunctionDefs))

            $dcip = $param["dcip"]
            Log-Message -Message "Waiting for domain controller $($param["domainname"]) at $dcip" -Level 2
            while (!(Test-Connection -Computername "$dcip" -BufferSize 16 -Count 1 )) #-Quiet -ea SilentlyContinue 
            {
                Start-Sleep -Seconds 2
            }
            $edition = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion')| Select -expandproperty EditionID
            Log-Message -Message "Joining system $($env:COMPUTERNAME) ($($edition)) to domain $($param["domainname"])." -Level 2
            switch ($edition)
            {
                "ServerDataCenterNano" {
                    $djoinpath = "\\$dcip\c$\djoin\$($env:COMPUTERNAME).djoin"
                    if (Test-Path $djoinpath) {
                        Log-Message -Message "Using $djoinpath" -Level 2
                        djoin /requestodj /loadfile "$djoinpath" /windowspath C:\Windows /localos
                    }
                    else {
                        Log-Message -Message "$djoinpath not found."
                        throw
                    }
                }
                default {
                    $cred = New-Object System.Management.Automation.PSCredential ($param["domainuser"], $param["domainpwd"])
                    do {
                        Write-Host "." -NoNewline -ForegroundColor Gray
                        Start-Sleep -Seconds 2
                        Add-Computer -DomainName $param["domainname"] -Credential $cred -ErrorAction SilentlyContinue -WarningAction SilentlyContinue| Out-Null    
                    } until ($?)
                    Write-Host "done." -ForegroundColor Gray
                }
            }
        }
    
    $Arg_DomainJoin = @{
            domainname=$Script:domainName;
            domainuser="relecloud\administrator";
            domainpwd=$Script:passwordSecureString;
            dcip="$($Script:internalSubnet)1"
        }

    Invoke-CommandWithPSDirect -VirtualMachine $vmm01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_DomainJoin -ArgumentList $Arg_DomainJoin 
    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_DomainJoin -ArgumentList $Arg_DomainJoin
    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:localAdminCred -ScriptBlock $ScriptBlock_DomainJoin -ArgumentList $Arg_DomainJoin
    
    Reboot-VM $vmm01
    Reboot-VM $compute01
    Reboot-VM $compute02

    WaitFor-ActiveDirectory -VirtualMachine $hgs01 -Credential $Script:hgsAdminCred
    Invoke-CommandWithPSDirect -VirtualMachine $hgs01 -Credential $Script:hgsAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            . ([ScriptBlock]::Create($Using:FunctionDefs))

            Log-Message -Message "Creating a DNS forwarder to the fabric AD $($param["domainname"])" -Level 2
            Add-DnsServerConditionalForwarderZone -Name $($param["domainname"]) -MasterServers "$($param["subnet"])1"

            Log-Message -Message "Adding a one-way trust to the fabric AD $($param["domainname"])" -Level 2
            netdom.exe trust $($param["hgsdomainname"]) /domain:$($param["domainname"]) /userD:$($param["domainuser"]) /passwordD:$($param["domainpwd"]) /add

            Log-Message -Message "Adding SID $($param["computehostssid"]) to HGS attestation" -Level 2
            Add-HgsAttestationHostGroup -Name "ComputeHosts" -Identifier $param["computehostssid"] | Out-Null

            # Setting policies for nested environment - POC use only!!
            Disable-HgsAttestationPolicy -Name Hgs_IommuEnabled -WarningAction SilentlyContinue
            Disable-HgsAttestationPolicy -Name Hgs_HypervisorEnforcedCiPolicy -WarningAction SilentlyContinue
            Disable-HgsAttestationPolicy -Name Hgs_PagefileEncryptionEnabled -WarningAction SilentlyContinue
        } -ArgumentList @{
            domainname=$Script:domainName;
            domainuser="relecloud\administrator";
            domainpwd=$Script:clearTextPassword;
            hgsdomainname=$Script:hgsDomainName;
            computehostssid = $ComputeHostsSID;
            subnet=$Script:internalSubnet
        }
    
    Invoke-CommandWithPSDirect -VirtualMachine $dc01 -Credential $Script:relecloudAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            . ([ScriptBlock]::Create($Using:FunctionDefs))

            Log-Message -Message "Adding compute hosts to ComputeHosts group" -Level 2
            Add-ADGroupMember "ComputeHosts" -Members "Compute01$"
            Add-ADGroupMember "ComputeHosts" -Members "Compute02$"
            
            Log-Message -Message "Creating DNS Zone delegation to HGS for $($param["domainname"])" -Level 2
            Add-DnsServerZoneDelegation -Name $($param["domainname"]) -ChildZone "hgs" -NameServer "hgs01.$($param["domainname"])" -IPAddress "$($param["subnet"])99"
            
        } -ArgumentList @{
            domainname=$Script:domainName;
            hgsdomainname=$Script:hgsDomainName
            subnet=$Script:internalSubnet
        }

    $ScriptBlock_HgsClientConfiguration = {
        Param(
                [hashtable]$param
        )
        . ([ScriptBlock]::Create($Using:FunctionDefs))

        Log-Message -Message "Configuring HGS Client" -Level 2
        Set-HgsClientConfiguration -KeyProtectionServerUrl $param["keyprotectionserverurl"] -AttestationServerUrl $param["attestationserverurl"]
    }

    $Arg_HgsClientConfiguration = @{
            keyprotectionserverurl="http://service.$($Script:hgsDomainName)/KeyProtection";
            attestationserverurl="http://service.$($Script:hgsDomainName)/Attestation"
        }

    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:relecloudAdminCred -ScriptBlock $ScriptBlock_HgsClientConfiguration -ArgumentList $Arg_HgsClientConfiguration 
    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:relecloudAdminCred -ScriptBlock $ScriptBlock_HgsClientConfiguration -ArgumentList $Arg_HgsClientConfiguration

    $VMMDataVHDXPath = Join-Path $Script:basePath -ChildPath "\fabric\$($Script:VmNameVmm)\Virtual Hard Disks\Data.vhdx"
    Cleanup-File -path $VMMDataVHDXPath
    $vmmlibraryvhdx = New-VHD -Dynamic -SizeBytes 50GB -Path $VMMDataVHDXPath | Out-Null

    $driveletter = MountAndInitialize-VHDX $VMMDataVHDXPath -ErrorAction Stop

    Log-Message -Message "Creating library path" -Level 1
    New-Item -Path "$($driveletter):\Library\Virtual Machine Manager Library Files\VHDs" -ItemType Directory

    Log-Message -Message "Copying VMM Shielding Helper Disk to library" -Level 1
    Copy-Item $Script:vhdxVMMShieldingHelperDiskPath -Destination "$($driveletter):\Library\Virtual Machine Manager Library Files\VHDs\VMMShieldingHelperDisk.vhdx"

    Log-Message -Message "Copying Nano Server Disk to library" -Level 1
    Copy-Item $Script:vhdxNanoServerPath -Destination "$($driveletter):\Library\Virtual Machine Manager Library Files\VHDs\WindowsServer2016_ServerDataCenterNano.vhdx"

    Log-Message -Message "Dismounting VHDX" -MessageType Verbose -Level 1
    Dismount-VHD -Path $VMMDataVHDXPath

    Log-Message -Message "Attaching VMM Library disk" -MessageType Verbose -Level 1
    Add-VMHardDiskDrive -VM $vmm01 -Path $VMMDataVHDXPath | Out-Null
    Log-Message -Message "Attaching VMM/WAP dependencies source disk" -MessageType Verbose -Level 1
    Add-VMHardDiskDrive -VM $vmm01 -Path $Script:vhdxVMMWAPDependenciesPath | Out-Null

    $ScriptBlock_AddLocalAdmin = {
            Param(
                [hashtable]$param
            )
            . ([ScriptBlock]::Create($Using:FunctionDefs))
            Log-Message -Message "Adding $($param["domain"])/$($param["domainaccount"]) to local admin group on $($env:COMPUTERNAME)" -Level 2
            ([ADSI]"WinNT://$($env:COMPUTERNAME)/Administrators,group").psbase.Invoke("Add",([ADSI]"WinNT://$($param["domain"])/$($param["domainaccount"])").path)
        }
    
    $Arg_LocalAdmin = @{
            domain="relecloud";
            domainaccount="vmmserviceaccount"
        }

    Invoke-CommandWithPSDirect -VirtualMachine $vmm01 -Credential $Script:relecloudAdminCred -ScriptBlock $ScriptBlock_AddLocalAdmin -ArgumentList $Arg_LocalAdmin
    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:relecloudAdminCred -ScriptBlock $ScriptBlock_AddLocalAdmin -ArgumentList $Arg_LocalAdmin
    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:relecloudAdminCred -ScriptBlock $ScriptBlock_AddLocalAdmin -ArgumentList $Arg_LocalAdmin

    If (Test-Path (Join-Path $Script:sourcePath -ChildPath "Wallpaper\vmm01_wallpaper.jpg"))
    {
        Log-Message -Message "Overwriting default wallpaper image for VMM"
        Invoke-CommandWithPSDirect -VirtualMachine $vmm01 -Credential $Script:relecloudAdminCred -ScriptBlock {
            Rename-Item -Path C:\Windows\Web\Screen -NewName Screen_old -Force | Out-Null
            New-Item -Path C:\Windows\Web\Screen -ItemType Directory | Out-Null

            Rename-Item -Path C:\Windows\Web\Wallpaper\Windows -NewName Windows_old -Force | Out-Null
            New-Item -Path C:\Windows\Web\Wallpaper\Windows -ItemType Directory | Out-Null 
        }
        Copy-ItemToVm -VirtualMachine $vmm01 -Credential $Script:relecloudAdminCred -SourcePath (Join-Path $Script:sourcePath -ChildPath "Wallpaper\vmm01_wallpaper.jpg") -DestinationPath C:\Windows\Web\Wallpaper\Windows\img0.jpg
        Copy-ItemToVm -VirtualMachine $vmm01 -Credential $Script:relecloudAdminCred -SourcePath (Join-Path $Script:sourcePath -ChildPath "Wallpaper\vmm01_lockscreen.jpg") -DestinationPath C:\Windows\Web\Screen\img100.jpg
    }

    Invoke-CommandWithPSDirect -VirtualMachine $vmm01 -Credential $Script:relecloudLarsCred -ScriptBlock {
        Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'Wallpaper' -Value 'C:\Windows\Web\Wallpaper\Windows\img0.jpg'
    }

    Log-Message -Message "Installing VMM Dependencies"
    Invoke-CommandWithPSDirect -VirtualMachine $vmm01 -Credential $Script:relecloudAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            . ([ScriptBlock]::Create($Using:FunctionDefs))
            Log-Message -Message "Bringing offline disks online" -Level 2 -Verbose
            Get-Disk | ? IsOffline | Set-Disk -IsOffline:$false | Set-Disk -IsReadOnly:$false | Out-Null

            Log-Message -Message "Disabling automatic launch of server manager" -Level 2
            Get-ScheduledTask "ServerManager" | Disable-ScheduledTask | Out-Null

            Log-Message -Message "Installing ADK" -Level 2
            $arguments = "/q /features OptionId.DeploymentTools OptionId.WindowsPreinstallationEnvironment"
            Log-Message -Message "Arguments: $arguments" -Level 2
            Start-Process "E:\VMMWAPDependencies\ADK\adksetup.exe" -ArgumentList $arguments.Split(" ") -WorkingDirectory E:\VMMWAPDependencies\ADK -NoNewWindow -Wait
            
            Log-Message -Message "Writing SqlConfigurationFile.ini" -Level 2
            $using:SQLServerSetupConfig | Out-File C:\SqlConfigurationFile.ini

            Log-Message -Message "Installing SQL Server" -Level 2
            $arguments = "/QUIET /CONFIGURATIONFILE=C:\SqlConfigurationFile.ini /ACTION=Install /SQLSYSADMINACCOUNTS=RELECLOUD\lars $($using:IAcceptSqlLicenseTerms)"
            Log-Message -Message "Arguments: $arguments" -Level 2
            Start-Process "E:\VMMWAPDependencies\SQL\setup.exe" -ArgumentList $arguments.Split(" ") -WorkingDirectory E:\VMMWAPDependencies\SQL -NoNewWindow -Wait
        }
    Reboot-VM $vmm01 

    Invoke-CommandWithPSDirect -VirtualMachine $vmm01 -Credential $Script:relecloudAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            . ([ScriptBlock]::Create($Using:FunctionDefs))
            Log-Message -Message "Bringing offline disks online" -Level 2 -Verbose
            Get-Disk | ? IsOffline | Set-Disk -IsOffline:$false | Out-Null
            Get-Disk -Number 1 | Set-Disk -IsReadOnly:$false | Out-Null

            Log-Message -Message "Creating directory C:\config"
            New-Item -Path C:\config -ItemType Directory | Out-Null

            Log-Message -Message "Writing VMServer.ini" -Level 2
            $using:SCVMMSetupConfig | Out-File C:\config\VMServer.ini

            Log-Message -Message "Creating directory D:\Library"
            New-Item -Path D:\Library -ItemType Directory | Out-Null

            Log-Message -Message "Installing Virtual Machine Manager" -Level 2
            $arguments = "/server /i $($using:iacceptsceula) /f C:\config\VMServer.ini /VmmServiceDomain=$($param["domain"]) /VmmServiceUserName=$($param["VmmServiceUserName"]) /VmmServiceUserPassword=$($param["VmmServiceUserPassword"]) /SqlDBAdminDomain=$($param["domain"]) /SqlDBAdminName=$($param["SqlDBAdminName"]) /SqlDBAdminPassword=$($param["SqlDBAdminPassword"])"
            Log-Message -Message "Arguments: $arguments" -Level 2
            Start-Process "E:\VMMWAPDependencies\VMM\setup.exe" -ArgumentList $arguments.Split(" ") -WorkingDirectory E:\VMMWAPDependencies\VMM -NoNewWindow -Wait

            While (Get-Process SetupVMM -ErrorAction SilentlyContinue)
            {
                Write-Host "." -NoNewline
                Start-Sleep -Seconds 5
            }
            Write-Host "done."
            
        } -ArgumentList @{
            domain=$Script:domainName;
            VmmServiceUserName="vmmserviceaccount";
            VmmServiceUserPassword=$Script:clearTextPassword;
            SqlDBAdminName="lars"
            SqlDBAdminPassword=$Script:clearTextPassword
        }



    Get-VMHardDiskDrive -VM $vmm01 -ControllerLocation 2 | Remove-VMHardDiskDrive | Out-Null 
    End-Stage
} 
#######################################################################################
# End of Stage 3 Configure HGS in AD mode, join compute nodes to domain
#######################################################################################

#######################################################################################
# Beginning of Stage 4: Create VMs
#######################################################################################
If ($Script:stage -eq 4 -and $Script:stage -lt $StopBeforeStage)
{
    Begin-Stage

    WaitFor-ActiveDirectory -VirtualMachine $dc01 -Credential $Script:relecloudAdminCred

    Invoke-CommandWithPSDirect -VirtualMachine $vmm01 -Credential $Script:relecloudAdminCred -ScriptBlock {
            Param(
                [hashtable]$param
            )
            . ([ScriptBlock]::Create($Using:FunctionDefs))
            Log-Message -Message "Starting Virtual Machine Manager Service" -Level 1         
            Start-Service SCVMMService | Out-Null

            $cert = New-SelfSignedCertificate -DnsName publisher.relecloud.com -FriendlyName "Relecloud.com Publisher"
            Copy-Item "D:\Library\Virtual Machine Manager Library Files\VHDs\WindowsServer2016_ServerDatacenterNano.vhdx" -Destination "D:\Library\Virtual Machine Manager Library Files\VHDs\WindowsServer2016_ServerDatacenterNano_Shielded.vhdx"
            Protect-TemplateDisk -Path "D:\Library\Virtual Machine Manager Library Files\VHDs\WindowsServer2016_ServerDatacenterNano_Shielded.vhdx" -TemplateName "WindowsServer2016_Nano_Datacenter" -Version 1.0.0.0 -Certificate $cert

            Log-Message -Message "Importing VMM PowerShell Module" -Level 1
            ipmo 'virtualmachinemanager\virtualmachinemanager.psd1' | Out-Null 
            
            $password = (ConvertTo-SecureString -AsPlainText "P@ssw0rd." -Force)
            $credential = New-Object System.Management.Automation.PSCredential ("relecloud\administrator", $password)

            Get-VMMServer -ComputerName vmm01
            Log-Message -Message "Creating new SCVMM RunAs account" -Level 1
            do {
                Write-Host "." -NoNewline
                Start-Sleep -Seconds 2
                $runAsAccount = New-SCRunAsAccount -Credential $credential -Name "RelecloudDomainAdmin" -Description "Relecloud.com Domain Administrator" -JobGroup "4034e803-3871-460e-be99-968f45db861a" -ErrorAction Continue
            } until ($?)
            
            Log-Message -Message "Refreshing Library Share" -Level 1
            Get-LibraryShare | Refresh-LibraryShare | Out-Null 

            Log-Message -Message "Preparing shielding helper vhdx" -Level 1
            $ShieldingHelperVhd = Get-SCVirtualHardDisk -Name "VMMShieldingHelperDisk.vhdx"
            Initialize-VMShieldingHelperVHD -Path $ShieldingHelperVhd.Location | Out-Null
            
            Log-Message -Message "Setting vhdx properties" -Level 1
            # Get Operating System 'Windows Server 2016 Datacenter'
            $os = Get-SCOperatingSystem -ID "0a393d1e-9050-4142-8e55-a86e4a555013"
            Set-SCVirtualHardDisk -VirtualHardDisk $ShieldingHelperVhd -OperatingSystem $os -VirtualizationPlatform "HyperV"

            $NanoShielded = Get-SCVirtualHardDisk -Name "WindowsServer2016_ServerDatacenterNano_Shielded.vhdx"
            Set-SCVirtualHardDisk -VirtualHardDisk $NanoShielded -OperatingSystem $os -VirtualizationPlatform "HyperV"
            $vsc = Get-SCVolumeSignatureCatalog -VirtualHardDisk $NanoShielded
            $vsc.WriteToFile("C:\templateDisk.vsc")

            $Nano = Get-SCVirtualHardDisk -Name "WindowsServer2016_ServerDatacenterNano.vhdx"
            Set-SCVirtualHardDisk -VirtualHardDisk $Nano -OperatingSystem $os -VirtualizationPlatform "HyperV"

            Log-Message -Message "Configuring Host Guardian Service in VMM" -Level 1
            Set-SCVMMServer -AttestationServerUrl "http://service.hgs.relecloud.com/Attestation" -KeyProtectionServerUrl "http://service.hgs.relecloud.com/KeyProtection" -ShieldingHelperVhd $ShieldingHelperVhd | Out-Null 

            # Get Host Group 'All Hosts'
            Log-Message -Message "Adding Compute hosts to All Hosts group" -Level 1
            $hostGroup = Get-SCVMHostGroup -ID "0e3ba228-a059-46be-aa41-2f5cf0f4b96e"
            Add-SCVMHost -ComputerName "compute01.relecloud.com" -VMHostGroup $hostGroup -Credential $runAsAccount | Out-Null 
            Add-SCVMHost -ComputerName "compute02.relecloud.com"  -VMHostGroup $hostGroup -Credential $runAsAccount | Out-Null

            Log-Message -Message "Configuring Cloud Capacity" -Level 1
            Set-SCCloudCapacity -JobGroup "6990267b-995f-4328-8833-f09200a9308b" -UseCustomQuotaCountMaximum $true -UseMemoryMBMaximum $true -UseCPUCountMaximum $true -UseStorageGBMaximum $true -UseVMCountMaximum $true

            Log-Message -Message "Configuring Cloud Capability Profile" -Level 1
            $addCapabilityProfiles = @()
            $addCapabilityProfiles += Get-SCCapabilityProfile -Name "Hyper-V"

            Set-SCCloud -JobGroup "6990267b-995f-4328-8833-f09200a9308b" -RunAsynchronously -ReadWriteLibraryPath "\\VMM01.relecloud.com\MSSCVMMLibrary\VHDs" -AddCapabilityProfile $addCapabilityProfiles

            Log-Message -Message "Adding All Hosts to new Cloud" -Level 1
            $hostGroups = @()
            $hostGroups += $hostGroup
            New-SCCloud -JobGroup "6990267b-995f-4328-8833-f09200a9308b" -VMHostGroup $hostGroups -Name "Guarded Fabric" -Description "" -ShieldedVMSupportPolicy "ShieldedVMSupported" # -RunAsynchronously

            Log-Message -Message "Creating new VM template" -Level 1

            New-SCVirtualScsiAdapter -VMMServer localhost -JobGroup c511e949-2bf1-4c58-a990-252324afa8ec -AdapterID 7 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 
            New-SCVirtualDVDDrive -VMMServer localhost -JobGroup c511e949-2bf1-4c58-a990-252324afa8ec -Bus 0 -LUN 1 
            New-SCVirtualNetworkAdapter -VMMServer localhost -JobGroup c511e949-2bf1-4c58-a990-252324afa8ec -MACAddressType Dynamic -Synthetic -IPv4AddressType Dynamic -IPv6AddressType Dynamic 
            $CPUType = Get-SCCPUType -VMMServer localhost | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}
            $CapabilityProfile = Get-SCCapabilityProfile -VMMServer localhost | where {$_.Name -eq "Hyper-V"}
            New-SCHardwareProfile -VMMServer localhost -CPUType $CPUType -Name "Profileff689b1e-a025-4ff4-a778-31252d1f9aeb" -Description "Profile used to create a VM/Template" -CPUCount 1 -MemoryMB 1024 -DynamicMemoryEnabled $false -MemoryWeight 5000 -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NumaIsolationRequired $false -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $false -DRProtectionRequired $false -SecureBootEnabled $true -SecureBootTemplate "MicrosoftWindows" -CPULimitFunctionality $false -CPULimitForMigration $false -CheckpointType Production -CapabilityProfile $CapabilityProfile -Generation 2 -JobGroup c511e949-2bf1-4c58-a990-252324afa8ec 

            $VirtualHardDisk = Get-SCVirtualHardDisk -VMMServer localhost | where {$_.Location -eq "\\VMM01.relecloud.com\MSSCVMMLibrary\VHDs\WindowsServer2016_ServerDataCenterNano.vhdx"} | where {$_.HostName -eq "VMM01.relecloud.com"}
            New-SCVirtualDiskDrive -VMMServer localhost -SCSI -Bus 0 -LUN 0 -JobGroup be58f46f-a495-42ef-8841-afc8586da01e -CreateDiffDisk $false -VirtualHardDisk $VirtualHardDisk -VolumeType BootAndSystem 
            $HardwareProfile = Get-SCHardwareProfile -VMMServer localhost | where {$_.Name -eq "Profileff689b1e-a025-4ff4-a778-31252d1f9aeb"}
            $template = New-SCVMTemplate -Name "Windows Server 2016 Nano Server" -Generation 2 -HardwareProfile $HardwareProfile -JobGroup be58f46f-a495-42ef-8841-afc8586da01e -NoCustomization # -RunAsynchronously

        } -ArgumentList @{
            domainuser="relecloud\administrator"
            adminpassword=$Script:passwordSecureString
        }

    Invoke-CommandWithPSDirect -VirtualMachine $compute02 -Credential $Script:relecloudAdminCred -ScriptBlock {
        
        New-Item -Path C:\attestation -ItemType Directory

        Log-Message -Message "Getting baseline" -Level 1
        Get-HgsAttestationBaselinePolicy -Path C:\attestation\baseline.tcglog -SkipValidation

        Log-Message -Message "Getting system identifiere" -Level 1
        (Get-PlatformIdentifier -Name $env:COMPUTERNAME).InnerXml | Out-File "C:\attestation\$($env:COMPUTERNAME)-TPM.xml"

        Log-Message -Message "Creating new CI Policy" -Level 1
        New-CIPolicy -FilePath C:\attestation\CIPolicy.xml -Level FilePublisher -Fallback Hash -UserPEs

        Log-Message -Message "Converting to binary CI policy" -Level 1
        ConvertFrom-CIPolicy -XmlFilePath C:\attestation\CIPolicy.xml -BinaryFilePath C:\attestation\SIPolicy.p7b

        Log-Message -Message "Copying files" -Level 1
        copy C:\attestation\SIPolicy.p7b C:\Windows\System32\CodeIntegrity\SIPolicy.p7b
        copy C:\attestation\baseline.tcglog \\dc01\Attestation
        copy C:\attestation\*-TPM.xml \\dc01\Attestation
        copy C:\attestation\SIPolicy.p7b \\dc01\attestation
    }

    Invoke-CommandWithPSDirect -VirtualMachine $compute01 -Credential $Script:relecloudAdminCred -ScriptBlock {
        
        New-Item -Path C:\attestationprep -ItemType Directory
        New-Item -Path C:\attestation -ItemType Directory

        Log-Message -Message "Getting system identifiere" -Level 1
        (Get-PlatformIdentifier -Name $env:COMPUTERNAME).InnerXml | Out-File "C:\attestationprep\$($env:COMPUTERNAME)-TPM.xml"

        Log-Message -Message "Copying files" -Level 1
        copy C:\attestationprep\*-TPM.xml \\dc01\Attestation        
    }

    End-Stage
} 

#######################################################################################
# End of Stage 4: Create VMs
#######################################################################################

#######################################################################################
# Beginning of Stage 5: Demo
#######################################################################################
If ($Script:stage -eq 5 -and $Script:stage -lt $StopBeforeStage)
{
    Begin-Stage
    WaitFor-ActiveDirectory -VirtualMachine $dc01 -Credential $Script:relecloudAdminCred

   Invoke-CommandWithPSDirect -VirtualMachine $vmm01 -Credential $Script:relecloudAdminCred -ScriptBlock {
            . ([ScriptBlock]::Create($Using:FunctionDefs))
            Log-Message -Message "Starting Virtual Machine Manager Service" -Level 1         
            Start-Service SCVMMService | Out-Null
        }
}

Log-Message -Message "Script finished - Total Duration: $(((Get-Date) - $Script:ScriptStartTime))"