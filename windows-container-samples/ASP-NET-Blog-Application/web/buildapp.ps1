# Remove existing default web site files
remove-item C:\inetpub\wwwroot\iisstart.*

# Ensure write permissions over web app project files
icacls C:\inetpub\wwwroot\blogengine /grant Everyone:F /t /q

# Import necessary IIS modules then set app project folder as web application
Import-Module IISAdministration
Import-Module WebAdministration
New-Item 'IIS:\Sites\Default Web Site\BlogEngine' -Type Application -PhysicalPath 'C:\inetpub\wwwroot\blogengine'
