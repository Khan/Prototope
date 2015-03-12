//
//  ExceptionViewController.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/11/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

class ExceptionViewController: UIViewController {
	var exception: String? {
		get { return exceptionView.exception }
		set { exceptionView.exception = newValue }
	}

	private var exceptionView: ExceptionView { return view as! ExceptionView }

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has intentionally not been implemented")
	}

	override func loadView() {
		view = ExceptionView()
	}

	override func prefersStatusBarHidden() -> Bool {
		return true
	}
}