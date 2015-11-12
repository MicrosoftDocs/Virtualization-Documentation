# Variables
$filedate = get-date
$computer = gc env:computername
$metricsData = get-vm | measure-vm
$tableColor = "WhiteSmoke"
$errorColor = "Red"
$warningColor = "Yellow"
$FromEmail = "email@email.org"
$ToEmail = "email@email.org"

# Establish Connection to SMTP server
$smtpServer = "smtp.yourISP.com"
$smtpCreds = new-object Net.NetworkCredential("yourUsername", "YourPassword")
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$smtp.UseDefaultCredentials = $false
$smtp.Credentials = $smtpCreds

# HTML Style Definition
$message = "<!DOCTYPE html  PUBLIC`"-//W3C//DTD XHTML 1.0 Strict//EN`"  `"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd`">"
$message = "<html xmlns=`"http://www.w3.org/1999/xhtml`"><body>"
$message = "<style>"
$message = $message + "TABLE{border-width:2px;border-style: solid;border-color: #C0C0C0 ;border-collapse: collapse;width: 100%}"
$message = $message + "TH{border-width: 2px;padding: 0px;border-style: solid;border-color: #C0C0C0 ;text-align: left}"
$message = $message + "TD{border-width: 2px;padding: 0px;border-style: solid;border-color: #C0C0C0 ;text-align: left}"
$message = $message + "TD{border-width: 2px;padding: 0px;border-style: solid;border-color: #C0C0C0 ;text-align: left}"
$message = $message + "H1{font-family:Calibri;}"
$message = $message + "H2{font-family:Calibri;}"
$message = $message + "Body{font-family:Calibri;}"
$message = $message + "</style>"

# Title
$message = $message + "<h2>Data for Hyper-V Server '$($computer)' : $($filedate)</h2>"

# EventLog
$message = $message + "<style>TH{background-color:$($errorColor)}TR{background-color:$($tableColor)}</style>"
$message = $message + "<B>Parent EventLog</B> <br> <br>"
$message = $message + "Errors: <br>" + ((Get-EventLog system -after (get-date).AddHours(-24) -entryType Error) | `
                                                           Select-Object @{Expression={$_.InstanceID};Label="ID"},  `
                                                                         @{Expression={$_.Source};Label="Source"}, `
                                                                         @{Expression={$_.Message};Label="Message"} `
                                                                         | ConvertTo-HTML -Fragment) `
                                                                         + " <br>"

$message = $message + "<style>TH{background-color:$($warningColor)}TR{background-color:$($tableColor)}</style>"
$message = $message + "Warnings: <br>" + ((Get-EventLog system -after (get-date).AddHours(-24) -entryType Warning) | `
                                                           Select-Object @{Expression={$_.InstanceID};Label="ID"},  `
                                                                         @{Expression={$_.Source};Label="Source"}, `
                                                                         @{Expression={$_.Message};Label="Message"} `
                                                                         | ConvertTo-HTML -Fragment) `
                                                                         + " <br>"

# Hyper-V EventLog
$message = $message + "<style>TH{background-color:$($errorColor)}TR{background-color:$($tableColor)}</style>"
$message = $message + "<B>Hyper-V EventLog</B> <br> <br>"
$message = $message + "Errors: <br>" + ((Get-WinEvent -FilterHashTable @{LogName ="Microsoft-Windows-Hyper-V*"; StartTime = (Get-Date).AddDays(-1); Level = 2}) | `
                                                           Select-Object @{Expression={$_.InstanceID};Label="ID"},  `
                                                                         @{Expression={$_.Source};Label="Source"}, `
                                                                         @{Expression={$_.Message};Label="Message"} `
                                                                         | ConvertTo-HTML -Fragment) `
                                                                         + " <br>"

$message = $message + "<style>TH{background-color:$($warningColor)}TR{background-color:$($tableColor)}</style>"
$message = $message + "Warnings: <br>" + ((Get-WinEvent -FilterHashTable @{LogName ="Microsoft-Windows-Hyper-V*"; StartTime = (Get-Date).AddDays(-1); Level = 3}) | `
                                                           Select-Object @{Expression={$_.InstanceID};Label="ID"},  `
                                                                         @{Expression={$_.Source};Label="Source"}, `
                                                                         @{Expression={$_.Message};Label="Message"} `
                                                                         | ConvertTo-HTML -Fragment) `
                                                                         + " <br>"

