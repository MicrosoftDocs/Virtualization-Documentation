---
author: scooley
redirect_url: ./manage_docker
---

# PowerShell to Docker comparison for managing Windows Containers

There are many ways to manage Windows Containers using both in-box Windows tools (PowerShell, in this preview) and Open Source management tools such as Docker.  
Guides outlining both individually available here:
* [Manage Windows Containers with Docker](../quick_start/manage_docker.md)
* [Manage Windows Containers with PowerShell](../quick_start/manage_powershell.md) 

This page is a more in depth reference comparing the Docker tools and PowerShell management tools.

## PowerShell for containers versus Hyper-V VMs
You can create, run, and interact with Windows Containers using PowerShell cmdlets. Everything you need to get going is available in-box.

If you’ve used Hyper-V PowerShell, the design of the cmdlets should be pretty familiar to you. A lot of the workflow is similar to how you’d manage a virtual machine using the Hyper-V module. Instead of `New-VM`, `Get-VM`, `Start-VM`, `Stop-VM`, you have `New-Container`, `Get-Container`, `Start-Container`, `Stop-Container`.  There are quite a few container-specific cmdlets and parameters, but the general lifecycle and management of a Windows container looks roughly like that of a Hyper-V VM.

## How does PowerShell management compare to Docker? 
The Containers PowerShell cmdlets expose an API that isn’t quite the same as Docker's; as a general rule, the cmdlets are more granular in operation. Some Docker commands have pretty straightforward parallels in PowerShell:

| Docker command |	PowerShell Cmdlet |
|----|----|
| `docker ps -a`	| `Get-Container` |
| `docker images`	| `Get-ContainerImage` |
| `docker rm`	| `Remove-Container` |
| `docker rmi` | `Remove-ContainerImage` |
| `docker create`	| `New-Container` |
| `docker commit <container ID>` | `New-ContainerImage -Container <container>` |
| `docker load <tarball>` | `Import-ContainerImage <AppX package>` |
| `docker save` |	`Export-ContainerImage` |
| `docker start` |	`Start-Container` |
| `docker stop` |	`Stop-Container` |

The PowerShell cmdlets are not an exact perfect parity, and there are a fair number of commands that we’re not providing PowerShell replacements for* (notably `docker build` and `docker cp`). But what might leap out at you is that there’s no single one-line replacement for `docker run`.

\* Subject to change.

### But I need docker run! What’s going on?  
We’re doing a couple things here to provide a slightly more familiar interaction model for users who know their way around PowerShell already. Of course, if you’re used to the way docker operates, this will be a bit of a mental shift.

1.	The lifecycle of a container in the PowerShell model is slightly different. In the Containers PowerShell module, we expose the more granular operations of `New-Container` (which creates a new container that’s stopped) and `Start-Container`.
  
  In between creating and starting the container, you can also configure the container’s settings; for TP3, the only other configuration we’re planning to expose is the ability to set the network connection for the container. using the (Add/Remove/Connect/Disconnect/Get/Set)-ContainerNetworkAdapter cmdlets.

2.	You can’t currently pass a command to be run inside the container on start. However, you can still get an interactive PowerShell session to a running container using `Enter-PSSession -ContainerId <ID of a running container>`, and you can execute a command inside a running container using `Invoke-Command -ContainerId <container id> -ScriptBlock { code to run inside the container }` or `Invoke-Command -ContainerId <container id> -FilePath <path to script>`.  
Both of these commands allow the optional `-RunAsAdministrator` flag for high privilige actions.  


## Caveats and known issues
1.  Right now, the Containers cmdlets have no knowledge about any containers or images created through Docker, and Docker does not know anything about containers and images created through the PowerShell. If you created it in Docker, manage it with Docker; if you created it through PowerShell, manage it through PowerShell.

2.  We have quite a bit of work we'd like to do to improve the end user experience -- better error messages, better progress reporting, invalid event strings, and so forth. If you happen to run into a situation where you wish you were getting more or better info, please feel free to send suggestions to the forums.

## A quick runthrough
Here is a walk through of some common workflows.

This assumes you've installed an OS container image named "ServerDatacenterCore" and created a virtual switch named "Virtual Switch" (using New-VMSwitch).

