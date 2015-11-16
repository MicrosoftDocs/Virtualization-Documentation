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
$VMMS  = gwmi MSVM_VirtualSystemManagementService -namespace "root\virtualization\v2" -computername $HyperVServer
 
# Create the VM
$result = $VMMS.DefineSystem($newVSSD.GetText(1))
 
#Return success if the return value is "0"
if ($Result.ReturnValue -eq 0)
   {write-host "Virtual machine created."} 
 
#If the return value is not "0" or "4096" then the operation failed
ElseIf ($Result.ReturnValue -ne 4096)
   {write-host "Failed to create virtual machine"}
 
  Else
   {#Get the job object
    $job=[WMI]$Result.job
 
    #Provide updates if the jobstate is "3" (starting) or "4" (running)
    while ($job.JobState -eq 3 -or $job.JobState -eq 4)
      {write-host $job.PercentComplete
       start-sleep 1
 
       #Refresh the job object
       $job=[WMI]$Result.job}
 
     #A jobstate of "7" means success
    if ($job.JobState -eq 7)
       {write-host "Virtual machine created."}
      Else
       {write-host "Failed to create virtual machine"
        write-host "ErrorCode:" $job.ErrorCode
        write-host "ErrorDescription" $job.ErrorDescription}
   }
