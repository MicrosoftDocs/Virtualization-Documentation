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
    $Host.UI.RawUI.BackgroundColor = "DarkGreen"
    clear-host
 } else {
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




function demoSetupCleanup{
    Get-VM "psdirect" -Verbose | Get-VMSnapshot -Name "clean" -Verbose | Restore-VMSnapshot -Confirm:$false
    if ((get-vm "psdirect").state -ne "Running") { start-vm "psdirect" }
}


function guest1 {
    Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force ; `
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-ManagementScriptingTools
}

function guest2 {
    while(!(Test-Path "C:\inetpub\wwwroot\HelloWorld\index.html")) { sleep -Milliseconds 500 }
    new-website -Name "HelloWorld" -PhysicalPath "C:\inetpub\wwwroot\HelloWorld\"
    Stop-Website -Name "Default Web Site"
    Start-Website -Name "HelloWorld"
}

$title = "PSDirect Demo"

cls

$vmname = "psdirect"

$sitepath = "C:\Users\scooley\scooley-virt-docs\demos\PSDirect\site\"

$username = "Administrator"
$pass = ConvertTo-SecureString -AsPlainText "P@ssw0rd" -Force

$adminCred = new-object -TypeName System.Management.Automation.PSCredential `
    -ArgumentList $username, $pass


demoSetupCleanup

& vmconnect.exe localhost $vmname

write-host "Press enter to start setting up IIS"
read-host

Write-Host "Invoke-Command -VMName $vmname -Credential `$adminCred -ScriptBlock { '`'"
Write-host "    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-ManagementScriptingTools }"

Invoke-Command -VMName $vmname -Credential $adminCred -ScriptBlock ${function:guest1}

Write-Host ""
Write-Host "Refresh IE to see default IIS configured in $vmname"
Write-Host ""
Write-Host "Next, Let's our own default page."
Write-Host "Press enter to load the new site."

Write-Host ""
Write-Host "Invoke-Command -VMName $vmname -Credential `$adminCred -ScriptBlock `${function:SetSite}"

Get-ChildItem $sitepath -Recurse -File | % { Copy-VMFile -Name $vmname -SourcePath $_.FullName -DestinationPath ("C:\inetpub\wwwroot\HelloWorld\"+$_) -CreateFullPath -FileSource Host -Force }
Write-Host ""
read-host

Invoke-Command -VMName $vmname -Credential $adminCred -ScriptBlock ${function:guest3}

write-host ""
Write-Host -NoNewLine "Press any key to continue..."
Read-Host

get-process vmconnect | Stop-Process -Force
demoSetupCleanup