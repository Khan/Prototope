// You can draw by tapping:

var hintLabel = new TextLayer()
hintLabel.text = "Tap to draw!"
hintLabel.fontSize = 40
hintLabel.x = Layer.root.x
hintLabel.originY = 30

var drawing = new ShapeLayer()
drawing.strokeWidth = 2
drawing.fillColor = new Color({hue: 0.1, saturation: 0.3, brightness: 1.0})
drawing.lineCapStyle = LineCapStyle.Round
drawing.closed = true
drawing.lineJoinStyle = LineJoinStyle.Round

var currentPointDot = new ShapeLayer.Circle({center: Point.zero, radius: 10})
currentPointDot.alpha = 0

Layer.root.touchBeganHandler = function(sequence) {
	currentPointDot.alpha = 1
	currentPointDot.position = sequence.currentSample.globalLocation
	drawing.addPoint(sequence.currentSample.globalLocation)
}

Layer.root.touchMovedHandler = function(sequence) {
	var segments = drawing.segments
	var lastSegment = segments.pop()
	lastSegment.point = sequence.currentSample.globalLocation
	segments.push(lastSegment)
	drawing.segments = segments

	currentPointDot.position = sequence.currentSample.globalLocation
}

Layer.root.touchEndedHandler = Layer.root.touchCancelledHandler = function(sequence) {
	currentPointDot.alpha = 0
}

// Demo of various shapes.

var circle = new ShapeLayer.Circle({
	center: new Point({x: 75, y: Layer.root.frameMaxY - 75}),
	radius: 50
})
circle.fillColor = new Color({hue: 0.3, saturation: 0.6, brightness: 1.0})
circle.strokeColor = undefined

var oval = new ShapeLayer.Oval({
	rectangle: new Rect({x: circle.frameMaxX + 25, y: circle.originY, width: 50, height: circle.height})
})
oval.fillColor = undefined
oval.strokeColor = new Color({hue: 0.6, saturation: 0.6, brightness: 1.0})
oval.strokeWidth = 4

var polygon = new ShapeLayer.Polygon({center: Point.zero, radius: 50, numberOfSides: 5})
polygon.strokeWidth = 4
polygon.fillColor = new Color({hue: 0.8, saturation: 0.6, brightness: 1.0})
polygon.strokeColor = undefined
polygon.lineCapStyle = LineCapStyle.Round
polygon.lineJoinStyle = LineJoinStyle.Round
polygon.y = oval.y
polygon.originX = oval.frameMaxX + 25

var pizza = new ShapeLayer()
pizza.fillColor = Color.orange
pizza.strokeColor = undefined
pizza.segments = [
	new Segment({
		point: new Point({x: 10, y: 10}),
		handleIn: new Point({x: -10, y: 10}),
		handleOut: new Point({x: 10, y: -10})
	}),
	new Segment({
		point: new Point({x: 100, y: 30}),
		handleIn: new Point({x: -10, y: -10}),
		handleOut: new Point({x: -10, y: 10})
	}),
	new Segment(new Point({x: 30, y: 100})),
]
pizza.originX = polygon.frameMaxX + 25
pizza.y = polygon.y