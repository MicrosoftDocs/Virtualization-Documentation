# Parameters
$workingDir = "D:\MVP-DCBuild"
$BaseVHDPath = "$($workingDir)\BaseVHDs"
$VMPath = "$($workingDir)\VMs"
$Organization = "The Power Elite"
$Owner = "Ben Armstrong"
$Timezone = "Pacific Standard Time"
$adminPassword = "P@ssw0rd"
$domainName = "HyperV6.Bear"
$domainAdminPassword = "P@ssw0rd"
$virtualSwitchName = "Bens MVP Demo"
$subnet = "10.130.10."

$localCred = new-object -typename System.Management.Automation.PSCredential `
             -argumentlist "Administrator", (ConvertTo-SecureString $adminPassword -AsPlainText -Force)
$domainCred = new-object -typename System.Management.Automation.PSCredential `
              -argumentlist "$($domainName)\Administrator", (ConvertTo-SecureString $domainAdminPassword -AsPlainText -Force)
$benjaminCred = new-object -typename System.Management.Automation.PSCredential `
              -argumentlist "$($domainName)\Benjamin", (ConvertTo-SecureString $domainAdminPassword -AsPlainText -Force)
$ServerISO = "D:\14393.0.160715-1616.RS1_RELEASE_SERVER_OEMRET_X64FRE_EN-US.ISO"

$WindowsServerKey = "..."

$FunctionDefs = "function SetAutoLogon { ${function:SetAutoLogon} }; function PrepVM { ${function:PrepVM} }; function ConfigureVM { ${function:ConfigureVM} };function cleanupFile { ${function:cleanupFile} }; function logger { ${function:logger} }; `
                 function waitForPSDirect { ${function:waitForPSDirect} }; function waitForVMStop { ${function:waitForVMStop} }; function rebootVM { ${function:rebootVM} } ; function MountVHDandRunBlock { ${function:MountVHDandRunBlock} }    "

### Sysprep unattend XML
$unattendSource = [xml]@"
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <servicing></servicing>
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <ComputerName>*</ComputerName>
            <ProductKey>Key</ProductKey> 
            <RegisteredOrganization>Organization</RegisteredOrganization>
            <RegisteredOwner>Owner</RegisteredOwner>
            <TimeZone>TZ</TimeZone>
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
                    <Value>password</Value>
                    <PlainText>True</PlainText>
                </AdministratorPassword>
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

function waitForPSDirect([string]$VMName, $cred){
   logger $VMName "Waiting for PowerShell Direct (using $($cred.username))"
   while ((icm -VMName $VMName -Credential $cred {"Test"} -ea SilentlyContinue) -ne "Test") {Sleep -Seconds 1}}

function waitForVMStop([PSObject]$VM){

       $test = $false

while (!($test)) {
if ((get-vm $vm.VMName).State -eq "Off") 
     {Start-Sleep -Seconds 1
      if ((get-vm $vm.VMName).State -eq "Off") 
          {$test = $true}
          }
          }
          }

function rebootVM([string]$VMName){logger $VMName "Rebooting"; stop-vm $VMName; start-vm $VMName}

# Helper function to make sure that needed folders are present
function checkPath
{
    param
    (
        [string] $path
    )
    if (!(Test-Path $path)) 
    {
        $null = md $path;
    }
}

function Logger {
    param
    (
        [string]$systemName,
        [string]$message
    );

    # Function for displaying formatted log messages.  Also displays time in minutes since the script was started
    write-host (Get-Date).ToShortTimeString() -ForegroundColor Cyan -NoNewline;
    write-host " - [" -ForegroundColor White -NoNewline;
    write-host $systemName -ForegroundColor Yellow -NoNewline;
    write-Host "]::$($message)" -ForegroundColor White;
}

# Helper function for no error file cleanup
function cleanupFile
{
    param
    (
        [string] $file
    )
    
    if (Test-Path $file) 
    {
        Remove-Item $file -Recurse -Force > $null;
    }
}

function GetUnattendChunk 
{
    param
    (
        [string] $pass, 
        [string] $component, 
        [xml] $unattend
    ); 
    
    # Helper function that returns one component chunk from the Unattend XML data structure
    return $Unattend.unattend.settings | ? pass -eq $pass `
        | select -ExpandProperty component `
        | ? name -eq $component;
}

function makeUnattendFile 
{
    param
    (
        [string] $filePath
    ); 

    # Composes unattend file and writes it to the specified filepath
     
    # Reload template - clone is necessary as PowerShell thinks this is a "complex" object
    $unattend = $unattendSource.Clone();
     
    # Customize unattend XML
    GetUnattendChunk "specialize" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.RegisteredOrganization = $Organization};
    GetUnattendChunk "specialize" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.RegisteredOwner = $Owner};
    GetUnattendChunk "specialize" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.TimeZone = $Timezone};
    GetUnattendChunk "oobeSystem" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.UserAccounts.AdministratorPassword.Value = $adminPassword};
    GetUnattendChunk "specialize" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.ProductKey = $WindowsServerKey};

    # Write it out to disk
    cleanupFile $filePath; $unattend.Save($filePath);
}

function MountVHDandRunBlock 
{
    param
    (
        [string]$vhd, 
        [scriptblock]$block,
        [switch]$ReadOnly
    );
     
    # This function mounts a VHD, runs a script block and unmounts the VHD.
    # Drive letter of the mounted VHD is stored in $driveLetter - can be used by script blocks
    if($ReadOnly) {
        $driveLetter = (Mount-VHD $vhd -ReadOnly -Passthru | Get-Disk | Get-Partition | Get-Volume).DriveLetter;
    } else {
        $driveLetter = (Mount-VHD $vhd -Passthru | Get-Disk | Get-Partition | Get-Volume).DriveLetter;
    }
    & $block;

    Dismount-VHD $vhd;

    # Wait 2 seconds for activity to clean up
    Start-Sleep -Seconds 2;
}

function startEnvironment
{
start-vm "Domain Controller"
waitForPSDirect "Domain Controller" $domainCred

start-vm "Fileserver"
waitForPSDirect "FileServer" $domainCred

icm -VMName "Domain Controller" -Credential $domainCred {do {sleep -Seconds 1} until (test-path "\\sofs-fs\vhdx")}

foreach ($vm in $vms) {start-vm $VM.VMName}
}

function stopEnvironment
{
    foreach ($vm in $vms) {
        if ($vm.VMName -ne "Domain Controller") 
            { 
            if ($vm.VMName -ne "Fileserver") 
                { get-vm | ? Name -eq $VM.VMName | stop-vm -Force}}}

    stop-vm "Fileserver" -Force
    stop-vm "Domain Controller" -Force
}

Function SetAutoLogon{
    Param(
        [String] $DefaultUsername,
        [String] $DefaultPassword,
        [String] $AutoLogonCount,
        [String] $Script        
            )

    #Registry path declaration
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    $RegROPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
    
    #setting registry values
    Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String  
    Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String  
    Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String
    if($AutoLogonCount)
        {Set-ItemProperty $RegPath "AutoLogonCount" -Value "$AutoLogonCount" -type DWord}
    else
        {Set-ItemProperty $RegPath "AutoLogonCount" -Value "1" -type DWord}
    if($Script)
        {Set-ItemProperty $RegROPath "(Default)" -Value "$Script" -type String}
    else
        {Set-ItemProperty $RegROPath "(Default)" -Value "" -type String}        
    }

