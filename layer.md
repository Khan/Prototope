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

Once you have a root layer, you are free to create named layers, give layers sizes, add layers to those layers and begin adding behaviors to those layers. Prototope's layers are similar to `div`s in html and `Layer()`s in Framer.

You can create a layer with just a background color or you can create one with an image. If you go the image route, the layer is sized to match the image.

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

this sets your root layer to be the main view of your ios app. As a result, making new Layers with <code>Layer.root</code> as their parent will result in them appearing on the screen (which is usually what you want)

</li>
</ul>

### Creating and identifying layers

<ul>
<li class="variable">
    <h4>public class var root: Layer</h4>
</li>
<li class="method initializer">
    <h4>public init(parent: Layer? = nil, name: String? = nil)</h4>

    <p>Setting a name on a layer allows you to access it later on using methods like <code>sublayerNamed</code>, <code>descendentNamed</code> or <code>ancestorNamed</code>.

</li>
<li class="method initializer convenience">
    <h4>public convenience init(parent: Layer?, imageName: String)</h4>

    <p>Setting an <code>imageName</code> will look for the image in your project with a matching name.
    <p>in iOS, you do not need to specify the file extension, you may simply write

{% highlight swift %}
sled: Layer = Layer(nil, "dogesled")
{% endhighlight %}
    <p>This will match "dogesled.png", "dogesled.jpg", and even "dogesled@2x.png" on hidpi devices

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
    <h4>public var sublayerAtFront: Layer?</h4>
    <p>Layers stack, in order in which they are added. A layer added last to some parent will appear to be the frontmost layer.
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
    <p>sets the x position of the <i>middle</i> of your layer, relative to its parent.
</li>
<li class="variable">
    <h4>public var y: Double</h4>
    <p>sets the y position of the <i>middle</i> of your layer, relative to its parent.
</li>
<li class="variable">
    <h4>public var position: Point</h4>
    <p>If you have received a point (possibly from a touch handler), you may use that value directly to set a layer's x/y pair directly.
</li>
<li class="variable">
    <h4>public var width: Double</h4>
    <p>Sets the width of the layer in device points.
</li>
<li class="variable">
    <h4>public var height: Double</h4>
    <p>Sets the height of the layer in device points.
</li>
<li class="variable">
    <h4>public var size: Size</h4>
    <p>Sets the width and height at once, if you have received a Size from some other method.
</li>
<li class="variable">
    <h4>public var frame: Rect</h4>
    <p>Similar to <code>size</code>, the frame defines both the size and the position of the layer with respect to its parent. See the Rect docs for more information about Rects (which are defined by an <code>origin</code> and a <code>size</code>).
    <p>Because the frame is defined with respect to the layer's parent, it's usually best to modify the frame when operating in the parent's context.
</li>
<li class="variable">
    <h4>public var bounds: Rect</h4>
    <p>Defines the display bounds of the layer with respect to itself. In iOS, this means that the bounds start at the upper left corner. By default, the bounds are equal to the <code>size</code> of the layer, but you can alter the bounds to clip the layer's contents.
    <p>Changing the bounds will result in the <code>size</code> changing.
