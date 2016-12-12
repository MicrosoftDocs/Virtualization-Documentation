# vcbuildtools

Build a Docker image with Visual C++ Build tools.

## Build image

```
docker build -t vcbuildtools:14.3 .
```

## Use the image

```
docker run -v "$(pwd):C:\code" vcbuildtools:14.3 msbuild yourproject.sln /p:Configuration=Release
```
