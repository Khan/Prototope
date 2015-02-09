---
layout: api_doc
slug: particleemitter
title: ParticleEmitter
doctype: class
---
A particle emitter shows one or more kinds of Particles, and can show them in different formations.

The general strategy here is as follows:

{% highlight swift %}

// make a sunny expanse
var playa = Layer()
playa.size = Size(width: 300, height: 200)
Layer.root.addLayer(playa)

// create a Particle from a stack of 'benjamin's and
// with a preset of .Sparkle
let rain = Particle(image: "benjamin", preset: .Sparkle)

// make an emitter that always makes it rain
let sparklePony = ParticleEmitter(particle: rain)

// put our sparklepony on our sunny expanse
playa.addParticleEmitter(sparklePony)

{% endhighlight %}

Once you add the `ParticleEmitter` to a layer, it will emit particles continually until you remove it.

Although you need an emitter to 'make it rain,' you should look at `Particle` instead to get details on how to style out your fat wads of Benjamins.
