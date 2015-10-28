# Scooley's easy PS Direct Demo

What it does:  Start IIS in a virtual machine of your choice.

## VM Prep Steps
Start the VM and set admin credentials for some user account.

## Variables you need to customize

**Creds**
* `$username` - name of an Admin user
* `$pass` - Admin user pass in plain text because this is for demos only

**Paths and names**
* `$vmname` - name of the virtual machine to configure as an IIS Server
* `$clean` - name of snapshot to revert to before and after the demo
* `$sitepath` - location of your site folder on the host OS

**Guest functions**