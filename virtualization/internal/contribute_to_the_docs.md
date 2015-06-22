ms.ContentId: 1A979BC9-C43C-40A2-B60C-4ECC042AC7DC
title: Contribute to the documentation

# Contribute to the documentation #

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

On the right part of the page, click **Clone** and copy the address for cloning into your clipboard. Is should be: `https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV`

You may encounter a note about alternate credentials:

![](media\clone_firstrun.png)

You can set up alternate credentials to use a git client (if you have not already done so). Click **Profile** to open your profile dialog. Under **Credentials**, click **Enable alternate credentials** and set up an alternate username/password.

![](media\enable_alt_cred.png)

To clone the repo, open GitBash and enter:

	cd {path where you want the local copy of the repository} 
	//example: cd c:\GIT
	
	git clone https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV

	cd hyperv


### Branches ###
Run

	git branch

to see what branch you're currently in.  If it list the working branch (like Ignite or containerbits), you're great.  Continue to creating and adding your file.  If not, run

	git checkout <branch>

In our documentation system, release is the branch that publishes to stage, master publishes to live. The working branches are where you should be working and they are usually named after the release. **Never work directly in master.**

If you're feeling adventurous, read more about git branching here (link eventually about having a topic branch).

## Create your new file ##
You want to create a file named my_new_content.md in the reference section.  

First you'll want to make a new markdown file.  There are a number of ways to do this and a number of tools you can use.  I've been using the CodeWriter metro app or Notepad but [MarkdownPad](http://www.markdownpad.com/ "http://www.markdownpad.com/") or [Notepad++](http://notepad-plus-plus.org/ "http://notepad-plus-plus.org/") are also great.

Open your editor of choice and make a new file.  Name it my_new_content.md and save it to /windowscontainers/reference

Add your new file to the TOC.

For this example, open /virtualization/TOC.csv

and add the line:

	**,my_new_content.md

To fully understand these seemingly arbitrary steps, read folder and file structure.  Otherwise, skip that section.


### Folder/File structure ###

The documentation website's structure matches the git folder structure.  Looking inside the HyperV repository, the folder structure should look a bit like this:

	HyperV
		{build goo: Hyper-V, siteCatalog.json, publish.mdproj,etc} 
		tools
		virtualization
			windowscontainers
				{build goo}
				about
				quick_start
				userguide
				reference
			Community
			API	
				WMI
				Powershell
				REST

There is also a folder in the repo for the Client Hyper-V documentation for Windows 10 which will be hosted on the same site.

In the virtualization folder, there will be some site level files:

    	```about
    		{content pages}
    		TOC.csv
    		ContainerNodeTitles.csv
    		center.json```
    
Content is added to the folder as a markdown folder then to the TOC in order to tell the build system where that content should live in the site structure.

Here is a sample TOC:

    	```*,oa-toc-container:section_name
    	**,section_landingpage.md
    	**,content1.md 
    	**,oa-toc-container:deep_dive_content
    	***,deep_dive_landingpage.md
    	***,deep_dive1.md
    	**,content3.md.md```

oa-toc-container:section_name specifies that the landing page should automatically redirect to the next sub heading.  This builds the breadcrumb at the top of the page.
Asterisk (*) indicate the breadcrumb depth.



### Add Metadata ###
In order to convert your markdown files and internal documentation into HTML5, the each file must have some basic metadata.  There are many optional pieces of metadata but the two that are required are:

	ms.ContentId: <GUID>
	title: <Title>

To generate GUIDs, use the following PowerShell snippit:

	[guid]::NewGuid().ToString() | clip.exe

This command will generate a new GUID and put it on your clipboard so you can paste it directly into your file.

You can also create a GUID using Visual Studio, just click **Tools** > **Create GUID**. Option 4 gives you the GUID in the most bare format, but you still have to remove the brackets after you paste the GUID into the header.

Optional metadata includes:

	description: {discription of the page}


## Write content in MarkDown ##

There are lots of resources for how to write in markdown, here are a few favorites:

- [http://devdocs/HowTo/Markdown](http://devdocs/HowTo/Markdown)

- [http://markdowntutorial.com/lesson/1/](http://markdowntutorial.com/lesson/1/)

## Getting ready to publish content - staging ##

The working branch needs to be merged with the release branch in order to be built for staging. Type the following:
	git checkout release
	git merge <branch>
	git push



## Pushing content live ##

Talk to Cynthia Nottingham (cynthn) or Sarah Cooley (scooley) to get your changes pushed live.
 

## Pandoc for converting .doc files to markdown ##

Download Pandoc here: [https://github.com/jgm/pandoc/releases](https://github.com/jgm/pandoc/releases "https://github.com/jgm/pandoc/releases")

To convert a .docx file called **containers.docx** to a .md file with the same name, type: 

    pandoc -f docx -t markdown containers.docx -o containers.md

The switches are:

    -f = from
    -t = to
    -o = output


## Local Preview
The Open Authoring team have build a local preview so you can see how your content will look before committing your changes.

1. Install the tool from here: [http://co1msdnwbh01/LocalPreview/OA-LocalPreview.application](http://co1msdnwbh01/LocalPreview/OA-LocalPreview.application) 
2. Click on the ![](media\local_preview_icon.png) icon in your system tray and click Configuration. 
3. Click the **+** button to add a new configuration and then enter the following values:

	**Friendly name**: Windows Containers (or whatever friendly name you prefer)
	
	**Domain URL**: https://int.msdn.microsoft.com
	
	**Repository folder**: the path to the root of your repo. For example: `C\HyperV`

3. Click **Save**.

4. To see a local preview of the file **about_overview.md** in your browsers, type: [http://localhost:7777/windowscontainers/about/about_overview.md](http://localhost:7777/windowscontainers/about/about_overview.md) in the address bar.

# Using Markdown Pad 2 #

If you use Markdown Pad 2 for authoring, you should change the markdown style to GitHub.

1. In Markdown Pad 2 got to **Tools** > **Options**
2. Select the **Markdown** tab.
3. In the drop-down menu for **Markdown Processor**, choose **GitHub Flavored Markdown**.
4. Click Save and Close. 

**Note**:
If you get a "You are almost out of error like this one: 

![](media\out_of_api.png)

You need to enter in your GitHub account credentials instead of using **Anonymous mode**. For Microsoft folks, this means using your GitHub account name and because we use 2-factor authentication, you need to enter in a token instead of your GitHub password. Follow the instructions here: [http://markdownpad.com/faq.html#gfm-twofactor](http://markdownpad.com/faq.html#gfm-twofactor)

## References ##
A good example of a fully fleshed-out OA site: [Office365](https://msdn.microsoft.com/en-us/office/office365/api/api-catalog "https://msdn.microsoft.com/en-us/office/office365/api/api-catalog") here's a [link to their repo](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/O365API#path=%2Foffice%2Foffice365%2FAPI&version=GBmaster&_a=contents "https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/O365API#path=%2Foffice%2Foffice365%2FAPI&version=GBmaster&_a=contents")

