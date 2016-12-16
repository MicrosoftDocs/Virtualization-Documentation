# escape=`
FROM microsoft/windowsservercore

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Install Windows SDK 10 - avoids installing 'Windows IP Over USB-x86_en-us.msi'
# Workaround for https://github.com/PowerShell/PowerShell/issues/2571
RUN (New-Object System.Net.WebClient).DownloadFile('http://download.microsoft.com/download/6/3/B/63BADCE0-F2E6-44BD-B2F9-60F5F073038E/standalonesdk/SDKSETUP.EXE', 'sdksetup.exe') ; `
    $ExpectedSHA='23B87A221804A8DB90BC4AF7F974FD5601969D40936F856942AAC5C9DA295C04'; `
    $ActualSHA=$(Get-FileHash -Path C:\sdksetup.exe -Algorithm SHA256).Hash; `
    If ($ExpectedSHA -ne $ActualSHA) { Throw 'sdksetup.exe hash does not match the expected value!' } ; `
    New-Item -Path c:\sdksetup -Type Directory -Force|out-null ; `
    $procArgs=@('-norestart','-quiet','-ceip off','-Log c:\sdksetup\sdksetup.exe.log','-Layout c:\sdksetup', `
        '-Features OptionId.NetFxSoftwareDevelopmentKit OptionId.WindowsSoftwareDevelopmentKit'); `
    Write-Host 'Executing download of Win10SDK files (approximately 400mb)...'; `
    $proc=Start-Process -FilePath c:\sdksetup.exe -ArgumentList $procArgs -wait -PassThru ; `
    if ($proc.ExitCode -eq 0) { `
        Write-Host 'Win10SDK download complete.' `
    } else { `
        get-content -Path c:\sdksetup\sdksetup.exe.log -ea Ignore| write-output ; `
        throw ('C:\SdkSetup.exe returned '+$proc.ExitCode) `
    } `
    'Windows SDK EULA-x86_en-us.msi','Windows SDK-x86_en-us.msi','Windows SDK Desktop Headers Libs Metadata-x86_en-us.msi', `
    'Windows SDK Desktop Tools-x86_en-us.msi','Windows SDK Modern Versioned Developer Tools-x86_en-us.msi', `
    'Windows SDK for Windows Store Apps-x86_en-us.msi','Windows SDK for Windows Store Apps Headers Libs-x86_en-us.msi', `
    'Windows SDK for Windows Store Apps Contracts-x86_en-us.msi','Windows SDK for Windows Store Apps Tools-x86_en-us.msi', `
    'Windows SDK Redistributables-x86_en-us.msi','Windows SDK DirectX x64 Remote-x64_en-us.msi', `
    'Windows SDK DirectX x86 Remote-x86_en-us.msi','Windows SDK for Windows Store Apps DirectX x64 Remote-x64_en-us.msi', `
    'Windows SDK for Windows Store Apps DirectX x86 Remote-x86_en-us.msi','Universal CRT Redistributable-x86_en-us.msi', `
    'Universal CRT Headers Libraries and Sources-x86_en-us.msi','Universal CRT Tools x64-x64_en-us.msi', `
    'Universal CRT Tools x86-x86_en-us.msi','WinRT Intellisense UAP - en-us-x86_en-us.msi', `
    'WinRT Intellisense UAP - Other Languages-x86_en-us.msi','WinRT Intellisense Desktop - en-us-x86_en-us.msi', `
    'WinRT Intellisense Desktop - Other Languages-x86_en-us.msi','WinRT Intellisense IoT - en-us-x86_en-us.msi', `
    'WinRT Intellisense IoT - Other Languages-x86_en-us.msi','WinRT Intellisense PPI - en-us-x86_en-us.msi', `
    'WinRT Intellisense PPI - Other Languages-x86_en-us.msi','MobileIntellisense-x86.msi', `
    'WinAppDeploy-x86_en-us.msi','WindowsPhoneSdk-Desktop.msi' | ForEach-Object -Process { `
        Write-Host ('Executing MsiExec.exe with parameters:'); `
        $MsiArgs=@(('/i '+[char]0x0022+'c:\sdksetup\Installers\'+$_+[char]0x0022), `
            ('/log '+[char]0x0022+'c:\sdksetup\'+$_+'.log'+[char]0x0022),'/qn','/norestart'); `
        Write-Output $MsiArgs; `
        $proc=Start-Process msiexec.exe -ArgumentList $MsiArgs -Wait -PassThru -Verbose; `
        if ($proc.ExitCode -eq 0) { Write-Host '...Success!' `
        } else { `
            get-content -Path ('c:\sdksetup\'+$_+'.log') -ea Ignore | write-output; `
            throw ('...Failure!  '+$_+' returned '+$proc.ExitCode) `
        } `
     }; `
    $win10sdkBinPath = ${env:ProgramFiles(x86)}+'\Windows Kits\10\bin\x64'; `
    if (Test-Path -Path $win10sdkBinPath\mc.exe) { `
      Write-Host 'Win10 SDK 10.1.14393.0 Installation Complete.' ; `
      Remove-Item c:\sdksetup.exe -Force; `
      Remove-Item c:\sdksetup\ -Recurse -Force; `
    } else { Throw 'Installation failed!  See logs under c:\sdksetup\' };

RUN (New-Object System.Net.WebClient).DownloadFile('https://msdnshared.blob.core.windows.net/media/2016/04/NanoServerApiScan.zip', 'NanoServerApiScan.zip') ; `
    Expand-Archive NanoServerApiScan.zip -DestinationPath C:\tool ; `
    Remove-Item NanoServerApiScan.zip

COPY tmp/Forwarders /tool

RUN mkdir C:\scan
WORKDIR /scan

CMD ["C:\\tool\\NanoServerApiScan.exe", "/BinaryPath:C:\\scan", "/WindowsKitsPath:\"C:\\Program Files (x86)\\Windows Kits\""]
