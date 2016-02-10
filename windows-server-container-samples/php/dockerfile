FROM microsoft/iis
ADD sources/php-5.6.11-nts-Win32-VC11-x86 /php
ADD sources/php.ini /php/php.ini
ADD sources/vcredist_x86.exe /build/vcredist_x86.exe
RUN start /w C:\build\vcredist_x86.exe /q /norestart & del C:\build\vcredist_x86.exe 
RUN powershell.exe -executionpolicy bypass "Add-WindowsFeature Web-CGI" 
RUN %windir%\system32\inetsrv\appcmd set config /section:system.webServer/fastCGI /+[fullPath='c:\PHP\php-cgi.exe'] 
RUN %windir%\system32\inetsrv\appcmd set config /section:system.webServer/handlers /+[name='PHP_via_FastCGI',path='*.php',verb='*',modules='FastCgiModule',scriptProcessor='c:\PHP\php-cgi.exe',resourceType='Either'] 
