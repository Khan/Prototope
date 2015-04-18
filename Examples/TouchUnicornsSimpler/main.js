function makeUnicornLayer() {
	const unicornLayer = new Layer({imageName: "unicorn"})
	unicornLayer.x = 400
	unicornLayer.y = 512
	return unicornLayer
}

function gimmeSparkle() {
	return new Layer({imageName: "star"})
}

Layer.root.backgroundColor = new Color({hex: "FF31A0"})
const unicornLayer = makeUnicornLayer()

Layer.root.gestures = [new PanGesture({handler: function(phase, centroidSequence) {
	const finger = centroidSequence.currentSample.globalLocation
	const sparkle = gimmeSparkle()
	sparkle.position = finger
	unicornLayer.position = finger
	unicornLayer.zPosition = 1
}})]
