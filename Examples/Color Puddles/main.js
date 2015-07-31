Layer.root.backgroundColor = new Color({hue: 0.5, saturation: 0.8, brightness: 0.3})

// TODO: you currently can't attach touch handlers to the root layer. oops.
const touchLayer = new Layer()
touchLayer.frame = Layer.root.bounds

const touchesToLayers = new Map()

let z = 0
touchLayer.touchBeganHandler = function(touchSequence) {
	const touchCircleLayer = new Layer()
	touchCircleLayer.position = touchSequence.currentSample.globalLocation
	touchCircleLayer.width = touchCircleLayer.height = 125
	touchCircleLayer.cornerRadius = touchCircleLayer.width / 2.0
	touchCircleLayer.backgroundColor = new Color({hue: Math.random(), saturation: 0.8, brightness: 1.0})
	touchesToLayers.set(touchSequence.id, touchCircleLayer)
	touchCircleLayer.zPosition = z
	touchCircleLayer.userInteractionEnabled = false
	z += 1
}

touchLayer.touchMovedHandler = function(touchSequence) {
	touchesToLayers.get(touchSequence.id).position = touchSequence.currentSample.globalLocation
}

touchLayer.touchEndedHandler = touchLayer.touchCancelledHandler = function(touchSequence) {
	const layer = touchesToLayers.get(touchSequence.id)
	touchesToLayers.delete(touchSequence.id)

	layer.animators.scale.target = new Point({x: 0, y: 0})
	layer.animators.scale.springBounciness = 3
	layer.animators.scale.springSpeed = 30
	layer.animators.scale.completionHandler = () => { layer.parent = undefined }
}

const h = new Heartbeat({handler: function() {
	for (let layer of touchesToLayers.values()) {
		layer.scale *= 1.11
	}
}})
