---
slug: vars
layout: variables
doctype:
    - variable
variables:
  -
    name: "public var birthRate: Double"
    desc: "How often new baby particles are born."
  -
    name: "public var renderMode: String"
    desc: |
        The render mode of the emitter.

        In particular, CAEmitterLayer defines the following:

        * `let kCAEmitterLayerPoints: NSString!`
          * Particles are emitted from points on the particle emitter.
        * `let kCAEmitterLayerOutline: NSString!`
          * Particles are emitted from the outline of the particle emitter.
        * `let kCAEmitterLayerSurface: NSString!`
          * Particles are emitted from the surface of the particle emitter.
        * `let kCAEmitterLayerVolume: NSString!`
          * Particles are emitted from the a position within the particle emitter.

        The default is `kCAEmitterLayerUnordered`.
  -
    name: "public var shape: String"
    desc: |
        The shape of the emitter. c.f., [CAEmitterLayer](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CAEmitterLayer_class/index.html) for valid strings.

        In particular, CAEmitterLayer defines:

        * `let kCAEmitterLayerPoint: NSString!`
        * `let kCAEmitterLayerLine: NSString!`
        * `let kCAEmitterLayerRectangle: NSString!`
        * `let kCAEmitterLayerCuboid: NSString!`
        * `let kCAEmitterLayerCircle: NSString!`
        * `let kCAEmitterLayerSphere: NSString!`

        Again, see the class reference for more information.

  -
    name: "public var size: Size"
    desc: "Determines the size of the particle emitter shape."
  -
    name: "public var position: Point"
    desc: "The position of the emitter. The Point where particles are birthed from."
  -
    name: "public var x: Double"
    desc: "The x position of the emitter. This is a shortcut for `position`."
  -
    name: "public var y: Double"
    desc: "The y position of the emitter. This is a shortcut for `position`."
---
