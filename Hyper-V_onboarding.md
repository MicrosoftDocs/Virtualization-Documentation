# TEST #

## Install ALL THE things! ##
Install GIT for Windows: [http://git-scm.com/download/win](http://git-scm.com/download/win "http://git-scm.com/download/win")
- Gitbash is the command-line app that you will use to interact with your local Git repository
- Git GUI is an app used to create and clone Git repositories.
- Accept all default settings
Install the VS extensions: [https://visualstudiogallery.msdn.microsoft.com/8f594baa-e44e-4114-8381-e175ace0fe97](https://visualstudiogallery.msdn.microsoft.com/8f594baa-e44e-4114-8381-e175ace0fe97 "https://visualstudiogallery.msdn.microsoft.com/8f594baa-e44e-4114-8381-e175ace0fe97")
Optional: To use GIT at a Powershell prompt, download this: [http://msysgit.github.io/](http://msysgit.github.io/ "http://msysgit.github.io/")

## Enable Alternate Credentials ##
Go to the repo in VS Online: [https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV "https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV")
On the upper right, click your name and then click "My profile".  
In your profile details, click "Credentials".
Check that the e-mail address is correct and then put in the password for your account and click "Save Changes"

## Clone the Repository ##
Back in VS Online, on the right part of the page, click "Clone" and copy the address for cloning into your clipboard. Is should be: https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV
Open GitBash
type cd <path where you want the files to be stored>. For example: **cd c:\GIT**
Then type: git clone https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV
Type: **cd hyperv**. This puts you in the master branch.
Leave GitBash open for now. We will come back to it later.




## Write something ##
There are a few options for creating markdown:
Good 'ol Notepad
Notepad++: [http://notepad-plus-plus.org/](http://notepad-plus-plus.org/ "http://notepad-plus-plus.org/")
MarkdownPad: [http://www.markdownpad.com/](http://www.markdownpad.com/ "http://www.markdownpad.com/")

For now, just open notepad and copy\paste the following into a file:
"# Hello World #"
Save the file into the folder you are using for the master repository as <alias>.md. For example: c:\git\heyperv\cynthn.md

## Add your file to Git ##
Go back to GitBash and type: **git add <alias.md>**. For example: **git add cynthn.md**
Type: git commit -am "Testing adding my files to master"
Go back to VS online and see if your files is listed there now: [https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV#path=%2F&version=GBmaster&_a=contents](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV#path=%2F&version=GBmaster&_a=contents "https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV#path=%2F&version=GBmaster&_a=contents")

## Sync your local files with the master repository ##

Type: git 








Save your files **.md** files. 

## Add you file to the Master repo ##




For content makers:


git pull to sync local repo to public

git add newfile.md
add tells git to start tracking that file in git.

git commit -am “commit message”
-a commits all modified files tracked to the checkin.  Without this you have to explicitly list file names to commit. m says you’ll enter a commit message.

git push syncs you to the public

Note to new git people: git pull all the time!  Merge conflicts suck.
http://devdocs/HowTo/GitRepo <- HowTo git

For now, just drop all of the stuff in master and we (Cynthia on Friday, me on Monday) will figure out structure for publication.


## Learn more ##
- 
- For the GIT GUI, download this:  [http://git-scm.com/download/gui/linux](http://git-scm.com/download/gui/linux "http://git-scm.com/download/gui/linux") 

- Powerpoint presentation about onboarding (not step-by-step but an okay resource): [https://microsoft.sharepoint.com/teams/DD_VSCS/dcs/_layouts/15/WopiFrame.aspx?sourcedoc={BF244921-4CC7-480F-AD99-A321BC283F17}&file=ADS%20Onboarding.pptx&action=default](https://microsoft.sharepoint.com/teams/DD_VSCS/dcs/_layouts/15/WopiFrame.aspx?sourcedoc={BF244921-4CC7-480F-AD99-A321BC283F17}&file=ADS%20Onboarding.pptx&action=default "ADS Onboarding Presentation")

- Intro to GIT: [http://devdocs/HowTo/GitRepo](http://devdocs/HowTo/GitRepo "http://devdocs/HowTo/GitRepo")
- Intro to Markdown: [http://devdocs/HowTo/Markdown](http://devdocs/HowTo/Markdown "http://devdocs/HowTo/Markdown")
- Other materials: [http://devdocs/](http://devdocs/ "http://devdocs/")
- T​his StackOverflow thread contains a glossary of Git terms such as repo, branch, fork, etc.: [http://stackoverflow.com/questions/7076164/terminology-used-by-git](http://stackoverflow.com/questions/7076164/terminology-used-by-git "http://stackoverflow.com/questions/7076164/terminology-used-by-git")
- - Markdown cheat sheet: [https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet "https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet")​​

## Publish ##
How to manually promote content to staging: [http://devdocs/Learn/ManualTrigger](http://devdocs/Learn/ManualTrigger "http://devdocs/Learn/ManualTrigger") 



