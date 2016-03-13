# Parameters
$workingDir = "D:\DCBuild"
$BaseVHDPath = "$($workingDir)\BaseVHDs"
$VMPath = "$($workingDir)\VMs"
$Organization = "The Power Elite"
$Owner = "Ben Armstrong"
$Timezone = "Pacific Standard Time"
$adminPassword = "P@ssw0rd"
$domainName = "HyperV.Bear"
$domainAdminPassword = "P@ssw0rd"
$virtualSwitchName = "Bens MVP Demo"
$subnet = "10.10.10."

$localCred = new-object -typename System.Management.Automation.PSCredential `
             -argumentlist "Administrator", (ConvertTo-SecureString $adminPassword -AsPlainText -Force)
$domainCred = new-object -typename System.Management.Automation.PSCredential `
              -argumentlist "$($domainName)\Administrator", (ConvertTo-SecureString $domainAdminPassword -AsPlainText -Force)
$ServerISO = "D:\DCBuild\10586.0.151029-1700.TH2_RELEASE_SERVER_OEMRET_X64FRE_EN-US.ISO"

$WindowsKey = ""

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
        Remove-Item $file -Recurse > $null;
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
    GetUnattendChunk "specialize" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.ProductKey = $WindowsKey};

    # Write it out to disk
    cleanupFile $filePath; $Unattend.Save($filePath);
}

# Build base VHDs

Function BuildBaseImages {

   Mount-DiskImage $ServerISO
   $DVDDriveLetter = (Get-DiskImage $ServerISO | Get-Volume).DriveLetter
   Copy-Item "$($DVDDriveLetter):\NanoServer\Convert-WindowsImage.ps1" "$($workingDir)\Convert-WindowsImage.ps1" -Force
   Import-Module "$($DVDDriveLetter):\NanoServer\NanoServerImageGenerator.psm1" -Force

   makeUnattendFile "$($BaseVHDPath)\unattend.xml"

    if (!(Test-Path "$($BaseVHDPath)\NanoBase.vhdx")) 
    {
    New-NanoServerImage -MediaPath "$($DVDDriveLetter):\" -BasePath $BaseVHDPath -TargetPath "$($BaseVHDPath)\NanoBase.vhdx" -GuestDrivers -Compute -Clustering -AdministratorPassword (ConvertTo-SecureString $adminPassword -AsPlainText -Force)
    }

    if (!(Test-Path "$($BaseVHDPath)\VMServerBaseCore.vhdx")) 
    {
        . "$workingDir\Convert-WindowsImage.ps1" -SourcePath "$($DVDDriveLetter):\sources\install.wim" -VHDPath "$($BaseVHDPath)\VMServerBaseCore.vhdx" `
                     -SizeBytes 40GB -VHDFormat VHDX -UnattendPath "$($BaseVHDPath)\unattend.xml" `
                     -Edition "ServerDataCenterCore" -DiskLayout UEFI -MergeFolder "$($workingDir)\cBase"
    }

    if (!(Test-Path "$($BaseVHDPath)\VMServerBase.vhdx")) 
    {
        . "$workingDir\Convert-WindowsImage.ps1" -SourcePath "$($DVDDriveLetter):\sources\install.wim" -VHDPath "$($BaseVHDPath)\VMServerBase.vhdx" `
                     -SizeBytes 40GB -VHDFormat VHDX -UnattendPath "$($BaseVHDPath)\unattend.xml" `
                     -Edition "ServerDataCenter" -DiskLayout UEFI
    }

    cleanupFile "$($BaseVHDPath)\unattend.xml"
    Dismount-DiskImage $ServerISO 
    # cleanupFile "$($workingDir)\Convert-WindowsImage.ps1"
}

