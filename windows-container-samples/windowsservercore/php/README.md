This dockerfile will install PHP, version 5.6.11, in a Windows Server Core based container.

It will use the microsoft/iis image as a base.

You will need to have a "sources" folder in the same directory as the dockerfile.

This folder will need to include a folder called "php-5.6.11-nts-Win32-VC11-x86" which will have those sources, and cvredist_x86.
