FROM microsoft/windowsservercore

# BlogEngine.NET dependencies
RUN dism.exe /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN powershell add-windowsfeature web-asp-net45 

# # Download and extract BlogEngine.NET project files
RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
	Invoke-WebRequest -Method Get -Uri https://blogengine.codeplex.com/downloads/get/1566660 -OutFile c:\BlogEngineNETSrc.zip ; \
	Expand-Archive -Path c:\BlogEngineNETSrc.zip -DestinationPath c:\inetpub\wwwroot\blogengine ; \
	Remove-Item c:\BlogEngineNETSrc.zip -Force

# Configure Web App
COPY buildapp.ps1 C:/
RUN powershell.exe C:\buildapp.ps1

# Overwrite Web.config file so that web service points to db service
COPY Web.config C:/inetpub/wwwroot/blogengine

