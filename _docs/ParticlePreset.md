---
layout: api_doc
slug: particlepreset
title: ParticlePreset
doctype: enum
---

{% highlight swift %}
public enum ParticlePreset {
    /** Particles explode in all directions. */
    case Explode
    /** Particles fall like rain all the way down. */
    case Rain
    /** Particles fly upward and and quickly burn out. */
    case Sparkle
    /** Sets nothing on the particle. We trust you to do the right thing. */
    case IKnowWhatImDoing
}
{% endhighlight %}

`ParticlePreset` is useful for simplifying the creation of particles. By choosing a preset and passing it to a particle on creation, you get a ton of free `Particle` config values.

It also defines a special preset, the default for particles, `.IKnowWhatImDoing` which sets no defaults, leaving you to figure it all out on your own.

For details on the implementation for each, please take a look at [`ParticlePreset.swift`](https://github.com/Khan/Prototope/blob/master/Prototope/ParticlePreset.swift) in Prototope.

Sadly, you can't define other presets in your own code, but you may encapsulate a default particle with the attributes you wish.
