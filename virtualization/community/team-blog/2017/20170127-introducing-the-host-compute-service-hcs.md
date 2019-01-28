---
layout:     post
title:      "Introducing the Host Compute Service (HCS)"
date:       2017-01-27 00:21:18
categories: containers
---
### Summary

This post introduces a low level container management API in Hyper-V called the Host Compute Service (HCS). It tells the story behind its creation, and links to a few open source projects that make it easier to use.

### Motivation and Creation

Building a great management API for Docker was important for Windows Server Containers. There's a ton of really cool low-level technical work that went into enabling containers on Windows, and we needed to make sure they were easy to use. This seems very simple, but figuring out the right approach was surprisingly tricky. Our first thought was to extend our existing management technologies (e.g. WMI, PowerShell) to containers. After investigating, we concluded that they weren’t optimal for Docker, and started looking at other options. Next, we considered mirroring the way Linux exposes containerization primitives (e.g. control groups, namespaces, etc.). Under this model, we could have exposed each underlying feature independently, and asked Docker to call into them individually. However, there were a few questions about that approach that caused us to consider alternatives: 

  1. The low level APIs were evolving (and improving) rapidly. Docker (and others) wanted those improvements, but also needed a stable API to build upon. Could we stabilize the underlying features fast enough to meet our release goals?
  2. The low level APIs were interesting and useful because they made containers possible. Would anyone actually want to call them independently?

After a bit of thinking, we decided to go with a third option. We created a new management service called the Host Compute Service (HCS), which acts as a layer of abstraction above the low level functionality. The HCS was a stable API Docker could build upon, and it was also easier to use. Making a Windows Server Container with the HCS is just a single API call. Making a Hyper-V Container instead just means adding a flag when calling into the API. Figuring out how those calls translate into actual low-level implementation is something the Hyper-V team has already figured out. 

[![linux-arch](https://msdnshared.blob.core.windows.net/media/2017/01/Linux-Arch-1024x698.png)](https://msdnshared.blob.core.windows.net/media/2017/01/Linux-Arch.png) [![windows-arch](https://msdnshared.blob.core.windows.net/media/2017/01/Windows-Arch2-1024x718.png)](https://msdnshared.blob.core.windows.net/media/2017/01/Windows-Arch2.png)

### Getting Started with the HCS

If you think this is nifty, and would like to play around with the HCS, here's some infomation to help you get started. Instead of calling our C API directly, I recommend using one the friendly wrappers we've built around the HCS. These wrappers make it easy to call the HCS from higher level languages, and are released open source on GitHub. They're also super handy if you want to figure out how to use the C API. We've released two wrappers thus far. One is written in Go (and used by Docker), and the other is written in C#. You can find the wrappers here: 

  * <https://github.com/microsoft/dotnet-computevirtualization>
  * <https://github.com/microsoft/hcsshim>

If you want to use the HCS (either directly or via a wrapper), or you want to make a Rust/Haskell/InsertYourLanguage wrapper around the HCS, please drop a comment below. I'd love to chat. For a deeper look at this topic, I recommend taking a look at John Stark’s DockerCon presentation: <https://www.youtube.com/watch?v=85nCF5S8Qok> John Slack Program Manager Hyper-V Team
