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

		let redView = View(parent: view)
		redView.x = 200
		redView.y = 200
		redView.width = 100
		redView.height = 100
		redView.backgroundColor = UIColor.redColor()
		redView.cornerRadius = 10
		redView.border = Border(color: UIColor.blackColor(), width: 4)
		redView.shadow = Shadow(color: UIColor.blackColor(), alpha: 0.75, offset: CGSize(), radius: 10)
	}

}

