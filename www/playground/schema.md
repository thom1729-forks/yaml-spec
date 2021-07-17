---
layout: playground
title: YAML Playground Playground

eatme:
  slug: playground-devel
  cols: 4
  html: <div class="container-fluid row">

  pane:
  - name: YAML Schema Input
    slug: schema
    type: input
    colx: 1

  - name: YAML Text Input
    slug: yaml
    type: input
    colx: 2

  - name: Native JavaScript
    slug: native
    call: [schema-load, schema, yaml]
    colx: 3

  - name: Schema Compiled
    slug: compiled
    call: [schema-compile, schema]
    colx: 4
---
foo

<eatme conf=schema size=full cols=3>
```
+root: ++contact[]

+contact:
  pair:
    name: +str/name
    phone: +phone-entry[]

+phone-entry:
  pair:
  - type: <mobile home work>
  - number: +phone-number

```

```
- name: Ingy dot Net
  phone: 222-222-222
- name: Tina Muller
  phone:
  - 333-333-333
  - 444-444-444
- name: Clark Evans
    mobile: 555-555-555
    work: 666-666-666
```
</eatme>
