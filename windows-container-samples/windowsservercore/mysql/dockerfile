# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: http://www.mysql.com/about/legal/licensing/oem/

FROM windowsservercore

LABEL Description="MySql" Vendor="Oracle" Version="5.6.29"

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	Invoke-WebRequest -Method Get -Uri https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.29-winx64.zip -OutFile c:\mysql.zip ; \
	Expand-Archive -Path c:\mysql.zip -DestinationPath c:\ ; \
	Remove-Item c:\mysql.zip -Force

RUN SETX /M Path %path%;C:\mysql-5.6.29-winx64\bin

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	mysqld.exe --install ; \
	Start-Service mysql ; \
	Stop-Service mysql ; \
	Start-Service mysql

RUN mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION;"

CMD [ "ping localhost -t" ]
