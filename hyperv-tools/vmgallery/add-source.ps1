# Add a new gallery location to Quick Create VM Gallery

# Run add-source [new gallery URI/file path]
Param(
    [Parameter(Mandatory=$true)]
    [string]$newURI
)

$galleryRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization"
$galleryRegKey = "GalleryLocations"

$key = get-item $galleryRegPath
$values = $key.GetValue($galleryRegKey)
$values += $newURI

Set-ItemProperty -Path $galleryRegPath -Name $galleryRegKey -Value $values -Type MultiString 

Write-Host ""
Write-Host "Successfully added $newURI to $galleryRegKey"
Write-Host ""
Write-Host "New Value is: "
Write-Host (Get-ItemProperty -Path $galleryRegPath -Name $galleryRegKey).$galleryRegKey

# launch Quick Create to verify!

# If the new gallery location didn't load, check event logs.
# Event Viewer -> Windows Logs -> Application