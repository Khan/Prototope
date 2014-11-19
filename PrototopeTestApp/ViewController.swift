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

		setRootLayer(fromView: view)

		for i in 0..<5 {
			let layer = makeRedLayer("Layer \(i)")
			layer.y = Double(i) * 250
		}

	}

}

func makeRedLayer(name: String) -> Layer {
	let redLayer = Layer(parent: RootLayer, name: name)
	redLayer.image = Image(name: "paint")
	redLayer.frame.origin = Point(x: 50, y: 50)
	redLayer.backgroundColor = UIColor.red
	redLayer.cornerRadius = 10 // TODO(andy) mask to bounds when using corner radius
	redLayer.border = Border(color: UIColor.black, width: 4)
	redLayer.shadow = Shadow(color: UIColor.black, alpha: 0.75, offset: Size(), radius: 10)

	redLayer.gestures.append(PanGesture{ _, centroidSequence in
		if let previousSample = centroidSequence.previousSample {
			redLayer.position += (centroidSequence.currentSample.globalLocation - previousSample.globalLocation)
		}
	})
	redLayer.gestures.append(TapGesture { location in
		redLayer.animators.frame.target = Rect(x: 30, y: 30, width: 50, height: 50)
	})
	return redLayer
}