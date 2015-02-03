---
slug: gestures_section
title: "Gestures"
layout: section
---
Gestures are like a higher-level abstraction than the Layer touch handler API. For instance, a pan gesture consumes a series of touch events but does not actually begin until the user moves a certain distance with a specified number of fingers.

Gestures can also be exclusive: by default, if a gesture recognizes, traditional touch handlers for that subtree will be cancelled. You can control this with the cancelsTouchesInView property. Also by default, if one gesture recognizes, it will prevent all other gestures involved in that touch from recognizing.

Please refer to the documentation for TouchHandler and TouchesHandler.
