ms.ContentId: 1ab7bfe1-da35-4ff1-916f-936fedf536a0
title: Setup Windows Containers in Azure

# Preparing Microsoft Azure for Windows Containers

Before creating and managing Windows Containers the Windows Server 2016 Technical Preview environment must be prepared. With this preview release, two hands on experiences are available, one running in an Azure and one running in your on-premises environment. This guide will walk through configuring Windows container in a virtual machine hosted on Microsoft Azure. 

To run Windows Server Containers in a Hyper-V virtual machine instead, follow [these instructions](./container_setup.md).

## Start Using Azure Portal
If you have an Azure account and use Azure Portal, skip straight to [Create a Container Host VM](#CreateacontainerhostVM).

1. Go to [azure.com](https://azure.microsoft.com) and follow the steps for an [Azure Free Trial](https://azure.microsoft.com/en-us/pricing/free-trial/).
2. Sign in with your Microsoft account.
3. You should now be logged into the [Azure Management Portal](https://manage.windowsazure.com/).

## Create a Container Host VM
Create and configure a new virtual machine through Azure Gallery.

Click on New > Compute > Virtual Machine > From Gallery

![](./media/CreateAzureVM.png)

On the ‘Choose an Image’ menu, select ‘Windows Server Container Preview’.

![](media/Create_vm4.png)

Select a name for the Virtual Machine, select a size, user name and Password.

![](./media/Create_vm2.png)

On page 3 of the Create a Virtual Machine wizard there is an option to configure an Endpoint. Endpoints are used to map a VM port (internal) to a port that is exposed to the internet (external). During the Windows Server Container quick starts you will host a website in your container and access this website through port 80. You will need to create an endpoint to allow internet traffic to access this VM through port 80.

Select HTTP from the ‘Enter or Select Value’ drop down. 
 
![](media/AzurePorts.png)

Keep the default on the following page and select the check mark to create the Virtual Machine.
  
![](media/create_vm3.png)

To connect to the Azure Virtual Machine, select the virtual machine > click on Dashboard > select the connect bottom towards the bottom of the screen. This will download and open an .rdp file which will create an RDP session with the VM.

Log into the VM using the username and password specified during the VM creation wizard.

## Next Steps - Start Using Containers

Now that you have a Windows Server 2016 system running the Windows Server Container feature jump to the following guides to begin working with Windows Server Containers and Windows Server Container images. 

[Quick Start: Windows Server Containers and PowerShell](./manage_powershell.md)  
[Quick Start: Windows Server Containers and Docker](./manage_docker.md)

-------------------
[Back to Container Home](../containers_welcome.md)  
[Known Issues for Current Release](../about/work_in_progress.md)