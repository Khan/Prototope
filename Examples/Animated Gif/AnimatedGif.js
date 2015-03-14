/*

AnimatedGif

Simple support for frame-by-frame animations
Generated through a series of images

When not animating, blink randomly

*/

Layer.root.backgroundColor = new Color({hex:"150728"})

var touchCatchingLayer = new Layer()
touchCatchingLayer.frame = Layer.root.bounds

var starterFps = 60
var numFirstFrame = 1
var numLastFrame = 62
var currentFrame = numFirstFrame
var strFilename = "yayfez-"

var firstFrameName = strFilename + numFirstFrame
var gifLayer = new Layer({imageName: firstFrameName})
gifLayer.y = Layer.root.height - gifLayer.height/2
gifLayer.x = Layer.root.x

// start looping on touch
touchCatchingLayer.touchBeganHandler = function(touchSequence) {
	
}

// speed and slow animation depending on where the touch is in x
touchCatchingLayer.touchMovedHandler = function(touchSequence) {
	
}

// stop looping when touch has ended
touchCatchingLayer.touchEndedHandler = touchCatchingLayer.touchCancelledHandler = function(touchSequence) {

}

var playThroughImages = new ActionBehavior({handler:function(layer) {
	var nextFrameName = strFilename + currentFrame
	gifLayer.image = new Image({name:nextFrameName})
	if (currentFrame + 1 > numLastFrame) {
		currentFrame = numFirstFrame
	}
	else { 
		currentFrame++
	}

	}
})

touchCatchingLayer.behaviors = [playThroughImages] 

function playThroughImagesWithSpeed(fps) {

}




