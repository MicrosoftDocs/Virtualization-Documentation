## Microsoft Open Source Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

# Virtualization-Documentation

Rendered documentation website [msdn.microsoft.com/virtualization](http://msdn.microsoft.com/virtualization).

Place to store our documentation, code samples, etc for public consumption and contributions.

## Contribute
To contribute, fork the project and submit a pull request!  Here's [our wishlist](./TODO.md).

If you want to submit prospective content but contributing to public documentation takes too much time/planning, submit your idea or draft to the [Prospective Docs](./prospective-docs) folder and we'll figure it out from there.

Digging into the repo structure a little:

### virtualization -- Contribute docs here! --  
This is a mirrored copy of the documentation available on the [msdn virtualization site](https://msdn.microsoft.com/virtualization).

The folder structure matched the URL structure for the website.

**For example: **  Say you want to edit the user guide article for working with checkpoints.  
msdn location: [https://msdn.microsoft.com/virtualization/hyperv_on_windows/user_guide/checkpoints](https://msdn.microsoft.com/virtualization/hyperv_on_windows/user_guide/checkpoints)  
doc location:  
`virtualization/hyperv_on_windows/user_guide/checkpoints.md`
  
If you add a screen shot or picture, put it in the media folder closest to the article you're contributing to.  For the checkpoints userguide, that would be:  
`virtualization/hyperv_on_windows/user_guide/media`

### demos
Demos of Hyper-V.  These are public scripts from various presentations and conferences.

Everything in here was made to present once.  There are many egregious hacks.  Don't use any of it in production.

### *-samples
Walkthroughs and samples.

### *-tools
Scripts to automate Hyper-V/Windows Container things.

### Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
