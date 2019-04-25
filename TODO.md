# TODO

This file lists the things we'd like to get done.  Some of it is stuff we're working on and some of it is stuff anyone in the community could help with.

## Forever tasks

Things anyone can do across all docs:

* Copy editing - we *always* need folks to review spelling and grammar.
* Review code samples - while we always strive for code samples to be perfect and tested, sometimes they do break.
* Add README.md for all samples and tools with the following information:
  * Name
  * What does the script/tool do
  * Usage information

## Doc work in specific areas

### Container docs

#### Small

* Update all references to Hyper-V containers to be Hyper-V isolation (versus process isolation)

#### medium

* Add exact error messages to the known issues page for more searchable issues

#### large

* Get started guides for:
  * cri/containerd
  * runhcs
* build a table outlining tradeoffs between Hyper-V isolation and process isolation
* security deep dive for Hyper-V isolation

### Hyper-V docs

#### small

#### medium

#### large

* Update the [remote host management article](./virtualization/hyperv_on_windows/user_guide/remote_host_management.md).  It's the most viewed and least liked doc in this section.

### Community docs

## Doc structure and functionality

* Move Hyper-V server to virtualization docs
  *	Consolidate and cross ref where possible to Hyper-V for Win 10.
* Move blog to docs
  * Investigate making a template for a new docs in a file so when people go to add a new blog, it autopopulates the TOC + metadata and such.  Maybe a “create blog” button 😊.  I think this is the biggest barrier to blog in docs.
