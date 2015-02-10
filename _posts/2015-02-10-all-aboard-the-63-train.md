---
layout: post
title: All aboard the 6.3 beta train!
categories: []
tags: [updates]
published: True
author: marcos ojeda
---

That's correct, the .dmg is barely cold and we're already using the [xcode 6.3 beta](https://developer.apple.com/membercenter/). With it, we're happy to report vastly reduced SourceKit crashes, which makes editing scenes from within Xcode actually possible now.

The second thing is some minor changes[^1] to syntax.

For the time being, it seems that trailing closures no longer behave the way they used to, so the syntax for adding Gestures and Animations is changing until that regression is fixed. Here is a diff of the old and new syntax (the red lines are the *old* way):

## Gestures

{% highlight diff %}
-  cloud.gestures.append(PanGesture { _, centroidSequenc in
+  cloud.gestures.append(PanGesture( handler: { _, centroidSequenc in
           var finger: Point = centroidSequenc.currentSample.globalLocation
           self.cloudLayer.x = finger.x
           self.rainEmitter?.x = finger.x
-  })
+  })) // <-- notice the  trailing ")"
{% endhighlight %}

the `handler: ` label isn't strictly necessary, you can optionally write `PanGesture({_ in println("")})` if that makes things easier for you.

## Animations

Dynamic animators are unaffected, but the traditional animators require passing the closure as an explicit argument to `Layer.animateWithDuration`. Here's an example

{% highlight diff %}

-     Layer.animateWithDuration(0.35, curve: .EaseInOut) {
+     Layer.animateWithDuration(0.35, curve: .EaseInOut, animations: {
           self.spinnyLayer.rotationDegrees = 0
-     }
+     }) // <-- notice the  trailing ")"

{% endhighlight %}

## Other bits we learned

One of the most befuddling changes was that members of `@objc` private classes now need to be explicitly tagged `@objc` individually. For example, ohaiprototope's scene view controller's data source was giving the useless *"Type does not conform to protocol UITableViewDataSource"* error even though it was implementing all the required methods.

There's an **even more insidious error** which [Andy](https://twitter.com/andy_matuschak) points out: if the methods are *optional* then this will casually break silently leaving you scratching your head. If you're updating any objc classes from swift, take a look to see if you've done the requisite lambada.

For the required UITableViewDataSource file, The fix was to make this change:

{% highlight diff %}
-@objc private class SceneListingDataSource: NSObject, UITableViewDataSource {
+private class SceneListingDataSource: NSObject, UITableViewDataSource {
        var scenes: [Scene]
        init(scenes: [Scene]) {
                self.scenes = scenes
                super.init()
        }

-       private func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
+       @objc private func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return scenes.count
        }

-       private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
+       @objc private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
                return 1
        }
...
}
{% endhighlight %}

## Also new: Video and VideoLayer

If you've made it this far... There's been some recent work to add videos to prototope. This works in two ways, the first is a Video object and a VideoLayer which contains and displays the video. Here's [an example from ohaiprototope](https://github.com/Khan/OhaiPrototope/blob/master/OhaiPrototope/VideoScene.swift):

{% highlight swift %}
let video: Video!
let videoLayer: VideoLayer

video = Video(name: "jeff.mp4")

videoLayer = VideoLayer(parent: Layer.root, video: video)

videoLayer.size = Size(width: 400, height: 300)
videoLayer.position = Position(x: 200, y: 200)

videoLayer.play()
{% endhighlight %}

You can look forward to updated docs for that and more in the coming days.

### In closing

Beyond that, we have some upcoming changes in the next week or so that should make sketching much faster, but for now enjoy the increased stability! Thanks for riding along the prototrain!


<p style="text-align: center;">
    <img src="{{ site.baseurl }}/assets/I_Choo_Choo_Choose_You_Simpsons.jpg" alt="a valentine with a smiling saying 'i choo-choo-choose you.'">
</p>

Thanks to [desmond](https://twitter.com/dmnd_), [andy](https://twitter.com/andy_matuschak), and [nacho](https://twitter.com/nachosoto) for looking this post over.

[^1]:

    if you're curious about the trailing closure issue, take a look at [this tweet](https://twitter.com/AirspeedSwift/status/565209315813126144) (whose conversation indicates that this is [probably an unexpected regression](https://twitter.com/jckarter/status/565210722435485696)).

    <blockquote class="twitter-tweet" lang="en"><p><a href="https://twitter.com/jckarter">@jckarter</a> looks like trailing closures now disabled if there are default params after the fun arg e.g. split(s) { $0 == &quot;,&quot; }. Intentional?</p>&mdash; AirspeedVelocity (@AirspeedSwift) <a href="https://twitter.com/AirspeedSwift/status/565209315813126144">February 10, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