# Build base VHDs

Function BuildBaseImages {

   Mount-DiskImage $ServerISO
   $DVDDriveLetter = (Get-DiskImage $ServerISO | Get-Volume).DriveLetter
   Copy-Item "$($DVDDriveLetter):\NanoServer\NanoServerImageGenerator\Convert-WindowsImage.ps1" "$($workingDir)\Convert-WindowsImage.ps1" -Force
   . "$workingDir\Convert-WindowsImage.ps1"
   Import-Module "$($DVDDriveLetter):\NanoServer\NanoServerImageGenerator\NanoServerImageGenerator.psm1" -Force

   makeUnattendFile "$($BaseVHDPath)\unattend.xml"

    if (!(Test-Path "$($BaseVHDPath)\NanoBase.vhdx")) 
    {
    New-NanoServerImage -MediaPath "$($DVDDriveLetter):\" -BasePath $BaseVHDPath -TargetPath "$($BaseVHDPath)\NanoBase.vhdx" -DeploymentType Guest -Containers -Edition Datacenter -Compute -Clustering -AdministratorPassword (ConvertTo-SecureString $adminPassword -AsPlainText -Force)
    }

    if (!(Test-Path "$($BaseVHDPath)\VMServerBaseCore.vhdx")) 
    {
        Convert-WindowsImage -SourcePath "$($DVDDriveLetter):\sources\install.wim" -VHDPath "$($BaseVHDPath)\VMServerBaseCore.vhdx" `
                     -SizeBytes 500GB -VHDFormat VHDX -UnattendPath "$($BaseVHDPath)\unattend.xml" `
                     -Edition "ServerDataCenterCore" -DiskLayout UEFI -Package "D:\Windows10.0-KB3192366-x64.msu"
    }

    if (!(Test-Path "$($BaseVHDPath)\VMServerBase.vhdx")) 
    {
        Convert-WindowsImage -SourcePath "$($DVDDriveLetter):\sources\install.wim" -VHDPath "$($BaseVHDPath)\VMServerBase.vhdx" `
                     -SizeBytes 500GB -VHDFormat VHDX -UnattendPath "$($BaseVHDPath)\unattend.xml" `
                     -Edition "ServerDataCenter" -DiskLayout UEFI -Package "D:\Windows10.0-KB3192366-x64.msu"
    }

        if (!(Test-Path "$($BaseVHDPath)\VMServerBaseGen1.vhdx")) 
    {
        Convert-WindowsImage -SourcePath "$($DVDDriveLetter):\sources\install.wim" -VHDPath "$($BaseVHDPath)\VMServerBaseGen1.vhdx" `
                     -SizeBytes 500GB -VHDFormat VHDX -UnattendPath "$($BaseVHDPath)\unattend.xml" `
                     -Edition "ServerDataCenter" -DiskLayout BIOS -Package "D:\Windows10.0-KB3192366-x64.msu"

    }

    cleanupFile "$($BaseVHDPath)\unattend.xml"
    Dismount-DiskImage $ServerISO 
    # cleanupFile "$($workingDir)\Convert-WindowsImage.ps1"
}

function DeleteVM {
    param
    (
        [PSObject] $VM
    ); 

   logger $VM.VMName "Removing old VM"
   get-vm $VM.VMName -ErrorAction SilentlyContinue | stop-vm -TurnOff -Force -Passthru | remove-vm -Force
   cleanupFile "$($VMPath)\$($VM.GuestOSName).vhdx"
   cleanupFile "$($VMPath)\$($VM.GuestOSName) - REFS.vhdx"
   cleanupFile "$($VMPath)\$($VM.GuestOSName) - NTFS.vhdx"
   }

function RestoreVMCheckpoint {
    param
    (
        [PSObject] $VM,
        [string] $CheckpointName
    ); 

   logger $VM.VMName "Restoring checkpoint `"$($CheckpointName)`""
   get-vm $VM.VMName -ErrorAction SilentlyContinue | stop-vm -TurnOff -Force -Passthru | Restore-VMSnapshot -Name $CheckpointName -Confirm:$false
   if (test-path "$($VMPath)\$($VM.GuestOSName) - REFS.vhdx") {Add-VMHardDiskDrive -VMName $VM.VMName -Path "$($VMPath)\$($VM.GuestOSName) - REFS.vhdx"}
   if (test-path "$($VMPath)\$($VM.GuestOSName) - NTFS.vhdx") {Add-VMHardDiskDrive -VMName $VM.VMName -Path "$($VMPath)\$($VM.GuestOSName) - NTFS.vhdx"}
   }

function createVMCheckpoint {
    param
    (
        [PSObject] $VM,
        [string] $CheckpointName
    ); 

   logger $VM.VMName "Creating checkpoint `"$($CheckpointName)`""
   Remove-VMSnapshot -VMName $VM.VMName -Name $CheckpointName -IncludeAllChildSnapshots -Confirm:$false
   Get-VMHardDiskDrive -VMName $VM.VMName | ? Path -eq "$($VMPath)\$($VM.GuestOSName) - REFS.vhdx" | Remove-VMHardDiskDrive
   Get-VMHardDiskDrive -VMName $VM.VMName | ? Path -eq "$($VMPath)\$($VM.GuestOSName) - NTFS.vhdx" | Remove-VMHardDiskDrive
   do {checkpoint-vm -VMName $VM.VMName -SnapshotName $CheckpointName} until ($?)
   if (test-path "$($VMPath)\$($VM.GuestOSName) - REFS.vhdx") {Add-VMHardDiskDrive -VMName $VM.VMName -Path "$($VMPath)\$($VM.GuestOSName) - REFS.vhdx"}
   if (test-path "$($VMPath)\$($VM.GuestOSName) - NTFS.vhdx") {Add-VMHardDiskDrive -VMName $VM.VMName -Path "$($VMPath)\$($VM.GuestOSName) - NTFS.vhdx"}

   }

function PrepNestedVM {
    param
    (
        [PSObject] $VM
    );


        icm -VMName $VM.HVHost -Credential $domainCred {
             . ([ScriptBlock]::Create($Using:FunctionDefs))
             $VirtualSwitchName = $Using:virtualSwitchName
             $VMPath = "\\sofs-fs\VHDX\VMs"
             $BaseVHDPath = "\\sofs-fs\VHDX\Base"

             PrepVM($Using:VM)

         }
}

function ConfigureNestedVM {
    param
    (
        [PSObject] $VM
    );


        icm -VMName $VM.HVHost -Credential $domainCred {
             . ([ScriptBlock]::Create($Using:FunctionDefs))
             $VirtualSwitchName = $Using:virtualSwitchName
             $domainName = $Using:domainName
             $subnet = $Using:subnet
             $localCred = $Using:localCred
             $domainCred = $Using:domainCred
             $domainAdminPassword = $Using:domainAdminPassword
             $benjaminCred = $Using:benjaminCred
             $VMPath = "\\sofs-fs\VHDX\VMs"
             $BaseVHDPath = "\\sofs-fs\VHDX\Base"
             $VM = $Using:VM
             $VMs = $Using:VMs
             $FunctionDefs = $Using:FunctionDefs

             ConfigureVM($VM)

         }
}

