---
layout: playground
title: JavaScript YAML Loaders

eatme:
  slug: playground-devel
  cols: 4
  html: <div class="container-fluid row">

  pane:
  - name: YAML Text Input
    slug: text
    type: input
    colx: 1

  - name: YAML Reference Parser Events
    slug: events
    call: [refparser-events, text]
    colx: 1

  - name: NPM yaml.js master Parse to Events
    slug: npmyamlmasterevent
    type: text
    call: [npmyamlmaster-event, text]
    colx: 2

  - name: NPM yaml.js master Load to JSON
    slug: npmyamlmasterjson
    type: text
    call: [npmyamlmaster-json, text]
    colx: 2

  - name: NPM yaml.js v2.0.0.6 Parse to Events
    slug: npmyaml2event
    type: text
    call: [npmyaml2-event, text]
    colx: 3

  - name: NPM yaml.js v2.0.0.6 Load to JSON
    slug: npmyaml2
    type: text
    call: [npmyaml2-json, text]
    colx: 3

  - name: NPM yaml.js v1.10.2 Parse to Events
    slug: npmyaml1event
    type: text
    call: [npmyaml1-event, text]
    colx: 4

  - name: NPM yaml.js v1.10.2 Load to JSON
    slug: npmyaml1
    type: text
    call: [npmyaml1-json, text]
    colx: 4

#   - name: NPM yamljs Load to JSON
#     slug: npmjsyaml
#     type: text
#     call: [npmjsyaml-json, text]
#     colx: 3

#   - name: NPM js-yaml Load to JSON
#     slug: npmjsyaml
#     type: text
#     call: [npmjsyaml-json, text]
#     colx: 3
---
```
# Edit Me!

%YAML 1.2
---
foo: Hello, YAML!
bar: [123, true]
baz:
- one
- two
- null
```