# VM Health
$message = $message + "<style>TH{background-color:Indigo}TR{background-color:$($errorColor)}</style>"
$message = $message + "<B>Virtual Machine Health</B> <br> <br>"
$message = $message + "Virtual Machine Health: <br>" + ((Get-VM | `
                                                          Select-Object @{Expression={$_.Name};Label="Name"}, `
                                                                        @{Expression={$_.State};Label="State"}, `
                                                                        @{Expression={$_.Status};Label="Operational Status"}, `
                                                                        @{Expression={$_.UpTime};Label="Up Time"} `
                                                                        | ConvertTo-HTML -Fragment) `
                                                                        | %{if($_.Contains("<td>Operating normally</td>")){$_.Replace("<tr><td>", "<tr style=`"background-color:$($warningColor)`"><td>")}else{$_}} `
                                                                        | %{if($_.Contains("<td>Running</td><td>Operating normally</td>")){$_.Replace("<tr style=`"background-color:$($warningColor)`"><td>", "<tr style=`"background-color:$($tableColor)`"><td>")}else{$_}}) `
                                                                        + " <br>"
# VM Replication Health
$message = $message + "<style>TH{background-color:Indigo}TR{background-color:$($errorColor)}</style>"
$message = $message + "<B>Virtual Machine Replication Health</B> <br> <br>"
$message = $message + "Virtual Machine Replication Health: <br>" + ((Get-VM | `
                                                          Select-Object @{Expression={$_.Name};Label="Name"}, `
                                                                        @{Expression={$_.ReplicationState};Label="State"}, `
                                                                        @{Expression={$_.ReplicationHealth};Label="Health"}, `
                                                                        @{Expression={$_.ReplicationMode};Label="Mode"} `
                                                                        | ConvertTo-HTML -Fragment) `
                                                                        | %{if($_.Contains("<td>Replicating</td><td>Normal</td>")){$_.Replace("<tr><td>", "<tr style=`"background-color:$($tableColor)`"><td>")}else{$_}}) `
                                                                        + " <br>"

# Storage Health
$message = $message + "<style>TH{background-color:DarkGreen}TR{background-color:$($errorColor)}</style>"
$message = $message + "<B>Storage Health</B> <br> <br>"
$message = $message + "Physical Disk Health: <br>" + ((Get-PhysicalDisk | `
                                                           Select-Object @{Expression={$_.FriendlyName};Label="Physical Disk Name"},  `
                                                                         @{Expression={$_.DeviceID};Label="Device ID"}, `
                                                                         @{Expression={$_.OperationalStatus};Label="Operational Status"}, `
                                                                         @{Expression={$_.HealthStatus};Label="Health Status"}, `
                                                                         @{Expression={"{0:N2}" -f ($_.Size / 1073741824)};Label="Size (GB)"} `
                                                                         | ConvertTo-HTML -Fragment) `
                                                                         | %{if($_.Contains("<td>OK</td><td>Healthy</td>")){$_.Replace("<tr><td>", "<tr style=`"background-color:$($tableColor)`"><td>")}else{$_}}) `
                                                                         + " <br>"
$message = $message + "Storage Pool Health: <br>" + ((Get-StoragePool | `
                                                      where-object {($_.FriendlyName -ne "Primordial")} | `
                                                          Select-Object @{Expression={$_.FriendlyName};Label="Storage Pool Name"}, `
                                                                        @{Expression={$_.OperationalStatus};Label="Operational Status"}, `
                                                                        @{Expression={$_.HealthStatus};Label="Health Status"} `
                                                                        | ConvertTo-HTML -Fragment) `
                                                                        | %{if($_.Contains("<td>OK</td><td>Healthy</td>")){$_.Replace("<tr><td>", "<tr style=`"background-color:$($tableColor)`"><td>")}else{$_}}) `
                                                                        + " <br>"
$message = $message + "Virtual Disk Health: <br>" + ((Get-VirtualDisk | `
                                                          Select-Object @{Expression={$_.FriendlyName};Label="Virtual Disk Name"}, `
                                                                        @{Expression={$_.OperationalStatus};Label="Operational Status"}, `
                                                                        @{Expression={$_.HealthStatus};Label="Health Status"} `
                                                                        | ConvertTo-HTML -Fragment) `
                                                                        | %{if($_.Contains("<td>OK</td><td>Healthy</td>")){$_.Replace("<tr><td>", "<tr style=`"background-color:$($tableColor)`"><td>")}else{$_}}) `
                                                                        + " <br>"

# VM Metrics
$message = $message + "<style>TH{background-color:blue}TR{background-color:$($tableColor)}</style>"
$message = $message + "<B>Virtual Machine Utilization Report</B> <br> <br> "

$message = $message +  "CPU utilization data: <br>" + ($metricsData | `
                                                           select-object @{Expression={$_.VMName};Label="Virtual Machine"}, `
                                                                         @{Expression={$_.AvgCPU};Label="Average CPU Utilization (MHz)"} `
                                                                         | ConvertTo-HTML -Fragment) `
                                                                         +" <br>"
$message = $message + "Memory utilization data: <br>" + ($metricsData | `
                                                             select-object @{Expression={$_.VMName};Label="Virtual Machine"}, `
                                                                           @{Expression={$_.AvgRAM};Label="Average Memory (MB)"}, `
                                                                           @{Expression={$_.MinRAM};Label="Minimum Memory (MB)"}, `
                                                                           @{Expression={$_.MaxRAM};Label="Maximum Memory (MB)"} `
                                                                           | ConvertTo-HTML -Fragment) `
                                                                           +" <br>"
$message = $message + "Network utilization data: <br>" + ($metricsData | `
                                                             select-object @{Expression={$_.VMName};Label="Virtual Machine"}, `
                                                                           @{Expression={"{0:N2}" -f (($_.NetworkMeteredTrafficReport | where-object {($_.Direction -eq "Inbound")}`
                                                                              | measure-object TotalTraffic -sum).sum / 1024)};Label="Inbound Network Traffic (GB)"}, `
                                                                           @{Expression={"{0:N2}" -f (($_.NetworkMeteredTrafficReport | where-object {($_.Direction -eq "Outbound")} `
                                                                              | measure-object TotalTraffic -sum).sum / 1024)};Label="Outbound Network Traffic (GB)"} `
                                                                           | ConvertTo-HTML -Fragment) `
                                                                           +" <br>"
$message = $message + "Disk utilization data: <br>" + ($metricsData | `
                                                           select-object @{Expression={$_.VMName};Label="Virtual Machine"}, `
                                                                         @{Expression={"{0:N2}" -f ($_.TotalDisk / 1024)};Label="Disk Space Used (GB)"} `
                                                                         | ConvertTo-HTML -Fragment) `
                                                                         +" <br>"
$message = $message + "Metering Duration data: <br>" + ($metricsData | `
                                                            select-object @{Expression={$_.VMName};Label="Virtual Machine"}, `
                                                                          @{Expression={$_.MeteringDuration};Label="Metering data duration"} `
                                                                          | ConvertTo-HTML -Fragment) `
                                                                          +" <br>"

# Reset metrics
get-vm | Reset-VMResourceMetering
get-vm | Enable-VMResourceMetering

$message = $message + "</body></html>"

$email = new-object Net.Mail.MailMessage
$email.Subject = "Hyper-V Server Report: $($filedate)"
$email.From = new-object Net.Mail.MailAddress($FromEmail)
$email.IsBodyHtml = $true
$email.Body =  $message
$email.To.Add($ToEmail)

# Send Email
$smtp.Send($email)
