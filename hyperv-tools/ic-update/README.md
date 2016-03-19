# Integration component scripts

## offline-update-host.ps1
This script updates integration components in an offline VM from the Hyper-V host.

Parameters:
* `vhdPath` - Path to the virtual machine's VHD or VHDX.
* `cabPath` - Path to the cab file.  This should be the cab file with the appropriate integration components for the virtual machine.

## offline-update-guest.ps1
This script updates integration components in an offline VM from within the VM.

* `cabPath` - Path to the cab file.  This should be the cab file with the appropriate integration components for the virtual machine.
