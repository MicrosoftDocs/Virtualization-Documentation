# Load variables from a seperate file - this when you pull down the latest factory file you can keep your paths / product keys etc...
. .\FactoryVariables.ps1
$startTime = get-date


# Helper function to make sure that needed folders are present
function checkPath
{
    param
    (
        [string] $path
    )
    if (!(Test-Path $path)) 
    {
        $null = md $path;
    }
}

# Test that necessary paths and files exist
# Don't create the workingDir automatically - if it doesn't exist, the variables probably need the be configured first.
if(-not (Test-Path -Path $workingDir -PathType Container)) {
  Throw "Working directory $workingDir does not exist - edit FactoryVariables.ps1 to configure script"
}

# Create folders in workingDir if they don't exist
checkPath "$($workingdir)\Share"
checkPath "$($workingdir)\Bases"
checkPath "$($workingdir)\ISOs"
checkPath "$($workingdir)\Resources"
checkPath "$($workingdir)\Resources\bits"

### Load Convert-WindowsImage - making sure it exists and is unblocked
if(Test-Path -Path "$($workingDir)\resources\Convert-WindowsImage.ps1") {
    . "$($workingDir)\resources\Convert-WindowsImage.ps1"
    if(!(Get-Command Convert-WindowsImage -ErrorAction SilentlyContinue)) {
        Write-Host -ForegroundColor Green 'Convert-WindowsImage.ps1 could not be loaded. Unblock the script or check execution policy'
        Throw 'Convert-WindowsImage was not loaded'
    }
} else {
    Write-Host -ForegroundColor Green "Please download Convert-WindowsImage.ps1 and place in $($workingDir)\Resources\"
    Write-Host -ForegroundColor Green "`nhttps://gallery.technet.microsoft.com/scriptcenter/Convert-WindowsImageps1-0fe23a8f`n"
    Throw 'Missing Convert-WindowsImage.ps1 script'
}

# Check that PSWindowsUpdate module exists
if(!(Test-Path -Path "$($workingDir)\Resources\bits\PSWindowsUpdate\PSWindowsUpdate.psm1")) {
    Write-Host -ForegroundColor Green "Please download PSWindowsUpdate and extract to $($workingDir)\Resources\bits"
    Write-Host -ForegroundColor Green "`nhttps://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc`n"
    Throw 'Missing PSWindowsUpdate module'
}


### Sysprep unattend XML
$unattendSource = [xml]@"
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <servicing></servicing>
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <ComputerName>*</ComputerName>
            <ProductKey>Key</ProductKey> 
            <RegisteredOrganization>Organization</RegisteredOrganization>
            <RegisteredOwner>Owner</RegisteredOwner>
            <TimeZone>TZ</TimeZone>
        </component>
        <component name="Microsoft-Windows-TerminalServices-LocalSessionManager" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
             <fDenyTSConnections>false</fDenyTSConnections> 
         </component> 
         <component name="Microsoft-Windows-TerminalServices-RDP-WinStationExtensions" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
             <UserAuthentication>0</UserAuthentication> 
         </component> 
         <component name="Networking-MPSSVC-Svc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
             <FirewallGroups> 
                 <FirewallGroup wcm:action="add" wcm:keyValue="RemoteDesktop"> 
                     <Active>true</Active> 
                     <Profile>all</Profile> 
                     <Group>@FirewallAPI.dll,-28752</Group> 
                 </FirewallGroup> 
             </FirewallGroups> 
         </component> 
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <NetworkLocation>Work</NetworkLocation>
                <ProtectYourPC>1</ProtectYourPC>
            </OOBE>
            <UserAccounts>
                <AdministratorPassword>
                    <Value>password</Value>
                    <PlainText>True</PlainText>
                </AdministratorPassword>
                <LocalAccounts>
                   <LocalAccount wcm:action="add">
                       <Password>
                           <Value>password</Value>
                           <PlainText>True</PlainText>
                       </Password>
                       <DisplayName>Demo</DisplayName>
                       <Group>Administrators</Group>
                       <Name>demo</Name>
                   </LocalAccount>
               </LocalAccounts>
            </UserAccounts>
            <AutoLogon>
               <Password>
                  <Value>password</Value>
               </Password>
               <Enabled>true</Enabled>
               <LogonCount>1000</LogonCount>
               <Username>Administrator</Username>
            </AutoLogon>
             <LogonCommands> 
                 <AsynchronousCommand wcm:action="add"> 
                     <CommandLine>%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell -NoLogo -NonInteractive -ExecutionPolicy Unrestricted -File %SystemDrive%\Bits\Logon.ps1</CommandLine> 
                     <Order>1</Order> 
                 </AsynchronousCommand> 
             </LogonCommands> 
        </component>
        <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InputLocale>en-us</InputLocale>
            <SystemLocale>en-us</SystemLocale>
            <UILanguage>en-us</UILanguage>
            <UILanguageFallback>en-us</UILanguageFallback>
            <UserLocale>en-us</UserLocale>
        </component>
    </settings>
</unattend>
"@

