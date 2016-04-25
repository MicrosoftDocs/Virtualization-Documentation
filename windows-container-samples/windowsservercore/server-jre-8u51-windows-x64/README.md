# Sample to create a Windows Server Container Image with Java Runtime 1.8 update 60 server edition

These samples were created for Windows Server 2016 Technical Preview 3 with Containers. They assume that the WindowsServerCore Container base image is present.

## Using Docker-managed Windows Server Containers to create a Server JRE Container Image 

In order to create a Java Runtime 1.8 update 601 server edition Container image when you are running Docker-managed Windows Server Containers, please copy the Dockerfile to a new folder (e.g. `C:\build\server-jre`) on your local Container host. Then, download the Server JRE Windows binaries directly from Oracle ([http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html Download link]) and extract it to C:\build\server-jre\sources.

On the Container host, please run
```
docker build -t javaruntime:8u60 C:\build\server-jre
docker tag javaruntime:8u60 javaruntime:latest
```

The dockerfile will add the sources to the container image and set the JRE_HOME environment variable accordingly.