This guide was written by Cynthia Nottingham and Sarah Cooley. Please let us know if you run into any issues or the steps aren't clear.

## Install Git ##
Install Git for Windows: [http://git-scm.com/download/win](http://git-scm.com/download/win "http://git-scm.com/download/win")
- Gitbash is the command-line app that you will use to interact with your local Git repository
- Git GUI is an app used to create and clone Git repositories.
- Accept all default settings

Optional: To use GIT at a Powershell prompt, download this: [http://msysgit.github.io/](http://msysgit.github.io/ "http://msysgit.github.io/") and to use Git from VS, install the VS extensions: [https://visualstudiogallery.msdn.microsoft.com/8f594baa-e44e-4114-8381-e175ace0fe97](https://visualstudiogallery.msdn.microsoft.com/8f594baa-e44e-4114-8381-e175ace0fe97 "https://visualstudiogallery.msdn.microsoft.com/8f594baa-e44e-4114-8381-e175ace0fe97")

## Enable Alternate Credentials ##
1. Go to the repository in VS Online: [https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV "https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV")
2. On the upper right, click your name and then click **My profile**.  
3. In your profile details, click **Credentials**.
4. Check that the e-mail address is correct and then put in the password for your account and click **Save Changes**.

When you use GitBash you will occasionally be asked to enter your username and password. The information that you just entered for your alternate credentials will be what you have to enter in GitBash. When you type your password in GitBash, you don't get asterisks or any other indication that you are typing.

## Clone the Repository ##

1. Back in VS Online, on the right part of the page, click **Clone** and copy the address for cloning into your clipboard. Is should be: https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV
2. Open GitBash
type **cd *path*** where *path* is where you want the files to be stored. For example: **cd c:\GIT**
3. Then type: **git clone https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV**
4. Type: **cd hyperv**. This puts you in the master branch.
5. Leave GitBash open for now. We will come back to it later.


## Write something ##
There are lots of options for creating markdown. You just need a text editor like:
- Good 'ol Notepad - already installed and bare bones beautiful.
- Notepad++: [http://notepad-plus-plus.org/](http://notepad-plus-plus.org/ "http://notepad-plus-plus.org/")
- MarkdownPad: [http://www.markdownpad.com/](http://www.markdownpad.com/ "http://www.markdownpad.com/")

1. For now, just open notepad and copy\paste the following into a file:
"# Hello World #"
2. Save the file into the folder you are using for the master repository as *alias*.md. For example: **C:\git\hyperv\cynthn.md**

## Add your file to Git ##

1. Go back to GitBash and type: **git add *alias*.md**. For example: **git add cynthn.md**. This adds or updates your files in the local "index". This is how Git tracks your files. FYI: Tab complete works in GitBash, so you can start typing the name of the file and hit **Tab** to have it auto-complete the file name.
2. Type: **git commit -am "Testing adding my files to master"**. This is how you tell Git that you have made a change to a file and prepare it for being pushed back to the master shared repository (origin). The information in quotes is used as a check-in remark.
3. Type: **git push**. This pushes your changes to the master copy in the shared repository (origin).
4. Go back to VS online and see if your files is listed there now: [https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV#path=%2F&version=GBmaster&_a=contents](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV#path=%2F&version=GBmaster&_a=contents "https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV#path=%2F&version=GBmaster&_a=contents"). You should see your new file and the comment that you put in when yo did the commit.

## Get all the new stuff from the master repository (origin) ##

Type: **git pull**

Pull often! If you do a push and haven't done a pull in awhile, you may have to deal with merge conflicts if someone else has also been working on that file.

## Send your local changes to the master shared repository (origin) ##
You have to do all three steps before your files are available for everyone else to pull:

1. **git add** ***.md** to add all your files or do **git add *filename*.md** to just add one file
2. **git commit -am "My reasoning for sharing these changes"**
3. **git push**


## Learn more ##

- Intro to GIT: [http://devdocs/HowTo/GitRepo](http://devdocs/HowTo/GitRepo "http://devdocs/HowTo/GitRepo")
- Intro to Markdown: [http://devdocs/HowTo/Markdown](http://devdocs/HowTo/Markdown "http://devdocs/HowTo/Markdown")
- Other materials rom DevDiv: [http://devdocs/](http://devdocs/ "http://devdocs/")
- T​his StackOverflow thread contains a glossary of Git terms such as repo, branch, fork, etc.: [http://stackoverflow.com/questions/7076164/terminology-used-by-git](http://stackoverflow.com/questions/7076164/terminology-used-by-git "http://stackoverflow.com/questions/7076164/terminology-used-by-git")
- Markdown cheat sheet: [https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet "https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet")​​
- Powerpoint presentation about onboarding done by DevDiv (not step-by-step but an okay resource): [https://microsoft.sharepoint.com/teams/DD_VSCS/dcs/_layouts/15/WopiFrame.aspx?sourcedoc={BF244921-4CC7-480F-AD99-A321BC283F17}&file=ADS%20Onboarding.pptx&action=default](https://microsoft.sharepoint.com/teams/DD_VSCS/dcs/_layouts/15/WopiFrame.aspx?sourcedoc={BF244921-4CC7-480F-AD99-A321BC283F17}&file=ADS%20Onboarding.pptx&action=default "ADS Onboarding Presentation")
- Pandoc for converting between markdown and other formats: [http://johnmacfarlane.net/pandoc/](http://johnmacfarlane.net/pandoc/ "http://johnmacfarlane.net/pandoc/")


## Publish ##
How to manually promote content to staging: [http://devdocs/Learn/ManualTrigger](http://devdocs/Learn/ManualTrigger "http://devdocs/Learn/ManualTrigger") 



