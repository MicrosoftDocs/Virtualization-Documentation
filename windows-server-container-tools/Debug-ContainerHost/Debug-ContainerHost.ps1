Write-Output "Checking for common problems"
Invoke-Pester

# TODO: Dump full logs to text file
# TODO: Highlight errors

Write-Output "Warnings & errors from the last 24 hours"
$logStartTime = (Get-Date).AddHours(-24)

$logNames = "Microsoft-Windows-Containers-Wcifs/Operational",
            "Microsoft-Windows-Containers-Wcnfs/Operational",
            "Microsoft-Windows-Hyper-V-Compute-Admin", 
            "Microsoft-Windows-Hyper-V-Compute-Operational",
            "Application"
$levels = 3,2,1,0
$providers = "Docker", "Microsoft-Windows-Hyper-V-Compute"

# Get-EventLog -LogName Application -Source Docker -After $logStartTime -EntryType Warning, Error | Format-List TimeGenerated, Message
Get-WinEvent -FilterHashtable @{Logname=$logNames; StartTime=$logStartTime; Level=$levels; ProviderName=$providers} -ErrorAction Ignore