function PrepVM {

    param
    (
        [string] $VMName, 
        [string] $GuestOSName, 
        [switch] $FullServer
    ); 

   logger $VMName "Removing old VM"
   get-vm $VMName -ErrorAction SilentlyContinue | stop-vm -TurnOff -Force -Passthru | remove-vm -Force
   cleanupFile "$($VMPath)\$($GuestOSName).vhdx"

   # Make new VM
   logger $VMName "Creating new differencing disk"
   if ($FullServer) { New-VHD -Path "$($VMPath)\$($GuestOSName).vhdx" -ParentPath "$($BaseVHDPath)\VMServerBase.vhdx" -Differencing | Out-Null}
   else {New-VHD -Path "$($VMPath)\$($GuestOSName).vhdx" -ParentPath "$($BaseVHDPath)\VMServerBaseCore.vhdx" -Differencing | Out-Null}
   logger $VMName "Creating virtual machine"
   new-vm -Name $VMName -MemoryStartupBytes 1GB -SwitchName $VirtualSwitchName `
          -VHDPath "$($VMPath)\$($GuestOSName).vhdx" -Generation 2  | Set-VM -ProcessorCount 2
   logger $VMName "Starting virtual machine"
   start-vm $VMName
   }

function CreateVM {

    param
    (
        [string] $VMName, 
        [string] $GuestOSName, 
        [string] $IPNumber = "0"
    ); 

   waitForPSDirect $VMName -cred $localCred

   # Set IP address & name
   icm -VMName $VMName -Credential $localCred {
      param($IPNumber, $GuestOSName,  $VMName, $domainName, $subnet)
      if ($IPNumber -ne "0") {
         Write-Output "[$($VMName)]:: Setting IP Address to $($subnet)$($IPNumber)"
         New-NetIPAddress -IPAddress "$($subnet)$($IPNumber)" -InterfaceAlias "Ethernet" -PrefixLength 24 | Out-Null
         Write-Output "[$($VMName)]:: Setting DNS Address"
         Get-DnsClientServerAddress | %{Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses "$($subnet)1"}}
      Write-Output "[$($VMName)]:: Renaming OS to `"$($GuestOSName)`""
      Rename-Computer $GuestOSName
      Write-Output "[$($VMName)]:: Configuring WSMAN Trusted hosts"
      Set-Item WSMan:\localhost\Client\TrustedHosts "*.$($domainName)" -Force
      Set-Item WSMan:\localhost\client\trustedhosts "$($subnet)*" -force -concatenate
      Enable-WSManCredSSP -Role Client -DelegateComputer "*.$($domainName)" -Force
      } -ArgumentList $IPNumber, $GuestOSName, $VMName, $domainName, $subnet

      # Reboot
      rebootVM $VMName; waitForPSDirect $VMName -cred $localCred

}

logger "Host" "Getting started..."

checkpath $BaseVHDPath
checkpath $VMPath

BuildBaseImages

if ((Get-VMSwitch | ? name -eq $virtualSwitchName) -eq $null)
{
New-VMSwitch -Name $virtualSwitchName -SwitchType Private
}

PrepVM "Domain Controller 1" "DC1"
PrepVM "Container Host" "ConHost"
PrepVM "Domain Controller 2" "DC2"
PrepVM "DHCP Server" "DHCP"
PrepVM "Management Console" "Management" -FullServer
PrepVM "Storage Node 1" "S2DNode1"
PrepVM "Storage Node 2" "S2DNode2"
PrepVM "Storage Node 3" "S2DNode3"
PrepVM "Storage Node 4" "S2DNode4"

$vmName = "Domain Controller 1"
$GuestOSName = "DC1"
$IPNumber = "1"

