# Comparison between Windows PowerShell and Docker commands


##Image Management
<table width='80%'>
<tr> <th width='50%'> Windows PowerShell </th> <th width='50%'> Docker </th> </tr>
<tr> <td> Get-ContainerImage <td> docker images </tr>
<tr> <td> Find-ContainerImage <td> docker search </tr>
<tr> <td> Install-ContainerImage <td> docker pull </tr>
<tr> <td> New-ContainerImage <td> docker commit </tr>
<tr> <td> Remove-ContainerImage <td> docker rmi </tr>
</table>


##Container Management
<table width='80%'>
<tr> <th width='50%'> Windows PowerShell </th> <th width='50%'> Docker </th> </tr>
<tr> <td> New-Container	<br /> Start-Container <td> docker run </tr>
<tr> <td> Get-Container	<td> docker ps </tr>
<tr> <td> Stop-Container <td> docker stop </tr>
<tr> <td> Remove-Container <td> docker rm </tr>
</table>
		

##Network Management
<table width='80%'>
<tr> <th width='50%'> Windows PowerShell </th> <th width='50%'> Docker </th> </tr>
<tr> <td> New-VMSwitch </tr>
<tr> <td> New-NetNat </tr>	
<tr> <td> Add-NetNatStaticMapping <td> docker run -p &lt;src&gt;:&lt;dest&gt; </tr>
<tr> <td> Add-ContainerNetworkAdapter </tr>	
<tr> <td> Set-ContainerNetworkAdapter	</tr>
<tr> <td> Remove-ContainerNetworkAdapter </tr>
<tr> <td> Get-ContainerNetworkAdapter	</tr>
<tr> <td> Connect-ContainerNetworkAdapter	</tr>
<tr> <td> Disconnect-ContainerNetworkAdapter </tr>
</table>


##Shared Folders
<table width='80%'>
<tr> <th width='50%'> Windows PowerShell </th> <th width='50%'> Docker </th> </tr>
<tr> <td> Add-ContainerSharedFolder <br /> Remove-ContainerSharedFolder <td> docker -v &lt;src&gt;:&lt;dest&gt; </tr>
</table>


##Container Execution		
<table width='80%'>
<tr> <th width='50%'> Windows PowerShell </th> <th width='50%'> Docker </th> </tr>
<tr> <td> Enter-PSSession <td> Invoke-Command </tr>
</table>