FROM windowsservercore
LABEL Description="Windows Server Core with .NET 3.5" Vendor="Microsoft" Version="10.0.10586"
ADD source /build
RUN DISM /Online /Add-Package /PackagePath:C:\build\microsoft-windows-netfx3-ondemand-package.cab & del C:\build\microsoft-windows-netfx3-ondemand-package.cab
