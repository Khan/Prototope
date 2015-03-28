---
layout: api_doc
slug: heartbeat
title: Heartbeat
doctype: class
---

Allows you to run code once for every frame the display will render. This is a way of programming in "[immediate mode](http://en.wikipedia.org/wiki/Immediate_mode_(computer_graphics))" with Prototope.

<div class="swift-only">
{% highlight swift %}
let firstTimestamp = Timestamp.currentTimestamp
Heartbeat { heartbeat
    someLayer.x = sin(heartbeat.currentTimestamp - firstTimestamp) * 100 + 200
}
{% endhighlight %}
</div>

<div class="js-only">
{% highlight js %}
new Heartbeat({handler: function(heartbeat) {
    someLayer.x = Math.sin(heartbeat.currentTimestamp) * 100 + 200
}})
{% endhighlight %}
</div>
