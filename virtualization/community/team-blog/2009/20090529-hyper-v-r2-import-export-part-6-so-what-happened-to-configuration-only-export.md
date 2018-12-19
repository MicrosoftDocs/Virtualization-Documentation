---
layout:     post
title:      "Hyper-V R2 Import/Export – Part 6 - So, what happened to Configuration-only export?"
date:       2009-05-29 10:32:00
categories: uncategorized
---
There have been multiple customers who have voiced concern that the Configuration-only export feature is gone. It has not. Configuration-only export is still very much present in Hyper-V in R2. It just so happens that we have taken the option out from the UI. The user can still utilize this capability via the API. 

This brings us to the next question: “Why did you take it out of the UI?” The main motivation behind taking it out of the UI is that the user would not be able to easily import such a VM through the UI. Given our import UI, there is no way for the user to specify the locations of the VHD files during import. Ideally, we would have had an import wizard or the like where the user could specify the location of all the VHD files before launching the import process. However, short of that, it is best not to expose any of that functionality via the UI.

The ability to do a configuration-only export of a VM is available via SCVMM R2, which is built to use the new API. However, if you are not using SCVMM, you can script against that API. Here are a couple of sample scripts (VBScript) for doing the configuration-only export of a VM and for importing that VM. Many thanks to Madhan Gajendran and Dinesh Kumar Govindasamy for writing these scripts:

