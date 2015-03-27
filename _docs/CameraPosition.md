---
layout: api_doc
slug: cameraposition
title: CameraPosition
doctype: enum
---

Specifies one of the device's camera by its position. Used with `CameraLayer`.

<div class="swift-only">
{% highlight swift %}
public enum CameraPosition: Printable {
	/** The device's front-facing camera. */
	case Front

	/** The device's back-facing camera. */
	case Back
}
{% endhighlight %}
</div>
<div class="js-only">
{% highlight js %}
CameraPosition.Front // the device's front camera
CameraPosition.Back // the device's back camera
{% endhighlight %}
</div>