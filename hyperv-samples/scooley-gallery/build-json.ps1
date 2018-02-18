$UDailyURI = "http://cdimage.ubuntu.com/daily-live/current/"
$isoURI = "http://cdimage.ubuntu.com/daily-live/current/bionic-desktop-amd64.iso"
$checksumURI = "http://cdimage.ubuntu.com/daily-live/current/SHA256SUMS"
$metadataURI = "http://cdimage.ubuntu.com/daily-live/current/bionic-desktop-amd64.metalink"

$description = @("This Ubuntu VM was built by Sarah Cooley to make it easier to test out Enhanced Session Mode on Linux VMs.")

$json = Get-Content -Path "ubuntu_daily.json" | ConvertFrom-Json
[xml]$metadata = Invoke-WebRequest -Uri $metadataURI -UseBasicParsing

$img = $json.images[0]

$img.name = "Ubuntu ("+$metadata.metalink.version[1]+")"
$img.version = $metadata.metalink.version[0]
$img.lastUpdated = Get-Date -Format s

$description += ("It was published by Canonical on "+$metadata.metalink.pubdate)
$description += ("Resources found here are available online at "+$UDailyURI)

$img.description = @($description)

$img.disk.uri = $isoURI
$img.disk.hash = "sha256:"+(([string](Invoke-WebRequest -Uri $checksumURI -UseBasicParsing)).Split(' ')[0])

$json.images = @($img)

$json = $json | ConvertTo-Json -Depth 3
$json > ubuntu_daily.json
