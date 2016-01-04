# Dockerfiles-for-windows

* sqlexpress: SQL Server 2014 Express
* jdk8: Java JDK 8

Each of the above is entirely self-contained - all you need is what is in the dockerfile folder:
* docker build -t sqlexpress ./sqlexpress
* docker build -t jdk8 ./jdk8

Please see the following blog post for a detailed description of the SQL Server dockerfile:

[Dockerfile to create SQL Server Express windows container image](http://26thcentury.com/2016/01/03/dockerfile-to-create-sql-server-express-windows-container-image/)





