/*

AnimatedGif

Simple support for frame-by-frame animations
Generated through a series of images

When not animating, blink randomly

*/

Layer.root.backgroundColor = new Color({hex:"150728"})

const touchCatchingLayer = new Layer()
touchCatchingLayer.frame = Layer.root.bounds

const starterFps = 60
const numFirstFrame = 1
const numLastFrame = 62
let currentFrame = numFirstFrame
const strFilename = "yayfez-"

const firstFrameName = strFilename + numFirstFrame
const gifLayer = new Layer({imageName: firstFrameName})
gifLayer.y = Layer.root.height - gifLayer.height/2
gifLayer.x = Layer.root.x

// start looping on touch
touchCatchingLayer.touchBeganHandler = function(touchSequence) {
	touchCatchingLayer.behaviors = [playThroughImages] 
}

// speed and slow animation depending on where the touch is in x
touchCatchingLayer.touchMovedHandler = function(touchSequence) {
	
}

// stop looping when touch has ended
touchCatchingLayer.touchEndedHandler = touchCatchingLayer.touchCancelledHandler = function(touchSequence) {

}

const playThroughImages = new ActionBehavior({handler:function(layer) {
	const nextFrameName = strFilename + currentFrame
	gifLayer.image = new Image({name:nextFrameName})
	if (currentFrame + 1 > numLastFrame) {
		currentFrame = numFirstFrame
		touchCatchingLayer.behaviors = [] 
	}
	else { 
		currentFrame++
	}

	}
})



function playThroughImagesWithSpeed(fps) {

}
