---
layout: api_doc
slug: color
title: Color
doctype: struct
---

A simple representation of color. All color components range from 0.0 to 1.0, e.g.

<div class="swift-only">
{% highlight swift %}
layer.backgroundColor = Color(hue: 0.4, saturation: 0.8, brightness: 0.2)
{% endhighlight %}
</div>

<div class="js-only">
{% highlight js %}
layer.backgroundColor = new Color({hue: 0.4, saturation: 0.8, brightness: 0.2})
{% endhighlight %}
</div>