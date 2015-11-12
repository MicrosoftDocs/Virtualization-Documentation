Function Expand-VMConfig ($VMConfig) {
    $tempVM = (Compare-VM -Copy -Path $VMConfig -GenerateNewID).VM

    write-host "VM Configuration Data"
    write-host "====================="
    $tempVM | Select *

    write-host "VM Network Adapters"
    write-host "====================="
    $tempVM.NetworkAdapters

    write-host "VM Hard Drives"
    write-host "====================="
    $tempVM.HardDrives

    write-host "VM DVD Drives"
    write-host "====================="
    $tempVM.DVDDrives

    write-host "VM Floppy Drive"
    write-host "====================="
    $tempVM.FloppyDrive

    write-host "VM Fibre Channel"
    write-host "====================="
    $tempVM.FibreChannelHostBusAdapters

    write-host "VM COM1"
    write-host "====================="
    $tempVM.ComPort1

    write-host "VM COM2"
    write-host "====================="
    $tempVM.ComPort2}
