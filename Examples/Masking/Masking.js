var activeColor = new Color({hue: 0.78, saturation: 0.41, brightness: 0.61})

// We begin with a colored label...
var positiveLabel = makeButtonLabel()

// Create the highlight circle that will cover it, but start it scaled down.
var overlayCircle = new Layer()
overlayCircle.width = overlayCircle.height = positiveLabel.width * 1.4
overlayCircle.position = Layer.root.position
var fullySizedCircleFrame = overlayCircle.frame
overlayCircle.scale = 0.001
overlayCircle.cornerRadius = overlayCircle.width / 2.0
overlayCircle.backgroundColor = activeColor

// Then make a negatively-colored label in a container the same size the highlight circle will eventually be.
var negativeLabelContainer = new Layer()
negativeLabelContainer.frame = fullySizedCircleFrame

var negativeLabel = makeButtonLabel()
negativeLabel.parent = negativeLabelContainer
negativeLabel.x = negativeLabelContainer.bounds.midX
negativeLabel.y = negativeLabelContainer.bounds.midY
negativeLabel.textColor = Color.white

// And make a circle like the highlight circle to mask the negative label.
var maskingCircle = new Layer()
maskingCircle.frame = negativeLabelContainer.bounds
maskingCircle.cornerRadius = overlayCircle.cornerRadius
maskingCircle.backgroundColor = Color.black
maskingCircle.scale = overlayCircle.scale
negativeLabelContainer.maskLayer = maskingCircle

overlayCircle.animators.scale.springSpeed = maskingCircle.animators.scale.springSpeed = 0
overlayCircle.animators.scale.springBounciness = maskingCircle.animators.scale.springBounciness = 3

Layer.root.touchBeganHandler = function() {
	setExpanded(true)
}

Layer.root.touchEndedHandler = Layer.root.touchCancelledHandler = function() {
	setExpanded(false)
}

function setExpanded(expanded) {
	var newTarget = expanded ? new Point({x: 1.0, y: 1.0}) : new Point({x: 0.001, y: 0.001})
	overlayCircle.animators.scale.target = maskingCircle.animators.scale.target = newTarget
}

function makeButtonLabel() {
	var label = new TextLayer()
	label.fontName = "AvenirNext-Regular"
	label.fontSize = 100
	label.text = "Press Me"
	label.position = Layer.root.position
	label.textColor = activeColor
	return label
}