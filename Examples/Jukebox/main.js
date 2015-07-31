const sounds = ["coin", "explosion", "jump", "laser", "powerup"]
Layer.root.backgroundColor = new Color({hue: 0.1, brightness: 1.0, saturation: 0.4});

const button = new Layer({imageName: "note"})
button.position = Layer.root.bounds.center

button.gestures = [
	new TapGesture({
		handler: function() {
			const soundIndex = Math.floor(Math.random() * sounds.length)
			const sound = new Sound({name: sounds[soundIndex]})
			sound.play()
		}
	})
]
