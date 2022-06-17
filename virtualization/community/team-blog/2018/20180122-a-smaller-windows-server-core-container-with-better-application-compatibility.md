---
title: Windows Server Insider Preview Build 17074
description: Learn more about new container building blocks available in Windows.
keywords: windows server, azure, virtualization, blog
author: scooley
ms.author: scooley
ms.date: 01/22/2018
ms.topic: article
ms.prod: windows-containers
---

# Windows Server Insider Preview Build 17074

In [Windows Server Insider Preview Build 17074](https://blogs.windows.com/windowsexperience/2018/01/16/announcing-windows-server-insider-preview-build-17074/#9HZu5dBRKoVzcYoe.97) released on Tuesday Jan 16, 2018, there are some exciting improvements to Windows Server containers that we’d like to share with you. We’d love for you to test out the build, especially the [Windows Server Core container image](https://hub.docker.com/_/microsoft-windows-servercore-insider), and give us feedback! **Windows Server Core Container Base Image Size Reduced to 1.58GB!** You told us that the size of the Server Core container image affects your deployment times, takes too long to pull down and takes up too much space on your laptops and servers alike. In our first Semi-Annual Channel release, Windows Server, version 1709, we made some great progress reducing the size by 60% and your excitement was noted. We’ve continued to actively look for additional space savings while balancing application compatibility. It’s not easy but we are committed. There are two main directions we looked at: **1)** **Architecture optimization to reduce duplicate payloads** **** We are always looking for way to optimize our architecture. In Windows Server, version 1709 along with the substantial reduction in Server Core container image, we also made some substantial reductions in the Nano Server container image (dropping it below 100MB). In doing that work we identified that some of the same architecture could be leveraged with Server Core container. In partnership with other teams in Windows, we were able to implement changes in our build process to take advantage of those improvements. The great part about this work is that you should not notice any differences in application compatibility or experiences other than a nice reduction in size and some performance improvements. **2)** **Removing unused optional components** We looked at all the various roles, features and optional components available in Server Core and broke them down into a few buckets in terms of usage: frequently in containers, rarely in containers, those that we don’t believe are being used and those that are not supported in containers. We leveraged several data sources to help categorize this list. First, those of you that have telemetry enabled, thank you! That anonymized data is invaluable to these exercises. Second was publicly available dockerfiles/images and of course feedback from GitHub issues and forums. Third, the roles or features that are not even supported in containers were easy to make a call and remove. Lastly, we also removed roles and features we do not see evidence of customers using. We could do more in this space in the future but really need your feedback (telemetry is also very much appreciated) to help guide what can be removed or separated. So, here are the numbers on Windows Server Core container size if you are curious:

  * 1.58GB, download size, 30% reduction from Windows Server, version 1709
  * 3.61GB, on disk size, 20% reduction from Windows Server, version 1709

**MSMQ now installs in a Windows Server Core container** MSMQ has been one of the top asks we heard from you, and ranks very high on Windows Server User Voice [here](https://windowsserver.uservoice.com/forums/304624-containers/suggestions/15719031-create-base-container-image-with-msmq-server). In this release, we were able to partner with our Kernel team and make the change which was not trivial. We are happy to announce now it installs! And passed our in-house Application Compatibility test. Woohoo! However, there are many different use cases and ways customers have used MSMQ. So please do try it out and let us know if it indeed works for you. **A Few Other Key App Compatibility Bug Fixes:**

  * We fixed the issue reported on GitHub that services running in containers do not receive **shutdown notification**.

[https://github.com/moby/moby/issues/25982](https://na01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fmoby%2Fmoby%2Fissues%2F25982&data=02%7C01%7Crgowdy%40microsoft.com%7Cff2586e1a4c94ec5eda508d49ba39552%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C636304574268363175&sdata=%2B0pGMelWbvRhRxtE%2FvGuNna5HAAtHogCGHuQae2dqgc%3D&reserved=0)

  * We fixed this issue reported on GitHub and User Voice related to **BitLocker and** **FDVDenyWriteAccess** policy: Users were not able to run basic Docker commands like Docker Pull.

<https://github.com/Microsoft/Virtualization-Documentation/issues/530> <https://github.com/Microsoft/Virtualization-Documentation/issues/355> <https://windowsserver.uservoice.com/forums/304624-containers/suggestions/18544312-fix-docker-load-pull-build-issue-when-bitlocker-is>

  * We fixed a few issues reported on GitHub related to **mounting directories** between hosts and containers.

<https://github.com/moby/moby/issues/30556> <https://github.com/git-for-windows/git/issues/1007> We are so excited and proud of what we have done so far to listen to your voice, continuously optimize Server Core container size and performance, and fix top application compatibility issues to make your Windows Container experience better and meet your business needs better. We love hearing how you are using Windows containers, and we know there is still plenty of opportunities ahead of us to make them even faster and better. Fun journey ahead of us! Thank you. Weijuan
