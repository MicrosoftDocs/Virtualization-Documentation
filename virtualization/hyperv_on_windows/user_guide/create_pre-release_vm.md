# Try pre-release features for Hyper-V

> This is preliminary content and subject to change.  
  Pre-release virtual machines are intended for development or test environments only as they are not supported by Microsoft.

Get early access to pre-release features for Hyper-V on Windows Server 2016 Technical Preview to try out in your development or test environments. You can be the first to see the latest Hyper-V features and help shape the product by providing early feedback.

The virtual machines you create as pre-release have no build-to-build compatibility or future support.  Don't use them in a production environment.

Here are some more reasons why these are for non-production environments only:

* There is no forward compatibility for pre-release virtual machines. You can't upgrade these virtual machines to a new configuration version. 
* Pre-release virtual machines don't have a consistent definition between builds. If you update the host operating system, existing pre-release virtual machines may be incompatible with the host. These virtual machines may not start, or may initially appear to work but later run into significant compatibility issues.
* If you import a pre-release virtual machine to a host with a different build, the results are unpredictable. You can move a pre-release virtual machine to another host. But this scenario is only expected to work if both hosts are running the same build. 

## Create a pre-release virtual machine

You can create a pre-release virtual machine on Hyper-V hosts that run Windows Server 2016 Technical Preview.

1. On the Windows desktop, click the Start button and type any part of the name **Windows PowerShell**.
2. Right-click **Windows PowerShell** and select **Run as Administrator**.
3. Use the [New-VM](https://technet.microsoft.com/library/hh848537.aspx) cmdlet with the -Prerelease flag to create the pre-release virtual machine. Run the following command where VM Name is the name of the virtual machine that you want to create.

``` PowerShell
New-VM -Name <VM Name> –Prerelease 
```