function CSVLogger ([string]$vhd, [switch]$sysprepped) {

   $createLogFile = $false
   $entryExists = $false
   $logCsv = @()
   $newEntry = $null

   # Check if the log file exists
   if (!(test-path $logFile))
      {$createLogFile = $true}
   else
      {$logCsv = import-csv $logFile
       if (($logCsv.Image -eq $null) -or `
           ($logCsv.Created -eq $null) -or `
           ($logCsv.Sysprepped -eq $null) -or `
           ($logCsv.Checked -eq $null)) 
           {# Something is wrong with the log file
            cleanupFile $logFile
            $createLogFile = $true}
            }

   if ($createLogFile) {$logCsv = @()} else {$logCsv = import-csv $logFile}

   # If we find an entry for the VHD, update it
   foreach ($entry in $logCsv)
      { if ($entry.Image -eq $vhd)
        {$entryExists = $true
         $entry.Checked = ((get-Date).ToShortDateString() + "::" + (Get-Date).ToShortTimeString())
         if ($sysprepped) {$entry.Sysprepped = ((get-Date).ToShortDateString() + "::" + (Get-Date).ToShortTimeString())}
        }
      }

   # if no entry is found, create a new one
   If (!$entryExists) 
      {$newEntry = New-Object PSObject -Property @{Image=$vhd; `
                                                   Created=((get-Date).ToShortDateString() + "::" + (Get-Date).ToShortTimeString()); `
                                                   Sysprepped=((get-Date).ToShortDateString() + "::" + (Get-Date).ToShortTimeString()); `
                                                   Checked=((get-Date).ToShortDateString() + "::" + (Get-Date).ToShortTimeString())}}

   # Write out the CSV file
   $logCsv | Export-CSV $logFile -notype
   if (!($newEntry -eq $null)) {$newEntry | Export-CSV $logFile -notype -Append}
   
}

function Logger ([string]$systemName, [string]$message)
    {# Function for displaying formatted log messages.  Also displays time in minutes since the script was started
     write-host (Get-Date).ToShortTimeString() -ForegroundColor Cyan -NoNewline
     write-host " - [" -ForegroundColor White -NoNewline
     write-host $systemName -ForegroundColor Yellow -NoNewline
     write-Host "]::$($message)" -ForegroundColor White}

# Helper function for no error file cleanup

function cleanupFile
{
    param
    (
        [string] $file
    )
    
    if (Test-Path $file) 
    {
        Remove-Item $file -Recurse > $null;
    }
}



function GetUnattendChunk 
{
    param
    (
        [string] $pass, 
        [string] $component, 
        [xml] $unattend
    ); 
    
    # Helper function that returns one component chunk from the Unattend XML data structure
    return $Unattend.unattend.settings | ? pass -eq $pass `
        | select -ExpandProperty component `
        | ? name -eq $component;
}

function makeUnattendFile ([string]$key, [string]$logonCount, [string]$filePath, [bool]$desktop = $false, [bool]$is32bit = $false) 
    {# Composes unattend file and writes it to the specified filepath
     
     # Reload template - clone is necessary as PowerShell thinks this is a "complex" object
     $unattend = $unattendSource.Clone()
     
    # Customize unattend XML
    GetUnattendChunk "specialize" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.ProductKey = $key};
    GetUnattendChunk "specialize" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.RegisteredOrganization = $Organization};
    GetUnattendChunk "specialize" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.RegisteredOwner = $Owner};
    GetUnattendChunk "specialize" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.TimeZone = $Timezone};
    GetUnattendChunk "oobeSystem" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.UserAccounts.AdministratorPassword.Value = $adminPassword};
    GetUnattendChunk "oobeSystem" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.AutoLogon.Password.Value = $adminPassword};
    GetUnattendChunk "oobeSystem" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.AutoLogon.LogonCount = $logonCount};

    if ($desktop)
    {
        GetUnattendChunk "oobeSystem" "Microsoft-Windows-Shell-Setup" $unattend | %{$_.UserAccounts.LocalAccounts.LocalAccount.Password.Value = $userPassword};
        # HideLocalAccountScreen setting applies only to the Windows Server editions, and only to Windows Server 2012 and above
        # This will remove the setting for desktop images
        $ns = New-Object System.Xml.XmlNamespaceManager($unattend.NameTable);
        $ns.AddNamespace("ns", $unattend.DocumentElement.NamespaceURI);
        $node = $unattend.SelectSingleNode("//ns:HideLocalAccountScreen", $ns);
        $node.ParentNode.RemoveChild($node) | Out-Null;
	}
    else
    {
        # Desktop needs a user other than "Administrator" to be present
        # This will remove the creation of the other user for server images
        $ns = New-Object System.Xml.XmlNamespaceManager($unattend.NameTable);
        $ns.AddNamespace("ns", $unattend.DocumentElement.NamespaceURI);
        $node = $unattend.SelectSingleNode("//ns:LocalAccounts", $ns);
        $node.ParentNode.RemoveChild($node) | Out-Null;

        if ($FriendlyName.substring(0,19) -eq "Windows Server 2008")
        {
            # HideLocalAccountScreen setting applies only to the Windows Server editions, and only to Windows Server 2012 and above
            # This will remove the setting for Windows Server 2008 R2 images
            $ns = New-Object System.Xml.XmlNamespaceManager($unattend.NameTable);
            $ns.AddNamespace("ns", $unattend.DocumentElement.NamespaceURI);
            $node = $unattend.SelectSingleNode("//ns:HideLocalAccountScreen", $ns);
            $node.ParentNode.RemoveChild($node) | Out-Null;
    	}
    }
     
     if ($is32bit) {$unattend.InnerXml = $unattend.InnerXml.Replace('processorArchitecture="amd64"', 'processorArchitecture="x86"')}

     # Write it out to disk
     cleanupFile $filePath; $Unattend.Save($filePath)}