CreateVM $vmName $GuestOSName $IPNumber

      icm -VMName $VMName -Credential $localCred {
         param($VMName, $domainName, $domainAdminPassword)
         Write-Output "[$($VMName)]:: Installing AD"
         Install-WindowsFeature AD-Domain-Services -IncludeManagementTools | out-null
         Write-Output "[$($VMName)]:: Enabling Active Directory and promoting to domain controller"
         Install-ADDSForest -DomainName $domainName -InstallDNS -NoDNSonNetwork -NoRebootOnCompletion `
                            -SafeModeAdministratorPassword (ConvertTo-SecureString $domainAdminPassword -AsPlainText -Force) -confirm:$false
                            } -ArgumentList $VMName, $domainName, $domainAdminPassword

      # Reboot
      rebootVM $VMName; 
      
$vmName = "Container Host"
$GuestOSName =  "ConHost"

   waitForPSDirect $VMName -cred $localCred

   logger $VMName "Enabling Containers Feature"
   icm -VMName $VMName -Credential $localCred {install-windowsfeature containers} 

   # Reboot
   rebootVM $VMName; waitForPSDirect $VMName -cred $localCred

   logger $VMName "Starting background installation of the Container Base OS Image"
$job = icm -VMName $VMName -Credential $localCred {
        Install-ContainerOSImage C:\CBaseOs_th2_release_10586.0.151029-1700_amd64fre_ServerDatacenterCore_en-us.wim -Force} -asjob

$vmName = "DHCP Server"
$GuestOSName = "DHCP"
$IPNumber = "3"

CreateVM $vmName $GuestOSName $IPNumber

      icm -VMName $VMName -Credential $localCred {
         param($VMName, $domainCred, $domainName)
         Write-Output "[$($VMName)]:: Installing DHCP"
         Install-WindowsFeature DHCP -IncludeManagementTools | out-null
         Write-Output "[$($VMName)]:: Joining domain as `"$($env:computername)`""
         while (!(Test-Connection -Computername $domainName -BufferSize 16 -Count 1 -Quiet -ea SilentlyContinue)) {sleep -seconds 1}
         do {Add-Computer -DomainName $domainName -Credential $domainCred -ea SilentlyContinue} until ($?)
         } -ArgumentList $VMName, $domainCred, $domainName

               # Reboot
      rebootVM $VMName; waitForPSDirect $VMName -cred $domainCred

      icm -VMName $VMName -Credential $domainCred {
         param($VMName, $domainName, $subnet, $IPNumber)

         Write-Output "[$($VMName)]:: Waiting for name resolution"

         while ((Test-NetConnection -ComputerName $domainName).PingSucceeded -eq $false) {Start-Sleep 1}

         Write-Output "[$($VMName)]:: Configuring DHCP Server"    
         Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias Ethernet
         Add-DhcpServerv4Scope -Name "IPv4 Network" -StartRange "$($subnet)10" -EndRange "$($subnet)200" -SubnetMask 255.255.255.0
         Set-DhcpServerv4OptionValue -OptionId 6 -value "$($subnet)1"
         Add-DhcpServerInDC -DnsName "$($env:computername).$($domainName)"
         foreach($i in 1..99) {
         $mac = "00-b5-5d-fe-f6-" + ($i % 100).ToString("00")
         $ip = $subnet + "1" + ($i % 100).ToString("00")
         $desc = "Container " + $i.ToString()
         $scopeID = $subnet + "0"
         Add-DhcpServerv4Reservation -IPAddress $ip -ClientId $mac -Description $desc -ScopeId $scopeID}
                            } -ArgumentList $VMName, $domainName, $subnet, $IPNumber

      # Reboot
      rebootVM $VMName

$vmName = "Domain Controller 2"
$GuestOSName = "DC2"
$IPNumber = "2"

CreateVM $vmName $GuestOSName $IPNumber

      icm -VMName $VMName -Credential $localCred {
         param($VMName, $domainCred, $domainName)
         Write-Output "[$($VMName)]:: Installing AD"
         Install-WindowsFeature AD-Domain-Services -IncludeManagementTools | out-null
         Write-Output "[$($VMName)]:: Joining domain as `"$($env:computername)`""
         while (!(Test-Connection -Computername $domainName -BufferSize 16 -Count 1 -Quiet -ea SilentlyContinue)) {sleep -seconds 1}
         do {Add-Computer -DomainName $domainName -Credential $domainCred -ea SilentlyContinue} until ($?)
         } -ArgumentList $VMName, $domainCred, $domainName

               # Reboot
      rebootVM $VMName; waitForPSDirect $VMName -cred $domainCred

      icm -VMName $VMName -Credential $domainCred {
         param($VMName, $domainName, $domainAdminPassword)

         Write-Output "[$($VMName)]:: Waiting for name resolution"

         while ((Test-NetConnection -ComputerName $domainName).PingSucceeded -eq $false) {Start-Sleep 1}

         Write-Output "[$($VMName)]:: Enabling Active Directory and promoting to domain controller"
    
         Install-ADDSDomainController -DomainName $domainName -InstallDNS -NoRebootOnCompletion `
                                     -SafeModeAdministratorPassword (ConvertTo-SecureString $domainAdminPassword -AsPlainText -Force) -confirm:$false 
 
                            } -ArgumentList $VMName, $domainName, $domainAdminPassword

      # Reboot
      rebootVM $VMName

