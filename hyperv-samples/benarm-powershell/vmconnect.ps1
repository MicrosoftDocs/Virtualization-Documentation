function Start-VMConnect 
   {

   [CmdletBinding()]
   param
      (
      # CMDLet takes a single parameter of VMNames.  
      # Can be single or plural, can come from the pipeline.

      [Parameter(Mandatory=$True,ValueFromPipeline=$True)]$VMnames
      )

   begin 
      {
      # Path to the binary for FreeRDP
    
      $FreeRDPPath = "C:\FreeRDP\wfreerdp.exe"
      }

   process 
      {
      foreach ($VMname in $VMnames) 
         {
         if ($pscmdlet.ShouldProcess($VMname)) 
            {
            # Get the ID of the virtual machine
            # If a VM object has been provided - grab the ID directly
            # Otherwise, try and get the VM object and get the ID from there

            if ($VMname.GetType().name -eq "VirtualMachine")
               {$VMID = $VMname.ID}
            else
               {$VMID = (get-vm $VMname | Select -first 1).ID}
         
            # Start FreeRDP
            start-process $FreeRDPPath -ArgumentList "/v:localhost:2179 /vmconnect:$($VMID)"
            }
         }
      }

   end {}
   }