function createRunAndWaitVM 
{
    param
    (
        [string] $vhd, 
        [string] $gen
    );
    
    # Function for whenever I have a VHD that is ready to run
    New-VM $factoryVMName -MemoryStartupBytes $VMMemory -VHDPath $vhd -Generation $Gen -SwitchName $virtualSwitchName -ErrorAction Stop| Out-Null

    If($UseVLAN) {
        Get-VMNetworkAdapter -VMName $factoryVMName | Set-VMNetworkAdapterVlan -Access -VlanId $VlanId
    }

    set-vm -Name $factoryVMName -ProcessorCount 2;
    Start-VM $factoryVMName;
    
      # Give the VM a moment to start before we start checking for it to stop
      Sleep -Seconds 10

      # Wait for the VM to be stopped for a good solid 5 seconds
      do {$state1 = (Get-VM | ? name -eq $factoryVMName).State; sleep -Seconds 5
          $state2 = (Get-VM | ? name -eq $factoryVMName).State; sleep -Seconds 5} 
          until (($state1 -eq "Off") -and ($state2 -eq "Off"))

      # Clean up the VM
      Remove-VM $factoryVMName -Force}

function MountVHDandRunBlock 
{
    param
    (
        [string]$vhd, 
        [scriptblock]$block,
        [switch]$ReadOnly
    );
     
    # This function mounts a VHD, runs a script block and unmounts the VHD.
    # Drive letter of the mounted VHD is stored in $driveLetter - can be used by script blocks
    if($ReadOnly) {
        $driveLetter = (Mount-VHD $vhd -ReadOnly -Passthru | Get-Disk | Get-Partition | Get-Volume).DriveLetter;
    } else {
        $driveLetter = (Mount-VHD $vhd -Passthru | Get-Disk | Get-Partition | Get-Volume).DriveLetter;
    }
    & $block;

    Dismount-VHD $vhd;

    # Wait 2 seconds for activity to clean up
    Start-Sleep -Seconds 2;
}


