---
layout: api_doc
slug: border
title: Border
doctype: struct
---

`Border` is a simple specification of how a `Layer` should draw its border. <span class="swift-only">It's a `struct`, so a new copy is made every time it's assigned to a variable.</span>

<div class="js-only">
You can't modify the properties of a `Border` once it's made: to change a border's width, make a new one like this:

{% highlight js %}
// say you have an oldBorder and you want to change its width...
var newBorder = new Border({color: oldBorder.color, width: myNewWidth})
{% endhighlight %}
</div>