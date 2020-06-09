# [Containers on Windows Documentation](index.md) 

# Overview
## [About Windows containers](about/index.md)
## [Containers vs. VMs](about/containers-vs-vm.md)
## [System requirements](deploy-containers/system-requirements.md)
## [FAQ](about/faq.md)

# Get Started
## [Set up your environment](quick-start/set-up-environment.md)
## [Run your first container](quick-start/run-your-first-container.md)
## [Containerize a sample app](quick-start/building-sample-app.md)

# Tutorials
## Build a Windows container
### [Write a Dockerfile](manage-docker/manage-windows-dockerfile.md)
### [Optimize a Dockerfile](manage-docker/optimize-windows-dockerfile.md)
## Run on Azure Kubernetes Service
### [Create a Windows container cluster on AKS](/azure/aks/windows-container-cli)
### [Current Limitations](/azure/aks/windows-node-limitations)
## Run on Service Fabric
### [Deploy your first container](/azure/service-fabric/service-fabric-quickstart-containers)
### [Deploy a .NET application in a Windows container](/azure/service-fabric/service-fabric-host-app-in-a-container)
## Run on Azure App Service
### [Azure App Service Quickstart](/azure/app-service/app-service-web-get-started-windows-container)
### [Migrate an ASP.NET app with Windows containers and Azure App Service](/azure/app-service/app-service-web-tutorial-windows-containers-custom-fonts)
## Linux containers on Windows
### [Overview](deploy-containers/linux-containers.md)
### [Run your first Linux container](quick-start/quick-start-windows-10-linux.md)
## Use containers with the Windows Insider program
### [Overview](deploy-containers/insider-overview.md)

# Concepts
## Windows Container Essentials
### [Container Base Images](manage-containers/container-base-images.md)
### [Isolation Modes](manage-containers/hyperv-container.md)
### [Version compatibility](deploy-containers/version-compatibility.md)
### [Update containers](deploy-containers/update-containers.md)
### [Resource controls](manage-containers/resource-controls.md)
## Docker
### [Docker Engine on Windows](manage-docker/configure-docker-daemon.md)
### [Remote management of a Windows Docker host](management/manage_remotehost.md)
## Container Orchestration
### [Overview](about/overview-container-orchestrators.md)
### Kubernetes on Windows
#### [Kubernetes on Windows](kubernetes/getting-started-kubernetes-windows.md)
#### [Create a Kubernetes Master](kubernetes/creating-a-linux-master.md)
#### [Choose a network solution](kubernetes/network-topologies.md)
#### [Join Windows workers](kubernetes/joining-windows-workers.md)
#### [Join Linux workers](kubernetes/joining-linux-workers.md)
#### [Deploy Kubernetes resources](kubernetes/deploying-resources.md)
#### [Troubleshooting](kubernetes/common-problems.md)
#### [Kubernetes as a Windows service](kubernetes/kube-windows-services.md)
#### [Compile Kubernetes binaries](kubernetes/compiling-kubernetes-binaries.md)
### Service Fabric
#### [Service Fabric and Containers](/azure/service-fabric/service-fabric-containers-overview)
#### [Resource Governance](/azure/service-fabric/service-fabric-resource-governance)
### Docker Swarm
#### [Swarm Mode](manage-containers/swarm-mode.md)
## Workloads
### Group Managed Service Accounts
#### [Create a gMSA](manage-containers/manage-serviceaccounts.md)
#### [Configure your app to use a gMSA](manage-containers/gmsa-configure-app.md)
#### [Run a container with a gMSA](manage-containers/gmsa-run-container.md)
#### [Orchestrate containers with a gMSA](manage-containers/gmsa-orchestrate-containers.md)
#### [Troubleshoot gMSAs](manage-containers/gmsa-troubleshooting.md)
### [Printer services](deploy-containers/print-spooler.md)
## Networking
### [Overview](container-networking/architecture.md)
### [Network topologies and drivers](container-networking/network-drivers-topologies.md)
### [Network isolation and security](container-networking/network-isolation-security.md)
### [Configure advanced networking options](container-networking/advanced.md)
## Storage
### [Overview](manage-containers/container-storage.md)
### [Persistent Storage](manage-containers/persistent-storage.md)
## Devices
### [Hardware devices](deploy-containers/hardware-devices-in-containers.md)
### [GPU acceleration](deploy-containers/gpu-acceleration.md)

# Reference
## [Base image servicing lifecycles](deploy-containers/base-image-lifecycle.md)
## [Anti-virus optimization](https://docs.microsoft.com/windows-hardware/drivers/ifs/anti-virus-optimization-for-windows-containers)
## [Container platform tools](deploy-containers/containerd.md)
## [Container OS image EULA](Images_EULA.md)

# Resources
## [Known Issues](manage-containers/known-issues.md)
## [Container samples](samples.md)
## [Troubleshooting](troubleshooting.md)
## [Container forum](https://social.msdn.microsoft.com/Forums/home?forum=windowscontainers)
## [Community videos and blogs](communitylinks.md)
