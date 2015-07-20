$tempPath = [System.IO.Path]::GetTempPath() + [System.Guid]::NewGuid().ToString()

# ADK Download - https://www.microsoft.com/en-us/download/confirmation.aspx?id=39982
# You only need to install the deployment tools
$oscdimgPath = "C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"

# Download qemu-img from here: http://www.cloudbase.it/qemu-img-windows/
$qemuImgPath = "C:\Working Space\qemu-img\qemu-img.exe"

# Update this to the release of Ubuntu that you want
$ubuntuPath = "http://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64"

$GuestOSName = "Hyper-V-VM"
$GuestOSID = "iid-123456"
$GuestAdminPassword = "P@ssw0rd"

$VMName = "Ubuntu Test"
$virtualSwitchName = "Virtual Switch"

$vmPath = "C:\Working Space\VM"
$imageCachePath = "C:\Working Space"
$vhdx = "$($vmPath)\test.vhdx"
$metaDataIso = "$($vmPath)\metadata.iso"

# Get the timestamp of the latest build on the Ubuntu cloud-images site
$stamp = (Invoke-WebRequest "$($ubuntuPath).manifest").BaseResponse.LastModified.ToFileTimeUtc()

$metadata = @"
instance-id: $($GuestOSID)
local-hostname: $($GuestOSName)
"@

$userdata = @"
#cloud-config
password: $($GuestAdminPassword)
runcmd:
 - [ useradd, -m, -p, "", ben ]
 - [ chage, -d, 0, ben ]
"@

# Check Paths
if (!(test-path $vmPath)) {mkdir $vmPath}
if (!(test-path $imageCachePath)) {mkdir $imageCachePath}

# Helper function for no error file cleanup
Function cleanupFile ([string]$file) {if (test-path $file) {Remove-Item $file}}

# Delete the VM if it is around
If ((Get-VM | ? name -eq $VMName).Count -gt 0)
      {stop-vm $VMName -TurnOff -Confirm:$false -Passthru | Remove-VM -Force}

cleanupFile $vhdx
cleanupFile $metaDataIso

# Make temp location
md -Path $tempPath
md -Path "$($tempPath)\Bits"

if (!(test-path "$($imageCachePath)\ubuntu-$($stamp).img")) {
      # If we do not have a matching image - delete the old ones and download the new one
      Remove-Item "$($imageCachePath)\ubuntu-*.img"
      Invoke-WebRequest "$($ubuntuPath)-disk1.img" -UseBasicParsing -OutFile "$($imageCachePath)\ubuntu-$($stamp).img"
                  }

# Output meta and user data to files
sc "$($tempPath)\Bits\meta-data" ([byte[]][char[]] "$metadata") -Encoding Byte
sc "$($tempPath)\Bits\user-data" ([byte[]][char[]] "$userdata") -Encoding Byte

# Convert cloud image to VHDX
& $qemuImgPath convert -f qcow2 "$($imageCachePath)\ubuntu-$($stamp).img" -O vhdx -o subformat=dynamic $vhdx
Resize-VHD -Path $vhdx -SizeBytes 50GB

# Create meta data ISO image
& $oscdimgPath "$($tempPath)\Bits" $metaDataIso -j2 -lcidata

# Clean up temp directory
rd -Path $tempPath -Recurse -Force

# Create new virtual machine and start it
new-vm $VMName -MemoryStartupBytes 2048mb -VHDPath $vhdx -Generation 1 `
               -SwitchName $virtualSwitchName -Path $vmPath | Out-Null
set-vm -Name $VMName -ProcessorCount 2
Set-VMDvdDrive -VMName $VMName -Path $metaDataIso 
Start-VM $VMName

# Open up VMConnect
Invoke-Expression "vmconnect.exe localhost `"$VMName`""
