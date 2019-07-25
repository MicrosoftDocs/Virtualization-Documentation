---
title:      "Migrating local VM owner certificates for VMs with vTPM"
date:       2017-12-14 06:27:22
categories: guarded-fabric
---
Whenever I want to replace or reinstall a system which is used to run [virtual machines with a virtual trusted platform module](https://docs.microsoft.com/windows-server/virtualization/hyper-v/learn-more/generation-2-virtual-machine-security-settings-for-hyper-v#encryption-support-settings-in-hyper-v-manager) (vTPM), I've been facing a challenge: For hosts that are not part of a [guarded fabric](https://docs.microsoft.com/windows-server/virtualization/guarded-fabric-shielded-vm/guarded-fabric-and-shielded-vms), the new system does need to be authorized to run the VM. Some time ago, I wrote a blog post focused on [running VMs with a vTPM on additional hosts](https://blogs.technet.microsoft.com/virtualization/2016/10/25/allowing-an-additional-host-to-run-a-vm-with-virtual-tpm/), but the approach highlighted there does not solve everything when the original host is decommissioned. The VMs can be started on the new host, but without the original owner certificates, you cannot change the list of allowed guardians anymore. This blog post shows a way to export the information needed from the source host and import it on a destination host. Please note that this technique only works for _local_ mode and not for a host that is part of a guarded fabric. You can check whether your host runs in local mode by running `Get-HgsClientConfiguration`. The property `Mode` should list `Local` as a value. 

### Exporting the default owner from the source host

The following script exports the necessary information of the default owner ("`UntrustedGuardian`") on a host that is configured using local mode. When running the script on the source host, two certificates are exported: a signing certificate and an encryption certificate. 

### Importing the UntrustedGuardian on the new host

On the destination host, the following snippet creates a new guardian using the certificates that have been exported in the previous step.  Please note that importing the "UntrustedGuardian" on the new host has to be done before creating new VMs with a vTPM on this host -- otherwise a new guardian with the same name will already be present and the creation with the PowerShell snippet above will fail. With these two steps, you should be able to migrate all the necessary bits to keep your VMs with vTPM running in your dev/test environment. This approach can also be used to back up your owner certificates, depending on how these certificates have been created. 
