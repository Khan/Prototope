function randomPrettyColor() {
	// 5º increments of hue
    const hue = Math.random()*(72+1) * 5.0/360.0;
	// 1/8 increments of brightness
    const brightness = Math.max(0.5, Math.random()*(8+1) * 1.0/8.0);
	// 1/8 increments of saturation
    const saturation = Math.max(0.5, Math.random()*(8+1) * 1.0/8.0);

	return new Color({hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0})
}

Layer.root.backgroundColor = randomPrettyColor();

let delta = new Point();
let mouse = new Point();

let translation = new Point();

const drag = 0.2;
const radius = 50;

const center = new Point({x: Layer.root.width*0.5, 
y: Layer.root.height*0.5})

mouse = center
translation = center

const shadow = new ShapeLayer.Polygon({ center: center, radius:radius, numberOfSides: 15});
shadow.fillColor = new Color({red: 0, green: 0, blue: 0, alpha: 0.2})
shadow.strokeColor = Color.clear;
shadow.scale = 0.85

const ball = new ShapeLayer.Polygon({ center: center, radius:radius, numberOfSides: 15});
ball.fillColor = randomPrettyColor();

let shadowOffset = new Point()

function updateTargetWithSequence(seq) {
	mouse = seq.currentSample.globalLocation
              const shadowOffsetX = 5 * radius * (mouse.x - center.x) / Layer.root.width;
              const shadowOffsetY = 5 * radius * (mouse.y - center.y) / Layer.root.height;
	shadowOffset = new Point({x:shadowOffsetX, y:shadowOffsetY})
}

Layer.root.touchMovedHandler = function(seq) {
updateTargetWithSequence(seq)
}

Layer.root.touchBeganHandler = function(seq) {
updateTargetWithSequence(seq)
}

const origins = ball.segments.map((segment) =>
	new Point({x: segment.point.x, y: segment.point.y}))

//ball.backgroundColor = Color.black

ball.behaviors = [new ActionBehavior({
	
	handler: function() {
		
	delta = mouse.subtract(translation)

	const newSegments = []
	for (let i = 0; i<ball.segments.length; i++) {
		const v = ball.segments[i].point
		const origin = origins[i]
		
		const dist = origin.distanceToPoint(delta);
		const pct = dist / radius*0.5;

		const x = delta.x * pct;
		const y = delta.y * pct;

		const destx = origin.x - x;
		const desty = origin.y - y;

		const newVertex = new Point({
			x: v.x + (destx - v.x) * drag,
			y: v.y + (desty - v.y) * drag
			});	
		
		const segment = ball.segments[i]
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
