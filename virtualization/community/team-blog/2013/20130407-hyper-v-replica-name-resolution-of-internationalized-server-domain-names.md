---
layout:     post
title:      "Hyper-V Replica - Name Resolution of Internationalized Server/Domain names"
date:       2013-04-07 23:05:00
categories: hvr
---
In a mixed language environment where the server name or domain name contains international characters, you might encounter an error at the time of enabling replication. The event viewer messages will tell you that “Hyper-V failed to enable replication for virtual machine” and “The server name or address could not be resolved (0x00002EE7)”. The problem could seem a little perplexing because pinging the same FQDN might work just fine. The problem occurs because of Hyper-V Replica’s dependency on HTTP.

To work around the issue, an exception rule needs to be added to the primary server’s name resolution policies. Follow these steps to create the rule:

  1. Open the Local Group Policy Editor (Gpedit.msc).
  2. Under **Local Computer Policy** , expand **Computer Configuration** , **Windows Settings** , and then click **Name Resolution Policy**.
  3. In the **Create Rules** area, click **FQDN** , and then enter the Replica server FQDN that was failing.
  4. On the **Encoding** tab, select the **Enable Encoding** check box, and make sure that **UTF-8 with Mapping** is selected.
  5. Click **Create**. 

> The rule appears in the **Name Resolution Policy Table**.

  6. Click **Apply** , and then close the Local Group Policy Editor.
  7. From an elevated command prompt, run the command **gpupdate** to update the policy. 



[![Local Policy Group Editor 2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/0677.LocalPolicyGroupEditor2_thumb_32AE6ECF.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5516.LocalPolicyGroupEditor2_6C9B210A.png)
