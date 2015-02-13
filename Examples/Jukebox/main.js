var sounds = ["coin", "explosion", "jump", "laser", "powerup"]
Layer.root.backgroundColor = new Color({hue: 0.1, brightness: 1.0, saturation: 0.4});

var button = new Layer({imageName: "note"})
button.position = Layer.root.bounds.center

button.gestures = [
	new TapGesture({
		handler: function() {
			var soundIndex = Math.floor(Math.random() * sounds.length)
			var sound = new Sound({name: sounds[soundIndex]})
			sound.play()
		}
	})
]
