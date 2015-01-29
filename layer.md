---
layout: page
title: Layer
permalink: /Layer/
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

Once you have a root layer, you are free to create named layers, give layers sizes, add layers to those layers and begin adding behaviors to those layers. Prototope's layers are similar to `div`s in html and `layer`s in Framer.



## Method and Property Reference

<h3>Setting the Root Layer</h3>

<ul>
<li class="method">
    <h4>public class func setRoot(fromView view: UIView)</h4>
    <p>Call this method, likely in your <code>ViewController.swift</code> file, probably like:</p>

{% highlight swift %}
override func viewDidLoad() {
    super.viewDidLoad()
    Layer.setRoot(fromView: view)
}
{% endhighlight %}
</li>
</ul>

### Creating and identifying layers

<ul>
<li class="variable">
    <h4>public class var root: Layer</h4>
</li>
<li class="method initializer">
    <h4>public init(parent: Layer? = nil, name: String? = nil)</h4>
</li>
<li class="method initializer convenience">
    <h4>public convenience init(parent: Layer?, imageName: String)</h4>
</li>
<li class="method initializer convenience">
    <h4>public convenience init(wrappingCALayer: CALayer, name: String? = nil)</h4>
</li>
<li class="variable">
    <h4>public let name: String?</h4>
</li>
</ul>

### Layer hierarchy access and manipulation

<ul>
<li class="variable">
    <h4>public weak var parent: Layer?</h4>
</li>
<li class="variable">
    <h4>public private(set) var sublayers: [Layer] = []</h4>
</li>
<li class="method">
    <h4>public func removeAllSublayers()</h4>
</li>
<li class="variable">
    <h4>public var sublayerAtFront: Layer? { return sublayers.last }</h4>
</li>
<li class="method">
    <h4>public func sublayerNamed(name: String) -> Layer?</h4>
</li>
<li class="method">
    <h4>public func descendentNamed(name: String) -> Layer?</h4>
</li>
<li class="method">
    <h4>public func descendentAtPath(pathElements: [String]) -> Layer?</h4>
</li>
<li class="method">
    <h4>public func ancestorNamed(name: String) -> Layer?</h4>
</li>
</ul>

### Geometry

<ul>
<li class="variable">
    <h4>public var x: Double</h4>
</li>
<li class="variable">
    <h4>public var y: Double</h4>
</li>
<li class="variable">
    <h4>public var position: Point</h4>
</li>
<li class="variable">
    <h4>public var width: Double</h4>
</li>
<li class="variable">
    <h4>public var height: Double</h4>
</li>
<li class="variable">
    <h4>public var size: Size</h4>
</li>
<li class="variable">
    <h4>public var frame: Rect</h4>
</li>
<li class="variable">
    <h4>public var bounds: Rect</h4>
</li>
<li class="variable">
    <h4>public var anchorPoint: Point</h4>
</li>
<li class="variable">
    <h4>public var rotationDegrees: Double</h4>
</li>
<li class="variable">
    <h4>public var rotationRadians: Double = 0</h4>
</li>
<li class="variable">
    <h4>public var scale: Double</h4>
</li>
<li class="variable">
    <h4>public var scaleX: Double = 1</h4>
</li>
<li class="variable">
    <h4>public var scaleY: Double = 1</h4>
</li>
<li class="variable">
    <h4>public var globalPosition: Point</h4>
</li>
<li class="method">
    <h4>public func containsGlobalPoint(point: Point) -> Bool</h4>
</li>
<li class="method">
    <h4>public func convertGlobalPointToLocalPoint(globalPoint: Point) -> Point</h4>
</li>
<li class="method">
    <h4>public func convertLocalPointToGlobalPoint(localPoint: Point) -> Point</h4>
</li>
</ul>

### Appearance

<ul>
<li class="variable">
    <h4>public var backgroundColor: Color?</h4>
</li>
<li class="variable">
    <h4>public var alpha: Double</h4>
</li>
<li class="variable">
    <h4>public var cornerRadius: Double</h4>
</li>
<li class="variable">
    <h4>public var image: Image?</h4>
</li>
<li class="variable">
    <h4>public var border: Border</h4>
</li>
<li class="variable">
    <h4>public var shadow: Shadow</h4>
</li>
</ul>

### Touches and Gestures

<ul>
<li class="variable">
    <h4>public var userInteractionEnabled: Bool</h4>
</li>
<li class="variable">
    <h4>public var gestures: [GestureType] = []</h4>
</li>
<li class="typealias">
    <h4>public typealias TouchesHandler = [UITouchID: TouchSequence&lt;UITouchID&gt;] -> Bool</h4>
</li>
<li class="typealias">
    <h4>public typealias TouchHandler = TouchSequence&lt;UITouchID&gt; -> Void</h4>
</li>
<li class="variable">
    <h4>public var activeTouchSequences: [UITouchID: TouchSequence&lt;UITouchID&gt;]</h4>
</li>
<li class="variable">
    <h4>public var touchesBeganHandler: TouchesHandler?</h4>
</li>
<li class="variable">
    <h4>public var touchBeganHandler: TouchHandler?</h4>
</li>
<li class="variable">
    <h4>public var touchesMovedHandler: TouchesHandler?</h4>
</li>
<li class="variable">
    <h4>public var touchMovedHandler: TouchHandler?</h4>
</li>
<li class="variable">
    <h4>public var touchesEndedHandler: TouchesHandler?</h4>
</li>
<li class="variable">
    <h4>public var touchEndedHandler: TouchHandler?</h4>
</li>
<li class="variable">
    <h4>public var touchesCancelledHandler: TouchesHandler?</h4>
</li>
<li class="variable">
    <h4>public var touchCancelledHandler: TouchHandler?</h4>
</li>
<li class="variable">
    <h4>public var touchedDescendents: [Layer]</h4>
</li>
</ul>

### Convenience utilities

<ul>
<li class="variable">
    <h4>public private(set) var willBeRemovedSoon: Bool = false</h4>
</li>
<li class="method">
    <h4>public func removeAfterDuration(duration: NSTimeInterval)</h4>
</li>
<li class="method">
    <h4>public func fadeOutAndRemoveAfterDuration(duration: NSTimeInterval)</h4>
</li>
<li class="variable">
    <h4>public var hashValue: Int</h4>
</li>
<li class="variable">
    <h4>public var description: String</h4>
</li>
<li class="method">
    <h4>public func ==(a: Layer, b: Layer) -> Bool</h4>
</li>
