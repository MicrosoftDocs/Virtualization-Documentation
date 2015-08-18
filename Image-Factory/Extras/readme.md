# Extras

These scripts are examples you can use or modify to control the factory process. They should be placed in the `Resources\Bits` directory. 

There are hooks in various parts of the script to allow you to customize the process.

## PreUpdateScript.ps1
**Runs on virtual machine**

Called every time virtual machine boots up to install new updates, before the update process starts.
May be called multiple times, if the updates require multiple reboots.

Useful for configuring network settings - see the example in `StaticIPAddress`

## PostUpdateScript.ps1
**Runs on virtual machine**

Called just before the virtual machine reboots or shuts down after each round of installing updates.

## PreSysprepScript.ps1
**Runs on the virtual machine**

Called just before sysprep is run to create the final VHD.  Only runs once, and only affects the final VHD, not the base.

This would be a good place to do something like "dism.exe /Online /Disable-Feature /featurename:<something> /Remove" to remove windows
features you're sure you'll never need, if you want to save more disk space.

## PostSysprepScript.ps1
**Runs on the final deployed machine**

Called on the first boot of the deployed machine, before removing the \Bits directory
Not called if using GenericSysprep.

