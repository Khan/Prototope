---
slug: vars_appearance
layout: variables
doctype:
    - variable
variables:
  -
    name: "public var backgroundColor: Color?"
    desc: "Sets the background color of the layer. Look at the docs for Color to see what you can feed this."
  -
    name: "public var alpha: Double"
    desc: "Sets the opacity of the layer and all its descendents. If you only want to change the opacity of the background color, that can be set in <code>backgroundColor</code> directly."
  -
    name: "public var cornerRadius: Double"
    desc: |
        Sets how rounded the corners are in device points.

        By default, setting a corner radius will crop the contents (images) of the layer so that the radius is visible.
  -
    name: "public var image: Image?"
    desc: "Sets an image to be the primary content of the layer."
  -
    name: "public var border: Border"
    desc: "Sets the border properties of the layer."
  -
    name: "public var shadow: Shadow"
    desc: |
        Sets the shadow of the layer.

        If a shadow and a corner radius are set, you cannot also have an image in your layer. This is because for corner radius to work, the layer needs to clip its contents, but in order for shadows to work, you can't clip the content.

        A fix, however, if you want all three, is to round the image (png) outright and then apply a shadow, the Shadow property is set on the opaque portions of a layer's image.
---
