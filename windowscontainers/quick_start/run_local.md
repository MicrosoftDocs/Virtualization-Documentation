ms.ContentId: 9dc57a6a-7104-4721-ba5c-3e246ee17f75 
title: Running Containers Locally

# Setting up Argons on your local machine #

These instructions were created for the 2/6/2015 review.
 
1. Install the latest build -- VHD available from `\\winbuilds\release\FBL_KPG_CORE_XENON_LITE\<<build_number>>\amd64fre\vhd\vhd_server_serverdatacenter_en-us`
2. Create a VM with this VHD
3. When the VM comes up install the “Windows Containers” feature from roles and features
4. Reboot
5. Install the siloservice:
	
	`SiloService –install`

6. Now start a container via the following command line:

	`Siloclient –start test1 –def \windows\system32\containers\cmdserver.def –server`

7. Then follow [these instructions](..\reference\networking.md) to set up your network.

8. You can now try to TS into the container

