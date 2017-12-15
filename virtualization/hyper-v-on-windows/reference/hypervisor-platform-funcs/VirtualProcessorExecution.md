# Virtual Processor Execution
**Note: These APIs are not yet publically available and will be included in a future Windows release.  Subject to change.**

The virtual processors of a VM are executed using the new integrated scheduler of the hypervisor. To run a virtual processor, a thread in the process of the virtualization stack issues a blocking call to execute the virtual processor in the hypervisor, the call returns because of an operation of the virtual processor that requires handling in the virtualization stack or because of a request by the virtualization stack.  

A thread that handles a virtual processor executes the following basic operations:

 
1.  Create the virtual processor in the partition.
2. Setup the state of the virtual processor, which includes injecting pending interrupts and events into the processor. 
3. Run the virtual processor. 
4. Upon return from running the virtual processor, query the state of the processor and handle the operation that caused the processor to stop running. 
5. If the virtual processor is still active, go back to Step 2 to continue to run the processor. 
6. Delete the virtual processor in the partition.  

The state of the virtual processor includes the hardware registers and any interrupts the virtualization stack wants to inject into the virtual processor.