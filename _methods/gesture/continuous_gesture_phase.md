---
slug: continuous_gesture_phase
title: "public enum ContinuousGesturePhase{}"
js-title: "ContinuousGesturePhase"
doctype:
    - enum
---

`ContinuousGesturePhase` is an enum specifying a phase of continuous gesture recognition (see above).

When a gesture has just recognized, it will invoke its handler with phase `Began`. Then it will repeatedly invoke the handler with `Changed` until finally invoking it with either `Ended` or `Cancelled`.

`ContinuousGesturePhase` has the following fields:

<div class="swift-only">
{% highlight swift %}
public enum ContinuousGesturePhase {
    case Began
    case Changed
    case Ended
    case Cancelled
}
{% endhighlight %}
</div>

<div class="js-only">
{% highlight js %}
ContinuousGesturePhase.Began
ContinuousGesturePhase.Changed
ContinuousGesturePhase.Ended
ContinuousGesturePhase.Cancelled
{% endhighlight %}
</div>
