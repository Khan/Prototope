function gimmeSquare(x) {
    // return a rounded white square at some x value (defaults to 324)
	        
	const square = new Layer()
	square.width = 100
	square.height = 100
	square.backgroundColor = Color.white
	square.cornerRadius = 5
	square.x = x
	square.y = 512
	return square
}

function makeBreathingLayer() {
	const spinnyLayer = gimmeSquare(324);
	let t = 0
	const behavior = new ActionBehavior({handler:function(layer) {
			const scale = 1+Math.cos(t)
			t = t+0.09
			layer.scale = scale
		}});
	spinnyLayer.behaviors = [behavior];
	
	return spinnyLayer
}

Layer.root.backgroundColor = new Color({hex: "FF5F55"})
const breathingLayer = makeBreathingLayer()

const square = gimmeSquare(75)
square.gestures = [
       new PanGesture({
               handler: function(phase, sequence) {
                       if (sequence.previousSample !== undefined) {
                               const current = sequence.currentSample.globalLocation
                               const previous = sequence.previousSample.globalLocation
                               square.position = square.position.add(current.subtract(previous))
                       }
               }
       })
]

square.behaviors = [
       new CollisionBehavior({
               with: breathingLayer,
               handler: function(kind) {
					if (kind == CollisionBehaviorKind.Entering) {
                       square.animators.backgroundColor.target = Color.yellow
					} else if (kind == CollisionBehaviorKind.Leaving) {
						square.animators.backgroundColor.target = Color.white
					}
               }
       }),
]
