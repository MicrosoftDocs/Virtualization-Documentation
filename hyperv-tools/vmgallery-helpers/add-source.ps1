Param(
    [Parameter(Mandatory=$true)]
    [string]$newURI
)

$galleryRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization"
$galleryRegKey = "GalleryLocations"
[string[]]$regContents = (Get-ItemProperty -Path $galleryRegPath -Name $galleryRegKey).GalleryLocations

[string[]]$gallerylocations = (
    # existing contents
    $regContents,
    
    # Custom image json
    $newURI 
)

Set-ItemProperty -Path $galleryregpath -Name $galleryRegKey -Value $gallerylocations

Write-Host ""
Write-Host "Successfully added $newURI to $galleryRegKey"
Write-Host ""
Write-Host "New Value is: "
Write-Host (Get-ItemProperty -Path $galleryRegPath -Name $galleryRegKey).$galleryRegKey
