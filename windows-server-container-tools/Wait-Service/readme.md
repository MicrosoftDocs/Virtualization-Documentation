###Wait-Service
The intention of this module is to monitor a running service.

###Description
Finds the service specified by name, waits the specified amount of time for the service to start and then waits for the service to exit.
Upon exit the return code of the service will be the return code of the cmdlet.
If AllowServiceRestarts is true if the service is restarted the script automatically re-executes.

###Parameter's
####ServiceName
The name of the service to wait for.
####StartupTime
The amount of time in seconds to wait for the service to start after initating the script.  Default is 10sec.
####AllowServiceRestart
Automtically restart the wait process when the service exits looping for the StartupTimeout again.
##Example
```
FROM microsoft/iis
ADD Wait-Service.ps1 /Wait-Service.ps1

SHELL ["powershell", "-File"]
CMD c:\Wait-Service.ps1 -ServiceName W3SVC -AllowServiceRestart
```
or
```
FROM microsoft/iis
ADD Wait-Service.ps1 /Wait-Service.ps1

CMD powershell.exe -file c:\Wait-Service.ps1 -ServiceName W3SVC -AllowServiceRestart
```
