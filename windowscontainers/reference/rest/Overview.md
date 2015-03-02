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

Developers of detailed fabric controllers require that Hyper-V be as "basic" as possible. 
They expect to tightly control the environment Hyper-V runs in and to control Hyper-V itself. 
For these users, we must ensure that we do not require them to utilize higher level constructs in the Hyper-V mangement language.
They should always be able to go "straight to the source" and talk to Hyper-V at a basic level.

### Purpose Built Fabric Controllers ###

These developers want to build a fabric experience that has specific and unique differentiators.  Hyper-V should provide the right high level concepts that they are not required to impliment everything themselves, and are able to focus on adding value where they are different.

### Small Projects / Individual Developers ###

An individual developer with a laptop and an idea should find it easy to do what they want with Hyper-V.

## Philosophy ##

The following points are key to the philosophy of the Hyper-V REST API

### Human readable ###

It should be easy for a developer who is otherwise unfamiliar with Hyper-V to read and understand code that interacts with Hyper-V.
Developers who are familiar with Hyper-V should not have to expend mental effort in reading and parsing the code that they have written that interacts with Hyper-V.

This means we will prefer:
- Simple English over jargon
- Descriptive enumerations over booleans / codes
- Minimal syntax

### No unecessary content needed ###

Developers should only have to provide the information they care about.  Defaults should be defined and populated for all operations - so that people can focus solely on the problem they want to solve / solution they want to enable.

# Detailed Topics #

	Hopefully, Sarah will teach me how to do a TOC...

Templates:
Objects:
Reference material: