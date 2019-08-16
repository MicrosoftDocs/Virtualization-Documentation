
System Center, Virtual Machine Manager(SCVMM) customers can try out the Windows Containers feature by 
creating a Virtual Machine using the "ContainerHostTemplate.xml" provided.

The OS Image to be used for creating the Virtual machine can be found here:
https://aka.ms/containerhostvhd

Process:

1. Download the OS image, and import it into the VMM Library Server.
2. Download the ContainerHostTemplate.xml and the AdminAutoLogon.xml.
3. The "ContainerHostTemplate.xml" is an exported VM Template. Import the VM Template into VMM.
4. Create a Virtual machine using the VM Template. Note: The Virtual machine must be connected to a VirtualSwitch that is network connected.

Once the VM Creation is completed, the VM will server as a ContainerHost, and can be used to create Windows Containers.
