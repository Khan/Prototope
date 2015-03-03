Layer.root.backgroundColor = new Color({hue: 0.5, saturation: 0.8, brightness: 0.3})

// TODO: you currently can't attach touch handlers to the root layer. oops.
var touchLayer = new Layer()
touchLayer.frame = Layer.root.bounds

var touchesToLayers = {}
var touchLayers = []

var z = 0
touchLayer.touchBeganHandler = function(touchSequence) {
	var touchCircleLayer = new Layer()
	touchCircleLayer.position = touchSequence.currentSample.globalLocation
	touchCircleLayer.width = touchCircleLayer.height = 125
	touchCircleLayer.cornerRadius = touchCircleLayer.width / 2.0
	touchCircleLayer.backgroundColor = new Color({hue: Math.random(), saturation: 0.8, brightness: 1.0})
	touchesToLayers[touchSequence.id] = touchCircleLayer
	touchLayers.push(touchCircleLayer)
	touchCircleLayer.zPosition = z
	touchCircleLayer.userInteractionEnabled = false
	z += 1
}

touchLayer.touchMovedHandler = function(touchSequence) {
	touchesToLayers[touchSequence.id].position = touchSequence.currentSample.globalLocation
}

touchLayer.touchEndedHandler = touchLayer.touchCancelledHandler = function(touchSequence) {
	var layer = touchesToLayers[touchSequence.id]
	delete touchesToLayers[touchSequence.id]
	delete touchLayers[touchLayers.indexOf(layer)]

	layer.animators.scale.target = new Point({x: 0, y: 0})
	layer.animators.scale.springBounciness = 3
	layer.animators.scale.springSpeed = 30
	layer.animators.scale.completionHandler = function () {
		layer.parent = undefined
	}
}

var h = new Heartbeat({handler: function() {
	for (var layer in touchLayers) {
		touchLayers[layer].scale *= 1.11
	}
}})