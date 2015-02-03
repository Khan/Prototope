---
slug: vars_hierarchy
layout: variables
doctype:
    - variable
title: Variables for layer hierarchy
variables:
  -
    name: "public weak var parent: Layer?"
    desc: ""
  -
    name: "public private(set) var sublayers: [Layer] = []"
    desc: ""
  -
    name: "public var sublayerAtFront: Layer?"
    desc: Layers stack, in order in which they are added. A layer added last to some parent will appear to be the frontmost layer.
---