``` PowerShell
### 1. Enumerating images
# At this point, you can enumerate the images on the system:
Get-ContainerImage

# Get-ContainerImage also accepts filters.
# For example, this will return all container images whose Name starts with S (case-insensitive):
Get-ContainerImage -Name S*

# You can save the results of this to a variable.
# (If you're not familiar with PowerShell, the "$" denotes a variable.)
$baseImage = Get-ContainerImage -Name ServerDatacenterCore
$baseImage

### 2. Creating and enumerating containers
# Now, we can create a new container using this image:
New-Container -Name "MyContainer" -ContainerImage $baseImage -SwitchName "Virtual Switch"

# Now we can enumerate all containers.
Get-Container

# Similarly, we can save this container to a variable:
$container1 = Get-Container -Name "MyContainer"

### 3. Starting containers, interacting with running containers, and stopping containers
# Now let's go ahead and start the container.
Start-Container -Name "MyContainer"

# (We could've also started this container using "Start-Container -Container $container1".)

# With the container now running, let's go ahead and enter an interactive PowerShell session:
Enter-PSSession -ContainerId $container1.Id

# This should eventually bring up a PowerShell prompt from inside the container.
# You can try all the things that you did in the interactive cmd prompt given by "docker run -it".
# For now, just to prove we've been here, we can create a new file:
cd \
mkdir Test
cd Test
echo "hello world" > hello.txt
exit

# Now we should be back in the outside world. Even though we've exited the PowerShell session,
# the container itself is still running, as you can see by printing out the container again:
$container1

# Before we can commit this container to a new image, we need to stop the container.
# Let's do that now.
Stop-Container -Container $container1

### 4. Creating a new container image
# And now let's commit it to a new image.
$image1 = New-ContainerImage -Container $container1 -Publisher Test -Name Image1 -Version 1.0

# Enumerate all the images again, for sanity's sake:
Get-ContainerImage

# Rinse and repeat! Make another container based on the new image.
$container2 = New-Container -Name "MySecondContainer" -ContainerImage $image1 -SwitchName "Virtual Switch"

# (If you like, you can start the second container and verify that the new file
# "\Test\hello.txt" is there as expected.)

### 5. Removing a container
# The first container we created is now stopped. Let's get rid of it:
Remove-Container -Container $container1

# And confirm that it's gone:
Get-Container

### 6. Exporting, removing, and importing images
# For images that aren't the base OS image, we can export them into an .appx package file.
Export-ContainerImage -Image $image1 -Path "C:\exports"
# This should create a .appx file in the C:\exports folder.
# If you've given your image the same publisher, name, and version we used earlier,
# you'd expect the resulting .appx to be named "CN=Test_Image1_1.0.0.0.appx".

# Before we can try importing the image again, we need to remove the image.
# (If you have any running containers that depend on this image, you'll want to stop them first.)
Remove-ContainerImage -Image $image1

# Now let's import the image again:
Import-ContainerImage -Path C:\exports\CN=Test_Image1_1.0.0.0.appx

# We'd previously created a container dependent on this image. You should be able to start it:
Start-Container -Container $container2 
```

### Build your own sample
You can see all the Containers cmdlets using `Get-Command -Module Containers`.  There are several other cmdlets that are not described here, which we'll leave to you to learn about on your own.    
**Note** This won't return the `Enter-PSSession` and `Invoke-Command` cmdlets, which are part of core PowerShell.

You can also get help about any cmdlet using `Get-Help [cmdlet name]`, or equivalently `[cmdlet name] -?`.  Today, the help output is auto-generated and just tells you the syntax for commands; we will be adding further documentation as we get closer to finalizing the cmdlet design.

A nicer way to discover the syntax is the PowerShell ISE, which you may not have looked at before if you haven't used PowerShell very much. If you're running on a SKU that permits it, try starting the ISE, opening the Commands pane, and choosing the "Containers" module, which will show you a graphical representation of the cmdlets and their parameter sets.

PS: Just to prove it can be done, here's a PowerShell function that composes some of the cmdlets we've seen already into an ersatz `docker run`. (To be clear, this is a proof of concept, not under active development.)

``` PowerShell
function Run-Container ([string]$ContainerImageName, [string]$Name="fancy_name", [switch]$Remove, [switch]$Interactive, [scriptblock]$Command) {
    $image = Get-ContainerImage -Name $ContainerImageName
    $container = New-Container -Name $Name -ContainerImage $image
    Start-Container $container

    if ($Interactive) {
         Start-Process powershell ("-NoExit", "-c", "Enter-PSSession -ContainerId $($container.Id)") -Wait
    } else {
        Invoke-Command -ContainerId $container.Id -ScriptBlock $Command
    }

    Stop-Container $container

    if ($Remove) {
        Remove-Container $container -Force
    }
} 
```

## Docker
Windows Containers can be managed with Docker commands.  While Windows containers should be comparable to their Linux counterparts and have the same management experience through Docker, there are some Docker commands that simply don't make sense with a Windows container.  Others simply haven't been tested (we're getting there).

In an effort to not duplicate the API documentation available in Docker, <a href="https://docs.docker.com/engine/reference/commandline/cli/" >here</a> is a link to their management APIs.  Their walkthroughs are fantastic.

We're tracking things that do and don't work in the Docker APIs in our Work in Progress document.
