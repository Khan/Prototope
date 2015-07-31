var toolbarColors = [
	new Color({hex: "9B73AB"}),
	new Color({hex: "C55F73"}),
	new Color({hex: "FA6255"}),
	new Color({hex: "EFAC5F"}),
	new Color({hex: "83C166"}),
	new Color({hex: "5CD0B1"}),
	new Color({hex: "4FBAD3"}),
	new Color({hex: "6A8CA6"}),
	new Color({hex: "1F2C35"}),
	new Color({hex: "FEFFFF"})
]

let activeColor = toolbarColors[0]

let activeTouchIDs = []
let activeTouchShapeLayer = undefined

Layer.root.touchBeganHandler = sequence => {
	if (activeTouchIDs.length < 2) {
		activeTouchIDs.push(sequence.id)
		if (activeTouchIDs.length == 2) {
			activeTouchShapeLayer = new ShapeLayer()
			activeTouchShapeLayer.fillColor = activeColor
			activeTouchShapeLayer.strokeColor = undefined
			activeTouchShapeLayer.segments = [
				new Segment(Layer.root.activeTouchSequences[activeTouchIDs[0]].currentSample.globalLocation),
				new Segment(Layer.root.activeTouchSequences[activeTouchIDs[1]].currentSample.globalLocation)
			]
		}
	}
}

Layer.root.touchesMovedHandler = () => {
	if (activeTouchIDs.length == 2) {
		var segments = activeTouchShapeLayer.segments
		var insertionPoint = segments.length / 2.0
		segments.splice(
			insertionPoint,
			0,
			new Segment(Layer.root.activeTouchSequences[activeTouchIDs[0]].currentSample.globalLocation),
			new Segment(Layer.root.activeTouchSequences[activeTouchIDs[1]].currentSample.globalLocation)
		)
		activeTouchShapeLayer.segments = segments

		return true
	} else {
		return false
	}
}

Layer.root.touchEndedHandler = sequence => {
	activeTouchIDs.splice(activeTouchIDs.indexOf(sequence.id), 1)
}

//============================================================================

var toolbarFirstWellPoint = 95
var toolbarWellWidth = 84
var toolbarSelectionCenter = 38
makeToolbar()

function makeToolbar() {
	var toolbar = new Layer({imageName: "toolbar"})
	toolbar.x = Layer.root.x
	toolbar.originY = Layer.root.frameMaxY - toolbar.height
	toolbar.zPosition = 100000
  
  	toolbar.selectionDotLayer = makeToolbarSelectionDot(toolbar, 0)

	toolbar.touchBeganHandler = function(touchSequence) {
		var index = clip({
			value: Math.floor((touchSequence.currentSample.globalLocation.x - toolbarFirstWellPoint) / toolbarWellWidth),
			min: 0,
			max: 9
		})
		activeColor = toolbarColors[index]

		toolbar.selectionDotLayer.animators.scale.target = new Point({x: 0, y: 0})
		var oldSelectionDotLayer = toolbar.selectionDotLayer
		toolbar.selectionDotLayer.animators.scale.completionHandler = function() { oldSelectionDotLayer.parent = undefined }
	  	toolbar.selectionDotLayer = makeToolbarSelectionDot(toolbar, index)
	  	toolbar.selectionDotLayer.scale = 0.0001
	  	toolbar.selectionDotLayer.animators.scale.target = new Point({x: 1.2, y: 1.2})
	}

	toolbar.touchEndedHandler = function(touchSequence) {
		toolbar.selectionDotLayer.animators.scale.target = new Point({x: 1, y: 1})
	}
  
  return toolbar
}

function makeToolbarSelectionDot(toolbar, index) {
  var dot = new Layer({parent: toolbar})
  dot.width = dot.height = 40
  dot.backgroundColor = index == 9 ? Color.black : Color.white
  dot.alpha = 0.5
  dot.cornerRadius = dot.width / 2
  dot.y = toolbar.bounds.midY
  dot.x = toolbarFirstWellPoint + toolbarWellWidth * index + toolbarSelectionCenter
  dot.animators.scale.springBounciness = 3
  dot.animators.scale.springSpeed = 20
  return dot
}
