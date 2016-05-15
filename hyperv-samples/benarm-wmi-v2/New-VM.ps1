# Prompt for the Hyper-V Server to use
$HyperVServer = Read-Host "Specify the Hyper-V Server to create the virtual machine on"
 
# Get name for new VM
$VMName = Read-Host "Specify the name for the new virtual machine"
 
# Create new MSVM_VirtualSystemSettingData object
$wmiClassString = "\\" + $HyperVServer + "\root\virtualization\v2:Msvm_VirtualSystemSettingData"
$wmiClass = [WMIClass]$wmiClassString
$newVSSD = $wmiClass.CreateInstance()
 
# wait for the new object to be populated
while ($newVSSD.Properties -eq $null) {}
 
# Set the VM name
$newVSSD.Properties.Item("ElementName").value = $VMName
 
# Get the VirtualSystemManagementService object
$VMMS  = Get-WmiObject MSVM_VirtualSystemManagementService -Namespace "root\virtualization\v2" -ComputerName $HyperVServer
 
# Create the VM
$result = $VMMS.DefineSystem($newVSSD.GetText(1))
 
#Return success if the return value is "0"
if ($Result.ReturnValue -eq 0)
{
    Write-Host "Virtual machine created."
}
 
#If the return value is not "0" or "4096" then the operation failed
elseif ($Result.ReturnValue -ne 4096)
{
    Write-Host "Failed to create virtual machine"
}
 
else
{
    
    #Get the job object
    $job=[WMI]$Result.job
 
    #Provide updates if the jobstate is "3" (starting) or "4" (running)
    while ($job.JobState -eq 3 -or $job.JobState -eq 4)
    {
       Write-Host $job.PercentComplete
       Start-Sleep 1
 
       #Refresh the job object
       $job=[WMI]$Result.job
    }
 
    #A jobstate of "7" means success
    if ($job.JobState -eq 7)
    {
        Write-Host "Virtual machine created."
    }
    else
    {
        Write-Host "Failed to create virtual machine"
        Write-Host "ErrorCode:" $job.ErrorCode
        Write-Host "ErrorDescription" $job.ErrorDescription
    }
}
