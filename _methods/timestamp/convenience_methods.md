---
slug: convenience_methods
layout: variables
sublayout: convenience
doctype:
    - variable
variables:
  -
    name: "public func <(a: Timestamp, b: Timestamp) -> Bool"
    desc: ""
  -
    name: "public func ==(a: Timestamp, b: Timestamp) -> Bool"
    desc: ""
  -
    name: "public func -(a: Timestamp, b: Timestamp) -> TimeInterval"
    desc: ""
  -
    name: "public func afterDuration(duration: TimeInterval, action: () -> Void)"
    desc: |
      Performs an action after a duration.
---

n.b. `afterDuration` is not a method of Timestamp, you can run it anywhere, but it shows up here anyway.
