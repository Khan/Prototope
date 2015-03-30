/*

Adapted from P.1.0 "Hello, Color" in "Generative Design" by Bohnacker et al.
	built on Prototope@7b5d29cf6

*/

var rect = new Layer()
rect.position = Layer.root.position
rect.width = rect.height = 100
rect.backgroundColor = Color.black

Layer.root.animators.backgroundColor.springSpeed = rect.animators.backgroundColor.springSpeed = 40
Layer.root.animators.backgroundColor.springBounciness = rect.animators.backgroundColor.springBounciness = 0

rect.animators.bounds.springSpeed = 15
rect.animators.bounds.springBounciness = 3

Layer.root.touchBeganHandler = Layer.root.touchMovedHandler = Layer.root.touchEndedHandler = function(sequence) {
	var hue = sequence.currentSample.globalLocation.y / Layer.root.height
	Layer.root.animators.backgroundColor.target = new Color({hue: hue, saturation: 1.0, brightness: 1.0})
	rect.animators.backgroundColor.target = new Color({hue: (1.0 - hue), saturation: 1.0, brightness: 1.0})

	var size = Math.abs(sequence.currentSample.globalLocation.x - Layer.root.x) * 2.0
	rect.animators.bounds.target = new Rect({x: 0, y: 0, width: size, height: size})
}