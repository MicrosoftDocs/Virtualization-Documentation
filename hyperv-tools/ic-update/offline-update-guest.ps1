Param(
  [Parameter(Mandatory=$True)]
  [string]$cabPath
)

#Install the patch
Add-WindowsPackage -Online -PackagePath $cabPath