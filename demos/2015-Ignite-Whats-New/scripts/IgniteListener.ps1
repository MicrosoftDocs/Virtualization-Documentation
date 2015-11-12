# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
 
# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator
   
   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);
   
   # Exit from the current, unelevated, process
   exit
   }

cls

$found = $false
Write-Host "Current state of IIS:"
Write-Host 'Get-WindowsOptionalFeature -Online | Where-Object{ $_.FeatureName -match "IIS-*"}'
Get-WindowsOptionalFeature -Online | Where-Object{ $_.FeatureName -contains "IIS"} | select "Name","State"
Write-Host ""

Write-Host "Waiting for IIS to be enabled."
do{
    $feature = Get-WindowsOptionalFeature -Online | Where-Object{($_.State -match "Enabled") -and ($_.FeatureName -match "IIS-WebServerRole")}
    Start-Sleep -Milliseconds 200
}until(($feature | measure).count -eq 1)

Write-host "IIS is enabled!"
Write-host ""

Write-Host "Waiting for IIS management tools to be enabled."
do{
    $feature = Get-WindowsOptionalFeature -Online | Where-Object{($_.State -match "Enabled") -and ($_.FeatureName -match "IIS-ManagementScriptingTools")}
    Start-Sleep -Milliseconds 200
}until(($feature | measure).count -eq 1)

Write-host "IIS management tools are enabled!"
Write-host ""

Import-Module WebAdministration

Write-Host "Start looking for IIS process..."
$found = ((Get-Process | ?{$_.ProcessName -like "w3wp"} | Measure-Object).Count -gt 0)

Write-Host ""
Write-Host "Check for default site by launching internet explorer with http://localhost"

& 'C:\Program Files (x86)\Internet Explorer\iexplore.exe' http://localhost

while ((Get-Process | ?{$_.ProcessName -like "w3wp"} | Measure-Object).Count -gt 0) { sleep -Milliseconds 500 }

write-host "IIS running. Default site loaded."
Write-Host ""
write-host "Checking for new sites in IIS..."
Get-Website

while(!(Test-Path "C:\inetpub\wwwroot\IgniteSite\index.html")) { sleep -Milliseconds 500 }
write-host "New site (IgniteSite) copied."
Write-Host ""
write-host "Checking for new sites in IIS..."
while(!(Get-Website -Name "HelloIgnite")) { sleep -Milliseconds 500 }
Get-Website

if((Get-Website -Name "HelloIgnite").State -ne "Started"){
    Write-Host "Waiting for our new site to start"
    while((Get-Website -Name "HelloIgnite").State -ne "Started") { sleep -Milliseconds 500 }
    Get-Website
}

Write-Host "Reload localhost!"
Write-Host ""

While (1 -eq 1){sleep -Seconds 10}