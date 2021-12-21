# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://www.ruby-lang.org/en/about/license.txt

FROM mcr.microsoft.com/windows/servercore:ltsc2022

LABEL Description="Ruby Programming Language for Windows" Vendor="Ruby" Version="3.0.3-1-x64"

RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	Invoke-WebRequest -Method Get -Uri https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.3-1/rubyinstaller-3.0.3-1-x64.exe -OutFile c:\rubyinstaller-3.0.3-1-x64.exe ; \
	Start-Process c:\rubyinstaller-3.0.3-1-x64.exe -ArgumentList '/verysilent' -Wait ; \
	Remove-Item c:\rubyinstaller-3.0.3-1-x64.exe -Force

WORKDIR /Ruby30-x64/bin

CMD ["C:\Ruby30-x64\bin\ruby.exe --version"]
