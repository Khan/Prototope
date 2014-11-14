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

		let redLayer = Layer(parent: RootLayer, imageName: "paint")
		redLayer.frame.origin = Point(x: 50, y: 50)
		redLayer.backgroundColor = UIColor.red
		redLayer.cornerRadius = 10
		redLayer.border = Border(color: UIColor.black, width: 4)
		redLayer.shadow = Shadow(color: UIColor.black, alpha: 0.75, offset: Size(), radius: 10)

		redLayer.gestures.append(TapGesture(handler: { _ in
			println("Tap gesture triggered")
		}))

		redLayer.touchesBeganHandler = { _ in println("Touches began"); return true }
		redLayer.touchesMovedHandler = { sequences in
			for (_, sequence) in sequences {
				println(sequence.samples)
			}
			return true
		}
		redLayer.touchesEndedHandler = { _ in println("Touches ended"); return true }
		redLayer.touchesCancelledHandler = { _ in println("Touches cancelled"); return true }


		afterDuration(0.5) {
			redLayer.rotationDegrees = 30
			redLayer.scale = 2
		}
	}

}

