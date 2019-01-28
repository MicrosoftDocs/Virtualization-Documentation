---
layout:     post
title:      "Hyper-V R2 Import/Export – Part 5 – Import code sample"
date:       2009-05-28 12:33:00
categories: uncategorized
---
In the following sample, we do a basic import of a VM using the new Import API. This script essentially does what the import UI does; it assumes all the necessary files are present in the import folder and imports from that directory. In a later blog, there will be a sample that will utilize the fine grained capabilities of import in Hyper-V R2. Many thanks to Madhan Gajendran and Dinesh Kumar Govindasamy again for writing this script:
    
    
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
    
    
        dim computer, objArgs, importDirectory, generateNewID
    
    
        
    
    
        set fileSystem = Wscript.CreateObject("Scripting.FileSystemObject")
    
    
        computer = "."
    
    
        set objWMIService = GetObject("winmgmts:\\" & computer & "\root\virtualization")
    
    
        set managementService = objWMIService.ExecQuery("select * from Msvm_VirtualSystemManagementService").ItemIndex(0)
    
    
        
    
    
        set objArgs = WScript.Arguments
    
    
        if WScript.Arguments.Count = 1 then
    
    
            importDirectory = objArgs.Unnamed.Item(0)
    
    
        else
    
    
            WScript.Echo "usage: cscript ImportVirtualSystemEx.vbs importDirectoryName"
    
    
            WScript.Quit(1)
    
    
        end if
    
    
       
    
    
        if ImportVirtualSystemEx(importDirectory) then
    
    
            WriteLog "Done"
    
    
            WScript.Quit(0)
    
    
        else
    
    
            WriteLog "importDirectory Failed."
    
    
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
    
    
            WriteLog Format1("ImportVirtualSystem failed with ReturnValue {0}", objOutParams.ReturnValue)
    
    
        end if
    
    
     
    
    
    End Function
    
    
    '-----------------------------------------------------------------
    
    
    ' ImportVirtualSystem from a directory
    
    
    '-----------------------------------------------------------------
    
    
    Function ImportVirtualSystemEx(importDirectory)
    
    
     
    
    
        dim objInParam, objOutParams
    
    
        dim newDataRoot
    
    
        dim importSettingData, copyDir, fileSysObj
    
    
     
    
    
        ImportVirtualSystemEx = false    
    
    
            
    
    
        newDataRoot = importDirectory & "\NewCopy" 
    
    
        
    
    
        'Path in newDataRoot folder should be existing
    
    
        set fileSysObj  = CreateObject("Scripting.FileSystemObject")
    
    
        if fileSysObj.FolderExists(newDataRoot) then
    
    
        fileSysObj.DeleteFolder(newDataRoot)        
    
    
        end if
    
    
        copyDir = fileSysObj.CreateFolder(newDataRoot) 
    
    
        
    
    
        set objInParam = managementService.Methods_("ImportVirtualSystemEx").InParameters.SpawnInstance_()
    
    
        objInParam.ImportDirectory = importDirectory
    
    
     
    
    
        set importSettingData = GetVirtualSystemImportSettingData(importDirectory)
    
    
        importSettingData.GenerateNewId = true
    
    
        importSettingData.CreateCopy = true
    
    
        importSettingData.Name = "NewSampleVM"
    
    
        importSettingData.TargetVmDataRoot = newDataRoot
    
    
        importSettingData.TargetSnapshotDataRoot = newDataRoot
    
    
        importSettingData.TargetVhdDataRoot = newDataRoot
    
    
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
    
    
            WriteLog Format1("ImportVirtualSystem failed with ReturnValue {0}", objOutParams.ReturnValue)
    
    
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
    
    
        set fileStream = fileSystem.OpenTextFile(".\ImportVirtualSystemEx.log", 8, true)
    
    
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
