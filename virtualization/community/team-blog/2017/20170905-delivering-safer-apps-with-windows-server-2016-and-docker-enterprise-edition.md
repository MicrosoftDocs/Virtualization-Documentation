---
title:      "Delivering Safer Apps with Windows Server 2016 and Docker Enterprise Edition"
date:       2017-09-05 09:00:47
categories: containers
---
_Windows Server 2016 and Docker Enterprise Edition are revolutionizing the way Windows developers can create, deploy, and manage their applications on-premises and in the cloud. Microsoft and Docker are committed to providing secure containerization technologies and enabling developers to implement security best practices in their applications. This blog post highlights some of the security features in Docker Enterprise Edition and Windows Server 2016 designed to help you deliver safer applications._ _For more information on Docker and Windows Server 2016 Container security, check out the[full whitepaper](https://goto.docker.com/rs/929-FJL-178/images/20170831-WP-Delivering-Safer-Apps.pdf) on Docker's site._

## Introduction

Today, many organizations are turning to Docker Enterprise Edition (EE) and Windows Server 2016 to deploy IT applications consistently and efficiently using containers. Container technologies can play a pivotal role in ensuring the applications being deployed in your enterprise are safe -- free of malware, up-to-date with security patches, and known to come from a trustworthy source. Docker EE and Windows each play a hand in helping you develop and deploy safer applications according to the following three characteristics:

  1. **Usable Security:** Secure defaults with tooling that is native to both developers and operators.
  2. **Trusted Delivery:** Everything needed to run an application is delivered safely and guaranteed not to be tampered with.
  3. **Infrastructure Independent:** Application and security configurations are portable and can move between developer workstations, testing environments, and production deployments regardless of whether those environments are running in Azure or your own datacenter.

![](https://msdnshared.blob.core.windows.net/media/2017/08/KeyComponentsOfContainerSecurity-500x262.png)

## Usable Security

### Resource Isolation

Windows Server 2016 ships with support for Windows Server Containers, which are powered by Docker Enterprise Edition. Docker EE for Windows Server is the result of a joint engineering effort between Microsoft and Docker. When you run a Windows Server Container, key system resources are sandboxed for each container and isolated from the host operating system. This means the container does not see the resources available on the host machine, and any changes made within the container will not affect the host or other containers. Some of the resources that are isolated include:

  * File system
  * Registry
  * Certificate stores
  * Namespace (privileged API access, system services, task scheduler, etc.)
  * Local users and groups

Additionally, you can limit a Windows Server Container's use of the CPU, memory, disk usage, and disk throughput to protect the performance of other applications and containers running on the same host.

### Hyper-V Isolation

For even greater isolation, Windows Server Containers can be deployed using Hyper-V isolation. In this configuration, the container runs inside a specially optimized Hyper-V virtual machine with a completely isolated Windows kernel instance. Docker EE handles creating, managing, and deleting the VM for you. Better yet, the same Docker container images can be used for both process isolated and Hyper-V isolated containers, and both types of containers can run side by side on the same host.

### Application Secrets

Starting with Docker EE 17.06, support for delivering secrets to Windows Server Containers at runtime is now available. Secrets are simply blobs of data that may contain sensitive information best left out of a container image. Common examples of secrets are SSL/TLS certificates, connection strings, and passwords. Developers and security operators use and manage secrets in the exact same way -- by registering them on manager nodes (in an encrypted store), granting applicable services access to obtain the secrets, and instructing Docker to provide the secret to the container at deployment time. Each environment can use unique secrets without having to change the container image. The container can just read the secrets at runtime from the file system and use them for their intended purposes.

## Trusted Delivery

### Image Signing and Verification

Knowing that the software running in your environment is authentic and came from a trusted source is critical to protecting your information assets. With Docker Content Trust, which is built into Docker EE, container images are cryptographically signed to record the contents present in the image at the time of signing. Later, when a host pulls the image down, it will validate the signature of the downloaded image and compare it to the expected signature from the metadata. If the two do not match, Docker EE will not deploy the image since it is likely that someone tampered with the image.

### Image Scanning and Antimalware

Beyond checking if an image has been modified, it's important to ensure the image doesn't contain malware of libraries with known vulnerabilities. When images are stored in Docker Trusted Registry, Docker Security Scanning can analyze images to identify libraries and components in use that have known vulnerabilities in the Common Vulnerabilities and Exposures (CVE) database. Further, when the image is pulled on a Windows Server 2016 host with Windows Defender enabled, the image will automatically be scanned for malware to prevent malicious software from being distributed through container images.

### Windows Updates

Working alongside Docker Security Scanning, Microsoft Windows Update can ensure that your Windows Server operating system is up to date. Microsoft publishes two pre-built Windows Server base images to Docker Hub: [mcr.microsoft.com/windows/nanoserver:2009](https://hub.docker.com/_/microsoft-windows-nanoserver) and [mcr.microsoft.com/windows/servercore:ltsc2016](https://hub.docker.com/_/microsoft-windows-servercore). These images are updated the same day as new Windows security updates are released. When you use the "latest" tag to pull these images, you can rest assured that you're working with the most up to date version of Windows Server. This makes it easy to integrate updates into your continuous integration and deployment workflow.

## Infrastructure Independent

### Active Directory Service Accounts

Windows workloads often rely on Active Directory for authentication of users to the application and authentication between the application itself and other resources like Microsoft SQL Server. Windows Server Containers can be configured to use a Group Managed Service Account when communicating over the network to provide a native authentication experience with your existing Active Directory infrastructure. You can select a different service account (even belonging to a different AD domain) for each environment where you deploy the container, without ever having to update the container image.

### Docker Role Based Access Control

Docker Enterprise Edition allows administrators to apply fine-grained role based access control to a variety of Docker primitives, including volumes, nodes, networks, and containers. IT operators can grant users predefined permission roles to collections of Docker resources. Docker EE also provides the ability to create custom permission roles, providing IT operators tremendous flexibility in how they define access control policies in their environment.

## Conclusion

With Docker Enterprise Edition and Windows Server 2016, you can develop, deploy, and manage your applications more safely using the variety of built-in security features designed with developers and operators in mind. To read more about the security features available when running Windows Server Containers with Docker Enterprise Edition, check out the [full whitepaper](https://goto.docker.com/rs/929-FJL-178/images/20170831-WP-Delivering-Safer-Apps.pdf) and learn more about using [Docker Enterprise Edition in Azure](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/docker.dockerdatacenter).
