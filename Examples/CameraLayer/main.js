var cameraLayer = new CameraLayer()
cameraLayer.width = Layer.root.width * 0.5
cameraLayer.height = Layer.root.height * 0.5
cameraLayer.cameraPosition = CameraPosition.Front
cameraLayer.x = Layer.root.x
cameraLayer.y = Layer.root.y

var flipButton = new TextLayer()
flipButton.fontName = "Futura"
flipButton.fontSize = 30
flipButton.text = "Flip"
flipButton.x = Layer.root.x
flipButton.y = 100
flipButton.animators.alpha.springBounciness = 0
flipButton.animators.alpha.springSpeed = 20

Layer.root.touchBeganHandler = function() {
	flipButton.animators.alpha.target = 0.5
}
Layer.root.touchEndedHandler = function(touchSequence) {
	cameraLayer.cameraPosition = (cameraLayer.cameraPosition === CameraPosition.Front) ? CameraPosition.Back : CameraPosition.Front
	flipButton.animators.alpha.target = 1.0
}