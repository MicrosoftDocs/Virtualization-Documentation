<#
    .NOTES
        Copyright (c) Microsoft Corporation.  All rights reserved.
    
    .SYNOPSIS
        Waits for a service to stop.

    .DESCRIPTION
        Finds the service specified by name, waits the specified amount of time for the service to start and then waits for the service to exit.
        Upon exit the return code of the service will be the return code of the cmdlet.
        If AllowServiceRestarts is true if the service is restarted the script automatically re-executes.
        
    .PARAMETER ServiceName
        The name of the service to wait for.

    .PARAMETER StartupTimeout
        The amount of time in seconds to wait for the service to start after initating the script.  Default is 10sec.

    .PARAMETER AllowServiceRestart 
        Automtically restart the wait process when the service exits looping for the StartupTimeout again.

    .EXAMPLE
        .\Wait-Service.ps1 -ServiceName W3SVC       
#>

    [CmdletBinding()]
    param(
        #The name of the service to wait for.
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $ServiceName,

        #The amount of time in seconds to wait for the service to start after initating the script.  Default is 10sec.
        [ValidateNotNullOrEmpty()]
        [int] 
        $StartupTimeout = 10,

        #Automtically restart the wait process when the service exits looping for the StartupTimeout again.
        [switch] 
        $AllowServiceRestart
    )


function Wait-Service()
{
    [CmdletBinding()]
    param(
        #The name of the service to wait for.
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $ServiceName,

        #The amount of time in seconds to wait for the service to start after initating the script.  Default is 10sec.
        [ValidateNotNullOrEmpty()]
        [int] 
        $StartupTimeout = 10,

        #Automtically restart the wait process when the service exits looping for the StartupTimeout again.
        [switch] 
        $AllowServiceRestart
    )
    #Allow Service Restart
    do 
    {
        #Importing the System.ServiceProcess Assembly
        Add-Type -AssemblyName System.ServiceProcess -ErrorAction SilentlyContinue

        #Adding a PInvoke call for QueryServiceStatus which is used to get the error return.
        # https://github.com/dotnet/corefx/blob/master/src/Common/src/Interop/Windows/mincore/Interop.ENUM_SERVICE_STATUS.cs
        # https://github.com/dotnet/corefx/blob/master/src/Common/src/Interop/Windows/mincore/Interop.QueryServiceStatus.cs
        Add-Type -Name Advapi32 -Namespace Interop -PassThru -MemberDefinition @'
            // https://msdn.microsoft.com/en-us/library/windows/desktop/ms685996(v=vs.85).aspx
            [StructLayout(LayoutKind.Sequential)]
            public struct SERVICE_STATUS
            {
                public int serviceType;
                public int currentState;
                public int controlsAccepted;
                public int win32ExitCode;
                public int serviceSpecificExitCode;
                public int checkPoint;
                public int waitHint;
            }

            [DllImport("api-ms-win-service-winsvc-l1-1-0.dll", CharSet = CharSet.Unicode, SetLastError=true)] 
                public static extern bool QueryServiceStatus(
                    System.Runtime.InteropServices.SafeHandle serviceHandle, 
                    out SERVICE_STATUS pStatus);
'@ | Out-Null 


        $ServiceProcess = New-Object System.ServiceProcess.ServiceController($ServiceName)

        if ($ServiceProcess -eq $null)
        {
            throw "The specified service does not exist or can not be found."
        }
        #Startup timeout block
        try 
        {
            $ServiceProcess.WaitForStatus(
                [System.ServiceProcess.ServiceControllerStatus]::Running,
                [System.TimeSpan]::FromSeconds($StartupTimeout))
        }
        catch [System.ServiceProcess.TimeoutException] 
        {
            $exception = New-Object System.TimeoutException(
                [System.String]::Format(
                    "The Service '{0}' did not enter the 'Running' state within the {1} sec timeout.", 
                    $ServiceName, $StartupTimeout),
                $_.Exception
            )
            throw $exception 
        }

        #Service is in the Running State.  In a sleep loop waiting for service to stop.
        Write-Host (
            [System.String]::Format("The Service '{0}' is in the 'Running' state.", $ServiceName))

            do {
                Start-Sleep -Milliseconds 100
                $ServiceProcess.Refresh()
            } 
            while ($ServiceProcess.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running)

        #Stop/Error State
        $serviceStatus = New-Object Interop.Advapi32+SERVICE_STATUS
        [Interop.Advapi32]::QueryServiceStatus($ServiceProcess.ServiceHandle, [ref] $serviceStatus) |Out-Null
        
        $logString = [System.String]::Format(
                "The Service '{0}' has stopped.  The service control manager reported it's Exit Status as {1}", 
                $ServiceName, $serviceStatus.win32ExitCode)

        if ($serviceStatus.win32ExitCode -ne 0)
        {
            Write-Error $logString
        }
        else 
        {
            Write-Host $logString
        }
    }
    while ($AllowServiceRestart)    

    return $serviceStatus.win32ExitCode
}

if ($AllowServiceRestart)
{
    Wait-Service -ServiceName $ServiceName -StartupTimeout $StartupTimeout -AllowServiceRestart
}
else 
{
    Wait-Service -ServiceName $ServiceName -StartupTimeout $StartupTimeout
}
