# set sql server express to use static TCP port 1433

param(
[Parameter(Mandatory=$true)]
[string]$sqlinstance
)

$ErrorActionPreference = "Stop"

$servicename = "mssql$" + $sqlinstance

stop-service $servicename

set-itemproperty -path "HKLM:\software\microsoft\microsoft sql server\mssql12.$sqlinstance\mssqlserver\supersocketnetlib\tcp\ipall" -name tcpdynamicports -value ""
set-itemproperty -path "HKLM:\software\microsoft\microsoft sql server\mssql12.$sqlinstance\mssqlserver\supersocketnetlib\tcp\ipall" -name tcpport -value 1433

start-service $servicename