_**Exporting config-only**_
    
    
     option explicit 
    
    
     
    
    
    dim objWMIService
    
    
    dim managementService
    
    
    dim fileSystem
    
    
     
    
    
    const JobStarting = 3
    
    
    const JobRunning = 4
    
    
    const JobCompleted = 7
    
    
    const wmiStarted = 4096
    
    
    const wmiSuccessful = 0
    
    
     
    
    
    Main()
    
    
     
    
    
     
    
    
    '-----------------------------------------------------------------
    
    
    ' Main
    
    
    '-----------------------------------------------------------------
    
    
    Sub Main()
    
    
     
    
    
        dim computer, objArgs, vmName, vm, exportDirectory
    
    
        
    
    
        set fileSystem = Wscript.CreateObject("Scripting.FileSystemObject")
    
    
        computer = "."
    
    
        set objWMIService = GetObject("winmgmts:\\" & computer & "\root\virtualization")
    
    
        set managementService = objWMIService.ExecQuery("select * from Msvm_VirtualSystemManagementService").ItemIndex(0)
    
    
        
    
    
        set objArgs = WScript.Arguments
    
    
        if WScript.Arguments.Count = 2 then
    
    
            vmName = objArgs.Unnamed.Item(0)
    
    
            exportDirectory = objArgs.Unnamed.Item(1)
    
    
        else
    
    
            WScript.Echo "usage: cscript ExportVirtualSystemEx.vbs vmName exportDirectoryName"
    
    
            WScript.Quit(1)
    
    
        end if
    
    
        
    
    
        set vm = GetComputerSystem(vmName)
    
    
     
    
    
        if ExportVirtualSystemEx(vm, exportDirectory) then
    
    
            WriteLog "Done"
    
    
            WScript.Quit(0)
    
    
        else
    
    
            WriteLog "ExportVirtualSystemEx Failed."
    
    
            WScript.Quit(1)
    
    
        end if
    
    
    End Sub
    
    
     
    
    
    '-----------------------------------------------------------------
    
    
    ' Retrieve Msvm_VirtualComputerSystem from base on its ElementName
    
    
    '-----------------------------------------------------------------
    
    
    Function GetComputerSystem(vmElementName)
    
    
        On Error Resume Next
    
    
        dim query
    
    
        query = Format1("select * from Msvm_ComputerSystem where ElementName = '{0}'", vmElementName)
    
    
        set GetComputerSystem = objWMIService.ExecQuery(query).ItemIndex(0)
    
    
        if (Err.Number <> 0) then
    
    
            WriteLog Format1("Err.Number: {0}", Err.Number)
    
    
            WriteLog Format1("Err.Description:{0}",Err.Description)
    
    
            WScript.Quit(1)
    
    
        end if
    
    
    End Function
    
    
     
    
    
    '-----------------------------------------------------------------
    
    
    ' Export a virtual system
    
    
    '-----------------------------------------------------------------
    
    
    Function ExportVirtualSystemEx(computerSystem, exportDirectory)
    
    
     
    
    
        dim objInParam, objOutParams 
    
    
        dim query
    
    
        dim computer
    
    
        dim exportSettingData
    
    
     
    
    
        ExportVirtualSystemEx = false
    
    
        
    
    
        if Not fileSystem.FolderExists(exportDirectory) then
    
    
            fileSystem.CreateFolder(exportDirectory)
    
    
        end if
    
    
        
    
    
        set objInParam = managementService.Methods_("ExportVirtualSystemEx").InParameters.SpawnInstance_()
    
    
        objInParam.ComputerSystem = computerSystem.Path_.Path
    
    
     
    
    
        query = Format1("ASSOCIATORS OF {{0}} WHERE resultClass = Msvm_VirtualSystemExportSettingData", computerSystem.Path_.Path)
    
    
        set exportSettingData = objWMIService.ExecQuery(query).ItemIndex(0)
    
    
     
    
    
        'Dont copy the VHDs and AVHDs, but copy the Saved state information and Snapshot configurations if present
    
    
        exportSettingData.CopyVmStorage = false
    
    
        exportSettingData.CopyVmRuntimeInformation = true
    
    
        exportSettingData.CreateVmExportSubdirectory = true
    
    
        exportSettingData.CopySnapshotConfiguration = 0
    
    
     
    
    
        objInParam.ExportSettingData = exportSettingData.GetText_(1)
    
    
     
    
    
        objInParam.ExportDirectory = exportDirectory
    
    
        
    
    
        set objOutParams = managementService.ExecMethod_("ExportVirtualSystemEx", objInParam)
    
    
     
    
    
        if objOutParams.ReturnValue = wmiStarted then
    
    
            if (WMIJobCompleted(objOutParams)) then
    
    
                ExportVirtualSystemEx = true
    
    
            end if
    
    
        elseif (objOutParams.ReturnValue = wmiSuccessful) then
    
    
            ExportVirtualSystemEx = true
    
    
        else
    
    
            WriteLog Format1("ExportVirtualSystemEx failed with ReturnValue {0}", objOutParams.ReturnValue)
    
    
        end if
    
    
     
    
    
    End Function
    
    
     
    
    
    '-----------------------------------------------------------------
    
    
    ' Handle wmi Job object
    
    
    '-----------------------------------------------------------------
    
    
    Function WMIJobCompleted(outParam)
    
    
        
    
    
        dim WMIJob, jobState
    
    
     
    
    
        set WMIJob = objWMIService.Get(outParam.Job)
    
    
     
    
    
        WMIJobCompleted = true
    
    
     
    
    
        jobState = WMIJob.JobState
    
    
     
    
    
        while jobState = JobRunning or jobState = JobStarting
    
    
            WriteLog Format1("In progress... {0}% completed.",WMIJob.PercentComplete)
    
    
            WScript.Sleep(1000)
    
    
            set WMIJob = objWMIService.Get(outParam.Job)
    
    
            jobState = WMIJob.JobState
    
    
        wend
    
    
     
    
    
        if (jobState <> JobCompleted) then
    
    
            WriteLog Format1("ErrorCode:{0}", WMIJob.ErrorCode)
    
    
            WriteLog Format1("ErrorDescription:{0}", WMIJob.ErrorDescription)
    
    
            WMIJobCompleted = false
    
    
        end if
    
    
     
    
    
    End Function
    
    
     
    
    
    '-----------------------------------------------------------------
    
    
    ' Create the console log files.
    
    
    '-----------------------------------------------------------------
    
    
    Sub WriteLog(line)
    
    
        dim fileStream
    
    
        set fileStream = fileSystem.OpenTextFile(".\ExportVirtualSystemExLog.log", 8, true)
    
    
        WScript.Echo line
    
    
        fileStream.WriteLine line
    
    
        fileStream.Close
    
    
     
    
    
    End Sub
    
    
     
    
    
    '------------------------------------------------------------------------------
    
    
    ' The string formating functions to avoid string concatenation.
    
    
    '------------------------------------------------------------------------------
    
    
    Function Format2(myString, arg0, arg1)
    
    
        Format2 = Format1(myString, arg0)
    
    
        Format2 = Replace(Format2, "{1}", arg1)
    
    
    End Function
    
    
     
    
    
    '------------------------------------------------------------------------------
    
    
    ' The string formating functions to avoid string concatenation.
    
    
    '------------------------------------------------------------------------------
    
    
    Function Format1(myString, arg0)
    
    
        Format1 = Replace(myString, "{0}", arg0)
    
    
    End Function

