function Start-VMConnect 
{
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    Param
    (
        # CMDLet takes a single parameter of VMNames.  
        # Can be single or plural, can come from the pipeline.

        [Parameter(Mandatory = $True,
                   ValueFromPipeline = $True
        )]
        [string[]]$VMnames
    )

    Begin
    {
        # Path to the binary for FreeRDP
        $FreeRDPPath = "C:\FreeRDP\wfreerdp.exe"
    }

    Process 
    {
        foreach ($VMname in $VMnames) 
        {
            if ($PSCmdlet.ShouldProcess($VMname)) 
            {
                # Get the ID of the virtual machine
                # If a VM object has been provided - grab the ID directly
                # Otherwise, try and get the VM object and get the ID from there

                if ($VMname.GetType().Name -eq "VirtualMachine")
                {
                    $VMID = $VMname.ID
                }
                else
                {
                    $VMID = (Get-VM -Name $VMname | Select-Object -First 1).ID
                }
         
                # Start FreeRDP
                Start-Process $FreeRDPPath -ArgumentList "/v:localhost:2179 /vmconnect:$($VMID)"
            }
         }
      }

   End {}
}