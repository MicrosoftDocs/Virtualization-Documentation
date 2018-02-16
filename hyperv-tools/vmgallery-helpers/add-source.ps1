Param(
    [Parameter(Mandatory=$true)]
    [string]$newURI
)

$galleryRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization"
$galleryRegKey = "GalleryLocations"

$key = get-item $galleryRegPath
$values = $key.GetValue($galleryRegKey)
$values += $newURI

Set-ItemProperty $galleryRegPath $galleryRegKey $values

Write-Host ""
Write-Host "Successfully added $newURI to $galleryRegKey"
Write-Host ""
Write-Host "New Value is: "
Write-Host (Get-ItemProperty -Path $galleryRegPath -Name $galleryRegKey).$galleryRegKey
