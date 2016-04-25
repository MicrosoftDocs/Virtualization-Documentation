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

   function laptop2Setup{

   $laptop2 = "demo-laptop-2"

   icm $laptop2 -Credential $domainCred -Authentication Credssp {"Test"}

   icm $laptop2 -Credential $domainCred -Authentication Credssp {

   get-vm | ? Name -ne "Domain Controller" | stop-vm -TurnOff -Force 
 
   Get-VMSnapshot -VMName * | ? Name -eq "Safe" | Restore-VMSnapshot -Confirm:$false

   start-vm "SOFS Cluster Node 1"
   start-vm "Replica Target"
   start-vm "Workload"

   do {sleep -Seconds 1} until (test-path "\\sofs-fs\vhdx")

   get-childitem \\sofs-fs\vhdx\backup | %{Write-Output "Copying file $($_)"; copy-item $_.FullName \\sofs-fs\vhdx -Force}

   Add-VMHardDiskDrive -VMName "Protected Workload" -Path "\\sofs-fs\vhdx\Protected.vhds" -SupportPersistentReservations
   Add-VMHardDiskDrive -VMName "Cluster Node 1" -Path "\\sofs-fs\vhdx\QOSDisk1.vhdx"
   Add-VMHardDiskDrive -VMName "Cluster Node 2" -Path "\\sofs-fs\vhdx\QOSDisk2.vhdx"

   start-vm "Protected Workload"
   start-vm "Cluster Node 1"
   start-vm "Cluster Node 2"
   del f:\*.*
   del g:\*.*
   copy c:\Disks\*.* F:\
   copy c:\Disks\*.* G:\

   Remove-VMReplication -VMName "Workload"

   Enable-VMReplication -VMName Workload -ReplicaServerName Replica.ignite.demo -AuthenticationType Kerberos -ReplicationFrequencySec 30 -AutoResynchronizeEnabled $true -CompressionEnabled $false -ReplicaServerPort 80
   Start-VMInitialReplication "Workload"
      }

   }

    function laptop1Setup{
        get-vm "Ubuntu" | Get-VMSnapshot -name "demo" | Restore-VMCheckpoint -Confirm:$false
        get-vm "Hot Add & Remove" | Get-VMSnapshot -name "demo" | Restore-VMCheckpoint -Confirm:$false
         get-vm "Different Checkpoints" | Get-VMSnapshot -name "demo" | Restore-VMCheckpoint -Confirm:$false
         get-vm "Hyper-V Management" | Get-VMSnapshot -name "demo" | Restore-VMCheckpoint -Confirm:$false
         Get-VM "scooley-ignite" -Verbose | Get-VMSnapshot -Name "Prepped" -Verbose | Restore-VMCheckpoint -Confirm:$false
         
       if ((get-vm "scooley-ignite").state -ne "Running") {start-vm "scooley-ignite"}
        if ((get-vm "Hyper-V Management").state -ne "Running") {start-vm "Hyper-V Management"}
        if ((get-vm "Hot Add & Remove").state -ne "Running") {start-vm "Hot Add & Remove"}
        if ((get-vm Ubuntu).state -ne "Running") {start-vm Ubuntu}
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

$domainCred = new-object -typename System.Management.Automation.PSCredential `
              -argumentlist "Ignite\Administrator", (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)
$laptop2 = "demo-laptop-2"

cls

$title = "Hyper-V Demo"
$message = "What do you want to demo show now?"

# Strange whitespace below == prettier menu

$VirtualTPM = New-Object System.Management.Automation.Host.ChoiceDescription                     "&vTPM                                                                                                             .", `
    "Using a virtual machine with a vTPM."

$LinuxSecureBoot =         New-Object System.Management.Automation.Host.ChoiceDescription        "&Linux and Secure Boot                                                                                            .", `
    "Using Linux and Secure Boot."

$StorageQoS =              New-Object System.Management.Automation.Host.ChoiceDescription        "&Distributed Storage QoS                                                                                          .", `
"Using Distributed Storage QoS on two VMs."

$StorageResiliency =              New-Object System.Management.Automation.Host.ChoiceDescription "&Storage Resiliency                                                                                               .", `
"Showing a virtual machine respond to storage failure."

$VMResiliency =            New-Object System.Management.Automation.Host.ChoiceDescription        "VMs resistent to hardware &failure                                                                                .", `
"Demonstrating VM Resiliency in a cluster."

$SVHDXOnlineResize =            New-Object System.Management.Automation.Host.ChoiceDescription   "&Online resize for Shared VHDX                                                                                    .", `
"Demonstrating VM Resiliency in a cluster."

$ReplicaDiskAdd =          New-Object System.Management.Automation.Host.ChoiceDescription        "&Replica and adding disks                                                                                         .", `
    "Using Replica and Adding Hard disks."

$HotAddRemove =            New-Object System.Management.Automation.Host.ChoiceDescription        "&Hot Add and Remove of Memory / Networking                                                                        .", `
 "Adding and removing networking from a running virtual machine."

$UpgradingVirtualMachine = New-Object System.Management.Automation.Host.ChoiceDescription        "&Upgrade                                                                                                          .", `
    "Upgrading a virtual machine from Hyper-V 2012 R2 to Hyper-V Technical Preview."

$ProductionCheckpoints =   New-Object System.Management.Automation.Host.ChoiceDescription        "&Production Checkpoints                                                                                           .", `
    "Using Production Checkpoints."

$PowerShellDirect =   New-Object System.Management.Automation.Host.ChoiceDescription             "Po&werShell Direct to VM                                                                                          .", `
    "PowerShell direct to VM."

$ReFSEnhancements =   New-Object System.Management.Automation.Host.ChoiceDescription             "Using ReFS to &increase virtual hard disk operations                                                              .", `
    "ReFS enhancements."

    $RemoteManagement =        New-Object System.Management.Automation.Host.ChoiceDescription    "Remote &management improvements                                                                                   .", `
"Remote Management improvements in the UI."

$ClusterWMI =              New-Object System.Management.Automation.Host.ChoiceDescription        "Multi-host level mana&gement                                                                                      .", `
"Performing cluster level management of Hyper-V."

$Containers =              New-Object System.Management.Automation.Host.ChoiceDescription        "&Containers                                                                                                       .", `
"Introduction to container technology."

$Shutdown =                New-Object System.Management.Automation.Host.ChoiceDescription        "Cleanly Shutdown the s&ystem                                                                                      .", `
    "Cleanly shutdown the system."

$clean =                New-Object System.Management.Automation.Host.ChoiceDescription           "&Z Setup the system                                                                                               .", `
    "Setup the system."

$Exit =                    New-Object System.Management.Automation.Host.ChoiceDescription        "E&xit                                                                                                             .", `
    "Finish up with demo."

    $options = [System.Management.Automation.Host.ChoiceDescription[]]($VirtualTPM, $LinuxSecureBoot, $StorageQoS, $StorageResiliency,$VMResiliency, $SVHDXOnlineResize, $ReplicaDiskAdd, $HotAddRemove, $UpgradingVirtualMachine,$ProductionCheckpoints, $PowerShellDirect,$ReFSEnhancements,$RemoteManagement,$ClusterWMI,$Containers,$Shutdown,$clean, $Exit)

do {

cls

$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
switch ($result)
    {
        0 {# vTPM
        
        write-Output ""

        # check that the vTPM system is running
        if ((icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp `
             {get-vm "Protected Workload"}).State -eq "Running")
            {Invoke-Expression "C:\Users\demo\Documents\vTPM.RDP"}
        else
            {Write-Output "The vTPM system is not running.  Please check the system state."}

        write-Output ""
        write-Output "Press enter to return to demo menu"
        read-host}

        1 {# Linux Secure Boot

        write-Output ""
                
        if ((get-vm Ubuntu).state -ne "Running") {start-vm Ubuntu}

        Invoke-Expression "C:\windows\system32\vmconnect.exe localhost ubuntu"
       
        #TODO - output PowerShell for enabling Linux secure boot       
        
        write-Output ""
        Write-Output "Press enter to return to demo menu"
        read-host
        get-process vmconnect | Stop-Process -Force}

        2 {# Distributed Storage QoS

        # check that the cluster is running
        if (((icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp `
             {get-vm "Cluster Node 1"}).State -eq "Running") -and `
           ((icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp `
             {get-vm "Cluster Node 2"}).State -eq "Running"))
            {Invoke-Expression "C:\windows\system32\vmconnect.exe demo-laptop-2 `"Cluster Node 1`" /user Ignite\administrator /password P@ssw0rd"
             Invoke-Expression "C:\windows\system32\vmconnect.exe demo-laptop-2 `"Cluster Node 2`" /user Ignite\administrator /password P@ssw0rd"}
        else
            {Write-Output "The cluster is not running.  Please check the system state."}

        # TODO - output PowerShell for enabling QOS in all locations

        icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
           Write-Output "Press enter to apply shared QOS policy to Cluster Node 1"
           read-host
           Get-VMHardDiskDrive -VMName "Cluster Node 1" | ?{$_.Path -eq "\\sofs-fs\VHDX\QOSDisk1.vhdx"} | Set-VMHardDiskDrive -QoSPolicyID 957436d0-96c5-4b86-a113-b85a69874aa7
           Write-Output "Press enter to apply shared QOS policy to Cluster Node 2"
           read-host
           Get-VMHardDiskDrive -VMName "Cluster Node 2" | ?{$_.Path -eq "\\sofs-fs\VHDX\QOSDisk2.vhdx"} | Set-VMHardDiskDrive -QoSPolicyID 957436d0-96c5-4b86-a113-b85a69874aa7
           Write-Output "Press enter to clear the QOS polocies"
           read-host
           Get-VMHardDiskDrive -VMName "Cluster Node 1" | ?{$_.Path -eq "\\sofs-fs\VHDX\QOSDisk1.vhdx"} | Set-VMHardDiskDrive -QoSPolicyID $null
           Get-VMHardDiskDrive -VMName "Cluster Node 2" | ?{$_.Path -eq "\\sofs-fs\VHDX\QOSDisk2.vhdx"} | Set-VMHardDiskDrive -QoSPolicyID $null}

        write-Output ""
        Write-Output "Press enter to return to demo menu"
        read-host
        get-process vmconnect | Stop-Process -Force}

        3 {# Storage Resiliency

        # check that the vTPM system is running
        if ((icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp `
             {get-vm "Workload"}).State -eq "Running")

            {icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
                  Add-VMHardDiskDrive -VMName "Workload" -Path \\protected-fs\vhdx\data.vhdx
                          Remove-VMReplication -VMName "Workload"}

              icm replica -Credential $domainCred -Authentication Credssp {remove-vm workload -force}

              Invoke-Expression "C:\windows\system32\vmconnect.exe demo-laptop-2 `"Workload`" /user Ignite\administrator /password P@ssw0rd"

              Write-Output "Press enter when you want to remove storage access"
              read-host

              icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
                  Disconnect-VMNetworkAdapter -VMName "Protected Workload"}

              Start-Sleep -Seconds 30
              write-host "30 seconds..."

              Start-Sleep -Seconds 30
              write-host "60 seconds..."

              Start-Sleep -Seconds 30
              write-host "90 seconds..."

              Write-Output "Press enter when you want to restore storage access"
              read-host

              icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
                  connect-VMNetworkAdapter -VMName "Protected Workload" -SwitchName "Virtual Switch"}

              }
        else
            {Write-Output "The workload is not running.  Please check the system state."}

        Write-Output "Press enter to return to demo menu"
        read-host
        
        icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
            get-VMHardDiskDrive -VMName "Workload" | ? Path -eq \\protected-fs\vhdx\data.vhdx | Remove-VMHardDiskDrive
            stop-vm "Workload" -Force
            start-vm "Workload"
            
        Enable-VMReplication -VMName Workload -ReplicaServerName Replica.ignite.demo -AuthenticationType Kerberos -ReplicationFrequencySec 30 -AutoResynchronizeEnabled $true -CompressionEnabled $false -ReplicaServerPort 80
        Start-VMInitialReplication "Workload"}

        get-process vmconnect | Stop-Process -Force
        }

        4 {# VMs resistent to hardware failure

        Invoke-Expression "C:\windows\system32\vmconnect.exe demo-laptop-2 `"Cluster Node 1`" /user Ignite\administrator /password P@ssw0rd"
        
        icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
        Remove-VMReplication -VMName "Workload"
                add-clusternode -Cluster "demo-cluster" -Name demo-laptop-2 -nostorage
                new-vm -Name "Test 7" -MemoryStartupBytes 32mb -Path \\sofs-fs\ClusData | Add-VMToCluster | out-null
                start-vm "test 7"                          }

              icm replica -Credential $domainCred -Authentication Credssp {remove-vm workload -force}

        #TODO - put this in a loop

        Write-Output "Press enter to cause a fault"
        read-host

        icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {get-process clussvc | Stop-Process -Force}

        Write-Output "Press enter to fix the fault"
        read-host

        icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {net start clussvc  | out-null}

        Write-Output "Press enter to return to demo menu"
        read-host

        icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
        Remove-ClusterGroup -Name "Test 7" -RemoveResources -Force
        stop-vm "Test 7" -TurnOff -Force
        remove-vm "Test 7" -Force
        remove-clusternode -Cluster "demo-cluster" -Name demo-laptop-2 -force
        
        Enable-VMReplication -VMName Workload -ReplicaServerName Replica.ignite.demo -AuthenticationType Kerberos -ReplicationFrequencySec 30 -AutoResynchronizeEnabled $true -CompressionEnabled $false -ReplicaServerPort 80
        Start-VMInitialReplication "Workload"}
        get-process vmconnect | Stop-Process -Force
        }

        5 {# Online resize for Shared VHDX

        Invoke-Expression "C:\windows\system32\vmconnect.exe demo-laptop-2 `"Cluster Node 1`" /user Ignite\administrator /password P@ssw0rd"

        icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
                  Add-VMHardDiskDrive -VMName "Cluster Node 2" -Path \\sofs-fs\vhdx\Cluster.vhds -SupportPersistentReservations}

        Write-Output "\\sofs-fs\vhdx\Cluster.vhds" | clip
     
        Write-Output "Press enter when you are ready to increase the size of the shared VHDX"
        read-host

        #TODO - output PowerShell for resizing VHDS

        icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
           Resize-VHD -Path \\sofs-fs\vhdx\Cluster.vhds -SizeBytes ((get-vhd \\sofs-fs\vhdx\Cluster.vhds).Size + 10GB)}

        Write-Output "Press enter to return to demo menu"
        read-host
        
        get-process vmconnect | Stop-Process -Force

            icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
            get-VMHardDiskDrive -VMName "Cluster Node 1" | ? Path -eq \\sofs-fs\vhdx\Cluster.vhds | Remove-VMHardDiskDrive
            get-VMHardDiskDrive -VMName "Cluster Node 2" | ? Path -eq \\sofs-fs\vhdx\Cluster.vhds | Remove-VMHardDiskDrive}

        }

        6 {# Replica and adding disks

        Invoke-Expression "C:\windows\system32\vmconnect.exe demo-laptop-2 `"Workload`" /user Ignite\administrator /password P@ssw0rd"
       

        icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
        
        do {sleep -Seconds 1} until ((Get-VMReplication "Workload").state -eq "Replicating")}


             Write-Output "Press enter when you want to add a virtual hard disk to the virtual machine" 
             Read-host
        icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {     Add-VMHardDiskDrive -vmName "Workload" -Path "D:\VMs\DataDisk.vhdx"}
             Write-host
             Write-Output "Press enter when you want to update the replicated disk set" 
             Read-host
         icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {    Set-VMReplication "Workload" -ReplicatedDisks (Get-VMHardDiskDrive "Workload")}
             Write-Output "Press enter to return to demo menu"
             read-host

         icm -ComputerName $laptop2 -Credential $domainCred -Authentication Credssp {
             Set-VMReplication "Workload" -ReplicatedDisks (Get-VMHardDiskDrive "Workload" | select -first 1)
             Start-Sleep -Seconds 2
             Get-VMHardDiskDrive "Workload" | ?{$_.Path -eq "D:\VMs\DataDisk.vhdx"} | Remove-VMHardDiskDrive}

                     get-process vmconnect | Stop-Process -Force
        }

        7 {# Hot Add and Remove of Memory / Networking
        write-Output ""
                
        if ((get-vm "Hot Add & Remove").state -ne "Running") {start-vm "Hot Add & Remove"}

        Invoke-Expression "C:\windows\system32\vmconnect.exe localhost 'Hot Add & Remove'"
        
        write-Output ""
        Write-Output "Press enter to return to demo menu"
        read-host
        get-process vmconnect | Stop-Process -Force
        get-vm "Hot Add & Remove" | Get-VMSnapshot -name "demo" | Restore-VMCheckpoint -Confirm:$false
        }

        8 {# Upgrade

             if ((get-vm "Old Virtual Machine").state -ne "Running") {start-vm "Old Virtual Machine"}
             vmconnect.exe "localhost" "Old Virtual Machine"

             Write-output "Press enter when you want to upgrade the virtual machine"
             Read-host

             Write-output "Shutting down the old virtual machine"
             stop-vm "Old Virtual Machine" -confirm:$false  -Force
             Write-output "Upgrading the old virtual machine" 
             Write-output "Update-VMVersion `"Old Virtual Machine`""
             Update-VMVersion "Old Virtual Machine"

             Write-output "Starting the old virtual machine"
             start-vm "Old Virtual Machine"

        Write-Output "Press enter to return to demo menu"
        read-host
        
        get-process vmconnect | Stop-Process -Force

           stop-vm "Old Virtual Machine" -TurnOff -confirm:$false
           remove-vm "Old Virtual Machine" -confirm:$false -Force
           Remove-Item "C:\VMs\OldVM.vhdx"
           import-vm -Copy -Path "D:\Build\VMs\Old Virtual Machine\Virtual Machines\EBF49DE2-966B-4806-A9D0-5F33939AC6C0.xml" | Out-Null
           new-vhd -path "C:\VMs\OldVM.vhdx" -ParentPath "D:\Build\BaseVHDs\Old Virtual Machine.vhdx" -Differencing
           Add-VMHardDiskDrive -VMName "Old Virtual Machine" -path "C:\VMs\OldVM.vhdx"
           start-vm "Old Virtual Machine"
}

        9 {# Production Checkpoints
        write-Output ""
                
       if ((get-vm "Different Checkpoints").state -ne "Running") {start-vm "Different Checkpoints"}

        Invoke-Expression "C:\windows\system32\vmconnect.exe localhost 'Different Checkpoints'"
       
        write-Output ""
        Write-Output "Press enter to return to demo menu"
        read-host

        get-process vmconnect | Stop-Process -Force
        stop-vm "Different Checkpoints" -TurnOff -force
        Restore-VMCheckpoint -VMName "Different Checkpoints" -Name "Demo" -Confirm:$false
        get-vm "Different Checkpoints" | Get-VMSnapshot | ? name -ne "Demo" | Remove-VMCheckpoint -Confirm:$false
        set-vm "Different Checkpoints" -CheckpointType Standard
        start-vm "Different Checkpoints"}

        10 {# PowerShell Direct to VM

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

        11 {# Using ReFS to increase virtual hard disk operations
write-host "VHDX operations on NTFS"
write-host
write-host "Press enter to create a 1GB fixed VHDX on an NTFS partition"
read-host
$time = (measure-command {icm -ComputerName demo-laptop-2 -Credential $domainCred -Authentication Credssp {new-vhd -path F:\1GB.vhdx -Size 1GB -fixed | out-null}}).totalseconds
Write-host
Write-host "Total time for creation of 1GB fixed VHDX: $($time) seconds"
icm -ComputerName demo-laptop-2 -Credential $domainCred -Authentication Credssp {del f:\1GB.VHDX}
write-host
write-host "VHDX operations on REFS"
write-host
write-host "Press enter to create a 1GB fixed VHDX on an REFS partition"
read-host
$time = (measure-command {icm -ComputerName demo-laptop-2 -Credential $domainCred -Authentication Credssp {new-vhd -path G:\1GB.vhdx -Size 1GB -fixed | out-null}}).totalseconds
Write-host
Write-host "Total time for creation of 1GB fixed VHDX: $($time) seconds"
icm -ComputerName demo-laptop-2 -Credential $domainCred -Authentication Credssp {del G:\1GB.VHDX}
write-host
write-host "Press enter to create a 50GB fixed VHDX on an REFS partition"
read-host
$time = (measure-command {icm -ComputerName demo-laptop-2 -Credential $domainCred -Authentication Credssp {new-vhd -path G:\50GB.vhdx -Size 50GB -fixed | out-null}}).totalseconds
Write-host
Write-host "Total time for creation of 50GB fixed VHDX: $($time) seconds"
icm -ComputerName demo-laptop-2 -Credential $domainCred -Authentication Credssp {del G:\50GB.VHDX}
Write-host
write-host "Press enter to merge disk on NTFS partition"
read-host
$time = (measure-command {icm -ComputerName demo-laptop-2 -Credential $domainCred -Authentication Credssp {merge-vhd f:\diff.vhdx -DestinationPath f:\base.vhdx | out-null}}).totalseconds
Write-host
Write-host "Total time for VHDX merge: $($time) seconds"
icm -ComputerName demo-laptop-2 -Credential $domainCred -Authentication Credssp {del f:\base.vhdx}
Write-host
write-host "Press enter to merge disk on REFS partition"
read-host
$time = (measure-command {icm -ComputerName demo-laptop-2 -Credential $domainCred -Authentication Credssp {merge-vhd g:\diff.vhdx -DestinationPath G:\base.vhdx | out-null}}).totalseconds
Write-host
Write-host "Total time for VHDX merge: $($time) seconds"
icm -ComputerName demo-laptop-2 -Credential $domainCred -Authentication Credssp {del G:\base.vhdx}

        read-host}

        12 {# Remote management improvements
        Write-Output "Connect to HVManager"
        Write-Output "hvmanager\administrator" | clip
        Write-Output "Press enter to return to the demo menu"
        read-host}

        13 {# Multi-host level management
        Write-Output "enter-pssession clusnode1 -authentication credssp -credential `"IGNITE\Administrator`"" | clip
        start -FilePath powershell
        Write-Output "Press enter to return to the demo menu"
        read-host}

        14 {# Containers
        Write-Output "Containers!"
        read-host}

        15 {# Cleanly Shutdown the system
        Write-Output "Cleanly Shutdown the system!"
        read-host}

        16 {# Setup
        laptop1Setup
        laptop2Setup }

        17 {# Exit
        exit}
    }
    }    while (1 -eq 1)

