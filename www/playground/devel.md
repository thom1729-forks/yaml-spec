---
layout: playground
title: YAML Playground Playground

eatme:
  slug: playground-devel
  cols: 4
  html: <div class="container-fluid row">

  pane:
  - name: Playground Menu
    slug: menu
    type: menu
    load: /main-menu.html

  - name: YAML Text Input
    slug: text
    type: input
    colx: 1

  - name: YAML Reference Parser Events
    slug: events
    call: [refparser-events, text]
    colx: 2

  - name: YAML::PP Events
    slug: yamlpp
    type: text

  - name: NPM yaml.js 1.10.2 Parse to Event
    slug: npmyaml
    type: text
    call: [npmyaml1-event, text]
    colx: 3

  - name: NPM yaml.js 2.0.0 Parse to Event
    slug: npmyaml2
    type: text
    call: [npmyaml2-event, text]
    colx: 4

  - name: DOM State
    type: text
    slug: dom

  - name: Native Data Structure
    slug: native
    type: text

  - name: JavaScript
    slug: javascript
    type: text

  - name: Parser Grammar
    slug: grammar
    type: input
    load: /grammar.yaml
    # call: rebuild

  - name: EatMe Settings
    slug: settings
    type: settings
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
