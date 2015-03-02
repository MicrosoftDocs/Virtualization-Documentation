# Hyper-V REST API #

## Goal ##

The goal of the Hyper-V REST API can be stated simply:

	Deliver an easy experience for building on top of Hyper-V
	
While it is a simple statement - it is an important one to understand.  Delivering an easy development experience has many benefits - including:
- Increased quality and reliability of solutions built on top of Hyper-V
- Increased number of solutions built on top of Hyper-V

## Target Audiences ##

There are multiple target audiences for the REST API

### Detailed Fabric Controllers ###

Developers of detailed fabric controllers require that Hyper-V be as "basic" as possible.  They expect to tightly control the environment Hyper-V runs in and to control Hyper-V itself.  For these users, we must ensure that we do not require them to utilize higher level constructs in the Hyper-V mangement language.  They should always be able to go "straight to the source" and talk to Hyper-V at a basic level.

### Purpose Built Fabric Controllers ###

These developers want to build a fabric experience that has specific and unique differentiators.  Hyper-V should provide the right high level concepts that they are not required to impliment everything themselves, and are able to focus on adding value where they are different.

### Small Projects / Individual Developers ###

An individual developer with a laptop and an idea should find it easy to do what they want with Hyper-V.

## Philosophy ##