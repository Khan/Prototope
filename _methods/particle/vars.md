---
slug: vars
layout: variables
doctype:
    - variable
variables:
  -
    desc: "The lifetime, in seconds, of particles."
    name: "public var lifetime: Double"

  -
    desc: "The range of variation for the particle's lifetime."
    name: "public var lifetimeRange: Double"

  -
    desc: "The birth rate, in particle / second, for new particles."
    name: "public var birthRate: Double"

  -
    desc: "The scale of the particles."
    name: "public var scale: Double"

  -
    desc: "The range of particle scale."
    name: "public var scaleRange: Double"

  -
    desc: "The spin of particles. Positive values spin clockwise, negative values spin counter-clockwise."
    name: "public var spin: Radian"
  -
    desc: "The spin range of particles. Positive values spin clockwise, negative values spin counter-clockwise."
    name: "public var spinRange: Radian"
  -
    desc: "The velocity of particles."
    name: "public var velocity: Double"
  -
    desc: "The velocity range of particles."
    name: "public var velocityRange: Double"
  -
    desc: |
        The emission range, in radians. Particles are uniformly distributed in this range.

        Set to a full circle (2π) for a full circular range.
    name: "public var emissionRange: Radian"

  -
    desc: "The colour of the particle. Or 'color'"
    name: "public var color: Color"

  -
    desc: "The range of red in the particle."
    name: "public var redRange: Double"

  -
    desc: "The range of blue in the particle."
    name: "public var blueRange: Double"

  -
    desc: "The range of green in the particle."
    name: "public var greenRange: Double"

  -
    desc: "The range of alpha in the particle."
    name: "public var alphaRange: Double"

  -
    desc: "The speed of red in the particle."
    name: "public var redSpeed: Double"

  -
    desc: "The speed of blue in the particle."
    name: "public var blueSpeed: Double"

  -
    desc: "The speed of green in the particle."
    name: "public var greenSpeed: Double"

  -
    desc: "The speed of alpha in the particle."
    name: "public var alphaSpeed: Double"

  -
    desc: "The x acceleration of particles."
    name: "public var xAcceleration: Double"

  -
    desc: "The y acceleration of particles."
    name: "public var yAcceleration: Double"

  -
    desc: "The z acceleration of particles."
    name: "public var zAcceleration: Double"

---
