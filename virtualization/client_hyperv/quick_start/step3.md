ms.ContentId: C5DAC361-D339-4C3B-90E4-2C133BE6812E
title: Step 3: Create a virtual switch

# Create a virtual switch #

The virtual switch is how you create a network connection for your virtual machine to use to connect to the internet, the host or to other virtual machines.

For this example, we are going to create an External switch, which will let virtual machine access the internet using the host machines network adapter. We will also set the switch to allow the host to share this network adapter. This will make it so that both the virtual machines and the host can use the same physical NIC.
![](\media\virtual_switch_manager.png)
1. In Hyper-V manager, click on the **Action** menu > **Virtual Switch Manager**.
2. In the left pane, select **New virtual network switch**.
![](\media\new_switch.png)
3. Select **External** and click **Create Virtual Switch**. 
![](\media\share_nic.png)
4. Under **Name**, type **External**.
5. Under **External network**, make sure the correct NIC is selected. If you have more than one, you might want to make a switch for each NIC.
6. Make sure that **Allow management operating system to share this network adapter** is selected and then click **OK**. 
![](\media\network_warning.png)
7. You will get a message warning you that your network might disconnect while the virtual switch is created. Just click **Yes**.

# Next step: #
[Step 4: Configure your host](step4.md)