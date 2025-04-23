---
title: Run Your First Windows Container
description: See how to run a Windows container from a command line and by using Windows Admin Center. Find out how to pull an image, create a new image, and run an image.
author: vrapolinario
ms.author: mosagie
ms.date: 04/23/2025
ms.topic: quickstart
ms.assetid: bb9bfbe0-5bdc-4984-912f-9c93ea67105f
# customer intent: As a developer, I want to see how to run Windows containers so that I can take advantage of the benefits that containers offer, such as isolation, portability, and versatility.
---
# Get started: Run your first Windows container

> Applies to: Windows Server 2025, Windows Server 2022, Windows Server 2019, Windows Server 2016

This article shows you how to run your first Windows container, after you set up your environment as described in [Get started: Prep Windows for containers](./set-up-environment.md). Running a container involves two steps:

- Downloading a base image. With containers, the process of downloading a base image is known as a *pull operation*. The base image provides a foundational layer of operating system services to your container.
- Creating and running a container image that's based upon the base image.

## Pull a container base image

All containers are created from container images. Microsoft offers several starter images, called base images, to choose from. For more information, see [Container base images](../manage-containers/container-base-images.md).

You can use the following procedure to *pull* the lightweight Nano Server base image, or in other words, to download and install that image.

1. Open a console window such as the built-in Command Prompt, PowerShell, or [Windows Terminal](https://apps.microsoft.com/detail/9n0dx20hk701).

1. Run the following command to download and install the base image:

   ```console
   docker pull mcr.microsoft.com/windows/nanoserver:ltsc2022
   ```

   While you wait, read the terms of the [supplemental license for the image](../images-eula.md).

   If Docker fails to start when you try to pull the image, the Docker daemon might be unreachable. To resolve this issue, restart the Docker service.

   > [!TIP]
   > If you see the error message, "No matching manifest for linux/amd64 in the manifest list entries," Docker might be configured to run Linux containers instead of Windows containers. To switch to Windows containers in Docker, take one of the following steps:
   >
   > - In the Windows system tray, right-click the Docker icon, and then select **Switch to Windows containers**.
   > - At a command prompt, run `& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon`.

1. Verify the existence of the image on your system by querying your local Docker image repository. You can perform this check by running the `docker images` command, which returns a list of installed images.

   Here's an example of output from that command, which shows the Nano Server image.

   ```console
   REPOSITORY                             TAG        IMAGE ID       CREATED      SIZE
   mcr.microsoft.com/windows/nanoserver   ltsc2022   4f0ead5b1b67   6 days ago   296MB
   ```

## Run a Windows container

For this basic example, you create and deploy a Hello World container image. For the best experience, run the commands in this section at an elevated command prompt. But don't use the Windows PowerShell Integrated Scripting Environment (ISE). It's not suited for interactive sessions with containers—the containers appear to stop responding.

1. Start a container with an interactive session from the `nanoserver` image by entering the following command at a command prompt:

   ```console
   docker run -it mcr.microsoft.com/windows/nanoserver:ltsc2022 cmd.exe
   ```

   The container starts, and the console window changes context to the container.

1. Inside the container, run the following commands. The first command creates a text file that contains the phrase "Hello World!" The second command exits the container.

   ```cmd
   echo "Hello World!" > Hello.txt
   exit
   ```

1. Get the container ID for the container you just exited by running the [`docker ps`](https://docs.docker.com/reference/cli/docker/container/ls/) command:

   ```console
   docker ps -a
   ```

1. Create a new `helloworld` image that includes the changes in the first container you ran. To do so, run the [`docker commit`](https://docs.docker.com/reference/cli/docker/container/commit/) command, replacing `<container-ID>` with the ID of your container:

   ```console
   docker commit <container-ID> helloworld
   ```

   You now have a custom image that contains the Hello.txt file. You can use the [`docker images`](https://docs.docker.com/reference/cli/docker/image/ls/) command to see the new image.

   ```console
   docker images
   ```

   Here's an example of the output:

   ```console
   REPOSITORY                             TAG        IMAGE ID       CREATED          SIZE
   helloworld                             latest     81013d6b73ae   25 seconds ago   299MB
   mcr.microsoft.com/windows/nanoserver   ltsc2022   4f0ead5b1b67   6 days ago       296MB
   ```

1. Run the new container by using the [`docker run`](https://docs.docker.com/reference/cli/docker/container/run/) command with the `--rm` option. When you use this option, Docker automatically removes the container when the command, `cmd.exe` in this case, stops.

   ```console
   docker run --rm helloworld cmd.exe /s /c type Hello.txt
   ```

   Docker creates a container from the `helloworld` image and starts an instance of `cmd.exe` in the container. The `cmd.exe` process reads the Hello.txt file and writes the contents to the console window. As the final step, Docker stops and removes the container.

## Run a Windows container by using Windows Admin Center

You can use Windows Admin Center to run your containers locally. Specifically, you can use the Containers extension of Windows Admin Center for this purpose.

### View container images

1. Open the container host that you want to manage.

1. In the **Tools** pane, select **Containers** to open the Containers extension.

1. In the main pane, under **Container host**, select **Images**.

   :::image type="content" source="media/WAC-Images.png" alt-text="Screenshot of Windows Admin Center. In the Containers extension, the Images tab lists information about images, such as the repository and image ID." lightbox="media/WAC-Images.png":::

### Pull a container image

1. If your host doesn't have a base container image, select **Pull** to open the **Pull Container Image** dialog.

   :::image type="content" source="media/WAC-Pull.png" alt-text="Screenshot of the Pull Container Image dialog, with fields for the repository and tag. Several common Windows images are available for selection.":::

1. In the **Pull Container Image** dialog, enter the image URL and the tag.
   - If you aren't certain which image to pull, expand **Common Windows images** to see a list of common images from Microsoft.
   - If you want to pull an image from a private repository, expand **Registry authentication** to enter the credentials.

1. Select **Pull**. Windows Admin Center starts the pull process on the container host. When the download is complete, you see the new image on the **Images** tab.

### Run an image

1. Select the image you want to run, and then select **Run**. The **Run image** dialog opens.

   :::image type="content" source="media/WAC-RunContainers.png" alt-text="Screenshot of the Run image dialog, with fields for the container name and other information. An Add button is available for configuring options.":::

1. In the **Run image** dialog, enter information to configure the container, such as the container name, the isolation type, the ports to publish, and the memory and CPU allocation. You can also add options to append to the `docker run` command, such as `-v` to specify a persistent volume. For more information about available `docker run` parameters, see [`docker container run`](https://docs.docker.com/reference/cli/docker/container/run/).

1. Select **Run**. The **Containers** tab displays the status of the running containers.

   :::image type="content" source="media/WAC-Containers.png" alt-text="Screenshot of Windows Admin Center. In the Containers extension, the Containers tab lists information about one container, such as the ID and status." lightbox="media/WAC-Containers.png":::

## Next step

> [!div class="nextstepaction"]
> [See how to containerize a sample app](./building-sample-app.md)
