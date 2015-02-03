---
slug: init_convenience
title: "public convenience init(parent: Layer?, imageName: String)"
doctype:
    - method
    - initializer
---

Setting an `imageName` will look for the image in your project with a matching name.

in iOS, you do not need to specify the file extension, you may simply write

{% highlight swift %}
sled: Layer = Layer(nil, "dogesled")
{% endhighlight %}

This will match "dogesled.png", "dogesled.jpg", and even "dogesled@2x.png" on hidpi devices
