Layer.root.backgroundColor = new Color({hue: 0.5, saturation: 0.9, brightness: 0.4})

var singleLineLayer = new TextLayer()
singleLineLayer.text = "This is a single centered line"
singleLineLayer.border = new Border({color: Color.red, width: 1})
singleLineLayer.textColor = new Color({white: 0.85})
singleLineLayer.fontName = "Optima"
singleLineLayer.fontSize = 25
singleLineLayer.x = Layer.root.x
singleLineLayer.y = 30


var wrappingLayer = new TextLayer()
wrappingLayer.text = "Hello there and welcome to Prototope, where we wrap text for you if you want."
wrappingLayer.textAlignment = TextAlignment.Right
wrappingLayer.textColor = Color.white
wrappingLayer.wraps = true
wrappingLayer.border = new Border({color: Color.red, width: 1})
wrappingLayer.x = Layer.root.x
wrappingLayer.y = 300
wrappingLayer.width = 100

var alignmentLayer = new TextLayer()
alignmentLayer.text = "align"
alignmentLayer.fontSize = 64
alignmentLayer.border = new Border({color: Color.red, width: 1})

var h = new Heartbeat({handler: function(heartbeat) {
	wrappingLayer.width = 100 + Math.sin(heartbeat.timestamp * 4) * 50
	alignmentLayer.alignWithBaselineOf(wrappingLayer)
	alignmentLayer.x = wrappingLayer.x + wrappingLayer.width*0.5 + alignmentLayer.width*0.5

}})