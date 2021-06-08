---
layout: default
---
# YAML Ain’t Markup Language (YAML™) Version 1.2

**3rd Edition, Patched at 2009-10-01**

* **Oren Ben-Kiki <[oren@ben-kiki.org](mailto:oren@ben-kiki.org)>**
* **Clark Evans <[cce@clarkevans.com](mailto:cce@clarkevans.com)>**
* **Ingy döt Net <[ingy@ingy.net](mailto:ingy@ingy.net)>**
{:.authorgroup}

**Latest (patched) version:**

* HTML: [http://yaml.org/spec/1.2/spec.html](/spec/1.2/spec.html)
* PDF: [http://yaml.org/spec/1.2/spec.pdf](/spec/1.2/spec.pdf)
* PS: [http://yaml.org/spec/1.2/spec.ps](/spec/1.2/spec.ps)
* Errata: [http://yaml.org/spec/1.2/errata.html](/spec/1.2/errata.html)
{:.releaseinfo}

**Previous (original) version:**
[http://yaml.org/spec/1.2/2009-07-21/spec.html](/spec/1.2/2009-07-21/spec.html)

Copyright © 2001-2009 Oren Ben-Kiki, Clark Evans, Ingy döt Net

This document may be freely copied, provided it is not modified.

**Status of this Document**

This document reflects the third version of YAML data serialization language.
The content of the specification was arrived at by consensus of its authors and
through user feedback on the
[yaml-core](http://lists.sourceforge.net/lists/listinfo/yaml-core) mailing list.
We encourage implementers to please update their software with support for this
version.

The primary objective of this revision is to bring YAML into compliance with
JSON as an official subset.
YAML 1.2 is compatible with 1.1 for most practical applications - this is a
minor revision.
An expected source of incompatibility with prior versions of YAML, especially
the syck implementation, is the change in implicit typing rules.
We have removed unique implicit typing rules and have updated these rules to
align them with JSON's productions.
In this version of YAML, boolean values may be serialized as "**`true`**" or
"**`false`**"; the empty scalar as "**`null`**".
Unquoted numeric values are a superset of JSON's numeric production.
Other changes in the specification were the removal of the Unicode line breaks
and production bug fixes.
We also define 3 built-in implicit typing rule sets: untyped, strict JSON, and
a more flexible YAML rule set that extends JSON typing.

The difference between late 1.0 drafts which syck 0.55 implements and the 1.1
revision of this specification is much more extensive.
We fixed usability issues with the tagging syntax.
In particular, the single exclamation was re-defined for private types and a
simple prefixing mechanism was introduced.
This revision also fixed many production edge cases and introduced a type
repository.
Therefore, there are several incompatibilities between syck and this revision
as well.

The list of known errors in this specification is available at
[http://yaml.org/spec/1.2/errata.html](/spec/1.2/errata.html).
Please report errors in this document to the yaml-core mailing list.
This revision contains fixes for all errors known as of 2009-10-01.

We wish to thank implementers who have tirelessly tracked earlier versions of
this specification, and our fabulous user community whose feedback has both
validated and clarified our direction.

**Abstract**

YAML™ (rhymes with "camel") is a human-friendly, cross language, Unicode based
data serialization language designed around the common native data types of
agile programming languages.
It is broadly useful for programming needs ranging from configuration files to
Internet messaging to object persistence to data auditing.
Together with the [Unicode standard for characters](http://www.unicode.org/),
this specification provides all the information necessary to understand YAML
Version 1.2 and to create programs that process YAML information.

----

**Contents**

* TOC
{:toc}

<div id="introduction" />
# Chapter 1. Introduction


"YAML Ain’t Markup Language" (abbreviated YAML) is a data serialization
language designed to be human-friendly and work well with modern programming
languages for common everyday tasks.
This specification is both an introduction to the YAML language and the
concepts supporting it, and also a complete specification of the information
needed to develop [applications](#processing-yaml-information) for processing YAML.

Open, interoperable and readily understandable tools have advanced computing
immensely.
YAML was designed from the start to be useful and friendly to people working
with data.
It uses Unicode [printable](#character-set) characters, ~~[some](#undefined)~~ of which provide structural
information and the rest containing the data itself.
YAML achieves a unique cleanness by minimizing the amount of structural
characters and allowing the data to show itself in a natural and meaningful way.
For example, [indentation](#indentation-spaces) may be used for structure, ~~[colons](#undefined)~~ separate
~~[key: value pairs](#undefined)~~, and ~~[dashes](#undefined)~~ are used to create "bullet" ~~[lists](#undefined)~~.

There are myriad flavors of ~~[data structures](#undefined)~~, but they can all be adequately
~~[represented](#undefined)~~ with three basic primitives: [mappings](#mapping) (hashes/dictionaries),
[sequences](#sequence) (arrays/lists) and ~~[scalars](#undefined)~~ (strings/numbers).
YAML leverages these primitives, and adds a simple typing system and ~~[aliasing](#undefined)~~
mechanism to form a complete language for ~~[serializing](#undefined)~~ any ~~[native data
structure](#undefined)~~.
While most programming languages can use YAML for data serialization, YAML
excels in working with those languages that are fundamentally built around the
three basic primitives.
These include the new wave of agile languages such as Perl, Python, PHP, Ruby,
and Javascript.

There are hundreds of different languages for programming, but only a handful
of languages for storing and transferring data.
Even though its potential is virtually boundless, YAML was specifically created
to work well for common use cases such as: configuration files, log files,
interprocess messaging, cross-language data sharing, object persistence, and
debugging of complex data structures.
When data is easy to view and understand, programming becomes a simpler task.

<div id="goals" />
## 1.1. Goals


The design goals for YAML are, in decreasing priority:

1. YAML is easily readable by humans.
1. YAML data is portable between programming languages.
1. YAML matches the ~~[native data structures](#undefined)~~ of agile languages.
1. YAML has a consistent model to support generic tools.
1. YAML supports one-pass processing.
1. YAML is expressive and extensible.
1. YAML is easy to implement and use.

<div id="prior-art" />
## 1.2. Prior Art


YAML’s initial direction was set by the data serialization and markup language
discussions among [SML-DEV members](http://www.docuverse.com/smldev/).
Later on, it directly incorporated experience from Ingy döt Net’s Perl module
[Data::Denter](http://search.cpan.org/dist/Data-Denter/).
Since then, YAML has matured through ideas and support from its user community.

YAML integrates and builds upon concepts described by
[C](http://cm.bell-labs.com/cm/cs/cbook/index.html),
[Java](http://java.sun.com/), [Perl](http://www.perl.org/),
[Python](http://www.python.org/), [Ruby](http://www.ruby-lang.org/),
[RFC0822](http://www.ietf.org/rfc/rfc0822.txt) (MAIL),
[RFC1866](http://www.ics.uci.edu/pub/ietf/html/rfc1866.txt) (HTML),
[RFC2045](http://www.ietf.org/rfc/rfc2045.txt) (MIME),
[RFC2396](http://www.ietf.org/rfc/rfc2396.txt) (URI),
[XML](http://www.w3.org/TR/REC-xml.html), [SAX](http://www.saxproject.org/),
[SOAP](http://www.w3.org/TR/SOAP), and [JSON](http://www.json.org/).

The syntax of YAML was motivated by Internet Mail (RFC0822) and remains
partially compatible with that standard.
Further, borrowing from MIME (RFC2045), YAML’s top-level production is a
[stream](#streams) of independent [documents](#document), ideal for message-based distributed
processing systems.

YAML’s [indentation](#indentation-spaces)\-based scoping is similar to Python’s (without the
ambiguities caused by ~~[tabs](#undefined)~~). ~~[Indented blocks](#undefined)~~ facilitate easy inspection of
the data’s structure.
YAML’s ~~[literal style](#undefined)~~ leverages this by enabling formatted text to be cleanly
mixed within an [indented](#indentation-spaces) structure without troublesome ~~[escaping](#undefined)~~.
YAML also allows the use of traditional ~~[indicator](#undefined)~~\-based scoping similar to
JSON’s and Perl’s.
Such ~~[flow content](#undefined)~~ can be freely nested inside ~~[indented blocks](#undefined)~~.

YAML’s ~~[double-quoted style](#undefined)~~ uses familiar C-style ~~[escape sequences](#undefined)~~.
This enables ASCII encoding of non-[printable](#character-set) or 8-bit (ISO 8859-1) characters
such as ~~["**`\x3B`**"](#undefined)~~.
Non-[printable](#character-set) 16-bit Unicode and 32-bit (ISO/IEC 10646) characters are
supported with ~~[escape sequences](#undefined)~~ such as ~~["**`\u003B`**"](#undefined)~~ and
~~["**`\U0000003B`**"](#undefined)~~.

Motivated by HTML’s end-of-line normalization, YAML’s ~~[line folding](#undefined)~~ employs an
intuitive method of handling [line breaks](#line-break-characters).
A single [line break](#line-break-characters) is ~~[folded](#undefined)~~ into a single [space](#white-space-characters), while ~~[empty lines](#undefined)~~
are interpreted as [line break](#line-break-characters) characters.
This technique allows for paragraphs to be word-wrapped without affecting the
~~[canonical form](#undefined)~~ of the [scalar content](#scalar).

YAML’s core type system is based on the requirements of agile languages such as
Perl, Python, and Ruby.
YAML directly supports both ~~[collections](#undefined)~~ ([mappings](#mapping), [sequences](#sequence)) and
~~[scalars](#undefined)~~.
Support for these common types enables programmers to use their language’s
~~[native data structures](#undefined)~~ for YAML manipulation, instead of requiring a special
document object model (DOM).

Like XML’s SOAP, YAML supports ~~[serializing](#undefined)~~ a graph of ~~[native data
structures](#undefined)~~ through an ~~[aliasing](#undefined)~~ mechanism.
Also like SOAP, YAML provides for [application](#processing-yaml-information)\-defined ~~[types](#undefined)~~.
This allows YAML to ~~[represent](#undefined)~~ rich data structures required for modern
distributed computing.
YAML provides globally unique ~~[type names](#undefined)~~ using a namespace mechanism inspired
by Java’s DNS-based package naming convention and XML’s URI-based namespaces.
In addition, YAML allows for private ~~[types](#undefined)~~ specific to a single
[application](#processing-yaml-information).

YAML was designed to support incremental interfaces that include both input
("**`getNextEvent()`**") and output ("**`sendNextEvent()`**") one-pass
interfaces.
Together, these enable YAML to support the processing of large [documents](#document)
(e.g. transaction logs) or continuous ~~[streams](#undefined)~~ (e.g. feeds from a production
machine).

<div id="relation-to-json" />
## 1.3. Relation to JSON


Both JSON and YAML aim to be human readable data interchange formats.
However, JSON and YAML have different priorities.
JSON’s foremost design goal is simplicity and universality.
Thus, JSON is trivial to generate and parse, at the cost of reduced human
readability.
It also uses a lowest common denominator information model, ensuring any JSON
data can be easily processed by every modern programming environment.

In contrast, YAML’s foremost design goals are human readability and support for
~~[serializing](#undefined)~~ arbitrary ~~[native data structures](#undefined)~~.
Thus, YAML allows for extremely readable files, but is more complex to generate
and parse.
In addition, YAML ventures beyond the lowest common denominator data types,
requiring more complex processing when crossing between different programming
environments.

YAML can therefore be viewed as a natural superset of JSON, offering improved
human readability and a more complete information model.
This is also the case in practice; every JSON file is also a valid YAML file.
This makes it easy to migrate from JSON to YAML if/when the additional features
are required.

JSON's [RFC4627](http://www.ietf.org/rfc/rfc4627.txt) requires that [mappings](#mapping)
~~[keys](#undefined)~~ merely "SHOULD" be [unique](#node-comparison), while YAML insists they "MUST" be.
Technically, YAML therefore complies with the JSON spec, choosing to treat
duplicates as an error.
In practice, since JSON is silent on the semantics of such duplicates, the only
portable JSON files are those with unique keys, which are therefore valid YAML
files.

It may be useful to define a intermediate format between YAML and JSON.
Such a format would be trivial to parse (but not very human readable), like JSON.
At the same time, it would allow for ~~[serializing](#undefined)~~ arbitrary ~~[native data
structures](#undefined)~~, like YAML.
Such a format might also serve as YAML’s "canonical format".
Defining such a "YSON" format (YSON is a Serialized Object Notation) can be
done either by enhancing the JSON specification or by restricting the YAML
specification.
Such a definition is beyond the scope of this specification.

<div id="relation-to-xml" />
## 1.4. Relation to XML


Newcomers to YAML often search for its correlation to the eXtensible Markup
Language (XML).
Although the two languages may actually compete in several application domains,
there is no direct correlation between them.

YAML is primarily a data serialization language.
XML was designed to be backwards compatible with the Standard Generalized
Markup Language (SGML), which was designed to support structured documentation.
XML therefore had many design constraints placed on it that YAML does not share.
XML is a pioneer in many domains, YAML is the result of lessons learned from
XML and other technologies.

It should be mentioned that there are ongoing efforts to define standard
XML/YAML mappings.
This generally requires that a subset of each language be used.
For more information on using both XML and YAML, please visit
[http://yaml.org/xml](/xml).

<div id="terminology" />
## 1.5. Terminology


This specification uses key words based on
[RFC2119](http://www.ietf.org/rfc/rfc2119.txt) to indicate requirement level.
In particular, the following words are used to describe the actions of a YAML
[processor](#processing-yaml-information):

##### May

> The word _may_, or the adjective _optional_, mean that conforming YAML
> ~~[processors](#undefined)~~ are permitted to, but _need not_ behave as described.

##### Should

> The word _should_, or the adjective _recommended_, mean that there could be
> reasons for a YAML [processor](#processing-yaml-information) to deviate from the behavior described, but that
> such deviation could hurt interoperability and should therefore be advertised
> with appropriate notice.

##### Must

> The word _must_, or the term _required_ or _shall_, mean that the behavior
> described is an absolute requirement of the specification.

The rest of this document is arranged as follows.
Chapter [2] provides a short preview of the main YAML features.
Chapter [3] describes the YAML information model, and the processes for
converting from and to this model and the YAML text format.
The bulk of the document, chapters [4] through [9], formally define this text
format.
Finally, chapter [10] recommends basic YAML schemas.

<div id="preview" />
# Chapter 2. Preview


This section provides a quick glimpse into the expressive power of YAML.
It is not expected that the first-time reader grok all of the examples.
Rather, these selections are used as motivation for the remainder of the
specification.

<div id="collections" />
## 2.1. Collections


YAML’s ~~[block collections](#undefined)~~ use [indentation](#indentation-spaces) for scope and begin each entry on
its own line. ~~[Block sequences](#undefined)~~ indicate each entry with a dash and space (
~~["**`-`** "](#undefined)~~). [Mappings](#mapping) use a colon and space (~~["**`:`** "](#undefined)~~) to mark each
~~[key: value pair](#undefined)~~. ~~[Comments](#undefined)~~ begin with an octothorpe (also called a "hash",
"sharp", "pound", or "number sign" - ~~["**`#`**"](#undefined)~~).

<div id="example-sequence-of-scalars" class="example">
**Example 2.1 Sequence of Scalars (ball players)**

<pre class="example">
- Mark McGwire
- Sammy Sosa
- Ken Griffey
</pre>

</div>

<div id="example-mapping-scalars-to-scalars" class="example">
**Example 2.2 Mapping Scalars to Scalars (player statistics)**

<pre class="example">
hr:  65    # Home runs
avg: 0.278 # Batting average
rbi: 147   # Runs Batted In
</pre>

</div>

<div id="example-mapping-scalars-to-sequences" class="example">
**Example 2.3 Mapping Scalars to Sequences (ball clubs in each league)**

<pre class="example">
american:
  - Boston Red Sox
  - Detroit Tigers
  - New York Yankees
national:
  - New York Mets
  - Chicago Cubs
  - Atlanta Braves
</pre>

</div>

<div id="example-sequence-of-mappings" class="example">
**Example 2.4 Sequence of Mappings (players’ statistics)**

<pre class="example">
-
  name: Mark McGwire
  hr:   65
  avg:  0.278
-
  name: Sammy Sosa
  hr:   63
  avg:  0.288
</pre>

</div>

YAML also has ~~[flow styles](#undefined)~~, using explicit ~~[indicators](#undefined)~~ rather than
[indentation](#indentation-spaces) to denote scope.
The ~~[flow sequence](#undefined)~~ is written as a ~~[comma](#undefined)~~ separated list within ~~[square](#undefined)~~
~~[brackets](#undefined)~~.
In a similar manner, the ~~[flow mapping](#undefined)~~ uses ~~[curly](#undefined)~~ ~~[braces](#undefined)~~.

<div id="example-sequence-of-sequences" class="example">
**Example 2.5 Sequence of Sequences**

<pre class="example">
- [name        , hr, avg  ]
- [Mark McGwire, 65, 0.278]
- [Sammy Sosa  , 63, 0.288]
</pre>

</div>

<div id="example-mapping-of-mappings" class="example">
**Example 2.6 Mapping of Mappings**

<pre class="example">
Mark McGwire: {hr: 65, avg: 0.278}
Sammy Sosa: {
    hr: 63,
    avg: 0.288
  }
</pre>

</div>

<div id="structures" />
## 2.2. Structures


YAML uses three dashes (~~["**`---`**"](#undefined)~~) to separate ~~[directives](#undefined)~~ from ~~[document](#undefined)~~
[content](#nodes).
This also serves to signal the start of a document if no ~~[directives](#undefined)~~ are
present.
Three dots ( ~~["**`...`**"](#undefined)~~) indicate the end of a document without starting a
new one, for use in communication channels.

<div id="example-two-documents-in-a-stream" class="example">
**Example 2.7 Two Documents in a Stream (each with a leading comment)**

<pre class="example">
# Ranking of 1998 home runs
---
- Mark McGwire
- Sammy Sosa
- Ken Griffey

# Team ranking
---
- Chicago Cubs
- St Louis Cardinals
</pre>

</div>

<div id="example-play-by-play-feed-from-a-game" class="example">
**Example 2.8 Play by Play Feed from a Game**

<pre class="example">
---
time: 20:03:20
player: Sammy Sosa
action: strike (miss)
...
---
time: 20:03:47
player: Sammy Sosa
action: grand slam
...
</pre>

</div>

Repeated ~~[nodes](#undefined)~~ (objects) are first ~~[identified](#undefined)~~ by an ~~[anchor](#undefined)~~ (marked with
the ampersand - ~~["**`&`**"](#undefined)~~), and are then ~~[aliased](#undefined)~~ (referenced with an
asterisk - ~~["**`*`**"](#undefined)~~) thereafter.

<div id="example-single-document-with-two-comments" class="example">
**Example 2.9 Single Document with Two Comments**

<pre class="example">
---
hr: # 1998 hr ranking
  - Mark McGwire
  - Sammy Sosa
rbi:
  # 1998 rbi ranking
  - Sammy Sosa
  - Ken Griffey
</pre>

</div>

<div id="example-node-for-sammy-sosa-appears-twice-in-this-document" class="example">
**Example 2.10 Node for "**`Sammy Sosa`**" appears twice in this document**

<pre class="example">
---
hr:
  - Mark McGwire
  # Following node labeled SS
  - &amp;SS Sammy Sosa
rbi:
  - *SS # Subsequent occurrence
  - Ken Griffey
</pre>

</div>

A question mark and space (~~["**`?`** "](#undefined)~~) indicate a complex ~~[mapping](#undefined)~~ [key](#nodes).
Within a ~~[block collection](#undefined)~~, ~~[key: value pairs](#undefined)~~ can start immediately following
the ~~[dash](#undefined)~~, ~~[colon](#undefined)~~, or ~~[question mark](#undefined)~~.

<div id="example-mapping-between-sequences" class="example">
**Example 2.11 Mapping between Sequences**

<pre class="example">
? - Detroit Tigers
  - Chicago cubs
:
  - 2001-07-23

? [ New York Yankees,
    Atlanta Braves ]
: [ 2001-07-02, 2001-08-12,
    2001-08-14 ]
</pre>

</div>

<div id="example-compact-nested-mapping" class="example">
**Example 2.12 Compact Nested Mapping**

<pre class="example">
---
# Products purchased
- item    : Super Hoop
  quantity: 1
- item    : Basketball
  quantity: 4
- item    : Big Shoes
  quantity: 1
</pre>

</div>

<div id="scalars" />
## 2.3. Scalars


[Scalar content](#scalar) can be written in ~~[block](#undefined)~~ notation, using a ~~[literal
style](#undefined)~~ (indicated by ~~["**`|`**"](#undefined)~~) where all [line breaks](#line-break-characters) are significant.
Alternatively, they can be written with the ~~[folded style](#undefined)~~ ~~[(denoted by
"**`>`**"](#undefined)~~) where each [line break](#line-break-characters) is ~~[folded](#undefined)~~ to a [space](#white-space-characters) unless it ends an
~~[empty](#undefined)~~ or a ~~[more-indented](#undefined)~~ line.

<div id="example-in-literals-newlines-are-preserved" class="example">
**Example 2.13 In literals, newlines are preserved**

<pre class="example">
# ASCII Art
--- |
  \//||\/||
  // ||  ||__
</pre>

</div>

<div id="example-in-the-folded-scalars-newlines-become-spaces" class="example">
**Example 2.14 In the folded scalars, newlines become spaces**

<pre class="example">
--- &gt;
  Mark McGwire's
  year was crippled
  by a knee injury.
</pre>

</div>

<div id="example-folded-newlines-are-preserved-for-more-indented-and-blank-lines" class="example">
**Example 2.15 Folded newlines are preserved for "more indented" and blank
lines**

<pre class="example">
&gt;
 Sammy Sosa completed another
 fine season with great stats.

   63 Home Runs
   0.288 Batting Average

 What a year!
</pre>

</div>

<div id="example-indentation-determines-scope" class="example">
**Example 2.16 Indentation determines scope**

<pre class="example">
name: Mark McGwire
accomplishment: &gt;
  Mark set a major league
  home run record in 1998.
stats: |
  65 Home Runs
  0.278 Batting Average
</pre>

</div>

YAML’s ~~[flow scalars](#undefined)~~ include the ~~[plain style](#undefined)~~ (most examples thus far) and
two quoted styles.
The ~~[double-quoted style](#undefined)~~ provides ~~[escape sequences](#undefined)~~.
The ~~[single-quoted style](#undefined)~~ is useful when ~~[escaping](#undefined)~~ is not needed.
All ~~[flow scalars](#undefined)~~ can span multiple lines; [line breaks](#line-break-characters) are always ~~[folded](#undefined)~~.

<div id="example-quoted-scalars" class="example">
**Example 2.17 Quoted Scalars**

<pre class="example">
unicode: "Sosa did fine.\u263A"
control: "\b1998\t1999\t2000\n"
hex esc: "\x0d\x0a is \r\n"

single: '"Howdy!" he cried.'
quoted: ' # Not a ''comment''.'
tie-fighter: '|\-*-/|'
</pre>

</div>

<div id="example-multi-line-flow-scalars" class="example">
**Example 2.18 Multi-line Flow Scalars**

<pre class="example">
plain:
  This unquoted scalar
  spans many lines.

quoted: "So does this
  quoted scalar.\n"
</pre>

</div>

<div id="tags" />
## 2.4. Tags


In YAML, ~~[untagged nodes](#undefined)~~ are given a type depending on the [application](#processing-yaml-information).
The examples in this specification generally use the ~~[**`seq`**](#undefined)~~, ~~[**`map`**](#undefined)~~
and ~~[**`str`**](#undefined)~~ types from the ~~[fail safe schema](#undefined)~~.
A few examples also use the ~~[**`int`**](#undefined)~~, ~~[**`float`**](#undefined)~~, and ~~[**`null`**](#undefined)~~ types
from the ~~[JSON schema](#undefined)~~.
The ~~[repository](#undefined)~~ includes additional types such as
[**`binary`**](/type/binary.html), [**`omap`**](/type/omap.html),
[**`set`**](/type/set.html) and others.

<div id="example-integers" class="example">
**Example 2.19 Integers**

<pre class="example">
canonical: 12345
decimal: +12345
octal: 0o14
hexadecimal: 0xC
</pre>

</div>

<div id="example-floating-point" class="example">
**Example 2.20 Floating Point**

<pre class="example">
canonical: 1.23015e+3
exponential: 12.3015e+02
fixed: 1230.15
negative infinity: -.inf
not a number: .NaN
</pre>

</div>

<div id="example-miscellaneous" class="example">
**Example 2.21 Miscellaneous**

<pre class="example">
null:
booleans: [ true, false ]
string: '012345'
</pre>

</div>

<div id="example-timestamps" class="example">
**Example 2.22 Timestamps**

<pre class="example">
canonical: 2001-12-15T02:59:43.1Z
iso8601: 2001-12-14t21:59:43.10-05:00
spaced: 2001-12-14 21:59:43.10 -5
date: 2002-12-14
</pre>

</div>

Explicit typing is denoted with a [tag](#tags) using the exclamation point
(~~["**`!`**"](#undefined)~~) symbol. ~~[Global tags](#undefined)~~ are URIs and may be specified in a ~~[tag
shorthand](#undefined)~~ notation using a ~~[handle](#undefined)~~. [Application](#processing-yaml-information)\-specific ~~[local tags](#undefined)~~ may
also be used.

<div id="example-various-explicit-tags" class="example">
**Example 2.23 Various Explicit Tags**

<pre class="example">
---
not-date: !!str 2002-04-28

picture: !!binary |
 R0lGODlhDAAMAIQAAP//9/X
 17unp5WZmZgAAAOfn515eXv
 Pz7Y6OjuDg4J+fn5OTk6enp
 56enmleECcgggoBADs=

application specific tag: !something |
 The semantics of the tag
 above may be different for
 different documents.
</pre>

</div>

<div id="example-global-tags" class="example">
**Example 2.24 Global Tags**

<pre class="example">
%TAG ! tag:clarkevans.com,2002:
--- !shape
  # Use the ! handle for presenting
  # tag:clarkevans.com,2002:circle
- !circle
  center: &amp;ORIGIN {x: 73, y: 129}
  radius: 7
- !line
  start: *ORIGIN
  finish: { x: 89, y: 102 }
- !label
  start: *ORIGIN
  color: 0xFFEEBB
  text: Pretty vector drawing.
</pre>

</div>

<div id="example-unordered-sets" class="example">
**Example 2.25 Unordered Sets**

<pre class="example">
# Sets are represented as a
# Mapping where each key is
# associated with a null value
--- !!set
? Mark McGwire
? Sammy Sosa
? Ken Griff
</pre>

</div>

<div id="example-ordered-mappings" class="example">
**Example 2.26 Ordered Mappings**

<pre class="example">
# Ordered maps are represented as
# A sequence of mappings, with
# each mapping having one key
--- !!omap
- Mark McGwire: 65
- Sammy Sosa: 63
- Ken Griffy: 58
</pre>

</div>

<div id="full-length-example" />
## 2.5. Full Length Example


Below are two full-length examples of YAML.
On the left is a sample invoice; on the right is a sample log file.

<div id="example-invoice" class="example">
**Example 2.27 Invoice**

<pre class="example">
--- !&lt;tag:clarkevans.com,2002:invoice&gt;
invoice: 34843
date   : 2001-01-23
bill-to: &amp;id001
    given  : Chris
    family : Dumars
    address:
        lines: |
            458 Walkman Dr.
            Suite #292
        city    : Royal Oak
        state   : MI
        postal  : 48046
ship-to: *id001
product:
    - sku         : BL394D
      quantity    : 4
      description : Basketball
      price       : 450.00
    - sku         : BL4438H
      quantity    : 1
      description : Super Hoop
      price       : 2392.00
tax  : 251.42
total: 4443.52
comments:
    Late afternoon is best.
    Backup contact is Nancy
    Billsmer @ 338-4338.
</pre>

</div>

<div id="example-log-file" class="example">
**Example 2.28 Log File**

<pre class="example">
---
Time: 2001-11-23 15:01:42 -5
User: ed
Warning:
  This is an error message
  for the log file
---
Time: 2001-11-23 15:02:31 -5
User: ed
Warning:
  A slightly different error
  message.
---
Date: 2001-11-23 15:03:17 -5
User: ed
Fatal:
  Unknown variable "bar"
Stack:
  - file: TopClass.py
    line: 23
    code: |
      x = MoreObject("345\n")
  - file: MoreClass.py
    line: 58
    code: |-
      foo = bar
</pre>

</div>

<div id="processing-yaml-information" />
# Chapter 3. Processing YAML Information


YAML is both a text format and a method for ~~[presenting](#undefined)~~ any ~~[native data
structure](#undefined)~~ in this format.
Therefore, this specification defines two concepts: a class of data objects
called YAML [representations](#representation-graph), and a syntax for ~~[presenting](#undefined)~~ YAML
[representations](#representation-graph) as a series of characters, called a YAML [stream](#streams).
A YAML _processor_ is a tool for converting information between these
complementary views.
It is assumed that a YAML processor does its work on behalf of another module,
called an _application_.
This chapter describes the information structures a YAML processor must provide
to or obtain from the application.

YAML information is used in two ways: for machine processing, and for human
consumption.
The challenge of reconciling these two perspectives is best done in three
distinct translation stages: [representation](#representation-graph), [serialization](#serialization-tree), and
[presentation](#presentation-stream). [Representation](#representation-graph) addresses how YAML views ~~[native data
structures](#undefined)~~ to achieve portability between programming environments.
[Serialization](#serialization-tree) concerns itself with turning a YAML [representation](#representation-graph) into a
serial form, that is, a form with sequential access constraints. [Presentation](#presentation-stream)
deals with the formatting of a YAML [serialization](#serialization-tree) as a series of characters
in a human-friendly manner.

<div id="processes" />
## 3.1. Processes


Translating between ~~[native data structures](#undefined)~~ and a character [stream](#streams) is done
in several logically distinct stages, each with a well defined input and output
data model, as shown in the following diagram:

**Figure 3.1. Processing Overview**

![Processing Overview](img/overview2.png)

A YAML processor need not expose the [serialization](#serialization-tree) or [representation](#representation-graph) stages.
It may translate directly between ~~[native data structures](#undefined)~~ and a character
[stream](#streams) (~~[dump](#undefined)~~ and ~~[load](#undefined)~~ in the diagram above).
However, such a direct translation should take place so that the ~~[native data
structures](#undefined)~~ are ~~[constructed](#undefined)~~ only from information available in the
[representation](#representation-graph).
In particular, ~~[mapping key order](#undefined)~~, ~~[comments](#undefined)~~, and ~~[tag handles](#undefined)~~ should not be
referenced during ~~[composition](#undefined)~~.

<div id="dump" />
### 3.1.1. Dump


_Dumping_ native data structures to a character [stream](#streams) is done using the
following three stages:

##### Representing Native Data Structures

> YAML _represents_ any _native data structure_ using three ~~[node kinds](#undefined)~~:
> ~~[sequence](#undefined)~~ - an ordered series of entries; ~~[mapping](#undefined)~~ - an unordered
> association of [unique](#node-comparison) ~~[keys](#undefined)~~ to ~~[values](#undefined)~~; and [scalar](#scalar) - any datum with
> opaque structure presentable as a series of Unicode characters.
> Combined, these primitives generate directed graph structures.
> These primitives were chosen because they are both powerful and familiar: the
> ~~[sequence](#undefined)~~ corresponds to a Perl array and a Python list, the ~~[mapping](#undefined)~~
> corresponds to a Perl hash table and a Python dictionary.
> The [scalar](#scalar) represents strings, integers, dates, and other atomic data
> types.
>
> Each YAML [node](#nodes) requires, in addition to its ~~[kind](#undefined)~~ and [content](#nodes), a [tag](#tags)
> specifying its data type.
> Type specifiers are either ~~[global](#undefined)~~ URIs, or are ~~[local](#undefined)~~ in scope to a single
> [application](#processing-yaml-information).
> For example, an integer is represented in YAML with a [scalar](#scalar) plus the
> ~~[global tag](#undefined)~~ "**`tag:yaml.org,2002:int`**".
> Similarly, an invoice object, particular to a given organization, could be
> represented as a ~~[mapping](#undefined)~~ together with the ~~[local tag](#undefined)~~ "**`!invoice`**".
> This simple model can represent any data structure independent of programming
> language.

##### Serializing the Representation Graph

> For sequential access mediums, such as an event callback API, a YAML
> [representation](#representation-graph) must be _serialized_ to an ordered tree.
> Since in a YAML [representation](#representation-graph), [mapping keys](#nodes) are unordered and ~~[nodes](#undefined)~~ may
> be referenced more than once (have more than one incoming "arrow"), the
> serialization process is required to impose an ~~[ordering](#undefined)~~ on the [mapping keys](#nodes)
> and to replace the second and subsequent references to a given [node](#nodes) with
> place holders called ~~[aliases](#undefined)~~.
> YAML does not specify how these _serialization details_ are chosen.
> It is up to the YAML [processor](#processing-yaml-information) to come up with human-friendly ~~[key order](#undefined)~~ and
> ~~[anchor](#undefined)~~ names, possibly with the help of the [application](#processing-yaml-information).
> The result of this process, a YAML ~~[serialization tree](#undefined)~~, can then be traversed
> to produce a series of event calls for one-pass processing of YAML data.

##### Presenting the Serialization Tree

> The final output process is _presenting_ the YAML ~~[serializations](#undefined)~~ as a
> character [stream](#streams) in a human-friendly manner.
> To maximize human readability, YAML offers a rich set of stylistic options
> which go far beyond the minimal functional needs of simple data storage.
> Therefore the YAML [processor](#processing-yaml-information) is required to introduce various _presentation
> details_ when creating the [stream](#streams), such as the choice of ~~[node styles](#undefined)~~, how
> to ~~[format scalar content](#undefined)~~, the amount of [indentation](#indentation-spaces), which ~~[tag handles](#undefined)~~ to
> use, the ~~[node tags](#undefined)~~ to leave ~~[unspecified](#undefined)~~, the set of ~~[directives](#undefined)~~ to provide
> and possibly even what ~~[comments](#undefined)~~ to add.
> While some of this can be done with the help of the [application](#processing-yaml-information), in general
> this process should be guided by the preferences of the user.

<div id="load" />
### 3.1.2. Load


_Loading_ ~~[native data structures](#undefined)~~ from a character [stream](#streams) is done using the
following three stages:

##### Parsing the Presentation Stream

> _Parsing_ is the inverse process of [presentation](#presentation-stream), it takes a [stream](#streams) of
> characters and produces a series of events.
> Parsing discards all the ~~[details](#undefined)~~ introduced in the [presentation](#presentation-stream) process,
> reporting only the [serialization](#serialization-tree) events.
> Parsing can fail due to ~~[ill-formed](#undefined)~~ input.

##### Composing the Representation Graph

> _Composing_ takes a series of [serialization](#serialization-tree) events and produces a
> [representation graph](#representation-graph).
> Composing discards all the ~~[details](#undefined)~~ introduced in the [serialization](#serialization-tree) process,
> producing only the [representation graph](#representation-graph).
> Composing can fail due to any of several reasons, detailed ~~[below](#undefined)~~.

##### Constructing Native Data Structures

> The final input process is _constructing_ ~~[native data structures](#undefined)~~ from the
> YAML [representation](#representation-graph).
> Construction must be based only on the information available in the
> [representation](#representation-graph), and not on additional [serialization](#serialization-tree) or ~~[presentation
> details](#undefined)~~ such as ~~[comments](#undefined)~~, ~~[directives](#undefined)~~, ~~[mapping key order](#undefined)~~, ~~[node styles](#undefined)~~,
> ~~[scalar content format](#undefined)~~, [indentation](#indentation-spaces) levels etc.
> Construction can fail due to the ~~[unavailability](#undefined)~~ of the required ~~[native data
> types](#undefined)~~.

<div id="information-models" />
## 3.2. Information Models


This section specifies the formal details of the results of the above processes.
To maximize data portability between programming languages and implementations,
users of YAML should be mindful of the distinction between [serialization](#serialization-tree) or
[presentation](#presentation-stream) properties and those which are part of the YAML [representation](#representation-graph).
Thus, while imposing a ~~[order](#undefined)~~ on [mapping keys](#nodes) is necessary for flattening
YAML [representations](#representation-graph) to a sequential access medium, this ~~[serialization
detail](#undefined)~~ must not be used to convey [application](#processing-yaml-information) level information.
In a similar manner, while [indentation](#indentation-spaces) technique and a choice of a ~~[node
style](#undefined)~~ are needed for the human readability, these ~~[presentation details](#undefined)~~ are
neither part of the YAML [serialization](#serialization-tree) nor the YAML [representation](#representation-graph).
By carefully separating properties needed for [serialization](#serialization-tree) and
[presentation](#presentation-stream), YAML [representations](#representation-graph) of [application](#processing-yaml-information) information will be
consistent and portable between various programming environments.

The following diagram summarizes the three _information models_.
Full arrows denote composition, hollow arrows denote inheritance, "**`1`**" and
"**`*`**" denote "one" and "many" relationships.
A single "**`+`**" denotes [serialization](#serialization-tree) details, a double "**`++`**" denotes
[presentation](#presentation-stream) details.

**Figure 3.2. Information Models**

![Information Models](img/model2.png)

<div id="representation-graph" />
### 3.2.1. Representation Graph


YAML’s _representation_ of ~~[native data structure](#undefined)~~ is a rooted, connected,
directed graph of ~~[tagged](#undefined)~~ ~~[nodes](#undefined)~~.
By "directed graph" we mean a set of ~~[nodes](#undefined)~~ and directed edges ("arrows"),
where each edge connects one [node](#nodes) to another (see [a formal
definition](http://www.nist.gov/dads/HTML/directedGraph.html)).
All the ~~[nodes](#undefined)~~ must be reachable from the _root node_ via such edges.
Note that the YAML graph may include cycles, and a [node](#nodes) may have more than
one incoming edge.

~~[Nodes](#undefined)~~ that are defined in terms of other ~~[nodes](#undefined)~~ are ~~[collections](#undefined)~~; ~~[nodes](#undefined)~~
that are independent of any other ~~[nodes](#undefined)~~ are ~~[scalars](#undefined)~~.
YAML supports two ~~[kinds](#undefined)~~ of ~~[collection nodes](#undefined)~~: [sequences](#sequence) and [mappings](#mapping).
~~[Mapping nodes](#undefined)~~ are somewhat tricky because their ~~[keys](#undefined)~~ are unordered and must
be [unique](#node-comparison).

**Figure 3.3. Representation Model**

![Representation Model](img/represent2.png)

<div id="nodes" />
#### 3.2.1.1. Nodes


A YAML _node_ ~~[represents](#undefined)~~ a single ~~[native data structure](#undefined)~~.
Such nodes have _content_ of one of three _kinds_: scalar, sequence, or mapping.
In addition, each node has a [tag](#tags) which serves to restrict the set of possible
values the content can have.

##### Scalar

> The content of a _scalar_ node is an opaque datum that can be ~~[presented](#undefined)~~ as a
> series of zero or more Unicode characters.

##### Sequence

> The content of a _sequence_ node is an ordered series of zero or more nodes.
> In particular, a sequence may contain the same node more than once.
> It could even contain itself (directly or indirectly).

##### Mapping

> The content of a _mapping_ node is an unordered set of _key:_ _value_ node
> _pairs_, with the restriction that each of the keys is [unique](#node-comparison).
> YAML places no further restrictions on the nodes.
> In particular, keys may be arbitrary nodes, the same node may be used as the
> value of several key: value pairs, and a mapping could even contain itself as a
> key or a value (directly or indirectly).

When appropriate, it is convenient to consider sequences and mappings together,
as _collections_.
In this view, sequences are treated as mappings with integer keys starting at
zero.
Having a unified collections view for sequences and mappings is helpful both
for theoretical analysis and for creating practical YAML tools and APIs.
This strategy is also used by the Javascript programming language.

<div id="tags" />
#### 3.2.1.2. Tags


YAML ~~[represents](#undefined)~~ type information of ~~[native data structures](#undefined)~~ with a simple
identifier, called a _tag_. _Global tags_ are
[URIs](http://www.ietf.org/rfc/rfc2396.txt) and hence globally unique across
all [applications](#processing-yaml-information).
The "**`tag:`**" [URI scheme](http://www.faqs.org/rfcs/rfc4151.html) is
recommended for all global YAML tags.
In contrast, _local tags_ are specific to a single [application](#processing-yaml-information).
Local tags start with _"**`!`**"_, are not URIs and are not expected to be
globally unique.
YAML provides a ~~["**`TAG`**" directive](#undefined)~~ to make tag notation less verbose; it
also offers easy migration from local to global tags.
To ensure this, local tags are restricted to the URI character set and use URI
character ~~[escaping](#undefined)~~.

YAML does not mandate any special relationship between different tags that
begin with the same substring.
Tags ending with URI fragments (containing "**`#`**") are no exception; tags
that share the same base URI but differ in their fragment part are considered
to be different, independent tags.
By convention, fragments are used to identify different "variants" of a tag,
while "**`/`**" is used to define nested tag "namespace" hierarchies.
However, this is merely a convention, and each tag may employ its own rules.
For example, Perl tags may use "**`::`**" to express namespace hierarchies,
Java tags may use "**`.`**", etc.

YAML tags are used to associate meta information with each [node](#nodes).
In particular, each tag must specify the expected ~~[node kind](#undefined)~~ ([scalar](#scalar),
~~[sequence](#undefined)~~, or ~~[mapping](#undefined)~~). [Scalar](#scalar) tags must also provide a mechanism for
converting [formatted content](#scalar-formats) to a ~~[canonical form](#undefined)~~ for supporting ~~[equality](#undefined)~~
testing.
Furthermore, a tag may provide additional information such as the set of
allowed [content](#nodes) values for validation, a mechanism for ~~[tag resolution](#undefined)~~, or
any other data that is applicable to all of the tag’s ~~[nodes](#undefined)~~.

<div id="node-comparison" />
#### 3.2.1.3. Node Comparison


Since YAML [mappings](#mapping) require [key](#nodes) uniqueness, [representations](#representation-graph) must include
a mechanism for testing the equality of ~~[nodes](#undefined)~~.
This is non-trivial since YAML allows various ways to ~~[format scalar content](#undefined)~~.
For example, the integer eleven can be written as "**`0o13`**" (octal) or
"**`0xB`**" (hexadecimal).
If both notations are used as ~~[keys](#undefined)~~ in the same ~~[mapping](#undefined)~~, only a YAML
[processor](#processing-yaml-information) which recognizes integer ~~[formats](#undefined)~~ would correctly flag the
duplicate [key](#nodes) as an error.

##### Canonical Form

YAML supports the need for [scalar](#scalar) equality by requiring that every
[scalar](#scalar) [tag](#tags) must specify a mechanism for producing the _canonical form_ of
any [formatted content](#scalar-formats).
This form is a Unicode character string which also ~~[presents](#undefined)~~ the same
[content](#nodes), and can be used for equality testing.
While this requirement is stronger than a well defined equality operator, it
has other uses, such as the production of digital signatures.

##### Equality

Two ~~[nodes](#undefined)~~ must have the same [tag](#tags) and [content](#nodes) to be _equal_.
Since each [tag](#tags) applies to exactly one ~~[kind](#undefined)~~, this implies that the two
~~[nodes](#undefined)~~ must have the same ~~[kind](#undefined)~~ to be equal.
Two ~~[scalars](#undefined)~~ are equal only when their ~~[tags](#undefined)~~ and canonical forms are equal
character-by-character.
Equality of ~~[collections](#undefined)~~ is defined recursively.
Two [sequences](#sequence) are equal only when they have the same [tag](#tags) and length, and
each [node](#nodes) in one ~~[sequence](#undefined)~~ is equal to the corresponding [node](#nodes) in the
other ~~[sequence](#undefined)~~.
Two [mappings](#mapping) are equal only when they have the same [tag](#tags) and an equal set
of ~~[keys](#undefined)~~, and each [key](#nodes) in this set is associated with equal ~~[values](#undefined)~~ in
both [mappings](#mapping).

Different URI schemes may define different rules for testing the equality of
URIs.
Since a YAML [processor](#processing-yaml-information) cannot be reasonably expected to be aware of them
all, it must resort to a simple character-by-character comparison of ~~[tags](#undefined)~~
to ensure consistency.
This also happens to be the comparison method defined by the "**`tag:`**" URI
scheme. ~~[Tags](#undefined)~~ in a YAML stream must therefore be ~~[presented](#undefined)~~ in a canonical
way so that such comparison would yield the correct results.

##### Identity

Two ~~[nodes](#undefined)~~ are _identical_ only when they ~~[represent](#undefined)~~ the same ~~[native data
structure](#undefined)~~.
Typically, this corresponds to a single memory address.
Identity should not be confused with equality; two equal ~~[nodes](#undefined)~~ need not have
the same identity.
A YAML [processor](#processing-yaml-information) may treat equal ~~[scalars](#undefined)~~ as if they were identical.
In contrast, the separate identity of two distinct but equal ~~[collections](#undefined)~~ must
be preserved.

<div id="serialization-tree" />
### 3.2.2. Serialization Tree


To express a YAML [representation](#representation-graph) using a serial API, it is necessary to
impose an ~~[order](#undefined)~~ on [mapping keys](#nodes) and employ ~~[alias nodes](#undefined)~~ to indicate a
subsequent occurrence of a previously encountered [node](#nodes).
The result of this process is a _serialization tree_, where each [node](#nodes) has an
ordered set of children.
This tree can be traversed for a serial event-based API. ~~[Construction](#undefined)~~ of
~~[native data structures](#undefined)~~ from the serial interface should not use ~~[key order](#undefined)~~
or ~~[anchor names](#undefined)~~ for the preservation of [application](#processing-yaml-information) data.

**Figure 3.4. Serialization Model**

![Serialization Model](img/serialize2.png)

<div id="keys-order" />
#### 3.2.2.1. Keys Order


In the [representation](#representation-graph) model, [mapping keys](#nodes) do not have an order.
To ~~[serialize](#undefined)~~ a ~~[mapping](#undefined)~~, it is necessary to impose an _ordering_ on its
~~[keys](#undefined)~~.
This order is a ~~[serialization detail](#undefined)~~ and should not be used when ~~[composing](#undefined)~~
the [representation graph](#representation-graph) (and hence for the preservation of [application](#processing-yaml-information)
data).
In every case where [node](#nodes) order is significant, a ~~[sequence](#undefined)~~ must be used.
For example, an ordered ~~[mapping](#undefined)~~ can be ~~[represented](#undefined)~~ as a ~~[sequence](#undefined)~~ of
[mappings](#mapping), where each ~~[mapping](#undefined)~~ is a single ~~[key: value pair](#undefined)~~.
YAML provides convenient ~~[compact notation](#undefined)~~ for this case.

<div id="anchors-and-aliases" />
#### 3.2.2.2. Anchors and Aliases


In the [representation graph](#representation-graph), a [node](#nodes) may appear in more than one ~~[collection](#undefined)~~.
When ~~[serializing](#undefined)~~ such data, the first occurrence of the [node](#nodes) is
_identified_ by an _anchor_.
Each subsequent occurrence is ~~[serialized](#undefined)~~ as an ~~[alias node](#undefined)~~ which refers back
to this anchor.
Otherwise, anchor names are a ~~[serialization detail](#undefined)~~ and are discarded once
~~[composing](#undefined)~~ is completed.
When ~~[composing](#undefined)~~ a [representation graph](#representation-graph) from ~~[serialized](#undefined)~~ events, an alias
node refers to the most recent [node](#nodes) in the [serialization](#serialization-tree) having the
specified anchor.
Therefore, anchors need not be unique within a [serialization](#serialization-tree).
In addition, an anchor need not have an alias node referring to it.
It is therefore possible to provide an anchor for all ~~[nodes](#undefined)~~ in
[serialization](#serialization-tree).

<div id="presentation-stream" />
### 3.2.3. Presentation Stream


A YAML _presentation_ is a [stream](#streams) of Unicode characters making use of of
[styles](#node-styles), ~~[scalar content formats](#undefined)~~, ~~[comments](#undefined)~~, ~~[directives](#undefined)~~ and other
~~[presentation details](#undefined)~~ to ~~[present](#undefined)~~ a YAML [serialization](#serialization-tree) in a human readable
way.
Although a YAML [processor](#processing-yaml-information) may provide these ~~[details](#undefined)~~ when ~~[parsing](#undefined)~~, they
should not be reflected in the resulting [serialization](#serialization-tree).
YAML allows several ~~[serialization trees](#undefined)~~ to be contained in the same YAML
character stream, as a series of [documents](#document) separated by ~~[markers](#undefined)~~.
Documents appearing in the same stream are independent; that is, a [node](#nodes) must
not appear in more than one ~~[serialization tree](#undefined)~~ or [representation graph](#representation-graph).

**Figure 3.5. Presentation Model**

![Presentation Model](img/present2.png)

<div id="node-styles" />
#### 3.2.3.1. Node Styles


Each [node](#nodes) is presented in some _style_, depending on its ~~[kind](#undefined)~~.
The node style is a ~~[presentation detail](#undefined)~~ and is not reflected in the
~~[serialization tree](#undefined)~~ or [representation graph](#representation-graph).
There are two groups of styles. ~~[Block styles](#undefined)~~ use [indentation](#indentation-spaces) to denote
structure; In contrast, ~~[flow styles](#undefined)~~ styles rely on explicit ~~[indicators](#undefined)~~.

YAML provides a rich set of _scalar styles_. ~~[Block scalar](#undefined)~~ styles include the
~~[literal style](#undefined)~~ and the ~~[folded style](#undefined)~~. ~~[Flow scalar](#undefined)~~ styles include the ~~[plain
style](#undefined)~~ and two quoted styles, the ~~[single-quoted style](#undefined)~~ and the ~~[double-quoted
style](#undefined)~~.
These styles offer a range of trade-offs between expressive power and
readability.

Normally, ~~[block sequences](#undefined)~~ and [mappings](#mapping) begin on the next line.
In some cases, YAML also allows nested ~~[block](#undefined)~~ ~~[collections](#undefined)~~ to start in-line
for a more ~~[compact notation](#undefined)~~.
In addition, YAML provides a ~~[compact notation](#undefined)~~ for ~~[flow mappings](#undefined)~~ with a
single ~~[key: value pair](#undefined)~~, nested inside a ~~[flow sequence](#undefined)~~.
These allow for a natural "ordered mapping" notation.

**Figure 3.6. Kind/Style Combinations**

![Kind/Style Combinations](img/styles2.png)

<div id="scalar-formats" />
#### 3.2.3.2. Scalar Formats


YAML allows ~~[scalars](#undefined)~~ to be ~~[presented](#undefined)~~ in several _formats_.
For example, the integer "**`11`**" might also be written as "**`0xB`**".
~~[Tags](#undefined)~~ must specify a mechanism for converting the formatted content to a
~~[canonical form](#undefined)~~ for use in ~~[equality](#undefined)~~ testing.
Like ~~[node style](#undefined)~~, the format is a ~~[presentation detail](#undefined)~~ and is not reflected
in the ~~[serialization tree](#undefined)~~ and [representation graph](#representation-graph).

<div id="comments" />
#### 3.2.3.3. Comments


~~[Comments](#undefined)~~ are a ~~[presentation detail](#undefined)~~ and must not have any effect on the
~~[serialization tree](#undefined)~~ or [representation graph](#representation-graph).
In particular, comments are not associated with a particular [node](#nodes).
The usual purpose of a comment is to communicate between the human maintainers
of a file.
A typical example is comments in a configuration file.
Comments must not appear inside ~~[scalars](#undefined)~~, but may be interleaved with such
~~[scalars](#undefined)~~ inside ~~[collections](#undefined)~~.

<div id="directives" />
#### 3.2.3.4. Directives


Each ~~[document](#undefined)~~ may be associated with a set of ~~[directives](#undefined)~~.
A directive has a name and an optional sequence of parameters.
Directives are instructions to the YAML [processor](#processing-yaml-information), and like all other
~~[presentation details](#undefined)~~ are not reflected in the YAML ~~[serialization tree](#undefined)~~ or
[representation graph](#representation-graph).
This version of YAML defines a two directives, ~~["**`YAML`**"](#undefined)~~ and ~~["**`TAG`**"](#undefined)~~.
All other directives are ~~[reserved](#undefined)~~ for future versions of YAML.

<div id="loading-failure-points" />
## 3.3. Loading Failure Points


The process of ~~[loading](#undefined)~~ ~~[native data structures](#undefined)~~ from a YAML [stream](#streams) has
several potential _failure points_.
The character [stream](#streams) may be ~~[ill-formed](#undefined)~~, ~~[aliases](#undefined)~~ may be ~~[unidentified](#undefined)~~,
~~[unspecified tags](#undefined)~~ may be ~~[unresolvable](#undefined)~~, ~~[tags](#undefined)~~ may be ~~[unrecognized](#undefined)~~, the
[content](#nodes) may be ~~[invalid](#undefined)~~, and a native type may be ~~[unavailable](#undefined)~~.
Each of these failures results with an incomplete loading.

A _partial representation_ need not ~~[resolve](#undefined)~~ the [tag](#tags) of each [node](#nodes), and the
~~[canonical form](#undefined)~~ of ~~[formatted scalar content](#undefined)~~ need not be available.
This weaker representation is useful for cases of incomplete knowledge of the
types used in the ~~[document](#undefined)~~.
In contrast, a _complete representation_ specifies the [tag](#tags) of each [node](#nodes),
and provides the ~~[canonical form](#undefined)~~ of ~~[formatted scalar content](#undefined)~~, allowing for
~~[equality](#undefined)~~ testing.
A complete representation is required in order to ~~[construct](#undefined)~~ ~~[native data
structures](#undefined)~~.

**Figure 3.7. Loading Failure Points**

![Loading Failure Points](img/validity2.png)

<div id="well-formed-streams-and-identified-aliases" />
### 3.3.1. Well-Formed Streams and Identified Aliases


A ~~[well-formed](#undefined)~~ character [stream](#streams) must match the BNF productions specified in
the following chapters.
Successful loading also requires that each ~~[alias](#undefined)~~ shall refer to a previous
[node](#nodes) ~~[identified](#undefined)~~ by the ~~[anchor](#undefined)~~.
A YAML [processor](#processing-yaml-information) should reject _ill-formed streams_ and _unidentified aliases_.
A YAML [processor](#processing-yaml-information) may recover from syntax errors, possibly by ignoring certain
parts of the input, but it must provide a mechanism for reporting such errors.

<div id="resolved-tags" />
### 3.3.2. Resolved Tags


Typically, most ~~[tags](#undefined)~~ are not explicitly specified in the character [stream](#streams).
During ~~[parsing](#undefined)~~, ~~[nodes](#undefined)~~ lacking an explicit [tag](#tags) are given a _non-specific
tag_: _"**`!`**"_ for non-~~[plain scalars](#undefined)~~, and _"**`?`**"_ for all other
~~[nodes](#undefined)~~. ~~[Composing](#undefined)~~ a ~~[complete representation](#undefined)~~ requires each such
non-specific tag to be _resolved_ to a _specific tag_, be it a ~~[global tag](#undefined)~~ or
a ~~[local tag](#undefined)~~.

Resolving the [tag](#tags) of a [node](#nodes) must only depend on the following three
parameters: (1) the non-specific tag of the [node](#nodes), (2) the path leading from
the ~~[root](#undefined)~~ to the [node](#nodes), and (3) the [content](#nodes) (and hence the ~~[kind](#undefined)~~) of the
[node](#nodes).
When a [node](#nodes) has more than one occurrence (using ~~[aliases](#undefined)~~), tag resolution
must depend only on the path to the first (~~[anchored](#undefined)~~) occurrence of the
[node](#nodes).

Note that resolution must not consider ~~[presentation details](#undefined)~~ such as
~~[comments](#undefined)~~, [indentation](#indentation-spaces) and ~~[node style](#undefined)~~.
Also, resolution must not consider the [content](#nodes) of any other [node](#nodes), except
for the [content](#nodes) of the ~~[key nodes](#undefined)~~ directly along the path leading from the
~~[root](#undefined)~~ to the resolved [node](#nodes).
Finally, resolution must not consider the [content](#nodes) of a sibling [node](#nodes) in a
~~[collection](#undefined)~~, or the [content](#nodes) of the ~~[value node](#undefined)~~ associated with a ~~[key node](#undefined)~~
being resolved.

These rules ensure that tag resolution can be performed as soon as a [node](#nodes) is
first encountered in the [stream](#streams), typically before its [content](#nodes) is ~~[parsed](#undefined)~~.
Also, tag resolution only requires referring to a relatively small number of
previously parsed ~~[nodes](#undefined)~~.
Thus, in most cases, tag resolution in one-pass ~~[processors](#undefined)~~ is both possible
and practical.

YAML ~~[processors](#undefined)~~ should resolve ~~[nodes](#undefined)~~ having the "**`!`**" non-specific tag
as "**`tag:yaml.org,2002:seq`**", "**`tag:yaml.org,2002:map`**" or
"**`tag:yaml.org,2002:str`**" depending on their ~~[kind](#undefined)~~.
This _tag resolution convention_ allows the author of a YAML character [stream](#streams)
to effectively "disable" the tag resolution process.
By explicitly specifying a "**`!`**" non-specific ~~[tag property](#undefined)~~, the [node](#nodes)
would then be resolved to a "vanilla" ~~[sequence](#undefined)~~, ~~[mapping](#undefined)~~, or string,
according to its ~~[kind](#undefined)~~.

[Application](#processing-yaml-information) specific tag resolution rules should be restricted to resolving
the "**`?`**" non-specific tag, most commonly to resolving ~~[plain scalars](#undefined)~~.
These may be matched against a set of regular expressions to provide automatic
resolution of integers, floats, timestamps, and similar types.
An [application](#processing-yaml-information) may also match the [content](#nodes) of ~~[mapping nodes](#undefined)~~ against sets
of expected ~~[keys](#undefined)~~ to automatically resolve points, complex numbers, and
similar types.
Resolved ~~[sequence node](#undefined)~~ types such as the "ordered mapping" are also possible.

That said, tag resolution is specific to the [application](#processing-yaml-information).
YAML ~~[processors](#undefined)~~ should therefore provide a mechanism allowing the
[application](#processing-yaml-information) to override and expand these default tag resolution rules.

If a ~~[document](#undefined)~~ contains _unresolved tags_, the YAML [processor](#processing-yaml-information) is unable to
~~[compose](#undefined)~~ a ~~[complete representation](#undefined)~~ graph.
In such a case, the YAML [processor](#processing-yaml-information) may ~~[compose](#undefined)~~ a ~~[partial representation](#undefined)~~,
based on each ~~[node’s kind](#undefined)~~ and allowing for non-specific tags.

<div id="recognized-and-valid-tags" />
### 3.3.3. Recognized and Valid Tags


To be _valid_, a [node](#nodes) must have a [tag](#tags) which is _recognized_ by the YAML
[processor](#processing-yaml-information) and its [content](#nodes) must satisfy the constraints imposed by this [tag](#tags).
If a ~~[document](#undefined)~~ contains a ~~[scalar node](#undefined)~~ with an _unrecognized tag_ or _invalid
content_, only a ~~[partial representation](#undefined)~~ may be ~~[composed](#undefined)~~.
In contrast, a YAML [processor](#processing-yaml-information) can always ~~[compose](#undefined)~~ a ~~[complete
representation](#undefined)~~ for an unrecognized or an invalid ~~[collection](#undefined)~~, since
~~[collection](#undefined)~~ ~~[equality](#undefined)~~ does not depend upon knowledge of the ~~[collection’s](#undefined)~~
data type.
However, such a ~~[complete representation](#undefined)~~ cannot be used to ~~[construct](#undefined)~~ a
~~[native data structure](#undefined)~~.

<div id="available-tags" />
### 3.3.4. Available Tags


In a given processing environment, there need not be an _available_ native type
corresponding to a given [tag](#tags).
If a ~~[node’s tag](#undefined)~~ is _unavailable_, a YAML [processor](#processing-yaml-information) will not be able to
~~[construct](#undefined)~~ a ~~[native data structure](#undefined)~~ for it.
In this case, a ~~[complete representation](#undefined)~~ may still be ~~[composed](#undefined)~~, and an
[application](#processing-yaml-information) may wish to use this [representation](#representation-graph) directly.

<div id="syntax-conventions" />
# Chapter 4. Syntax Conventions


The following chapters formally define the syntax of YAML character ~~[streams](#undefined)~~,
using parameterized BNF productions.
Each BNF production is both named and numbered for easy reference.
Whenever possible, basic structures are specified before the more complex
structures using them in a "bottom up" fashion.

The order of alternatives inside a production is significant.
Subsequent alternatives are only considered when previous ones fails.
See for example the [**`b-break`**](#b-break) production.
In addition, production matching is expected to be greedy.
Optional (**`?`**), zero-or-more (**`*`**) and one-or-more (**`+`**) patterns
are always expected to match as much of the input as possible.

The productions are accompanied by examples, which are given side-by-side next
to equivalent YAML text in an explanatory format.
This format uses only ~~[flow collections](#undefined)~~, ~~[double-quoted scalars](#undefined)~~, and explicit
~~[tags](#undefined)~~ for each [node](#nodes).

A reference implementation using the productions is available as the
[YamlReference](http://hackage.haskell.org/cgi-bin/hackage-scripts/package/Yaml
Reference) Haskell package.
This reference implementation is also available as an interactive web
application at [http://dev.yaml.org/ypaste](http://dev.yaml.org/ypaste).

<div id="production-parameters" />
## 4.1. Production Parameters


YAML’s syntax is designed for maximal human readability.
This requires ~~[parsing](#undefined)~~ to depend on the surrounding text.
For notational compactness, this dependency is expressed using parameterized
BNF productions.

This context sensitivity is the cause of most of the complexity of the YAML
syntax definition.
It is further complicated by struggling with the human tendency to look ahead
when interpreting text.
These complications are of course the source of most of YAML’s power to
~~[present](#undefined)~~ data in a very human readable way.

Productions use any of the following parameters:

##### Indentation: `n` or `m`

> Many productions use an explicit [indentation](#indentation-spaces) level parameter.
> This is less elegant than Python’s "indent" and "undent" conceptual tokens.
> However it is required to formally express YAML’s indentation rules.

##### Context: `c`

> This parameter allows productions to tweak their behavior according to their
> surrounding.
> YAML supports two groups of _contexts_, distinguishing between ~~[block styles](#undefined)~~
> and ~~[flow styles](#undefined)~~.
>
> In ~~[block styles](#undefined)~~, [indentation](#indentation-spaces) is used to delineate structure.
> To capture human perception of [indentation](#indentation-spaces) the rules require special
> treatment of the ~~["**`-`**"](#undefined)~~ character, used in ~~[block sequences](#undefined)~~.
> Hence in some cases productions need to behave differently inside ~~[block
> sequences](#undefined)~~ (_block-in context_) and outside them (_block-out context_).
>
> In ~~[flow styles](#undefined)~~, explicit ~~[indicators](#undefined)~~ are used to delineate structure.
> These styles can be viewed as the natural extension of JSON to cover
> ~~[tagged](#undefined)~~, ~~[single-quoted](#undefined)~~ and ~~[plain scalars](#undefined)~~.
> Since the latter have no delineating ~~[indicators](#undefined)~~, they are subject to some
> restrictions to avoid ambiguities.
> These restrictions depend on where they appear: as implicit keys directly
> inside a ~~[block mapping](#undefined)~~ (_block-key_); as implicit keys inside a ~~[flow
> mapping](#undefined)~~ (_flow-key_); as values inside a ~~[flow collection](#undefined)~~ (_flow-in_); or
> as values outside one (_flow-out_).

##### (Block) Chomping: `t`

> Block scalars offer three possible mechanisms for ~~[chomping](#undefined)~~ any trailing ~~[line
> breaks](#undefined)~~: ~~[strip](#undefined)~~, ~~[clip](#undefined)~~ and ~~[keep](#undefined)~~.
> Unlike the previous parameters, this only controls interpretation; the ~~[line
> breaks](#undefined)~~ are valid in all cases.

<div id="production-naming-conventions" />
## 4.2. Production Naming Conventions


To make it easier to follow production combinations, production names use a
Hungarian-style naming convention.
Each production is given a prefix based on the type of characters it begins and
ends with.

**`e-`**

> A production matching no characters.

**`c-`**

> A production starting and ending with a special character.

**`b-`**

> A production matching a single [line break](#line-break-characters).

**`nb-`**

> A production starting and ending with a non-[break](#line-break-characters) character.

**`s-`**

> A production starting and ending with a [white space](#white-space-characters) character.

**`ns-`**

> A production starting and ending with a non-[space](#white-space-characters) character.

**`l-`**

> A production matching complete line(s).

`X`**`-`**`Y`**`-`**

> A production starting with an `X`**`-`** character and ending with a `Y`**`-`**
> character, where `X`**`-`** and `Y`**`-`** are any of the above prefixes.

`X`**`+`**, `X`**`-`**`Y`**`+`**

> A production as above, with the additional property that the matched content
> [indentation](#indentation-spaces) level is greater than the specified `n` parameter.

<div id="characters" />
# Chapter 5. Characters


<div id="character-set" />
## 5.1. Character Set


To ensure readability, YAML ~~[streams](#undefined)~~ use only the _printable_ subset of the
Unicode character set.
The allowed character range explicitly excludes the C0 control block
**`#x0-#x1F`** (except for TAB **`#x9`**, LF **`#xA`**, and CR **`#xD`** which
are allowed), DEL **`#x7F`**, the C1 control block **`#x80-#x9F`** (except for
NEL **`#x85`** which is allowed), the surrogate block **`#xD800-#xDFFF`**,
**`#xFFFE`**, and **`#xFFFF`**.

On input, a YAML [processor](#processing-yaml-information) must accept all Unicode characters except those
explicitly excluded above.

On output, a YAML [processor](#processing-yaml-information) must only produce acceptable characters.
Any excluded characters must be ~~[presented](#undefined)~~ using ~~[escape](#undefined)~~ sequences.
In addition, any allowed characters known to be non-printable should also be
~~[escaped](#undefined)~~.
This isn’t mandatory since a full implementation would require extensive
character property tables.

<div id="rule-c-printable" />
<pre class="rule">
[1] c-printable ::=
    #x9 | #xA | #xD | [#x20-#x7E]          /* 8 bit */
  | #x85 | [#xA0-#xD7FF] | [#xE000-#xFFFD] /* 16 bit */
  | [#x10000-#x10FFFF]                     /* 32 bit */
</pre>

To ensure ~~[JSON compatibility](#undefined)~~, YAML ~~[processors](#undefined)~~ must allow all non-control
characters inside ~~[quoted scalars](#undefined)~~.
To ensure readability, non-printable characters should be ~~[escaped](#undefined)~~ on output,
even inside such ~~[scalars](#undefined)~~.
Note that JSON ~~[quoted scalars](#undefined)~~ cannot span multiple lines or contain ~~[tabs](#undefined)~~,
but YAML ~~[quoted scalars](#undefined)~~ can.

<div id="rule-nb-json" />
<pre class="rule">
[2] nb-json ::=
  #x9 | [#x20-#x10FFFF]
</pre>

<div id="character-encodings" />
## 5.2. Character Encodings


All characters mentioned in this specification are Unicode code points.
Each such code point is written as one or more bytes depending on the
_character encoding_ used.
Note that in UTF-16, characters above **`#xFFFF`** are written as four bytes,
using a surrogate pair.

The character encoding is a ~~[presentation detail](#undefined)~~ and must not be used to
convey [content](#nodes) information.

On input, a YAML [processor](#processing-yaml-information) must support the UTF-8 and UTF-16 character
encodings.
For ~~[JSON compatibility](#undefined)~~, the UTF-32 encodings must also be supported.

If a character [stream](#streams) begins with a _byte order mark_, the character encoding
will be taken to be as as indicated by the byte order mark.
Otherwise, the [stream](#streams) must begin with an ASCII character.
This allows the encoding to be deduced by the pattern of null (**`#x00`**)
characters.

To make it easier to concatenate ~~[streams](#undefined)~~, byte order marks may appear at the
start of any ~~[document](#undefined)~~.
However all [documents](#document) in the same [stream](#streams) must use the same character
encoding.

To allow for ~~[JSON compatibility](#undefined)~~, byte order marks are also allowed inside
~~[quoted scalars](#undefined)~~.
For readability, such [content](#nodes) byte order marks should be ~~[escaped](#undefined)~~ on output.

The encoding can therefore be deduced by matching the first few bytes of the
[stream](#streams) with the following table rows (in order):

|   | Byte0 | Byte1 | Byte2 | Byte3 | Encoding
| -- | -- | -- | -- | -- | --
| Explicit BOM | #x00 | #x00 | #xFE | #xFF | UTF-32BE
| ASCII first character | #x00 | #x00 | #x00 | any | UTF-32BE
| Explicit BOM | #xFF | #xFE | #x00 | #x00 | UTF-32LE
| ASCII first character | any | #x00 | #x00 | #x00 | UTF-32LE
| Explicit BOM | #xFE | #xFF |   |   | UTF-16BE
| ASCII first character | #x00 | any |   |   | UTF-16BE
| Explicit BOM | #xFF | #xFE |   |   | UTF-16LE
| ASCII first character | any | #x00 |   |   | UTF-16LE
| Explicit BOM | #xEF | #xBB | #xBF |   | UTF-8
| Default |   |   |   |   | UTF-8

The recommended output encoding is UTF-8.
If another encoding is used, it is recommended that an explicit byte order mark
be used, even if the first [stream](#streams) character is ASCII.

For more information about the byte order mark and the Unicode character
encoding schemes see the [Unicode
FAQ](http://www.unicode.org/unicode/faq/utf_bom.html).

<div id="rule-c-byte-order-mark" />
<pre class="rule">
[3] c-byte-order-mark ::= #xFEFF
</pre>

In the examples, byte order mark characters are displayed as "**`⇔`**".

<div id="example-byte-order-mark" class="example">
**Example 5.1 Byte Order Mark**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">⇔</code># Comment only.
</pre>

</td>
<td class="side-by-side">
<pre>
# This stream contains no
# documents, only comments.
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-byte-order-mark">c-byte-order-mark</a></code>
</div>
</div>

<div id="example-invalid-byte-order-mark" class="example">
**Example 5.2 Invalid Byte Order Mark**

<table width="100%">
<tr>
<td class="side-by-side">
<pre class="error">
- Invalid use of BOM
⇔
- Inside a document.
</pre>

</td>
<td class="side-by-side">
<pre class="error">
ERROR:
 A BOM must not appear
 inside a document.
</pre>

</td>
</tr>
</table>
</div>

<div id="indicator-characters" />
## 5.3. Indicator Characters


_Indicators_ are characters that have special semantics.

A ~~["**`-`**"](#undefined)~~ (**`#x2D`**, hyphen) denotes a ~~[block sequence](#undefined)~~ entry.

<div id="rule-c-sequence-entry" />
<pre class="rule">
[4] c-sequence-entry ::= "-"
</pre>

A ~~["**`?`**"](#undefined)~~ (**`#x3F`**, question mark) denotes a ~~[mapping key](#undefined)~~.

<div id="rule-c-mapping-key" />
<pre class="rule">
[5] c-mapping-key ::= "?"
</pre>

A ~~["**`:`**"](#undefined)~~ (**`#x3A`**, colon) denotes a ~~[mapping value](#undefined)~~.

<div id="rule-c-mapping-value" />
<pre class="rule">
[6] c-mapping-value ::= ":"
</pre>

<div id="example-block-structure-indicators" class="example">
**Example 5.3 Block Structure Indicators**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
sequence<code class="legend-3">:</code>
<code class="legend-1">-</code> one
<code class="legend-1">-</code> two
mapping<code class="legend-3">:</code>
  <code class="legend-2">?</code> sky
  <code class="legend-3">:</code> blue
  sea <code class="legend-3">:</code> green
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "sequence"
  : !!seq [ !!str "one", !!str "two" ],
  ? !!str "mapping"
  : !!map {
    ? !!str "sky" : !!str "blue",
    ? !!str "sea" : !!str "green",
  },
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-sequence-entry">c-sequence-entry</a></code>
> * <code class="legend-2"><a href="#rule-c-mapping-key">c-mapping-key</a></code>
> * <code class="legend-3"><a href="#rule-c-mapping-value">c-mapping-value</a></code>
</div>
</div>

A ~~["**`,`**"](#undefined)~~ (**`#x2C`**, comma) ends a ~~[flow collection](#undefined)~~ entry.

<div id="rule-c-collect-entry" />
<pre class="rule">
[7] c-collect-entry ::= ","
</pre>

A ~~["**`[`**"](#undefined)~~ (**`#x5B`**, left bracket) starts a ~~[flow sequence](#undefined)~~.

<div id="rule-c-sequence-start" />
<pre class="rule">
[8] c-sequence-start ::= "["
</pre>

A ["**`]`**"] (**`#x5D`**, right bracket) ends a ~~[flow sequence](#undefined)~~.

<div id="rule-c-sequence-end" />
<pre class="rule">
[9] c-sequence-end ::= "]"
</pre>

A ~~["**`{`**"](#undefined)~~ (**`#x7B`**, left brace) starts a ~~[flow mapping](#undefined)~~.

<div id="rule-c-mapping-start" />
<pre class="rule">
[10] c-mapping-start ::= "{"
</pre>

A ~~["**`}`**"](#undefined)~~ (**`#x7D`**, right brace) ends a ~~[flow mapping](#undefined)~~.

<div id="rule-c-mapping-end" />
<pre class="rule">
[11] c-mapping-end ::= "}"
</pre>

<div id="example-flow-collection-indicators" class="example">
**Example 5.4 Flow Collection Indicators**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
sequence: <code class="legend-1">[</code> one<code class="legend-3">,</code> two<code class="legend-3">,</code> <code class="legend-1">]</code>
mapping: <code class="legend-2">{</code> sky: blue<code class="legend-3">,</code> sea: green <code class="legend-2">}</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "sequence"
  : !!seq [ !!str "one", !!str "two" ],
  ? !!str "mapping"
  : !!map {
    ? !!str "sky" : !!str "blue",
    ? !!str "sea" : !!str "green",
  },
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-sequence-start">c-sequence-start</a></code> <code class="legend-1"><a href="#rule-c-sequence-end">c-sequence-end</a></code>
> * <code class="legend-2"><a href="#rule-c-mapping-start">c-mapping-start</a></code> <code class="legend-2"><a href="#rule-c-mapping-end">c-mapping-end</a></code>
> * <code class="legend-3"><a href="#rule-c-collect-entry">c-collect-entry</a></code>
</div>
</div>

An ~~["**`#`**"](#undefined)~~ (**`#x23`**, octothorpe, hash, sharp, pound, number sign)
denotes a ~~[comment](#undefined)~~.

<div id="rule-c-comment" />
<pre class="rule">
[12] c-comment ::= "#"
</pre>

<div id="example-comment-indicator" class="example">
**Example 5.5 Comment Indicator**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">#</code> Comment only.
</pre>

</td>
<td class="side-by-side">
<pre>
# This stream contains no
# documents, only comments.
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-comment">c-comment</a></code>
</div>
</div>

An ~~["**`&`**"](#undefined)~~ (**`#x26`**, ampersand) denotes a ~~[node’s anchor property](#undefined)~~.

<div id="rule-c-anchor" />
<pre class="rule">
[13] c-anchor ::= "&amp;"
</pre>

An ~~["**`*`**"](#undefined)~~ (**`#x2A`**, asterisk) denotes an ~~[alias node](#undefined)~~.

<div id="rule-c-alias" />
<pre class="rule">
[14] c-alias ::= "*"
</pre>

The ~~["**`!`**"](#undefined)~~ (**`#x21`**, exclamation) is heavily overloaded for specifying
~~[node tags](#undefined)~~.
It is used to denote ~~[tag handles](#undefined)~~ used in ~~[tag directives](#undefined)~~ and ~~[tag
properties](#undefined)~~; to denote ~~[local tags](#undefined)~~; and as the ~~[non-specific tag](#undefined)~~ for
non-~~[plain scalars](#undefined)~~.

<div id="rule-c-tag" />
<pre class="rule">
[15] c-tag ::= "!"
</pre>

<div id="example-node-property-indicators" class="example">
**Example 5.6 Node Property Indicators**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
anchored: <code class="legend-1">!</code>local <code class="legend-2">&amp;</code>anchor value
alias: <code class="legend-3">*</code>anchor
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "anchored"
  : !local &amp;A1 "value",
  ? !!str "alias"
  : *A1,
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-tag">c-tag</a></code>
> * <code class="legend-2"><a href="#rule-c-anchor">c-anchor</a></code>
> * <code class="legend-3"><a href="#rule-c-alias">c-alias</a></code>
</div>
</div>

A ~~["**`|`**"](#undefined)~~ (**`7C`**, vertical bar) denotes a [literal block scalar](#literal-style).

<div id="rule-c-literal" />
<pre class="rule">
[16] c-literal ::= "|"
</pre>

A ~~["**`>`**"](#undefined)~~ (**`#x3E`**, greater than) denotes a ~~[folded block scalar](#undefined)~~.

<div id="rule-c-folded" />
<pre class="rule">
[17] c-folded ::= "&gt;"
</pre>

<div id="example-block-scalar-indicators" class="example">
**Example 5.7 Block Scalar Indicators**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
literal: <code class="legend-1">|</code>
  some
  text
folded: <code class="legend-2">&gt;</code>
  some
  text
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "literal"
  : !!str "some\ntext\n",
  ? !!str "folded"
  : !!str "some text\n",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-literal">c-literal</a></code>
> * <code class="legend-2"><a href="#rule-c-folded">c-folded</a></code>
</div>
</div>

An ~~["**`'`**"](#undefined)~~ (**`#x27`**, apostrophe, single quote) surrounds a
~~[single-quoted flow scalar](#undefined)~~.

<div id="rule-c-single-quote" />
<pre class="rule">
[18] c-single-quote ::= "'"
</pre>

A ~~["**`"`**"](#undefined)~~ (**`#x22`**, double quote) surrounds a ~~[double-quoted flow
scalar](#undefined)~~.

<div id="rule-c-double-quote" />
<pre class="rule">
[19] c-double-quote ::= """
</pre>

<div id="example-quoted-scalar-indicators" class="example">
**Example 5.8 Quoted Scalar Indicators**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
single: <code class="legend-1">'</code>text<code class="legend-1">'</code>
double: <code class="legend-2">"</code>text<code class="legend-2">"</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "single"
  : !!str "text",
  ? !!str "double"
  : !!str "text",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-single-quote">c-single-quote</a></code>
> * <code class="legend-2"><a href="#rule-c-double-quote">c-double-quote</a></code>
</div>
</div>

A ~~["**`%`**"](#undefined)~~ (**`#x25`**, percent) denotes a ~~[directive](#undefined)~~ line.

<div id="rule-c-directive" />
<pre class="rule">
[20] c-directive ::= "%"
</pre>

<div id="example-directive-indicator" class="example">
**Example 5.9 Directive Indicator**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">%</code>YAML 1.2
--- text
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "text"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-directive">c-directive</a></code>
</div>
</div>

The _"**`@`**"_ (**`#x40`**, at) and _"**<code>&grave;</code>**"_ (**`#x60`**,
grave accent) are _reserved_ for future use.

<div id="rule-c-reserved" />
<pre class="rule">
[21] c-reserved ::=
  "@" | "`"
</pre>

<div id="example-invalid-use-of-reserved-indicators" class="example">
**Example 5.10 Invalid use of Reserved Indicators**

<table width="100%">
<tr>
<td class="side-by-side">
<pre class="error">
commercial-at: @text
grave-accent: text
</pre>

</td>
<td class="side-by-side">
<pre class="error">
ERROR:
 Reserved indicators can't
 start a plain scalar.
</pre>

</td>
</tr>
</table>
</div>

Any indicator character:

<div id="rule-c-indicator" />
<pre class="rule">
[22] c-indicator ::=
    "-" | "?" | ":" | "," | "[" | "]" | "{" | "}"
  | "#" | "&amp;" | "*" | "!" | "|" | "&gt;" | "'" | """
  | "%" | "@" | "`"
</pre>

The ~~["**`[`**"](#undefined)~~, ["**`]`**"], ~~["**`{`**"](#undefined)~~, ~~["**`}`**"](#undefined)~~ and ~~["**`,`**"](#undefined)~~
indicators denote structure in ~~[flow collections](#undefined)~~.
They are therefore forbidden in some cases, to avoid ambiguity in several
constructs.
This is handled on a case-by-case basis by the relevant productions.

<div id="rule-c-flow-indicator" />
<pre class="rule">
[23] c-flow-indicator ::=
  "," | "[" | "]" | "{" | "}"
</pre>

<div id="line-break-characters" />
## 5.4. Line Break Characters


YAML recognizes the following ASCII _line break_ characters.

<div id="rule-b-line-feed" />
<pre class="rule">
[24] b-line-feed ::=
  #xA    /* LF */
</pre>

<div id="rule-b-carriage-return" />
<pre class="rule">
[25] b-carriage-return ::=
  #xD    /* CR */
</pre>

<div id="rule-b-char" />
<pre class="rule">
[26] b-char ::=
  b-line-feed | b-carriage-return
</pre>

All other characters, including the form feed (**`#x0C`**), are considered to
be non-break characters.
Note that these include the _non-ASCII line breaks_: next line (**`#x85`**),
line separator (**`#x2028`**) and paragraph separator (**`#x2029`**).

~~[YAML version 1.1](#undefined)~~ did support the above non-ASCII line break characters;
however, JSON does not.
Hence, to ensure ~~[JSON compatibility](#undefined)~~, YAML treats them as non-break characters
as of version 1.2.
In theory this would cause incompatibility with ~~[version 1.1](#undefined)~~; in practice
these characters were rarely (if ever) used.
YAML 1.2 ~~[processors](#undefined)~~ ~~[parsing](#undefined)~~ a ~~[version 1.1](#undefined)~~ ~~[document](#undefined)~~ should therefore
treat these line breaks as non-break characters, with an appropriate warning.

<div id="rule-nb-char" />
<pre class="rule">
[27] nb-char ::=
  c-printable - b-char - c-byte-order-mark
</pre>

Line breaks are interpreted differently by different systems, and have several
widely used formats.

<div id="rule-b-break" />
<pre class="rule">
[28] b-break ::=
    ( b-carriage-return b-line-feed ) /* DOS, Windows */
  | b-carriage-return                 /* MacOS upto 9.x */
  | b-line-feed                       /* UNIX, MacOS X */
</pre>

Line breaks inside [scalar content](#scalar) must be _normalized_ by the YAML [processor](#processing-yaml-information).
Each such line break must be ~~[parsed](#undefined)~~ into a single line feed character.
The original line break format is a ~~[presentation detail](#undefined)~~ and must not be used
to convey [content](#nodes) information.

<div id="rule-b-as-line-feed" />
<pre class="rule">
[29] b-as-line-feed ::= b-break
</pre>

Outside [scalar content](#scalar), YAML allows any line break to be used to terminate
lines.

<div id="rule-b-non-content" />
<pre class="rule">
[30] b-non-content ::= b-break
</pre>

On output, a YAML [processor](#processing-yaml-information) is free to emit line breaks using whatever
convention is most appropriate.

In the examples, line breaks are sometimes displayed using the "**`↓`**" glyph
for clarity.

<div id="example-line-break-characters" class="example">
**Example 5.11 Line Break Characters**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
|
  Line break (no glyph)
  Line break (glyphed)<code class="legend-1">↓</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "line break (no glyph)\n\
      line break (glyphed)\n"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-b-break">b-break</a></code>
</div>
</div>

<div id="white-space-characters" />
## 5.5. White Space Characters


YAML recognizes two _white space_ characters: _space_ and _tab_.

<div id="rule-s-space" />
<pre class="rule">
[31] s-space ::=
  #x20 /* SP */
</pre>

<div id="rule-s-tab" />
<pre class="rule">
[32] s-tab ::=
  #x9  /* TAB */
</pre>

<div id="rule-s-white" />
<pre class="rule">
[33] s-white ::=
  s-space | s-tab
</pre>

The rest of the ([printable](#character-set)) non-[break](#line-break-characters) characters are considered to be
non-space characters.

<div id="rule-ns-char" />
<pre class="rule">
[34] ns-char ::=
  nb-char - s-white
</pre>

In the examples, tab characters are displayed as the glyph "**`→`**".
Space characters are sometimes displayed as the glyph "**`·`**" for clarity.

<div id="example-tabs-and-spaces" class="example">
**Example 5.12 Tabs and Spaces**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
# Tabs and spaces
quoted:<code class="legend-1">·</code>"Quoted <code class="legend-2">→</code>"
block:<code class="legend-2">→</code>|
<code class="legend-1">··</code>void main() {
<code class="legend-1">··</code><code class="legend-2">→</code>printf("Hello, world!\n");
<code class="legend-1">··</code>}
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "quoted"
  : "Quoted \t",
  ? !!str "block"
  : "void main() {\n\
    \tprintf(\"Hello, world!\\n\");\n\
    }\n",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-space">s-space</a></code>
> * <code class="legend-2"><a href="#rule-s-tab">s-tab</a></code>
</div>
</div>

<div id="miscellaneous-characters" />
## 5.6. Miscellaneous Characters


The YAML syntax productions make use of the following additional character
classes:

* A decimal digit for numbers:

<div id="rule-ns-dec-digit" />
<pre class="rule">
[35] ns-dec-digit ::=
  [#x30-#x39] /* 0-9 */
</pre>

* A hexadecimal digit for ~~[escape sequences](#undefined)~~:

<div id="rule-ns-hex-digit" />
<pre class="rule">
[36] ns-hex-digit ::=
    ns-dec-digit
  | [#x41-#x46] /* A-F */ | [#x61-#x66] /* a-f */
</pre>

* ASCII letter (alphabetic) characters:

<div id="rule-ns-ascii-letter" />
<pre class="rule">
[37] ns-ascii-letter ::=
  [#x41-#x5A] /* A-Z */ | [#x61-#x7A] /* a-z */
</pre>

* Word (alphanumeric) characters for identifiers:

<div id="rule-ns-word-char" />
<pre class="rule">
[38] ns-word-char ::=
  ns-dec-digit | ns-ascii-letter | "-"
</pre>

* URI characters for ~~[tags](#undefined)~~, as specified in
  [RFC2396](http://www.ietf.org/rfc/rfc2396.txt), with the addition of the
  "**`[`**" and "**`]`**" for presenting IPv6 addresses as proposed in
  [RFC2732](http://www.ietf.org/rfc/rfc2732.txt).

  By convention, any URI characters other than the allowed printable ASCII
  characters are first _encoded_ in UTF-8, and then each byte is _escaped_
  using the _"**`%`**"_ character.
  The YAML [processor](#processing-yaml-information) must not expand such escaped characters. [Tag](#tags)
  characters must be preserved and compared exactly as ~~[presented](#undefined)~~ in the YAML
  [stream](#streams), without any processing.

<div id="rule-ns-uri-char" />
<pre class="rule">
[39] ns-uri-char ::=
    "%" ns-hex-digit ns-hex-digit | ns-word-char | "#"
  | ";" | "/" | "?" | ":" | "@" | "&amp;" | "=" | "+" | "$" | ","
  | "_" | "." | "!" | "~" | "*" | "'" | "(" | ")" | "[" | "]"
</pre>

* The ~~["**`!`**"](#undefined)~~ character is used to indicate the end of a ~~[named tag
  handle](#undefined)~~; hence its use in ~~[tag shorthands](#undefined)~~ is restricted.
  In addition, such ~~[shorthands](#undefined)~~ must not contain the ~~["**`[`**"](#undefined)~~, ["**`]`**"],
  ~~["**`{`**"](#undefined)~~, ~~["**`}`**"](#undefined)~~ and ~~["**`,`**"](#undefined)~~ characters.
  These characters would cause ambiguity with ~~[flow collection](#undefined)~~ structures.

<div id="rule-ns-tag-char" />
<pre class="rule">
[40] ns-tag-char ::=
  ns-uri-char - "!" - c-flow-indicator
</pre>

<div id="escaped-characters" />
## 5.7. Escaped Characters


All non-[printable](#character-set) characters must be _escaped_.
YAML escape sequences use the _"**`\`**"_ notation common to most modern
computer languages.
Each escape sequence must be ~~[parsed](#undefined)~~ into the appropriate Unicode character.
The original escape sequence is a ~~[presentation detail](#undefined)~~ and must not be used to
convey [content](#nodes) information.

Note that escape sequences are only interpreted in ~~[double-quoted scalars](#undefined)~~.
In all other ~~[scalar styles](#undefined)~~, the "**`\`**" character has no special meaning
and non-[printable](#character-set) characters are not available.

<div id="rule-c-escape" />
<pre class="rule">
[41] c-escape ::= "\"
</pre>

YAML escape sequences are a superset of C’s escape sequences:

Escaped ASCII null (**`#x0`**) character.

<div id="rule-ns-esc-null" />
<pre class="rule">
[42] ns-esc-null ::= "0"
</pre>

Escaped ASCII bell (**`#x7`**) character.

<div id="rule-ns-esc-bell" />
<pre class="rule">
[43] ns-esc-bell ::= "a"
</pre>

Escaped ASCII backspace (**`#x8`**) character.

<div id="rule-ns-esc-backspace" />
<pre class="rule">
[44] ns-esc-backspace ::= "b"
</pre>

Escaped ASCII horizontal tab (**`#x9`**) character.
This is useful at the start or the end of a line to force a leading or trailing
tab to become part of the [content](#nodes).

<div id="rule-ns-esc-horizontal-tab" />
<pre class="rule">
[45] ns-esc-horizontal-tab ::=
  "t" | #x9
</pre>

Escaped ASCII line feed (**`#xA`**) character.

<div id="rule-ns-esc-line-feed" />
<pre class="rule">
[46] ns-esc-line-feed ::= "n"
</pre>

Escaped ASCII vertical tab (**`#xB`**) character.

<div id="rule-ns-esc-vertical-tab" />
<pre class="rule">
[47] ns-esc-vertical-tab ::= "v"
</pre>

Escaped ASCII form feed (**`#xC`**) character.

<div id="rule-ns-esc-form-feed" />
<pre class="rule">
[48] ns-esc-form-feed ::= "f"
</pre>

Escaped ASCII carriage return (**`#xD`**) character.

<div id="rule-ns-esc-carriage-return" />
<pre class="rule">
[49] ns-esc-carriage-return ::= "r"
</pre>

Escaped ASCII escape (**`#x1B`**) character.

<div id="rule-ns-esc-escape" />
<pre class="rule">
[50] ns-esc-escape ::= "e"
</pre>

Escaped ASCII space (**`#x20`**) character.
This is useful at the start or the end of a line to force a leading or trailing
space to become part of the [content](#nodes).

<div id="rule-ns-esc-space" />
<pre class="rule">
[51] ns-esc-space ::= #x20
</pre>

Escaped ASCII double quote (**`#x22`**).

<div id="rule-ns-esc-double-quote" />
<pre class="rule">
[52] ns-esc-double-quote ::= """
</pre>

Escaped ASCII slash (**`#x2F`**), for ~~[JSON compatibility](#undefined)~~.

<div id="rule-ns-esc-slash" />
<pre class="rule">
[53] ns-esc-slash ::= "/"
</pre>

Escaped ASCII back slash (**`#x5C`**).

<div id="rule-ns-esc-backslash" />
<pre class="rule">
[54] ns-esc-backslash ::= "\"
</pre>

Escaped Unicode next line (**`#x85`**) character.

<div id="rule-ns-esc-next-line" />
<pre class="rule">
[55] ns-esc-next-line ::= "N"
</pre>

Escaped Unicode non-breaking space (**`#xA0`**) character.

<div id="rule-ns-esc-non-breaking-space" />
<pre class="rule">
[56] ns-esc-non-breaking-space ::= "_"
</pre>

Escaped Unicode line separator (**`#x2028`**) character.

<div id="rule-ns-esc-line-separator" />
<pre class="rule">
[57] ns-esc-line-separator ::= "L"
</pre>

Escaped Unicode paragraph separator (**`#x2029`**) character.

<div id="rule-ns-esc-paragraph-separator" />
<pre class="rule">
[58] ns-esc-paragraph-separator ::= "P"
</pre>

Escaped 8-bit Unicode character.

<div id="rule-ns-esc-8-bit" />
<pre class="rule">
[59] ns-esc-8-bit ::=
  "x"
  ( ns-hex-digit × 2 )
</pre>

Escaped 16-bit Unicode character.

<div id="rule-ns-esc-16-bit" />
<pre class="rule">
[60] ns-esc-16-bit ::=
  "u"
  ( ns-hex-digit × 4 )
</pre>

Escaped 32-bit Unicode character.

<div id="rule-ns-esc-32-bit" />
<pre class="rule">
[61] ns-esc-32-bit ::=
  "U"
  ( ns-hex-digit × 8 )
</pre>

Any escaped character:

<div id="rule-c-ns-esc-char" />
<pre class="rule">
[62] c-ns-esc-char ::=
  "\"
  ( ns-esc-null | ns-esc-bell | ns-esc-backspace
  | ns-esc-horizontal-tab | ns-esc-line-feed
  | ns-esc-vertical-tab | ns-esc-form-feed
  | ns-esc-carriage-return | ns-esc-escape | ns-esc-space
  | ns-esc-double-quote | ns-esc-slash | ns-esc-backslash
  | ns-esc-next-line | ns-esc-non-breaking-space
  | ns-esc-line-separator | ns-esc-paragraph-separator
  | ns-esc-8-bit | ns-esc-16-bit | ns-esc-32-bit )
</pre>

<div id="example-escaped-characters" class="example">
**Example 5.13 Escaped Characters**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
"Fun with \
<code class="legend-1">\"</code> <code class="legend-1">\a</code> <code class="legend-1">\b</code> <code class="legend-1">\e</code> <code class="legend-1">\f</code> <code class="legend-1">\↓</code>
<code class="legend-1">\n</code> <code class="legend-1">\r</code> <code class="legend-1">\t</code> <code class="legend-1">\v</code> <code class="legend-1">\0</code> <code class="legend-1">\↓</code>
<code class="legend-1">\ </code> _ <code class="legend-1">\N</code> <code class="legend-1">\L</code> <code class="legend-1">\P</code> <code class="legend-1">\↓</code>
<code class="legend-1">\x41</code> <code class="legend-1">\u0041</code> <code class="legend-1">\U00000041</code>"
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
"Fun with \x5C
\x22 \x07 \x08 \x1B \x0C
\x0A \x0D \x09 \x0B \x00
\x20 \xA0 \x85 \u2028 \u2029
A A A"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-ns-esc-char">c-ns-esc-char</a></code>
</div>
</div>

<div id="example-invalid-escaped-characters" class="example">
**Example 5.14 Invalid Escaped Characters**

<table width="100%">
<tr>
<td class="side-by-side">
<pre class="error">
Bad escapes:
  "\c
  \xq-"
</pre>

</td>
<td class="side-by-side">
<pre class="error">
ERROR:
- c is an invalid escaped character.
- q and - are invalid hex digits.
</pre>

</td>
</tr>
</table>
</div>

<div id="basic-structures" />
# Chapter 6. Basic Structures


<div id="indentation-spaces" />
## 6.1. Indentation Spaces


In YAML ~~[block styles](#undefined)~~, structure is determined by _indentation_.
In general, indentation is defined as a zero or more [space](#white-space-characters) characters at the
start of a line.

To maintain portability, ~~[tab](#undefined)~~ characters must not be used in indentation,
since different systems treat ~~[tabs](#undefined)~~ differently.
Note that most modern editors may be configured so that pressing the ~~[tab](#undefined)~~ key
results in the insertion of an appropriate number of [spaces](#white-space-characters).

The amount of indentation is a ~~[presentation detail](#undefined)~~ and must not be used to
convey [content](#nodes) information.

<div id="rule-s-indent(n)" />
<pre class="rule">
[63] s-indent(n) ::=
  s-space × n
</pre>

A ~~[block style](#undefined)~~ construct is terminated when encountering a line which is less
indented than the construct.
The productions use the notation "**`s-indent(<n)`**" and "**`s-indent(≤n)`**"
to express this.

<div id="rule-s-indent(&lt;n)" />
<pre class="rule">
[64] s-indent(&lt;n) ::=
  s-space × m /* Where m &lt; n */
</pre>

<div id="rule-s-indent(≤n)" />
<pre class="rule">
[65] s-indent(≤n) ::=
  s-space × m /* Where m ≤ n */
</pre>

Each [node](#nodes) must be indented further than its parent [node](#nodes).
All sibling ~~[nodes](#undefined)~~ must use the exact same indentation level.
However the [content](#nodes) of each sibling [node](#nodes) may be further indented
independently.

<div id="example-indentation-spaces" class="example">
**Example 6.1 Indentation Spaces**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
··# Leading comment line spaces are
···# neither content nor indentation.
····
Not indented:
<code class="legend-1">·</code>By one space: |
<code class="legend-1">····</code>By four
<code class="legend-1">····</code>··spaces
<code class="legend-1">·</code>Flow style: [    # Leading spaces
<code class="legend-1">··</code>·By two,        # in flow style
<code class="legend-1">··</code>Also by two,    # are neither
<code class="legend-1">··</code>→Still by two   # content nor
<code class="legend-1">··</code>··]             # indentation.
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
- - -
!!map {
  ? !!str "Not indented"
  : !!map {
      ? !!str "By one space"
      : !!str "By four\n  spaces\n",
      ? !!str "Flow style"
      : !!seq [
          !!str "By two",
          !!str "Also by two",
          !!str "Still by two",
        ]
    }
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-indent(n)">s-indent(n)</a></code>
> * Content
> * Neither content nor indentation
</div>
</div>

The ~~["**`-`**"](#undefined)~~, ~~["**`?`**"](#undefined)~~ and ~~["**`:`**"](#undefined)~~ characters used to denote ~~[block
collection](#undefined)~~ entries are perceived by people to be part of the indentation.
This is handled on a case-by-case basis by the relevant productions.

<div id="example-indentation-indicators" class="example">
**Example 6.2 Indentation Indicators**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">?</code>·a
<code class="legend-1">:·-</code>→b
<code class="legend-1">··-··-</code>→c
<code class="legend-1">·····-</code>·d
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "a"
  : !!seq [
    !!str "b",
    !!seq [ !!str "c", !!str "d" ]
  ],
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * Total Indentation
> * <code class="legend-1"><a href="#rule-s-indent(n)">s-indent(n)</a></code>
> * Indicator as indentation
</div>
</div>

<div id="separation-spaces" />
## 6.2. Separation Spaces


Outside [indentation](#indentation-spaces) and [scalar content](#scalar), YAML uses [white space](#white-space-characters) characters
for _separation_ between tokens within a line.
Note that such [white space](#white-space-characters) may safely include ~~[tab](#undefined)~~ characters.

Separation spaces are a ~~[presentation detail](#undefined)~~ and must not be used to convey
[content](#nodes) information.

<div id="rule-s-separate-in-line" />
<pre class="rule">
[66] s-separate-in-line ::=
  s-white+ | /* Start of line */
</pre>

<div id="example-separation-spaces" class="example">
**Example 6.3 Separation Spaces**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
-<code class="legend-1">·</code>foo:<code class="legend-1">→·</code>bar
- -<code class="legend-1">·</code>baz
  -<code class="legend-1">→</code>baz
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!map {
    ? !!str "foo" : !!str "bar",
  },
  !!seq [ !!str "baz", !!str "baz" ],
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-separate-in-line">s-separate-in-line</a></code>
</div>
</div>

<div id="line-prefixes" />
## 6.3. Line Prefixes


Inside [scalar content](#scalar), each line begins with a non-[content](#nodes) _line prefix_.
This prefix always includes the [indentation](#indentation-spaces).
For ~~[flow scalar styles](#undefined)~~ it additionally includes all leading [white space](#white-space-characters),
which may contain ~~[tab](#undefined)~~ characters.

Line prefixes are a ~~[presentation detail](#undefined)~~ and must not be used to convey
[content](#nodes) information.

<div id="rule-s-line-prefix(n,c)" />
<pre class="rule">
[67] s-line-prefix(n,c) ::=
  c = block-out ⇒ s-block-line-prefix(n)
  c = block-in  ⇒ s-block-line-prefix(n)
  c = flow-out  ⇒ s-flow-line-prefix(n)
  c = flow-in   ⇒ s-flow-line-prefix(n)
</pre>

<div id="rule-s-block-line-prefix(n)" />
<pre class="rule">
[68] s-block-line-prefix(n) ::= s-indent(n)
</pre>

<div id="rule-s-flow-line-prefix(n)" />
<pre class="rule">
[69] s-flow-line-prefix(n) ::=
  s-indent(n) s-separate-in-line?
</pre>

<div id="example-line-prefixes" class="example">
**Example 6.4 Line Prefixes**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
plain: text
<code class="legend-1"><code class="legend-3">·</code>·</code>lines
quoted: "text
<code class="legend-1"><code class="legend-3">·</code>·→</code>lines"
block: |
<code class="legend-2"><code class="legend-3">··</code></code>text
<code class="legend-2"><code class="legend-3">··</code></code>·→lines
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "plain"
  : !!str "text lines",
  ? !!str "quoted"
  : !!str "text lines",
  ? !!str "block"
  : !!str "text\n·→lines\n",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-flow-line-prefix(n)">s-flow-line-prefix(n)</a></code>
> * <code class="legend-2"><a href="#rule-s-block-line-prefix(n)">s-block-line-prefix(n)</a></code>
> * <code class="legend-3"><a href="#rule-s-indent(n)">s-indent(n)</a></code>
</div>
</div>

<div id="empty-lines" />
## 6.4. Empty Lines


An _empty line_ line consists of the non-[content](#nodes) ~~[prefix](#undefined)~~ followed by a ~~[line
break](#undefined)~~.

<div id="rule-l-empty(n,c)" />
<pre class="rule">
[70] l-empty(n,c) ::=
  ( s-line-prefix(n,c) | s-indent(&lt;n) )
  b-as-line-feed
</pre>

The semantics of empty lines depend on the ~~[scalar style](#undefined)~~ they appear in.
This is handled on a case-by-case basis by the relevant productions.

<div id="example-empty-lines" class="example">
**Example 6.5 Empty Lines**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
Folding:
  "Empty line
<code class="legend-1">···→</code>
  as a line feed"
Chomping: |
  Clipped empty lines
<code class="legend-1">·</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "Folding"
  : !!str "Empty line\nas a line feed",
  ? !!str "Chomping"
  : !!str "Clipped empty lines\n",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-l-empty(n,c)">l-empty(n,c)</a></code>
</div>
</div>

<div id="line-folding" />
## 6.5. Line Folding


_Line folding_ allows long lines to be broken for readability, while retaining
the semantics of the original long line.
If a [line break](#line-break-characters) is followed by an ~~[empty line](#undefined)~~, it is _trimmed_; the first
[line break](#line-break-characters) is discarded and the rest are retained as [content](#nodes).

<div id="rule-b-l-trimmed(n,c)" />
<pre class="rule">
[71] b-l-trimmed(n,c) ::=
  b-non-content l-empty(n,c)+
</pre>

Otherwise (the following line is not ~~[empty](#undefined)~~), the [line break](#line-break-characters) is converted to
a single [space](#white-space-characters) (**`#x20`**).

<div id="rule-b-as-space" />
<pre class="rule">
[72] b-as-space ::= b-break
</pre>

A folded non-~~[empty line](#undefined)~~ may end with either of the above [line breaks](#line-break-characters).

<div id="rule-b-l-folded(n,c)" />
<pre class="rule">
[73] b-l-folded(n,c) ::=
  b-l-trimmed(n,c) | b-as-space
</pre>

<div id="example-line-folding" class="example">
**Example 6.6 Line Folding**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
&gt;-
  trimmed<code class="legend-1">↓</code>
<code class="legend-1">··↓</code>
<code class="legend-1">·↓</code>
<code class="legend-1">↓</code>
  as<code class="legend-2">↓</code>
  space
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "trimmed\n\n\nas space"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-b-l-trimmed(n,c)">b-l-trimmed(n,c)</a></code>
> * <code class="legend-2"><a href="#rule-b-as-space">b-as-space</a></code>
</div>
</div>

The above rules are common to both the ~~[folded block style](#undefined)~~ and the ~~[scalar
flow styles](#undefined)~~.
Folding does distinguish between these cases in the following way:

##### Block Folding

> In the ~~[folded block style](#undefined)~~, the final [line break](#line-break-characters) and trailing ~~[empty
> lines](#undefined)~~ are subject to ~~[chomping](#undefined)~~, and are never folded.
> In addition, folding does not apply to [line breaks](#line-break-characters) surrounding text lines
> that contain leading [white space](#white-space-characters).
> Note that such a ~~[more-indented](#undefined)~~ line may consist only of such leading ~~[white
> space](#undefined)~~.
>
> The combined effect of the _block line folding_ rules is that each
> "paragraph" is interpreted as a line, ~~[empty lines](#undefined)~~ are interpreted as a line
> feed, and the formatting of ~~[more-indented](#undefined)~~ lines is preserved.

<div id="example-block-folding" class="example">
**Example 6.7 Block Folding**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
&gt;
··foo·<code class="legend-1">↓</code>
<code class="legend-1">·↓</code>
··→·bar<code class="legend-1">↓</code>
<code class="legend-1">↓</code>
··baz↓
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
--- !!str
"foo \n\n\t bar\n\nbaz\n"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-b-l-folded(n,c)">b-l-folded(n,c)</a></code>
> * Non-content spaces Content spaces
</div>
</div>

##### Flow Folding

> Folding in ~~[flow styles](#undefined)~~ provides more relaxed semantics. ~~[Flow styles](#undefined)~~
> typically depend on explicit ~~[indicators](#undefined)~~ rather than [indentation](#indentation-spaces) to convey
> structure.
> Hence spaces preceding or following the text in a line are a ~~[presentation
> detail](#undefined)~~ and must not be used to convey [content](#nodes) information.
> Once all such spaces have been discarded, all [line breaks](#line-break-characters) are folded,
> without exception.
>
> The combined effect of the _flow line folding_ rules is that each "paragraph"
> is interpreted as a line, ~~[empty lines](#undefined)~~ are interpreted as line feeds, and
> text can be freely ~~[more-indented](#undefined)~~ without affecting the [content](#nodes)
> information.

<div id="rule-s-flow-folded(n)" />
<pre class="rule">
[74] s-flow-folded(n) ::=
  s-separate-in-line? b-l-folded(n,flow-in)
  s-flow-line-prefix(n)
</pre>

<div id="example-flow-folding" class="example">
**Example 6.8 Flow Folding**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
"<code class="legend-1">↓</code>
<code class="legend-1">··</code>foo<code class="legend-1">·↓</code>
<code class="legend-1">·↓</code>
<code class="legend-1">··→·</code>bar<code class="legend-1">↓</code>
<code class="legend-1">↓</code>
<code class="legend-1">··</code>baz<code class="legend-1">↓</code> "
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
--- !!str
" foo\nbar\nbaz "
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-flow-folded(n)">s-flow-folded(n)</a></code>
> * Non-content spaces
</div>
</div>

<div id="comments" />
## 6.6. Comments


An explicit _comment_ is marked by a _"**`#`**" indicator_.
Comments are a ~~[presentation detail](#undefined)~~ and must not be used to convey [content](#nodes)
information.

Comments must be [separated](#separation-spaces) from other tokens by [white space](#white-space-characters) characters.
To ensure ~~[JSON compatibility](#undefined)~~, YAML ~~[processors](#undefined)~~ must allow for the omission
of the final comment [line break](#line-break-characters) of the input [stream](#streams).
However, as this confuses many tools, YAML ~~[processors](#undefined)~~ should terminate the
[stream](#streams) with an explicit [line break](#line-break-characters) on output.

<div id="rule-c-nb-comment-text" />
<pre class="rule">
[75] c-nb-comment-text ::=
  "#" nb-char*
</pre>

<div id="rule-b-comment" />
<pre class="rule">
[76] b-comment ::=
  b-non-content | /* End of file */
</pre>

<div id="rule-s-b-comment" />
<pre class="rule">
[77] s-b-comment ::=
  ( s-separate-in-line c-nb-comment-text? )?
  b-comment
</pre>

<div id="example-separated-comment" class="example">
**Example 6.9 Separated Comment**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
key:<code class="legend-3">····<code class="legend-1"># Comment</code><code class="legend-2">↓</code></code>
  value<code class="legend-3">_eo</code>f_
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "key"
  : !!str "value",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-nb-comment-text">c-nb-comment-text</a></code>
> * <code class="legend-2"><a href="#rule-b-comment">b-comment</a></code>
> * <code class="legend-3"><a href="#rule-s-b-comment">s-b-comment</a></code>
</div>
</div>

Outside [scalar content](#scalar), comments may appear on a line of their own,
independent of the [indentation](#indentation-spaces) level.
Note that outside [scalar content](#scalar), a line containing only [white space](#white-space-characters)
characters is taken to be a comment line.

<div id="rule-l-comment" />
<pre class="rule">
[78] l-comment ::=
  s-separate-in-line c-nb-comment-text? b-comment
</pre>

<div id="example-comment-lines" class="example">
**Example 6.10 Comment Lines**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-2">··<code class="legend-1"># Comment↓</code></code>
<code class="legend-2">···<code class="legend-1">↓</code></code>
<code class="legend-1"><code class="legend-2">↓</code></code>
</pre>

</td>
<td class="side-by-side">
<pre>
# This stream contains no
# documents, only comments.
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-b-comment">s-b-comment</a></code>
> * <code class="legend-2"><a href="#rule-l-comment">l-comment</a></code>
</div>
</div>

In most cases, when a line may end with a comment, YAML allows it to be
followed by additional comment lines.
The only exception is a comment ending a ~~[block scalar header](#undefined)~~.

<div id="rule-s-l-comments" />
<pre class="rule">
[79] s-l-comments ::=
  ( s-b-comment | /* Start of line */ )
  l-comment*
</pre>

<div id="example-multi-line-comments" class="example">
**Example 6.11 Multi-Line Comments**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
key:<code class="legend-1"><code class="legend-3">····# Comment↓</code></code>
<code class="legend-2"><code class="legend-3">········# lines↓</code></code>
  value<code class="legend-1"><code class="legend-3">↓</code></code>
<code class="legend-2"><code class="legend-3">↓</code></code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "key"
  : !!str "value",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-b-comment">s-b-comment</a></code>
> * <code class="legend-2"><a href="#rule-l-comment">l-comment</a></code>
> * <code class="legend-3"><a href="#rule-s-l-comments">s-l-comments</a></code>
</div>
</div>

<div id="separation-lines" />
## 6.7. Separation Lines


~~[Implicit keys](#undefined)~~ are restricted to a single line.
In all other cases, YAML allows tokens to be separated by multi-line (possibly
empty) ~~[comments](#undefined)~~.

Note that structures following multi-line comment separation must be properly
[indented](#indentation-spaces), even though there is no such restriction on the separation
~~[comment](#undefined)~~ lines themselves.

<div id="rule-s-separate(n,c)" />
<pre class="rule">
[80] s-separate(n,c) ::=
  c = block-out ⇒ s-separate-lines(n)
  c = block-in  ⇒ s-separate-lines(n)
  c = flow-out  ⇒ s-separate-lines(n)
  c = flow-in   ⇒ s-separate-lines(n)
  c = block-key ⇒ s-separate-in-line
  c = flow-key  ⇒ s-separate-in-line
</pre>

<div id="rule-s-separate-lines(n)" />
<pre class="rule">
[81] s-separate-lines(n) ::=
    ( s-l-comments s-flow-line-prefix(n) )
  | s-separate-in-line
</pre>

<div id="example-separation-spaces" class="example">
**Example 6.12 Separation Spaces**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
{<code class="legend-1">·</code>first:<code class="legend-1">·</code>Sammy,<code class="legend-1">·</code>last:<code class="legend-1">·</code>Sosa<code class="legend-1">·</code>}:<code class="legend-2">↓</code>
<code class="legend-2"># Statistics:</code>
<code class="legend-2"><code class="legend-3">··</code></code>hr:<code class="legend-2">··# Home runs</code>
<code class="legend-2"><code class="legend-3">···</code>··</code>65
<code class="legend-3">··</code>avg:<code class="legend-2">·# Average</code>
<code class="legend-2"><code class="legend-3">···</code></code>0.278
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!map {
    ? !!str "first"
    : !!str "Sammy",
    ? !!str "last"
    : !!str "Sosa",
  }
  : !!map {
    ? !!str "hr"
    : !!int "65",
    ? !!str "avg"
    : !!float "0.278",
  },
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-separate-in-line">s-separate-in-line</a></code>
> * <code class="legend-2"><a href="#rule-s-separate-lines(n)">s-separate-lines(n)</a></code>
> * <code class="legend-3"><a href="#rule-s-indent(n)">s-indent(n)</a></code>
</div>
</div>

<div id="directives" />
## 6.8. Directives


_Directives_ are instructions to the YAML [processor](#processing-yaml-information).
This specification defines two directives, ~~["**`YAML`**"](#undefined)~~ and ~~["**`TAG`**"](#undefined)~~,
and _reserves_ all other directives for future use.
There is no way to define private directives.
This is intentional.

Directives are a ~~[presentation detail](#undefined)~~ and must not be used to convey [content](#nodes)
information.

<div id="rule-l-directive" />
<pre class="rule">
[82] l-directive ::=
  "%"
  ( ns-yaml-directive
  | ns-tag-directive
  | ns-reserved-directive )
  s-l-comments
</pre>

Each directive is specified on a separate non-[indented](#indentation-spaces) line starting with the
_"**`%`**" indicator_, followed by the directive name and a list of parameters.
The semantics of these parameters depends on the specific directive.
A YAML [processor](#processing-yaml-information) should ignore unknown directives with an appropriate
warning.

<div id="rule-ns-reserved-directive" />
<pre class="rule">
[83] ns-reserved-directive ::=
  ns-directive-name
  ( s-separate-in-line ns-directive-parameter )*
</pre>

<div id="rule-ns-directive-name" />
<pre class="rule">
[84] ns-directive-name ::= ns-char+
</pre>

<div id="rule-ns-directive-parameter" />
<pre class="rule">
[85] ns-directive-parameter ::= ns-char+
</pre>

<div id="example-reserved-directives" class="example">
**Example 6.13 Reserved Directives**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
%<code class="legend-1"><code class="legend-2">FOO</code>  <code class="legend-3">bar</code> <code class="legend-3">baz</code></code> # Should be ignored
               # with a warning.
--- "foo"
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
--- !!str
"foo"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-reserved-directive">ns-reserved-directive</a></code>
> * <code class="legend-2"><a href="#rule-ns-directive-name">ns-directive-name</a></code>
> * <code class="legend-3"><a href="#rule-ns-directive-parameter">ns-directive-parameter</a></code>
</div>
</div>

<div id="yaml-directives" />
### 6.8.1. "**`YAML`**" Directives


The _"**`YAML`**" directive_ specifies the version of YAML the ~~[document](#undefined)~~
conforms to.
This specification defines version "**`1.2`**", including recommendations for
_YAML 1.1 processing_.

A version 1.2 YAML [processor](#processing-yaml-information) must accept [documents](#document) with an explicit
"**`%YAML 1.2`**" directive, as well as [documents](#document) lacking a "**`YAML`**"
directive.
Such [documents](#document) are assumed to conform to the 1.2 version specification.
[Documents](#document) with a "**`YAML`**" directive specifying a higher minor version
(e.g. "**`%YAML 1.3`**") should be processed with an appropriate warning.
[Documents](#document) with a "**`YAML`**" directive specifying a higher major version
(e.g. "**`%YAML 2.0`**") should be rejected with an appropriate error message.

A version 1.2 YAML [processor](#processing-yaml-information) must also accept [documents](#document) with an explicit
"**`%YAML 1.1`**" directive.
Note that version 1.2 is mostly a superset of version 1.1, defined for the
purpose of ensuring _JSON compatibility_.
Hence a version 1.2 [processor](#processing-yaml-information) should process version 1.1 [documents](#document) as if
they were version 1.2, giving a warning on points of incompatibility (handling
of ~~[non-ASCII line breaks](#undefined)~~, as described ~~[above](#undefined)~~).

<div id="rule-ns-yaml-directive" />
<pre class="rule">
[86] ns-yaml-directive ::=
  "Y" "A" "M" "L"
  s-separate-in-line ns-yaml-version
</pre>

<div id="rule-ns-yaml-version" />
<pre class="rule">
[87] ns-yaml-version ::=
  ns-dec-digit+ "." ns-dec-digit+
</pre>

<div id="example-yaml-directive" class="example">
**Example 6.14 "**`YAML`**" directive**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
%<code class="legend-1">YAML <code class="legend-2">1.3</code></code> # Attempt parsing
           # with a warning
---
"foo"
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "foo"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-yaml-directive">ns-yaml-directive</a></code>
> * <code class="legend-2"><a href="#rule-ns-yaml-version">ns-yaml-version</a></code>
</div>
</div>

It is an error to specify more than one "**`YAML`**" directive for the same
document, even if both occurrences give the same version number.

<div id="example-invalid-repeated-yaml-directive" class="example">
**Example 6.15 Invalid Repeated YAML directive**

<table width="100%">
<tr>
<td class="side-by-side">
<pre class="error">
%YAML 1.2
%YAML 1.1
foo
</pre>

</td>
<td class="side-by-side">
<pre class="error">
ERROR:
The YAML directive must only be
given at most once per document.
</pre>

</td>
</tr>
</table>
</div>

<div id="tag-directives" />
### 6.8.2. "**`TAG`**" Directives


The _"**`TAG`**" directive_ establishes a ~~[tag shorthand](#undefined)~~ notation for
specifying ~~[node tags](#undefined)~~.
Each "**`TAG`**" directive associates a ~~[handle](#undefined)~~ with a ~~[prefix](#undefined)~~.
This allows for compact and readable [tag](#tags) notation.

<div id="rule-ns-tag-directive" />
<pre class="rule">
[88] ns-tag-directive ::=
  "T" "A" "G"
  s-separate-in-line c-tag-handle
  s-separate-in-line ns-tag-prefix
</pre>

<div id="example-tag-directive" class="example">
**Example 6.16 "**`TAG`**" directive**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
%<code class="legend-1">TAG <code class="legend-2">!yaml!</code> <code class="legend-3">tag:yaml.org,2002:</code></code>
---
!yaml!str "foo"
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "foo"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-tag-directive">ns-tag-directive</a></code>
> * <code class="legend-2"><a href="#rule-c-tag-handle">c-tag-handle</a></code>
> * <code class="legend-3"><a href="#rule-ns-tag-prefix">ns-tag-prefix</a></code>
</div>
</div>

It is an error to specify more than one "**`TAG`**" directive for the same
~~[handle](#undefined)~~ in the same document, even if both occurrences give the same ~~[prefix](#undefined)~~.

<div id="example-invalid-repeated-tag-directive" class="example">
**Example 6.17 Invalid Repeated TAG directive**

<table width="100%">
<tr>
<td class="side-by-side">
<pre class="error">
%TAG ! !foo
%TAG ! !foo
bar
</pre>

</td>
<td class="side-by-side">
<pre class="error">
ERROR:
The TAG directive must only
be given at most once per
handle in the same document.
</pre>

</td>
</tr>
</table>
</div>

<div id="tag-handles" />
#### 6.8.2.1. Tag Handles


The _tag handle_ exactly matches the prefix of the affected ~~[tag shorthand](#undefined)~~.
There are three tag handle variants:

<div id="rule-c-tag-handle" />
<pre class="rule">
[89] c-tag-handle ::=
    c-named-tag-handle
  | c-secondary-tag-handle
  | c-primary-tag-handle
</pre>

##### Primary Handle

> The _primary tag handle_ is a single _"**`!`**"_ character.
> This allows using the most compact possible notation for a single "primary"
> name space.
> By default, the prefix associated with this handle is ~~["**`!`**"](#undefined)~~.
> Thus, by default, ~~[shorthands](#undefined)~~ using this handle are interpreted as ~~[local
> tags](#undefined)~~.
>
> It is possible to override the default behavior by providing an explicit
> "**`TAG`**" directive, associating a different prefix for this handle.
> This provides smooth migration from using ~~[local tags](#undefined)~~ to using ~~[global
> tags](#undefined)~~, by the simple addition of a single "**`TAG`**" directive.

<div id="rule-c-primary-tag-handle" />
<pre class="rule">
[90] c-primary-tag-handle ::= "!"
</pre>

<div id="example-primary-tag-handle" class="example">
**Example 6.18 Primary Tag Handle**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
# Private
<code class="legend-1">!</code>foo "bar"
...
# Global
%TAG <code class="legend-1">!</code> tag:example.com,2000:app/
---
<code class="legend-1">!</code>foo "bar"
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!&lt;!foo&gt; "bar"
...
---
!&lt;tag:example.com,2000:app/foo&gt; "bar"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-primary-tag-handle">c-primary-tag-handle</a></code>
</div>
</div>

##### Secondary Handle

> The _secondary tag handle_ is written as _"**`!!`**"_.
> This allows using a compact notation for a single "secondary" name space.
> By default, the prefix associated with this handle is
> "**`tag:yaml.org,2002:`**".
> This prefix is used by the ~~[YAML tag repository](#undefined)~~.
>
> It is possible to override this default behavior by providing an explicit
> "**`TAG`**" directive associating a different prefix for this handle.

<div id="rule-c-secondary-tag-handle" />
<pre class="rule">
[91] c-secondary-tag-handle ::=
  "!" "!"
</pre>

<div id="example-secondary-tag-handle" class="example">
**Example 6.19 Secondary Tag Handle**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
%TAG <code class="legend-1">!!</code> tag:example.com,2000:app/
---
<code class="legend-1">!!</code>int 1 - 3 # Interval, not integer
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!&lt;tag:example.com,2000:app/int&gt; "1 - 3"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-secondary-tag-handle">c-secondary-tag-handle</a></code>
</div>
</div>

##### Named Handles

> A _named tag handle_ surrounds a non-empty name with _"**`!`**"_ characters.
> A handle name must not be used in a ~~[tag shorthand](#undefined)~~ unless an explicit
> "**`TAG`**" directive has associated some prefix with it.
>
> The name of the handle is a ~~[presentation detail](#undefined)~~ and must not be used to
> convey [content](#nodes) information.
> In particular, the YAML [processor](#processing-yaml-information) need not preserve the handle name once
> ~~[parsing](#undefined)~~ is completed.

<div id="rule-c-named-tag-handle" />
<pre class="rule">
[92] c-named-tag-handle ::=
  "!" ns-word-char+ "!"
</pre>

<div id="example-tag-handles" class="example">
**Example 6.20 Tag Handles**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
%TAG <code class="legend-1">!e!</code> tag:example.com,2000:app/
---
<code class="legend-1">!e!</code>foo "bar"
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!&lt;tag:example.com,2000:app/foo&gt; "bar"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-named-tag-handle">c-named-tag-handle</a></code>
</div>
</div>

<div id="tag-prefixes" />
#### 6.8.2.2. Tag Prefixes


There are two _tag prefix_ variants:

<div id="rule-ns-tag-prefix" />
<pre class="rule">
[93] ns-tag-prefix ::=
  c-ns-local-tag-prefix | ns-global-tag-prefix
</pre>

##### Local Tag Prefix

> If the prefix begins with a ~~["**`!`**"](#undefined)~~ character, ~~[shorthands](#undefined)~~ using the
> ~~[handle](#undefined)~~ are expanded to a ~~[local tag](#undefined)~~.
> Note that such a [tag](#tags) is intentionally not a valid URI, and its semantics are
> specific to the [application](#processing-yaml-information).
> In particular, two [documents](#document) in the same [stream](#streams) may assign different
> semantics to the same ~~[local tag](#undefined)~~.

<div id="rule-c-ns-local-tag-prefix" />
<pre class="rule">
[94] c-ns-local-tag-prefix ::=
  "!" ns-uri-char*
</pre>

<div id="example-local-tag-prefix" class="example">
**Example 6.21 Local Tag Prefix**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
%TAG !m! <code class="legend-1">!my-</code>
--- # Bulb here
!m!light fluorescent
...
%TAG !m! <code class="legend-1">!my-</code>
--- # Color here
!m!light green
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!&lt;!my-light&gt; "fluorescent"
...
%YAML 1.2
---
!&lt;!my-light&gt; "green"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-ns-local-tag-prefix">c-ns-local-tag-prefix</a></code>
</div>
</div>

##### Global Tag Prefix

> If the prefix begins with a character other than ~~["**`!`**"](#undefined)~~, it must to be a
> valid URI prefix, and should contain at least the scheme and the authority.
> ~~[Shorthands](#undefined)~~ using the associated ~~[handle](#undefined)~~ are expanded to globally unique URI
> tags, and their semantics is consistent across [applications](#processing-yaml-information).
> In particular, every [documents](#document) in every [stream](#streams) must assign the same
> semantics to the same ~~[global tag](#undefined)~~.

<div id="rule-ns-global-tag-prefix" />
<pre class="rule">
[95] ns-global-tag-prefix ::=
  ns-tag-char ns-uri-char*
</pre>

<div id="example-global-tag-prefix" class="example">
**Example 6.22 Global Tag Prefix**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
%TAG !e! <code class="legend-1">tag:example.com,2000:app/</code>
---
- !e!foo "bar"
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!&lt;tag:example.com,2000:app/foo&gt; "bar"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-global-tag-prefix">ns-global-tag-prefix</a></code>
</div>
</div>

<div id="node-properties" />
## 6.9. Node Properties


Each [node](#nodes) may have two optional _properties_, ~~[anchor](#undefined)~~ and [tag](#tags), in addition
to its [content](#nodes).
Node properties may be specified in any order before the ~~[node’s content](#undefined)~~.
Either or both may be omitted.

<div id="rule-c-ns-properties(n,c)" />
<pre class="rule">
[96] c-ns-properties(n,c) ::=
    ( c-ns-tag-property
      ( s-separate(n,c) c-ns-anchor-property )? )
  | ( c-ns-anchor-property
      ( s-separate(n,c) c-ns-tag-property )? )
</pre>

<div id="example-node-properties" class="example">
**Example 6.23 Node Properties**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1"><code class="legend-3">!!str</code> <code class="legend-2">&amp;a1</code></code> "foo":
  <code class="legend-1"><code class="legend-3">!!str</code></code> bar
<code class="legend-1"><code class="legend-2">&amp;a2</code></code> baz : *a1
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? &amp;B1 !!str "foo"
  : !!str "bar",
  ? !!str "baz"
  : *B1,
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-ns-properties(n,c)">c-ns-properties(n,c)</a></code>
> * <code class="legend-2"><a href="#rule-c-ns-anchor-property">c-ns-anchor-property</a></code>
> * <code class="legend-3"><a href="#rule-c-ns-tag-property">c-ns-tag-property</a></code>
</div>
</div>

<div id="node-tags" />
### 6.9.1. Node Tags


The _tag property_ identifies the type of the ~~[native data structure](#undefined)~~
~~[presented](#undefined)~~ by the [node](#nodes).
A tag is denoted by the _"**`!`**" indicator_.

<div id="rule-c-ns-tag-property" />
<pre class="rule">
[97] c-ns-tag-property ::=
    c-verbatim-tag
  | c-ns-shorthand-tag
  | c-non-specific-tag
</pre>

##### Verbatim Tags

> A tag may be written _verbatim_ by surrounding it with the _"**`<`**" and
> "**`>`**"_ characters.
> In this case, the YAML [processor](#processing-yaml-information) must deliver the verbatim tag as-is to the
> [application](#processing-yaml-information).
> In particular, verbatim tags are not subject to ~~[tag resolution](#undefined)~~.
> A verbatim tag must either begin with a ~~["**`!`**"](#undefined)~~ (a ~~[local tag](#undefined)~~) or be a
> valid URI (a ~~[global tag](#undefined)~~).

<div id="rule-c-verbatim-tag" />
<pre class="rule">
[98] c-verbatim-tag ::=
  "!" "&lt;" ns-uri-char+ "&gt;"
</pre>

<div id="example-verbatim-tags" class="example">
**Example 6.24 Verbatim Tags**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">!&lt;tag:yaml.org,2002:str&gt;</code> foo :
  <code class="legend-1">!&lt;!bar&gt;</code> baz
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !&lt;tag:yaml.org,2002:str&gt; "foo"
  : !&lt;!bar&gt; "baz",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-verbatim-tag">c-verbatim-tag</a></code>
</div>
</div>

<div id="example-invalid-verbatim-tags" class="example">
**Example 6.25 Invalid Verbatim Tags**

<table width="100%">
<tr>
<td class="side-by-side">
<pre class="error">
- !&lt;!\&gt; foo
- !&lt;$:?\&gt; bar
</pre>

</td>
<td class="side-by-side">
<pre class="error">
ERROR:
- Verbatim tags aren't resolved,
  so ! is invalid.
- The $:? tag is neither a global
  URI tag nor a local tag starting
  with "!".
</pre>

</td>
</tr>
</table>
</div>

##### Tag Shorthands

> A _tag shorthand_ consists of a valid ~~[tag handle](#undefined)~~ followed by a non-empty
> suffix.
> The ~~[tag handle](#undefined)~~ must be associated with a ~~[prefix](#undefined)~~, either by default or by
> using a ~~["**`TAG`**" directive](#undefined)~~.
> The resulting ~~[parsed](#undefined)~~ [tag](#tags) is the concatenation of the ~~[prefix](#undefined)~~ and the
> suffix, and must either begin with ~~["**`!`**"](#undefined)~~ (a ~~[local tag](#undefined)~~) or be a valid
> URI (a ~~[global tag](#undefined)~~).
>
> The choice of ~~[tag handle](#undefined)~~ is a ~~[presentation detail](#undefined)~~ and must not be used to
> convey [content](#nodes) information.
> In particular, the ~~[tag handle](#undefined)~~ may be discarded once ~~[parsing](#undefined)~~ is completed.
>
> The suffix must not contain any ~~["**`!`**"](#undefined)~~ character.
> This would cause the tag shorthand to be interpreted as having a ~~[named tag
> handle](#undefined)~~.
> In addition, the suffix must not contain the ~~["**`[`**"](#undefined)~~, ["**`]`**"],
> ~~["**`{`**"](#undefined)~~, ~~["**`}`**"](#undefined)~~ and ~~["**`,`**"](#undefined)~~ characters.
> These characters would cause ambiguity with ~~[flow collection](#undefined)~~ structures.
> If the suffix needs to specify any of the above restricted characters, they
> must be ~~[escaped](#undefined)~~ using the ~~["**`%`**"](#undefined)~~ character.
> This behavior is consistent with the URI character escaping rules
> (specifically, section 2.3 of
> [RFC2396](http://www.ietf.org/rfc/rfc2396.txt)).

<div id="rule-c-ns-shorthand-tag" />
<pre class="rule">
[99] c-ns-shorthand-tag ::=
  c-tag-handle ns-tag-char+
</pre>

<div id="example-tag-shorthands" class="example">
**Example 6.26 Tag Shorthands**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
%TAG !e! tag:example.com,2000:app/
---
- <code class="legend-1">!local</code> foo
- <code class="legend-1">!!str</code> bar
- <code class="legend-1">!e!tag%21</code> baz
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !&lt;!local&gt; "foo",
  !&lt;tag:yaml.org,2002:str&gt; "bar",
  !&lt;tag:example.com,2000:app/tag!&gt; "baz"
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-ns-shorthand-tag">c-ns-shorthand-tag</a></code>
</div>
</div>

<div id="example-invalid-tag-shorthands" class="example">
**Example 6.27 Invalid Tag Shorthands**

<table width="100%">
<tr>
<td class="side-by-side">
<pre class="error">
%TAG !e! tag:example,2000:app/
---
- !e! foo
- !h!bar baz
</pre>

</td>
<td class="side-by-side">
<pre class="error">
ERROR:
- The !o! handle has no suffix.
- The !h! handle wasn't declared.
</pre>

</td>
</tr>
</table>
</div>

##### Non-Specific Tags

> If a [node](#nodes) has no tag property, it is assigned a ~~[non-specific tag](#undefined)~~ that
> needs to be ~~[resolved](#undefined)~~ to a ~~[specific](#undefined)~~ one.
> This ~~[non-specific tag](#undefined)~~ is ~~["**`!`**"](#undefined)~~ for non-~~[plain scalars](#undefined)~~ and
> ~~["**`?`**"](#undefined)~~ for all other ~~[nodes](#undefined)~~.
> This is the only case where the ~~[node style](#undefined)~~ has any effect on the [content](#nodes)
> information.
>
> It is possible for the tag property to be explicitly set to the ~~["**`!`**"
> non-specific tag](#undefined)~~.
> By ~~[convention](#undefined)~~, this "disables" ~~[tag resolution](#undefined)~~, forcing the [node](#nodes) to be
> interpreted as "**`tag:yaml.org,2002:seq`**", "**`tag:yaml.org,2002:map`**",
> or "**`tag:yaml.org,2002:str`**", according to its ~~[kind](#undefined)~~.
>
> There is no way to explicitly specify the ~~["**`?`**" non-specific](#undefined)~~ tag.
> This is intentional.

<div id="rule-c-non-specific-tag" />
<pre class="rule">
[100] c-non-specific-tag ::= "!"
</pre>

<div id="example-non-specific-tags" class="example">
**Example 6.28 Non-Specific Tags**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
# Assuming conventional resolution:
- "12"
- 12
- <code class="legend-1">!</code> 12
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !&lt;tag:yaml.org,2002:str&gt; "12",
  !&lt;tag:yaml.org,2002:int&gt; "12",
  !&lt;tag:yaml.org,2002:str&gt; "12",
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-non-specific-tag">c-non-specific-tag</a></code>
</div>
</div>

<div id="node-anchors" />
### 6.9.2. Node Anchors


An anchor is denoted by the _"**`&`**" indicator_.
It marks a [node](#nodes) for future reference.
An ~~[alias node](#undefined)~~ can then be used to indicate additional inclusions of the
anchored [node](#nodes).
An anchored [node](#nodes) need not be referenced by any ~~[alias nodes](#undefined)~~; in particular,
it is valid for all ~~[nodes](#undefined)~~ to be anchored.

<div id="rule-c-ns-anchor-property" />
<pre class="rule">
[101] c-ns-anchor-property ::=
  "&amp;" ns-anchor-name
</pre>

Note that as a ~~[serialization detail](#undefined)~~, the anchor name is preserved in the
~~[serialization tree](#undefined)~~.
However, it is not reflected in the [representation](#representation-graph) graph and must not be used
to convey [content](#nodes) information.
In particular, the YAML [processor](#processing-yaml-information) need not preserve the anchor name once the
[representation](#representation-graph) is ~~[composed](#undefined)~~.

Anchor names must not contain the ~~["**`[`**"](#undefined)~~, ["**`]`**"], ~~["**`{`**"](#undefined)~~,
~~["**`}`**"](#undefined)~~ and ~~["**`,`**"](#undefined)~~ characters.
These characters would cause ambiguity with ~~[flow collection](#undefined)~~ structures.

<div id="rule-ns-anchor-char" />
<pre class="rule">
[102] ns-anchor-char ::=
  ns-char - c-flow-indicator
</pre>

<div id="rule-ns-anchor-name" />
<pre class="rule">
[103] ns-anchor-name ::= ns-anchor-char+
</pre>

<div id="example-node-anchors" class="example">
**Example 6.29 Node Anchors**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
First occurrence: <code class="legend-1">&amp;<code class="legend-2">anchor</code></code> Value
Second occurrence: *<code class="legend-2">anchor</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "First occurrence"
  : &amp;A !!str "Value",
  ? !!str "Second occurrence"
  : *A,
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-ns-anchor-property">c-ns-anchor-property</a></code>
> * <code class="legend-2"><a href="#rule-ns-anchor-name">ns-anchor-name</a></code>
</div>
</div>

<div id="flow-styles" />
# Chapter 7. Flow Styles


YAML’s _flow styles_ can be thought of as the natural extension of JSON to
cover ~~[folding](#undefined)~~ long content lines for readability, ~~[tagging](#undefined)~~ nodes to control
~~[construction](#undefined)~~ of ~~[native data structures](#undefined)~~, and using ~~[anchors](#undefined)~~ and ~~[aliases](#undefined)~~
to reuse ~~[constructed](#undefined)~~ object instances.

<div id="alias-nodes" />
## 7.1. Alias Nodes


Subsequent occurrences of a previously ~~[serialized](#undefined)~~ node are ~~[presented](#undefined)~~ as
_alias nodes_.
The first occurrence of the [node](#nodes) must be marked by an ~~[anchor](#undefined)~~ to allow
subsequent occurrences to be ~~[presented](#undefined)~~ as alias nodes.

An alias node is denoted by the _"**`*`**" indicator_.
The alias refers to the most recent preceding [node](#nodes) having the same ~~[anchor](#undefined)~~.
It is an error for an alias node to use an ~~[anchor](#undefined)~~ that does not previously
occur in the ~~[document](#undefined)~~.
It is not an error to specify an ~~[anchor](#undefined)~~ that is not used by any alias node.

Note that an alias node must not specify any ~~[properties](#undefined)~~ or [content](#nodes), as
these were already specified at the first occurrence of the [node](#nodes).

<div id="rule-c-ns-alias-node" />
<pre class="rule">
[104] c-ns-alias-node ::=
  "*" ns-anchor-name
</pre>

<div id="example-alias-nodes" class="example">
**Example 7.1 Alias Nodes**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
First occurrence: &amp;<code class="legend-2">anchor</code> Foo
Second occurrence: <code class="legend-1">*<code class="legend-2">anchor</code></code>
Override anchor: &amp;<code class="legend-2">anchor</code> Bar
Reuse anchor: <code class="legend-1">*<code class="legend-2">anchor</code></code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "First occurrence"
  : &amp;A !!str "Foo",
  ? !!str "Override anchor"
  : &amp;B !!str "Bar",
  ? !!str "Second occurrence"
  : *A,
  ? !!str "Reuse anchor"
  : *B,
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-ns-alias-node">c-ns-alias-node</a></code>
> * <code class="legend-2"><a href="#rule-ns-anchor-name">ns-anchor-name</a></code>
</div>
</div>

<div id="empty-nodes" />
## 7.2. Empty Nodes


YAML allows the ~~[node content](#undefined)~~ to be omitted in many cases. ~~[Nodes](#undefined)~~ with empty
[content](#nodes) are interpreted as if they were ~~[plain scalars](#undefined)~~ with an empty value.
Such ~~[nodes](#undefined)~~ are commonly resolved to a ~~["**`null`**"](#undefined)~~ value.

<div id="rule-e-scalar" />
<pre class="rule">
[105] e-scalar ::=
  /* Empty */
</pre>

In the examples, empty ~~[scalars](#undefined)~~ are sometimes displayed as the glyph "**`°`**"
for clarity.
Note that this glyph corresponds to a position in the characters [stream](#streams)
rather than to an actual character.

<div id="example-empty-content" class="example">
**Example 7.2 Empty Content**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
{
  foo : !!str<code class="legend-1">°</code>,
  !!str<code class="legend-1">°</code> : bar,
}
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "foo" : !!str "",
  ? !!str ""    : !!str "bar",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-e-scalar">e-scalar</a></code>
</div>
</div>

Both the ~~[node’s properties](#undefined)~~ and ~~[node content](#undefined)~~ are optional.
This allows for a _completely empty node_.
Completely empty nodes are only valid when following some explicit indication
for their existence.

<div id="rule-e-node" />
<pre class="rule">
[106] e-node ::= e-scalar
</pre>

<div id="example-completely-empty-flow-nodes" class="example">
**Example 7.3 Completely Empty Flow Nodes**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
{
  ? foo :<code class="legend-1">°</code>,
  <code class="legend-1">°</code>: bar,
}
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "foo" : !!null "",
  ? !!null ""   : !!str "bar",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-e-node">e-node</a></code>
</div>
</div>

<div id="flow-scalar-styles" />
## 7.3. Flow Scalar Styles


YAML provides three _flow scalar styles_: ~~[double-quoted](#undefined)~~, ~~[single-quoted](#undefined)~~ and
~~[plain](#undefined)~~ (unquoted).
Each provides a different trade-off between readability and expressive power.

The ~~[scalar style](#undefined)~~ is a ~~[presentation detail](#undefined)~~ and must not be used to convey
[content](#nodes) information, with the exception that ~~[plain scalars](#undefined)~~ are
distinguished for the purpose of ~~[tag resolution](#undefined)~~.

<div id="double-quoted-style" />
### 7.3.1. Double-Quoted Style


The _double-quoted style_ is specified by surrounding _"**`"`**" indicators_.
This is the only ~~[style](#undefined)~~ capable of expressing arbitrary strings, by using
~~["**`\`**"](#undefined)~~ ~~[escape sequences](#undefined)~~.
This comes at the cost of having to escape the ~~["**`\`**"](#undefined)~~ and "**`"`**"
characters.

<div id="rule-nb-double-char" />
<pre class="rule">
[107] nb-double-char ::=
  c-ns-esc-char | ( nb-json - "\" - """ )
</pre>

<div id="rule-ns-double-char" />
<pre class="rule">
[108] ns-double-char ::=
  nb-double-char - s-white
</pre>

Double-quoted scalars are restricted to a single line when contained inside an
~~[implicit key](#undefined)~~.

<div id="rule-c-double-quoted(n,c)" />
<pre class="rule">
[109] c-double-quoted(n,c) ::=
  """ nb-double-text(n,c) """
</pre>

<div id="rule-nb-double-text(n,c)" />
<pre class="rule">
[110] nb-double-text(n,c) ::=
  c = flow-out  ⇒ nb-double-multi-line(n)
  c = flow-in   ⇒ nb-double-multi-line(n)
  c = block-key ⇒ nb-double-one-line
  c = flow-key  ⇒ nb-double-one-line
</pre>

<div id="rule-nb-double-one-line" />
<pre class="rule">
[111] nb-double-one-line ::= nb-double-char*
</pre>

<div id="example-double-quoted-implicit-keys" class="example">
**Example 7.4 Double Quoted Implicit Keys**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-2">"<code class="legend-1">implicit block key"</code> </code>: [
  <code class="legend-2">"<code class="legend-1">implicit flow key"</code> </code>: value,
 ]
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "implicit block key"
  : !!seq [
    !!map {
      ? !!str "implicit flow key"
      : !!str "value",
    }
  ]
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-nb-double-one-line">nb-double-one-line</a></code>
> * <code class="legend-2"><a href="#rule-c-double-quoted(n,c)">c-double-quoted(n,c)</a></code>
</div>
</div>

In a multi-line double-quoted scalar, [line breaks](#line-break-characters) are are subject to ~~[flow
line folding](#undefined)~~, which discards any trailing [white space](#white-space-characters) characters.
It is also possible to _escape_ the [line break](#line-break-characters) character.
In this case, the [line break](#line-break-characters) is excluded from the [content](#nodes), and the trailing
[white space](#white-space-characters) characters are preserved.
Combined with the ability to ~~[escape](#undefined)~~ [white space](#white-space-characters) characters, this allows
double-quoted lines to be broken at arbitrary positions.

<div id="rule-s-double-escaped(n)" />
<pre class="rule">
[112] s-double-escaped(n) ::=
  s-white* "\" b-non-content
  l-empty(n,flow-in)* s-flow-line-prefix(n)
</pre>

<div id="rule-s-double-break(n)" />
<pre class="rule">
[113] s-double-break(n) ::=
  s-double-escaped(n) | s-flow-folded(n)
</pre>

<div id="example-double-quoted-line-breaks" class="example">
**Example 7.5 Double Quoted Line Breaks**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
"folded<code class="legend-1">·↓</code>
to a space,<code class="legend-1">→↓</code>
<code class="legend-1">·↓</code>
to a line feed, or<code class="legend-2">·→\↓</code>
<code class="legend-2">·</code>\·→non-content"
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "folded to a space,\n\
      to a line feed, \
      or \t \tnon-content"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-flow-folded(n)">s-flow-folded(n)</a></code>
> * <code class="legend-2"><a href="#rule-s-double-escaped(n)">s-double-escaped(n)</a></code>
</div>
</div>

All leading and trailing [white space](#white-space-characters) characters are excluded from the
[content](#nodes).
Each continuation line must therefore contain at least one non-[space](#white-space-characters) character.
Empty lines, if any, are consumed as part of the ~~[line folding](#undefined)~~.

<div id="rule-nb-ns-double-in-line" />
<pre class="rule">
[114] nb-ns-double-in-line ::=
  ( s-white* ns-double-char )*
</pre>

<div id="rule-s-double-next-line(n)" />
<pre class="rule">
[115] s-double-next-line(n) ::=
  s-double-break(n)
  ( ns-double-char nb-ns-double-in-line
    ( s-double-next-line(n) | s-white* ) )?
</pre>

<div id="rule-nb-double-multi-line(n)" />
<pre class="rule">
[116] nb-double-multi-line(n) ::=
  nb-ns-double-in-line
  ( s-double-next-line(n) | s-white* )
</pre>

<div id="example-double-quoted-lines" class="example">
**Example 7.6 Double Quoted Lines**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
"<code class="legend-1">·1st non-empty</code><code class="legend-2">↓</code>
<code class="legend-2">↓</code>
<code class="legend-2">·<code class="legend-1">2nd non-empty</code>·</code>
<code class="legend-2">→<code class="legend-1">3rd non-empty</code></code>·"
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str " 1st non-empty\n\
      2nd non-empty \
      3rd non-empty "
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-nb-ns-double-in-line">nb-ns-double-in-line</a></code>
> * <code class="legend-2"><a href="#rule-s-double-next-line(n)">s-double-next-line(n)</a></code>
</div>
</div>

<div id="single-quoted-style" />
### 7.3.2. Single-Quoted Style


The _single-quoted style_ is specified by surrounding _"**`'`**" indicators_.
Therefore, within a single-quoted scalar, such characters need to be repeated.
This is the only form of _escaping_ performed in single-quoted scalars.
In particular, the "**`\`**" and "**`"`**" characters may be freely used.
This restricts single-quoted scalars to [printable](#character-set) characters.
In addition, it is only possible to break a long single-quoted line where a
[space](#white-space-characters) character is surrounded by non-[spaces](#white-space-characters).

<div id="rule-c-quoted-quote" />
<pre class="rule">
[117] c-quoted-quote ::=
  "'" "'"
</pre>

<div id="rule-nb-single-char" />
<pre class="rule">
[118] nb-single-char ::=
  c-quoted-quote | ( nb-json - "'" )
</pre>

<div id="rule-ns-single-char" />
<pre class="rule">
[119] ns-single-char ::=
  nb-single-char - s-white
</pre>

<div id="example-single-quoted-characters" class="example">
**Example 7.7 Single Quoted Characters**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
'here<code class="legend-1">''</code>s to "quotes"'
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "here's to \"quotes\""
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-quoted-quote">c-quoted-quote</a></code>
</div>
</div>

Single-quoted scalars are restricted to a single line when contained inside a
~~[implicit key](#undefined)~~.

<div id="rule-c-single-quoted(n,c)" />
<pre class="rule">
[120] c-single-quoted(n,c) ::=
  "'" nb-single-text(n,c) "'"
</pre>

<div id="rule-nb-single-text(n,c)" />
<pre class="rule">
[121] nb-single-text(n,c) ::=
  c = flow-out  ⇒ nb-single-multi-line(n)
  c = flow-in   ⇒ nb-single-multi-line(n)
  c = block-key ⇒ nb-single-one-line
  c = flow-key  ⇒ nb-single-one-line
</pre>

<div id="rule-nb-single-one-line" />
<pre class="rule">
[122] nb-single-one-line ::= nb-single-char*
</pre>

<div id="example-single-quoted-implicit-keys" class="example">
**Example 7.8 Single Quoted Implicit Keys**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-2">'<code class="legend-1">implicit block key</code>'</code> : [
  <code class="legend-2">'<code class="legend-1">implicit flow key</code>'</code> : value,
 ]
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "implicit block key"
  : !!seq [
    !!map {
      ? !!str "implicit flow key"
      : !!str "value",
    }
  ]
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-nb-single-one-line">nb-single-one-line</a></code>
> * <code class="legend-2"><a href="#rule-c-single-quoted(n,c)">c-single-quoted(n,c)</a></code>
</div>
</div>

All leading and trailing [white space](#white-space-characters) characters are excluded from the
[content](#nodes).
Each continuation line must therefore contain at least one non-[space](#white-space-characters) character.
Empty lines, if any, are consumed as part of the ~~[line folding](#undefined)~~.

<div id="rule-nb-ns-single-in-line" />
<pre class="rule">
[123] nb-ns-single-in-line ::=
  ( s-white* ns-single-char )*
</pre>

<div id="rule-s-single-next-line(n)" />
<pre class="rule">
[124] s-single-next-line(n) ::=
  s-flow-folded(n)
  ( ns-single-char nb-ns-single-in-line
    ( s-single-next-line(n) | s-white* ) )?
</pre>

<div id="rule-nb-single-multi-line(n)" />
<pre class="rule">
[125] nb-single-multi-line(n) ::=
  nb-ns-single-in-line
  ( s-single-next-line(n) | s-white* )
</pre>

<div id="example-single-quoted-lines" class="example">
**Example 7.9 Single Quoted Lines**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
'<code class="legend-1">·1st non-empty</code><code class="legend-2">↓</code>
<code class="legend-2">↓</code><code class="legend-1"></code>
<code class="legend-2">·<code class="legend-1">2nd non-empty</code>·</code>
<code class="legend-2">→<code class="legend-1">3rd non-empty</code></code>·'
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str " 1st non-empty\n\
      2nd non-empty \
      3rd non-empty "
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-nb-ns-single-in-line(n)">nb-ns-single-in-line(n)</a></code>
> * <code class="legend-2"><a href="#rule-s-single-next-line(n)">s-single-next-line(n)</a></code>
</div>
</div>

<div id="plain-style" />
### 7.3.3. Plain Style


The _plain_ (unquoted) style has no identifying ~~[indicators](#undefined)~~ and provides no
form of escaping.
It is therefore the most readable, most limited and most ~~[context](#undefined)~~ sensitive
~~[style](#undefined)~~.
In addition to a restricted character set, a plain scalar must not be empty, or
contain leading or trailing [white space](#white-space-characters) characters.
It is only possible to break a long plain line where a [space](#white-space-characters) character is
surrounded by non-[spaces](#white-space-characters).

Plain scalars must not begin with most ~~[indicators](#undefined)~~, as this would cause
ambiguity with other YAML constructs.
However, the ~~["**`:`**"](#undefined)~~, ~~["**`?`**"](#undefined)~~ and ~~["**`-`**"](#undefined)~~ ~~[indicators](#undefined)~~ may be used
as the first character if followed by a non-[space](#white-space-characters) "safe" character, as this
causes no ambiguity.

<div id="rule-ns-plain-first(c)" />
<pre class="rule">
[126] ns-plain-first(c) ::=
    ( ns-char - c-indicator )
  | ( ( "?" | ":" | "-" )
      /* Followed by an ns-plain-safe(c)) */ )
</pre>

Plain scalars must never contain the ~~["**`:`** "](#undefined)~~ and ~~[" **`#`**"](#undefined)~~ character
combinations.
Such combinations would cause ambiguity with ~~[mapping](#undefined)~~ ~~[key: value pairs](#undefined)~~ and
~~[comments](#undefined)~~.
In addition, inside ~~[flow collections](#undefined)~~, or when used as ~~[implicit keys](#undefined)~~, plain
scalars must not contain the ~~["**`[`**"](#undefined)~~, ["**`]`**"], ~~["**`{`**"](#undefined)~~, ~~["**`}`**"](#undefined)~~
and ~~["**`,`**"](#undefined)~~ characters.
These characters would cause ambiguity with ~~[flow collection](#undefined)~~ structures.

<div id="rule-ns-plain-safe(c)" />
<pre class="rule">
[127] ns-plain-safe(c) ::=
  c = flow-out  ⇒ ns-plain-safe-out
  c = flow-in   ⇒ ns-plain-safe-in
  c = block-key ⇒ ns-plain-safe-out
  c = flow-key  ⇒ ns-plain-safe-in
</pre>

<div id="rule-ns-plain-safe-out" />
<pre class="rule">
[128] ns-plain-safe-out ::= ns-char
</pre>

<div id="rule-ns-plain-safe-in" />
<pre class="rule">
[129] ns-plain-safe-in ::=
  ns-char - c-flow-indicator
</pre>

<div id="rule-ns-plain-char(c)" />
<pre class="rule">
[130] ns-plain-char(c) ::=
    ( ns-plain-safe(c) - ":" - "#" )
  | ( /* An ns-char preceding */ "#" )
  | ( ":" /* Followed by an ns-plain-safe(c) */ )
</pre>

<div id="example-plain-characters" class="example">
**Example 7.10 Plain Characters**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
# Outside flow collection:
- ::vector
- ": - ()"
- Up, up, and away!
- -123
- http://example.com/foo#bar
# Inside flow collection:
- [ ::vector,
  ": - ()",
  "Up, up and away!",
  -123,
  http://example.com/foo#bar ]
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!str "::vector",
  !!str ": - ()",
  !!str "Up, up, and away!",
  !!int "-123",
  !!str "http://example.com/foo#bar",
  !!seq [
    !!str "::vector",
    !!str ": - ()",
    !!str "Up, up, and away!",
    !!int "-123",
    !!str "http://example.com/foo#bar",
  ],
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-plain-first(c)">ns-plain-first(c)</a></code> Not ns-plain-first(c)
> * <code class="legend-2"><a href="#rule-ns-plain-char(c)">ns-plain-char(c)</a></code> Not ns-plain-char(c)
</div>
</div>

Plain scalars are further restricted to a single line when contained inside an
~~[implicit key](#undefined)~~.

<div id="rule-ns-plain(n,c)" />
<pre class="rule">
[131] ns-plain(n,c) ::=
  c = flow-out  ⇒ ns-plain-multi-line(n,c)
  c = flow-in   ⇒ ns-plain-multi-line(n,c)
  c = block-key ⇒ ns-plain-one-line(c)
  c = flow-key  ⇒ ns-plain-one-line(c)
</pre>

<div id="rule-nb-ns-plain-in-line(c)" />
<pre class="rule">
[132] nb-ns-plain-in-line(c) ::=
  ( s-white* ns-plain-char(c) )*
</pre>

<div id="rule-ns-plain-one-line(c)" />
<pre class="rule">
[133] ns-plain-one-line(c) ::=
  ns-plain-first(c) nb-ns-plain-in-line(c)
</pre>

<div id="example-plain-implicit-keys" class="example">
**Example 7.11 Plain Implicit Keys**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">implicit block key</code> : [
  <code class="legend-1">implicit flow key</code> : value,
 ]
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "implicit block key"
  : !!seq [
    !!map {
      ? !!str "implicit flow key"
      : !!str "value",
    }
  ]
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-plain-one-line(c)">ns-plain-one-line(c)</a></code>
</div>
</div>

All leading and trailing [white space](#white-space-characters) characters are excluded from the
[content](#nodes).
Each continuation line must therefore contain at least one non-[space](#white-space-characters) character.
Empty lines, if any, are consumed as part of the ~~[line folding](#undefined)~~.

<div id="rule-s-ns-plain-next-line(n,c)" />
<pre class="rule">
[134] s-ns-plain-next-line(n,c) ::=
  s-flow-folded(n)
  ns-plain-char(c) nb-ns-plain-in-line(c)
</pre>

<div id="rule-ns-plain-multi-line(n,c)" />
<pre class="rule">
[135] ns-plain-multi-line(n,c) ::=
  ns-plain-one-line(c)
  s-ns-plain-next-line(n,c)*
</pre>

<div id="example-plain-lines" class="example">
**Example 7.12 Plain Lines**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">1st non-empty</code><code class="legend-2">↓</code>
<code class="legend-2">↓</code>
<code class="legend-2">·<code class="legend-1">2nd non-empty</code>·</code>
<code class="legend-2">→<code class="legend-1">3rd non-empty</code></code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "1st non-empty\n\
      2nd non-empty \
      3rd non-empty"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-nb-ns-plain-in-line(c)">nb-ns-plain-in-line(c)</a></code>
> * <code class="legend-2"><a href="#rule-s-ns-plain-next-line(n,c)">s-ns-plain-next-line(n,c)</a></code>
</div>
</div>

<div id="flow-collection-styles" />
## 7.4. Flow Collection Styles


A _flow collection_ may be nested within a ~~[block collection](#undefined)~~ (~~[**`flow-out`**
context](#undefined)~~), nested within another flow collection (~~[**`flow-in`** context](#undefined)~~), or
be a part of an ~~[implicit key](#undefined)~~ (~~[**`flow-key`** context](#undefined)~~ or ~~[**`block-key`**
context](#undefined)~~).
Flow collection entries are terminated by the _"**`,`**" indicator_.
The final "**`,`**" may be omitted.
This does not cause ambiguity because flow collection entries can never be
~~[completely empty](#undefined)~~.

<div id="rule-in-flow(c)" />
<pre class="rule">
[136] in-flow(c) ::=
  c = flow-out  ⇒ flow-in
  c = flow-in   ⇒ flow-in
  c = block-key ⇒ flow-key
  c = flow-key  ⇒ flow-key
</pre>

<div id="flow-sequences" />
### 7.4.1. Flow Sequences


_Flow sequence content_ is denoted by surrounding _"**`[`**"_ and _"**`]`**"_
characters.

<div id="rule-c-flow-sequence(n,c)" />
<pre class="rule">
[137] c-flow-sequence(n,c) ::=
  "[" s-separate(n,c)?
  ns-s-flow-seq-entries(n,in-flow(c))? "]"
</pre>

Sequence entries are separated by a ~~["**`,`**"](#undefined)~~ character.

<div id="rule-ns-s-flow-seq-entries(n,c)" />
<pre class="rule">
[138] ns-s-flow-seq-entries(n,c) ::=
  ns-flow-seq-entry(n,c) s-separate(n,c)?
  ( "," s-separate(n,c)?
    ns-s-flow-seq-entries(n,c)? )?
</pre>

<div id="example-flow-sequence" class="example">
**Example 7.13 Flow Sequence**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
- <code class="legend-1">[</code> <code class="legend-2">one</code>, <code class="legend-2">two</code>, <code class="legend-1">]</code>
- <code class="legend-1">[</code><code class="legend-2">three</code> ,<code class="legend-2">four</code><code class="legend-1">]</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!seq [
    !!str "one",
    !!str "two",
  ],
  !!seq [
    !!str "three",
    !!str "four",
  ],
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-sequence-start">c-sequence-start</a></code> <code class="legend-1"><a href="#rule-c-sequence-end">c-sequence-end</a></code>
> * <code class="legend-2"><a href="#rule-ns-flow-seq-entry(n,c)">ns-flow-seq-entry(n,c)</a></code>
</div>
</div>

Any ~~[flow node](#undefined)~~ may be used as a flow sequence entry.
In addition, YAML provides a ~~[compact notation](#undefined)~~ for the case where a flow
sequence entry is a ~~[mapping](#undefined)~~ with a ~~[single key: value pair](#undefined)~~.

<div id="rule-ns-flow-seq-entry(n,c)" />
<pre class="rule">
[139] ns-flow-seq-entry(n,c) ::=
  ns-flow-pair(n,c) | ns-flow-node(n,c)
</pre>

<div id="example-flow-sequence-entries" class="example">
**Example 7.14 Flow Sequence Entries**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
[
<code class="legend-1">"double</code>
<code class="legend-1"> quoted"</code>, <code class="legend-1">'single</code>
<code class="legend-1">           quoted'</code>,
<code class="legend-1">plain</code>
<code class="legend-1"> text</code>, <code class="legend-1">[ nested ]</code>,
<code class="legend-2">single: pair</code>,
]
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!str "double quoted",
  !!str "single quoted",
  !!str "plain text",
  !!seq [
    !!str "nested",
  ],
  !!map {
    ? !!str "single"
    : !!str "pair",
  },
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-flow-node(n,c)">ns-flow-node(n,c)</a></code>
> * <code class="legend-2"><a href="#rule-ns-flow-pair(n,c)">ns-flow-pair(n,c)</a></code>
</div>
</div>

<div id="flow-mappings" />
### 7.4.2. Flow Mappings


_Flow mappings_ are denoted by surrounding _"**`{`**"_ and _"**`}`**"_
characters.

<div id="rule-c-flow-mapping(n,c)" />
<pre class="rule">
[140] c-flow-mapping(n,c) ::=
  "{" s-separate(n,c)?
  ns-s-flow-map-entries(n,in-flow(c))? "}"
</pre>

Mapping entries are separated by a ~~["**`,`**"](#undefined)~~ character.

<div id="rule-ns-s-flow-map-entries(n,c)" />
<pre class="rule">
[141] ns-s-flow-map-entries(n,c) ::=
  ns-flow-map-entry(n,c) s-separate(n,c)?
  ( "," s-separate(n,c)?
    ns-s-flow-map-entries(n,c)? )?
</pre>

<div id="example-flow-mappings" class="example">
**Example 7.15 Flow Mappings**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
- <code class="legend-1">{</code> <code class="legend-2">one : two</code> , <code class="legend-2">three: four</code> , <code class="legend-1">}</code>
- <code class="legend-1">{</code><code class="legend-2">five: six</code>,<code class="legend-2">seven : eight</code><code class="legend-1">}</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!map {
    ? !!str "one"   : !!str "two",
    ? !!str "three" : !!str "four",
  },
  !!map {
    ? !!str "five"  : !!str "six",
    ? !!str "seven" : !!str "eight",
  },
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-mapping-start">c-mapping-start</a></code> <code class="legend-1"><a href="#rule-c-mapping-end">c-mapping-end</a></code>
> * <code class="legend-2"><a href="#rule-ns-flow-map-entry(n,c)">ns-flow-map-entry(n,c)</a></code>
</div>
</div>

If the optional _"**`?`**" mapping key indicator_ is specified, the rest of the
entry may be ~~[completely empty](#undefined)~~.

<div id="rule-ns-flow-map-entry(n,c)" />
<pre class="rule">
[142] ns-flow-map-entry(n,c) ::=
    ( "?" s-separate(n,c)
      ns-flow-map-explicit-entry(n,c) )
  | ns-flow-map-implicit-entry(n,c)
</pre>

<div id="rule-ns-flow-map-explicit-entry(n,c)" />
<pre class="rule">
[143] ns-flow-map-explicit-entry(n,c) ::=
    ns-flow-map-implicit-entry(n,c)
  | ( e-node /* Key */
      e-node /* Value */ )
</pre>

<div id="example-flow-mapping-entries" class="example">
**Example 7.16 Flow Mapping Entries**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
{
? <code class="legend-2">explicit: entry</code>,
<code class="legend-1">implicit: entry</code>,
?<code class="legend-3">°</code><code class="legend-3">°</code>
}
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "explicit" : !!str "entry",
  ? !!str "implicit" : !!str "entry",
  ? !!null "" : !!null "",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-flow-map-explicit-entry(n,c)">ns-flow-map-explicit-entry(n,c)</a></code>
> * <code class="legend-2"><a href="#rule-ns-flow-map-implicit-entry(n,c)">ns-flow-map-implicit-entry(n,c)</a></code>
> * <code class="legend-3"><a href="#rule-e-node">e-node</a></code>
</div>
</div>

Normally, YAML insists the _"**`:`**" mapping value indicator_ be [separated](#separation-spaces)
from the ~~[value](#undefined)~~ by [white space](#white-space-characters).
A benefit of this restriction is that the "**`:`**" character can be used
inside ~~[plain scalars](#undefined)~~, as long as it is not followed by [white space](#white-space-characters).
This allows for unquoted URLs and timestamps.
It is also a potential source for confusion as "**`a:1`**" is a ~~[plain scalar](#undefined)~~
and not a ~~[key: value pair](#undefined)~~.

Note that the ~~[value](#undefined)~~ may be ~~[completely empty](#undefined)~~ since its existence is
indicated by the "**`:`**".

<div id="rule-ns-flow-map-implicit-entry(n,c)" />
<pre class="rule">
[144] ns-flow-map-implicit-entry(n,c) ::=
    ns-flow-map-yaml-key-entry(n,c)
  | c-ns-flow-map-empty-key-entry(n,c)
  | c-ns-flow-map-json-key-entry(n,c)
</pre>

<div id="rule-ns-flow-map-yaml-key-entry(n,c)" />
<pre class="rule">
[145] ns-flow-map-yaml-key-entry(n,c) ::=
  ns-flow-yaml-node(n,c)
  ( ( s-separate(n,c)?
      c-ns-flow-map-separate-value(n,c) )
  | e-node )
</pre>

<div id="rule-c-ns-flow-map-empty-key-entry(n,c)" />
<pre class="rule">
[146] c-ns-flow-map-empty-key-entry(n,c) ::=
  e-node /* Key */
  c-ns-flow-map-separate-value(n,c)
</pre>

<div id="rule-c-ns-flow-map-separate-value(n,c)" />
<pre class="rule">
[147] c-ns-flow-map-separate-value(n,c) ::=
  ":" /* Not followed by an
         ns-plain-safe(c) */
  ( ( s-separate(n,c) ns-flow-node(n,c) )
  | e-node /* Value */ )
</pre>

<div id="example-flow-mapping-separate-values" class="example">
**Example 7.17 Flow Mapping Separate Values**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
{
<code class="legend-1">unquoted</code>·<code class="legend-2">:·"separate"</code>,
<code class="legend-1">http://foo.com</code>,
<code class="legend-1">omitted value</code><code class="legend-2">:<code class="legend-3">°</code></code>,
<code class="legend-3">°</code><code class="legend-2">:·omitted key</code>,
}
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "unquoted" : !!str "separate",
  ? !!str "http://foo.com" : !!null "",
  ? !!str "omitted value" : !!null "",
  ? !!null "" : !!str "omitted key",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-flow-yaml-node(n,c)">ns-flow-yaml-node(n,c)</a></code>
> * <code class="legend-2"><a href="#rule-e-node">e-node</a></code>
> * <code class="legend-3"><a href="#rule-c-ns-flow-map-separate-value(n,c)">c-ns-flow-map-separate-value(n,c)</a></code>
</div>
</div>

To ensure ~~[JSON compatibility](#undefined)~~, if a [key](#nodes) inside a flow mapping is
~~[JSON-like](#undefined)~~, YAML allows the following ~~[value](#undefined)~~ to be specified adjacent to the
"**`:`**".
This causes no ambiguity, as all ~~[JSON-like](#undefined)~~ ~~[keys](#undefined)~~ are surrounded by
~~[indicators](#undefined)~~.
However, as this greatly reduces readability, YAML ~~[processors](#undefined)~~ should
~~[separate](#undefined)~~ the ~~[value](#undefined)~~ from the "**`:`**" on output, even in this case.

<div id="rule-c-ns-flow-map-json-key-entry(n,c)" />
<pre class="rule">
[148] c-ns-flow-map-json-key-entry(n,c) ::=
  c-flow-json-node(n,c)
  ( ( s-separate(n,c)?
      c-ns-flow-map-adjacent-value(n,c) )
  | e-node )
</pre>

<div id="rule-c-ns-flow-map-adjacent-value(n,c)" />
<pre class="rule">
[149] c-ns-flow-map-adjacent-value(n,c) ::=
  ":" ( ( s-separate(n,c)?
          ns-flow-node(n,c) )
      | e-node ) /* Value */
</pre>

<div id="example-flow-mapping-adjacent-values" class="example">
**Example 7.18 Flow Mapping Adjacent Values**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
{
<code class="legend-1">"adjacent"</code>:<code class="legend-3">value</code>,
<code class="legend-1">"readable"</code>:·<code class="legend-3">value</code>,
<code class="legend-1">"empty"</code>:<code class="legend-2">°</code>
}
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "adjacent" : !!str "value",
  ? !!str "readable" : !!str "value",
  ? !!str "empty"    : !!null "",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-flow-json-node(n,c)">c-flow-json-node(n,c)</a></code>
> * <code class="legend-2"><a href="#rule-e-node">e-node</a></code>
> * <code class="legend-3"><a href="#rule-c-ns-flow-map-adjacent-value(n,c)">c-ns-flow-map-adjacent-value(n,c)</a></code>
</div>
</div>

A more compact notation is usable inside ~~[flow sequences](#undefined)~~, if the ~~[mapping](#undefined)~~
contains a _single key: value pair_.
This notation does not require the surrounding "**`{`**" and "**`}`**"
characters.
Note that it is not possible to specify any ~~[node properties](#undefined)~~ for the ~~[mapping](#undefined)~~
in this case.

<div id="example-single-pair-flow-mappings" class="example">
**Example 7.19 Single Pair Flow Mappings**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
[
<code class="legend-1">foo: bar</code>
]
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!map { ? !!str "foo" : !!str "bar" }
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-flow-pair(n,c)">ns-flow-pair(n,c)</a></code>
</div>
</div>

If the "**`?`**" indicator is explicitly specified, ~~[parsing](#undefined)~~ is unambiguous,
and the syntax is identical to the general case.

<div id="rule-ns-flow-pair(n,c)" />
<pre class="rule">
[150] ns-flow-pair(n,c) ::=
    ( "?" s-separate(n,c)
      ns-flow-map-explicit-entry(n,c) )
  | ns-flow-pair-entry(n,c)
</pre>

<div id="example-single-pair-explicit-entry" class="example">
**Example 7.20 Single Pair Explicit Entry**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
[
? <code class="legend-1">foo</code>
 <code class="legend-1">bar : baz</code>
]
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!map {
    ? !!str "foo bar"
    : !!str "baz",
  },
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-flow-map-explicit-entry(n,c)">ns-flow-map-explicit-entry(n,c)</a></code>
</div>
</div>

If the "**`?`**" indicator is omitted, ~~[parsing](#undefined)~~ needs to see past the
_implicit key_ to recognize it as such.
To limit the amount of lookahead required, the "**`:`**" indicator must appear
at most 1024 Unicode characters beyond the start of the [key](#nodes).
In addition, the [key](#nodes) is restricted to a single line.

Note that YAML allows arbitrary ~~[nodes](#undefined)~~ to be used as ~~[keys](#undefined)~~.
In particular, a [key](#nodes) may be a ~~[sequence](#undefined)~~ or a ~~[mapping](#undefined)~~.
Thus, without the above restrictions, practical one-pass ~~[parsing](#undefined)~~ would have
been impossible to implement.

<div id="rule-ns-flow-pair-entry(n,c)" />
<pre class="rule">
[151] ns-flow-pair-entry(n,c) ::=
    ns-flow-pair-yaml-key-entry(n,c)
  | c-ns-flow-map-empty-key-entry(n,c)
  | c-ns-flow-pair-json-key-entry(n,c)
</pre>

<div id="rule-ns-flow-pair-yaml-key-entry(n,c)" />
<pre class="rule">
[152] ns-flow-pair-yaml-key-entry(n,c) ::=
  ns-s-implicit-yaml-key(flow-key)
  c-ns-flow-map-separate-value(n,c)
</pre>

<div id="rule-c-ns-flow-pair-json-key-entry(n,c)" />
<pre class="rule">
[153] c-ns-flow-pair-json-key-entry(n,c) ::=
  c-s-implicit-json-key(flow-key)
  c-ns-flow-map-adjacent-value(n,c)
</pre>

<div id="rule-ns-s-implicit-yaml-key(c)" />
<pre class="rule">
[154] ns-s-implicit-yaml-key(c) ::=
  ns-flow-yaml-node(n/a,c) s-separate-in-line?
  /* At most 1024 characters altogether */
</pre>

<div id="rule-c-s-implicit-json-key(c)" />
<pre class="rule">
[155] c-s-implicit-json-key(c) ::=
  c-flow-json-node(n/a,c) s-separate-in-line?
  /* At most 1024 characters altogether */
</pre>

<div id="example-single-pair-implicit-entries" class="example">
**Example 7.21 Single Pair Implicit Entries**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
- [ <code class="legend-1">YAML·</code>: separate ]
- [ °: empty key entry ]
- [ <code class="legend-2">{JSON: like}</code>:adjacent ]
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!seq [
    !!map {
      ? !!str "YAML"
      : !!str "separate"
    },
  ],
  !!seq [
    !!map {
      ? !!null ""
      : !!str "empty key entry"
    },
  ],
  !!seq [
    !!map {
      ? !!map {
        ? !!str "JSON"
        : !!str "like"
      } : "adjacent",
    },
  ],
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-s-implicit-yaml-key">ns-s-implicit-yaml-key</a></code>
> * <code class="legend-2"><a href="#rule-c-s-implicit-json-key">c-s-implicit-json-key</a></code>
> * <code class="legend-3"><a href="#rule-e-node">e-node</a></code> Value
</div>
</div>

<div id="example-invalid-implicit-keys" class="example">
**Example 7.22 Invalid Implicit Keys**

<table width="100%">
<tr>
<td class="side-by-side">
<pre class="error">
[ foo
 bar: invalid,
 "foo_...&gt;1K characters..._bar": invalid ]
</pre>

</td>
<td class="side-by-side">
<pre class="error">
ERROR:
- The foo bar key spans multiple lines
- The foo...bar key is too long
</pre>

</td>
</tr>
</table>
</div>

<div id="flow-nodes" />
## 7.5. Flow Nodes


_JSON-like_ ~~[flow styles](#undefined)~~ all have explicit start and end ~~[indicators](#undefined)~~.
The only ~~[flow style](#undefined)~~ that does not have this property is the ~~[plain scalar](#undefined)~~.
Note that none of the "JSON-like" styles is actually acceptable by JSON.
Even the ~~[double-quoted style](#undefined)~~ is a superset of the JSON string format.

<div id="rule-ns-flow-yaml-content(n,c)" />
<pre class="rule">
[156] ns-flow-yaml-content(n,c) ::= ns-plain(n,c)
</pre>

<div id="rule-c-flow-json-content(n,c)" />
<pre class="rule">
[157] c-flow-json-content(n,c) ::=
    c-flow-sequence(n,c) | c-flow-mapping(n,c)
  | c-single-quoted(n,c) | c-double-quoted(n,c)
</pre>

<div id="rule-ns-flow-content(n,c)" />
<pre class="rule">
[158] ns-flow-content(n,c) ::=
  ns-flow-yaml-content(n,c) | c-flow-json-content(n,c)
</pre>

<div id="example-flow-content" class="example">
**Example 7.23 Flow Content**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
- <code class="legend-1">[ a, b ]</code>
- <code class="legend-1">{ a: b }</code>
- <code class="legend-1">"a"</code>
- <code class="legend-1">'b'</code>
- <code class="legend-2">c</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!seq [ !!str "a", !!str "b" ],
  !!map { ? !!str "a" : !!str "b" },
  !!str "a",
  !!str "b",
  !!str "c",
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-flow-json-content(n,c)">c-flow-json-content(n,c)</a></code>
> * <code class="legend-2"><a href="#rule-ns-flow-yaml-content(n,c)">ns-flow-yaml-content(n,c)</a></code>
</div>
</div>

A complete ~~[flow](#undefined)~~ [node](#nodes) also has optional ~~[node properties](#undefined)~~, except for ~~[alias
nodes](#undefined)~~ which refer to the ~~[anchored](#undefined)~~ ~~[node properties](#undefined)~~.

<div id="rule-ns-flow-yaml-node(n,c)" />
<pre class="rule">
[159] ns-flow-yaml-node(n,c) ::=
    c-ns-alias-node
  | ns-flow-yaml-content(n,c)
  | ( c-ns-properties(n,c)
      ( ( s-separate(n,c)
          ns-flow-yaml-content(n,c) )
        | e-scalar ) )
</pre>

<div id="rule-c-flow-json-node(n,c)" />
<pre class="rule">
[160] c-flow-json-node(n,c) ::=
  ( c-ns-properties(n,c) s-separate(n,c) )?
  c-flow-json-content(n,c)
</pre>

<div id="rule-ns-flow-node(n,c)" />
<pre class="rule">
[161] ns-flow-node(n,c) ::=
    c-ns-alias-node
  | ns-flow-content(n,c)
  | ( c-ns-properties(n,c)
      ( ( s-separate(n,c)
          ns-flow-content(n,c) )
        | e-scalar ) )
</pre>

<div id="example-flow-nodes" class="example">
**Example 7.24 Flow Nodes**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
- <code class="legend-1">!!str "a"</code>
- <code class="legend-1">'b'</code>
- <code class="legend-1">&amp;anchor "c"</code>
- <code class="legend-2">*anchor</code>
- <code class="legend-2">!!str°</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!str "a",
  !!str "b",
  &amp;A !!str "c",
  *A,
  !!str "",
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-flow-json-node(n,c)">c-flow-json-node(n,c)</a></code>
> * <code class="legend-2"><a href="#rule-ns-flow-yaml-node(n,c)">ns-flow-yaml-node(n,c)</a></code>
</div>
</div>

<div id="block-styles" />
# Chapter 8. Block Styles


YAML’s _block styles_ employ [indentation](#indentation-spaces) rather than ~~[indicators](#undefined)~~ to denote
structure.
This results in a more human readable (though less compact) notation.

<div id="block-scalar-styles" />
## 8.1. Block Scalar Styles


YAML provides two _block scalar styles_, ~~[literal](#undefined)~~ and ~~[folded](#undefined)~~.
Each provides a different trade-off between readability and expressive power.

<div id="block-scalar-headers" />
### 8.1.1. Block Scalar Headers


~~[Block scalars](#undefined)~~ are controlled by a few ~~[indicators](#undefined)~~ given in a _header_
preceding the [content](#nodes) itself.
This header is followed by a non-content [line break](#line-break-characters) with an optional ~~[comment](#undefined)~~.
This is the only case where a ~~[comment](#undefined)~~ must not be followed by additional
~~[comment](#undefined)~~ lines.

<div id="rule-c-b-block-header(m,t)" />
<pre class="rule">
[162] c-b-block-header(m,t) ::=
  ( ( c-indentation-indicator(m)
      c-chomping-indicator(t) )
  | ( c-chomping-indicator(t)
      c-indentation-indicator(m) ) )
  s-b-comment
</pre>

<div id="example-block-scalar-header" class="example">
**Example 8.1 Block Scalar Header**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
- |<code class="legend-1"> # Empty header↓</code>
 literal
- &gt;<code class="legend-1">1 # Indentation indicator↓</code>
 ·folded
- |<code class="legend-1">+ # Chomping indicator↓</code>
 keep

- &gt;<code class="legend-1">1- # Both indicators↓</code>
 ·strip
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!str "literal\n",
  !!str "·folded\n",
  !!str "keep\n\n",
  !!str "·strip",
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-b-block-header(m,t)">c-b-block-header(m,t)</a></code>
</div>
</div>

<div id="block-indentation-indicator" />
#### 8.1.1.1. Block Indentation Indicator


Typically, the [indentation](#indentation-spaces) level of a ~~[block scalar](#undefined)~~ is detected from its
first non-~~[empty](#undefined)~~ line.
It is an error for any of the leading ~~[empty lines](#undefined)~~ to contain more [spaces](#white-space-characters)
than the first non-~~[empty line](#undefined)~~.

Detection fails when the first non-~~[empty line](#undefined)~~ contains leading content
[space](#white-space-characters) characters. [Content](#nodes) may safely start with a ~~[tab](#undefined)~~ or a ~~["**`#`**"](#undefined)~~
character.

When detection would fail, YAML requires that the [indentation](#indentation-spaces) level for the
[content](#nodes) be given using an explicit _indentation indicator_.
This level is specified as the integer number of the additional [indentation](#indentation-spaces)
spaces used for the [content](#nodes), relative to its parent [node](#nodes).

It is always valid to specify an indentation indicator for a ~~[block scalar](#undefined)~~
node, though a YAML [processor](#processing-yaml-information) should only emit an explicit indentation
indicator for cases where detection will fail.

<div id="rule-c-indentation-indicator(m)" />
<pre class="rule">
[163] c-indentation-indicator(m) ::=
  ns-dec-digit ⇒ m = ns-dec-digit - #x30
  /* Empty */  ⇒ m = auto-detect()
</pre>

<div id="example-block-indentation-indicator" class="example">
**Example 8.2 Block Indentation Indicator**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
- |<code class="legend-1">°</code>
<code class="legend-2">·</code>detected
- &gt;<code class="legend-1">°</code>
<code class="legend-2">·</code>
<code class="legend-2">··</code>
<code class="legend-2">··</code># detected
- |<code class="legend-1">1</code>
<code class="legend-2">··</code>explicit
- &gt;<code class="legend-1">°</code>
<code class="legend-2">·</code>→
<code class="legend-2">·</code>detected
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!str "detected\n",
  !!str "\n\n# detected\n",
  !!str "·explicit\n",
  !!str "\t·detected\n",
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-indentation-indicator(m)">c-indentation-indicator(m)</a></code>
> * <code class="legend-2"><a href="#rule-s-indent(n)">s-indent(n)</a></code>
</div>
</div>

<div id="example-invalid-block-scalar-indentation-indicators" class="example">
**Example 8.3 Invalid Block Scalar Indentation Indicators**

<table width="100%">
<tr>
<td class="side-by-side">
<pre class="error">
- |
··
·text
- &gt;
··text
·text
- |2
·text
</pre>

</td>
<td class="side-by-side">
<pre class="error">
ERROR:
- A leading all-space line must
  not have too many spaces.
- A following text line must
  not be less indented.
- The text is less indented
  than the indicated level.
</pre>

</td>
</tr>
</table>
</div>

<div id="block-chomping-indicator" />
#### 8.1.1.2. Block Chomping Indicator


_Chomping_ controls how final [line breaks](#line-break-characters) and trailing ~~[empty lines](#undefined)~~ are
interpreted.
YAML provides three chomping methods:

##### Strip

> _Stripping_ is specified by the _"**`-`**" chomping indicator_.
> In this case, the final [line break](#line-break-characters) and any trailing ~~[empty lines](#undefined)~~ are
> excluded from the ~~[scalar’s content](#undefined)~~.

##### Clip

> _Clipping_ is the default behavior used if no explicit chomping indicator is
> specified.
> In this case, the final [line break](#line-break-characters) character is preserved in the ~~[scalar’s
> content](#undefined)~~.
> However, any trailing ~~[empty lines](#undefined)~~ are excluded from the ~~[scalar’s content](#undefined)~~.

##### Keep

> _Keeping_ is specified by the _"**`+`**" chomping indicator_.
> In this case, the final [line break](#line-break-characters) and any trailing ~~[empty lines](#undefined)~~ are
> considered to be part of the ~~[scalar’s content](#undefined)~~.
> These additional lines are not subject to ~~[folding](#undefined)~~.

The chomping method used is a ~~[presentation detail](#undefined)~~ and must not be used to
convey [content](#nodes) information.

<div id="rule-c-chomping-indicator(t)" />
<pre class="rule">
[164] c-chomping-indicator(t) ::=
  "-"         ⇒ t = strip
  "+"         ⇒ t = keep
  /* Empty */ ⇒ t = clip
</pre>

The interpretation of the final [line break](#line-break-characters) of a ~~[block scalar](#undefined)~~ is controlled
by the chomping indicator specified in the ~~[block scalar header](#undefined)~~.

<div id="rule-b-chomped-last(t)" />
<pre class="rule">
[165] b-chomped-last(t) ::=
  t = strip ⇒ b-non-content | /* End of file */
  t = clip  ⇒ b-as-line-feed | /* End of file */
  t = keep  ⇒ b-as-line-feed | /* End of file */
</pre>

<div id="example-chomping-final-line-break" class="example">
**Example 8.4 Chomping Final Line Break**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
strip: |-
  text<code class="legend-1">↓</code>
clip: |
  text<code class="legend-2">↓</code>
keep: |+
  text<code class="legend-2">↓</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "strip"
  : !!str "text",
  ? !!str "clip"
  : !!str "text\n",
  ? !!str "keep"
  : !!str "text\n",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-b-non-content">b-non-content</a></code>
> * <code class="legend-2"><a href="#rule-b-as-line-feed">b-as-line-feed</a></code>
</div>
</div>

The interpretation of the trailing ~~[empty lines](#undefined)~~ following a ~~[block scalar](#undefined)~~ is
also controlled by the chomping indicator specified in the ~~[block scalar
header](#undefined)~~.

<div id="rule-l-chomped-empty(n,t)" />
<pre class="rule">
[166] l-chomped-empty(n,t) ::=
  t = strip ⇒ l-strip-empty(n)
  t = clip  ⇒ l-strip-empty(n)
  t = keep  ⇒ l-keep-empty(n)
</pre>

<div id="rule-l-strip-empty(n)" />
<pre class="rule">
[167] l-strip-empty(n) ::=
  ( s-indent(≤n) b-non-content )*
  l-trail-comments(n)?
</pre>

<div id="rule-l-keep-empty(n)" />
<pre class="rule">
[168] l-keep-empty(n) ::=
  l-empty(n,block-in)*
  l-trail-comments(n)?
</pre>

Explicit ~~[comment](#undefined)~~ lines may follow the trailing ~~[empty lines](#undefined)~~.
To prevent ambiguity, the first such ~~[comment](#undefined)~~ line must be less [indented](#indentation-spaces)
than the ~~[block scalar content](#undefined)~~.
Additional ~~[comment](#undefined)~~ lines, if any, are not so restricted.
This is the only case where the [indentation](#indentation-spaces) of ~~[comment](#undefined)~~ lines is
constrained.

<div id="rule-l-trail-comments(n)" />
<pre class="rule">
[169] l-trail-comments(n) ::=
  s-indent(&lt;n) c-nb-comment-text b-comment
  l-comment*
</pre>

<div id="example-chomping-trailing-lines" class="example">
**Example 8.5 Chomping Trailing Lines**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
# Strip
  # Comments:
strip: |-
  # text↓
<code class="legend-1">··⇓</code>
<code class="legend-1"><code class="legend-3">·# Clip</code></code>
<code class="legend-1"><code class="legend-3">··# comments:</code></code>
<code class="legend-1"><code class="legend-3">↓</code></code>
clip: |
  # text↓
<code class="legend-1">·↓</code>
<code class="legend-1"><code class="legend-3">·# Keep</code></code>
<code class="legend-1"><code class="legend-3">··# comments:</code></code>
<code class="legend-1"><code class="legend-3">↓</code></code>
keep: |+
  # text↓
<code class="legend-2">↓</code>
<code class="legend-2"><code class="legend-3">·# Trail</code></code>
<code class="legend-2"><code class="legend-3">··# comments.</code></code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "strip"
  : !!str "# text",
  ? !!str "clip"
  : !!str "# text\n",
  ? !!str "keep"
  : !!str "# text\n",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-l-strip-empty(n)">l-strip-empty(n)</a></code>
> * <code class="legend-2"><a href="#rule-l-keep-empty(n)">l-keep-empty(n)</a></code>
> * <code class="legend-3"><a href="#rule-l-trail-comments(n)">l-trail-comments(n)</a></code>
</div>
</div>

If a ~~[block scalar](#undefined)~~ consists only of ~~[empty lines](#undefined)~~, then these lines are
considered as trailing lines and hence are affected by chomping.

<div id="example-empty-scalar-chomping" class="example">
**Example 8.6 Empty Scalar Chomping**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
strip: &gt;-
<code class="legend-1">↓</code>
clip: &gt;
<code class="legend-1">↓</code>
keep: |+
<code class="legend-2">↓</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "strip"
  : !!str "",
  ? !!str "clip"
  : !!str "",
  ? !!str "keep"
  : !!str "\n",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-l-strip-empty(n)">l-strip-empty(n)</a></code>
> * <code class="legend-2"><a href="#rule-l-keep-empty(n)">l-keep-empty(n)</a></code>
</div>
</div>

<div id="literal-style" />
### 8.1.2. Literal Style


The _literal style_ is denoted by the _"**`|`**" indicator_.
It is the simplest, most restricted, and most readable ~~[scalar style](#undefined)~~.

<div id="rule-c-l+literal(n)" />
<pre class="rule">
[170] c-l+literal(n) ::=
  "|" c-b-block-header(m,t)
  l-literal-content(n+m,t)
</pre>

<div id="example-literal-scalar" class="example">
**Example 8.7 Literal Scalar**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">|↓</code>
<code class="legend-1">·literal↓</code>
<code class="legend-1">·→text↓</code>
<code class="legend-1">↓</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "literal\n\ttext\n"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-l+literal(n)">c-l+literal(n)</a></code>
</div>
</div>

Inside literal scalars, all ([indented](#indentation-spaces)) characters are considered to be
[content](#nodes), including [white space](#white-space-characters) characters.
Note that all [line break](#line-break-characters) characters are ~~[normalized](#undefined)~~.
In addition, ~~[empty lines](#undefined)~~ are not ~~[folded](#undefined)~~, though final [line breaks](#line-break-characters) and
trailing ~~[empty lines](#undefined)~~ are ~~[chomped](#undefined)~~.

There is no way to escape characters inside literal scalars.
This restricts them to [printable](#character-set) characters.
In addition, there is no way to break a long literal line.

<div id="rule-l-nb-literal-text(n)" />
<pre class="rule">
[171] l-nb-literal-text(n) ::=
  l-empty(n,block-in)*
  s-indent(n) nb-char+
</pre>

<div id="rule-b-nb-literal-next(n)" />
<pre class="rule">
[172] b-nb-literal-next(n) ::=
  b-as-line-feed
  l-nb-literal-text(n)
</pre>

<div id="rule-l-literal-content(n,t)" />
<pre class="rule">
[173] l-literal-content(n,t) ::=
  ( l-nb-literal-text(n) b-nb-literal-next(n)*
    b-chomped-last(t) )?
  l-chomped-empty(n,t)
</pre>

<div id="example-literal-content" class="example">
**Example 8.8 Literal Content**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
|
<code class="legend-1">·</code>
<code class="legend-1">··</code>
<code class="legend-1">··literal</code><code class="legend-2">↓</code>
<code class="legend-1"><code class="legend-2">···</code></code><code class="legend-2">↓</code>
<code class="legend-1"><code class="legend-2">··</code></code>
<code class="legend-1"><code class="legend-2">··text</code></code><code class="legend-3">↓</code>
↓
<code class="legend-4">·# Comment</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "\n\nliteral\n·\n\ntext\n"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-l-nb-literal-text(n)">l-nb-literal-text(n)</a></code>
> * <code class="legend-2"><a href="#rule-b-nb-literal-next(n)">b-nb-literal-next(n)</a></code>
> * <code class="legend-3"><a href="#rule-b-chomped-last(t)">b-chomped-last(t)</a></code>
> * <code class="legend-4"><a href="#rule-l-chomped-empty(n,t)">l-chomped-empty(n,t)</a></code>
</div>
</div>

<div id="folded-style" />
### 8.1.3. Folded Style


The _folded style_ is denoted by the _"**`>`**" indicator_.
It is similar to the ~~[literal style](#undefined)~~; however, folded scalars are subject to
~~[line folding](#undefined)~~.

<div id="rule-c-l+folded(n)" />
<pre class="rule">
[174] c-l+folded(n) ::=
  "&gt;" c-b-block-header(m,t)
  l-folded-content(n+m,t)
</pre>

<div id="example-folded-scalar" class="example">
**Example 8.9 Folded Scalar**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">&gt;↓</code>
<code class="legend-1">·folded↓</code>
<code class="legend-1">·text↓</code>
<code class="legend-1">↓</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "folded text\n"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-l+folded(n)">c-l+folded(n)</a></code>
</div>
</div>

~~[Folding](#undefined)~~ allows long lines to be broken anywhere a single [space](#white-space-characters) character
separates two non-[space](#white-space-characters) characters.

<div id="rule-s-nb-folded-text(n)" />
<pre class="rule">
[175] s-nb-folded-text(n) ::=
  s-indent(n) ns-char nb-char*
</pre>

<div id="rule-l-nb-folded-lines(n)" />
<pre class="rule">
[176] l-nb-folded-lines(n) ::=
  s-nb-folded-text(n)
  ( b-l-folded(n,block-in) s-nb-folded-text(n) )*
</pre>

<div id="example-folded-lines" class="example">
**Example 8.10 Folded Lines**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
&gt;
·folded↓
<code class="legend-1"><code class="legend-2">·line↓</code></code>
<code class="legend-1"><code class="legend-2">↓</code></code>
·next
<code class="legend-1"><code class="legend-2">·line↓</code></code>
<code class="legend-1"><code class="legend-2">   *</code> bullet</code>

   * list
   * lines

·last↓
<code class="legend-1"><code class="legend-2">·line</code>↓</code>
<code class="legend-1"><code class="legend-2"></code></code>
# Comment
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "\n\
      folded line\n\
      next line\n\
      \  * bullet\n
      \n\
      \  * list\n\
      \  * lines\n\
      \n\
      last line\n"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-nb-folded-text(n)">s-nb-folded-text(n)</a></code>
> * <code class="legend-2"><a href="#rule-l-nb-folded-lines(n)">l-nb-folded-lines(n)</a></code>
</div>
</div>

(The following three examples duplicate this example, each highlighting
different productions.)

Lines starting with [white space](#white-space-characters) characters (_more-indented_ lines) are not
~~[folded](#undefined)~~.

<div id="rule-s-nb-spaced-text(n)" />
<pre class="rule">
[177] s-nb-spaced-text(n) ::=
  s-indent(n) s-white nb-char*
</pre>

<div id="rule-b-l-spaced(n)" />
<pre class="rule">
[178] b-l-spaced(n) ::=
  b-as-line-feed
  l-empty(n,block-in)*
</pre>

<div id="rule-l-nb-spaced-lines(n)" />
<pre class="rule">
[179] l-nb-spaced-lines(n) ::=
  s-nb-spaced-text(n)
  ( b-l-spaced(n) s-nb-spaced-text(n) )*
</pre>

<div id="example-more-indented-lines" class="example">
**Example 8.11 More Indented Lines**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
&gt;
 folded
 line

 next
 line
···* bullet↓
<code class="legend-1"><code class="legend-2">↓</code></code>
<code class="legend-2">···* list↓</code>
<code class="legend-1"><code class="legend-2">···* line</code>s↓</code>
<code class="legend-1"><code class="legend-2"></code></code>
 last
 line

# Comment
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "\n\
      folded line\n\
      next line\n\
      \  * bullet\n
      \n\
      \  * list\n\
      \  * lines\n\
      \n\
      last line\n"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-nb-spaced-text(n)">s-nb-spaced-text(n)</a></code>
> * <code class="legend-2"><a href="#rule-l-nb-spaced-lines(n)">l-nb-spaced-lines(n)</a></code>
</div>
</div>

[Line breaks](#line-break-characters) and ~~[empty lines](#undefined)~~ separating folded and more-indented lines are
also not ~~[folded](#undefined)~~.

<div id="rule-l-nb-same-lines(n)" />
<pre class="rule">
[180] l-nb-same-lines(n) ::=
  l-empty(n,block-in)*
  ( l-nb-folded-lines(n) | l-nb-spaced-lines(n) )
</pre>

<div id="rule-l-nb-diff-lines(n)" />
<pre class="rule">
[181] l-nb-diff-lines(n) ::=
  l-nb-same-lines(n)
  ( b-as-line-feed l-nb-same-lines(n) )*
</pre>

<div id="example-empty-separation-lines" class="example">
**Example 8.12 Empty Separation Lines**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
&gt;
<code class="legend-2">↓</code>
 folded
 line<code class="legend-1">↓</code>
<code class="legend-2">↓</code>
 next
 line<code class="legend-1">↓</code>
   * bullet

   * list
   * line↓
<code class="legend-2">↓</code>
 last
 line

# Comment
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "\n\
      folded line\n\
      next line\n\
      \  * bullet\n
      \n\
      \  * list\n\
      \  * lines\n\
      \n\
      last line\n"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-b-as-line-feed">b-as-line-feed</a></code>
> * (separation)
> * <code class="legend-2"><a href="#rule-l-empty(n,c)">l-empty(n,c)</a></code>
</div>
</div>

The final [line break](#line-break-characters), and trailing ~~[empty lines](#undefined)~~ if any, are subject to
~~[chomping](#undefined)~~ and are never ~~[folded](#undefined)~~.

<div id="rule-l-folded-content(n,t)" />
<pre class="rule">
[182] l-folded-content(n,t) ::=
  ( l-nb-diff-lines(n) b-chomped-last(t) )?
  l-chomped-empty(n,t)
</pre>

<div id="example-final-empty-lines" class="example">
**Example 8.13 Final Empty Lines**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
&gt;
 folded
 line

 next
 line
   * bullet

   * list
   * line

 last
 line<code class="legend-1">↓</code>
<code class="legend-2">↓</code>
<code class="legend-2"># Comment</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "\n\
      folded line\n\
      next line\n\
      \  * bullet\n
      \n\
      \  * list\n\
      \  * lines\n\
      \n\
      last line\n"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-b-chomped-last(t)">b-chomped-last(t)</a></code>
> * <code class="legend-2"><a href="#rule-l-chomped-empty(n,t)">l-chomped-empty(n,t)</a></code>
</div>
</div>

<div id="block-collection-styles" />
## 8.2. Block Collection Styles


For readability, _block collections styles_ are not denoted by any ~~[indicator](#undefined)~~.
Instead, YAML uses a lookahead method, where a block collection is
distinguished from a ~~[plain scalar](#undefined)~~ only when a ~~[key: value pair](#undefined)~~ or a
~~[sequence entry](#undefined)~~ is seen.

<div id="block-sequences" />
### 8.2.1. Block Sequences


A _block sequence_ is simply a series of ~~[nodes](#undefined)~~, each denoted by a leading
_"**`-`**" indicator_.
The "**`-`**" indicator must be [separated](#separation-spaces) from the [node](#nodes) by [white space](#white-space-characters).
This allows "**`-`**" to be used as the first character in a ~~[plain scalar](#undefined)~~ if
followed by a non-space character (e.g. "**`-1`**").

<div id="rule-l+block-sequence(n)" />
<pre class="rule">
[183] l+block-sequence(n) ::=
  ( s-indent(n+m) c-l-block-seq-entry(n+m) )+
  /* For some fixed auto-detected m &gt; 0 */
</pre>

<div id="rule-c-l-block-seq-entry(n)" />
<pre class="rule">
[184] c-l-block-seq-entry(n) ::=
  "-" /* Not followed by an ns-char */
  s-l+block-indented(n,block-in)
</pre>

<div id="example-block-sequence" class="example">
**Example 8.14 Block Sequence**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
block sequence:
··<code class="legend-1">- one↓</code>
  <code class="legend-1">- two : three↓</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "block sequence"
  : !!seq [
    !!str "one",
    !!map {
      ? !!str "two"
      : !!str "three"
    },
  ],
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-l-block-seq-entry(n)">c-l-block-seq-entry(n)</a></code>
> * auto-detected <code class="legend-2"><a href="#rule-s-indent(n)">s-indent(n)</a></code>
</div>
</div>

The entry [node](#nodes) may be either ~~[completely empty](#undefined)~~, be a nested ~~[block node](#undefined)~~, or
use a _compact in-line notation_.
The compact notation may be used when the entry is itself a nested ~~[block
collection](#undefined)~~.
In this case, both the "**`-`**" indicator and the following [spaces](#white-space-characters) are
considered to be part of the [indentation](#indentation-spaces) of the nested ~~[collection](#undefined)~~.
Note that it is not possible to specify ~~[node properties](#undefined)~~ for such a
~~[collection](#undefined)~~.

<div id="rule-s-l+block-indented(n,c)" />
<pre class="rule">
[185] s-l+block-indented(n,c) ::=
    ( s-indent(m)
      ( ns-l-compact-sequence(n+1+m)
      | ns-l-compact-mapping(n+1+m) ) )
  | s-l+block-node(n,c)
  | ( e-node s-l-comments )
</pre>

<div id="rule-ns-l-compact-sequence(n)" />
<pre class="rule">
[186] ns-l-compact-sequence(n) ::=
  c-l-block-seq-entry(n)
  ( s-indent(n) c-l-block-seq-entry(n) )*
</pre>

<div id="example-block-sequence-entry-types" class="example">
**Example 8.15 Block Sequence Entry Types**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
-<code class="legend-1">° # Empty</code>
- |
 block node
-·- one # Compact
··- two # sequence
- one: two # Compact mapping
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!null "",
  !!str "block node\n",
  !!seq [
    !!str "one"
    !!str "two",
  ],
  !!map {
    ? !!str "one"
    : !!str "two",
  },
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * Empty
> * <code class="legend-1"><a href="#rule-s-l+block-node(n,c)">s-l+block-node(n,c)</a></code>
> * <code class="legend-2"><a href="#rule-ns-l-compact-sequence(n)">ns-l-compact-sequence(n)</a></code>
> * <code class="legend-3"><a href="#rule-ns-l-compact-mapping(n)">ns-l-compact-mapping(n)</a></code>
</div>
</div>

<div id="block-mappings" />
### 8.2.2. Block Mappings


A _Block mapping_ is a series of entries, each ~~[presenting](#undefined)~~ a ~~[key: value
pair](#undefined)~~.

<div id="rule-l+block-mapping(n)" />
<pre class="rule">
[187] l+block-mapping(n) ::=
  ( s-indent(n+m) ns-l-block-map-entry(n+m) )+
  /* For some fixed auto-detected m &gt; 0 */
</pre>

<div id="example-block-mappings" class="example">
**Example 8.16 Block Mappings**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
block mapping:
<code class="legend-2">·</code><code class="legend-1">key: value↓</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "block mapping"
  : !!map {
    ? !!str "key"
    : !!str "value",
  },
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-l-block-map-entry(n)">ns-l-block-map-entry(n)</a></code>
> * auto-detected <code class="legend-2"><a href="#rule-s-indent(n)">s-indent(n)</a></code>
</div>
</div>

If the ~~["**`?`**"](#undefined)~~ indicator is specified, the optional value node must be
specified on a separate line, denoted by the ~~["**`:`**"](#undefined)~~ indicator.
Note that YAML allows here the same ~~[compact in-line notation](#undefined)~~ described above
for ~~[block sequence](#undefined)~~ entries.

<div id="rule-ns-l-block-map-entry(n)" />
<pre class="rule">
[188] ns-l-block-map-entry(n) ::=
    c-l-block-map-explicit-entry(n)
  | ns-l-block-map-implicit-entry(n)
</pre>

<div id="rule-c-l-block-map-explicit-entry(n)" />
<pre class="rule">
[189] c-l-block-map-explicit-entry(n) ::=
  c-l-block-map-explicit-key(n)
  ( l-block-map-explicit-value(n)
  | e-node )
</pre>

<div id="rule-c-l-block-map-explicit-key(n)" />
<pre class="rule">
[190] c-l-block-map-explicit-key(n) ::=
  "?" s-l+block-indented(n,block-out)
</pre>

<div id="rule-l-block-map-explicit-value(n)" />
<pre class="rule">
[191] l-block-map-explicit-value(n) ::=
  s-indent(n)
  ":" s-l+block-indented(n,block-out)
</pre>

<div id="example-explicit-block-mapping-entries" class="example">
**Example 8.17 Explicit Block Mapping Entries**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">? explicit key # Empty value</code><code class="legend-3">↓</code>°
<code class="legend-1">? |</code>
<code class="legend-1">  block key↓</code>
<code class="legend-2">:·- one # Explicit compact</code>
<code class="legend-2">··- two # block value↓</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "explicit key"
  : !!str "",
  ? !!str "block key\n"
  : !!seq [
    !!str "one",
    !!str "two",
  ],
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-l-block-map-explicit-key(n)">c-l-block-map-explicit-key(n)</a></code>
> * <code class="legend-2"><a href="#rule-l-block-map-explicit-value(n)">l-block-map-explicit-value(n)</a></code>
> * <code class="legend-3"><a href="#rule-e-node">e-node</a></code>
</div>
</div>

If the "**`?`**" indicator is omitted, ~~[parsing](#undefined)~~ needs to see past the
~~[implicit key](#undefined)~~, in the same way as in the ~~[single key: value pair](#undefined)~~ ~~[flow
mapping](#undefined)~~.
Hence, such ~~[keys](#undefined)~~ are subject to the same restrictions; they are limited to a
single line and must not span more than 1024 Unicode characters.

<div id="rule-ns-l-block-map-implicit-entry(n)" />
<pre class="rule">
[192] ns-l-block-map-implicit-entry(n) ::=
  ( ns-s-block-map-implicit-key
  | e-node )
  c-l-block-map-implicit-value(n)
</pre>

<div id="rule-ns-s-block-map-implicit-key" />
<pre class="rule">
[193] ns-s-block-map-implicit-key ::=
    c-s-implicit-json-key(block-key)
  | ns-s-implicit-yaml-key(block-key)
</pre>

In this case, the ~~[value](#undefined)~~ may be specified on the same line as the ~~[implicit
key](#undefined)~~.
Note however that in block mappings the ~~[value](#undefined)~~ must never be adjacent to the
"**`:`**", as this greatly reduces readability and is not required for ~~[JSON
compatibility](#undefined)~~ (unlike the case in ~~[flow mappings](#undefined)~~).

There is no compact notation for in-line ~~[values](#undefined)~~.
Also, while both the ~~[implicit key](#undefined)~~ and the ~~[value](#undefined)~~ following it may be empty,
the ~~["**`:`**"](#undefined)~~ indicator is mandatory.
This prevents a potential ambiguity with multi-line ~~[plain scalars](#undefined)~~.

<div id="rule-c-l-block-map-implicit-value(n)" />
<pre class="rule">
[194] c-l-block-map-implicit-value(n) ::=
  ":" ( s-l+block-node(n,block-out)
      | ( e-node s-l-comments ) )
</pre>

<div id="example-implicit-block-mapping-entries" class="example">
**Example 8.18 Implicit Block Mapping Entries**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">plain key</code><code class="legend-2">: in-line value</code>
<code class="legend-1">°</code><code class="legend-2">:° # Both empty</code>
<code class="legend-1">"quoted key"</code><code class="legend-2">:</code>
<code class="legend-2">- entry</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "plain key"
  : !!str "in-line value",
  ? !!null ""
  : !!null "",
  ? !!str "quoted key"
  : !!seq [ !!str "entry" ],
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-s-block-map-implicit-key">ns-s-block-map-implicit-key</a></code>
> * <code class="legend-2"><a href="#rule-c-l-block-map-implicit-value(n)">c-l-block-map-implicit-value(n)</a></code>
</div>
</div>

A ~~[compact in-line notation](#undefined)~~ is also available.
This compact notation may be nested inside ~~[block sequences](#undefined)~~ and explicit block
mapping entries.
Note that it is not possible to specify ~~[node properties](#undefined)~~ for such a nested
mapping.

<div id="rule-ns-l-compact-mapping(n)" />
<pre class="rule">
[195] ns-l-compact-mapping(n) ::=
  ns-l-block-map-entry(n)
  ( s-indent(n) ns-l-block-map-entry(n) )*
</pre>

<div id="example-compact-block-mappings" class="example">
**Example 8.19 Compact Block Mappings**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
- <code class="legend-1">sun: yellow↓</code>
- <code class="legend-1">? earth: blue↓</code>
<code class="legend-1">  : moon: white↓</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!map {
     !!str "sun" : !!str "yellow",
  },
  !!map {
    ? !!map {
      ? !!str "earth"
      : !!str "blue"
    },
    : !!map {
      ? !!str "moon"
      : !!str "white"
    },
  }
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-ns-l-compact-mapping(n)">ns-l-compact-mapping(n)</a></code>
</div>
</div>

<div id="block-nodes" />
### 8.2.3. Block Nodes


YAML allows ~~[flow nodes](#undefined)~~ to be embedded inside ~~[block collections](#undefined)~~ (but not
vice-versa). ~~[Flow nodes](#undefined)~~ must be [indented](#indentation-spaces) by at least one more [space](#white-space-characters) than
the parent ~~[block collection](#undefined)~~.
Note that ~~[flow nodes](#undefined)~~ may begin on a following line.

It is at this point that ~~[parsing](#undefined)~~ needs to distinguish between a ~~[plain
scalar](#undefined)~~ and an ~~[implicit key](#undefined)~~ starting a nested ~~[block mapping](#undefined)~~.

<div id="rule-s-l+block-node(n,c)" />
<pre class="rule">
[196] s-l+block-node(n,c) ::=
  s-l+block-in-block(n,c) | s-l+flow-in-block(n)
</pre>

<div id="rule-s-l+flow-in-block(n)" />
<pre class="rule">
[197] s-l+flow-in-block(n) ::=
  s-separate(n+1,flow-out)
  ns-flow-node(n+1,flow-out) s-l-comments
</pre>

<div id="example-block-node-types" class="example">
**Example 8.20 Block Node Types**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
-<code class="legend-1">↓</code>
<code class="legend-1">··"flow in block"↓</code>
-·<code class="legend-2">&gt;</code>
<code class="legend-2"> Block scalar↓</code>
-·<code class="legend-2">!!map # Block collection</code>
<code class="legend-2">  foo : bar↓</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!seq [
  !!str "flow in block",
  !!str "Block scalar\n",
  !!map {
    ? !!str "foo"
    : !!str "bar",
  },
]
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-s-l+flow-in-block(n)">s-l+flow-in-block(n)</a></code>
> * <code class="legend-2"><a href="#rule-s-l+block-in-block(n,c)">s-l+block-in-block(n,c)</a></code>
</div>
</div>

The block ~~[node’s properties](#undefined)~~ may span across several lines.
In this case, they must be [indented](#indentation-spaces) by at least one more [space](#white-space-characters) than the
~~[block collection](#undefined)~~, regardless of the [indentation](#indentation-spaces) of the ~~[block collection](#undefined)~~
entries.

<div id="rule-s-l+block-in-block(n,c)" />
<pre class="rule">
[198] s-l+block-in-block(n,c) ::=
  s-l+block-scalar(n,c) | s-l+block-collection(n,c)
</pre>

<div id="rule-s-l+block-scalar(n,c)" />
<pre class="rule">
[199] s-l+block-scalar(n,c) ::=
  s-separate(n+1,c)
  ( c-ns-properties(n+1,c) s-separate(n+1,c) )?
  ( c-l+literal(n) | c-l+folded(n) )
</pre>

<div id="example-block-scalar-nodes" class="example">
**Example 8.21 Block Scalar Nodes**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
literal: <code class="legend-1">|2</code>
<code class="legend-1">··value</code>
folded:<code class="legend-2">↓</code>
<code class="legend-2">···!foo</code>
<code class="legend-2">··&gt;1</code>
<code class="legend-2">·value</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "literal"
  : !!str "value",
  ? !!str "folded"
  : !&lt;!foo&gt; "value",
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-l+literal(n)">c-l+literal(n)</a></code>
> * <code class="legend-2"><a href="#rule-c-l+folded(n)">c-l+folded(n)</a></code>
</div>
</div>

Since people perceive the ~~["**`-`**" indicator](#undefined)~~ as [indentation](#indentation-spaces), nested ~~[block
sequences](#undefined)~~ may be [indented](#indentation-spaces) by one less [space](#white-space-characters) to compensate, except, of
course, if nested inside another ~~[block sequence](#undefined)~~ (~~[**`block-out`** context](#undefined)~~
vs. ~~[**`block-in`** context](#undefined)~~).

<div id="rule-s-l+block-collection(n,c)" />
<pre class="rule">
[200] s-l+block-collection(n,c) ::=
  ( s-separate(n+1,c) c-ns-properties(n+1,c) )?
  s-l-comments
  ( l+block-sequence(seq-spaces(n,c))
  | l+block-mapping(n) )
</pre>

<div id="rule-seq-spaces(n,c)" />
<pre class="rule">
[201] seq-spaces(n,c) ::=
  c = block-out ⇒ n-1
  c = block-in  ⇒ n
</pre>

<div id="example-block-collection-nodes" class="example">
**Example 8.22 Block Collection Nodes**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
sequence:<code class="legend-3"> !!seq</code>
<code class="legend-1"><code class="legend-3">- entry</code></code>
<code class="legend-1"><code class="legend-3">- !!seq</code></code>
<code class="legend-1"><code class="legend-3"> - nested</code></code>
mapping:<code class="legend-3"> !!map</code>
<code class="legend-2"><code class="legend-3"> foo: bar</code></code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  ? !!str "sequence"
  : !!seq [
    !!str "entry",
    !!seq [ !!str "nested" ],
  ],
  ? !!str "mapping"
  : !!map {
    ? !!str "foo" : !!str "bar",
  },
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-l+block-sequence(n)">l+block-sequence(n)</a></code>
> * <code class="legend-2"><a href="#rule-l+block-mapping(n)">l+block-mapping(n)</a></code>
> * <code class="legend-3"><a href="#rule-s-l+block-collection(n,c)">s-l+block-collection(n,c)</a></code>
</div>
</div>

<div id="yaml-character-stream" />
# Chapter 9. YAML Character Stream


<div id="documents" />
## 9.1. Documents


A YAML character [stream](#streams) may contain several _documents_.
Each document is completely independent from the rest.

<div id="document-prefix" />
### 9.1.1. Document Prefix


A document may be preceded by a _prefix_ specifying the ~~[character encoding](#undefined)~~,
and optional ~~[comment](#undefined)~~ lines.
Note that all [documents](#document) in a stream must use the same ~~[character encoding](#undefined)~~.
However it is valid to re-specify the ~~[encoding](#undefined)~~ using a ~~[byte order mark](#undefined)~~ for
each ~~[document](#undefined)~~ in the stream.
This makes it easier to concatenate streams.

The existence of the optional prefix does not necessarily indicate the
existence of an actual ~~[document](#undefined)~~.

<div id="rule-l-document-prefix" />
<pre class="rule">
[202] l-document-prefix ::=
  c-byte-order-mark? l-comment*
</pre>

<div id="example-document-prefix" class="example">
**Example 9.1 Document Prefix**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">⇔# Comment</code>
<code class="legend-1"># lines</code>
Document
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "Document"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-l-document-prefix">l-document-prefix</a></code>
</div>
</div>

<div id="document-markers" />
### 9.1.2. Document Markers


Using ~~[directives](#undefined)~~ creates a potential ambiguity.
It is valid to have a ~~["**`%`**"](#undefined)~~ character at the start of a line (e.g. as the
first character of the second line of a ~~[plain scalar](#undefined)~~).
How, then, to distinguish between an actual ~~[directive](#undefined)~~ and a [content](#nodes) line
that happens to start with a ~~["**`%`**"](#undefined)~~ character?

The solution is the use of two special _marker_ lines to control the processing
of ~~[directives](#undefined)~~, one at the start of a ~~[document](#undefined)~~ and one at the end.

At the start of a ~~[document](#undefined)~~, lines beginning with a ~~["**`%`**"](#undefined)~~ character are
assumed to be ~~[directives](#undefined)~~.
The (possibly empty) list of ~~[directives](#undefined)~~ is terminated by a _directives end
marker_ line.
Lines following this marker can safely use ~~["**`%`**"](#undefined)~~ as the first character.

At the end of a ~~[document](#undefined)~~, a _document end marker_ line is used to signal the
~~[parser](#undefined)~~ to begin scanning for ~~[directives](#undefined)~~ again.

The existence of this optional _document suffix_ does not necessarily indicate
the existence of an actual following ~~[document](#undefined)~~.

Obviously, the actual [content](#nodes) lines are therefore forbidden to begin with
either of these markers.

<div id="rule-c-directives-end" />
<pre class="rule">
[203] c-directives-end ::=
  "-" "-" "-"
</pre>

<div id="rule-c-document-end" />
<pre class="rule">
[204] c-document-end ::=
  "." "." "."
</pre>

<div id="rule-l-document-suffix" />
<pre class="rule">
[205] l-document-suffix ::=
  c-document-end s-l-comments
</pre>

<div id="rule-c-forbidden" />
<pre class="rule">
[206] c-forbidden ::=
  /* Start of line */
  ( c-directives-end | c-document-end )
  ( b-char | s-white | /* End of file */ )
</pre>

<div id="example-document-markers" class="example">
**Example 9.2 Document Markers**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
%YAML 1.2
<code class="legend-1">---</code>
Document
<code class="legend-2"><code class="legend-3">...</code> # Suffix</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "Document"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-c-directives-end">c-directives-end</a></code>
> * <code class="legend-2"><a href="#rule-c-document-end">c-document-end</a></code>
> * <code class="legend-3"><a href="#rule-l-document-suffix">l-document-suffix</a></code>
</div>
</div>

<div id="bare-documents" />
### 9.1.3. Bare Documents


A _bare document_ does not begin with any ~~[directives](#undefined)~~ or ~~[marker](#undefined)~~ lines.
Such documents are very "clean" as they contain nothing other than the [content](#nodes).
In this case, the first non-comment line may not start with a ~~["**`%`**"](#undefined)~~ first
character.

Document ~~[nodes](#undefined)~~ are [indented](#indentation-spaces) as if they have a parent [indented](#indentation-spaces) at -1
[spaces](#white-space-characters).
Since a [node](#nodes) must be more [indented](#indentation-spaces) than its parent [node](#nodes), this allows the
document’s [node](#nodes) to be [indented](#indentation-spaces) at zero or more [spaces](#white-space-characters).

<div id="rule-l-bare-document" />
<pre class="rule">
[207] l-bare-document ::=
  s-l+block-node(-1,block-in)
  /* Excluding c-forbidden content */
</pre>

<div id="example-bare-documents" class="example">
**Example 9.3 Bare Documents**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">Bare</code>
<code class="legend-1">document</code>
...
# No document
...
<code class="legend-1">|</code>
<code class="legend-1">%!PS-Adobe-2.0 # Not the first line</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "Bare document"
%YAML 1.2
---
!!str "%!PS-Adobe-2.0\n"
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-l-bare-document">l-bare-document</a></code>
</div>
</div>

<div id="explicit-documents" />
### 9.1.4. Explicit Documents


An _explicit document_ begins with an explicit ~~[directives end marker](#undefined)~~ line but
no ~~[directives](#undefined)~~.
Since the existence of the ~~[document](#undefined)~~ is indicated by this ~~[marker](#undefined)~~, the
~~[document](#undefined)~~ itself may be ~~[completely empty](#undefined)~~.

<div id="rule-l-explicit-document" />
<pre class="rule">
[208] l-explicit-document ::=
  c-directives-end
  ( l-bare-document
  | ( e-node s-l-comments ) )
</pre>

<div id="example-explicit-documents" class="example">
**Example 9.4 Explicit Documents**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">---</code>
<code class="legend-1">{ matches</code>
<code class="legend-1">% : 20 }</code>
...
<code class="legend-1">---</code>
<code class="legend-1"># Empty</code>
...
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  !!str "matches %": !!int "20"
}
...
%YAML 1.2
---
!!null ""
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-l-explicit-document">l-explicit-document</a></code>
</div>
</div>

<div id="directives-documents" />
### 9.1.5. Directives Documents


A _directives document_ begins with some ~~[directives](#undefined)~~ followed by an explicit
~~[directives end marker](#undefined)~~ line.

<div id="rule-l-directive-document" />
<pre class="rule">
[209] l-directive-document ::=
  l-directive+
  l-explicit-document
</pre>

<div id="example-directives-documents" class="example">
**Example 9.5 Directives Documents**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">%YAML 1.2</code>
<code class="legend-1">--- |</code>
<code class="legend-1">%!PS-Adobe-2.0</code>
...
<code class="legend-1">%YAML1.2</code>
<code class="legend-1">---</code>
<code class="legend-1"># Empty</code>
...
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "%!PS-Adobe-2.0\n"
...
%YAML 1.2
---
!!null ""
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-l-explicit-document">l-explicit-document</a></code>
</div>
</div>

<div id="streams" />
## 9.2. Streams


A YAML _stream_ consists of zero or more [documents](#document).
Subsequent [documents](#document) require some sort of separation ~~[marker](#undefined)~~ line.
If a ~~[document](#undefined)~~ is not terminated by a ~~[document end marker](#undefined)~~ line, then the
following ~~[document](#undefined)~~ must begin with a ~~[directives end marker](#undefined)~~ line.

The stream format is intentionally "sloppy" to better support common use cases,
such as stream concatenation.

<div id="rule-l-any-document" />
<pre class="rule">
[210] l-any-document ::=
    l-directive-document
  | l-explicit-document
  | l-bare-document
</pre>

<div id="rule-l-yaml-stream" />
<pre class="rule">
[211] l-yaml-stream ::=
  l-document-prefix* l-any-document?
  ( l-document-suffix+ l-document-prefix* l-any-document?
  | l-document-prefix* l-explicit-document? )*
</pre>

<div id="example-stream" class="example">
**Example 9.6 Stream**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
<code class="legend-1">Document</code>
<code class="legend-1">---</code>
<code class="legend-1"># Empty</code>
...
<code class="legend-3">%YAML 1.2</code>
<code class="legend-3">---</code>
<code class="legend-3">matches %: 20</code>
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!str "Document"
...
%YAML 1.2
---
!!null ""
...
%YAML 1.2
---
!!map {
  !!str "matches %": !!int "20"
}
</pre>

</td>
</tr>
</table>
<div class="legend" markdown=1>
> **Legend:**
> * <code class="legend-1"><a href="#rule-l-any-document">l-any-document</a></code>
> * <code class="legend-2"><a href="#rule-l-document-suffix">l-document-suffix</a></code>
> * <code class="legend-3"><a href="#rule-l-explicit-document">l-explicit-document</a></code>
</div>
</div>

A sequence of bytes is a _well-formed stream_ if, taken as a whole, it complies
with the above **`l-yaml-stream`** production.

Some common use case that can take advantage of the YAML stream structure are:

##### Appending to Streams

> Allowing multiple [documents](#document) in a single stream makes YAML suitable for log
> files and similar [applications](#processing-yaml-information).
> Note that each ~~[document](#undefined)~~ is independent of the rest, allowing for
> heterogeneous log file entries.

##### Concatenating Streams

> Concatenating two YAML streams requires both to use the same ~~[character
> encoding](#undefined)~~.
> In addition, it is necessary to separate the last ~~[document](#undefined)~~ of the first
> stream and the first ~~[document](#undefined)~~ of the second stream.
> This is easily ensured by inserting a ~~[document end marker](#undefined)~~ between the two
> streams.
> Note that this is safe regardless of the content of either stream.
> In particular, either or both may be empty, and the first stream may or may
> not already contain such a marker.

##### Communication Streams

> The ~~[document end marker](#undefined)~~ allows signaling the end of a ~~[document](#undefined)~~ without
> closing the stream or starting the next ~~[document](#undefined)~~.
> This allows the receiver to complete processing a ~~[document](#undefined)~~ without having
> to wait for the next one to arrive.
> The sender may also transmit "keep-alive" messages in the form of ~~[comment](#undefined)~~
> lines or repeated ~~[document end markers](#undefined)~~ without signalling the start of the
> next ~~[document](#undefined)~~.

<div id="recommended-schemas" />
# Chapter 10. Recommended Schemas


A YAML _schema_ is a combination of a set of ~~[tags](#undefined)~~ and a mechanism for
~~[resolving](#undefined)~~ ~~[non-specific tags](#undefined)~~.

<div id="failsafe-schema" />
## 10.1. Failsafe Schema


The _failsafe schema_ is guaranteed to work with any YAML ~~[document](#undefined)~~.
It is therefore the recommended ~~[schema](#undefined)~~ for generic YAML tools.
A YAML [processor](#processing-yaml-information) should therefore support this ~~[schema](#undefined)~~, at least as an
option.

<div id="tags" />
### 10.1.1. Tags


<div id="generic-mapping" />
#### 10.1.1.1. Generic Mapping


##### URI:

> **`tag:yaml.org,2002:map`**

##### Kind:

> ~~[Mapping](#undefined)~~.

##### Definition:

> ~~[Represents](#undefined)~~ an associative container, where each [key](#nodes) is unique in the
> association and mapped to exactly one ~~[value](#undefined)~~.
> YAML places no restrictions on the type of ~~[keys](#undefined)~~; in particular, they are
> not restricted to being ~~[scalars](#undefined)~~.
> Example ~~[bindings](#undefined)~~ to ~~[native](#undefined)~~ types include Perl’s hash, Python’s
> dictionary, and Java’s Hashtable.

<div id="example-map-examples" class="example">
**Example 10.1 `!!map` Examples**

<pre class="example">
Block style: !!map
  Clark : Evans
  Ingy  : döt Net
  Oren  : Ben-Kiki

Flow style: !!map { Clark: Evans, Ingy: döt Net, Oren: Ben-Kiki }
</pre>

</div>

<div id="generic-sequence" />
#### 10.1.1.2. Generic Sequence


##### URI:

> **`tag:yaml.org,2002:seq`**

##### Kind:

> ~~[Sequence](#undefined)~~.

##### Definition:

> ~~[Represents](#undefined)~~ a collection indexed by sequential integers starting with zero.
> Example ~~[bindings](#undefined)~~ to ~~[native](#undefined)~~ types include Perl’s array, Python’s list or
> tuple, and Java’s array or Vector.

<div id="example-seq-examples" class="example">
**Example 10.2 `!!seq` Examples**

<pre class="example">
Block style: !!seq
- Clark Evans
- Ingy döt Net
- Oren Ben-Kiki

Flow style: !!seq [ Clark Evans, Ingy döt Net, Oren Ben-Kiki ]
</pre>

</div>

<div id="generic-string" />
#### 10.1.1.3. Generic String


##### URI:

> **`tag:yaml.org,2002:str`**

##### Kind:

> [Scalar](#scalar).

##### Definition:

> ~~[Represents](#undefined)~~ a Unicode string, a sequence of zero or more Unicode characters.
> This type is usually ~~[bound](#undefined)~~ to the ~~[native](#undefined)~~ language’s string type, or, for
> languages lacking one (such as C), to a character array.

##### Canonical Form:

> The obvious.

<div id="example-str-examples" class="example">
**Example 10.3 `!!str` Examples**

<pre class="example">
Block style: !!str |-
  String: just a theory.

Flow style: !!str "String: just a theory."
</pre>

</div>

<div id="tag-resolution" />
### 10.1.2. Tag Resolution


All ~~[nodes](#undefined)~~ with the ~~["**`!`**" non-specific tag](#undefined)~~ are ~~[resolved](#undefined)~~, by the
standard ~~[convention](#undefined)~~, to "**`tag:yaml.org,2002:seq`**",
"**`tag:yaml.org,2002:map`**", or "**`tag:yaml.org,2002:str`**", according to
their ~~[kind](#undefined)~~.

All ~~[nodes](#undefined)~~ with the ~~["**`?`**" non-specific tag](#undefined)~~ are left ~~[unresolved](#undefined)~~.
This constrains the [application](#processing-yaml-information) to deal with a ~~[partial representation](#undefined)~~.

<div id="json-schema" />
## 10.2. JSON Schema


The _JSON schema_ is the lowest common denominator of most modern computer
languages, and allows ~~[parsing](#undefined)~~ JSON files.
A YAML [processor](#processing-yaml-information) should therefore support this ~~[schema](#undefined)~~, at least as an option.
It is also strongly recommended that other ~~[schemas](#undefined)~~ should be based on it.

<div id="tags" />
### 10.2.1. Tags


The JSON ~~[schema](#undefined)~~ uses the following ~~[tags](#undefined)~~ in addition to those defined by the
~~[failsafe](#undefined)~~ schema:

<div id="null" />
#### 10.2.1.1. Null


##### URI:

> **`tag:yaml.org,2002:null`**

##### Kind:

> [Scalar](#scalar).

##### Definition:

> ~~[Represents](#undefined)~~ the lack of a value.
> This is typically ~~[bound](#undefined)~~ to a ~~[native](#undefined)~~ null-like value (e.g., **`undef`** in
> Perl, **`None`** in Python).
> Note that a null is different from an empty string.
> Also, a ~~[mapping](#undefined)~~ entry with some [key](#nodes) and a null ~~[value](#undefined)~~ is valid, and
> different from not having that [key](#nodes) in the ~~[mapping](#undefined)~~.

##### Canonical Form:

> **`null`**.

<div id="example-null-examples" class="example">
**Example 10.4 `!!null` Examples**

<pre class="example">
!!null null: value for null key
key with null value: !!null null
</pre>

</div>

<div id="boolean" />
#### 10.2.1.2. Boolean


##### URI:

> **`tag:yaml.org,2002:bool`**

##### Kind:

> [Scalar](#scalar).

##### Definition:

> ~~[Represents](#undefined)~~ a true/false value.
> In languages without a ~~[native](#undefined)~~ Boolean type (such as C), is usually ~~[bound](#undefined)~~
> to a native integer type, using one for true and zero for false.

##### Canonical Form:

> Either **`true`** or **`false`**.

<div id="example-bool-examples" class="example">
**Example 10.5 `!!bool` Examples**

<pre class="example">
YAML is a superset of JSON: !!bool true
Pluto is a planet: !!bool false
</pre>

</div>

<div id="integer" />
#### 10.2.1.3. Integer


##### URI:

> **`tag:yaml.org,2002:int`**

##### Kind:

> [Scalar](#scalar).

##### Definition:

> ~~[Represents](#undefined)~~ arbitrary sized finite mathematical integers.
> Scalars of this type should be ~~[bound](#undefined)~~ to a ~~[native](#undefined)~~ integer data type, if
> possible.
>
> Some languages (such as Perl) provide only a "number" type that allows for
> both integer and floating-point values.
> A YAML [processor](#processing-yaml-information) may use such a type for integers, as long as they
> round-trip properly.
>
> In some languages (such as C), an integer may overflow the ~~[native](#undefined)~~ type’s
> storage capability.
> A YAML [processor](#processing-yaml-information) may reject such a value as an error, truncate it with a
> warning, or find some other manner to round-trip it.
> In general, integers representable using 32 binary digits should safely
> round-trip through most systems.

##### Canonical Form:

> Decimal integer notation, with a leading "**`-`**" character for negative
> values, matching the regular expression **`0 | -? [1-9] [0-9]*`**

<div id="example-int-examples" class="example">
**Example 10.6 `!!int` Examples**

<pre class="example">
negative: !!int -12
zero: !!int 0
positive: !!int 34
</pre>

</div>

<div id="floating-point" />
#### 10.2.1.4. Floating Point


##### URI:

> **`tag:yaml.org,2002:float`**

##### Kind:

> [Scalar](#scalar).

##### Definition:

> ~~[Represents](#undefined)~~ an approximation to real numbers, including three special values
> (positive and negative infinity, and "not a number").
>
> Some languages (such as Perl) provide only a "number" type that allows for
> both integer and floating-point values.
> A YAML [processor](#processing-yaml-information) may use such a type for floating-point numbers, as long as
> they round-trip properly.
>
> Not all floating-point values can be stored exactly in any given ~~[native](#undefined)~~ type.
> Hence a float value may change by "a small amount" when round-tripped.
> The supported range and accuracy depends on the implementation, though 32 bit
> IEEE floats should be safe.
> Since YAML does not specify a particular accuracy, using floating-point
> [mapping keys](#nodes) requires great care and is not recommended.

##### Canonical Form:

> Either **`0`**, **`.inf`**, **`-.inf`**, **`.nan`**, or scientific notation
> matching the regular expression
> **`-? [1-9] ( \. [0-9]* [1-9] )? ( e [-+] [1-9] [0-9]* )?`**.

<div id="example-float-examples" class="example">
**Example 10.7 `!!float` Examples**

<pre class="example">
negative: !!float -1
zero: !!float 0
positive: !!float 2.3e4
infinity: !!float .inf
not a number: !!float .nan
</pre>

</div>

<div id="tag-resolution" />
### 10.2.2. Tag Resolution


The ~~[JSON schema](#undefined)~~ ~~[tag resolution](#undefined)~~ is an extension of the ~~[failsafe schema](#undefined)~~
~~[tag resolution](#undefined)~~.

All ~~[nodes](#undefined)~~ with the ~~["**`!`**" non-specific tag](#undefined)~~ are ~~[resolved](#undefined)~~, by the
standard ~~[convention](#undefined)~~, to "**`tag:yaml.org,2002:seq`**",
"**`tag:yaml.org,2002:map`**", or "**`tag:yaml.org,2002:str`**", according to
their ~~[kind](#undefined)~~.

~~[Collections](#undefined)~~ with the ~~["**`?`**" non-specific tag](#undefined)~~ (that is, ~~[untagged](#undefined)~~
~~[collections](#undefined)~~) are ~~[resolved](#undefined)~~ to "**`tag:yaml.org,2002:seq`**" or
"**`tag:yaml.org,2002:map`**" according to their ~~[kind](#undefined)~~.

~~[Scalars](#undefined)~~ with the ~~["**`?`**" non-specific tag](#undefined)~~ (that is, ~~[plain scalars](#undefined)~~) are
matched with a list of regular expressions (first match wins, e.g. **`0`** is
resolved as **`!!int`**).
In principle, JSON files should not contain any ~~[scalars](#undefined)~~ that do not match at
least one of these.
Hence the YAML [processor](#processing-yaml-information) should consider them to be an error.

| Regular expression | Resolved to tag
| -- | --
| null | tag:yaml.org,2002:null
| true | false | tag:yaml.org,2002:bool
| -? ( 0 | [1-9] [0-9]* ) | tag:yaml.org,2002:int
| -? ( 0 | [1-9] [0-9]* ) ( \. [0-9]* )? ( [eE] [-+]? [0-9]+ )? | tag:yaml.org,2002:float
| * | Error

<div id="example-json-tag-resolution" class="example">
**Example 10.8 JSON Tag Resolution**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
A null: null
Booleans: [ true, false ]
Integers: [ 0, -0, 3, -19 ]
Floats: [ 0., -0.0, 12e03, -2E+05 ]
Invalid: [ True, Null, 0o7, 0x3A, +12.3 ]
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  !!str "A null" : !!null "null",
  !!str "Booleans: !!seq [
    !!bool "true", !!bool "false"
  ],
  !!str "Integers": !!seq [
    !!int "0", !!int "-0",
    !!int "3", !!int "-19"
  ],
  !!str "Floats": !!seq [
    !!float "0.", !!float "-0.0",
    !!float "12e03", !!float "-2E+05"
  ],
  !!str "Invalid": !!seq [
    # Rejected by the schema
    True, Null, 0o7, 0x3A, +12.3,
  ],
}
...
</pre>

</td>
</tr>
</table>
</div>

<div id="core-schema" />
## 10.3. Core Schema


The _Core schema_ is an extension of the ~~[JSON schema](#undefined)~~, allowing for more
human-readable [presentation](#presentation-stream) of the same types.
This is the recommended default ~~[schema](#undefined)~~ that YAML [processor](#processing-yaml-information) should use
unless instructed otherwise.
It is also strongly recommended that other ~~[schemas](#undefined)~~ should be based on it.

<div id="tags" />
### 10.3.1. Tags


The core ~~[schema](#undefined)~~ uses the same ~~[tags](#undefined)~~ as the ~~[JSON schema](#undefined)~~.

<div id="tag-resolution" />
### 10.3.2. Tag Resolution


The ~~[core schema](#undefined)~~ ~~[tag resolution](#undefined)~~ is an extension of the ~~[JSON schema](#undefined)~~ ~~[tag
resolution](#undefined)~~.

All ~~[nodes](#undefined)~~ with the ~~["**`!`**" non-specific tag](#undefined)~~ are ~~[resolved](#undefined)~~, by the
standard ~~[convention](#undefined)~~, to "**`tag:yaml.org,2002:seq`**",
"**`tag:yaml.org,2002:map`**", or "**`tag:yaml.org,2002:str`**", according to
their ~~[kind](#undefined)~~.

~~[Collections](#undefined)~~ with the ~~["**`?`**" non-specific tag](#undefined)~~ (that is, ~~[untagged](#undefined)~~
~~[collections](#undefined)~~) are ~~[resolved](#undefined)~~ to "**`tag:yaml.org,2002:seq`**" or
"**`tag:yaml.org,2002:map`**" according to their ~~[kind](#undefined)~~.

~~[Scalars](#undefined)~~ with the ~~["**`?`**" non-specific tag](#undefined)~~ (that is, ~~[plain scalars](#undefined)~~) are
matched with an extended list of regular expressions.
However, in this case, if none of the regular expressions matches, the [scalar](#scalar)
is ~~[resolved](#undefined)~~ to **`tag:yaml.org,2002:str`** (that is, considered to be a
string).

| Regular expression | Resolved to tag
| -- | --
| null | Null | NULL | ~ | tag:yaml.org,2002:null
| /* Empty */ | tag:yaml.org,2002:null
| true | True | TRUE | false | False | FALSE | tag:yaml.org,2002:bool
| [-+]? [0-9]+ | tag:yaml.org,2002:int (Base 10)
| 0o [0-7]+ | tag:yaml.org,2002:int (Base 8)
| 0x [0-9a-fA-F]+ | tag:yaml.org,2002:int (Base 16)
| [-+]? ( \. [0-9]+ | [0-9]+ ( \. [0-9]* )? ) ( [eE] [-+]? [0-9]+ )? | tag:yaml.org,2002:float (Number)
| [-+]? ( \.inf | \.Inf | \.INF ) | tag:yaml.org,2002:float (Infinity)
| \.nan | \.NaN | \.NAN | tag:yaml.org,2002:float (Not a number)
| * | tag:yaml.org,2002:str (Default)

<div id="example-core-tag-resolution" class="example">
**Example 10.9 Core Tag Resolution**

<table width="100%">
<tr>
<td class="side-by-side">
<pre>
A null: null
Also a null: # Empty
Not a null: ""
Booleans: [ true, True, false, FALSE ]
Integers: [ 0, 0o7, 0x3A, -19 ]
Floats: [ 0., -0.0, .5, +12e03, -2E+05 ]
Also floats: [ .inf, -.Inf, +.INF, .NAN ]
</pre>

</td>
<td class="side-by-side">
<pre>
%YAML 1.2
---
!!map {
  !!str "A null" : !!null "null",
  !!str "Also a null" : !!null "",
  !!str "Not a null" : !!str "",
  !!str "Booleans: !!seq [
    !!bool "true", !!bool "True",
    !!bool "false", !!bool "FALSE",
  ],
  !!str "Integers": !!seq [
    !!int "0", !!int "0o7",
    !!int "0x3A", !!int "-19",
  ],
  !!str "Floats": !!seq [
    !!float "0.", !!float "-0.0", !!float ".5",
    !!float "+12e03", !!float "-2E+05"
  ],
  !!str "Also floats": !!seq [
    !!float ".inf", !!float "-.Inf",
    !!float "+.INF", !!float ".NAN",
  ],
}
...
</pre>

</td>
</tr>
</table>
</div>

<div id="other-schemas" />
## 10.4. Other Schemas


None of the above recommended ~~[schemas](#undefined)~~ preclude the use of arbitrary explicit
~~[tags](#undefined)~~.
Hence YAML ~~[processors](#undefined)~~ for a particular programming language typically provide
some form of ~~[local tags](#undefined)~~ that map directly to the language’s ~~[native data
structures](#undefined)~~ (e.g., **`!ruby/object:Set`**).

While such ~~[local tags](#undefined)~~ are useful for ad-hoc [applications](#processing-yaml-information), they do not
suffice for stable, interoperable cross-[application](#processing-yaml-information) or cross-platform data
exchange.

Interoperable ~~[schemas](#undefined)~~ make use of ~~[global tags](#undefined)~~ (URIs) that ~~[represent](#undefined)~~ the
same data across different programming languages.
In addition, an interoperable ~~[schema](#undefined)~~ may provide additional ~~[tag resolution](#undefined)~~
rules.
Such rules may provide additional regular expressions, as well as consider the
path to the [node](#nodes).
This allows interoperable ~~[schemas](#undefined)~~ to use ~~[untagged](#undefined)~~ ~~[nodes](#undefined)~~.

It is strongly recommended that such ~~[schemas](#undefined)~~ be based on the ~~[core schema](#undefined)~~
defined above.
In addition, it is strongly recommended that such ~~[schemas](#undefined)~~ make as much use as
possible of the the _YAML tag repository_ at [http://yaml.org/type/](/type/).
This repository provides recommended ~~[global tags](#undefined)~~ for increasing the
portability of YAML [documents](#document) between different [applications](#processing-yaml-information).

The tag repository is intentionally left out of the scope of this specification.
This allows it to evolve to better support YAML [applications](#processing-yaml-information).
Hence, developers are encouraged to submit new "universal" types to the
repository.
The yaml-core mailing list at
[http://lists.sourceforge.net/lists/listinfo/yaml-core](http://lists.sourceforg
e.net/lists/listinfo/yaml-core) is the preferred method for such submissions,
as well as raising any questions regarding this draft.

# Index
