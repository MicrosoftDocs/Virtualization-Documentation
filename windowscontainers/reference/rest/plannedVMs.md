There are times when a virtual machine configuration needs to be "altered" in order to be moved.

When:
- Live migrating a virtual machine
- Importing a virtual machine
- Registering a virtual machine
- Replicating a virtual machine
- Restoring a virtual machine backup

You might find an incompatible configuration detail.

This may be non-fatal, like it is looking for a network with a different name.  
This may be possibly fatal, like it is referencing a missing disk or package.  Regardless, the design we choose needs to consider the following:
- We cannot tell if any configuration issue is fatal or not.
- The user should never be blocked by a configuration issue
	+ Which is to say, they should be given the option to correct the configuration, even if it is destructive
- The user should always be informed of the current "wrong" setting
	- e.g. This virtual machine is looking for a virtual network called "Foo"

Hyper-V handles this today with the planned virtual machine infrastructure

LXD handles this by having the caller define a container configuration that the container is then "created into".  For instanace - in the case of a live migration on LXD the caller:
1. Calls the source server and tells it to prepare the container for live migration
2. Calls the destination server and tells it to:
	1. Create a new blank container, including configuration
	2. Pull the content from the source server

Here is a snippet from the LXD spec to demonstrate this:

	/1.0/containers/Post
	{
    	'name': "my-new-container",                                                     # 64 chars max, ASCII, no slash, no colon and no comma
    	'architecture': "x86_64",
    	'hostname': "my-container",
    	'profiles': ["default"],                                                        # List of profiles
    	'ephemeral': True,                                                              # Whether to destroy the container on shutdown
    	'config': {'resources.cpus': "2"},                                              # Config override.
    	'source': {'type': "migration",                                                 # Can be: "image", "migration" or "none"
            	   'mode': "pull",                                                      # One of "pull" or "receive"
        	       'operation': "https://10.0.2.3:8443/1.0/operations/<UUID>",          # Full URL to the remote operation (pull mode only)
              	 'secret': "my-secret-string"},                                       # Secret to use to retrieve the container (pull mode only)
	}