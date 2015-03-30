---
slug: init
title: "public init(handler: Heartbeat -> ())"
js-title: "new Heartbeat({handler: Function(heartbeat: Heartbeat)})"
doctype:
    - method
    - initializer
---

You make a heartbeat with a <span class="swift-only">closure</span><span class="js-only">function</span> that specifies what should happen every frame.

The heartbeat itself is passed into that handler so that you can determine the frame's timestamp or [cause the heartbeat to stop from within the handler](https://www.youtube.com/watch?v=aqAUmgE3WyM).