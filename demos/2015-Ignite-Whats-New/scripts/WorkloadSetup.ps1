# Global Variables
$localCredDemo = new-object -typename System.Management.Automation.PSCredential `
             -argumentlist "Demo", (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)
$localCred = new-object -typename System.Management.Automation.PSCredential `
             -argumentlist "Administrator", (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)
$domainCred = new-object -typename System.Management.Automation.PSCredential `
              -argumentlist "Ignite\Administrator", (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)
$VMPath = "C:\VMs"
$DomainControllerVMName = "Domain Controller"
$DomainControllerGuestName = "DC"
$VirtualSwitchName = "Virtual Switch"
$VLANID = 7

function waitForPSDirect([string]$VMName, $cred){
   Write-Output "[$($VMName)]:: Waiting for PowerShell Direct (using $($cred.username))"
   while ((icm -VMName $VMName -Credential $cred {"Test"} -ea SilentlyContinue) -ne "Test") {Sleep -Seconds 1}}

function rebootVM([string]$VMName){Write-Output "[$($VMName)]:: Rebooting"; stop-vm $VMName; start-vm $VMName}

function CreateBaseVM([string]$VMName, `
                      [string]$GuestOSName, `
                      [string]$IPAddress, `
                      [switch]$domainJoined, `
                      [switch]$Desktop, `
                      [switch]$enableHyperV, `
                      [switch]$enableClustering, `
                      [switch]$DomainController, `
                      [switch]$SOFSnode) {

   # Throw away old VM
   Write-Output "[$($VMName)]:: Removing old VM"
   get-vm $VMName -ErrorAction SilentlyContinue | stop-vm -TurnOff -Force -Passthru | remove-vm -Force
   if (test-path "$($VMPath)\$($GuestOSName).vhdx") {remove-item "$($VMPath)\$($GuestOSName).vhdx" -Force}

   # Clean up old domain entries
   if ($domainJoined) {
      Write-Output "[$($VMName)]:: Cleaning out old virtual machine domain entry"
      icm -VMName $DomainControllerVMName -Credential $domainCred {
         param($GuestOSName)
         Get-ADComputer -Filter * | ? Name -eq "$($GuestOSName)" | Remove-ADObject -Recursive -Confirm:$false
         } -ArgumentList $GuestOSName}

   # Make new VM
   Write-Output "[$($VMName)]:: Creating new differencing disk"
   if ($Desktop) {New-VHD -Path "$($VMPath)\$($GuestOSName).vhdx" -ParentPath "$($VMPath)\VMDesktopBase.vhdx" -Differencing | Out-Null}
            else {New-VHD -Path "$($VMPath)\$($GuestOSName).vhdx" -ParentPath "$($VMPath)\VMServerBase.vhdx" -Differencing | Out-Null}
   Write-Output "[$($VMName)]:: Creating virtual machine"
   new-vm -Name $VMName -MemoryStartupBytes 768mb -SwitchName $VirtualSwitchName `
          -VHDPath "$($VMPath)\$($GuestOSName).vhdx" -Generation 2  | Set-VM -ProcessorCount 2 -StaticMemory
   Write-Output "[$($VMName)]:: Setting VLAN on network adapter"
   Get-VMNetworkAdapter -VMName $VMName | Set-VMNetworkAdapterVlan -access -VlanId $VLANID
   Write-Output "[$($VMName)]:: Starting virtual machine"
   start-vm $VMName

   waitForPSDirect $VMName -cred $localCred

   # Set IP address & name
   icm -VMName $VMName -Credential $localCred {
      param($IPAddress, $GuestOSName, $domainJoined, $domainCred, $enableHyperV, $enableClustering, $DomainController, $VMName, $SOFSnode)
      Write-Output "[$($VMName)]:: Setting IP Address to $($IPAddress)"
      New-NetIPAddress -IPAddress $IPAddress -InterfaceAlias "Ethernet" -PrefixLength 24 | Out-Null
      Write-Output "[$($VMName)]:: Setting DNS Address"
      Get-DnsClientServerAddress | %{Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ServerAddresses 10.100.7.1}
      Write-Output "[$($VMName)]:: Renaming OS to `"$($GuestOSName)`""
      Rename-Computer $GuestOSName
      if ($enableHyperV) {
         Write-Output "[$($VMName)]:: Enabling Hyper-V"
         Install-WindowsFeature RSAT-Hyper-V-Tools | out-null
         dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All /NoRestart | out-null}
      if ($enableClustering) {
         Write-Output "[$($VMName)]:: Enabling Clustering"
         Install-WindowsFeature Failover-Clustering -IncludeManagementTools | out-null}
      if ($DomainController) {
         Write-Output "[$($VMName)]:: Enabling iSCSI, AD and DHCP"
         Add-WindowsFeature -Name FS-iSCSITarget-Server | out-null
         Install-WindowsFeature AD-Domain-Services, DHCP -IncludeManagementTools | out-null}
      if ($SOFSnode) {
         Write-Output "[$($VMName)]:: Enabling file services"
         Install-WindowsFeature File-Services, FS-FileServer -IncludeManagementTools | Out-Null}
      Write-Output "[$($VMName)]:: Configuring WSMAN Trusted hosts"
      Set-Item WSMan:\localhost\Client\TrustedHosts "*.ignite.demo" -Force
      Set-Item WSMan:\localhost\client\trustedhosts "10.100.7.*" -force -concatenate
      } -ArgumentList $IPAddress, $GuestOSName, $domainJoined, $domainCred, $enableHyperV, $enableClustering, $DomainController, $VMName, $SOFSnode

   if ($domainJoined) {
      # Reboot
      rebootVM $VMName; waitForPSDirect $VMName -cred $localCred

      icm -VMName $VMName -Credential $localCred {
         param($VMName, $domainCred)
         Write-Output "[$($VMName)]:: Joining domain as `"$($env:computername)`""
         while (!(Test-Connection -Computername 10.100.7.1 -BufferSize 16 -Count 1 -Quiet -ea SilentlyContinue)) {sleep -seconds 1}
         Add-Computer -DomainName Ignite.demo -Credential $domainCred
         } -ArgumentList $VMName, $domainCred

      # Reboot
      rebootVM $VMName; waitForPSDirect $VMName -cred $domainCred
      }

   # Setup domain controller
   if ($DomainController) {
      # Reboot
      rebootVM $VMName; waitForPSDirect $VMName -cred $localCred

      icm -VMName $VMName -Credential $localCred {
         param($VMName)
         Write-Output "[$($VMName)]:: Configuring DHCP Server"    
         Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias Ethernet
         Add-DhcpServerv4Scope -Name "IPv4 Network" -StartRange 10.100.7.100 -EndRange 10.100.7.200 -SubnetMask 255.255.255.0
         Write-Output "[$($VMName)]:: Installing Active Directory and promoting to domain controller"
         Install-ADDSForest -DomainName Ignite.demo -InstallDNS -NoDNSonNetwork -NoRebootOnCompletion `
                            -SafeModeAdministratorPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -confirm:$false
                            } -ArgumentList $VMName

      # Reboot
      rebootVM $VMName; waitForPSDirect $VMName -cred $domainCred

      icm -VMName $VMName -Credential $domainCred {
         param($VMName)
         Write-Output "[$($VMName)]:: Creating VHDXs for iSCSI targets"
         New-IscsiVirtualDisk C:\iSCSITargetDisks\Quorum.vhdx -Size 10GB | Out-Null
         New-IscsiVirtualDisk C:\iSCSITargetDisks\Data.vhdx -Size 120GB | Out-Null
         Write-Output "[$($VMName)]:: Creating iSCSI targets"
         New-IscsiServerTarget ISCSIQuorum -InitiatorIds "Iqn:iqn.1991-05.com.microsoft:sofs-n1.ignite.demo" | Out-Null
         New-IscsiServerTarget ISCSIData -InitiatorIds "Iqn:iqn.1991-05.com.microsoft:sofs-n1.ignite.demo" | Out-Null
         Write-Output "[$($VMName)]:: Mapping VHDX files to iSCSI targets"
         Add-IscsiVirtualDiskTargetMapping ISCSIQuorum C:\iSCSITargetDisks\Quorum.vhdx -lun 0 
         Add-IscsiVirtualDiskTargetMapping ISCSIData C:\iSCSITargetDisks\Data.vhdx -lun 0
         Write-Output "[$($VMName)]:: Setting DNS option on DHCP server"
         Set-DhcpServerV4OptionValue -DnsDomain Ignite.demo -DnsServer 10.100.7.1
         } -ArgumentList $VMName

      # Reboot
      rebootVM $VMName; waitForPSDirect $VMName -cred $domainCred

      icm -VMName $VMName -Credential $domainCred {
              param($VMName)
         Write-Output "[$($VMName)]:: Registering DHCP with AD"
         sleep -Seconds 60
         Add-DhcpServerInDC -DnsName "DC.Ignite.demo" -IPAddress "10.100.7.1"
      } -ArgumentList $VMName
      }

   if ($SOFSnode) {
      icm -VMName $VMName -Credential $domainCred {
         Set-Service MSiSCSI -StartupType automatic 
         Start-Service MSiSCSI 
         New-iSCSITargetPortal -TargetPortalAddress dc.ignite.demo 
         Get-iSCSITarget | Connect-iSCSITarget 
         Get-iSCSISession | Register-iSCSISession
         Get-Disk | ?{$_.BusType -eq "iSCSI"} | %{
            $d = "WXYZ"[$_.Number]
            Set-Disk -Number $_.Number -IsReadOnly 0 
            Set-Disk -Number $_.Number -IsOffline 0 
            Initialize-Disk -Number $_.Number -PartitionStyle MBR 
            New-Partition -DiskNumber $_.Number -UseMaximumSize | Set-Partition -NewDriveLetter $d  
            Initialize-Volume -DriveLetter $d -FileSystem NTFS -Confirm:$false}
         New-Cluster -Name SOFS -Node $env:COMPUTERNAME -StaticAddress 10.100.7.3 
         Get-Disk | ?{$_.BusType -eq "iSCSI"} | Add-ClusterDisk
         Get-ClusterResource | ? Name -eq "Cluster Disk 1" | %{Set-ClusterQuorum -DiskWitness $_}
         Get-ClusterResource | ? Name -eq "Cluster Disk 2" | Add-ClusterSharedVolume
         Add-ClusterScaleOutFileServerRole -Name SOFS-FS

         MD C:\ClusterStorage\Volume1\VHDX
         New-SmbShare -Name VHDX -Path C:\ClusterStorage\Volume1\VHDX -FullAccess Ignite.demo\administrator
         Set-SmbPathAcl -ShareName VHDX

         MD C:\ClusterStorage\Volume1\ClusQuorum
         New-SmbShare -Name ClusQuorum -Path C:\ClusterStorage\Volume1\ClusQuorum -FullAccess Ignite.demo\administrator
         Set-SmbPathAcl -ShareName ClusQuorum

         MD C:\ClusterStorage\Volume1\ClusData
         New-SmbShare -Name ClusData -Path C:\ClusterStorage\Volume1\ClusData -FullAccess Ignite.demo\administrator
         Set-SmbPathAcl -ShareName ClusData}
         }


   if ($domainJoined -or $DomainController) {waitForPSDirect $VMName -cred $domainCred}
   else {waitForPSDirect $VMName -cred $localCred}
   }

Function BuildBaseImages {

$ServerWim = "D:\Build\Builds\FBL_IMPRESSIVE10074.0.150424-1350\10074.0.150424-1350.FBL_IMPRESSIVE_SERVER_OEMRET_X64FRE_EN-US.WIM"
$DesktopWim = "D:\Build\Builds\FBL_IMPRESSIVE10074.0.150424-1350\10074.0.150424-1350.FBL_IMPRESSIVE_CLIENTPRO-CORE_OEMRET_X64FRE_EN-US.wim"

D:\Build\Scripts\Convert-WindowsImage.ps1 -SourcePath $DesktopWim -VHDPath "$($VMPath)\VMDesktopBase.vhdx" `
                                          -SizeBytes 40GB -VHDFormat VHDX -UnattendPath D:\Build\Unattends\unattendDesktopFull.xml `
                                          -Edition "Windows 10 Pro Technical Preview" -VHDPartitionStyle GPT

D:\Build\Scripts\Convert-WindowsImage.ps1 -SourcePath $ServerWim -VHDPath "$($VMPath)\VMServerBase.vhdx" `
                                          -SizeBytes 40GB -VHDFormat VHDX -UnattendPath D:\Build\Unattends\unattendServerFull.xml `
                                          -Edition "ServerDataCenter" -VHDPartitionStyle GPT
}

Function BuildVMsForLaptop2 {

   CreateBaseVM -VMName $DomainControllerVMName -GuestOSName $DomainControllerGuestName -IPAddress "10.100.7.1" -DomainController
   CreateBaseVM -VMName "SOFS Cluster Node 1" -GuestOSName "SOFS-N1" -IPAddress "10.100.7.2" -domainJoined -SOFSnode -enableClustering
   CreateBaseVM -VMName "Workload" -GuestOSName "Workload" -IPAddress "10.100.7.13"
   CreateBaseVM -VMName "Cluster Node 1" -GuestOSName "ClusNode1" -IPAddress "10.100.7.4" -enableHyperV -enableClustering -domainJoined
   CreateBaseVM -VMName "Cluster Node 2" -GuestOSName "ClusNode2" -IPAddress "10.100.7.5" -enableHyperV -enableClustering -domainJoined
   CreateBaseVM -VMName "Replica Target" -GuestOSName "Replica" -IPAddress "10.100.7.8" -enableHyperV -domainJoined
   CreateBaseVM -VMName "Protected Workload" -GuestOSName "vTPM" -IPAddress "10.100.7.12" -Desktop 

   invoke-command -VMName "Cluster Node 1" -Credential $domainCred {
   new-cluster -name "Demo-Cluster" -Node ClusNode1, ClusNode2 -NoStorage -staticAddress 10.100.7.6
   Set-ClusterQuorum -Cluster ClusNode1 -NodeAndFileShareMajority \\sofs-fs.ignite.demo\ClusQuorum}
}

Function BuildVMsForLaptop1 {

   CreateBaseVM -VMName "Hyper-V Management" -GuestOSName "HVManager" -IPAddress "10.100.7.7" -enableHyperV
   CreateBaseVM -VMName "Hot Add & Remove" -GuestOSName "HotAddRemove" -IPAddress "10.100.7.15" -Desktop 
   CreateBaseVM -VMName "Different Checkpoints" -GuestOSName "Checkpoint" -IPAddress "10.100.7.14" -Desktop 
   
   #Build old VM
   $VMName = "Old Virtual Machine"
   $GuestOSName = "OldVM"

   Write-Output "[$($VMName)]:: Removing old VM"
   get-vm $VMName -ErrorAction SilentlyContinue | stop-vm -TurnOff -Force -Passthru | remove-vm -Force
   if (test-path "$($VMPath)\$($GuestOSName).vhdx") {remove-item "$($VMPath)\$($GuestOSName).vhdx" -Force}

   import-vm -Copy -Path "D:\Build\VMs\Old Virtual Machine\Virtual Machines\EBF49DE2-966B-4806-A9D0-5F33939AC6C0.xml" | set-vm -NewVMName $VMName
   new-vhd -path "$($VMPath)\$($GuestOSName).vhdx" -ParentPath "D:\build\BaseVHDs\Old Virtual Machine.vhdx" | Out-Null
   Add-VMHardDiskDrive -VMName $VMName -path "$($VMPath)\$($GuestOSName).vhdx"
   start-vm $VMName

   #Build Ubuntu VM
   $VMName = "Ubuntu"
   $GuestOSName = "Ubuntu"

   Write-Output "[$($VMName)]:: Removing old VM"
   get-vm $VMName -ErrorAction SilentlyContinue | stop-vm -TurnOff -Force -Passthru | remove-vm -Force
   if (test-path "$($VMPath)\$($GuestOSName).vhdx") {remove-item "$($VMPath)\$($GuestOSName).vhdx" -Force}

   new-vhd -path "$($VMPath)\$($GuestOSName).vhdx" -ParentPath "D:\Build\BaseVHDs\Ubuntu 14.vhdx" | Out-Null
   new-vm -Name $VMName -MemoryStartupBytes 750mb -SwitchName $VirtualSwitchName `
          -VHDPath "$($VMPath)\$($GuestOSName).vhdx" -Generation 2  | Set-VM -ProcessorCount 2 -StaticMemory -Passthru | `
          Set-VMFirmware -SecureBootTemplate MicrosoftUEFICertificateAuthority
   start-vm $VMName
}

get-vm | stop-vm -Force

BuildBaseImages
BuildVMsForLaptop1

