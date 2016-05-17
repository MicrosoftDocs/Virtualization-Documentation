---
title: Connecting with the Docker daemon
description: Connecting with the Docker daemon
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-contianers
ms.service: windows-containers
ms.assetid: 2605ece3-5918-4898-bc6b-60ef09e44d9d
---

# Connecting with the Docker daemon

On Windows, the Docker daemon accepts client and API connections locally through a non-networked named piped, and remotely through a TCP port. As a best practice, the Docker daemon should be accessed from a remote machine, through a TCP port. Furthermore, when doing so, the connection should be secured with TLS. This document will detail configuring incoming client connections, creating TLS certificates, and how to use these certificates with the Docker client and Docker daemon.

For detailed information on securing the Docker daemon, see [Protect the Docker daemon socket on Docker.com](https://docs.docker.com/engine/security/https/).

## Configuring connections

Specifying how the Docker daemon will accept incoming requests is done at daemon start up. On Windows, the Docker daemon start up options are configured in the 'c:\ProgramData\Docker\runDockerDaemon.cmd' file. Three connection configurations are available, locally through a named pipe, remotely through a TCP port, and both a named pipe and TCP connection. The configuration of each of these is detailed below.

### Named pipe

With nothing specified, the daemon will only accept local connections through the named pipe.

```none
docker daemon
```

Specifying the named pipe with the -H parameter is equivalent to the last example.

```none
docker daemon -H npipe:// 
```

### TCP port

A TCP port can also be specified using the -H parameter. In this example port 2375 is exposed, however is not secured. In this configuration no access control is configured, which exposes the potential for malicious container execution. This configuration is not recommended.

```
dockerd -H 0.0.0.0:2375
```

The TCP port can be secured using TLS certificates and the **--tlsverify** parameter. In this configuration the **--tlscacert**, **--tlscert**, and **--tlskey** parameters are used to specify the location of the required TLS components.

```none
dockerd -H 0.0.0.0:2376 --tlsverify --tlscacert=C:\ProgramData\Docker\certs.d\ca.pem --tlscert=C:\ProgramData\Docker\certs.d\server-cert.pem --tlskey=C:\ProgramData\Docker\certs.d\server-key.pem
```

### Both named pipe and TCP

If a TCP port is specified, and the named pipe will also be used, the named pipe declaration must be made.

```none
dockerd -H npipe:// -H 0.0.0.0:2376 --tlsverify --tlscacert=C:\ProgramData\Docker\certs.d\ca.pem --tlscert=C:\ProgramData\Docker\certs.d\server-cert.pem --tlskey=C:\ProgramData\Docker\certs.d\server-key.pem
```

## Create TLS Certificates

### Open TLS on Windows

There are several option available for creating TLS certificates on Windows. In this example, OpenSSL for Windows will be downloaded from https://indy.fulgan.com/SSL/.

```none
# Download Open SSL for Windows
wget https://indy.fulgan.com/SSL/openssl-0.9.8r-x64_86-win64-rev2.zip -outfile .\openssl-0.9.8x86.zip

# Expand compressed file
Expand-Archive .\ openssl-0.9.8x86.zip c:\
```

### Server SSL Certificates

Generate CA Private and Public keys:

```none
openssl genrsa -aes256 -out ./cert/ca-key.pem 4096
openssl req -new -x509 -days 365 -key ./cert/ca-key.pem -sha256 -out ./cert/ca.pem
```

Create server key and signing request (CSR):

```none
openssl genrsa -out ./cert/server-key.pem 4096
openssl req -subj "/CN=WIN-33A3HTEISE3" -sha256 -new -key ./cert/server-key.pem -out ./cert/server.csr
```

Sign the public key:

```none
echo subjectAltName = IP:10.0.0.13,IP:127.0.0.1 > ./cert/extfile.cnf
openssl x509 -req -days 365 -sha256 -in ./cert/server.csr -CA ./cert/ca.pem -CAkey ./cert/ca-key.pem -CAcreateserial -out ./cert/server-cert.pem -extfile ./cert/extfile.cnf
```
    
### Client TLS Certificates

Create client key and signing request:

```none
openssl genrsa -out ./cert/key.pem 4096
openssl req -subj "/CN=client" -new -key ./cert/key.pem -out ./cert/client.csr
```
	
Sign the public key:

```none
echo extendedKeyUsage = clientAuth > ./cert/extfile.cnf
openssl x509 -req -days 365 -sha256 -in ./cert/client.csr -CA ./cert/ca.pem -CAkey ./cert/ca-key.pem -CAcreateserial -out ./cert/cert.pem -extfile ./cert/extfile.cnf
```

## Configure Docker TLS

If you need to install the Docker daemon or Docker client, see [Docker on Windows](../deployment/docker_windows.md).

### Docker daemon

Copy the server TLS certificates to the ` C:\ProgramData\Docker\certs.d` folder on the container host.

### Docker client

Create an environmental variable named `DOCKER_CERT_PATH` and give it a value of the directory where the client TLS certificates will be copied.

```none
$env: DOCKER_CERT_PATH = "c:\dokcercerts"
```

Copy the client TLS certificates into the `DOCKER_CERT_PATH` directory.

## Remote client connection

To connect the Docker client to a remote daemon the ‘-H’ parameter can be used. In this example, the client is connecting on port 2375 and returning a list of container images.

```none
docker -H tcp://10.0.0.5:2375 images
```

To secure the client connection, the ‘-—tlsverify’ parameter is used.

```none
Docker -H -–tlsverify tcp://10.0.0.5:2375 images
```

To avoid specifying the remote system, an environmental variable named ‘DOCKER_HOST’ can be set with the value of the remote system and TCP port.

```none
powershell $env:DOCKER_HOST = "tcp://10.0.0.5:2376"
```

When set, the remote Docker command would be similar to this. 

```none
Docker -H -–tlsverify images
```