FROM microsoft/windowsservercore

MAINTAINER SHI HAO WANG

WORKDIR /

ENV serverfarms "[]"

#Install IIS Web-Server
RUN powershell -Command Add-WindowsFeature Web-Server

RUN @powershell Install-WindowsFeature Web-Mgmt-Service
RUN @powershell Install-WindowsFeature WAS-Config-APIs
RUN @powershell Install-WindowsFeature NET-Framework-45-ASPNET

RUN reg add HKLM\SOFTWARE\Microsoft\InetStp /v MajorVersion /t REG_DWORD /d 0x9 /f

RUN net stop was /y
#RUN net stop wmsvc /y

RUN @powershell wget http://download.microsoft.com/download/5/7/0/57065640-4665-4980-a2f1-4d5940b577b0/webfarm_v1.1_amd64_en_us.msi -OutFile webfarm_v1.1_amd64_en_us.msi 
RUN msiexec /i "webfarm_v1.1_amd64_en_us.msi" /q /log foo.log
RUN @powershell wget http://download.microsoft.com/download/3/4/1/3415F3F9-5698-44FE-A072-D4AF09728390/ExternalDiskCache_amd64_en-US.msi -OutFile ExternalDiskCache_amd64_en-US.msi
RUN msiexec /i "ExternalDiskCache_amd64_en-US.msi" /q /log foo.log
RUN @powershell wget http://download.microsoft.com/download/6/7/D/67D80164-7DD0-48AF-86E3-DE7A182D6815/rewrite_amd64_en-US.msi -OutFile rewrite_amd64_en-US.msi
RUN msiexec /i "rewrite_amd64_en-US.msi" /q /log foo.log
RUN @powershell wget http://download.microsoft.com/download/6/3/D/63D67918-483E-4507-939D-7F8C077F889E/requestRouter_x64.msi -OutFile requestRouter_x64.msi
RUN msiexec /i "requestRouter_x64.msi" /q /log foo.log

RUN reg add HKLM\SOFTWARE\Microsoft\InetStp /v MajorVersion /t REG_DWORD /d 0xa /f

RUN @powershell restart-service was -force
RUN @powershell restart-service wmsvc -force

ADD ./start.ps1 /

CMD powershell ./start.ps1 -serverfarms \"%serverfarms%\" -Verbose

# docker run -d -v C:/temp/:C:/temp/ -e serverfarms="[{'name':'Maxtest123','servers':[{'address':'172.21.116.32'}]}]" --link web1:web1 -p 80:80 knom/iis-arr

