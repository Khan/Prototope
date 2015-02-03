---
slug: animators
title: "public var animators: LayerAnimatorStore"
doctype:
    - variable
    - extension
---
Provides access to a collection of dynamic animators for the properties on this layer.

If you want a layer to animate towards a point in a physical fashion (i.e. with speed determined by physical parameters, not a fixed duration), or if you want to take into account gesture velocity, this is your API.

For example, this dynamically animates someLayer's x value to 400 using velocity from a touch sequence:

{% highlight swift %}
someLayer.animators.x.target = 400
someLayer.animators.x.velocity = touchSequence.currentVelocityInLayer(someLayer.superlayer!)
{% endhighlight %}

See documentation for `LayerAnimatorStore` and `Animator` for more information.

If you just want to change a bunch of values in a fixed-time animation, see `Layer.animateWithDuration(:, animations:, completionHandler:)`.
