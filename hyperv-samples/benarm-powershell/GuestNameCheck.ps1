# Get the virtual machine name from the parent partition
<<<<<<< HEAD
$vmName = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters").VirtualMachineName

# Replace any non-alphanumeric characters with an underscore
$vmName = [Regex]::Replace($vmName, "\W","_")

# Trim names that are longer than 15 characters
$vmName = $vmName.Substring(0, [System.Math]::Min(15, $vmName.Length))
=======
 $vmName = (Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters").VirtualMachineName
 # Replace any non-alphanumeric characters with an underscore
 $vmName = [Regex]::Replace($vmName,"\W","_")
 # Trim names that are longer than 15 characters
 $vmName = $vmName.Substring(0,[System.Math]::Min(15, $vmName.Length))
>>>>>>> 9339480bc30c0fc1ee0a1d9f34a6a2b4d9df5202
  
# Check the trimmed and cleaned VM name against the guest OS name
# If it is different, change the guest OS name and reboot
if ($env:COMPUTERNAME -ne $vmName) 
{
    (Get-WmiObject Win32_ComputerSystem).Rename($vmName); shutdown -r -t 0
}