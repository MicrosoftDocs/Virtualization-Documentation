# NanoServerApiScan

Build a Docker image with the NanoServerApiScan tool.

## Usage

There are two variants to run the scanner.

### Use volume

Bind mount the directory with your Exe files to scan to `C:\scan` into the container.

```
docker run -v "$(pwd):C:\scan" nanoserverapiscan
```

### Use onbuild

If you can't use `-v` for example if you are using a remote Windows Docker engine
you can use the onbuild variant instead.

Create a small Dockerfile with the following line in the directory of your
binaries to scan.

```Dockerfile
FROM nanoserverapiscan:onbuild
```

Then build a Docker image with your binaries and then run the container to
scan all binaries.

```
docker build -t scan .
docker run scan
```

## Build the nanoserverapiscan images

```
docker create --name nano microsoft/nanoserver
mkdir tmp
docker cp nano:Windows/System32/Forwarders tmp

docker build -t nanoserverapiscan .
docker build -t nanoserverapiscan:onbuild onbuild
```

## See also

### Blog post

* https://blogs.technet.microsoft.com/nanoserver/2016/04/27/nanoserverapiscan-exe-updated-for-tp5/

### Nano Server APIs

* https://msdn.microsoft.com/en-us/library/mt588480(v=vs.85).aspx
