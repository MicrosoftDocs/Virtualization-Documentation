ms.ContentId: 1A979BC9-C43C-40A2-B60C-4ECC042AC7DC
title: Contribute to the documentation

# Contribute to the documentation 

Did we get something wrong?  Do you have something to add?  Follow these steps to start contributing to the documentation.

## Quickest way to jump in and help

If you just want to make a small change or two to an existing topic, the easiest thing to do is to jump onto [VSOnline](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV) 

1. Go here: [VSOnline](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV)
2. Make sure you are in the right branch. Pick the repo from the drop-down on the right.
	- containerbits - Containers content for TP3 and beyond
	- win10 - for content that will ship in support of Hyper-V in Windows 10
3. Select the .md file from the left pane and then click **Edit**. 

	![](media\vsonline.png)

4. This opens a simple online editor where you can make changes. Just click the **Save** button when you are done to add the changes to the repo. 

	![](media\vsoeditor.png)


Ask Catherine Watson or Cynthia Nottingham about how to contribute to the Windows Server 2016 documentation.

## Set up Git 

### Install Git 
Install [Git for Windows](http://git-scm.com/download/win "http://git-scm.com/download/win")
- Gitbash is the command-line app that you will use to interact with your local Git repository
* Note: Accepting all default settings during installation is fine, but if you want to use Git in Powershell and from the cmd prompt, select the **Use Git from the Windows Command Prompt** option shown below:
![](media\git_install.png)

Optional:
To use GIT at a Powershell prompt, [download msysgit](http://msysgit.github.io/ "http://msysgit.github.io/") 
To use Git from Visual Studio, install the [Visual Studio extensions](https://visualstudiogallery.msdn.microsoft.com/8f594baa-e44e-4114-8381-e175ace0fe97)

### Create and access token

If you are having access issues in Git using your corp credentials, you may need to create an access token.
1. Go here: [VSOnline](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV)
2. Click on your name in upper right-hand area of browser 
3. Click My Profile >  Security tab  > Personal Access tokens > Add 
4. In Description, name it Git and then in Expires In change it to 1 year. 
5. Leave the other defaults and then click Create Token.
**Before you do anything else, make sure you copy and paste the token someplace safe!!!!**
A .txt file on your OneDrive for Business is a good place.
When you are asked  for username in GitBash, use your full e-mail address (alias@microsoft.com) and Git access token as your password. You should only ave to use the access token once, after that your corporate password should work.


### Clone the repository locally 
1. Go to the [repository in VS Online](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV)

2.On the right part of the page, click **Clone** and copy the address for cloning into your clipboard. Is should be: 
```
https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV 
```

3. In GitBash, change to the folder where you want the local copy of the repository:
	```cd <path_to_my_repo>```
4. To clone the repo, type:
```git clone https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV```
Git will ask for your username (alias@microsoft.com) and password. If you are having issues, use the access token you created as the password instead of your corporate password.

5. Get all of the indexes locally, type:
```git fetch --all```


### Cache your credentials

Don't want to enter your username and password over-and-over? Use the handy tool from here: http://gitcredentialstore.codeplex.com/

### Branches 
Run

	```git branch```

to see what branch you're currently in.  If it list the rigt branch (like win10 or containerbits), you're great.  Continue to creating and adding your file.  If not, run

	```git checkout <branch>```

**Never work directly in master.**


## Install a writing tool

We recommend VSCode - [https://www.visualstudio.com/en-us/products/code-vs.aspx](https://www.visualstudio.com/en-us/products/code-vs.aspx)  
You can use any text editor, but VSCode is really nice!

### Using VSCode

To preview a file, click CTRL+Shift+V or click the **Split Editor** button and then in the second pane, click **Open Preview**.

Auto save and revert - you can setup  VS Code to auto save. Use the File > Revert File option if you need to revert.

To turn on word wrap:
1. Go to File > Preferences > User Settings 
2. Find the setting “editor.wrappingcolumn”: 300, 
3. Copy and paste that setting into the curly braces in the .json pane and change it to:   `“editor.wrappingColumn”: 0,`
4. Save and close the settings file.



## Create a new file ##

1. Create a new file and name it something readable with .md as extension
2. At the top of the file, before any whitespace, you need 2 things:  
	```ms.ContentId: <GUID>```
	(use new-guid cmdlet in Powershell or Tools -> Create GUID in VS)
	```title: <title of the file>```
3. When you are done, add it to Git:
	```Git add myfile.md```
	```Git commit –m “my new file”```
	```Git push```
4. Add the file to te TOC by adding a line to the file `<your repo path>\virtualization\toc.csv`. For example, this is the entry for the When to use containers topic in the About section of the Windows Containers content:
	```****,windowscontainers/about/when_containers.md```
5. When you are done, add the updated toc.csv back to git too (see above – add, commit, push!)


### Folder/File structure ###

The documentation website's structure matches the git folder structure.  Looking inside the HyperV repository, the folder structure should look a bit like this:

	```HyperV
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
				REST```

There is also a folder in the repo win10 for the Client Hyper-V documentation for Windows 10 which will be hosted on the same site.

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


## Write content in MarkDown ##

There are lots of resources for how to write in markdown, here are a few favorites:

- [http://devdocs/HowTo/Markdown](http://devdocs/HowTo/Markdown)

- [http://markdowntutorial.com/lesson/1/](http://markdowntutorial.com/lesson/1/)

## Staging on sandbox


## Staging on int before going live

The working branch needs to be merged with the release branch in order to be built for *int* staging (https://int.msdn.microsoft.com/en-us/virtualization/windowscontainers/about/about_overview). 

To launch a staging build, type the following:
	```git checkout release
	git merge <branch>
	git push```



## Pushing content live

Talk to Cynthia Nottingham (cynthn), Neil Peterson (nepeters) or Sarah Cooley (scooley) to get your changes pushed live.
 

## Pandoc for converting .doc files to markdown 

Download Pandoc here: [https://github.com/jgm/pandoc/releases](https://github.com/jgm/pandoc/releases)

To convert a .docx file called **containers.docx** to a .md file with the same name, type: 

    pandoc -f docx -t markdown containers.docx -o containers.md

The switches are:

    -f = from
    -t = to
    -o = output



## References 
A good example of a fully fleshed-out OA site: [Office365](https://msdn.microsoft.com/en-us/office/office365/api/api-catalog "https://msdn.microsoft.com/en-us/office/office365/api/api-catalog") here's a [link to their repo](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/O365API#path=%2Foffice%2Foffice365%2FAPI&version=GBmaster&_a=contents "https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/O365API#path=%2Foffice%2Foffice365%2FAPI&version=GBmaster&_a=contents")

