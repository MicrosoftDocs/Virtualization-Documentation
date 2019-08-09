Function Expand-VMConfig ($VMConfig) {
    $tempVM = (Compare-VM -Copy -Path $VMConfig -GenerateNewID).VM

    Write-Host "VM Configuration Data"
    Write-Host "====================="
    $tempVM | Select *

    Write-Host "VM Network Adapters"
    Write-Host "====================="
    $tempVM.NetworkAdapters

    Write-Host "VM Hard Drives"
    Write-Host "====================="
    $tempVM.HardDrives

    Write-Host "VM DVD Drives"
    Write-Host "====================="
    $tempVM.DVDDrives

    Write-Host "VM Floppy Drive"
    Write-Host "====================="
    $tempVM.FloppyDrive

    Write-Host "VM Fibre Channel"
    Write-Host "====================="
    $tempVM.FibreChannelHostBusAdapters

    Write-Host "VM COM1"
    Write-Host "====================="
    $tempVM.ComPort1

    Write-Host "VM COM2"
    Write-Host "====================="
    $tempVM.ComPort2}
