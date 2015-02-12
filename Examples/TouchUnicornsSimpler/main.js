function makeUnicornLayer() {
	var unicornLayer = new Layer({imageName: "unicorn"})
	unicornLayer.x = 400
	unicornLayer.y = 512
	return unicornLayer
}

function gimmeSparkle() {
	return new Layer({imageName: "star"})
}

Layer.root.backgroundColor = new Color({hex: "FF31A0"})
var unicornLayer = makeUnicornLayer()

Layer.root.gestures = [new PanGesture({handler: function(phase, centroidSequence) {
	var finger = centroidSequence.currentSample.globalLocation
	var sparkle = gimmeSparkle()
	sparkle.position = finger
	unicornLayer.position = finger
	unicornLayer.zPosition = 1
}})]
