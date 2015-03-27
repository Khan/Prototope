---
layout: api_doc
slug: gesture
title: Gesture
doctype: meta
---

Gestures are like a higher-level abstraction than the `Layer` touch handler API. For
instance, a `PanGesture` consumes a series of touch events but does not actually begin
until the user moves a certain distance with a specified number of fingers.
Gestures can also be exclusive: by default, if a gesture recognizes, traditional
touch handlers for that subtree will be cancelled. You can control this with the
`cancelsTouchesInView` argument to `Gesture` initializers (see docs for
individual gestures for more details).

Also by default, if one gesture recognizes, it will prevent all other gestures
involved in that touch from recognizing. For instance, if you attach both a
`PanGesture` and a `PinchGesture` to a layer, and the pinch gesture
recognizes, then the pan gesture will not also try to recognize. You can
control this with the `shouldRecognizeSimultaneouslyWithGesture` property (see
docs for individual gestures for more details).

You don't make a `Gesture` directly--you always make some *kind* of gesture.
See `PanGesture`, `TapGesture`, `PinchGesture`, `RotationGesture` to learn
more.

<div class="swift-only">
{% highlight swift %}
layer.gestures = [
	TapGesture { location in println("Tapped at \(location)") }
]
{% endhighlight %}
</div>

<div class="js-only">
{% highlight js %}
layer.gestures = [
	new TapGesture({handler: function(location) {
		console.log("Tapped at " + location)
	}})
]
{% endhighlight %}
</div>


### Continuous vs. discrete gestures

Continuous gestures are different from discrete gestures in that they pass
through several phases. A discrete gesture simply recognizes--then it's done.
A continuous gesture begins, then may change over the course of several
events, then ends (or is cancelled). Continuous gestures will pass their
current phase (a `ContinuousGesturePhase`; see below) to their handlers.