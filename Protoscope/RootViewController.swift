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
	var sceneViewController: SceneViewController?

	override init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has intentionally not been implemented")
	}

	/// Returns scene display host view
	func transitionToSceneDisplay() -> UIView {
		// TODO: Replace with value-based state
		if protoscopeNavigationController.topViewController !== sceneViewController {
			sceneViewController = SceneViewController()
			protoscopeNavigationController.pushViewController(sceneViewController!, animated: true)
		}
		return sceneViewController!.view
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
