ms.ContentId: 1ab7bfe1-da35-4ff1-916f-936fedf536a0
title: Setup Windows Containers in Azure

# Preparing Microsoft Azure for Windows Containers

Before creating and managing Windows Containers the Windows Server 2016 Technical Preview environment must be prepared. With this preview release, two hands on experiences are available, one running in an Azure and one running in your on-premises environment. This guide will walk through configuring Windows container in a virtual machine hosted on Microsoft Azure. 

To run Windows Server Containers in a local virtual machine instead, follow [these instructions](./container_setup.md).

## Start using Azure Portal
If you have an Azure account and use Azure Portal, skip straight to [creating a container host](#CreateacontainerhostVM).

1. Go to [azure.com](https://azure.microsoft.com) and follow the steps for an [Azure Free Trial](https://azure.microsoft.com/en-us/pricing/free-trial/).
2. Sign in with your Microsoft account.
3. You should now be logged into the [Azure Management Portal](https://manage.windowsazure.com/).

## Create a container host VM
Create a new virtual machine through Azure Gallery.

click on "New" (in the bottom left hand corner of the page).  
From there:  Compute > Virtual Machine > From Gallery.

That should look something like this:
![](./media/CreateAzureVM.png)

On the ‘choose an image’ menu, select ‘Windows Server Technical Preview 3 – Container Edition’.

##  Windows Containers Preparation in Azure

.
.
.

6.  Enter your password.  

Now you have a Windows Server Core virtual machine in Azure running Docker and Windows Server Containers!
  
## Next - Start using containers

Jump to the following quick starts to begin containerizing applications and managing Windows Server Containers.

[Quick Start: Windows Server Containers and PowerShell](./manage_powershell.md)  
[Quick Start: Windows Server Containers and Docker](./manage_docker.md) 

The Docker and PowerShell guides both walk through containerizing a web server and performing equivalent management tasks.  Use whichever toolset you prefer. 

-------------------

[Back to Container Home](../containers_welcome.md)
