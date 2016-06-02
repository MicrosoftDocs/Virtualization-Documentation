FROM microsoft/dotnet35

ENV SQL_EXPRESS_DOWNLOAD_URL "https://download.microsoft.com/download/1/5/6/156992E6-F7C7-4E55-833D-249BD2348138/ENU/x64/SQLEXPR_x64_ENU.exe"
ENV SQL_SERVER_SA_PASSWORD "Password1"

WORKDIR /

RUN powershell -Command (New-Object System.Net.WebClient).DownloadFile('%SQL_EXPRESS_DOWNLOAD_URL%', 'sqlexpress.exe') \
	&& start /wait .\sqlexpress.exe /qs /x:setup \
	&& .\setup\SETUP.EXE /q /ACTION=Install /INSTANCENAME=SQLEXPRESS /FEATURES=SQLEngine \
		/UPDATEENABLED=0 /SECURITYMODE=SQL /SAPWD=%SQL_SERVER_SA_PASSWORD% \
		/SQLSVCACCOUNT="NT AUTHORITY\System" /SQLSYSADMINACCOUNTS="BUILTIN\ADMINISTRATORS" \
		/TCPENABLED=1 /NPENABLED=0 /IAcceptSQLServerLicenseTerms \
	&& del sqlexpress.exe \
	&& rmdir .\setup /s /q \
	&& powershell -Command \
		stop-service MSSQL`$SQLEXPRESS ; \
		set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql12.SQLEXPRESS\mssqlserver\supersocketnetlib\tcp\ipall' -name tcpdynamicports -value '' ; \
		set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql12.SQLEXPRESS\mssqlserver\supersocketnetlib\tcp\ipall' -name tcpport -value 1433 ; \
		start-service MSSQL`$SQLEXPRESS

CMD powershell -Command while ($true) { Start-Sleep -Seconds 3600 }
EXPOSE 1433
