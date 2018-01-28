Param(
    [Parameter(Mandatory=$true)]
    [string]$newURI
)

$galleryRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization"
$galleryRegKey = "GalleryLocations"
$DefaultLocations = "https://go.microsoft.com/fwlink/?linkid=851584"

Set-ItemProperty -Path $galleryregpath -Name $galleryRegKey -Value $gallerylocations

Write-Host ""
Write-Host "Successfully reset $galleryRegKey"
Write-Host ""
Write-Host "New Value is: "
Write-Host (Get-ItemProperty -Path $galleryRegPath -Name $galleryRegKey).$galleryRegKey
