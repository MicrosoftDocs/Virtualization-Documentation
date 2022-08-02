# [Containers on Windows Documentation](index.yml) 

# Overview
## [About Windows containers](about/index.md)
## [What's new for Windows containers in Windows Server 2022](about/whats-new-ws2022-containers.md) 
## [Containers vs. VMs](about/containers-vs-vm.md)
## [System requirements](deploy-containers/system-requirements.md)
## [FAQ](about/faq.yml)

# Quickstarts
## [Set up your environment](quick-start/set-up-environment.md)
## [Run your first container](quick-start/run-your-first-container.md)
## [Containerize a sample app](quick-start/building-sample-app.md)
## [Lift and shift to Windows containers](quick-start/lift-shift-to-containers.md)

# Tutorials
## Build a Windows container
### [Write a Dockerfile](manage-docker/manage-windows-dockerfile.md)
### [Optimize a Dockerfile](manage-docker/optimize-windows-dockerfile.md)
## Run on Azure Kubernetes Service on Azure Stack HCI
### [Deploy Windows applications in AKS on Azure Stack HCI](/azure-stack/aks-hci/deploy-windows-application) 
## Run on Azure Kubernetes Service
### [Create a Windows container cluster on AKS](/azure/aks/windows-container-cli)
### [Current Limitations](/azure/aks/windows-node-limitations)
## Run on Azure App Service
### [Azure App Service Quickstart](/azure/app-service/app-service-web-get-started-windows-container)
### [Migrate an ASP.NET app with Windows containers and Azure App Service](/azure/app-service/app-service-web-tutorial-windows-containers-custom-fonts)
## Container solutions
### [Solutions overview](samples.md)
### Application Frameworks
#### [aspnet](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/aspnet)
#### [iis](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/iis)
#### [iis-arr](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/iis-arr)
#### [iis-https](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/iis-https)
#### [iis-php](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/iis-php)
#### [Django](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/Django)
#### [apache-http](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/apache-http)
#### [apache-http-php](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/apache-http-php)
#### [nginx](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/nginx)
### Programing Languages
#### [dotnet35](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/dotnet35)
#### [golang](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/golang)
#### [nodejs](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/nodejs)
#### [python](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/python)
#### [python-django](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/python-django)
#### [rails](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/rails)
#### [ruby](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/ruby)
#### [server-jre-8u51-windows-x64](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/server-jre-8u51-windows-x64)
### Databases
#### [mongodb](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/mongodb)
#### [mysql](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/mysql)
#### [redis](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/redis)
#### [sqlite](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/sqlite)
#### [sqlserver-express](https://github.com/microsoft/mssql-docker/tree/master/windows)
### Infrastructure and CI Tools
#### [PowerShellDSC_iis-10.0](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/PowerShellDSC_iis-10.0)
### Just for fun
#### [MineCraft](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/MineCraft)
### Other
#### [DirectX](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/master/windows-container-samples/directx)
## Use Linux containers on Windows
### [Linux containers on Windows 10](deploy-containers/linux-containers.md)
### [Run your first Linux container](quick-start/quick-start-windows-10-linux.md)
## [Use containers with the Windows Insider program](deploy-containers/insider-overview.md)
## [Containerize apps with printer services](deploy-containers/print-spooler.md)
## Manage containers with Windows Admin Center
### [Containers extension overview](WAC-tooling/WAC-extension.md)
### [Manage container images](WAC-tooling/WAC-Manage.md)
### [Run new containers](WAC-tooling/WAC-Containers.md)
### [Create new container images](WAC-tooling/WAC-Images.md)
### [Manage Azure Container Registry](WAC-tooling/WAC-ACR.md)
### [Manage Azure Container Instance](WAC-tooling/WAC-ACI.md)

