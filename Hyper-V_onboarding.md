## Setup your machine ##



1. Install GIT for Windows:
2. Install the VS extensions:
3. Go to the repo in VS Online: [https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV](https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV "https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV")
4. On the upper right, click your name and then click "My profile".  
5. In your profile details, click "Credentials".
6. Check that the e-mail address is correct and then put in the password for your account and click "Save Changes"
7. Back in VS Online, on the right part of the page, click "Clone" and copy the address for cloning into your clipboard. Is should be: https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV


For content makers:
Clone the git repo locally using
git clone https://mseng.visualstudio.com/DefaultCollection/Documentation/_git/HyperV
this will clone the repo locally.  Work is done in the master branch (which is the default branch)
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
- To use GIT at a Powershell prompt, download this: [http://msysgit.github.io/](http://msysgit.github.io/ "http://msysgit.github.io/")

- For the GIT GUI, download this:  [http://git-scm.com/download/gui/linux](http://git-scm.com/download/gui/linux "http://git-scm.com/download/gui/linux") 

- Powerpoint presentation about onboarding (not step-by-step but an okay resource): [https://microsoft.sharepoint.com/teams/DD_VSCS/dcs/_layouts/15/WopiFrame.aspx?sourcedoc={BF244921-4CC7-480F-AD99-A321BC283F17}&file=ADS%20Onboarding.pptx&action=default](https://microsoft.sharepoint.com/teams/DD_VSCS/dcs/_layouts/15/WopiFrame.aspx?sourcedoc={BF244921-4CC7-480F-AD99-A321BC283F17}&file=ADS%20Onboarding.pptx&action=default "ADS Onboarding Presentation")

- Intro to GIT: [http://devdocs/HowTo/GitRepo](http://devdocs/HowTo/GitRepo "http://devdocs/HowTo/GitRepo")
- Intro to Markdown: [http://devdocs/HowTo/Markdown](http://devdocs/HowTo/Markdown "http://devdocs/HowTo/Markdown")
- Other materials: [http://devdocs/](http://devdocs/ "http://devdocs/")

## Publish ##
How to manually promote content to stagin: [http://devdocs/Learn/ManualTrigger](http://devdocs/Learn/ManualTrigger "http://devdocs/Learn/ManualTrigger") 



