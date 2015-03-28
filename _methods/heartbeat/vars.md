---
slug: vars
layout: variables
doctype:
    - variable
variables:
  -
    name: "public var paused: Bool"
    js-name: "this.paused"
    js-type: Boolean
    desc: |
        The `Heartbeat`'s handler won't be called when `paused` is `true`.

        Defaults to `false`.
  -
    name: "public var timestamp: Timestamp"
    js-name: "this.timestamp"
    js-type: Number
    desc: |
        The timestamp of the last frame that was displayed. Only valid to call from inside the `Heartbeat`'s handler block.

        You generally want to use this timestamp to do animations or to do other time math in your heartbeat, instead of using `Timestamp.currentTimestamp`: these timestamps will be spaced at regular 16.67ms intervals, whereas `Timestamp.currentTimestamp` will return a value that will vary depending on when it's called in the time between frames being rendered.
---
