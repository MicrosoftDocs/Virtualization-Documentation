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

**Guest functions - optional**
`guest2` customizes the site.  All files are pulled from the host so you don't need to change anything here but you can.


## VM Setup
For simplicity, I manually enabled the guest file copy IC.
I also enabled logging in as Administrator and my script is using the Administrator account.  Again, demo only.