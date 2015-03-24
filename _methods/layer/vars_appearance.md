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
  -
    name: "public var layerMask: Layer"
    js-name: "this.layerMask"
    js-type: "Layer"
    desc: |
      The mask layer is used to clip or filter the contents of a layer. Those contents will be rendered only where the mask layer's contents are opaque. Partially transparent regions of the mask layer will result in partially transparent renderings of the host layer.

      The mask layer operates within the coordinate space of its host layer. In most cases, you'll want to set a mask layer's frame to be equal to its host's bounds.
      
      Be aware: mask layers do incur an additional performance cost. If the cost becomes too onerous, consider making flattened images of the masked content instead.

---
