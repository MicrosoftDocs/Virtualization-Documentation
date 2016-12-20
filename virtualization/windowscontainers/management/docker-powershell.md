---
title: PowerShell for Docker
description: How to manage Docker containers using PowerShell
keywords: docker, containers, powershell
author: PatrickLang
ms.date: 12/19/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 4a0e907d-0d07-42f8-8203-2593391071da
---

### PowerShell For Docker

Through our conversations with you, our users though forums, over Twitter, in GitHub, and even in person one question has come up more than any other – why can’t I see Docker containers from PowerShell? 

As we’ve discussed the pro’s, con’s and various options with you we’ve come to the conclusion that the container PowerShell module needed an update… So we are deprecating the container PowerShell module that has been shipping in the preview builds of Windows Server 2016 and have begun work replacing it with a new PowerShell module for Docker.  While the development of this new module is already underway but with a different approach than in the past – we’re doing the work in the open.  Our goal for this module is that it will be a community collaboration that results in a great PowerShell experience for containers though the Docker engine.  This new module builds directly on top of the Docker Engine’s REST interface enabling user choice between the Docker CLI, PowerShell or both.

Building a great PowerShell module is no easy task, between getting all of the code right and striking the right balance of objects and parameters sets and cmdlet names are all super important.  So as we are embarking on this new module we are looking to you – our end users and the vast PowerShell and Docker communities to help shape this module.  What parameter sets are important to you?  Should we have an equivalent to “docker run” or should you pipe new-container to start-container – what would you want…  To learn more about this module and participate in the development please head over to our GitHub page (https://github.com/Microsoft/Docker-PowerShell/) and join in.

As the development proceeds and we get to a solid alpha quality module we will be posting it on the PowerShell Gallery and updating this page with instructions on its usage.
