ms.ContentId: 805cdd3f-b286-428c-a1c8-f72f999ec28a
title: Working With Packages

# Packaging Windows Containers #

There are six major components to our packaging and package management subsystem:
1.	Runtime layout or what containers actually run from (i.e. exploded packages with reparse points etc…)
2.	Transport layout or the raw payload in a format that can be transported between machines (i.e. files, registry hives etc…)
3.	A private API that converts between the transport and runtime layout
4.	Container management APIs for repository operations that ultimately call the private API, i.e. import/export, delete, create sandbox etc…
5.	Management services that users interact with to import/export packages, create containers etc… – we expect multiple of these (inbox and Docker at a minimum)
6.	An actual package that can be shared between systems, containing the raw payload in transport layout along with metadata such as dependencies – we expect multiple of these (inbox and Docker at a minimum)

![](Media\container_packaging.png) 
![](Media\container_package_management.png)


Decisions:

- The Windows packaging technology is AppX thus our decision is to utilize that format for our container packages.  John’s team will own this work in coordination with the AppX team.
- Windows will define and own both the transport friendly layout and the runtime repository layout, including the packages contained within.  Erick’s team will own this.
- Windows will provide, as part of our container management API surface, APIs for importing transport layout payloads into runtime repositories and vice/verse as well as other pertinent runtime repository operations.  John’s team will own this.