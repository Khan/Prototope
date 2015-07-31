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

function makeSpinnyLayer() {
    // touching this layer will rotate it 90 degrees to the right

	var spinnyLayer = gimmeSquare(324);
	spinnyLayer.touchBeganHandler = function() {
		Layer.animate({
			duration: 0.35,
			curve: AnimationCurve.EaseInOut,
			animations: function() {
				spinnyLayer.rotationDegrees = 90
			}
		})
	}

	spinnyLayer.touchEndedHandler = function() {
		Layer.animate({
			duration: 0.35,
			curve: AnimationCurve.EaseInOut,
			animations: function() {
				spinnyLayer.rotationDegrees = 0
			}
		})
	}
}

function makeNeedyLayer() {
	var needyLayer = gimmeSquare(444)
	needyLayer.touchBeganHandler = function() {
		needyLayer.animators.rotationRadians.target = 1.57
		needyLayer.animators.rotationRadians.springBounciness = 6.0
	}

	// letting go restores the values
	needyLayer.touchEndedHandler = function() {
		needyLayer.animators.rotationRadians.target = 0
	}
}

Layer.root.backgroundColor = new Color({hex: "535F55"})
makeSpinnyLayer()
makeNeedyLayer()