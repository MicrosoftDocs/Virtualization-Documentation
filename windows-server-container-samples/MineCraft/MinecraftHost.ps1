$containerHostVMName = "PowerShell Container"
$internetVirtualSwitch = "External Switch"
# Setup Admin credential
$localVMCred = new-object -typename System.Management.Automation.PSCredential `
             -argumentlist "Administrator", (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)

$host.UI.RawUI.BackgroundColor = "DarkMagenta"; Cls

icm -VMName $containerHostVMName -Credential $localVMCred {
   Param ([string]$internetVirtualSwitch)

   if ((get-containerimage | ? Name -eq "MinecraftBase").Count -eq 0)
      { # There is no Minecraft base image - we need to make one
      New-NetFirewallRule -DisplayName "Minecraft" -Direction Inbound -Action Allow -LocalPort @("25565") -Protocol TCP | Out-Null

      write-host "*******************************************************************"
      write-host "** No Minecraft Container base image found - creating base image **"
      write-host "*******************************************************************"

      # Create new container, start it and Enter-PSSession
      write-host "[Container Host]:: Create new container using Windows base image"
      $MCBase = New-Container "Minecraft-Base" -ContainerImageName "WindowsServerCore" -SwitchName $internetVirtualSwitch
      write-host "[Container Host]:: Start new container"
      Start-Container $MCBase
      write-host "[Container Host]:: Enter container `"MineCraft-Base`""
      # Note - admin cred is only needed for Java install - but there is an ACL'ing issue I need to investigate
      Invoke-Command -ContainerId $MCBase.ID -RunAsAdministrator {
         write-host "[MineCraft-Base]:: Create MineCraft Directory"
         # Create and change to Minecraft Directory
         md \MC | Out-Null; cd \MC
   
         # Wait for DHCP or NAT
         write-host "[MineCraft-Base]:: Wait for DHCP or NAT address to be acquired"
         While (((Get-NetIPAddress | ? AddressFamily -eq IPv4 | ? IPAddress -ne 127.0.0.1).SuffixOrigin -ne "Manual") -and ((Get-NetIPAddress | ? AddressFamily -eq IPv4 | ? IPAddress -ne 127.0.0.1).SuffixOrigin -ne "Dhcp")) {Sleep -Milliseconds 10}

         # Get the current version of Minecraft, and download the server jar
         write-host "[MineCraft-Base]:: Discover latest version of MineCraft Server"
         $version = (wget -Uri http://s3.amazonaws.com/Minecraft.Download/versions/versions.json -UseBasicParsing | ConvertFrom-Json).latest.release
         write-host "[MineCraft-Base]:: The latest version of MineCraft Server is: $($version)"
         write-host "[MineCraft-Base]:: Download MineCraft Server $($version)"
         wget -Uri "http://s3.amazonaws.com/Minecraft.Download/versions/$($version)/minecraft_server.$($version).jar" -outfile C:\MC\mcserver.jar  -UseBasicParsing
   
         # Download latest Java runtime
         write-host "[MineCraft-Base]:: Download latest version of Java"
         wget -Uri "http://javadl.sun.com/webapps/download/AutoDL?BundleId=107944" -outfile javaInstall.exe -UseBasicParsing

         # Install Java (registry key line is a hack to work around a bug)
         write-host "[MineCraft-Base]:: Installing Java"
         REG ADD HKLM\Software\Policies\Microsoft\Windows\Installer /v DisableRollback /t REG_DWORD /d 1 | Out-Null
         ./javaInstall.exe /s INSTALLDIR=C:\Java REBOOT=Disable | Out-Null

         write-host "[MineCraft-Base]:: Creating MineCraft EULA file"
         # Create Minecraft EULA file
         $eula = @"
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
eula=true
"@
         $eula | Out-File -FilePath .\eula.txt -Encoding ascii
   
         write-host "[MineCraft-Base]:: Creating MineCraft Server Properties file"
         # Create Minecraft Server Properties file
         $serverProperties = @"
#Minecraft server properties
motd=A Minecraft Server, in a container
online-mode=false
"@
         $serverProperties | Out-File -FilePath .\server.properties -Encoding ascii

         # Create other blank files so that Minecraft will not complain when it starts
         write-host "[MineCraft-Base]:: Creating MineCraft Banned Players file"
         New-Item -ItemType file .\banned-players.json | Out-Null
         write-host "[MineCraft-Base]:: Creating MineCraft Banned IPs file"
         New-Item -ItemType file .\banned-ips.json | Out-Null
         write-host "[MineCraft-Base]:: Creating MineCraft Ops file"
         New-Item -ItemType file .\ops.json | Out-Null
         write-host "[MineCraft-Base]:: Creating MineCraft Whitelist file"
         New-Item -ItemType file .\whitelist.json | Out-Null
         }

      # Stop the container
      write-host "[Container Host]:: Stop container"
      stop-container $mcbase

      # Create new container image from the container
      write-host "[Container Host]:: Create image from container"
      new-containerimage -Container $mcbase -Publisher "MineCraft" -Name "MinecraftBase" -Version 1.0

      # Remove the container - it is no longer needed
      write-host "[Container Host]:: Remove container"
      remove-container $mcbase -force
      }
  

   write-host "****************************************************************"
   write-host "** Setting up Minecraft Container using base image            **"
   write-host "****************************************************************"

   $cnName = "MC Server"

   # Create new container from base image
   write-host "[Container Host]:: Create new MineCraft server use MinecraftBase image"
   $MCServer = new-container -name $cnName -ContainerImageName "MinecraftBase"
   Add-ContainerNetworkAdapter -Container $MCServer -SwitchName $internetVirtualSwitch
   write-host "[Container Host]:: Start container `"$($cnName)`""
   Start-Container $MCServer
   
   # Enter the container
   write-host "[Container Host]:: Enter container `"$($cnName)`""
   Invoke-Command -ContainerId $MCServer.ID -RunAsAdministrator {
      Param ($cnName)
      write-host "[$($cnName)]:: Change to MineCraft directory"
      cd \MC

      write-host "[$($cnName)]:: Wait for IP Address"
      # Wait for an IP address
      while ((Get-NetIPAddress | ? AddressFamily -eq IPv4 | ? IPAddress -ne 127.0.0.1).SuffixOrigin -ne "Dhcp") {sleep -Milliseconds 10}
      write-host "[$($cnName)]:: IP Address: " (Get-NetIPAddress | ? AddressFamily -eq IPv4 | ? IPAddress -ne 127.0.0.1).IPAddress

      # Touch the Jar (Bug)
      (gci mcserver.jar).LastWriteTime = Get-Date

      write-host "[$($cnName)]:: Start MineCraft Server"
      # Start the MineCraft Server
      C:\java\bin\java.exe -Xmx1024M -Xms1024M -jar mcserver.jar nogui
      } -ArgumentList $cnName
   stop-container $MCServer
   remove-container $MCServer -force
   } -ArgumentList $internetVirtualSwitch
 