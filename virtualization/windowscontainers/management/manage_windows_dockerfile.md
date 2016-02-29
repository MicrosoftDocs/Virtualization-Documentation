# Dockerfile on Windows

## FROM
```FROM windowsservercore```



## RUN

### Do fewer operations per line
This makes caching more effective. If the same step has been done in a similar build, then this step could be cached. Although adding a script is convenient, breaking it into multiple RUN commands will cache more and build faster.

```
RUN script.cmd
```
<!-- build twice, show docker history excerpt -->

```
RUN foo
RUN bar
```
<!-- build twice, show docker history excerpt -->

### Remove excess files in the same step
If a file, such as an installer, isn't required after the RUN step, you can delete it to save space in the layer.

Example:
<!-- compare wget & unzip to wget & unzip & delete -->


### Consider using copy-based installs instead of MSI-based installs  
The [Windows Installer][msi] is designed to install, upgrade, repair, and remove applications from a Windows machine. This is convenient for desktop machines and servers that may be maintained for a long time, but may not be necessary for a container that can easily be redeployed or rebuilt. Using ADD to copy the needed files into a container, or unzipping an archive may produce fewer changes in the container, and make the resulting image smaller.

Example:
<!-- compare a Git installation vs UNZIP -->



[@StefanScherer](http://www.github.com/StefanScherer) shared his experiences optimizing an image for building applications using Go in [Issue:dockerfiles-windows#1](https://github.com/StefanScherer/dockerfiles-windows/issues/1)  


## WORKDIR
<!-- Topics: compare to RUN cd ... -->


## CMD
<!-- Topics: envvar scope & set /x workaround -->



## Further Reading & References
* [Optimizing Docker Images](https://www.ctl.io/developers/blog/post/optimizing-docker-images/)

<!-- These URLs can't be used with the typical [text](link) syntax, so the reference style was used instead -->
[msi]: https://msdn.microsoft.com/en-us/library/aa367449(v=vs.85).aspx "About Windows Installer"
