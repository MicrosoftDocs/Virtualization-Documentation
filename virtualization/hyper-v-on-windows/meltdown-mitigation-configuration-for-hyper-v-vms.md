# Exposing firmware updates to guest virtual machines

Additional configuration may be required to enable protections for virtual machines on Hyper-V hosts. By default, virtual machines with a VM version below 8.0 will not have access to the updated firmware capabilities. You can gather the version of your VMs by running the following PowerShell command: 

``` PowerShell
Get-VM * | Format-Table Name, Version  
```

To give virtual machines with a VM version below 8.0 access to the updated firmware capabilities, either:

1. Update the VM version by following the steps on [this page](https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/deploy/upgrade-virtual-machine-version-in-hyper-v-on-windows-or-windows-server).
2. Modify the `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization` registry key to the minimum VM version (format "Major.Minor") that needs access to the updated firmware capabilities.  For example, to expose the firmware capabilities to version 5.0 virtual machines, run the following command: 

  ```
  reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization" /v MinVmVersionForCpuBasedMitigations /t REG_SZ /d "5.0" /f
  ```

To take advantage of the updated firmware capabilities within the guest virtual machine, you must still update the guest operating system.

Warning: enabling these protections will prevent migration of VMs from patched Hyper-V hosts to unpatched Hyper-V hosts.



