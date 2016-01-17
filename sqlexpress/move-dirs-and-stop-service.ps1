# move sql server data to location expected by downstream 'start' script, leave service stopped
#
# POSTCONDITIONS:
#   x SQL Data is in temporary location /datatemp
#   x $sqldata is removed
#   x $sqlbackup is removed
#   x $sql is removed
#   x Service is stopped

param(
[Parameter(Mandatory=$true)]
[string]$sqlinstance,
[Parameter(Mandatory=$true)]
[string]$sql,
[Parameter(Mandatory=$true)]
[string]$sqldata,
[Parameter(Mandatory=$true)]
[string]$sqlbackup
)

set-strictmode -version latest
$ErrorActionPreference = "Stop"

$datatemp = "\datatemp"

$servicename = "mssql$" + $sqlinstance

# stop service
stop-service $servicename

# move data to temp loc
copy-item $sqldata $datatemp -recurse
remove-item $sqldata -force -recurse

# remove backup folder
remove-item $sqlbackup -force -recurse

# if sqldata and sqlbackup share same parent, ensure that is removed
if ( test-path $sql ) {
  remove-item $sql -force -recurse
}

# service is left stopped