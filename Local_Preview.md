Title: Local Preview
Description: This topic contains important information that you should read or there is no hope that you will get local preview working.
Custom-keywords: local preview


## Note ##
- Your file needs to be listed in toc.txt in order to work in the local preview. If you need help adding your file, let Sarah or Cynthia know!

- The VS version of the instructions are here: http://devdocs/Learn/LocalPreview. They have nice screenshots which might be helpful, but the instructions aren't complete. 

## Connect to and clone the Preview Project ##

1. Open **Visual Studio 2013** as an administrator. 
2. On the right pane, click on the **Team Explorer** tab
3. Click **Select Team Projects**. The **Connect to Team Foundation Servers** dialog appears. 
4. Click on the **Servers** button and in the **Add\Remove Team Foundation Server** dialog, click **Add**.
5. Paste in this address: **https://mseng.visualstudio.com**. You might be asked for your credentials. When it is finished adding, click **Close**.
6. In the **Connect to Team Foundation Server** dialog, select **VSOnline** from the list and then click **Connect**.
7. Back in Visual Studio, in Team Explorer, click on the drop-down next to VSOnline and click **Projects** -> **My Teams** -> **Connect to Team Projects**.
8. Under VSOnline, scroll down and right-click on **MSDN.RenderingPreview** and select **Clone**.
9. Under **Local Git Repositories** it will have the path to the Rendering Preview as the source and then the second path is to where it will put the files on your local machine. It defaults to: `C:\Users\<username>\Source\Repos\MSDN.RenderingPreview`. Click **Clone**.

## Create a local branch for the preview ##
In GitBash, got to your local hyperV repo and then type: **git branch RenderingPreview**.

## Configure and build the preview project ##

1. Back in Visual Studio, click on **File** -> **Open** -> **Project\Solution**. Navigate to `C:\Users\<username>\Source\Repos\MSDN.RenderingPreview` and open  **Microsoft.DCS.Rendering.sln**.
2. In the right pane, in the Solution Explorer, right-click on the **NancySelfHostedWithSignalR** project and select **Set as startup project**.
3. Click on **Tools** -> **Options** -> **Package Manager** -> **Package Sources** and click the plus sign (+) to add a package source. Add the Nutmeg package location **\\\msdnfs\CodeDrop\Drops\MsNuGet** and then click **OK**.
4. Double-click on the file **app.config** in the **NancySelfHostedWithSignalR** project and find the line that looks like this: `<add key="ContentRepoPath" value="E:\Git\VSContent" />` and edit the path to be the path to your local repo files. For me, my repo is cloned at C:\HyperV so that line now reads: `<add key="ContentRepoPath" value="C:\hyperv" />`.
5. In app.config, find the line `<add key="webPages:Enabled" value="false" />` and change the value to **true**, like this: `<add key="webPages:Enabled" value="true" />`.
6. Save the **app.config** file.
7. Click on the **Build** menu and select **Build Solution**. It should build without errors. 

**Note:** If you *do* get build errors, try right-clicking on the **Microsoft.DCS.rendering.MiddleTier.UnitTests** and select **Unload Project**. Then click on the **Build** menu and select **Clean Solution** and when that is done, click on the **Build** menu and choose **Build Solution**. 

## Run the preview ##
1. Click **Start** to run the solution. A command prompt will launch and give you the path to the local host, which is typically http://localhost:8777. The cmd prompt needs to remain open while you are previewing files.
2. Open a Chrome (sorry, I've not had any luck with IE) and navigate to http://localhost:8777. This is a default page that uses toc.txt to give you links to the files listed in the TOC. Scroll down and click on one of the links in the list to see the local preview.


**If it works, do a happy little dance!**
