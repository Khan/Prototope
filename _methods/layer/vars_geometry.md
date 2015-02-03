---
slug: vars_geometry
layout: variables
doctype:
    - variable
variables:
  -
    name: "var x: Double"
    desc: "sets the x position of the <i>middle</i> of your layer, relative to its parent."
  -
    name: "var y: Double"
    desc: "sets the y position of the <i>middle</i> of your layer, relative to its parent."
  -
    name: "var position: Point"
    desc: "If you have received a point (possibly from a touch handler), you may use that value directly to set a layer's x/y pair directly."
  -
    name: "var width: Double"
    desc: "Sets the width of the layer in device points."
  -
    name: "var height: Double"
    desc: "Sets the height of the layer in device points."
  -
    name: "var size: Size"
    desc: "Sets the width and height at once, if you have received a Size from some other method."
  -
    name: "var frame: Rect"
    desc: |
        Similar to <code>size</code>, the frame defines both the size and the position of the layer with respect to its parent. See the Rect docs for more information about Rects (which are defined by an <code>origin</code> and a <code>size</code>).

        Because the frame is defined with respect to the layer's parent, it's usually best to modify the frame when operating in the parent's context.
  -
    name: "var bounds: Rect"
    desc: ""
  -
    name: "var anchorPoint: Point"
    desc: ""
  -
    name: "var rotationDegrees: Double"
    desc: ""
  -
    name: "var rotationRadians: Double = 0"
    desc: ""
  -
    name: "var scale: Double"
    desc: ""
  -
    name: "var scaleX: Double = 1"
    desc: ""
  -
    name: "var scaleY: Double = 1"
    desc: ""
  -
    name: "var globalPosition: Point"
    desc: ""

---

All the geometry variables of Layers are read/write, such that setting any of these variables will cause the layer to update to that value.
