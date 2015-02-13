//
//  Environment.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/8/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

/** Establishes an environment in which Prototope can execute. */
public struct Environment {
	public let rootLayer: Layer
	public let imageProvider: String -> UIImage?
	public let soundProvider: String -> NSData?
    public let behaviorDriver: BehaviorDriver

	public static var currentEnvironment: Environment?

	public init(rootView: UIView, imageProvider: String -> UIImage?, soundProvider: String -> NSData?) {
		self.rootLayer = Layer(wrappingView: rootView, name: "Root")

		// TODO: move defaultSpec into Environment.
		let gesture = defaultSpec.twoFingerTripleTapGestureRecognizer()
		rootView.addGestureRecognizer(gesture)
		gesture.cancelsTouchesInView = false
		gesture.delaysTouchesEnded = false

		self.imageProvider = imageProvider
		self.soundProvider = soundProvider
        self.behaviorDriver = BehaviorDriver()
	}

	public static func runWithEnvironment(environment: Environment, action: () -> Void) {
		// Eventually this will push and pop... but we're a long way from that because we still get events from the system now (e.g. timers, gestures). Before we can really push and pop, callbacks to clients will have to restore the environment according with those events. So for now, the expectation is that everything's dead when you change the environment.
		currentEnvironment = environment
		action()
	}

	public static func defaultEnvironmentWithRootView(rootView: UIView) -> Environment {
		return Environment(
			rootView: rootView,
			imageProvider: { UIImage(named: $0) },
			soundProvider: { name in
				for fileExtension in ["caf", "aif", "aiff", "wav"] {
					if let URL = NSBundle.mainBundle().URLForResource(name, withExtension: fileExtension) {
						return NSData(contentsOfURL: URL, options: nil, error: nil)
					}
				}
				return nil
			}
		)
	}
}
