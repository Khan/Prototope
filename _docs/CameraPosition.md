---
layout: api_doc
slug: cameraposition
title: CameraPosition
doctype: enum
---

Specifies one of the device's camera by its position. Used with `CameraLayer`.

{% highlight swift %}
public enum CameraPosition: Printable {
	/** The device's front-facing camera. */
	case Front

	/** The device's back-facing camera. */
	case Back
}
{% endhighlight %}