### Update script block
$updateCheckScriptBlock = {
    function Logger {
        param
        (
            [string]$message
        );

        # Function for displaying formatted log messages.  Also displays time in minutes since the script was started
        write-host (Get-Date).ToShortTimeString() -ForegroundColor Cyan -NoNewline;
        write-host " - ::$($message)" -ForegroundColor White;
    }

    # Clean up unattend file if it is there
    if (Test-Path "$ENV:SystemDrive\Unattend.xml") 
    {
        Remove-Item -Force "$ENV:SystemDrive\Unattend.xml"
    }

    # Elements of the script rely on PowerShell 3.0, so install updated PowerShell if necessary
    if ($PSVersionTable.PSVersion.Major -lt 3)
    {
        logger "Not running PowerShell 3.0 or above"
        # First check .NET Framework 4.5 full version prerequisite
        $DNVersion = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -name Version -EA 0 | Where-Object { $_.PSChildName -match '^(?!S)\p{L}'} | Sort-Object version -Descending | Select-Object -ExpandProperty Version -First 1 
        $DNVersions = $DNVersion.Split(".") 
        $DNVersionMajor = $DNVersions[0] 
        $DNVersionMinor = $DNVersions[1] 
        $DNVersionBuild = $DNVersions[2]

        if (($DNVersionMajor -eq 4 -and $DNVersionMinor -ge 5) -or ($DNVersionMajor -ge 4))
        {
            logger ".NET prerequisites met"
        }
        else
        {
            logger ".NET update required"
            if (!(test-path -Path "C:\Temp"))
            { 
                New-Item -ItemType Directory -Force -Path "C:\Temp" > $null
            }
            logger "Downloading .NET 4.5.2" 
            $download = New-Object Net.WebClient 
            $url = "http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
            $file = ("C:\Temp\NDP452-KB2901907-x86-x64-AllOS-ENU.exe") 
            $download.Downloadfile($url,$file) 
            if (!(Test-Path -Path "C:\Temp\NDP452-KB2901907-x86-x64-AllOS-ENU.exe"))
            {
                logger "Download failed. Please check your Internet connection"
            }
            else
            {
                logger "Installing .NET 4.5.2"
                $InstallDotNet = Start-Process $file -ArgumentList "/q /norestart" -Wait -PassThru 
                logger ".NET 4.5.2 installation complete"
            }	
        }    		
		
        logger "Downloading Windows Management Framework 4.0"
        if (!(test-path -Path "C:\Temp"))
        { 
            New-Item -ItemType Directory -Force -Path "C:\Temp" > $null
        }
        $download = New-Object Net.WebClient 
        $url = "http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-x64-MultiPkg.msu"
        $file = ("C:\Temp\Windows6.1-KB2819745-x64-MultiPkg.msu")
        $commandline =  "C:\Temp\Windows6.1-KB2819745-x64-MultiPkg.msu /quiet /norestart"
        $download.Downloadfile($url,$file) 
        if (!(Test-Path -Path "C:\Temp\Windows6.1-KB2819745-x64-MultiPkg.msu"))
        {
            logger "Download failed. Please check your Internet connection"
        }
        else
        {
            logger "Installing Windows Management Framework 4.0"
            $InstallWMF = Start-Process -FilePath 'wusa.exe' -ArgumentList "$commandline" -Wait -PassThru 
            logger "Windows Management Framework 4.0 installation complete"
        }
        Invoke-Expression 'shutdown -r -t 0'
    }
	
    # Check to see if files need to be unblocked - if they do, do it and reboot
    if ((Get-ChildItem $env:SystemDrive\Bits | `
        Get-Item -Stream "Zone.Identifier" -ErrorAction SilentlyContinue).Count -gt 0)
    {
        Get-ChildItem $env:SystemDrive\Bits | Unblock-File;
        Invoke-Expression 'shutdown -r -t 0'
    }

    # To get here - the files are unblocked
    Import-Module $env:SystemDrive\Bits\PSWindowsUpdate\PSWindowsUpdate;

    # Set static IP address - do not change values here, change them in FactoryVariables.ps1
    $UseStaticIP = STATICIPBOOLPLACEHOLDER
    if($UseStaticIP) {
        $IP = 'IPADDRESSPLACEHOLDER'
        $MaskBits = 'SUBNETMASKPLACEHOLDER'
        $Gateway = 'GATEWAYPLACEHOLDER'
        $DNS = 'DNSPLACEHOLDER'
        $IPType = 'IPTYPEPLACEHOLDER'

        $adapter = Get-NetAdapter | Where-Object {$_.Status -eq 'up'}
        # Remove any existing IP, gateway from our ipv4 adapter
        If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
            $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
        }
        If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
            $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
        }
        # Configure the IP address and default gateway
        $adapter | New-NetIPAddress -AddressFamily $IPType `
            -IPAddress $IP `
            -PrefixLength $MaskBits `
            -DefaultGateway $Gateway 
        # Configure the DNS client server IP addresses
        $adapter | Set-DnsClientServerAddress -ServerAddresses $DNS  
    }



    # Need to add check for Internet connectivity due to Windows 7 driver load timing fail
	logger "Checking for Internet connection" 
    do
    {
        Start-Sleep -Seconds 5;
		logger "Checking for Internet connection"
    } until (Test-Connection -computername www.microsoft.com)
	
    # Run pre-update script if it exists
    if (Test-Path "$env:SystemDrive\Bits\PreUpdateScript.ps1") {
        & "$env:SystemDrive\Bits\PreUpdateScript.ps1"
    }

    # Check if any updates are needed - leave a marker if there are
	logger "Checking for updates" 
    if ((Get-WUList).Count -gt 0)
    {
        if (-not (Test-Path $env:SystemDrive\Bits\changesMade.txt))
        {
            New-Item $env:SystemDrive\Bits\changesMade.txt -type file > $null;
        }
    }

 
    # Apply all the updates
    logger "Applying the updates"
    Get-WUInstall -AcceptAll -IgnoreReboot -IgnoreUserInput -NotCategory "Language packs";

    # Run post-update script if it exists
    if (Test-Path "$env:SystemDrive\Bits\PostUpdateScript.ps1") {
        & "$env:SystemDrive\Bits\PostUpdateScript.ps1"
    }

    # Remove static IP address
    if($UseStaticIP) {
        $adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
        $interface = $adapter | Get-NetIPInterface -AddressFamily $IPType

        If ($interface.Dhcp -eq "Disabled") {
            If (($interface | Get-NetIPConfiguration).Ipv4DefaultGateway) { 
                $interface | Remove-NetRoute -Confirm:$false
            }
            $interface | Set-NetIPInterface -DHCP Enabled
            $interface | Set-DnsClientServerAddress -ResetServerAddresses
        }
    }

    # Reboot if needed - otherwise shutdown because we are done
    if (Get-WURebootStatus -Silent) 
    {
        Invoke-Expression 'shutdown -r -t 0';
    } 
    else
    {
        invoke-expression 'shutdown -s -t 0';
    }
};


function Set-UpdateCheckPlaceHolders {
    $block = $updateCheckScriptBlock | Out-String -Width 4096
    
    if($UseStaticIP) {
        $block = $block.Replace('$UseStaticIP = STATICIPBOOLPLACEHOLDER', '$UseStaticIP = $true')
        $block = $block.Replace('IPADDRESSPLACEHOLDER', $IP)
        $block = $block.Replace('SUBNETMASKPLACEHOLDER', $MaskBits)
        $block = $block.Replace('GATEWAYPLACEHOLDER', $Gateway)
        $block = $block.Replace('DNSPLACEHOLDER', $DNS)
        $block = $block.Replace('IPTYPEPLACEHOLDER', $IPType)
    } else {
        $block = $block.Replace('$UseStaticIP = STATICIPBOOLPLACEHOLDER', '$UseStaticIP = $false')
    }
    return $block
}

### Sysprep script block
$sysprepScriptBlock = {

    # Run pre-sysprep script if it exists
    if (Test-Path "$env:SystemDrive\Bits\PreSysprepScript.ps1") {
        & "$env:SystemDrive\Bits\PreSysprepScript.ps1"
    }

    # Remove Unattend entries from the autorun key if they exist
    foreach ($regvalue in (Get-Item -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run).Property)
	{
		if ($regvalue -like "Unattend*")
		{
		    # could be multiple unattend* entries
		    foreach ($unattendvalue in $regvalue)
		    {
			    Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -name $unattendvalue
		    }
        }
	}
             
     $unattendedXmlPath = "$ENV:SystemDrive\Bits\Unattend.xml" 
     & "$ENV:SystemRoot\System32\Sysprep\Sysprep.exe" `/generalize `/oobe `/shutdown `/unattend:"$unattendedXmlPath"}

### Post Sysprep script block
$postSysprepScriptBlock = {
    # Remove Unattend entries from the autorun key if they exist
    foreach ($regvalue in (Get-Item -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run).Property)
	{
		if ($regvalue -like "Unattend*")
		{
		    # could be multiple unattend* entries
		    foreach ($unattendvalue in $regvalue)
		    {
			    Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -name $unattendvalue
		    }
        }
	}

    # Run post-sysprep script if it exists
    if (Test-Path "$env:SystemDrive\Bits\PostSysprepScript.ps1") {
        & "$env:SystemDrive\Bits\PostSysprepScript.ps1"
    }

    # Clean up unattend file if it is there
    if (Test-Path "$ENV:SystemDrive\Unattend.xml") 
    {
        Remove-Item -Force "$ENV:SystemDrive\Unattend.xml";
    }

    # Clean up bits
    if(Test-Path "$ENV:SystemDrive\Bits")
    {
        Remove-Item -Force -Recurse "$ENV:SystemDrive\Bits";
    } 
     
    # Clean up temp
    if(Test-Path "$ENV:SystemDrive\Temp")
    {
        Remove-Item -Force -Recurse "$ENV:SystemDrive\Temp";
    } 

    # Remove Demo user
	$computer = $env:computername
	$user = "Demo"
	if ([ADSI]::Exists("WinNT://$computer/$user"))
	{
	    [ADSI]$server = "WinNT://$computer"
	    $server.delete("user",$user)
	}
	
    # Put any code you want to run Post sysprep here
    Invoke-Expression 'shutdown -r -t 0';
};

# This is the main function of this script
function Start-ImageFactory
{
	<#
			.SYNOPSIS
			Creates or updates a windows image with the latest windows updates.

            .DESCRIPTION
            This function creates fully updated VHD images for deployment as virtual machines.

            The first time it is called for a particular windows type, it creates a fresh install in a Hyper-V virtual machine,
            updates it, and saves a sysprepped image. The unsysprepped VHD is kept so future runs only need to install new updates.

            Much of the configuration is done in FactoryVariables.ps1, which must be edited to suit your environment.

			.PARAMETER FriendlyName
			Used as the file name for the image.

            .PARAMETER ISOFile
            The ISO or WIM file to use as the base of the windows image.

            .PARAMETER SKUEdition
            The name of index number of the edition to use from the ISO/WIM file.  
            eg. "Professional" or "ServerDataCenter"

            .PARAMETER ProductKey
            The product key to use for the unattended installation.

            .PARAMETER Desktop
            Set to $true for desktop windows versions. Creates a regular user account, which is required by the desktop unattended installation.

            .PARAMETER Is32Bit
            Set to $true for 32 bit images to create the unattend file correctly.

            .PARAMETER Generation2
            Create a generation 2 virtual machine.  Default is generation 1

            .PARAMETER GenericSysprep
            Run the final sysprep without specifying a /unattend file.  This is required by some deployment tools like SCVMM which will run their own sysprep when deploying.

            .NOTES
            This script requires two additional downloads:
            PSWindowsUpdate from https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc

            Convert-WindowsImage.ps1 from https://gallery.technet.microsoft.com/scriptcenter/Convert-WindowsImageps1-0fe23a8f

			.LINK
            https://github.com/BenjaminArmstrong/Hyper-V-PowerShell

            .EXAMPLE
            Start-ImageFactory -FriendlyName "Windows Server 2012 R2 DataCenter with GUI" -ISOFile c:\path\to\isos\server2012r2.iso -ProductKey "W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9" -SKUEdition "ServerDataCenter"

            .EXAMPLE
            Start-ImageFactory -FriendlyName "Windows Server 2012 R2 DataCenter Core - Gen 2" -ISOFile c:\path\to\isos\server2012r2.iso -ProductKey "W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9" -SKUEdition "ServerDataCenterCore" -Generation2

            .EXAMPLE
            Start-ImageFactory -FriendlyName "Windows 8.1 Professional - 32 bit" -ISOFile c:\path\to\isos\windows81.iso -ProductKey "GCRJD-8NW9H-F2CDX-CCM8D-9D6T9" -SKUEdition "Professional" -desktop $true -is32bit $true

	#>


    param
    (
        [Parameter(Mandatory=$true)][string]$FriendlyName,
        [string]$ISOFile,
        [string]$ProductKey,
        [string]$SKUEdition,
        [bool]$desktop = $false,
        [bool]$is32bit = $false,
        [switch]$Generation2,
        [bool] $GenericSysprep = $false
    );

    logger $FriendlyName "Starting a new cycle!"

    # Setup a bunch of variables 
    $sysprepNeeded = $true;

    $VHDFormat = "vhdx";
    if ($LegacyVHD)
    {
        $VHDFormat = "vhd";
    }

    $baseVHD = "$($workingDir)\bases\$($FriendlyName)-base.$($VHDFormat)";
    $updateVHD = "$($workingDir)\$($FriendlyName)-update.$($VHDFormat)";
    $sysprepVHD = "$($workingDir)\$($FriendlyName)-sysprep.$($VHDFormat)";
    $finalVHD = "$($workingDir)\share\$($FriendlyName).$($VHDFormat)";
   
    $VHDPartitionStyle = "MBR";
    $Gen = 1;
    if ($Generation2) 
    {
        $VHDPartitionStyle = "GPT";
        $Gen = 2;
    }

    # Verify product key
    if(-not ($ProductKey -imatch '^[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}$')) {
        logger $FriendlyName 'Invalid product key, skipping this product'
        return
    }

    logger $FriendlyName "Checking for existing Factory VM";

    # Check if there is already a factory VM - and kill it if there is
    if ((Get-VM | ? Name -eq $factoryVMName).Count -gt 0)
    {
        Stop-VM $factoryVMName -TurnOff -Confirm:$false -Passthru | Remove-VM -Force;
    }

    # Check for a base VHD
    if (-not (test-path $baseVHD))
    {
        if (-not (Test-Path $ISOFile)) {
            logger $FriendlyName 'ISO/WIM file missing, skipping this product.'
            return
        }

        # No base VHD - we need to create one
        logger $FriendlyName "No base VHD!";

        # Make unattend file
        logger $FriendlyName "Creating unattend file for base VHD";

        # Logon count is just "large number"
        makeUnattendFile -key $ProductKey -logonCount "1000" -filePath "$($workingDir)\unattend.xml" -desktop $desktop -is32bit $is32bit;
      
        # Time to create the base VHD
        logger $FriendlyName "Create base VHD using Convert-WindowsImage.ps1";
        $ConvertCommand = "Convert-WindowsImage";
        $ConvertCommand = $ConvertCommand + " -SourcePath `"$ISOFile`" -VHDPath `"$baseVHD`"";
        $ConvertCommand = $ConvertCommand + " -SizeBytes 80GB -VHDFormat $VHDFormat -UnattendPath `"$($workingDir)\unattend.xml`"";
        $ConvertCommand = $ConvertCommand + " -Edition $SKUEdition -VHDPartitionStyle $VHDPartitionStyle";

        Invoke-Expression "& $ConvertCommand";

        # Clean up unattend file - we don't need it any more
        logger $FriendlyName "Remove unattend file now that that is done";
        cleanupFile "$($workingDir)\unattend.xml";

        logger $FriendlyName "Mount VHD and copy bits in, also set startup file";
        MountVHDandRunBlock $baseVHD {
            cleanupFile -file "$($driveLetter):\Convert-WindowsImageInfo.txt";

            # Copy bits to VHD
            Copy-Item "$($ResourceDirectory)\bits" -Destination ($driveLetter + ":\") -Recurse;
            
            # Create first logon script
            Set-UpdateCheckPlaceHolders | Out-File -FilePath "$($driveLetter):\Bits\Logon.ps1" -Width 4096;
        }

        logger $FriendlyName "Create virtual machine, start it and wait for it to stop...";
        createRunAndWaitVM $baseVHD $Gen;

        # Remove Page file
        logger $FriendlyName "Removing the page file";
        MountVHDandRunBlock $baseVHD {
            attrib -s -h "$($driveLetter):\pagefile.sys";
            cleanupFile "$($driveLetter):\pagefile.sys";
        }

        # Compact the base file
        logger $FriendlyName "Compacting the base file";
        Optimize-VHD -Path $baseVHD -Mode Full;
    }
    else
    {
        # The base VHD existed - time to check if it needs an update
        logger $FriendlyName "Base VHD exists - need to check for updates";

        # create new diff to check for updates
        logger $FriendlyName "Create new differencing disk to check for updates";
        cleanupFile $updateVHD;
        New-VHD -Path $updateVHD -ParentPath $baseVHD | Out-Null;

        logger $FriendlyName "Copy login file for update check, also make sure flag file is cleared"
        MountVHDandRunBlock $updateVHD {
            # Refresh the Bits folder
            cleanupFile "$($driveLetter):\Bits"
            Copy-Item "$($ResourceDirectory)\bits" -Destination ($driveLetter + ":\") -Recurse;
            # Create the update check logon script
            Set-UpdateCheckPlaceHolders | Out-File -FilePath "$($driveLetter):\Bits\Logon.ps1" -Width 4096;
        }

        logger $FriendlyName "Create virtual machine, start it and wait for it to stop...";
        createRunAndWaitVM $updateVHD $Gen;

        # Mount the VHD
        logger $FriendlyName "Mount the differencing disk";
        $driveLetter = (Mount-VHD $updateVHD -Passthru | Get-Disk | Get-Partition | Get-Volume).DriveLetter;
 
        # Check to see if changes were made
        logger $FriendlyName "Check to see if there were any updates";
        if (Test-Path "$($driveLetter):\Bits\changesMade.txt") 
        {
            cleanupFile "$($driveLetter):\Bits\changesMade.txt";
            logger $FriendlyName "Updates were found";
        }
        else 
        {
            logger $FriendlyName "No updates were found"; 
            $sysprepNeeded = $false;
        }

        # Dismount
        logger $FriendlyName "Dismount the differencing disk";
        Dismount-VHD $updateVHD;

        # Wait 2 seconds for activity to clean up
        Start-Sleep -Seconds 2;

        # If changes were made - merge them in.  If not, throw it away
        if ($sysprepNeeded) 
        {
            logger $FriendlyName "Merge the differencing disk";
            Merge-VHD -Path $updateVHD -DestinationPath $baseVHD;
        }
        else 
        {
            logger $FriendlyName "Delete the differencing disk"; 
            CSVLogger $finalVHD;
            cleanupFile $updateVHD;
        }
    }

    # Final Check - if the final VHD is missing - we need to sysprep and make it
    if (-not (Test-Path $finalVHD)) 
    {
        $sysprepNeeded = $true;
    }

    if ($sysprepNeeded)
    {
        # create new diff to sysprep
        logger $FriendlyName "Need to run Sysprep";
        logger $FriendlyName "Creating differencing disk";
        cleanupFile $sysprepVHD; new-vhd -Path $sysprepVHD -ParentPath $baseVHD | Out-Null;

        logger $FriendlyName "Mount the differencing disk and copy in files";
        MountVHDandRunBlock $sysprepVHD {
            $sysprepScriptBlockString = $sysprepScriptBlock | Out-String;

            if($GenericSysprep)
            {
                $sysprepScriptBlockString = $sysprepScriptBlockString.Replace(' `/unattend:"$unattendedXmlPath"', "");
            }
            else
            {
                # Make unattend file
                makeUnattendFile -key $ProductKey -logonCount "1" -filePath "$($driveLetter):\Bits\unattend.xml" -desktop $desktop -is32bit $is32bit;
            }
            
            # Make the logon script
            cleanupFile "$($driveLetter):\Bits\Logon.ps1";
            $sysprepScriptBlockString | Out-File -FilePath "$($driveLetter):\Bits\Logon.ps1" -Width 4096;
        }

        logger $FriendlyName "Create virtual machine, start it and wait for it to stop...";
        createRunAndWaitVM $sysprepVHD $Gen;

        logger $FriendlyName "Mount the differencing disk and cleanup files";
        MountVHDandRunBlock $sysprepVHD {
            cleanupFile "$($driveLetter):\Bits\unattend.xml";
            cleanupFile "$($driveLetter):\Bits\Logon.ps1";

            if(-not $GenericSysprep)
            {
                # Make the logon script
                $postSysprepScriptBlock | Out-String | Out-File -FilePath "$($driveLetter):\Bits\Logon.ps1" -Width 4096;
            }
            else
            {
                # Cleanup \Bits as the postSysprepScriptBlock is not run anymore
                cleanupFile "$($driveLetter):\Bits";
            }
        }

        # Remove Page file
        logger $FriendlyName "Removing the page file";
        MountVHDandRunBlock $sysprepVHD {

            attrib -s -h "$($driveLetter):\pagefile.sys";
            cleanupFile "$($driveLetter):\pagefile.sys";
        }

        # Produce the final disk
        cleanupFile $finalVHD;
        logger $FriendlyName "Convert differencing disk into pristine base image";
        Convert-VHD -Path $sysprepVHD -DestinationPath $finalVHD -VHDType Dynamic;
        if($CleanWinSXS) {
            logger $FriendlyName "Cleaning windows component store. Be patient, this may take awhile."
            MountVHDandRunBlock $finalVHD {
                # Clean up the WinSXS store, and remove any superceded components. Updates will no longer be able to be uninstalled,
                # but saves a considerable amount of disk space.
                dism.exe /image:$($driveLetter):\ /Cleanup-Image /StartComponentCleanup /ResetBase
            }
        }
        logger $FriendlyName "Optimizing VHD file"
        # Mounting the VHD read only allows it to be compacted better.
        # Running Optimize-VHD twice seems to be necessary - don't know why, but it works.
        MountVHDandRunBlock -ReadOnly $finalVHD {
            Optimize-VHD $finalVHD -Mode Full
            Optimize-VHD $finalVHD -Mode Full
        }
        logger $FriendlyName "Delete differencing disk";
        CSVLogger $finalVHD -sysprepped;
        cleanupFile $sysprepVHD;
    }
}

