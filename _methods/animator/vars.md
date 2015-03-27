---
slug: vars
layout: variables
doctype:
    - variable
variables:
  -
    name: "public var target: Target?"
    js-name: "this.target"
    js-type: "(Varies, see below)"
    desc: |
      The target value for this animator. The `Animator` will continuously move its layer's value closer to this value. When the animation completes, the target value will be set back to <span class='swift-only'>`nil`</span><span class='js-only'>`undefined`</span>.

      The type of this property will vary based on the animator. For instance, `Layer.animators.x`'s target is a <span class='swift-only'>`Double`</span><span class='js-only'>`Number`</span>, but `Layer.animators.backgroundColor` is a `Color`.
  -
    name: "public var springSpeed: Double"
    js-name: "this.springSpeed"
    js-type: "Number"
    desc: "How quickly the animation resolves to the target value. Valid range from 0 to 20. Defaults to 4."
  -
    name: "public var springBounciness: Double = 12.0 "
    js-name: "this.springBounciness"
    js-type: "Number"
    desc: "How springily the animation resolves to the target value. Valid range from 0 to 20. Defaults to 12."
  -
    name: "public var velocity: Target?"
    js-name: "this.velocity"
    js-type: "(Varies, see below)"
    desc: |
      The instantaneous velocity of the layer, specified in `target`'s units per second.

      For instance, if this animator affects `x`, `velocity` is specified in points per second.
  -
    name: "public var completionHandler: (() -> Void)? "
    js-name: "this.completionHandler"
    js-type: "Function"
    desc: "This function is called whenever the animation resolves to its target value."

---
