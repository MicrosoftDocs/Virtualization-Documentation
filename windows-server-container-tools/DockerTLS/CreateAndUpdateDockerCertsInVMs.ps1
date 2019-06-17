<#
    .NOTES
        Copyright (c) Microsoft Corporation.  All rights reserved.

        Use of this sample source code is subject to the terms of the Microsoft
        license agreement under which you licensed this sample source code. If
        you did not accept the terms of the license agreement, you are not
        authorized to use this sample source code. For the terms of the license,
        please see the license agreement between you and Microsoft or, if applicable,
        see the LICENSE.RTF on your install media or the root of your tools installation.
        THE SAMPLE SOURCE CODE IS PROVIDED "AS IS", WITH NO WARRANTIES.
    
    .SYNOPSIS
        Sample code for creating a Docker Server Certificate and Copying it to a Hyper-V VM.

    .DESCRIPTION
        Sample code for creating a Docker Server Certificate and Copying it to a Hyper-V VM.
   
    .PARAMETER VmName 
        The VM to Create the Certifcate For

    .PARAMETER GuestUserName 
        The Username in the VM to operate as, must be an administrator

    .PARAMETER GuestPassword 
        The password for the GuestUserName in the VM to Operate as
                    
    .EXAMPLE
        .\CreateAndUpdateDockerCertsInVMs.ps1 -VmName "VM1" -GuestUserName "administrator" -GuestPassword (ConvertTo-SecureString -String "p@ssw0rd" -AsPlainText -Force)    
#>

Param(
    [String]$VmName = "VM1",
    [String]$GuestUserName = "administrator",
    [SecureString] $GuestPassword = (ConvertTo-SecureString -String "p@ssw0rd" -AsPlainText -Force)
    )

$guestCredentals =  New-Object System.Management.Automation.PSCredential($GuestUserName, $GuestPassword)

Enable-VMIntegrationService -VMName $VmName -Name "Guest Service Interface"

$vmComputerName = Invoke-Command -VMName $VmName -Credential $guestCredentals -ScriptBlock {$env:COMPUTERNAME}

$vmIPAddresses = @("127.0.0.1")

foreach ($ip in Invoke-Command -VMName $VmName -Credential $guestCredentals -ScriptBlock {Get-NetIPAddress -AddressFamily IPv4})
{
    $vmIPAddresses += $ip.IPAddress    
}


New-ServerKeyandCert -serverName $vmComputerName -serverIPAddresses $vmIPAddresses

Copy-VMFile -Name $VmName -SourcePath "C:\myDockerKeys\ca.pem" -DestinationPath "c:\ProgramData\docker\certs.d\ca.pem" -CreateFullPath -FileSource Host -Force
Copy-VMFile -Name $VmName -SourcePath "C:\myDockerKeys\key.pem" -DestinationPath "c:\ProgramData\docker\certs.d\key.pem" -CreateFullPath -FileSource Host -Force

Copy-VMFile -Name $VmName -SourcePath ("C:\myDockerKeys\" + $vmComputerName + "_server-key.pem") -DestinationPath "c:\ProgramData\docker\certs.d\server-key.pem" -CreateFullPath -FileSource Host  -Force
Copy-VMFile -Name $VmName -SourcePath ("C:\myDockerKeys\" + $vmComputerName + "_server-cert.pem") -DestinationPath "c:\ProgramData\docker\certs.d\server-cert.pem" -CreateFullPath -FileSource Host -Force

Invoke-Command -VMName $VmName -Credential $guestCredentals -ScriptBlock {"Tag" | Out-File "c:\ProgramData\docker\tag.txt" -Force}

Invoke-Command -VMName $VmName -Credential $guestCredentals -ScriptBlock {Stop-Service -Name "Docker"}
Start-Sleep -Seconds 2
Invoke-Command -VMName $VmName -Credential $guestCredentals -ScriptBlock {Start-Service -Name "Docker"}