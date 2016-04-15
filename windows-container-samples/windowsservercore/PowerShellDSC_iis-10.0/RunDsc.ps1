# Lifted from http://blogs.technet.com/b/privatecloud/archive/2013/08/30/introducing-powershell-desired-state-configuration-dsc.aspx

Configuration ContosoWebsite 
{ 
  param ($MachineName)

  Node $MachineName 
  { 
    #Install the IIS Role 
    WindowsFeature IIS 
    { 
      Ensure = "Present" 
      Name = "Web-Server" 
    } 
  } 
} 

ContosoWebsite -MachineName localhost
Start-DscConfiguration -Path .\ContosoWebsite -Wait -Verbose
