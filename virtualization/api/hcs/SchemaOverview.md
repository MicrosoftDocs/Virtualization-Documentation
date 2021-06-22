---
title: Schema Overview
description: Schema Overview
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# Schema Overview

## Schema-based Configuration

Configuration documents based on well-defined schemas is an established industry standard in the virtualization space. Most virtualization solutions, such as Docker and Kubernetes, provide APIs based on configuration documents. Several industry initiatives, with the participation of Microsoft, drive an ecosystem for defining and validating these schemas, such as [OpenAPI](https://www.openapis.org/). These initiatives also drive the standardization of specific schema definitions for the schemas used for containers, such as [Open Container Initiative (OCI)](https://opencontainers.org/).

The language used for authoring configuration documents is JSON, which you use in combination with:

* Schema definitions that define an object model for the document.
* Validation of whether a JSON document conforms to a schema.
* Automated conversion of JSON documents to and from native representations of these schemas in the programming languages used by the callers of the APIs.

Frequently used schema definitions are [OpenAPI](https://www.openapis.org/) and [JSON Schema](http://json-schema.org/), which lets you specify the detailed definitions of the properties in a document, for example:

* The valid set of values for a property, such as 0-100 for a property representing a percentage.
* The definition of enumerations, which are represented as a set of valid strings for a property.
* A regular expression for the expected format of a string.


## Schema Reference

For the detail description of JSON Schema used in HCS APIs, please see [Schema References](./SchemaReference.md).

## Schema Samples

For JSON Schema file used to generate other languages and the example of generated Schema code, please see [Schema Sample](./SchemaSample.md). 