$vmName = "Domain Controller 1"
$GuestOSName = "DC1"
$IPNumber = "1"

waitForPSDirect $VMName -cred $domainCred

icm -VMName $VMName -Credential $domainCred {
         param($VMName, $password)

         Write-Output "[$($VMName)]:: Creating user account for Benjamin"
         do {start-sleep 5; New-ADUser `
            -Name "Benjamin" `
            -SamAccountName  "Benjamin" `
            -DisplayName "Benjamin" `
            -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
            -ChangePasswordAtLogon $false  `
            -Enabled $true -ea 0} until ($?)
            Add-ADGroupMember "Domain Admins" "Benjamin"} -ArgumentList $VMName, $domainAdminPassword

$vmName = "Management Console"
$GuestOSName = "Management"

CreateVM $vmName $GuestOSName

      icm -VMName $VMName -Credential $localCred {
         param($VMName, $domainCred, $domainName)
         Write-Output "[$($VMName)]:: Management tools"
         Install-WindowsFeature RSAT-Clustering, RSAT-Hyper-V-Tools | out-null
         Write-Output "[$($VMName)]:: Joining domain as `"$($env:computername)`""
         while (!(Test-Connection -Computername $domainName -BufferSize 16 -Count 1 -Quiet -ea SilentlyContinue)) {sleep -seconds 1}
         do {Add-Computer -DomainName $domainName -Credential $domainCred -ea SilentlyContinue} until ($?)
         } -ArgumentList $VMName, $domainCred, $domainName

      # Reboot
      rebootVM $VMName

function BuildStorageNode {
param($VMName, $GuestOSName)

CreateVM $vmName $GuestOSName

   cleanupFile "$($VMPath)\$($GuestOSName) - Data 1.vhdx"
   cleanupFile "$($VMPath)\$($GuestOSName) - Data 2.vhdx"

   Add-VMNetworkAdapter -VMName $VMName -SwitchName $VirtualSwitchName
   new-vhd -Path "$($VMPath)\$($GuestOSName) - Data 1.vhdx" -Dynamic -SizeBytes 200GB
   Add-VMHardDiskDrive -VMName $VMName -Path "$($VMPath)\$($GuestOSName) - Data 1.vhdx"
   new-vhd -Path "$($VMPath)\$($GuestOSName) - Data 2.vhdx" -Dynamic -SizeBytes 200GB
   Add-VMHardDiskDrive -VMName $VMName -Path "$($VMPath)\$($GuestOSName) - Data 2.vhdx"

      icm -VMName $VMName -Credential $localCred {
         param($VMName, $domainCred, $domainName)
         Write-Output "[$($VMName)]:: Installing Clustering"
         Install-WindowsFeature -Name File-Services, Failover-Clustering -IncludeManagementTools | out-null
         Write-Output "[$($VMName)]:: Joining domain as `"$($env:computername)`""
         while (!(Test-Connection -Computername $domainName -BufferSize 16 -Count 1 -Quiet -ea SilentlyContinue)) {sleep -seconds 1}
         do {Add-Computer -DomainName $domainName -Credential $domainCred -ea SilentlyContinue} until ($?)
         } -ArgumentList $VMName, $domainCred, $domainName


      # Reboot
      rebootVM $VMName
}

BuildStorageNode "Storage Node 1" "S2DNode1"
BuildStorageNode "Storage Node 2" "S2DNode2"
BuildStorageNode "Storage Node 3" "S2DNode3"
BuildStorageNode "Storage Node 4" "S2DNode4"

waitForPSDirect "Storage Node 4" -cred $domainCred

icm -VMName "Management Console" -Credential $domainCred {
param ($domainName)
do {New-Cluster -Name S2DCluster -Node S2DNode1,S2DNode2,S2DNode3,S2DNode4 -NoStorage} until ($?)
while (!(Test-Connection -Computername "S2DCluster.$($domainName)" -BufferSize 16 -Count 1 -Quiet -ea SilentlyContinue)) 
      {ipconfig /flushdns; sleep -seconds 1}
Enable-ClusterStorageSpacesDirect -Cluster "S2DCluster.$($domainName)"
Add-ClusterScaleoutFileServerRole -name S2DFileServer -cluster "S2DCluster.$($domainName)"
} -ArgumentList $domainName

icm -VMName "Storage Node 1" -Credential $domainCred {
param ($domainName)
New-StoragePool -StorageSubSystemName "S2DCluster.$($domainName)" -FriendlyName S2DPool -WriteCacheSizeDefault 0 -ProvisioningTypeDefault Fixed -ResiliencySettingNameDefault Mirror -PhysicalDisk (Get-StorageSubSystem  -Name "S2DCluster.$($domainName)" | Get-PhysicalDisk)
New-Volume -StoragePoolFriendlyName S2DPool -FriendlyName S2DDisk -PhysicalDiskRedundancy 2 -FileSystem CSVFS_REFS -Size 500GB
Set-FileIntegrity "C:\ClusterStorage\Volume1" -Enable $false

         MD C:\ClusterStorage\Volume1\VHDX
         New-SmbShare -Name VHDX -Path C:\ClusterStorage\Volume1\VHDX -FullAccess "$($domainName)\administrator", "$($domainName)\Benjamin", "$($domainName)\Management$"
         Set-SmbPathAcl -ShareName VHDX

         MD C:\ClusterStorage\Volume1\ClusQuorum
         New-SmbShare -Name ClusQuorum -Path C:\ClusterStorage\Volume1\ClusQuorum -FullAccess "$($domainName)\administrator", "$($domainName)\Benjamin", "$($domainName)\Management$"
         Set-SmbPathAcl -ShareName ClusQuorum

         MD C:\ClusterStorage\Volume1\ClusData
         New-SmbShare -Name ClusData -Path C:\ClusterStorage\Volume1\ClusData -FullAccess "$($domainName)\administrator", "$($domainName)\Benjamin", "$($domainName)\Management$"
         Set-SmbPathAcl -ShareName ClusData

} -ArgumentList $domainName

$vmName = "Container Host"
$GuestOSName =  "ConHost"

icm -VMName $VMName -Credential $localCred {
        new-container "IIS" -ContainerImageName * 
        start-container "IIS"
        icm -ContainerName "IIS" -RunAsAdministrator {install-windowsfeature web-server}
        stop-container "IIS"
        New-ContainerImage -ContainerName "IIS" -Name "IIS" -Publisher "Armstrong" -Version 1.0
        Remove-Container -Name "IIS" -Force
        New-NetFirewallRule -DisplayName "Allow inbound TCP Port 80" -Direction inbound -LocalPort 80 -Protocol TCP -Action Allow}
icm -VMName $VMName -Credential $localCred {& cmd /c "C:\windows\system32\Sysprep\sysprep.exe /quiet /generalize /oobe /shutdown /unattend:C:\unattend.xml"}

logger $VMName "Ready to inject Container Host into Storage Cluster"

while ((get-vm "Container Host").State -ne "Off") {start-sleep 1}

remove-vm "Container Host" -force


function PrepComputeNode {
param($VMName, $GuestOSName)

   logger $VMName "Removing old VM"
   get-vm $VMName -ErrorAction SilentlyContinue | stop-vm -TurnOff -Force -Passthru | remove-vm -Force
   cleanupFile "$($VMPath)\$($GuestOSName).vhdx"

   copy "$($BaseVHDPath)\NanoBase.vhdx" "$($VMPath)\$($GuestOSName).vhdx"

   # Make new VM
   logger $VMName "Creating virtual machine"
   new-vm -Name $VMName -MemoryStartupBytes 2400MB -SwitchName $VirtualSwitchName `
          -VHDPath "$($VMPath)\$($GuestOSName).vhdx" -Generation 2
   Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $false
   Set-VMProcessor -VMName $VMName -Count 2 -ExposeVirtualizationExtensions $true
   Add-VMNetworkAdapter -VMName $VMName -SwitchName $VirtualSwitchName
   Get-VMNetworkAdapter -VMName $VMName | Set-VMNetworkAdapter -MacAddressSpoofing on
   logger $VMName "Starting virtual machine"
   do {start-vm $VMName} until ($?)
}

function BuildComputeNode {
param($VMName, $GuestOSName)

   waitForPSDirect $VMName $localCred

   logger $VMName "Creating standard virtual switch"
   icm -VMName $VMName -Credential $localCred {
      param($GuestOSName)
      enable-wsmancredssp -role server -force
      New-VMSwitch -Name "Virtual Switch" -NetAdapterName "Ethernet" -AllowManagementOS $true
      djoin /requestodj /loadfile "\\10.10.10.1\c$\$($GuestOSName).txt" /windowspath c:\windows /localos
      del "\\10.10.10.1\c$\$($GuestOSName).txt"} -ArgumentList $GuestOSName

      # Reboot
      rebootVM $VMName; 
}

PrepComputeNode "Hyper-V Node 1" "HVNode1"
PrepComputeNode "Hyper-V Node 2" "HVNode2"
PrepComputeNode "Hyper-V Node 3" "HVNode3"
PrepComputeNode "Hyper-V Node 4" "HVNode4"
PrepComputeNode "Hyper-V Node 5" "HVNode5"
PrepComputeNode "Hyper-V Node 6" "HVNode6"
PrepComputeNode "Hyper-V Node 7" "HVNode7"
PrepComputeNode "Hyper-V Node 8" "HVNode8"

icm -VMName "Management Console" -Credential $domainCred {
                    param($domainName)
                    djoin.exe /provision /domain $domainName /machine "HVNode1" /savefile \\10.10.10.1\c$\HVNode1.txt
                    djoin.exe /provision /domain $domainName /machine "HVNode2" /savefile \\10.10.10.1\c$\HVNode2.txt
                    djoin.exe /provision /domain $domainName /machine "HVNode3" /savefile \\10.10.10.1\c$\HVNode3.txt
                    djoin.exe /provision /domain $domainName /machine "HVNode4" /savefile \\10.10.10.1\c$\HVNode4.txt
                    djoin.exe /provision /domain $domainName /machine "HVNode5" /savefile \\10.10.10.1\c$\HVNode5.txt
                    djoin.exe /provision /domain $domainName /machine "HVNode6" /savefile \\10.10.10.1\c$\HVNode6.txt
                    djoin.exe /provision /domain $domainName /machine "HVNode7" /savefile \\10.10.10.1\c$\HVNode7.txt
                    djoin.exe /provision /domain $domainName /machine "HVNode8" /savefile \\10.10.10.1\c$\HVNode8.txt} -ArgumentList $domainName

BuildComputeNode "Hyper-V Node 1" "HVNode1"
BuildComputeNode "Hyper-V Node 2" "HVNode2"
BuildComputeNode "Hyper-V Node 3" "HVNode3"
BuildComputeNode "Hyper-V Node 4" "HVNode4"
BuildComputeNode "Hyper-V Node 5" "HVNode5"
BuildComputeNode "Hyper-V Node 6" "HVNode6"
BuildComputeNode "Hyper-V Node 7" "HVNode7"
BuildComputeNode "Hyper-V Node 8" "HVNode8"

waitForPSDirect "Hyper-V Node 8" -cred $domainCred

icm -VMName "Management Console" -Credential $domainCred {
param ($domainName)
do {New-Cluster -Name HVCluster -Node HVNode1,HVNode2,HVNode3,HVNode4,HVNode5,HVNode6,HVNode7,HVNode8 -NoStorage} until ($?)
while (!(Test-Connection -Computername "S2DCluster.$($domainName)" -BufferSize 16 -Count 1 -Quiet -ea SilentlyContinue)) 
      {ipconfig /flushdns; sleep -seconds 1}
} -ArgumentList $domainName

icm -VMName "Storage Node 1" -Credential $domainCred {
param ($domainName)
get-SmbShareAccess VHDX | Grant-SmbShareAccess -AccountName "$($domainName)\HVNode1$","$($domainName)\HVNode2$","$($domainName)\HVNode3$", `
                                             "$($domainName)\HVNode4$","$($domainName)\HVNode5$","$($domainName)\HVNode6$", `
                                             "$($domainName)\HVNode7$","$($domainName)\HVNode8$","$($domainName)\HVCluster$" `
                                             -AccessRight full -Confirm:$false

get-SmbShareAccess ClusQuorum | Grant-SmbShareAccess -AccountName "$($domainName)\HVNode1$","$($domainName)\HVNode2$","$($domainName)\HVNode3$", `
                                             "$($domainName)\HVNode4$","$($domainName)\HVNode5$","$($domainName)\HVNode6$", `
                                             "$($domainName)\HVNode7$","$($domainName)\HVNode8$","$($domainName)\HVCluster$" `
                                             -AccessRight full -Confirm:$false

get-SmbShareAccess ClusData | Grant-SmbShareAccess -AccountName "$($domainName)\HVNode1$","$($domainName)\HVNode2$","$($domainName)\HVNode3$", `
                                             "$($domainName)\HVNode4$","$($domainName)\HVNode5$","$($domainName)\HVNode6$", `
                                             "$($domainName)\HVNode7$","$($domainName)\HVNode8$","$($domainName)\HVCluster$" `
                                             -AccessRight full -Confirm:$false

Set-SmbPathAcl -ShareName VHDX
Set-SmbPathAcl -ShareName ClusQuorum
Set-SmbPathAcl -ShareName ClusData
} -ArgumentList $domainName

icm -VMName "Management Console" -Credential $domainCred {
param ($domainName)
Set-ClusterQuorum -Cluster HVCluster -NodeAndFileShareMajority "\\S2DFileServer.$($domainName)\ClusQuorum"
} -ArgumentList $domainName

cleanupFile "$($VMPath)\ConHost - Diff.vhdx"
New-VHD -Path "$($VMPath)\ConHost - Diff.vhdx" -ParentPath "$($VMPath)\ConHost.vhdx" -Differencing | Out-Null

Add-VMHardDiskDrive -VMName "Hyper-V Node 1" -Path "$($VMPath)\ConHost - Diff.vhdx"

icm -VMName "Hyper-V Node 1" -Credential $domainCred {while ((get-disk).Count -ne 2) {start-sleep 1}
                                                      New-VHD -path "\\s2dfileserver\vhdx\ContainerBase.VHDX" -Dynamic -SourceDisk 1}

foreach ($i in 1..8) {

icm -VMName "Hyper-V Node $($i)" -Credential $domainCred {
param ($k, $domainName, $localCred)
Set-VMHost -VirtualHardDiskPath "\\S2DFileServer.$($domainName)\VHDX" `
           -VirtualMachinePath "\\S2DFileServer.$($domainName)\VHDX" 
$j = $k - 1
   do {New-VHD -Path "\\s2dfileserver\vhdx\Container Host $($j).VHDX" -ParentPath "\\s2dfileserver\vhdx\ContainerBase.VHDX" -Differencing -ea 0| Out-Null} until ($?)
   do {new-vm -Name "Container Host $($j)" -MemoryStartupBytes 768MB -SwitchName "Virtual Switch" `
          -VHDPath "\\s2dfileserver\vhdx\Container Host $($j).VHDX" -Generation 2 -ea 0} until ($?)
          Set-VM -name "Container Host $($j)" -ProcessorCount 2
          Get-VMNetworkAdapter -VMName "Container Host $($j)" | Set-VMNetworkAdapter -MacAddressSpoofing on
          start-vm "Container Host $($j)"
   New-VHD -Path "\\s2dfileserver\vhdx\Container Host $($k).VHDX" -ParentPath "\\s2dfileserver\vhdx\ContainerBase.VHDX" -Differencing | Out-Null
   do {new-vm -Name "Container Host $($k)" -MemoryStartupBytes 768MB -SwitchName "Virtual Switch" `
          -VHDPath "\\s2dfileserver\vhdx\Container Host $($k).VHDX" -Generation 2 -ea 0} until ($?)
          Set-VM -Name "Container Host $($k)" -ProcessorCount 2
          Get-VMNetworkAdapter -VMName "Container Host $($k)" | Set-VMNetworkAdapter -MacAddressSpoofing on
          start-vm "Container Host $($k)"
   while ((icm -VMName "Container Host $($k)" -Credential $localCred {"Test"} -ea SilentlyContinue) -ne "Test") {Sleep -Seconds 1}

   icm -VMName "Container Host $($j)" -Credential $localCred {
param ($containerNo)
if ((Get-VMSwitch | ? name -eq "Virtual Switch") -eq $null)
{
New-VMSwitch -Name "Virtual Switch" -NetAdapterName "Ethernet" -AllowManagementOS $true
}
New-Container -Name "IIS$($containerNo-3)" -ContainerImageName "IIS"
$cnMac = "00-b5-5d-fe-f6-" + (($containerNo-3) % 100).ToString("00")
Add-ContainerNetworkAdapter -ContainerName "IIS$($containerNo-3)" -SwitchName "Virtual Switch" -StaticMacAddress $cnMac
start-container "IIS$($containerNo-3)"

New-Container -Name "IIS$($containerNo-2)" -ContainerImageName "IIS"
$cnMac = "00-b5-5d-fe-f6-" + (($containerNo-2) % 100).ToString("00")
Add-ContainerNetworkAdapter -ContainerName "IIS$($containerNo-2)" -SwitchName "Virtual Switch" -StaticMacAddress $cnMac
# start-container "IIS$($containerNo-2)"

New-Container -Name "IIS$($containerNo-1)" -ContainerImageName "IIS"
$cnMac = "00-b5-5d-fe-f6-" + (($containerNo-1) % 100).ToString("00")
Add-ContainerNetworkAdapter -ContainerName "IIS$($containerNo-1)" -SwitchName "Virtual Switch" -StaticMacAddress $cnMac
# start-container "IIS$($containerNo-1)"

New-Container -Name "IIS$($containerNo)" -ContainerImageName "IIS"
$cnMac = "00-b5-5d-fe-f6-" + (($containerNo) % 100).ToString("00")
Add-ContainerNetworkAdapter -ContainerName "IIS$($containerNo)" -SwitchName "Virtual Switch" -StaticMacAddress $cnMac
# start-container "IIS$($containerNo)"
} -ArgumentList ($j*4)

icm -VMName "Container Host $($k)" -Credential $localCred {
param ($containerNo)
if ((Get-VMSwitch | ? name -eq "Virtual Switch") -eq $null)
{
New-VMSwitch -Name "Virtual Switch" -NetAdapterName "Ethernet" -AllowManagementOS $true
}
New-Container -Name "IIS$($containerNo-3)" -ContainerImageName "IIS"
$cnMac = "00-b5-5d-fe-f6-" + (($containerNo-3) % 100).ToString("00")
Add-ContainerNetworkAdapter -ContainerName "IIS$($containerNo-3)" -SwitchName "Virtual Switch" -StaticMacAddress $cnMac
start-container "IIS$($containerNo-3)"

New-Container -Name "IIS$($containerNo-2)" -ContainerImageName "IIS"
$cnMac = "00-b5-5d-fe-f6-" + (($containerNo-2) % 100).ToString("00")
Add-ContainerNetworkAdapter -ContainerName "IIS$($containerNo-2)" -SwitchName "Virtual Switch" -StaticMacAddress $cnMac
# start-container "IIS$($containerNo-2)"

New-Container -Name "IIS$($containerNo-1)" -ContainerImageName "IIS"
$cnMac = "00-b5-5d-fe-f6-" + (($containerNo-1) % 100).ToString("00")
Add-ContainerNetworkAdapter -ContainerName "IIS$($containerNo-1)" -SwitchName "Virtual Switch" -StaticMacAddress $cnMac
# start-container "IIS$($containerNo-1)"

New-Container -Name "IIS$($containerNo)" -ContainerImageName "IIS"
$cnMac = "00-b5-5d-fe-f6-" + (($containerNo) % 100).ToString("00")
Add-ContainerNetworkAdapter -ContainerName "IIS$($containerNo)" -SwitchName "Virtual Switch" -StaticMacAddress $cnMac
# start-container "IIS$($containerNo)"
} -ArgumentList ($k*4)
   } -ArgumentList ($i*2), $domainName, $localCred

icm -VMName "Management Console" -Credential $domainCred {
param ($k) 
$j = $k - 1
Add-VMToCluster -Cluster HVCluster -VMName "Container Host $($j)"
Add-VMToCluster -Cluster HVCluster -VMName "Container Host $($k)"} -ArgumentList ($i*2)
}

logger "Done" "Done!"
