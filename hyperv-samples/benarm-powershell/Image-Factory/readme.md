# Hyper-V Image Factory #

This is a PowerShell script that creates and maintains a set of Windows virtual hard disks for me that are always up to date.  

# What is this all about? #

For more information - read here: http://blogs.msdn.com/b/virtual_pc_guy/archive/2015/06/16/script-image-factory-for-hyper-v.aspx


# Change Log #

8/21/15 -
* Changes from Grant Emsley
  * Support configuration of static IP address on the factory VM
  * Verify product keys have been set

8/17/15 -
* Changes from Grant Emsley
  * Optimize final VHD file
  * Optionally clean the windows component store to save disk space

8/16/15 -

* Changes from Grant Emsley
  * Support for configuring Factory VM RAM and VLAN
  * Better error handling on missing folders / dependancies
  * Better handling of missing ISO / WIM files

8/1/15 -

* Tested with Windows 10 (yay!)
* Moved variables into separate file to make it easier to accept changes - and to stop people from giving me their product keys
* Added code to check for and create directories that are missing

7/29/15 -

* Accepted changes from Christoph Petersen that: 
   * Cleaned up files inside the virtual machine at the end
   * Added support for an external sysprep process
   * Made the code a lot prettier to look at (thanks Christoph!)

# To do #

This is the list of things currently in my "to do" list.  Feel free to tackle any of them yourself and request a pull.

* MD5 summing for virtual hard drives in the share folder
* Make variables for the build and share directories - so they do not have to be under the working directory
* Add support for Windows 7 / 2008 R2 guest operating systems
* Update this readme to have more information from the blog post - and vice versa
