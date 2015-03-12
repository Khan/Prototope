---
layout: api_doc
slug: animator
title: Animator
doctype: class
---
`Animator` represents a *dynamic animator* for a particular variable. It continuously moves some value towards its target. You can use this to animate a layer property in a physical fashion.

You would normally access an animator through `Layer.animators` (see `LayerAnimatorStore`), like this:

{% highlight swift %}
myLayer.animators.x.target = 20 // Animate x to 20
// Here, myLayer.animators.x is the Animator.
{% endhighlight %}

*Dynamic animations* are distinct from more traditional animations in that you don't specify a duration or a curve: motion depends on the layer's velocity and its distance from the target. Instead, you adjust a more abstract speed parameter (see `springSpeed` below).