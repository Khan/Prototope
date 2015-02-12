function makeUnicornLayer() {
	var unicornLayer = new Layer({imageName: "unicorn"})
	unicornLayer.x = 400
	unicornLayer.y = 512
	return unicornLayer
}

function gimmeSparkle(x, y) {
	var sparkleLayer = new Layer({imageName: "star"})
	sparkleLayer.x = x
	sparkleLayer.y = y
	return sparkleLayer
}

Layer.root.backgroundColor = new Color({hex: "FF31A0"})
var unicornLayer = makeUnicornLayer()

Layer.root.gestures = [new PanGesture({handler: function(phase, centroidSequence) {
	var finger = centroidSequence.currentSample.globalLocation
	gimmeSparkle(finger.x, finger.y)

	unicornLayer.x = finger.x
	unicornLayer.y = finger.y
	// or: unicornLayer.position = finger
}})]