if($startfactory) {

    Start-ImageFactory -FriendlyName "Windows Server 2016 DataCenter Core - Gen 2" -ISOFile $2016Image -ProductKey $Windows2016Key -SKUEdition "ServerDataCenterCore" -Generation2;
    Start-ImageFactory -FriendlyName "Windows Server 2016 DataCenter with GUI - Gen 2" -ISOFile $2016Image -ProductKey $Windows2016Key -SKUEdition "ServerDataCenter" -Generation2;
    Start-ImageFactory -FriendlyName "Windows Server 2012 R2 DataCenter with GUI" -ISOFile $2012R2Image -ProductKey $Windows2012R2Key -SKUEdition "ServerDataCenter";
    Start-ImageFactory -FriendlyName "Windows Server 2012 R2 DataCenter Core" -ISOFile $2012R2Image -ProductKey $Windows2012R2Key -SKUEdition "ServerDataCenterCore";
    Start-ImageFactory -FriendlyName "Windows Server 2012 R2 DataCenter with GUI - Gen 2" -ISOFile $2012R2Image -ProductKey $Windows2012R2Key -SKUEdition "ServerDataCenter" -Generation2;
    Start-ImageFactory -FriendlyName "Windows Server 2012 R2 DataCenter Core - Gen 2" -ISOFile $2012R2Image -ProductKey $Windows2012R2Key -SKUEdition "ServerDataCenterCore" -Generation2;
    Start-ImageFactory -FriendlyName "Windows Server 2012 DataCenter with GUI" -ISOFile $2012Image -ProductKey $Windows2012Key -SKUEdition "ServerDataCenter";
    Start-ImageFactory -FriendlyName "Windows Server 2012 DataCenter Core" -ISOFile $2012Image -ProductKey $Windows2012Key -SKUEdition "ServerDataCenterCore";
    Start-ImageFactory -FriendlyName "Windows Server 2012 DataCenter with GUI - Gen 2" -ISOFile $2012Image -ProductKey $Windows2012Key -SKUEdition "ServerDataCenter" -Generation2;
    Start-ImageFactory -FriendlyName "Windows Server 2012 DataCenter Core - Gen 2" -ISOFile $2012Image -ProductKey $Windows2012Key -SKUEdition "ServerDataCenterCore" -Generation2;
    Start-ImageFactory -FriendlyName "Windows Server 2008 R2 DataCenter with GUI" -ISOFile $2008R2Image -ProductKey $Windows2008R2Key -SKUEdition "ServerDataCenter";
    Start-ImageFactory -FriendlyName "Windows Server 2008 R2 DataCenter Core" -ISOFile $2008R2Image -ProductKey $Windows2008R2Key -SKUEdition "ServerDataCenterCore";
    Start-ImageFactory -FriendlyName "Windows 8.1 Professional" -ISOFile $81x64Image -ProductKey $Windows81Key -SKUEdition "Professional" -desktop $true;
    Start-ImageFactory -FriendlyName "Windows 8.1 Professional - Gen 2" -ISOFile $81x64Image -ProductKey $Windows81Key -SKUEdition "Professional" -Generation2  -desktop $true;
    Start-ImageFactory -FriendlyName "Windows 8.1 Professional - 32 bit" -ISOFile $81x86Image -ProductKey $Windows81Key -SKUEdition "Professional" -desktop $true -is32bit $true;
    Start-ImageFactory -FriendlyName "Windows 8 Professional" -ISOFile $8x64Image -ProductKey $Windows8Key -SKUEdition "Professional" -desktop $true;
    Start-ImageFactory -FriendlyName "Windows 8 Professional - Gen 2" -ISOFile $8x64Image -ProductKey $Windows8Key -SKUEdition "Professional" -Generation2 -desktop $true;
    Start-ImageFactory -FriendlyName "Windows 8 Professional - 32 bit" -ISOFile $8x86Image -ProductKey $Windows8Key -SKUEdition "Professional" -desktop $true -is32bit $true;
    Start-ImageFactory -FriendlyName "Windows 7 Enterprise" -ISOFile $7x64Image -ProductKey $Windows7Key -SKUEdition "Enterprise" -desktop $true;
    Start-ImageFactory -FriendlyName "Windows 7 Enterprise - 32 bit" -ISOFile $7x86Image -ProductKey $Windows7Key -SKUEdition "Enterprise" -desktop $true -is32bit $true;
    Start-ImageFactory -FriendlyName "Windows 10 Professional" -ISOFile $10x64Image -ProductKey $Windows10Key -SKUEdition "Professional" -desktop $true;
    Start-ImageFactory -FriendlyName "Windows 10 Professional - Gen 2" -ISOFile $10x64Image -ProductKey $Windows10Key -SKUEdition "Professional" -Generation2 -desktop $true;
    Start-ImageFactory -FriendlyName "Windows 10 Professional - 32 bit" -ISOFile $10x86Image -ProductKey $Windows10Key -SKUEdition "Professional" -desktop $true -is32bit $true;

} else {
    If($myinvocation.InvocationName -eq '.') {
        Write-Host 'Start-ImageFactory is ready to use'
    } else {
        Write-Host 'Image Factory is set to be dot sourced.  If you want to run this script directly, changed $startfactory to $true in FactoryVariables.ps1'
    }
}
