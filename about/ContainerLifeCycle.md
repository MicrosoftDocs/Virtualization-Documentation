# Container Life Cycle #

## Container Instantiation ##
This illustration describes the process of instantiating a container from an image.

### Initial State ###
For this example there are two images present (image authoring is covered in a subsequent example).  Both images have packages stored in a local package store as well as metadata stored in the local image configuration store.  An Msvm_VirtualSystemSettingData object instance with a virtual system subtype of Microsoft:Hyper-V:Container:Package represents each image in the WMI object model.  The application package will have a dependency on a base operating system package which is expressed in the package metadata. 

### Container Creation ###
A container is represented by an instance of the Msvm_ComputerSystem object along with an associated Msvm_VirtualSystemSettingData object with a virtual system type (VirtualSystemType) of **Microsoft:Hyper-V:Container:Realized**.

The process of creating a container begins, just as with virtual machines, by calling the DefineSystem method on the Msvm_VirtualSystemManagementService.  In order to specify the package the contain is deponent on as well as any inherited properties DefineSystem will require as one of its parameters a reference to an Msvm_VirtualSystemSettingData object representing the package.   The Msvm_ComputerSystem references the parent package as well as a container specific starch space location that will accumulate any file system or registry changes.

To support customization and validation of the container prior to full instantiation callers may opt to invoke a new DefinePlannedSystem method, which like DefineSystem will require as one of its parameters a reference to an Msvm_VirtualSystemSettingData object representing the package.  Unlike DefineSystem when calling DefinePlannedSystem the resulting object is a planned virtual system, which supports modification and subsequent validation and realization into a functional container.  Common customizations might include renaming or modification of resource configuration (network, CPU, memory).

![](media\ContainerCreationLifeCycle.png)

## Image Composition ###
This illustration describes the process of constructing an image. 
 
### Initial State ###
In the initial state, there is a default image (metadata and package).  The package is stored in a local package store and the metadata is stored within the image configuration store.  An Msvm_ImageVirtualSystem (specific name TBD) instance represents the image in the WMI object model.  

### Container Creation ###
A conversion of the Msvm_ImageVirtualSystem into an Msvm_PlannedVirtualSystem begins the container creation.  Customization of the container can be performed against the Msvm_PlannedVirtualSystem and then the Msvm_PlannedVirtualSystem is realized into an Msvm_ComputerSystem.  The Msvm_ComputerSystem references the parent package as well as a container specific starch space location that will accumulate any file system or registry changes. 

### Container Authoring ###
During the authoring stage, the administrator can install applications, copy files, and modify configuration or other such tasks.  The container specific scratch space accumulates any file system and/or registry changes.  The containers configuration file is updated with any changes made to the containers configuration through the WMI objects.

### Image Creation ###
At any point the container can be converted into an image, typically this will be done once the authoring has been completed.  Invocation of a WMI conversion API referencing the Msvm_ComputerSystem will convert the container into an image.  When invoked this API will capture the changes accumulated in the scratch space into a package residing in the package store as well as a metadata file that will reside in the image configuration store, an instance of Msvm_ImageVirtualSystem will represent these entities.  

![](..\media\ImageCreationLifeCycle.png)
 



