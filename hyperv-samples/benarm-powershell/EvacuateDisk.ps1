$sourcePath = "F:\"
$destinationPath = "D:\"

(Get-ChildItem $sourcePath -Recurse | Where-Object {$_.Attributes -ne "Directory"}).Count
  
Get-VM | foreach {
    
    $VM = $_
  
    # Check the configuration path
    $currentVMPath = $_.ConfigurationLocation
  
    if ($currentVMPath.StartsWith($sourcePath)) 
    {
        $newVMPath = ($destinationPath) + ($currentVMPath.TrimStart($sourcePath))
        Move-VMStorage -VM $VM -VirtualMachinePath $newVMPath
    }
  
    # Check the snapshot path
    $currentSnapshotFilePath = $_.SnapshotFileLocation 
  
    if ($currentSnapshotFilePath.StartsWith($sourcePath))
    {
        $newSnapshotFilePath = ($destinationPath) + ($currentSnapshotFilePath.TrimStart($sourcePath))
        Move-VMStorage -VM $VM -SnapshotFilePath $newSnapshotFilePath
    }
  
    # Check the smart paging file path
    $currentSmartPagingFilePath = $_.SmartPagingFilePath
  
    if ($currentSmartPagingFilePath.StartsWith($sourcePath))
    {
        $newSmartPagingFilePath = ($destinationPath) + ($currentSmartPagingFilePath.TrimStart($sourcePath))
        Move-VMStorage -VM $VM -SmartPagingFilePath $newSmartPagingFilePath
    }
  
    # Go over each hard drive
    $_.HardDrives | foreach {

        # Check the hard drive
        $currentHardDrivePath = $_.Path
  
        if ($currentHardDrivePath.StartsWith($sourcePath)) 
        {
            $newHardDrivePath = ($destinationPath) + ($currentHardDrivePath.TrimStart($sourcePath))
            Move-VMStorage -VM $VM -VHDs @(@{"SourceFilePath" = $currentHardDrivePath; "DestinationFilePath" = $newHardDrivePath})}
        }
  
}

(Get-ChildItem $sourcePath -Recurse | Where-Object {$_.Attributes -ne "Directory"}).count