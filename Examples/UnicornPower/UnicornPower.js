Layer.root.backgroundColor = new Color({hex: "FF31A0"})
const unicornLayer = makeUnicornLayer()
const sparkleParentLayer = new Layer({name:"sparkleParent"})
let firstTouchTime = 0.0
const globalTime = Timestamp.currentTimestamp
let fingerOnUnicornTime = 0.0
let fingerDown = false
const spazzTime = false
let sparklesExist = false
let sparklesAnimated = false
const numStars = 13
let t=0

function makeUnicornLayer() {
	const unicornLayer = new Layer({imageName: "unicorn"})
	unicornLayer.x = Layer.root.width/2
	unicornLayer.y = Layer.root.height/2
	

	const pulse = new ActionBehavior({handler:function(layer) {
		if (fingerOnUnicornTime > 1.0) {
			let scale = 1 + Math.sin(t)
			scale = map({value: scale, fromInterval: [1,3], toInterval: [1, 1.1]})
			layer.scale = scale 

			//adjust t to accelerate up the longer a finger is held down
			let normalizedTime = map({value:fingerOnUnicornTime, fromInterval: [0,15], toInterval: [0,5]})
			normalizedTime = clip({value:normalizedTime, min:0, max:5})
			t = t+normalizedTime
		}
	}});
	
	unicornLayer.behaviors = [pulse];

	const countTouchLength = new ActionBehavior({handler:function(layer) {
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

	const behaviorArray = unicornLayer.behaviors
	behaviorArray.push(countTouchLength)

	unicornLayer.behaviors = behaviorArray

	return unicornLayer
}

function gimmeSparkle(x, y) {
	const sparkleLayer = new Layer({parent:sparkleParentLayer, imageName: "star"})
	sparkleLayer.x = x
	sparkleLayer.y = y
	return sparkleLayer
}

function gimmeSparkleCircle(x,y) {

	for (let i = 0; i < numStars; i++) {
		const spotInCircleX = i * 27;
		const spotInCircleY = i * 27;
		const normalizedI = i/numStars * (2*Math.PI)
		const sparkleX = x + (Math.cos(normalizedI)*2)
		const sparkleY = y + (Math.sin(normalizedI)*2)
		gimmeSparkle(sparkleX,sparkleY)
	}
}

function animateSparkleCircle() {
	for (let layerIndex in sparkleParentLayer.sublayers) {
		const layer = sparkleParentLayer.sublayers[layerIndex]
		const deltaVector = layer.position.subtract(unicornLayer.position)
		const scaledVector = deltaVector.multiply(100)
		const sparklePosition = scaledVector.add(layer.position) 
		layer.animators.position.target = sparklePosition
	}

}

function resetSparkleBehavior() {
	t = 0;
	sparklesAnimated = false;
	let i = 0;
	for (let layerIndex in sparkleParentLayer.sublayers) {
		const layer = sparkleParentLayer.sublayers[layerIndex]
		const normalizedI = i/numStars * (2*Math.PI)
		const sparkleX = unicornLayer.x + (Math.cos(normalizedI)*2)
		const sparkleY = unicornLayer.y + (Math.sin(normalizedI)*2)
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




