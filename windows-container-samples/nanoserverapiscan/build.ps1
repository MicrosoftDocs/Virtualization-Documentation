docker rm -f nano
docker create --name nano microsoft/nanoserver
if (Test-Path tmp) { rm -recurse -force tmp }
mkdir tmp
docker cp nano:Windows/System32/Forwarders tmp

docker build -t nanoserverapiscan .
docker build -t nanoserverapiscan:onbuild onbuild