_****_

_****_

**__**

**_Importing a VM that was exported config only_**

The VM exported above can be imported via the following script. Please note that what this script does is to provide a fine-grained control over the different parameters of import and thus can be used for importing a VM regardless of how it was exported (config-only or with VHDs). It just so happens that it is particularly useful for importing a VM that was exported config-only.
    
    
    option explicit 
    
    
     
    
    
    dim objWMIService
    
    
    dim managementService
    
    
    dim switchService
    
    
    dim fileSystem
    
    
     
    
    
    const JobStarting = 3
    
    
    const JobRunning = 4
    
    
    const JobCompleted = 7
    
    
    const wmiStarted = 4096
    
    
    const wmiSuccessful = 0
    
    
     
    
    
    Main()
    
    
     
    
    
    '-----------------------------------------------------------------
    
    
    ' Main
    
    
    '-----------------------------------------------------------------
    
    
    Sub Main()
    
    
        dim computer, objArgs, importDirectory, generateNewID
    
    
        
    
    
        set fileSystem = Wscript.CreateObject("Scripting.FileSystemObject")
    
    
        computer = "."
    
    
        set objWMIService = GetObject("winmgmts:\\" & computer & "\root\virtualization")
    
    
        set managementService = objWMIService.ExecQuery("select * from Msvm_VirtualSystemManagementService").ItemIndex(0)
    
    
        set switchService = objWMIService.ExecQuery("select * from Msvm_VirtualSwitchManagementService").ItemIndex(0)
    
    
     
    
    
        
    
    
        set objArgs = WScript.Arguments
    
    
        if WScript.Arguments.Count = 1 then
    
    
            importDirectory = objArgs.Unnamed.Item(0)
    
    
        else
    
    
            WScript.Echo "usage: cscript ImportVirtualSystemEx-ConfigOnly.vbs importDirectoryName"
    
    
            WScript.Quit(1)
    
    
        end if
    
    
       
    
    
        if ImportVirtualSystemEx(importDirectory) then
    
    
            WriteLog "Done"
    
    
            WScript.Quit(0)
    
    
        else
    
    
            WriteLog "ImportVirtualSystemEx Failed."
    
    
            WScript.Quit(1)
    
    
        end if
    
    
    End Sub
    
    
     
    
    
     
    
    
    '-----------------------------------------------------------------
    
    
    ' GetVirtualSystemImportSettingData from a directory
    
    
    '-----------------------------------------------------------------
    
    
    Function GetVirtualSystemImportSettingData(importDirectory)
    
    
     
    
    
        dim objInParam, objOutParams    
    
    
     
    
    
        set objInParam = managementService.Methods_("GetVirtualSystemImportSettingData").InParameters.SpawnInstance_()
    
    
        objInParam.ImportDirectory = importDirectory
    
    
     
    
    
        set objOutParams = managementService.ExecMethod_("GetVirtualSystemImportSettingData", objInParam)
    
    
        
    
    
        if objOutParams.ReturnValue = wmiStarted then
    
    
            if (WMIJobCompleted(objOutParams)) then
    
    
                set GetVirtualSystemImportSettingData = objOutParams.ImportSettingData
    
    
            end if
    
    
        elseif objOutParams.ReturnValue = wmiSuccessful then
    
    
            set GetVirtualSystemImportSettingData = objOutParams.ImportSettingData
    
    
        else
    
    
            WriteLog Format1("GetVirtualSystemImportSettingData failed with ReturnValue {0}", objOutParams.ReturnValue)
    
    
        end if
    
    
     
    
    
    End Function
    
    
    '-----------------------------------------------------------------
    
    
    ' ImportVirtualSystem from a directory
    
    
    '-----------------------------------------------------------------
    
    
    Function ImportVirtualSystemEx(importDirectory)
    
    
     
    
    
        dim objInParam, objOutParams
    
    
        dim newDataRoot
    
    
        dim importSettingData
    
    
        dim newSourceResourcePaths, newTargetNetworkConnections, newSwitch    
    
    
     
    
    
        'Resources in newSourceResourcePaths below should be existing. Fill this with the resources corresponding to those in CurrentResourcePaths
    
    
        newSourceResourcePaths = Array(1)
    
    
        newSourceResourcePaths(0) = importDirectory & "\VM.vhd"
    
    
     
    
    
        ImportVirtualSystemEx = false
    
    
        set objInParam = managementService.Methods_("ImportVirtualSystemEx").InParameters.SpawnInstance_()
    
    
        objInParam.ImportDirectory = importDirectory
    
    
     
    
    
        set importSettingData = GetVirtualSystemImportSettingData(importDirectory)
    
    
        importSettingData.GenerateNewId = true
    
    
        importSettingData.CreateCopy = false
    
    
        importSettingData.Name = "NewSampleVM-ConfigOnlyImport"
    
    
        importSettingData.SourceResourcePaths = newSourceResourcePaths
    
    
        importSettingData.Put_
    
    
     
    
    
        objInParam.ImportSettingData = importSettingData.GetText_(1)
    
    
        
    
    
        set objOutParams = managementService.ExecMethod_("ImportVirtualSystemEx", objInParam)
    
    
     
    
    
        if objOutParams.ReturnValue = wmiStarted then
    
    
            if (WMIJobCompleted(objOutParams)) then
    
    
                ImportVirtualSystemEx = true
    
    
            end if
    
    
        elseif objOutParams.ReturnValue = wmiSuccessful then
    
    
            ImportVirtualSystemEx = true
    
    
        else
    
    
            WriteLog Format1("ImportVirtualSystemEx failed with ReturnValue {0}", objOutParams.ReturnValue)
    
    
        end if
    
    
     
    
    
    End Function
    
    
     
    
    
     
    
    
    '-----------------------------------------------------------------
    
    
    ' Handle wmi Job object
    
    
    '-----------------------------------------------------------------
    
    
    Function WMIJobCompleted(outParam)
    
    
     
    
    
        dim WMIJob, jobState
    
    
     
    
    
        set WMIJob = objWMIService.Get(outParam.Job)
    
    
     
    
    
        WMIJobCompleted = true
    
    
     
    
    
        jobState = WMIJob.JobState
    
    
     
    
    
        while jobState = JobRunning or jobState = JobStarting
    
    
            WriteLog Format1("In progress... {0}% completed.",WMIJob.PercentComplete)
    
    
            WScript.Sleep(1000)
    
    
            set WMIJob = objWMIService.Get(outParam.Job)
    
    
            jobState = WMIJob.JobState
    
    
        wend
    
    
     
    
    
        if (jobState <> JobCompleted) then
    
    
            WriteLog Format1("ErrorCode:{0}", WMIJob.ErrorCode)
    
    
            WriteLog Format1("ErrorDescription:{0}", WMIJob.ErrorDescription)
    
    
            WMIJobCompleted = false
    
    
        end if
    
    
     
    
    
    End Function
    
    
     
    
    
    '-----------------------------------------------------------------
    
    
    ' Create the console log files.
    
    
    '-----------------------------------------------------------------
    
    
    Sub WriteLog(line)
    
    
        dim fileStream
    
    
        set fileStream = fileSystem.OpenTextFile(".\ImportVirtualSystemEx-ConfigOnly.log", 8, true)
    
    
        WScript.Echo line
    
    
        fileStream.WriteLine line
    
    
        fileStream.Close
    
    
     
    
    
    End Sub
    
    
     
    
    
    '------------------------------------------------------------------------------
    
    
    ' The string formating functions to avoid string concatenation.
    
    
    '------------------------------------------------------------------------------
    
    
    Function Format1(myString, arg0)
    
    
        Format1 = Replace(myString, "{0}", arg0)
    
    
    End Function
