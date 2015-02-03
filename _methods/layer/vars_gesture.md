---
slug: vars_gesture
layout: variables
doctype:
    - variable
variables:
  -
    name: "public var userInteractionEnabled: Bool"
    desc: "When false, touches that hit this layer or its sublayers are discarded. Defaults to true"
  -
    name: "public var gestures: [GestureType] = []"
    desc: "Append Gestures to this property to add them to the layer. By default, this is an empty list."
  -
    name: "public typealias TouchesHandler = [UITouchID: TouchSequence<UITouchID>] -> Bool"
    desc: ""
    type: "typealias"
  -
    name: "public typealias TouchHandler = TouchSequence<UITouchID> -> Void"
    desc: ""
    type: "typealias"
  -
    name: "public var activeTouchSequences: [UITouchID: TouchSequence<UITouchID>]"
    desc: ""
  -
    name: "public var touchesBeganHandler: TouchesHandler?"
    desc: ""
  -
    name: "public var touchBeganHandler: TouchHandler?"
    desc: ""
  -
    name: "public var touchesMovedHandler: TouchesHandler?"
    desc: ""
  -
    name: "public var touchMovedHandler: TouchHandler?"
    desc: ""
  -
    name: "public var touchesEndedHandler: TouchesHandler?"
    desc: ""
  -
    name: "public var touchEndedHandler: TouchHandler?"
    desc: ""
  -
    name: "public var touchesCancelledHandler: TouchesHandler?"
    desc: ""
  -
    name: "public var touchCancelledHandler: TouchHandler?"
    desc: ""
  -
    name: "public var touchedDescendents: [Layer]"
    desc: ""
---
