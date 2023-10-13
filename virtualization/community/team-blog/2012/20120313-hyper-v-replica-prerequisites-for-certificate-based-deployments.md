---
title:      "Hyper-V Replica - Prerequisites for certificate based deployments"
author: sethmanheim
ms.author: mabrigg
description: Hyper-V Replica - Prerequisites for certificate based deployments
ms.date: 03/13/2012
date:       2012-03-13 03:06:00
categories: hvr
---
# Hyper-V Replica - Prerequisites for certificate based deployments

An often asked question from early HVR deployments has been about the product’s certificate requirements. This post captures the pre-requisites for enabling replication using certificate based authentication.

HVR uses machine level mutual authentication, which requires you to install the certificates in the Personal certificate store of the local computer.

## View/Import Certificates

To view or to import the certificates ****

   i.  Launch **mmc** from the command prompt.

   ii. Click **File** -> **Add/Remove Snap-in...** and choose **Certificates** from the available list of snap-ins.

   iii. Choose ' **Computer Account** ' in the Certificate snap-in pop up


     iv.   Open the **Certificates** store under the **Personal** store.


## **Primary Server Certificate** **Requirements**

To setup a replication relationship, the certificate in the **primary server** must meet the following conditions:

  * **Enhanced Key Usage** must support both Client and Server authentication 



  * Set the Subject field or the Subject Alternative Name using **one** of the following methods:
    * Set the Subject field to the primary server name (e.g.: _primary1.contoso.com_ ).  If the primary server is part of a cluster, ensure that the subject field is set to the FQDN of the HVR Broker (install this certificate on all the nodes of the cluster). 



(or)
* Subject field can contain a wildcard (e.g.: _*.department.contoso.com_ ).



 (or)
* For a SAN certificate, set the Subject Alternative Name’s DNS Name to the primary server name (e.g.: _primary1.contoso.com_ ). If the primary server is part of a cluster, the Subject Alternative Name of the certificate should contain the FQDN of the HVR Broker (install this certificate on all the nodes of the cluster).



 

  * Ensure that the valid X.509v3 certificate is not revoked.
  * Check if the root of this certificate is present in the “Trusted Root Certification Authorities” of the replica server certificate store.



**** 

**Replica Server Certificate** **Requirements**

To enable a server to receive replication traffic, the certificate in the replica server must meet the following conditions

  * **Enhanced Key Usage**  must support both Client and Server authentication 
  * Set the Subject field or the Subject Alternative Name using **one** of the following methods:
    * For a SAN certificate, set the Subject Alternative Name’s DNS Name to the replica server name (e.g.: _replica1.contoso.com_ ). If the replica server is part of cluster, the Subject Alternative Name of the certificate must contain the replica server name ***and***  FQDN of the HVR Broker (install this certificate on all the nodes of the cluster.)



(or)
* Set the Subject field to the replica server name (e.g.: _replica1.contoso.com_ ). If the replica server is part of cluster, ensure that a certificate with the subject field set to the FQDN of the HVR Broker is installed on  **all** the nodes of the cluster.



(or)
 * Subject field can contain a wildcard (e.g.: _*.department.contoso.com_ )



 

  * Ensure that the valid X.509v3 certificate is not revoked.
  * Check if the root of this certificate is present in the “Trusted Root Certification Authorities” of the replica server certificate store.



## **Validate using certutil**

After the certificate is installed, run the following command from the command prompt on both the primary and replica server:

_certutil –store my _

At least one of the certificates in your output should resemble the following sample output such that  **the Encryption test (not just Signature)  **has passed **.**

_==============================Certificate 1 =====================================================_

 

_Serial Number: 6c028cf0d47c0db8490dbd18191eaeb1_

_Issuer: CN=corp-DC1-CA, DC=corp, DC=contoso, DC=com_

_NotBefore: 2/7/2012 9:39 PM_

_NotAfter: 12/31/2039 3:59 PM_

_Subject: CN=CLIENT1.corp.contoso.com_

_Non-root Certificate_

_Cert Hash(sha1): ba 20 b0 1a c1 dd d8 5c c9 4a 73 0f 61 e2 f0 ca a5 8d ed 6d_

_Key Container = 6199522e-cbe4-4a69-b27d-edcbdf06911e_

_Unique container name: b2c457fabbb5acb7fbac1c3585f8c079_2176a3a0-cd09-417b-87d_ _7-826e858f5461_

_Provider = Microsoft RSA SChannel Cryptographic Provider_

_Encryption test passed_

_================================================================================================_

 

For a sample HVR deployment scenario using makecert certificate, see Appendix C of the UTG which is available [here](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831759(v=ws.11)).  

In the next few weeks , we will be posting an end to end workflow for enabling replication using certificates.

\- Hyper-V Replication Team
