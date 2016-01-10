param(
[ValidateSet('interactive', 'detached', ignorecase=$true)]
[string]$attachmode="interactive",
[string]$sqldata="c:\sql"
)

$ErrorActionPreference = "Stop"

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