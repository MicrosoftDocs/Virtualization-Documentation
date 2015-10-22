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

function setup{
    Get-VM "Different Checkpoints" | Get-VMSnapshot -name "demo" | Restore-VMCheckpoint -Confirm:$false
    Get-VM "PS Direct" -Verbose | Get-VMSnapshot -Name "prepped" -Verbose | Restore-VMCheckpoint -Confirm:$false
         
    if ((get-vm "PS Direct").state -ne "Running") {start-vm "PS Direct"}
    if ((get-vm "Different Checkpoints").state -ne "Running") {start-vm "Different Checkpoints"}

    stop-vm "Old Virtual Machine" -TurnOff -confirm:$false
    remove-vm "Old Virtual Machine" -confirm:$false -Force
    Remove-Item "C:\VMs\OldVM.vhdx"
    import-vm -Copy -Path "D:\Build\VMs\Old Virtual Machine\Virtual Machines\EBF49DE2-966B-4806-A9D0-5F33939AC6C0.xml" | Out-Null
    new-vhd -path "C:\VMs\OldVM.vhdx" -ParentPath "D:\Build\BaseVHDs\Old Virtual Machine.vhdx" -Differencing
    Add-VMHardDiskDrive -VMName "Old Virtual Machine" -path "C:\VMs\OldVM.vhdx"
    start-vm "Old Virtual Machine"
    set-vm "Different Checkpoints" -CheckpointType Standard
}

cls

$title = "Hyper-V Demo"
$message = "What do you want to demo show now?"

# Strange whitespace below == prettier menu

$ProductionCheckpoints =   New-Object System.Management.Automation.Host.ChoiceDescription        "&Production Checkpoints                                                                                           .", `
    "Using Production Checkpoints."

$PowerShellDirect =   New-Object System.Management.Automation.Host.ChoiceDescription             "PowerShell &Direct to VM                                                                                          .", `
    "PowerShell direct to VM."

$Shutdown =                New-Object System.Management.Automation.Host.ChoiceDescription        "Cleanly &Shutdown the system                                                                                      .", `
    "Cleanly shutdown the system."

$clean =                New-Object System.Management.Automation.Host.ChoiceDescription           "Setup the syste&m                                                                                               .", `
    "Setup the system."

$Exit =                    New-Object System.Management.Automation.Host.ChoiceDescription        "E&xit                                                                                                             .", `
    "Finish up with demo."

$options = [System.Management.Automation.Host.ChoiceDescription[]]($ProductionCheckpoints, $PowerShellDirect,$Shutdown,$clean, $Exit)

do {

cls

$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
switch ($result)
    {
        0 {# Production Checkpoints
        write-Output ""
                
       if ((get-vm "Different Checkpoints").state -ne "Running") {start-vm "Different Checkpoints"}

        Invoke-Expression "C:\windows\system32\vmconnect.exe localhost 'Different Checkpoints'"
       
        write-Output ""
        Write-Output "Press enter to return to demo menu"
        read-host

        get-process vmconnect | Stop-Process -Force
        stop-vm "Different Checkpoints" -TurnOff -force
        Restore-VMCheckpoint -VMName "Different Checkpoints" -Name "demo" -Confirm:$false
        get-vm "Different Checkpoints" | Get-VMSnapshot | ? name -ne "demo" | Remove-VMCheckpoint -Confirm:$false
        set-vm "Different Checkpoints" -CheckpointType Standard
        start-vm "Different Checkpoints" }

        1 {# PowerShell Direct to VM

        # Scooley Code -->

        $vmname = "scooley-ignite"

        $vmscriptpath = "C:\IgniteListener.ps1"
        $sitepath = "C:\IgniteSite"

        $username = "Administrator"
        $pass = ConvertTo-SecureString -AsPlainText "P@ssw0rd" -Force

        $adminCred = new-object -TypeName System.Management.Automation.PSCredential `
             -ArgumentList $username, $pass


        function IISSite {
         new-website -Name "HelloIgnite" -PhysicalPath "C:\inetpub\wwwroot\IgniteSite\"
         Stop-Website -Name "Default Web Site"
         Start-Website -Name "HelloIgnite"
         }


         & vmconnect.exe localhost $vmname

         write-host "Press enter to start"
         read-host


         Write-Host "I'm enabled guest file copy so I can copy in a monitoring script.  Then you can watch setup inside the VM."
         Write-Host ""

         Write-Host "Copy-VMFile -Name $vmname -SourcePath $vmscriptpath -DestinationPath `"C:\Users\scooley\Desktop\IgniteListener.ps1`" -FileSource Host -Verbose"
         Copy-VMFile -Name $vmname -SourcePath $vmscriptpath -DestinationPath "C:\Users\scooley\Desktop\IgniteListener.ps1" -FileSource Host -Verbose -ErrorAction Inquire
         Write-Host ""

         Write-Host "Making sure the file copied and setting the execution policy on the remote host to unrestricted..."
         Write-Host "Invoke-Command -VMName $vmname -Credential `$adminCred -ScriptBlock { Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force ; while(!(Test-Path `"C:\Users\scooley\Desktop\IgniteListener.ps1`")) { Write-Host -NoNewline "."; sleep -Milliseconds 500 } }"


         Invoke-Command -VMName $vmname -Credential $adminCred -ScriptBlock { `
             Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force ;`
             while(!(Test-Path "C:\Users\scooley\Desktop\IgniteListener.ps1")) { sleep -Milliseconds 500; } }

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
         Get-ChildItem $sitepath -Recurse -File | % { Copy-VMFile -Name $vmname -SourcePath $_.FullName -DestinationPath ("C:\inetpub\wwwroot\IgniteSite\"+$_) -CreateFullPath -FileSource Host -Force }
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
         Get-VM $vmname -Verbose | Get-VMSnapshot -Name "Prepped" -Verbose | Restore-VMCheckpoint -Confirm:$false
         Start-VM $vmname}

        2 {# Cleanly Shutdown the system
        Write-Output "Cleanly Shutdown the system!"
        read-host }

        3 {# Setup
        Setup }

        4 {# Exit
        exit }
    }
    }    while (1 -eq 1)

