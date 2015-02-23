Layer.root.backgroundColor = new Color({hex: "FF31A0"})
var unicornLayer = makeUnicornLayer()
var sparkleParentLayer = new Layer({name:"sparkleParent"})
var firstTouchTime = 0.0
var globalTime = Timestamp.currentTimestamp
var fingerOnUnicornTime = 0.0
var fingerDown = false
var spazzTime = false
var sparklesExist = false
var sparklesAnimated = false
var numStars = 13
var t=0

function makeUnicornLayer() {
	var unicornLayer = new Layer({imageName: "unicorn"})
	unicornLayer.x = Layer.root.width/2
	unicornLayer.y = Layer.root.height/2
	

	var behaviorArray = unicornLayer.behaviors //variable to hold array of behaviors

	var pulse = new ActionBehavior({handler:function(layer) {
		if (fingerOnUnicornTime > 1.0) {
			var scale = 1 + Math.sin(t)
			scale = map({value: scale, fromInterval: [1,3], toInterval: [1, 1.1]})
			layer.scale = scale 

			//adjust t to accelerate up the longer a finger is held down
			var normalizedTime = map({value:fingerOnUnicornTime, fromInterval: [0,15], toInterval: [0,5]})
			normalizedTime = clip({value:normalizedTime, min:0, max:5})
			t = t+normalizedTime
		}
	}});
	
	unicornLayer.behaviors = [pulse];

	var countTouchLength = new ActionBehavior({handler:function(layer) {
		if (fingerDown) {
			fingerOnUnicornTime = Timestamp.currentTimestamp() - firstTouchTime
			console.log("fingerOnUnicornTime: " + fingerOnUnicornTime)
			if ((fingerOnUnicornTime > 0.2)&&(!sparklesExist)) {

					gimmeSparkleCircle(unicornLayer.position.x, unicornLayer.position.y)
					sparklesExist = true;
					
					
			} 
			if ((fingerOnUnicornTime > 5.0) && !sparklesAnimated) {
				animateSparkleCircle()
				sparklesAnimated = true;

			}

		}	
	}});

	var behaviorArray = unicornLayer.behaviors
	behaviorArray.push(countTouchLength)

	unicornLayer.behaviors = behaviorArray

	return unicornLayer
}

function gimmeSparkle(x, y) {
	var sparkleLayer = new Layer({parent:sparkleParentLayer, imageName: "star"})
	sparkleLayer.x = x
	sparkleLayer.y = y
	return sparkleLayer
}

function gimmeSparkleCircle(x,y) {

	for (i = 0; i < numStars; i++) {
		var spotInCircleX = i * 27;
		var spotInCircleY = i * 27;
		var normalizedI = i/numStars * (2*Math.PI)
		var sparkleX = x + (Math.cos(normalizedI)*2)
		var sparkleY = y + (Math.sin(normalizedI)*2)
		gimmeSparkle(sparkleX,sparkleY)
	}
}

function animateSparkleCircle() {
	for (layerIndex in sparkleParentLayer.sublayers) {
		var layer = sparkleParentLayer.sublayers[layerIndex]
		var deltaVector = layer.position.subtract(unicornLayer.position)
		var scaledVector = deltaVector.multiply(600)
		var sparklePosition = scaledVector.add(layer.position) 
		layer.animators.position.target = sparklePosition
	}

}

function resetSparkleBehavior() {
	t = 0;
	sparklesAnimated = false;
	i = 0;
	for (layerIndex in sparkleParentLayer.sublayers) {
		var layer = sparkleParentLayer.sublayers[layerIndex]
		var normalizedI = i/numStars * (2*Math.PI)
		var sparkleX = unicornLayer.x + (Math.cos(normalizedI)*2)
		var sparkleY = unicornLayer.y + (Math.sin(normalizedI)*2)
		layer.x = sparkleX
		layer.y = sparkleY
		i++
	}

}

unicornLayer.touchBeganHandler = function(touchsequence) {
	firstTouchTime = touchsequence.firstSample.timestamp
	////console.log(firstTouchTime)
	unicornLayer.zPosition = 1
	fingerDown = true
}

unicornLayer.touchEndedHandler = function() {
	firstTouchTime = 0.0;
	fingerOnUnicornTime = 0.0;
	fingerDown = false
	resetSparkleBehavior()

}




