ms.ContentId: C49DA0E6-2E12-4D51-803A-31B1B5A8F85C
title: PowerShell Reference


# PowerShell for Containers  #


## Managing containers ##

Containers can easily be managed with PowerShell. Users with experience managing Hyper-V VMs through PowerShell will find managing containers to be very similar.



## Commands ##

### Listing containers ###

Because containers and traditional VMs work happily together, retrieving a list of your containers is as easy as

    PS C:\> Get-VM
    Name . . . . CPUUsage . . . . AssignedMemory . . . . 
    
    

What if you don't want your old VMs in the list? Just specify

    PS C:\> Get-VM -subtype Xenon


If you want to get a specific set of containers or VMs


    PS C:\> Get-VM -subtype Xenon | where ($_.status -eq 'running')


### Managing packages ###

Managing packages is an important part of working with containers. You can build a container from a package, as well as build a package from a container. 

A base package is the starting point for all containers. Here is how you can create a container that is based on one of the provided base packages. 

    PS C:\> New-VM -subtype Xenon -package $DefaultPackage -Name "MyFirstXenon"

Now you can start the container you just created. Use the -EnterSession flag to automatically connect to the container.

    PS C:\> Start-VM MyFirstXenon -EnterSession

Now you are in a session inside your shiny new container, and you can continue to use Powershell to install applications in it. 

    [myFirstXenon]: PS C:> Add-WindowsFeature -Name IIS

Continue adding applications and configuring your container. 

### Creating new packages ###

Once you're done setting up your container, you can use it to create a new package. First, you need to stop the container. Simply exit the container with 'exit'

    
    [myFirstXenon]: PS C:> exit
    TEsting           this thing             woah         Sarah was right
 
Now you are back to your original Powershell session, but the container is still running. Let's stop the container, and create a new package based on it.


    PS C:\> Stop-VM myFirstXenon -Passthru | New-VMPackage -PackageName 'myPackageWithIIS'

Let's take a look at what we just did. First, we stopped the container with the Stop-VM cmdlet, and used the -Passthru flag, which passes the container object through the pipeline (|) to New-VMPackage, which creates a new package that includes the changes we made to the container. If you were to create a new container from this package, you would find that the container still has the applications that you installed!

In summary, we started with a base package, spun up a container from it, installed our application in the container, and saved it back as a new package. Our new package can now be easily passed around the team or deployed to the cloud.

## Markdown testing ##

Lists of things

- this
- this
- also this



Trying to create a quoteblock 

    I'm not a quoteblock but I am 
    A script block!

    and this


1. this is item 1
2. This is item 2
3. Yay for ordered lists

1/29/2015 1:57:50 PM 

1/29/2015 1:57:55 PM 


## Tutorial:  ##

Watch this tutorial to learn more

[![Tutorial](http://upload.wikimedia.org/wikipedia/commons/4/4a/Video_icon1.png)](https://www.youtube.com/watch?v=xSE9Qk9wkig)


