# Virtualization-Documentation
Place to store our documentation, code samples, etc for public consumption and contributions.

## Contribute
To contribute, fork the project and submit a pull request!

Digging into the repo structure a little:

### doc-site
This is a mirrored copy of the documentation available on the [msdn virtualization site](https://msdn.microsoft.com/virtualization).

Folders you can add to:
* **virtualization** -- Contribute here! --  
This folder contains all of the markdown for the docs!

  The folder structure matched the URL structure for the website.
  
  **For example: **  Say you want to edit the user guide article for working with checkpoints.  
  msdn location: [https://msdn.microsoft.com/virtualization/hyperv_on_windows/user_guide/checkpoints](https://msdn.microsoft.com/virtualization/hyperv_on_windows/user_guide/checkpoints)  
  doc location:  
  doc-site/virtualization/hyperv_on_windows/user_guide/checkpoints.md
  
  If you add a screen shot or picture, put it in the media folder closest to the article you're contributing to.  For the checkpoints userguide, that would be:  
  doc-site/virtualization/hyperv_on_windows/user_guide/media
   
* media -- shared media for the main landing page  
Chances are you aren't adding pictures to the landing page but, if you were, they would be in here.

Folders you don't care about -- _I will not review pull requests that modify any of these folders._  All of their contents are for doc parsing robots only.
* Hyper-V -- contains git config information for the docs
* Tools -- site building tools


### demos
Demos of Hyper-V.  These are public scripts from various presentations and conferences.

Everything in here was made to present once.  There are many agregious hacks.  Don't use any of it in production.

### *-samples
Walkthroughs and samples.

### *-tools
Scripts to automate Hyper-V/Windows Container things.

