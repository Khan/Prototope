//
//  StatusViewController.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/7/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
	override init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has intentionally not been implemented")
	}

	override func loadView() {
		view = StatusView()
		view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
	}
}