# Concepts
## Windows Container Essentials
### [Container base Images](manage-containers/container-base-images.md)
### [Base image servicing lifecycles](deploy-containers/base-image-lifecycle.md)
### [Isolation modes](manage-containers/hyperv-container.md)
### [Version compatibility](deploy-containers/version-compatibility.md)
### [Update containers](deploy-containers/update-containers.md)
### [Upgrade Windows containers](deploy-containers/upgrade-windows-containers.md)
### [Resource controls](manage-containers/resource-controls.md)
### [Container time zones](manage-containers/virtual-time-zone.md)
## Docker
### [Docker Engine on Windows](manage-docker/configure-docker-daemon.md)
### [Remote management of a Windows Docker host](management/manage_remotehost.md)
## Container orchestration
### [Windows Container orchestration overview](about/overview-container-orchestrators.md)
### [Azure Kubernetes Service (AKS)](/azure/aks)
### [AKS on Azure Stack HCI](/azure-stack/aks-hci/overview)
### Kubernetes on Windows
#### [Kubernetes on Windows](kubernetes/getting-started-kubernetes-windows.md)
#### [Troubleshooting](kubernetes/common-problems.md)
#### [Compile Kubernetes binaries](kubernetes/compiling-kubernetes-binaries.md)
### Service Fabric
#### [Service Fabric and Containers](/azure/service-fabric/service-fabric-containers-overview)
#### [Resource Governance](/azure/service-fabric/service-fabric-resource-governance)
### Docker Swarm
#### [Swarm Mode](manage-containers/swarm-mode.md)
## Security
### [Secure Windows containers](manage-containers/container-security.md)
### Group Managed Service Accounts
#### [Create a gMSA](manage-containers/manage-serviceaccounts.md)
#### [Configure your app to use a gMSA](manage-containers/gmsa-configure-app.md)
#### [Run a container with a gMSA](manage-containers/gmsa-run-container.md)
#### [Orchestrate containers with a gMSA](manage-containers/gmsa-orchestrate-containers.md)
#### [Configure gMSA with AKS on Azure Stack HCI](/azure-stack/aks-hci/prepare-windows-nodes-gmsa)
#### [Troubleshoot gMSAs](manage-containers/gmsa-troubleshooting.md)
#### gMSA on Azure Kubernetes Service (AKS)
##### [gMSA on AKS PowerShell Module](manage-containers/gmsa-aks-ps-module.md)
##### [Configure gMSA on AKS with PowerShell Module](manage-containers/configure-gmsa-ps-module.md)
##### [Validate gMSA on AKS with PowerShell Module](manage-containers/validate-gmsa-ps-module.md)
## Networking
### [Windows container networking](container-networking/architecture.md)
### [Network topologies and drivers](container-networking/network-drivers-topologies.md)
### [Multiple subnet support in Host Networking Service](container-networking/multi-subnet.md)
### [Network isolation and security](container-networking/network-isolation-security.md)
### [Configure advanced networking options](container-networking/advanced.md)
## Storage
### [Container Storage overview](manage-containers/container-storage.md)
### [Persistent storage](manage-containers/persistent-storage.md)
## Devices
### [Hardware devices](deploy-containers/hardware-devices-in-containers.md)
### [GPU acceleration](deploy-containers/gpu-acceleration.md)

# Reference
## [Events](deploy-containers/events.md)
## [Anti-virus optimization](/windows-hardware/drivers/ifs/anti-virus-optimization-for-windows-containers)
## [Container platform tools](deploy-containers/containerd.md)
## [Container OS image EULA](./images-eula.md)

# Resources
## [Known Issues](manage-containers/known-issues.md)
## [Windows Server containers roadmap](https://github.com/microsoft/Windows-Containers/projects/1)
## Licensing and support
### [Pricing and licensing](https://www.microsoft.com/windows-server/pricing)
### [Windows base OS images](https://hub.docker.com/_/microsoft-windows-base-os-images)
### [File bugs](https://github.com/microsoft/Windows-Containers/issues)
## [Troubleshooting](troubleshooting.md)
## [Container forum](https://social.msdn.microsoft.com/Forums/home?forum=windowscontainers)
## [Community videos and blogs](communitylinks.md)
