

# Container Orchestrators

Because of their small size and application orientation, containers are well suited for agile delivery environments and microservice-based architectures. When you use containers and microservices, however, you can easily have hundreds or thousands of components in your environment. You may be able to manually manage a few dozen virtual machines or physical servers, but there is no way you can manage a production-scale container environment without automation. The task of automating and managing a large number of containers and how they interact is known as orchestration. 

## Container Orchestrator definition

The standard definition of orchestration includes the following tasks:

- Scheduling: Given a container image and a resource request, find a suitable machine on which to run the container.
Affinity/Anti-affinity: Specify that a set of containers should run nearby each other (for performance) or sufficiently far apart (for availability).
- Health monitoring: Watch for container failures and automatically reschedule them.
- Failover: Keep track of what is running on each machine and reschedule containers from failed machines to healthy nodes.
- Scaling: Add or remove container instances to match demand, either manually or automatically.
- Networking: Provide an overlay network for coordinating containers to communicate across multiple host machines.
- Service discovery: Enable containers to locate each other automatically even as they move between host machines and change IP addresses.
- Coordinated application upgrades: Manage container upgrades to avoid application down time and enable rollback if something goes wrong.

## Container Orchestration in Azure

Azure offers two container orchestrators: Azure Container Service (AKS) and Service Fabric.

[Azure Container Service (AKS)](/azure/aks/) makes it simple to create, configure, and manage a cluster of virtual machines that are preconfigured to run containerized applications. This enables you to use your existing skills, or draw upon a large and growing body of community expertise, to deploy and manage container-based applications on Microsoft Azure. By using AKS, you can take advantage of the enterprise-grade features of Azure, while still maintaining application portability through Kubernetes and the Docker image format.

[Azure Service Fabric](/azure/service-fabric/) is a distributed systems platform that makes it easy to package, deploy, and manage scalable and reliable microservices and containers. Service Fabric addresses the significant challenges in developing and managing cloud native applications. Developers and administrators can avoid complex infrastructure problems and focus on implementing mission-critical, demanding workloads that are scalable, reliable, and manageable. Service Fabric represents the next-generation platform for building and managing these enterprise-class, tier-1, cloud-scale applications running in containers.
