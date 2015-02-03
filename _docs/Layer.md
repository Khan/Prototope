---
layout: api_doc
slug: layer
title: Layer
doctype: class
---


Layers are the fundamental building block of Prototope.

A layer displays content (a color, an image, etc.) and can route touch events.

Layers are stored in a tree. It's *possible* to make a layer without a parent, but only layers in the tree starting at `Layer.root` will be displayed.

{% highlight swift %}
let redLayer = Layer(parent: Layer.root)
redLayer.backgroundColor = Color.red
redLayer.frame = Rect(x: 50, y: 50, width: 100, height: 100)
{% endhighlight %}

But first things first: how do you set `Layer.root`?

## Getting started

in iOS Setting a root layer requires having a uiview available to you. Typically, you can use the view available to you from your main `ViewController`'s `viewDidLoad` method. When you have that, you can set it as your root using `Layer.setRoot()` like so:

{% highlight swift %}
override func viewDidLoad() {
    super.viewDidLoad()
    Layer.setRoot(fromView: view)
}
{% endhighlight %}

Once you have a root layer, you are free to create named layers, give layers sizes, add layers to those layers and begin adding behaviors to those layers. Prototope's layers are similar to `div`s in html and `Layer()`s in Framer.

You can create a layer with just a background color or you can create one with an image. If you go the image route, the layer is sized to match the image.