</li>
<li class="variable">
    <h4>public var anchorPoint: Point</h4>
    <p>Defines where rotation happens. In almost every case (unless you know what you're doing), you want the default <code>Point(0.5, 0.5)</code> which causes rotation to happen relative to the middle of the layer. Setting <code>Point(1,1)</code>sets the anchor point to be the bottom right, and <code>Point(0,0)</code> is the upper left.
</li>
<li class="variable">
    <h4>public var rotationDegrees: Double</h4>
    <p>the amount to rotate the layer in degrees.
</li>
<li class="variable">
    <h4>public var rotationRadians: Double = 0</h4>
    <p>the amount to rotate the layer in radians.
</li>
<li class="variable">
    <h4>public var scaleX: Double = 1</h4>
    <p>Sets the horizontal scale of the object, by default set to 1
</li>
<li class="variable">
    <h4>public var scaleY: Double = 1</h4>
    <p>Sets the vertical scale of the object, by default set to 1
</li>
<li class="variable">
    <h4>public var scale: Double</h4>
    <p>Sets the scale of the object, by default set to 1. setting this sets both <code>scaleX</code> and <code>scaleY</code> at the same time
</li>
<li class="variable">
    <h4>public var globalPosition: Point</h4>
    <p>the layer's position in the terms of the root layer's coordinate space which usually maps to "points on the screen" regardless of how nested the layer is.
</li>
<li class="method">
    <h4>public func containsGlobalPoint(point: Point) -> Bool</h4>
    <p>Is a point in <code>Layer.root</code>'s coordinate space enclosed by this Layer?
</li>
<li class="method">
    <h4>public func convertGlobalPointToLocalPoint(globalPoint: Point) -> Point</h4>
    <p>Returns a point in the Layer's coordinate space (i.e. if you have somehow captured a touch event in <code>Layer.root</code> but you want to know where in your layer that is)
</li>
<li class="method">
    <h4>public func convertLocalPointToGlobalPoint(localPoint: Point) -> Point</h4>
    <p>Returns a point from your special layer in the coordinate space of <code>Layer.root</code></p>
</li>
</ul>

### Appearance

<ul>
<li class="variable">
    <h4>public var backgroundColor: Color?</h4>
    <p>Sets the background color of the layer. Look at the color docs.
</li>
<li class="variable">
    <h4>public var alpha: Double</h4>
    <p>Sets the opacity of the layer and all its descendents. If you only want to change the opacity of the background color, that can be set in <code>backgroundColor</code> directly.
</li>
<li class="variable">
    <h4>public var cornerRadius: Double</h4>
    <p>Sets how rounded the corners are in device points.
    <p>By default, setting a corner radius will crop the contents (images) of the layer so that the radius is visible.
</li>
<li class="variable">
    <h4>public var image: Image?</h4>
    <p>Sets an image to be the primary content of the layer.
</li>
<li class="variable">
    <h4>public var border: Border</h4>
    <p>Sets the border properties of the layer.
</li>
<li class="variable">
    <h4>public var shadow: Shadow</h4>
    <p>Sets the shadow of the layer.
    <p>If a shadow and a corner radius are set, you cannot also have an image in your layer. This is because for corner radius to work, the layer needs to clip its contents, but in order for shadows to work, you can't clip the content.
    <p>A fix, however, if you want all three, is to round the image (png) outright and then apply a shadow, the Shadow property is set on the opaque portions of a layer's image.
</li>
</ul>

### Touches and Gestures

Gestures are like a higher-level abstraction than the Layer touch handler API. For instance, a pan gesture consumes a series of touch events but does not actually begin until the user moves a certain distance with a specified number of fingers.

Gestures can also be exclusive: by default, if a gesture recognizes, traditional touch handlers for that subtree will be cancelled. You can control this with the cancelsTouchesInView property. Also by default, if one gesture recognizes, it will prevent all other gestures involved in that touch from recognizing.

Please refer to the documentation for TouchHandler and TouchesHandler.
<ul>
<li class="variable">
    <h4>public var userInteractionEnabled: Bool</h4>
    <p>When false, touches that hit this layer or its sublayers are discarded. Defaults to true
</li>
<li class="variable">
    <h4>public var gestures: [GestureType] = []</h4>
    <p>Append Gestures to this property to add them to the layer. By default, this is an empty list.
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
    <p>This might as well be called <code>swansong()</code>
</li>
<li class="method">
    <h4>public func removeAfterDuration(duration: NSTimeInterval)</h4>
    <p>Although the argument is an <code>NSTimeInterval</code>, you can enter seconds here with <code>double</code> resolution.
</li>
<li class="method">
    <h4>public func fadeOutAndRemoveAfterDuration(duration: NSTimeInterval)</h4>
    <p>Although the argument is an <code>NSTimeInterval</code>, you can enter seconds here with <code>double</code> resolution.
</li>
<li class="variable">
    <h4>public var hashValue: Int</h4>
    <p>a property that returns a hash for your layer (presumably to compare it with another layer, as in <code>==</code> below)
</li>
<li class="variable">
    <h4>public var description: String</h4>
    <p>a readonly property that creates a printable version of your layer
</li>
<li class="method">
    <h4>public func ==(a: Layer, b: Layer) -> Bool</h4>
</li>
