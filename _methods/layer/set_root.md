---
slug: set_root
title: "public class func setRoot(fromView view: UIView)"
doctype:
    - method
    - classmethod
---
Call this method, likely in your <code>ViewController.swift</code> file, probably like:

{% highlight swift %}
override func viewDidLoad() {
    super.viewDidLoad()
    Layer.setRoot(fromView: view)
}

{% endhighlight %}

this sets your root layer to be the main view of your ios app. As a result, making new Layers with <code>Layer.root</code> as their parent will result in them appearing on the screen (which is usually what you want)
