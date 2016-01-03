# does not work as of Nov-2015 version of docker-windows

docker rmi $(docker images --filter dangling=true)