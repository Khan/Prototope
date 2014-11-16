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

		for i in 0..<10 {
			let layer = makeRedLayer("Layer \(i)")
			layer.x = Double(i) * 80
		}

	}

}

func makeRedLayer(name: String) -> Layer {
	let redLayer = Layer(parent: RootLayer, name: name)
	redLayer.image = Image(name: "paint")
	redLayer.frame.origin = Point(x: 50, y: 50)
	redLayer.backgroundColor = UIColor.red
	redLayer.cornerRadius = 10
	redLayer.border = Border(color: UIColor.black, width: 4)
	redLayer.shadow = Shadow(color: UIColor.black, alpha: 0.75, offset: Size(), radius: 10)

	redLayer.gestures.append(PanGesture{ phase, centroidSequence in
		println("\(phase): \(centroidSequence)")
	})
	redLayer.gestures.append(TapGesture({ location in
		println("\(redLayer.name): \(location)")
		}, numberOfTapsRequired: 2))
	return redLayer
}