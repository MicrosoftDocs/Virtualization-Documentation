function addNicWithIP([string]$VMName,$cred, [string]$Switch, [string]$IPaddress, [string]$subnetPrefixLength){
   $newNetAdapter = Add-VMNetworkAdapter -VMName $VMName -SwitchName $Switch -Passthru
   Write-Output "[$($VMName)]:: Wait for IP address and create virtual switch"
   waitForPSDirect $VMName $cred
   icm -VMName $VMName -Credential $cred {
      param($IPAddress, $subnetPrefixLength, $MacAddress)
      # Wait for the NIC to appear
      do {sleep 1} until (@(get-netadapter | ? PermanentAddress -eq $MacAddress).Count -eq 1)
      # Setup IP Address
      New-NetIPAddress -IPAddress $IPAddress `
                       -InterfaceAlias (get-netadapter | ? PermanentAddress -eq $MacAddress).Name `
                       -PrefixLength $subnetPrefixLength
      } -ArgumentList $IPAddress, $subnetPrefixLength, $newNetAdapter.MacAddress
}