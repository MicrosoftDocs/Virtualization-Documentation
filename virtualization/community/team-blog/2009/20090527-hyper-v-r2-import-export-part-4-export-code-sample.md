---
layout:     post
title:      "Hyper-V R2 Import/Export – Part 4 – Export code sample"
date:       2009-05-27 11:33:00
categories: uncategorized
---
In the following sample, we do a basic export of a VM using the new Export API. Here we export a VM with all the data associated with it. In a later blog, I will cover configuration-only export. Many thanks to Madhan Gajendran and Dinesh Kumar Govindasamy from the Hyper-V team for writing this script:

 
    
    
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
    
    
        exportSettingData.CopyVmStorage = true
    
    
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
