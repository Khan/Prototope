//
//  RootViewController.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/7/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
	var protoscopeNavigationController: UINavigationController!
	var statusViewController: UIViewController!

	override init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has intentionally not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		statusViewController = StatusViewController()
		protoscopeNavigationController = UINavigationController(rootViewController: statusViewController)
		protoscopeNavigationController.navigationBarHidden = true

		addChildViewController(protoscopeNavigationController)
		view.addSubview(protoscopeNavigationController.view)
		protoscopeNavigationController.didMoveToParentViewController(self)
	}

	override func prefersStatusBarHidden() -> Bool {
		return true
	}
}