function PrepVM {

    param
    (
        [PSObject] $VM
    ); 

   # Make new VM
   logger $VM.VMName "Creating new differencing disk"

   $Gen = 2

   switch ($VM.OSType)
      {
        "DatacenterCore" {$BaseVHD = "$($BaseVHDPath)\VMServerBaseCore.vhdx"}
        "Datacenter" {$BaseVHD = "$($BaseVHDPath)\VMServerBase.vhdx"}
        "Gen1" {$BaseVHD = "$($BaseVHDPath)\VMServerBaseGen1.vhdx" ; $Gen = 1}
        "Nano" {$BaseVHD = "$($BaseVHDPath)\NanoBase.vhdx"}
        default {$BaseVHD = "$($BaseVHDPath)\VMServerBaseCore.vhdx"}
      }

   if ($VM.CustomBaseVHD -ne $null) {$BaseVHD = $VM.CustomBaseVHD}

   New-VHD -Path "$($VMPath)\$($VM.GuestOSName).vhdx" -ParentPath $BaseVHD -Differencing | Out-Null

      if ($VM.Wallpaper -ne $null) {
         MountVHDandRunBlock "$($VMPath)\$($VM.GuestOSName).vhdx" {

            Rename-Item "$($driveLetter):\Windows\Web\Screen" "$($driveLetter):\Windows\Web\Screen-old"
            md "$($driveLetter):\Windows\Web\Screen"
            Copy-Item $VM.Wallpaper -Destination "$($driveLetter):\Windows\Web\Screen\img100.jpg" -Force
            }
         }

    if ($VM.VMName -eq "Fileserver") {
             MountVHDandRunBlock "$($VMPath)\$($VM.GuestOSName).vhdx" {
                     md "$($driveLetter):\BaseVHDs"
                     copy-item "$($BaseVHDPath)\*.*" -Destination "$($driveLetter):\BaseVHDs"
                     copy-item "$($workingDir)\Bits" -Destination "$($driveLetter):\" -Recurse
                     }
         }

   logger $VM.VMName "Creating virtual machine"
   new-vm -Name $VM.VMName -MemoryStartupBytes $VM.Memory -SwitchName $VirtualSwitchName `
          -VHDPath "$($VMPath)\$($VM.GuestOSName).vhdx" -Generation $Gen  | Set-VM -ProcessorCount 2
   Set-VMMemory -VMName $VM.VMName -DynamicMemoryEnabled $false
   Set-VM -VMName $VM.VMName -AutomaticStopAction ShutDown
   if ($VM.EnableNesting) {
      Add-VMNetworkAdapter -VMName $VM.VMName -SwitchName $VirtualSwitchName
      Get-VMNetworkAdapter -VMName $VM.VMName | Set-VMNetworkAdapter -MacAddressSpoofing on
      Set-VMProcessor -VMName $VM.VMName -ExposeVirtualizationExtensions $true}
   if ($VM.Roles.contains("Bitlocker")) {
      Set-VMKeyProtector -VMName $VM.VMName -NewLocalKeyProtector
            if ($VM.OSType -eq "Gen1")
               {Add-VMKeyStorageDrive -VMName $VM.VMName}
               else {enable-vmtpm -VMName $VM.VMName}
      }
   if ($VM.Headless) {Disable-VMConsoleSupport -VMName $VM.VMName}
   if ($VM.OSType -eq "Linux") {
      Set-VMFirmware -VMName $VM.VMName -SecureBootTemplate "MicrosoftUEFICertificateAuthority"
      set-vm -VMName $VM.VMName -CheckpointType Standard
      }
   logger $VM.VMName "Starting virtual machine"
   do {start-vm $VM.VMName} until ($?)
   }

function ConfigureVM{

    param
    (
        [PSObject] $VM
    ); 

   if ($VM.OSType -ne "Linux") {

   waitForPSDirect $VM.VMName -cred $localCred

   # Set IP address & name
   icm -VMName $VM.VMName -Credential $localCred {
      if ($using:VM.IPAddress -ne $null) {
         Write-Output "[$($using:VM.VMName)]:: Setting IP Address to $($using:VM.IPAddress)"
         New-NetIPAddress -IPAddress $using:VM.IPAddress -InterfaceAlias "Ethernet" -PrefixLength 24 | Out-Null
         Write-Output "[$($using:VM.VMName)]:: Setting DNS Address"
         Get-DnsClientServerAddress | %{Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex `
                                                                -ServerAddresses "$(($using:vms | ?{$_.VMName -eq "Domain Controller"}).IPAddress)"}}
      Write-Output "[$($using:VM.VMName)]:: Renaming OS to `"$($using:VM.GuestOSName)`""
      Rename-Computer $using:VM.GuestOSName
      # Enable necessary roles
      if ($using:VM.OSType -ne "Nano") {
          if (($using:VM).Roles.contains("Hyper-V")) {
             Write-Output "[$($using:VM.VMName)]:: Enabling Hyper-V"
             Install-WindowsFeature RSAT-Hyper-V-Tools | out-null
             dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All /NoRestart | out-null}
          if (($using:VM).Roles.contains("Clustering")) {
             Write-Output "[$($using:VM.VMName)]:: Enabling Clustering"
             Install-WindowsFeature Failover-Clustering -IncludeManagementTools | out-null}
          if (($using:VM).Roles.contains("DomainController")) {
             Write-Output "[$($using:VM.VMName)]:: Enabling iSCSI, AD and DHCP"
             Add-WindowsFeature -Name FS-iSCSITarget-Server | out-null
             Install-WindowsFeature AD-Domain-Services, DHCP -IncludeManagementTools | out-null}
          if (($using:VM).Roles.contains("SOFS")) {
             Write-Output "[$($using:VM.VMName)]:: Enabling file services"
             Install-WindowsFeature File-Services, FS-FileServer -IncludeManagementTools | Out-Null}
          if (($using:VM).Roles.contains("Management")) {
             Write-Output "[$($using:VM.VMName)]:: Enabling Management Tools"
             Add-WindowsFeature "RSAT-Clustering", "RSAT-AD-Tools", "RSAT-Hyper-V-Tools", "RSAT-DHCP", `
                                "RSAT-DNS-Server", "RSAT-File-Services" -IncludeAllSubFeature | out-null}
          if (($using:VM).Roles.contains("Bitlocker")) {
             Write-Output "[$($using:VM.VMName)]:: Enabling Bitlocker"
             Add-WindowsFeature "BitLocker" | out-null

             }
         }
      # For Server core - set the shell to be the RunOnce tool.  Set the back at the end of the script.
      if ($using:VM.OSType -eq "DatacenterCore") 
           { Set-ItemProperty "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\WinLogon" Shell 'runonce.exe /AlternateShellStartup'}



      # Configure WinRM trusts
      Write-Output "[$($using:VM.VMName)]:: Configuring WSMAN Trusted hosts"
      Set-Item WSMan:\localhost\Client\TrustedHosts "*.$($using:domainname)" -Force
      Set-Item WSMan:\localhost\client\trustedhosts "$($using:subnet)*" -force -concatenate
      }

   if ($VM.DomainJoined) {
      # Reboot
      rebootVM $VM.VMName; waitForPSDirect $VM.VMName -cred $localCred

      if ($VM.OSType -ne "Nano") {
          icm -VMName $VM.VMName -Credential $localCred {
             Write-Output "[$($using:VM.VMName)]:: Joining domain as `"$($env:computername)`""
             while (!(Test-Connection -Computername "$(($using:vms | ?{$_.VMName -eq "Domain Controller"}).IPAddress)" -BufferSize 16 -Count 1 -Quiet -ea SilentlyContinue)) {sleep -seconds 1; iex "ipconfig /renew"}
             do {Add-Computer -DomainName $using:domainName -Credential $using:domainCred -ea SilentlyContinue} until ($?)
             }
         }
      else {

      icm -VMName "Domain Controller" -Credential $domainCred {
                    djoin.exe /provision /domain "$($using:domainName)" /machine "$($using:VM.GuestOSName)" /savefile "C:\$($using:VM.GuestOSName).txt"} 

      icm -VMName $VM.VMName -Credential $localCred {
            djoin /requestodj /loadfile "\\$(($using:vms | ?{$_.VMName -eq "Domain Controller"}).IPAddress)\c$\$($using:VM.GuestOSName).txt" /windowspath c:\windows /localos
            del "\\$(($using:vms | ?{$_.VMName -eq "Domain Controller"}).IPAddress)\c$\$($using:VM.GuestOSName).txt"}
         }

      # Reboot
      rebootVM $VM.VMName; waitForPSDirect $VM.VMName -cred $domainCred
      }
      else {
      # Reboot
      rebootVM $VM.VMName; waitForPSDirect $VM.VMName -cred $localCred}

   # Login once as key user accounts - TODO - BIG FIX!!

      if ($VM.DomainJoined -or $VM.Roles.contains("DomainController")) 
       {
       waitForPSDirect $VM.VMName -cred $domainCred;

       # Login once as each user to setup profiles

       if (($VM.OSType -eq "Gen1") -or ($VM.OSType -eq "Datacenter") -or ($VM.OSType -eq "DatacenterCore")){

           icm -VMName $VM.VMName -Credential $domainCred {
               . ([ScriptBlock]::Create($Using:FunctionDefs))
               SetAutoLogon "$($using:domainName)\Administrator" $using:domainAdminPassword "1" "C:\windows\System32\WindowsPowerShell\v1.0\powershell.exe -command `"& {while (1) {Stop-Computer -force}}`""
               Restart-Computer -Force
               }
        
           waitForVMStop $VM
           Start-vm $VM.VMName; waitForPSDirect $VM.VMName -cred $domainCred

           if (!($VM.Roles.contains("DomainController"))) {
               icm -VMName $VM.VMName -Credential $domainCred {
                   . ([ScriptBlock]::Create($Using:FunctionDefs))
                   SetAutoLogon "$($using:domainName)\Benjamin" $using:domainAdminPassword "1" "C:\windows\System32\WindowsPowerShell\v1.0\powershell.exe -command `"& {while (`$true) {Stop-Computer -force}}`""
                   Restart-Computer -Force
                   }

           waitForVMStop $VM 
           Start-vm $VM.VMName; waitForPSDirect $VM.VMName -cred $domainCred}

           if ($VM.OSType -eq "DatacenterCore") {
           icm -VMName $VM.VMName -Credential $domainCred {
                    Set-ItemProperty "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\WinLogon" Shell 'PowerShell.exe -WindowStyle maximized'
                    $profile = "$($env:userprofile)\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
                    New-Item -path $profile -type file -force

                    "(Get-Host).UI.RawUI.ForegroundColor = `"$($Using:VM.PowerShellTextColor)`"" | out-file $profile
                    "(Get-Host).UI.RawUI.BackgroundColor = `"$($Using:VM.PowerShellBackColor)`"" | out-file -append $profile
                    "cd \" | out-file -append $profile
                    "cls" | out-file -append $profile
                    "write-host Welcome to $env:computername" | out-file -append $profile
                    "write-host" | out-file -append $profile}
                    
            if (!($VM.Roles.contains("DomainController"))) {
                      icm -VMName $VM.VMName -Credential $benjaminCred {
                                        $profile = "$($env:userprofile)\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
                    New-Item -path $profile -type file -force

                    "(Get-Host).UI.RawUI.ForegroundColor = `"Green`"" | out-file $profile
                    "(Get-Host).UI.RawUI.BackgroundColor = `"Black`"" | out-file -append $profile
                    "cd \" | out-file -append $profile
                    "cls" | out-file -append $profile
                    "write-host Welcome to $env:computername" | out-file -append $profile
                    "write-host" | out-file -append $profile}
                    }

           }

           else {
           icm -VMName $VM.VMName -Credential $domainCred {Set-ItemProperty 'HKCU:\Control Panel\Desktop' 'Wallpaper' -value 'c:\Windows\Web\Screen\img100.jpg'
                                                           Get-ScheduledTask "ServerManager" | Disable-ScheduledTask}
           if (!($VM.Roles.contains("DomainController"))) {
               icm -VMName $VM.VMName -Credential $benjaminCred {Set-ItemProperty 'HKCU:\Control Panel\Desktop' 'Wallpaper' -value 'c:\Windows\Web\Screen\img100.jpg'}}
           }

           }
   
       }
   else {rebootVM $VM.VMName; waitForPSDirect $VM.VMName -cred $localCred}

   # Setup domain controller
   if ($VM.Roles.contains("DomainController")) {
      # Reboot
      icm -VMName $VM.VMName -Credential $localCred {
         Write-Output "[$($using:VM.VMName)]:: Configuring DHCP Server"    
         Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias Ethernet
         Add-DhcpServerv4Scope -Name "IPv4 Network" -StartRange "$($using:subnet)20" -EndRange "$($using:subnet)200" -SubnetMask 255.255.255.0
         Write-Output "[$($using:VM.VMName)]:: Installing Active Directory and promoting to domain controller"
         Install-ADDSForest -DomainName $using:domainname -InstallDNS -NoDNSonNetwork -NoRebootOnCompletion `
                            -SafeModeAdministratorPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -confirm:$false
                            }

      # Reboot
      rebootVM $VM.VMName; waitForPSDirect $VM.VMName -cred $domainCred

      icm -VMName $VM.VMName -Credential $domainCred {
         Write-Output "[$($using:VM.VMName)]:: Creating VHDXs for iSCSI targets"
         New-IscsiVirtualDisk C:\iSCSITargetDisks\Quorum.vhdx -Size 10GB | Out-Null
         New-IscsiVirtualDisk C:\iSCSITargetDisks\Data.vhdx -Size 500GB | Out-Null
         Write-Output "[$($using:VM.VMName)]:: Creating iSCSI targets"
         New-IscsiServerTarget ISCSIQuorum -InitiatorIds "Iqn:iqn.1991-05.com.microsoft:FileServer.$($using:domainname)" | Out-Null
         New-IscsiServerTarget ISCSIData -InitiatorIds "Iqn:iqn.1991-05.com.microsoft:FileServer.$($using:domainname)" | Out-Null
         Write-Output "[$($using:VM.VMName)]:: Mapping VHDX files to iSCSI targets"
         Add-IscsiVirtualDiskTargetMapping ISCSIQuorum C:\iSCSITargetDisks\Quorum.vhdx -lun 0 
         Add-IscsiVirtualDiskTargetMapping ISCSIData C:\iSCSITargetDisks\Data.vhdx -lun 0
         Write-Output "[$($using:VM.VMName)]:: Setting DNS option on DHCP server"
         Set-DhcpServerV4OptionValue -DnsDomain $using:domainname -DnsServer "$(($using:vms | ?{$_.VMName -eq "Domain Controller"}).IPAddress)"
         Write-Output "[$($using:VM.VMName)]:: Configuring MAC address reservations on DHCP server"
         Set-DhcpServerv4OptionValue -OptionId 6 -value "$($Using:subnet)1"
         foreach($i in 1..99) {
         $mac = "00-b5-5d-fe-f6-" + ($i % 100).ToString("00")
         $ip = $using:subnet + "1" + ($i % 100).ToString("00")
         $desc = "Container " + $i.ToString()
         $scopeID = $Using:subnet + "0"
         Add-DhcpServerv4Reservation -IPAddress $ip -ClientId $mac -Description $desc -ScopeId $scopeID}
         } 

      # Reboot
      rebootVM $VM.VMName; waitForPSDirect $VM.VMName -cred $domainCred

      icm -VMName $VM.VMName -Credential $domainCred {
         
         Import-Module ActiveDirectory
         do {start-sleep 1; New-PSDrive -Name AD -PSProvider ActiveDirectory -Server $using:domainname -Root "" -ea 0} until ($?)


         Write-Output "[$($using:VM.VMName)]:: Registering DHCP with AD"
         do {sleep 5
             Add-DhcpServerInDC -ea 0} until ($?)
         
         Write-Output "[$($Using:VM.VMName)]:: Creating user account for Benjamin"
         do {start-sleep 5; write-host . -NoNewline; New-ADUser `
            -Name "Benjamin" `
            -SamAccountName  "Benjamin" `
            -DisplayName "Benjamin" `
            -AccountPassword (ConvertTo-SecureString $Using:domainAdminPassword -AsPlainText -Force) `
            -ChangePasswordAtLogon $false  `
            -Enabled $true -ea 0 | Out-Null} until ($?)
            Add-ADGroupMember "Domain Admins" "Benjamin"
      } 
      }

   if ($VM.Roles.contains("SOFS")) {
      icm -VMName $VM.VMName -Credential $domainCred {
         Set-Service MSiSCSI -StartupType automatic 
         Start-Service MSiSCSI 
         New-iSCSITargetPortal -TargetPortalAddress "dc.$($using:domainname)"
         Get-iSCSITarget | Connect-iSCSITarget 
         Get-iSCSISession | Register-iSCSISession
         Get-Disk | ?{$_.BusType -eq "iSCSI"} | %{
            $d = “WXYZ”[$_.Number] 
            Set-Disk -Number $_.Number -IsReadOnly 0 
            Set-Disk -Number $_.Number -IsOffline 0 
            Initialize-Disk -Number $_.Number -PartitionStyle MBR 
            New-Partition -DiskNumber $_.Number -UseMaximumSize | Set-Partition -NewDriveLetter $d  
            Initialize-Volume -DriveLetter $d -FileSystem NTFS -Confirm:$false}
         New-Cluster -Name SOFS -Node $env:COMPUTERNAME -StaticAddress "$($Using:subnet)3" 
         
         $quorum = get-disk -Number (Get-CimInstance MSiSCSIInitiator_SessionClass -namespace ROOT\WMI | `
                   select -ExpandProperty Devices | ? TargetName -Match "iscsiquorum-target").DeviceNumber | `
                   Add-ClusterDisk

         $data = get-disk -Number (Get-CimInstance MSiSCSIInitiator_SessionClass -namespace ROOT\WMI | `
                   select -ExpandProperty Devices | ? TargetName -Match "iscsidata-target").DeviceNumber | `
                   Add-ClusterDisk
         
         Set-ClusterQuorum -DiskWitness $quorum
         $data | Add-ClusterSharedVolume

         Add-ClusterScaleOutFileServerRole -Name SOFS-FS

         MD C:\ClusterStorage\Volume1\VHDX
         MD C:\ClusterStorage\Volume1\VHDX\Base
         New-SmbShare -Name VHDX -Path C:\ClusterStorage\Volume1\VHDX -FullAccess "$($Using:domainName)\administrator", "$($Using:domainName)\benjamin"
         Set-SmbPathAcl -ShareName VHDX

         MD C:\ClusterStorage\Volume1\ClusQuorum
         New-SmbShare -Name ClusQuorum -Path C:\ClusterStorage\Volume1\ClusQuorum -FullAccess "$($Using:domainName)\administrator", "$($Using:domainName)\benjamin"
         Set-SmbPathAcl -ShareName ClusQuorum

         MD C:\ClusterStorage\Volume1\ClusData
         New-SmbShare -Name ClusData -Path C:\ClusterStorage\Volume1\ClusData -FullAccess "$($Using:domainName)\administrator", "$($Using:domainName)\benjamin"
         Set-SmbPathAcl -ShareName ClusData

         New-SmbShare -Name Bits -Path C:\Bits -FullAccess "$($Using:domainName)\administrator", "$($Using:domainName)\benjamin"
         Set-SmbPathAcl -ShareName Bits
         
         Move-Item "$($env:SystemDrive)\BaseVHDs\*.*" -Destination C:\ClusterStorage\Volume1\VHDX\Base -Force
         } 
   }

   if ($VM.Roles.contains("Hyper-V")) {
      icm -VMName $VM.VMName -Credential $domainCred {
            New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\SystemCertificates\AuthRoot
            New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\SystemCertificates\AuthRoot -Name DisableRootAutoUpdate -PropertyType DWord -Value 1 -Force
            Get-NetAdapter | select -first 1 | new-vmswitch -Name $Using:virtualSwitchName -ComputerName .
            Set-VMHost -VirtualHardDiskPath \\sofs-fs\VHDX
            Set-VMHost -VirtualMachinePath \\sofs-fs\VHDX\VMs
            Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Kerberos `
                                    -ReplicationAllowedFromAnyServer $true `
                                    -DefaultStorageLocation "\\sofs-fs\VHDX\VMReplicas"
          set-vmhost -EnableEnhancedSessionMode $true
          if (!(($Using:VM).Roles.contains("Clustering"))) {
             Enable-VMMigration
             set-vmhost -UseAnyNetworkForMigration $true -VirtualMachineMigrationAuthenticationType CredSSP
             }
          }
      icm -VMName "FileServer" -Credential $domainCred {
            write-host "$($using:domainName)\$($using:VM.GuestOSName)$"
            get-SmbShareAccess VHDX | Grant-SmbShareAccess -AccountName "$($using:domainName)\$($using:VM.GuestOSName)$" -AccessRight full -Confirm:$false | Out-Null
            get-SmbShareAccess ClusQuorum | Grant-SmbShareAccess -AccountName "$($using:domainName)\$($using:VM.GuestOSName)$" -AccessRight full -Confirm:$false | Out-Null
            get-SmbShareAccess ClusData | Grant-SmbShareAccess -AccountName "$($using:domainName)\$($using:VM.GuestOSName)$" -AccessRight full -Confirm:$false | Out-Null
            Set-SmbPathAcl –ShareName VHDX | Out-Null
            Set-SmbPathAcl –ShareName ClusQuorum | Out-Null
            Set-SmbPathAcl –ShareName ClusData | Out-Null
            }
      }

       if ($VM.Roles.contains("ReFS")) {
            Get-VMHardDiskDrive -VMName $VM.VMName | ? Path -eq "$($VMPath)\$($VM.GuestOSName) - REFS.vhdx" | Remove-VMHardDiskDrive
            cleanupFile "$($VMPath)\$($VM.GuestOSName) - REFS.vhdx"
            New-VHD -Path "$($VMPath)\$($VM.GuestOSName) - REFS.vhdx" -Fixed -SizeBytes 50GB | Out-Null
            Add-VMHardDiskDrive -VMName $VM.VMname -Path "$($VMPath)\$($VM.GuestOSName) - REFS.vhdx"

            icm -VMName $VM.VMName -Credential $domainCred {
            $newDisk = (get-disk | Where-Object -FilterScript {($_.PartitionStyle -eq 'RAW')})

            If ($newDisk) 
                {
                 #Initializing Disk, creating partition, formatting and assigning drive letter
                 Initialize-Disk -UniqueId $newDisk.UniqueId -PartitionStyle GPT
                 $disk = get-disk -Number $newDisk.Number
                 $partition = New-Partition -DiskNumber $disk.Number -Size $disk.LargestFreeExtent 
                 $volume = Format-Volume -Partition $partition -FileSystem ReFS -NewFileSystemLabel "ReFS" -Confirm:$false
                 $partition | Add-PartitionAccessPath -AccessPath R:}
                 }

            Get-VMHardDiskDrive -VMName $VM.VMName | ? Path -eq "$($VMPath)\$($VM.GuestOSName) - NTFS.vhdx" | Remove-VMHardDiskDrive
            cleanupFile "$($VMPath)\$($VM.GuestOSName) - NTFS.vhdx"
            New-VHD -Path "$($VMPath)\$($VM.GuestOSName) - NTFS.vhdx" -Fixed -SizeBytes 50GB | Out-Null
            Add-VMHardDiskDrive -VMName $VM.VMname -Path "$($VMPath)\$($VM.GuestOSName) - NTFS.vhdx"

            icm -VMName $VM.VMName -Credential $domainCred {
            $newDisk = (get-disk | Where-Object -FilterScript {($_.PartitionStyle -eq 'RAW')})

            If ($newDisk) 
                {
                 #Initializing Disk, creating partition, formatting and assigning drive letter
                 Initialize-Disk -UniqueId $newDisk.UniqueId -PartitionStyle GPT
                 $disk = get-disk -Number $newDisk.Number
                 $partition = New-Partition -DiskNumber $disk.Number -Size $disk.LargestFreeExtent 
                 $volume = Format-Volume -Partition $partition -FileSystem NTFS -NewFileSystemLabel "NTFS" -Confirm:$false
                 $partition | Add-PartitionAccessPath -AccessPath N:}

            new-vhd N:\Parent.vhdx -Dynamic -SizeBytes 20GB
            New-VHD N:\Diff.vhdx -Differencing -ParentPath N:\Parent.vhdx
            $newDisk = Mount-VHD N:\Diff.vhdx -Passthru | Get-Disk 
            Initialize-Disk -UniqueId $newDisk.UniqueId -PartitionStyle GPT
            $disk = get-disk -Number $newDisk.Number
            $partition = New-Partition -DiskNumber $disk.Number -Size $disk.LargestFreeExtent 
            $volume = Format-Volume -Partition $partition -FileSystem NTFS -NewFileSystemLabel "NTFS" -Confirm:$false
            $partition | Add-PartitionAccessPath -AccessPath X:
            copy-item \\sofs-fs\VHDX\Base\VMServerBaseCore.vhdx X:
            Dismount-VHD N:\Diff.vhdx

            iex "xcopy N:\*.* R:\*.*"
            }
      }

    if ($VM.Roles.contains("Bitlocker")) {

      if ($VM.OSType -ne "Gen1") {
      icm -VMName $VM.VMName -Credential $domainCred {
                # Add required registry key for Credential Guard
                $RegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard"
                if (-not(Test-Path -Path $RegistryKeyPath)) {
                    New-Item -Path $RegistryKeyPath -ItemType Directory -Force
                }
 
                # Add registry value RequirePlatformSecurityFeatures - 1 for Secure Boot only, 3 for Secure Boot and DMA Protection
                New-ItemProperty -Path $RegistryKeyPath -Name RequirePlatformSecurityFeatures -PropertyType DWORD -Value 1
 
                # Add registry value EnableVirtualizationBasedSecurity - 1 for Enabled, 0 for Disabled
                New-ItemProperty -Path $RegistryKeyPath -Name EnableVirtualizationBasedSecurity -PropertyType DWORD -Value 1
                New-ItemProperty -Path $RegistryKeyPath -Name HypervisorEnforcedCodeIntegrity -PropertyType DWORD -Value 1
 
                # Add registry value LsaCfgFlags - 1 enables Credential Guard with UEFI lock, 2 enables Credential Guard without lock, 0 for Disabled
                New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name LsaCfgFlags -PropertyType DWORD -Value 1
                
                Enable-BitLocker -MountPoint C:\ -TpmProtector -SkipHardwareTest -UsedSpaceOnly}

                rebootVM $VM.VMName; waitForPSDirect $VM.VMName -cred $domainCred

         
          }
      else{
           icm -VMName $VM.VMName -Credential $domainCred {iex "BdeHdCfg -target c: shrink -size 550 -quiet"}

           rebootVM $VM.VMName; waitForPSDirect $VM.VMName -cred $domainCred

           icm -VMName $VM.VMName -Credential $domainCred {
             # I am almost sure there is a smarter way of detecting a newly added KSD - current approach:
            $ksd = (get-disk | Where-Object -FilterScript {($_.Size -le 48MB) -and ($_.PartitionStyle -eq 'RAW')})

            # Create local group policy configuration to allow BitLocker without TPM
            New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\FVE -Force | Out-Null
            New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\FVE -Name EnableBDEWithNoTPM -PropertyType DWord -Value 1 -Force| Out-Null
            New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\FVE -Name UseAdvancedStartup -PropertyType DWord -Value 1 -Force| Out-Null

            If ($ksd) 
            {
                #Initializing Disk, creating partition, formatting and assigning drive letter
                Initialize-Disk -UniqueId $ksd.UniqueId -PartitionStyle MBR
                $partition = New-Partition -DiskNumber $ksd.Number -Size $ksd.LargestFreeExtent 
                $volume = Format-Volume -Partition $partition -FileSystem NTFS -Confirm:$false

                $partition | Add-PartitionAccessPath -AssignDriveLetter

                $driveLetter = ($partition | Get-Volume).DriveLetter

                $path = "$($driveLetter):"

                # enabling BitLocker for default OS partition
                Enable-BitLocker -MountPoint C: -StartupKeyProtector -StartupKeyPath $path -SkipHardwareTest -UsedSpaceOnly | Out-Null

                # Adding numeric recovery key (should be backed up to AD etc.)
                Add-BitLockerKeyProtector -MountPoint C: -RecoveryPasswordProtector | Out-Null

                Remove-PartitionAccessPath -DiskNumber $ksd.DiskNumber -PartitionNumber $partition.PartitionNumber -AccessPath $path
            }
            }
          }

      }

   }
  }

Class DemoVM
    {
        [string]$VMName
        [string]$GuestOSName
        [string]$OSType = "DatacenterCore"
        [long]$Memory = 1GB
        [bool]$EnableNesting = $false
        [string]$IPAddress
        [bool]$DomainJoined = $false
        [string]$CustomBaseVHD
        [string]$Wallpaper
        [string]$PowerShellTextColor = "Green"
        [string]$PowerShellBackColor = "Black"
        [string]$HVHost = $null
        [int]$phase = 100
        [bool]$headless = $false
        $Roles = @()
    }

$VMs = @()

$VMs += (New-Object DemoVM -Property @{
          VMName = "Domain Controller"
          GuestOSName = "DC"
          IPAddress = "$($subnet)1"
          phase = 1
          Roles = @("DomainController")})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Fileserver"
          GuestOSName = "Fileserver"
          Memory = 700MB
          IPAddress = "$($subnet)2"
          DomainJoined = $true
          phase = 2
          Roles = @("SOFS", "Clustering")})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Management"
          GuestOSName = "Management"
          Memory = 1500MB
          OSType = "Datacenter"
          IPAddress = "$($subnet)10"
          DomainJoined = $true
          Wallpaper = "$($workingDir)\Bits\Wallpapers\kitty.jpg"
          phase = 2
          Roles = @("Management")})

$VMs += (New-Object DemoVM -Property @{
          VMName = "vTPM"
          GuestOSName = "vTPM"
          Memory = 1500MB 
          OSType = "Datacenter"
          phase = 3
          DomainJoined = $true
          Wallpaper = "$($workingDir)\Bits\Wallpapers\kitty2.jpg"
          Roles = @("Bitlocker")})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Bitlocker"
          GuestOSName = "BitLocker"
          Memory = 1500MB
          OSType = "Gen1"
          phase = 3
          DomainJoined = $true
          Wallpaper = "$($workingDir)\Bits\Wallpapers\kitty3.jpg"
          Roles = @("Bitlocker")})

$VMs += (New-Object DemoVM -Property @{
          VMName = "PowerShell Direct"
          GuestOSName = "PSDirect"
          Memory = 600MB
          phase = 3
          DomainJoined = $true})

$VMs += (New-Object DemoVM -Property @{
          VMName = "SCVMM"
          GuestOSName = "SCVMM"
          Memory = 1200MB
          OSType = "Datacenter"
          phase = 3
          Wallpaper = "$($workingDir)\Bits\Wallpapers\kitty4.jpg"
          DomainJoined = $true})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Hyper-V - Storage Resiliency"
          GuestOSName = "HVStorRes"
          Memory = 2GB
          OSType = "Datacenter"
          Wallpaper = "$($workingDir)\Bits\Wallpapers\kitty5.jpg"
          EnableNesting = $true
          DomainJoined = $true
          phase = 3
          Roles = @("Hyper-V", "ReFS")})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Hyper-V - Replica Source"
          GuestOSName = "HVReplicaSource"
          Memory = 750MB
          OSType = "Nano"
          EnableNesting = $true
          DomainJoined = $true
          phase = 3
          Roles = @("Hyper-V")})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Hyper-V - Replica Target"
          GuestOSName = "HVReplicaTarget"
          Memory = 750MB
          OSType = "Nano"
          EnableNesting = $true
          DomainJoined = $true
          Headless = $true
          phase = 3
          Roles = @("Hyper-V")})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Hyper-V Cluster Node 1"
          GuestOSName = "HVNode1"
          Memory = 3GB
          OSType = "Nano"
          EnableNesting = $true
          DomainJoined = $true
          phase = 3
          Roles = @("Hyper-V", "Clustering")})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Hyper-V Cluster Node 2"
          GuestOSName = "HVNode2"
          Memory = 3GB
          OSType = "Nano"
          EnableNesting = $true
          DomainJoined = $true
          phase = 3
          Roles = @("Hyper-V", "Clustering")})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Hyper-V Server"
          GuestOSName = "HVServer"
          Memory = 7GB
          OSType = "Nano"
          EnableNesting = $true
          DomainJoined = $true
          phase = 3
          Roles = @("Hyper-V")})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Windows Containers"
          GuestOSName = "WinContainers"
          Memory = 1500MB
          phase = 3
          DomainJoined = $true})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Ubuntu Server 16"
          GuestOSName = "ubuntu"
          Memory = 1500MB
          OSType = "Linux"
          phase = 3
          CustomBaseVHD = "$($workingDir)\CustomBaseVHDs\Ubuntu 16 Server.vhdx"})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Workload 1"
          GuestOSName = "Workload1"
          Memory = 256MB
          OSType = "Nano"
          DomainJoined = $false
          phase = 4
          HVHost = "Hyper-V Cluster Node 1"})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Workload 2"
          GuestOSName = "Workload2"
          Memory = 256MB
          OSType = "Nano"
          DomainJoined = $false
          phase = 4
          HVHost = "Hyper-V Cluster Node 1"})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Workload 3"
          GuestOSName = "Workload3"
          Memory = 256MB
          OSType = "Nano"
          DomainJoined = $false
          phase = 4
          HVHost = "Hyper-V Cluster Node 2"})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Workload 4"
          GuestOSName = "Workload4"
          Memory = 256MB
          OSType = "Nano"
          DomainJoined = $false
          phase = 4
          HVHost = "Hyper-V Cluster Node 2"})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Replicated Workload"
          GuestOSName = "RepWorkload"
          Memory = 256MB
          OSType = "Nano"
          DomainJoined = $false
          phase = 4
          HVHost = "Hyper-V - Replica Source"})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Storage Workload"
          GuestOSName = "StorageWorkload"
          Memory = 512MB
          DomainJoined = $true
          phase = 4
          HVHost = "Hyper-V - Storage Resiliency"})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Storage QOS 1"
          GuestOSName = "SQOS1"
          Memory = 512MB
          DomainJoined = $true
          phase = 4
          HVHost = "Hyper-V Server"})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Storage QOS 2"
          GuestOSName = "SQOS2"
          Memory = 512MB
          DomainJoined = $true
          phase = 4
          HVHost = "Hyper-V Server"})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Guest Cluster Node 1"
          GuestOSName = "GClusN1"
          Memory = 512MB
          DomainJoined = $true
          phase = 4
          HVHost = "Hyper-V Server"})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Guest Cluster Node 2"
          GuestOSName = "GClusN2"
          Memory = 512MB
          DomainJoined = $true
          phase = 4
          HVHost = "Hyper-V Server"})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Upgrade VM"
          GuestOSName = "UpgradeVM"
          Memory = 1GB
          OSType = "Datacenter"
          phase = 4
          HVHost = "Hyper-V Server"
          Wallpaper = "\\fileserver\bits\Wallpapers\kitty6.jpg"
          DomainJoined = $true})

$VMs += (New-Object DemoVM -Property @{
          VMName = "Hot Add Remove"
          GuestOSName = "AddRemove"
          Memory = 1GB
          OSType = "Datacenter"
          phase = 4
          HVHost = "Hyper-V Server"
          Wallpaper = "\\fileserver\bits\Wallpapers\kitty7.jpg"
          DomainJoined = $true})

## TODO - Create Hyper-V Cluster
## TODO - Desktop shortcuts on: Management, vTPM, Bitlocker, Storage Resiliency, Hot/ Add Remove VM

#############################

$title = "Hyper-V Demo Build"
$message = "What are we doing?"

$BaseImages = New-Object System.Management.Automation.Host.ChoiceDescription "Rebuild &Base Images","Rebuild everything"
$VirtualMachines = New-Object System.Management.Automation.Host.ChoiceDescription "Rebuild &Virtual Machines","Rebuild VMs from base image"
$Phase2 = New-Object System.Management.Automation.Host.ChoiceDescription "Rebuild from Phase &2 Checkpoint","Rebuild from Phase 2 Checkpoint"
$Phase3 = New-Object System.Management.Automation.Host.ChoiceDescription "Rebuild from Phase &3 Checkpoint","Rebuild from Phase 3 Checkpoint"
$Shutdown = New-Object System.Management.Automation.Host.ChoiceDescription "Cleanly &Shut down the entire environment"
$Startup = New-Object System.Management.Automation.Host.ChoiceDescription "Cleanly &Start the entire environment"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($BaseImages, $VirtualMachines, $Phase2, $Phase3, $Shutdown, $Startup)

$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
switch ($result)
    {
        0 { # Rebuild Everything
            foreach ($vm in $vms) {if ($vm.HVHost -eq "") {DeleteVM($VM)}}
            BuildBaseImages
            write-host "Prepping VMs"
            foreach ($vm in $vms) {if ($vm.HVHost -eq "") {PrepVM($VM)}}
            write-host "Creating base checkpoint"
            foreach ($vm in $vms) {if ($vm.HVHost -eq ""){createVMCheckpoint -VM $VM -CheckpointName "Base"}}
            write-host "Configuring Phase 1"
            foreach ($vm in $vms) {if ($VM.phase -eq 1) {ConfigureVM($VM)}}
            foreach ($vm in $vms) {if ($VM.phase -le 3) {createVMCheckpoint -VM $VM -CheckpointName "Phase 1"}}
            write-host "Configuring Phase 2"
            foreach ($vm in $vms) {if ($VM.phase -eq 2) {ConfigureVM($VM)}}
            foreach ($vm in $vms) {if ($VM.phase -le 3) {createVMCheckpoint -VM $VM -CheckpointName "Phase 2"}}
            write-host "Configuring Phase 3"
            foreach ($vm in $vms) {if ($VM.phase -eq 3) {ConfigureVM($VM)}}
            foreach ($vm in $vms) {if ($VM.phase -le 3) {createVMCheckpoint -VM $VM -CheckpointName "Phase 3"}}

            foreach ($vm in $vms) {if ($VM.phase -eq 4) {PrepNestedVM($VM)}}
            foreach ($vm in $vms) {if ($VM.phase -eq 4) {ConfigureNestedVM($VM)}}

            }
        1 { # Leave base images alone
            foreach ($vm in $vms) {DeleteVM($VM)}
            foreach ($vm in $vms) {PrepVM($VM)}
            foreach ($vm in $vms) {ConfigureVM($VM)}

        }
        2 {# Restore phase 2 checkpoints
            stopEnvironment
            foreach ($vm in $vms) {RestoreVMCheckpoint -VM $vm -CheckpointName "Phase 2"}
            startEnvironment

            # Fix missing VMs
            $missingVMs = @()
            foreach ($vm in $vms) {if ($vm.HVHost -eq "") {if ((Get-VM | ? Name -eq $VM.VMname) -eq $null) {$missingVMs += $VM}}}
            foreach ($vm in $missingVMs) {PrepVM($VM)}
            foreach ($vm in $missingVMs) {createVMCheckpoint -VM $VM -CheckpointName "Base"}
            foreach ($vm in $missingVMs) {if ($VM.phase -eq 1) {ConfigureVM($VM)}}
            foreach ($vm in $missingVMs) {createVMCheckpoint -VM $VM -CheckpointName "Phase 1"}
            foreach ($vm in $missingVMs) {if ($VM.phase -eq 2) {ConfigureVM($VM)}}
            foreach ($vm in $missingVMs) {createVMCheckpoint -VM $VM -CheckpointName "Phase 2"}

            write-host "Configuring Phase 3"
            foreach ($vm in $vms) {if ($VM.phase -eq 3) {ConfigureVM($VM)}}
            foreach ($vm in $vms) {createVMCheckpoint -VM $VM -CheckpointName "Phase 3"}

            foreach ($vm in $vms) {if ($VM.phase -eq 4) {PrepNestedVM($VM)}}
            foreach ($vm in $vms) {if ($VM.phase -eq 4) {ConfigureNestedVM($VM)}}
        }

        3 {# Restore phase 3 checkpoints
            stopEnvironment
            foreach ($vm in $vms) {if ($vm.HVHost -eq "") {RestoreVMCheckpoint -VM $vm -CheckpointName "Phase 3"}}
            startEnvironment

            # Fix missing VMs
            $missingVMs = @()
            foreach ($vm in $vms) {if ($vm.HVHost -eq "") {if ((Get-VM | ? Name -eq $VM.VMname) -eq $null) {$missingVMs += $VM}}}
            foreach ($vm in $missingVMs) {PrepVM($VM)}
            foreach ($vm in $missingVMs) {createVMCheckpoint -VM $VM -CheckpointName "Base"}
            foreach ($vm in $missingVMs) {if ($VM.phase -eq 1) {ConfigureVM($VM)}}
            foreach ($vm in $missingVMs) {createVMCheckpoint -VM $VM -CheckpointName "Phase 1"}
            foreach ($vm in $missingVMs) {if ($VM.phase -eq 2) {ConfigureVM($VM)}}
            foreach ($vm in $missingVMs) {createVMCheckpoint -VM $VM -CheckpointName "Phase 2"}
            foreach ($vm in $missingVMs) {if ($VM.phase -eq 3) {ConfigureVM($VM)}}
            foreach ($vm in $missingVMs) {createVMCheckpoint -VM $VM -CheckpointName "Phase 3"}

            foreach ($vm in $vms) {if ($VM.phase -eq 4) {PrepNestedVM($VM)}}
            foreach ($vm in $vms) {if ($VM.phase -eq 4) {ConfigureNestedVM($VM)}}
        }

        4 {# Restore phase 1 checkpoints
            stopEnvironment
        }

        5 {# Restore phase 1 checkpoints
            startEnvironment
        }
    }