//
//  Environment.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/8/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

public struct Environment {
	public var rootLayer: Layer
	public var fileProvider: String -> NSData?

	public static var currentEnvironment: Environment?

	public init(rootView: UIView, fileProvider: String -> NSData?) {
		self.rootLayer = Layer(wrappingView: rootView, name: "Root")
		// TODO: move defaultSpec into Environment.
		rootView.addGestureRecognizer(defaultSpec.twoFingerTripleTapGestureRecognizer())

		self.fileProvider = fileProvider
	}

	public static func runWithEnvironment(environment: Environment, action: () -> Void) {
		// Eventually this will push and pop... but we're a long way from that because we still get events from the system now (e.g. timers, gestures). Before we can really push and pop, callbacks to clients will have to restore the environment according with those events. So for now, the expectation is that everything's dead when you change the environment.
		currentEnvironment = environment
		action()
	}
}
