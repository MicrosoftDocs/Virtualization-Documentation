# Hyper-V REST API #

## Goal ##

The goal of the Hyper-V REST API can be stated simply:

	Deliver an easy experience for building on top of Hyper-V
	
While it is a simple statement - it is an important one to understand.  Delivering an easy development experience has many benefits - including:
- Increased quality and reliability of solutions built on top of Hyper-V
- Increased number of solutions built on top of Hyper-V

## Target Audience ##

There are multiple target audiences for the REST API

### Detailed Fabric Controllers ###

Developers of detailed fabric controllers require that Hyper-V be as "basic" as possible.  They expect to tightly control the environment Hyper-V runs in and to control Hyper-V itself.  For these users, we must ensure that we do not require them to utilize higher level constructs in the Hyper-V mangement language.  They should always be able to go "straight to the source" and talk to Hyper-V at a basic level.


## Philosophy ##