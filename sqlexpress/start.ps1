# place sql server data in mapped or unmapped volume as appropriate, start service

param(
[ValidateSet('interactive', 'detached', ignorecase=$true)]
[string]$attachmode="interactive",
[string]$sqlinstance="SQL",
[string]$sqldata="c:\sql\data",
[string]$sqlbackup="c:\sql\backup"
)

set-strictmode -version latest
$ErrorActionPreference = "Stop"

$sqldatatemp = "\datatemp"

$attachmode
$sqlinstance
$sqldata
$sqlbackup

# move / copy data and backup folders as appropriate

if ( test-path $sqldata) {
  # host
  if ( ! (test-path (join-path $sqldata ("MSSQL12." + $sqlinstance) ) ) ) {
    # host data does not yet exist - bootstrap scenario
    copy-item $sqldatatemp $sqldata -recurse
  }
}
else {
  # local
  copy-item $sqldatatemp $sqldata -recurse
}

if ( ! (test-path $sqlbackup) ) {
  # local
  new-item $sqlbackup -itemtype directory
}

# start service
$servicename = "mssql$" + $sqlinstance
start-service $servicename

# take interactive / detached action as appropriate
if ($attachmode -eq "interactive") {
  powershell
}
else {
 # sleep-loop indefinitely (until container stop)
 while (1 -eq 1) {
   [DateTime]::Now.ToShortTimeString()
   Start-Sleep -Seconds 1
  }
}
