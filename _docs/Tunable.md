---
layout: api_doc
slug: tunable
title: Tunable
---

These functions allow you to take a value and make it tunable by a slider or a switch!

Example usage:
{% highlight swift %}
tunable(0.5, name: "button alpha") { alpha in someButton.alpha = alpha }
{% endhighlight %}
Whenever the alpha changes, the closure will be run, and the button's alpha will be updated.

If an instantaneous return value is good enough, you can do this instead:
{% highlight swift %}
someButton.alpha = tunable(0.5, name: "button alpha")
{% endhighlight %}

Once you've tuned values in the UI, you can apply them back to the project by following these steps:

1. Tap "Share"
2. Get the values you just tweaked

    * If you're not attached to Xcode, email yourself from the share sheet.
    * If you're attached to Xcode, open up the console (`View > Debug Area > Activate Console`) and look for a log like this:

        {% highlight json %}
        [
            {
            "label" : "Test",
            "key" : "Test",
            "sliderMinValue" : 0,
            "sliderMaxValue" : 1400,
            "sliderValue" : 179.6053
            }
        ]
        {% endhighlight %}
3. Copy and paste the contents into `TunableSpec.json` in your project (included with OhaiPrototope).
