function gimmeSquare(x) {
    // return a rounded white square at some x value (defaults to 324)
	        
	var square = new Layer()
	square.width = 100
	square.height = 100
	square.backgroundColor = Color.white
	square.cornerRadius = 5
	square.x = x
	square.y = 512
	return square
}

function makeBreathingLayer() {
	var spinnyLayer = gimmeSquare(324);
	var t = 0
	var behavior = new BlockBehavior({handler:function(layer) {
			var scale = 1+Math.cos(t)
			t = t+0.09
			layer.scale = scale
		}});
	spinnyLayer.behaviors = [behavior];
}

Layer.root.backgroundColor = new Color({hex: "FF5F55"})
makeBreathingLayer()