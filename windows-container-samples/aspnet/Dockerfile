FROM microsoft/windowsservercore

#Globally install DNVM in program data.
ADD globalinstall.ps1 /Windows/Temp/globalinstall.ps1
RUN powershell -executionpolicy unrestricted C:\Windows\Temp\globalinstall.ps1

#Install DNVM globally on the machine and set it as persistent. This modifies the user path to have DNX on it.
#if the user trying to run DNX is not the same as the installing user then the path to the DNX will need to be specified.
RUN DNVM install 1.0.0-rc1-final -global -persistent
