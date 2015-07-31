function makeUnicornLayer() {
	const unicornLayer = new Layer({imageName: "unicorn"})
	unicornLayer.x = 400
	unicornLayer.y = 512
	return unicornLayer
}

function gimmeSparkle(x, y) {
	const sparkleLayer = new Layer({imageName: "star"})
	sparkleLayer.x = x
	sparkleLayer.y = y
	return sparkleLayer
}

Layer.root.backgroundColor = new Color({hex: "FF31A0"})
const unicornLayer = makeUnicornLayer()

Layer.root.gestures = [new PanGesture({handler: function(phase, centroidSequence) {
	const finger = centroidSequence.currentSample.globalLocation
	gimmeSparkle(finger.x, finger.y)

	unicornLayer.x = finger.x
	unicornLayer.y = finger.y
	// or: unicornLayer.position = finger
	unicornLayer.zPosition = 1
}})]
