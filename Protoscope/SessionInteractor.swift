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
import swiftz_core

class SessionInteractor {
	private var context: PrototopeJSBridge.Context?

	init() {}

	func displayPrototype(prototype: Prototype, rootView: UIView) {
		Prototope.Layer.root?.removeAllSublayers()
		Prototope.Environment.currentEnvironment = Environment(
			rootView: rootView,
			imageProvider: { name in
				let scale = UIScreen.mainScreen().scale
				let filenameWithScale = name.stringByAppendingString("@\(Int(scale))x").stringByAppendingPathExtension("png")!
				let filename = name.stringByAppendingPathExtension("png")!

				let loadImage: (String, CGFloat) -> UIImage? = { filename, scale in
					return prototype.images[filename] >>- { UIImage(data: $0, scale: scale) }
				}

				return loadImage(filenameWithScale, scale) ?? loadImage(filename, 1)
			}
		)

		let script = NSString(data: prototype.mainScript, encoding: NSUTF8StringEncoding)
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
