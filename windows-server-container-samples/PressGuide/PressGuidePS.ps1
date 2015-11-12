
#Clean Container Host
Get-Container | Stop-Container
Get-Container | Remove-Container -force
Get-ContainerImage -Name *Image* | Remove-ContainerImage -force
Write-Output "Container Host was cleaned!"

#Get VMSwitch from Host
$VMSwitch = Get-VMSwitch
if ($VMSwitch)
{
    Write-Output "Virtual Switch for Containers ok!"
}
else
{
    Write-Output "The Host does not contain a Virtual Switch. Create a new Virtual Switch to continue!"
    exit
}

#Get WindowsServerCore Base Container Image
$BaseCoreImage = Get-ContainerImage -Name WindowsServerCore
if ($BaseCoreImage)
{
    Write-Output "Base Core Image for Containers ok!"
}
else
{
    Write-Output "The Host does not contain a Base Image. Check the documentation for creating a Container Host with Base Core Image!"
    exit
}


#Create new container based on WindowsServerCore Image
$CTN01 = New-Container -Name CTN01 -ContainerImageName WindowsServerCore -SwitchName $VMSwitch.Name
Write-Output "New Base Container Created!"

#Start Container
Start-Container -Name $CTN01.Name
Write-Output "Container Started... Entering Container!"

#Invoke Command and Install IIS
Invoke-Command -ContainerID $CTN01.Id -RunAsAdministrator -ScriptBlock {
Install-WindowsFeature -name web-server
if ((Get-WindowsFeature web-server).Installed)
        {
            Write-Output "Web Server installed successfully on Container!"
        }
        else
        {
            Install-WindowsFeature -name web-server
            Write-Output "Web Server was Installed on Container... Ignore the Error Message above."
        }
}
Write-Output "Exiting Container!"

#Shutdown Container
Stop-Container -Name $CTN01.Name
Write-Output "Base Container Stoped... Creating new Container Image!"

#Create Container Image from Container
New-ContainerImage -Name IISContainerImage -Container $CTN01 -Publisher Contoso -Version 1.0
Write-Output "New Container Image created 'IISContainerImage'!"

#Create new container from Container Image
$CTN02 = New-Container -Name CTN02 -ContainerImageName IISContainerImage -SwitchName $VMSwitch.Name
Write-Output "New Container created from Container Image!"

#Start new Container
Start-Container -Name $CTN02.Name
Write-Output "New Container started!"

#Get Container IP Address
Invoke-Command -ContainerID $CTN02.Id -RunAsAdministrator -ScriptBlock {ipconfig}
Write-Output "Use the IP Address above to test the Web Site from another machine. The IIS Welcome Screen should be presented to you!"
