ms.ContentId: 37e66cb2-c05e-4c5a-9da7-bb477cabf2ba
title: Contribute to this Documentation

# Contribute to this Documentation #

Did we get something wrong?  Do you have something to add?  Follow these steps to start contributing to the documentation.

## Quickest way to jump in and help

If you just want to make a small change or two to an existing topic, the easiest thing to do is to jump onto [VSOnline](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV#path=%2Fwindowscontainers&version=GBrelease&_a=contents) and make the change right in the repo.

1. Go here: [VSOnline](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV#path=%2Fwindowscontainers&version=GBrelease&_a=contents)
2. Select the .md file and then click **Edit**. 

![](media\vsonline.png)

3. This opens a simple online editor where you can make changes. Just click the **Save** button when you are done to add the changes to the repo. 

![](media\vsoeditor.png)

## Set up Git ##

### Install Git ###
Install [Git for Windows](http://git-scm.com/download/win "http://git-scm.com/download/win")
- Gitbash is the command-line app that you will use to interact with your local Git repository
- Git GUI is an app used to create and clone Git repositories.
* Note: Accepting all default settings during installation is fine

Optional:
To use GIT at a Powershell prompt, [download msysgit](http://msysgit.github.io/ "http://msysgit.github.io/") and to use Git from Visual Studio, install the [Visual Studio extensions](https://visualstudiogallery.msdn.microsoft.com/8f594baa-e44e-4114-8381-e175ace0fe97 "https://visualstudiogallery.msdn.microsoft.com/8f594baa-e44e-4114-8381-e175ace0fe97")

### Clone the repository locally ###
Go to the [repository in VS Online](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV#path=%2F&version=GBrelease&_a=contents "https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV#path=%2F&version=GBrelease&_a=contents")

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

In our documentation system, release is the branch that publishes to stage, master publishes to live.  **Never work directly in master.**

If you're feeling adventurous, read more about git branching here (link eventually about having a topic branch).

## Create your new file ##
You want to create a file named my_new_content.md in the reference section.  

First you'll want to make a new markdown file.  There are a number of ways to do this and a number of tools you can use.  I've been using the CodeWriter metro app or Notepad but [MarkdownPad](http://www.markdownpad.com/ "http://www.markdownpad.com/") or [Notepad++](http://notepad-plus-plus.org/ "http://notepad-plus-plus.org/") are also great.

Open your editor of choice and make a new file.  Name it my_new_content.md and save it to /windowscontainers/reference

Add your new file to the TOC.

For this example, open /windowscontainers/reference/TOC.csv

and add the line:

	**,my_new_content.md

To fully understand these seemingly arbitrary steps, read folder and file structure.  Otherwise, skip that section.


### Folder/File structure ###

The documentation website's structure matches the git folder structure.  Looking inside the HyperV repository, the folder structure should look a bit like this:

	HyperV
		{build goo: Hyper-V, siteCatalog.json, publish.mdproj,etc} 
		tools
		windowscontainers
			{build goo}
			about
			quick_start
			userguide
			reference
			community

Inside each of those folders corresponding to a heading on the navigation pane at the top of the container documentation, there will be some similar structure.  Let's look at the "about" folder as an example:

	about
		{content pages}
		TOC.cvs
		ContainerNodeTitles.csv
		center.json

Content is added to the folder as a markdown folder then to the TOC in order to tell the build system where that content should live in the site structure.

Here is a sample TOC:

	*,oa-toc-container:section_name
	**,section_landingpage.md
	**,content1.md 
	**,oa-toc-container:deep_dive_content
	***,deep_dive_landingpage.md
	***,deep_dive1.md
	**,content3.md.md

oa-toc-container:section_name specifies that the landing page should automatically redirect to the next sub heading.  This builds the breadcrumb at the top of the page.
Asterisk (*) indicate the breadcrumb depth.

To register a 
		

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

### Pandoc for converting files to markdown ###

Download Pandoc here: [https://github.com/jgm/pandoc/releases](https://github.com/jgm/pandoc/releases "https://github.com/jgm/pandoc/releases")

To convert a .docx file called **containers.docx** to a .md file with the same name, type: 

    pandoc -f docx -t markdown containers.docx -o containers.md

The switches are:

    -f = from
    -t = to
    -o = output


## See the changes ##

## References ##
A good example of a fully fleshed-out OA site: [Office365](https://msdn.microsoft.com/en-us/office/office365/api/api-catalog "https://msdn.microsoft.com/en-us/office/office365/api/api-catalog") here's a [link to their repo](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/O365API#path=%2Foffice%2Foffice365%2FAPI&version=GBmaster&_a=contents "https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/O365API#path=%2Foffice%2Foffice365%2FAPI&version=GBmaster&_a=contents")


