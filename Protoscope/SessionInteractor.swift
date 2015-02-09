//
//  SessionInteractor.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/8/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import PrototopeJSBridge

class SessionInteractor {
	private var context: PrototopeJSBridge.Context?

	init() {}

	// TODO: Make scene model.
	func displayScene(script: String, rootView: UIView) {
		Prototope.Layer.root?.removeAllSublayers()
		Prototope.Environment.currentEnvironment = Environment(
			rootView: rootView,
			imageProvider: { _ in fatalError("Unimplemented"); return nil }
		)

		context = SessionInteractor.createContext()
		context?.evaluateScript(script)
	}

	private class func createContext() -> PrototopeJSBridge.Context {
		let context = PrototopeJSBridge.Context()
		context.exceptionHandler = { value in
			let lineNumber = value.objectForKeyedSubscript("line")
			println("Exception on line \(lineNumber): \(value)")
		}
		return context
	}
}
