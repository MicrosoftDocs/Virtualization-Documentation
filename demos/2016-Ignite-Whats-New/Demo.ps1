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

function startEnvironment
{

foreach ($vm in $vms) {if ($vm.HVHost -eq ""){RestoreVMCheckpoint $VM "Phase 4"}}

start-vm "Domain Controller"
waitForPSDirect "Domain Controller" $domainCred

start-vm "Fileserver"
waitForPSDirect "FileServer" $domainCred

icm -VMName "Domain Controller" -Credential $domainCred {do {sleep -Seconds 1} until (test-path "\\sofs-fs\vhdx")
                                                         Stop-Service DHCPServer
                                                         Start-Service DHCPServer}

foreach ($vm in $vms) {if ($vm.HVHost -eq ""){start-vm $VM.VMName}}
}

function waitForPSDirect([string]$VMName, $cred){
   logger $VMName "Waiting for PowerShell Direct (using $($cred.username))"
   while ((icm -VMName $VMName -Credential $cred {"Test"} -ea SilentlyContinue) -ne "Test") {Sleep -Seconds 1}}

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

function startContainerEnvironment
{

foreach ($vm in $vms) {if ($vm.HVHost -eq ""){RestoreVMCheckpoint $VM "Phase 4"}}

start-vm "Domain Controller"
waitForPSDirect "Domain Controller" $domainCred

start-vm "Fileserver"
waitForPSDirect "FileServer" $domainCred

icm -VMName "Domain Controller" -Credential $domainCred {do {sleep -Seconds 1} until (test-path "\\sofs-fs\vhdx")
                                                         Stop-Service DHCPServer
                                                         Start-Service DHCPServer}

start-vm "Windows Containers"
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

function clusterGlitch {
icm -VMName "Hyper-V Cluster Node 2" -Credential $domainCred{
write-host "Press Enter to cause a problem..."
read-host
get-process clussvc | stop-process -Force
write-host "Press Enter to fix the problem..."
read-host
start-service clussvc
}
}

function Fileserver {
Enter-PSSession -VMName "Fileserver" -Credential $domainCred
}

function StorageQoS {
icm -VMName "Hyper-V Server" -Credential $domainCred{
write-host "Press Enter to apply first policy..."
read-host
Get-VMHardDiskDrive -VMName "Storage QOS 1" | ? path -eq \\sofs-fs\VHDX\Data1.vhdx | Set-VMHardDiskDrive -QoSPolicyID be436419-3385-42b4-9906-a5c369d51739
write-host "Press Enter to apply second policy..."
read-host
Get-VMHardDiskDrive -VMName "Storage QOS 2" | ? path -eq \\sofs-fs\VHDX\Data2.vhdx | Set-VMHardDiskDrive -QoSPolicyID be436419-3385-42b4-9906-a5c369d51739
write-host "Press Enter to clear policies..."
read-host
Get-VMHardDiskDrive -VMName "Storage QOS 2" | ? path -eq \\sofs-fs\VHDX\Data2.vhdx | Set-VMHardDiskDrive -QoSPolicyID $null
Get-VMHardDiskDrive -VMName "Storage QOS 1" | ? path -eq \\sofs-fs\VHDX\Data1.vhdx | Set-VMHardDiskDrive -QoSPolicyID $null
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

write-host "StopEnvironment StartEnvironment clusterGlitch Fileserver StorageQoS"