Sample Script: Log collection for Hyper-V
================================================================================

This script can be used to enable/disable event channels related to Hyper-V and create a consolidated evtx file from these channels.

Installing the module
---------------------
To download and install the module on your local system, you can use an administrative PowerShell:

```powershell
# Download the current module from GitHub

Invoke-WebRequest "https://github.com/MicrosoftDocs/Virtualization-Documentation/raw/live/hyperv-tools/HyperVLogs/HyperVLogs.psm1" -OutFile "HyperVLogs.psm1"

# Import the module
Import-Module .\HyperVLogs.psm1
```

Usage 
-----

When you would like to analyze an issue with a virtual machine or debug the behavior of a Hyper-V host, you can use the `HyperVLogs.psm1` PowerShell module to help.

To collect events from the broadest set of event channels, please run the following commands after importing the module:

```powershell
# Enable the Hyper-V related event channels and  remember 
# the start time to reduce number of events collected
Enable-EventChannels -HyperVChannels All
$startTime = Get-Date
```

Then, reproduce the issue, and finally coalesce the events from the event channels into a single .evtx file:

```powershell
# Write the events that happened after start time to a single file
Save-EventChannels -HyperVChannels All -StartTime $startTime

# Diable analytical and operational event channels
Disable-EventChannels -HyperVChannels All
```
