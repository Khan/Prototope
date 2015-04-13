function randomPrettyColor() {
	// 5º increments of hue
    var hue = Math.random()*(72+1) * 5.0/360.0;
	// 1/8 increments of brightness
    var brightness = Math.max(0.5, Math.random()*(8+1) * 1.0/8.0);
	// 1/8 increments of saturation
    var saturation = Math.max(0.5, Math.random()*(8+1) * 1.0/8.0);

	return new Color({hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0})
}

Layer.root.backgroundColor = randomPrettyColor();

var delta = new Point();
var mouse = new Point();

var translation = new Point();

var drag = 0.2;
var radius = 50;

var center = new Point({x: Layer.root.width*0.5, 
y: Layer.root.height*0.5})

mouse = center
translation = center

var shadow = new ShapeLayer.Polygon({ center: center, radius:radius, numberOfSides: 15});
shadow.fillColor = new Color({red: 0, green: 0, blue: 0, alpha: 0.2})
shadow.strokeColor = Color.clear;
shadow.scale = 0.85

var ball = new ShapeLayer.Polygon({ center: center, radius:radius, numberOfSides: 15});
ball.fillColor = randomPrettyColor();

var shadowOffset = new Point()

function updateTargetWithSequence(seq) {
	mouse = seq.currentSample.globalLocation
              var shadowOffsetX = 5 * radius * (mouse.x - center.x) / Layer.root.width;
              var shadowOffsetY = 5 * radius * (mouse.y - center.y) / Layer.root.height;
	shadowOffset = new Point({x:shadowOffsetX, y:shadowOffsetY})
}

Layer.root.touchMovedHandler = function(seq) {
updateTargetWithSequence(seq)
}

Layer.root.touchBeganHandler = function(seq) {
updateTargetWithSequence(seq)
}

var origins = []
for(var i = 0; i<ball.segments.length; i++) {
	origins.push(new Point({x: ball.segments[i].point.x, 
							 y: ball.segments[i].point.y}));
}

//ball.backgroundColor = Color.black

ball.behaviors = [new ActionBehavior({
	
	handler: function() {
		
	delta = mouse.subtract(translation)

	var newSegments = []
	for(var i = 0; i<ball.segments.length; i++) {
		var v = ball.segments[i].point
		var origin = origins[i]
		
		var dist = origin.distanceToPoint(delta);
		var pct = dist / radius*0.5;

		var x = delta.x * pct;
		var y = delta.y * pct;

		var destx = origin.x - x;
		var desty = origin.y - y;

		var newVertex = new Point({
			x: v.x + (destx - v.x) * drag,
			y: v.y + (desty - v.y) * drag
			});	
		
		var segment = ball.segments[i]
		segment.point = newVertex
		newSegments.push(segment)
	}
	
	ball.segments = newSegments
	shadow.segments = newSegments
	
	translation = translation.add(delta)
	ball.position = translation
	shadow.position = translation.add(shadowOffset)
	
	}
})]