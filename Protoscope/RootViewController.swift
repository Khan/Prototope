//
//  RootViewController.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/7/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
	private enum State {
		case WaitingForConnection
		case DisplayingScene(SceneViewController)
		case Exception(SceneViewController, ExceptionViewController)
	}

	private var state: State = .WaitingForConnection

	var protoscopeNavigationController: UINavigationController!
	var statusViewController: UIViewController!

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has intentionally not been implemented")
	}

	/// Returns scene display host view
	func transitionToSceneDisplay() -> UIView {
		switch state {
		case .WaitingForConnection:
			let sceneViewController = SceneViewController()
			protoscopeNavigationController.pushViewController(sceneViewController, animated: true)
			protoscopeNavigationController.view.layoutIfNeeded()
			state = .DisplayingScene(sceneViewController)
			return sceneViewController.sceneView
		case let .DisplayingScene(sceneViewController):
			sceneViewController.resetSceneView()
			return sceneViewController.sceneView
		case let .Exception(sceneViewController, _):
			dismissViewControllerAnimated(false, completion: nil)
			state = .DisplayingScene(sceneViewController)
			sceneViewController.resetSceneView()
			return sceneViewController.sceneView
		}
	}

	func displayException(exception: String) {
		switch state {
		case .WaitingForConnection:
			fatalError("Didn't expect to receive an exception while waiting for a connection.")
		case let .DisplayingScene(sceneViewController):
			let exceptionViewController = ExceptionViewController()
			exceptionViewController.exception = exception
			presentViewController(exceptionViewController, animated: false, completion: nil)

			state = .Exception(sceneViewController, exceptionViewController)
		case let .Exception(_, exceptionViewController):
			exceptionViewController.exception = exception
		}
	}

	func appendConsoleMessage(message: String) {
		switch state {
		case .WaitingForConnection:
			fatalError("Didn't expect to receive a console message while waiting for a connection.")
		case let .DisplayingScene(sceneViewController):
			sceneViewController.appendConsoleMessage(message)
		case let .Exception(sceneViewController, _):
			sceneViewController.appendConsoleMessage(message)
		}
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
	
	
	func handleKeyCommand(command: UIKeyCommand!) {
		switch self.state {
		case .DisplayingScene(let sceneViewController):
			sceneViewController.resetSceneView()
			
		default:
			return
		}
	}
	
	// needed to let vc handle keypresses
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	override var keyCommands: [AnyObject]? {
		get {
			let escape = UIKeyCommand(input: "r", modifierFlags: .Command, action: "handleKeyCommand:")
			return [escape]
		}
	}
	
}
