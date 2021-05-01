YAML Specification
==================

The YAML Data Language Specification

# Overview

[YAML](https://en.wikipedia.org/wiki/YAML) (YAML Ain't Markup Language) is a
versioned language for data.
The current versions of the language are 1.0, 1.2 and 1.2.

This repository is where the YAML language is further developed and the next
versions are defined.

This repository contains the source code and build system for the [published
YAML specifications](https://yaml.org/spec/) (versions 1.0, 1.1 and 1.2).

# Layout

YAML 1.2 was defined in a single document that blended together various aspects
including:

* Prosaic explanation of the YAML language
* Formal grammar of the YAML syntax
* Details of the YAML processing stack
* Various YAML schema definitions

The next version(s) of the language will not attempt to fit everything into a
single document.
It will have separate specification pieces for the parallel concerns of
defining YAML.
The pieces will rigorously cross-reference each other to create a robust
definition of the language.

## Directories

Each part of the specification is kept in its own top level directory:

* `1.2`

  The 1.2 and older spec files and build system.

* `spec`

  The prosaic explanation of what YAML is and how it works.

* `doc`

  Documentation manuals about the YAML language.

* `grammar`

  The formal syntax grammar for YAML.

* `test`

  Every aspect of the specified YAML language has tests supporting it.
  The tests are the final source of truth for a given aspect.

* `rfc`

  A collection of documents each describing a change to the YAML language.

* `story`

  A collection of documents each describing a use case for YAML.
  These stories will guide changes (RFCs) to the language.

* `feature`

  The individual aspects of the YAML syntax are called *features*.
  Each feature is described in detail here.

* `schema`

  In YAML, *schema* refers to the external definitions of a YAML stream's
  semantics and how it should be processed.
  YAML specifies a schema language for these definitions.

* `dom`

  The YAML DOM is the theoretical graph structure composed by a YAML loader.
  Many aspects of how YAML works are defined at this level.

* `path`

  The next versions of YAML will have features that support referencing beyond
  explicit anchor/alias.
  YAML specifies a path syntax.

* `stdlib`

  YAML tags are references to typed data transformation functions.
  YAML defines a standard library of common functions.

* `www`

  The current state of the development spec is published as
  <https://spec.yaml.io>.


