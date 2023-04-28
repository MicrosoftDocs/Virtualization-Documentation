---
title: Manage container images on Windows Admin Center
description: Manage container images on Windows Admin Center.
author: vrapolinario
ms.author: viniap
ms.date: 04/12/2023
ms.topic: how-to
ms.assetid: bb9bfbe0-5bdc-4984-912f-9c93ea67105f
---
# Manage Container images on Windows Admin Center

This topic describes how to manage container images on Windows Admin Center. Container images are used to create new containers on Windows machines or other cloud services, such as Azure Kubernetes Service. For more information on Windows images, see the [Container images overview](../about/index.md#container-images).

## Pull container images

After deploying a container host, the next step is to pull (or download) container images so new containers can be created from the images. You can use Windows Admin Center to pull new container images by selecting the Containers extension on your targeted container host. Then, select the **Images** tab inside the **Container** extension under **Container host** and select the **Pull** option.

![Pull container images](./media/wac-pull.png)

In the **Pull Container Image** settings, provide the image URL and the tag for the image you want to pull. You can also select the option to pull all tagged images on that repository.

If the image you want to pull is on a private repository, provide the username and password to authenticate against that repository. If your repository is hosted on Azure Container Registry, use the native Azure authentication on Windows Admin Center to access the image. This requires the Windows Admin Center instance to be connected to Azure and authenticated with your Azure account. For more information on how to connect a Windows Admin Center instance to Azure, see [Configuring Azure integration](/windows-server/manage/windows-admin-center/azure/azure-integration).

If you aren't certain which image to pull, Windows Admin Center provides a list of common images from Microsoft. Select the **Common Windows images** dropdown to see a list of base images that are commonly pulled. Select the image you want to pull, and Windows Admin Center will fill in the repository and tag fields.

## Push container images

Once you have your container image created, it's a good practice to push that image to a centralized repository to allow other container hosts or cloud services to pull the image.

On the **Images** tab in the **Containers** extension of Windows Admin Center, select the image you wan to push and click **Push**.

![Push container images](./media/wac-push.png)

In the **Push Container Image** settings, you can change the image name and tag before pushing (uploading) it. You can also choose whether to push it to either a generic repository or a repository on Azure Container Registry. For a generic repository, you will need to provide a username and password. For Azure Container Registry, you can use the integrated authentication on Windows Admin Center. For Azure, you can also select which subscription and registry you want to push the image to.

## Next steps

> [!div class="nextstepaction"]
> [Create new containers on Windows Admin Center](./wac-images.md)