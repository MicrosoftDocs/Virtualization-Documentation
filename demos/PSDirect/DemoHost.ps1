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

# Run your code that needs to be elevated here

function demoSetupCleanup{
    Get-VM "psdirect" -Verbose | Get-VMSnapshot -Name "clean" -Verbose | Restore-VMCheckpoint -Confirm:$false
    if ((get-vm "psdirect").state -ne "Running") { start-vm "psdirect" }
}

function guestSetup {
    new-website -Name "HelloWorld" -PhysicalPath "C:\inetpub\wwwroot\HelloWorld\"
    Stop-Website -Name "Default Web Site"
    Start-Website -Name "HelloWorld"
}

$title = "PSDirect Demo"

cls

$vmname = "psdirect"

$vmscriptpath = "C:\Users\scooley\scooley-virt-docs\demos\PSDirect\DemoGuest.ps1"
$guestScriptPath = "C:\Users\scooley\Desktop\DemoGuest.ps1"
$sitepath = "C:\Users\scooley\scooley-virt-docs\demos\PSDirect\site"

$username = "Administrator"
$pass = ConvertTo-SecureString -AsPlainText "P@ssw0rd" -Force

$adminCred = new-object -TypeName System.Management.Automation.PSCredential `
    -ArgumentList $username, $pass


& vmconnect.exe localhost $vmname

write-host "Press enter to start"
read-host

Write-Host "I enabled guest file copy so I can copy in a monitoring script.  Then you can watch setup inside the VM."
Write-Host ""

Write-Host "Copy-VMFile -Name $vmname -SourcePath $vmscriptpath -DestinationPath $guestScriptPath -FileSource Host -Verbose"
Copy-VMFile -Name $vmname -SourcePath $vmscriptpath -DestinationPath $guestScriptPath -FileSource Host -Verbose -ErrorAction Inquire
Write-Host ""

Write-Host "Making sure the file copied and setting the execution policy on the remote host to unrestricted..."
Write-Host "Invoke-Command -VMName $vmname -Credential `$adminCred -ScriptBlock { '`'"
Write-host "    Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force; '`'"
Write-Host '    while(!(Test-Path `"C:\Users\scooley\Desktop\DemoGuest.ps1`")) `'
Write-Host '        { Write-Host -NoNewline "."; sleep -Milliseconds 500 } }'


Invoke-Command -VMName $vmname -Credential $adminCred -ScriptBlock { `
    Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force ;`
    while(!(Test-Path "C:\Users\scooley\Desktop\DemoGuest.ps1")) { sleep -Milliseconds 500; } }

write-host ""
write-host "Press enter to start"
read-host

Write-Host "Now we're going to connect to the configured virtual machine using PowerShell Direct."
Write-Host ""

Write-Host "We're runing the following in $vmname with Invoke-Command:"
Write-Host 'Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole'
Write-Host ""
Write-Host "Invoke-Command -VMName $vmname -Credential `$adminCred -ScriptBlock `${function:Config}"

Invoke-Command -VMName $vmname -Credential $adminCred -ScriptBlock { Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-ManagementScriptingTools }

Write-Host ""
Write-Host "Now let's set the default page to Hello World or something..."
Write-Host ""
Get-ChildItem $sitepath -Recurse -File | % { Copy-VMFile -Name $vmname -SourcePath $_.FullName -DestinationPath ("C:\inetpub\wwwroot\HelloWorld\"+$_) -CreateFullPath -FileSource Host -Force }
Write-Host ""

Write-Host "Making sure the site copied..."
Write-Host "Invoke-Command -VMName $vmname -Credential `$adminCred -ScriptBlock { while(!(Test-Path `"C:\inetpub\wwwroot\IgniteSite\index.html`")) { sleep -Milliseconds 500 } }"
Invoke-Command -VMName $vmname -Credential $adminCred -ScriptBlock { while(!(Test-Path "C:\inetpub\wwwroot\IgniteSite\index.html")) { sleep -Milliseconds 500 } }

Invoke-Command -VMName $vmname -Credential $adminCred -ScriptBlock ${function:IISSite}

Write-Host ""
Write-Host "There you go, unconfigured VM to a running web server."
write-host
Write-Host -NoNewLine "Press any key to continue..."
Read-Host

get-process vmconnect | Stop-Process -Force
demoSetupCleanup