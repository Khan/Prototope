//
//  ViewController.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/3/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit
import Prototope

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		Environment.currentEnvironment = Environment(rootView: view, fileProvider: { _ in nil })

		for i in 0..<5 {
			let layer = makeRedLayer("Layer \(i)", Double(i) * 250)
		}

		makeJSLayer()
	}

}

func makeRedLayer(name: String, y: Double) -> Layer {
	let redLayer = Layer(parent: Layer.root, name: name)
	redLayer.image = Image(name: "paint")
	tunable(50, name: "x") { value in redLayer.frame.origin = Point(x: value, y: y) }
	redLayer.backgroundColor = Color.red
	redLayer.cornerRadius = 10
	redLayer.border = Border(color: Color.black, width: 4)

	redLayer.gestures.append(PanGesture{ phase, centroidSequence in
		if phase == .Began {
			redLayer.animators.position.stop()
    	} else if let previousSample = centroidSequence.previousSample {
			redLayer.position += (centroidSequence.currentSample.globalLocation - previousSample.globalLocation)
		}
		if phase == .Ended {
			redLayer.animators.position.target = Point(x: 100, y: 100)
			redLayer.animators.position.velocity = centroidSequence.currentVelocityInLayer(Layer.root)
		}
	})
	redLayer.gestures.append(TapGesture { location in
		if tunable(true, name: "shrinks when tapped") {
			Sound(name: "Glass").play()
			redLayer.animators.frame.target = Rect(x: 30, y: 30, width: 50, height: 50)
			redLayer.animators.frame.completionHandler = { println("Converged") }
		}
	})
	return redLayer
}
