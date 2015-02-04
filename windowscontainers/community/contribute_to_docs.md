ms.ContentId: 37e66cb2-c05e-4c5a-9da7-bb477cabf2ba
title: Contribute to this Documentation

# Contribute to this Documentation #

Did we get something wrong?  Do you have something to add?  Follow these steps to start contributing to the documentation.


## Set up Git ##

### Install Git ###
Install [Git for Windows](http://git-scm.com/download/win "http://git-scm.com/download/win")
- Gitbash is the command-line app that you will use to interact with your local Git repository
- Git GUI is an app used to create and clone Git repositories.
- Accepting all default settings is fine

Optional:
To use GIT at a Powershell prompt, [download msysgit](http://msysgit.github.io/ "http://msysgit.github.io/") and to use Git from Visual Studio, install the [Visual Studio extensions](https://visualstudiogallery.msdn.microsoft.com/8f594baa-e44e-4114-8381-e175ace0fe97 "https://visualstudiogallery.msdn.microsoft.com/8f594baa-e44e-4114-8381-e175ace0fe97")

### Clone the repository locally ###
Go to the [repository in VS Online](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV#path=%2F&version=GBrelease&_a=contents)

On the right part of the page, click **Clone** and copy the address for cloning into your clipboard. Is should be: https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV

Open GitBash and enter:

	cd {path where you want the local copy of the repository} 
	//example: cd c:\GIT
	
	git clone https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV

	cd hyperv


### Branches ###
Run

	git branch

to see what branch you're currently in.  If it says release, you're great.  Continue to creating and adding your file.  If not, run

	git checkout release



## Create your new file ##
You want to create a file named my_new_content.md in the reference section.  

First you'll want to make a new markdown file.  There are a number of ways to do this and a number of tools you can use.  I've been using the CodeWriter metro app or Notepad but MarkdownPad or Notepad++ are also great.

Open your editor of choice and make a new file.  Name it my_new_content.md and save it to /windowscontainers/reference

### Folder structure ###


### Add Metadata ###
In order to convert your markdown files and internal documentation into HTML5, the each file must have some basic metadata.  There are many optional pieces of metadata but the two that are required are:

	ms.ContentId: {GUID}
	title: {Title}

To generate GUIDs, use the following PowerShell snippit:

	[guid]::NewGuid().ToString() | clip.exe

This command will generate a new GUID and put it on your clipboard so you can paste it directly into your file.


Optional metadata includes:

	description: {discription of the page}


### Write content in MarkDown ###



## See the changes ##

## References ##
A good example of a fully fleshed-out OA site: [Office365](https://msdn.microsoft.com/en-us/office/office365/api/api-catalog) here's a [link to their repo](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/O365API#path=%2Foffice%2Foffice365%2FAPI&version=GBmaster&_a=contents)


