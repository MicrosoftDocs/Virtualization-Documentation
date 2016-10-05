param(
[Parameter(Mandatory=$false)]
[string]$serverfarms
)

Set-Location $env:windir\\system32\\inetsrv\\

$trimmed_serverfarms= $serverfarms.TrimStart('\\').TrimEnd('\\')

Write-Verbose "Passed in farm configuration is: $($trimmed_serverfarms)"

$farms = ConvertFrom-Json $trimmed_serverfarms

if ($null -ne $farms -And $farms.Length -gt 0){
	Write-Verbose "Configuring ARR server farms - $($farms.length)"
	
	ForEach($farm in $farms)
	{	
		# Create the farm
		.\appcmd.exe set config  -section:webFarms /+"[name='$($farm.name)']" /commit:apphost
		
		ForEach($server in $farm.Servers)
		{
			# Add server to farm
			.\appcmd.exe set config  -section:webFarms /+"[name='$($farm.name)'].[address='$($server.address)']" /commit:apphost
		}
		
		# URL Rewrite
		.\appcmd.exe set config  -section:system.webServer/rewrite/globalRules /+"[name='ARR_$($farm.name)_lb', patternSyntax='Wildcard',stopProcessing='True']" /commit:apphost
		.\appcmd.exe set config  -section:system.webServer/rewrite/globalRules /"[name='ARR_$($farm.name)_lb',patternSyntax='Wildcard',stopProcessing='True']".match.url:"*"  /commit:apphost
		.\appcmd.exe set config  -section:system.webServer/rewrite/globalRules /"[name='ARR_$($farm.name)_lb',patternSyntax='Wildcard',stopProcessing='True']".action.type:"Rewrite"  /"[name='ARR_$($farm.name)_lb',patternSyntax='Wildcard',stopProcessing='True']".action.url:"http://$($farm.name)/{R:0}"  /commit:apphost
	}
}

while ($true) { Start-Sleep -Seconds 3600 }