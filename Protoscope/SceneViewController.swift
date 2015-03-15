//
//  SceneViewController.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/7/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

class SceneViewController: UIViewController {
	// TODO Factor all this UI stuff out in to a UIView class
	var sceneView: UIView = SceneViewController.createSceneView()

	private var consoleView: ConsoleView = {
		let consoleView = ConsoleView()
		consoleView.autoresizingMask = .FlexibleBottomMargin | .FlexibleWidth
		return consoleView
	}()
	private var consoleViewTransitionCount = 0
	private var consoleViewVisible = false

	func resetSceneView() {
		sceneView.removeFromSuperview()

		sceneView = SceneViewController.createSceneView()
		sceneView.frame = view.bounds
		view.addSubview(sceneView)

		consoleView.reset()
		setConsoleViewVisible(false, animated: true)
	}

	func appendConsoleMessage(message: String) {
		consoleView.appendConsoleMessage(message)
		setConsoleViewVisible(true, animated: true)
	}

	private func setConsoleViewVisible(visible: Bool, animated: Bool) {
		if visible == consoleViewVisible { return }

		consoleView.frame = view.bounds
		consoleView.frame.size.height = 50
		consoleView.frame.origin.y = visible ? -consoleView.frame.size.height : 0

		let finalOrigin = visible ? 0 : -consoleView.frame.size.height
		if visible && consoleView.superview == nil {
			view.insertSubview(consoleView, aboveSubview: sceneView)
		}
		let cleanup: () -> Void = {
			if self.consoleViewTransitionCount == 0 && !self.consoleViewVisible {
				self.consoleView.removeFromSuperview()
			}
		}

		if animated {
			UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: { () -> Void in
				self.consoleView.frame.origin.y = finalOrigin
				self.consoleViewTransitionCount++
			}, completion: { _ in
				self.consoleViewTransitionCount--
				cleanup()
			})
		} else {
			consoleView.frame.origin.y = finalOrigin
			cleanup()
		}

		consoleViewVisible = visible
		if visible {
			consoleView.scrollToBottomAnimated(false)
		}
	}

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has intentionally not been implemented")
	}

	override func loadView() {
		super.loadView()
		sceneView.frame = view.bounds
		consoleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissConsole"))
		view.addSubview(sceneView)
	}

	@objc private func dismissConsole() {
		setConsoleViewVisible(false, animated: true)
	}

	private class func createSceneView() -> UIView {
		let view = UIView()
		view.backgroundColor = UIColor.whiteColor()
		view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
		return view
	}
}
