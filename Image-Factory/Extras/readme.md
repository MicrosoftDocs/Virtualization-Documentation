# Extras

These scripts are examples you can use or modify to control the factory process.

They should be placed in the `Resources\Bits` directory, and are called in various parts of the script:

## PreUpdateScript.ps1

Called when the virtual machine boots up to install new updates, before the update process starts.
May be called multiple times, if the updates require multiple reboots.

Useful for configuring network settings - see the examples in `StaticIPAddress`

## PostUpdateScript.ps1

Called just before the virtual machine reboots or shuts down after installing updates.
