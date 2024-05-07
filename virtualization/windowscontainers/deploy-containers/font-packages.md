---
title: Add optional font packages to Windows containers
description: Learn how to add optional font packages to Windows container images
author: vrapolinario
ms.author: viniap
ms.date: 05/07/2024
ms.topic: how-to
---

# Add optional font packages to Windows containers

In an effort to improve overall performance of Windows containers, we removed many components of the Windows base container images, including components such as fonts – which in most cases are not relevant. However, some scenarios might need these fonts back for applications to properly work.

## Preparing your environment

When we removed the fonts from the Server Core base container image, we also removed the feature that installs new fonts. As you build your container image, you will need to incorporate the steps below to add the necessary feature back to Windows containers. First, you’ll need an up-to-date Windows Server 2019 or 2022 host or VM as a container host. Putting removed features back requires up-to-date media.

> [!NOTE]
> There are a few ways to acquire up-to-date install media, but the simplest is just to take a Windows Server 2019 or 2022 VM and let Windows Update bring it up to date.
> You will also need an ISO of the original Windows Server 2019 or 2022 RTM media. This can be acquired via a [Visual Studio Subscription](https://my.visualstudio.com/Download) or [Volume License Service Center](https://www.microsoft.com/licensing/servicecenter/).

To prepare your environment, you need a [properly configured](quick-start/set-up-environment.md) Windows container host and share the %windir%\WinSxS directory. documentation page. You’ll also need to share the %windir%\WinSxS directory. For this example, we created a local user with a randomly-generated password:

For Command Prompt:

```dos
net user ShareUser <password> /ADD
net share WinSxS=%windir%\WinSxS /grant:ShareUser,READ
```

For PowerShell:

```powershell
net user ShareUser ‘<password>’ /ADD
net share WinSxS=${env:windir}\WinSxS /grant:ShareUser,READ
```

Next, you will need to mount the RTM media.

For Command Prompt:

```dos
set imagePath=<path to RTM ISO>
powershell Mount-DiskImage -ImagePath %imagePath%
set driveLetter=<drive letter of the mounted ISO>
set repairMountDir=%SystemDrive%\repair
mkdir repairMountDir
dism /mount-image /imagefile:"%driveLetter%\sources\install.wim" /index:1 /mountdir: %repairMountDir%
net share RTM=%repairMountDir% /grant:ShareUser,READ
```

For PowerShell:

```powershell
$imagePath = <path to RTM ISO>
Mount-DiskImage -ImagePath $imagePath
# Find the drive letter of the mounted ISO
$driveLetter = <drive letter of mounted ISO>
$repairMountDir = "${env:systemdrive}\repair"
mkdir $repairMountDir
dism /mount-image /imagefile:"$driveLetter\sources\install.wim" /index:1 /mountdir: $repairMountDir
net share RTM=$repairMountDir /grant:ShareUser,READ
```

> [!NOTE]
> Ensure that image index 1 is specified when mounting the RTM media.

Next, create a file called InstallFonts.cmd and add the following content to it:

```dos
REM Connect to the WinSxS share on the container host
for /f "tokens=3 delims=: " %%g in ('netsh interface ip show address ^| findstr /c:"Default Gateway"') do set GATEWAY=%%g
net use o: \\%GATEWAY%\WinSxS /user:ShareUser %SHARE_PW%
net use r: \\%GATEWAY%\RTM /user:ShareUser %SHARE_PW%if errorlevel 1 goto :eof
 
dism /online /enable-feature /featurename:ServerCoreFonts-NonCritical-Fonts-MinConsoleFonts /Source:O:\ /Source:R:\ /LimitAccess
dism /online /enable-feature /featurename:ServerCoreFonts-NonCritical-Fonts-Support /Source:O:\ /Source:R:\ /LimitAccess
dism /online /enable-feature /featurename:ServerCoreFonts-NonCritical-Fonts-BitmapFonts /Source:O:\ /Source:R:\ /LimitAccess
dism /online /enable-feature /featurename:ServerCoreFonts-NonCritical-Fonts-TrueType /Source:O:\ /Source:R:\ /LimitAccess
dism /online /enable-feature /featurename:ServerCoreFonts-NonCritical-Fonts-UAPFonts /Source:O:\ /Source:R:\ /LimitAccess
```

Now you can add the context to your dockerfile. Here’s an example:

```dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2022
ARG SHARE_PW=
WORKDIR /install
COPY InstallFonts.cmd .
RUN InstallFonts.cmd
```

With a dockerfile in place, you can build and tag your container image using:

```dos
docker build -t <newname:tag> --build-arg SHARE_PW=<password> .
```

You will end up with the SHARE_PW in the build trace, but if you set it up as a randomly-generated string for each build, you’re not leaking a real secret. Furthermore, once the build is complete you can clean up the share and user with by using:

```dos
net share WinSxS /delete
net user ShareUser /delete
```

## Running the workload

Due to a limitation in how Server Core containers handle fonts, you do need to specifically tell Windows about the newly available fonts in the container. A PowerShell script must be run after the container is started and prior to running your workload.  We suggest calling this LoadFonts.ps1:

```powershell
$fontCSharpCode = @'
using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Runtime.InteropServices;
namespace FontResource
{
    public class AddRemoveFonts
    {
        [DllImport("gdi32.dll")]
        static extern int AddFontResource(string lpFilename);
        public static int AddFont(string fontFilePath) {
            try 
            {
                return AddFontResource(fontFilePath);
            }
            catch
            {
                return 0;
            }
        }
    }
}
'@
 
Add-Type $fontCSharpCode
 
foreach($font in $(gci C:\Windows\Fonts))
{
 
        Write-Output "Loading $($font.FullName)"
        [FontResource.AddRemoveFonts]::AddFont($font.FullName) | Out-Null
 
}
```

Microsoft hopes to remove this limitation in a future version of Windows, but the script is required for current releases of Windows Server 2019 and 2022. Once you have built the container as described above and run this script inside the container, all of the fonts present on Windows Server Core will be available to your containerized workload.

## Issues when adding fonts?

If you have issues when enabling fonts on Server Core container images, let us know in the issues section of our [GitHub repo](https://github.com/microsoft/Windows-Containers/).
