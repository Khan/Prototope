---
slug: vars_convenience
layout: variables
title: Convenience Utilities
doctype:
    - variable
variables:
  -
    name: "public private(set) var willBeRemovedSoon: Bool = false"
    desc: ""
  -
    name: "public func removeAfterDuration(duration: NSTimeInterval)"
    desc: "Although the argument is an <code>NSTimeInterval</code>, you can enter seconds here with <code>double</code> resolution."
    type: "method"
  -
    name: "public func fadeOutAndRemoveAfterDuration(duration: NSTimeInterval)"
    desc: "Although the argument is an <code>NSTimeInterval</code>, you can enter seconds here with <code>double</code> resolution."
    type: "method"
  -
    name: "public var hashValue: Int"
    desc: "a property that returns a hash for your layer (presumably to compare it with another layer, as in <code>==</code>)"
  -
    name: "public var description: String"
    desc: "a readonly property that returns a printable version of your layer"
  -
    name: "public func ==(a: Layer, b: Layer) -> Bool"
    desc: ""
    type: "method"
---
