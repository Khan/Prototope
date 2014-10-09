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

		let redLayer = Layer(parent: RootLayer, name: "Red!")
		redLayer.frame = Rect(x: 300, y: 300, width: 100, height: 100)
		redLayer.backgroundColor = UIColor.red
		redLayer.cornerRadius = 10
		redLayer.border = Border(color: UIColor.black, width: 4)
		redLayer.shadow = Shadow(color: UIColor.black, alpha: 0.75, offset: Size(), radius: 10)

		redLayer.fadeOutAndRemoveAfterDuration(3)
	}

}

