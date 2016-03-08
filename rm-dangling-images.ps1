# this script is necessary because the following does not work as of Nov-2015 version of docker-windows:
#   docker rmi $(docker images --filter dangling=true)

$ErrorActionPreference = "Stop"

$pattern = "\<none\>\s+\<none\>\s+(?<id>[^\s]+)"

$danglingList = iex "docker images --filter dangling=true"

$ids = $danglingList | select-string -Pattern  $pattern | select -expand Matches | foreach {$_.groups['id'].value}

foreach ($id in $ids) {
  iex ("docker rmi " + $id)
}
