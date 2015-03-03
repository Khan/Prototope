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
	private let exceptionHandler: String -> ()
	private let consoleLogHandler: String -> ()

	init(exceptionHandler: String -> (), consoleLogHandler: String -> ()) {
		self.exceptionHandler = exceptionHandler
		self.consoleLogHandler = consoleLogHandler
	}

	func displayPrototype(prototype: Prototype, rootView: UIView) {
		Prototope.Layer.root?.removeAllSublayers()
		Prototope.Environment.currentEnvironment = Environment(
			rootView: rootView,
			imageProvider: { name in
				let scale = UIScreen.mainScreen().scale
				let filenameWithScale = name.stringByAppendingString("@\(Int(scale))x").stringByAppendingPathExtension("png")!
				let filename = name.stringByAppendingPathExtension("png")!

				let loadImage: (String, CGFloat) -> UIImage? = { filename, scale in
					// What does the brainfuck operator do?
					return prototype.resources[filename] >>- {
						let image = UIImage(data: $0, scale: scale)
						return image
					}
				}

				return loadImage(filenameWithScale, scale) ?? loadImage(filename, 1)
			},
			soundProvider: { name in
				for fileExtension in Sound.supportedExtensions {
					if let data = prototype.resources[name.stringByAppendingPathExtension(fileExtension)!] {
						return data
					}
				}
				return nil
			}
		)

		let script = NSString(data: prototype.mainScript, encoding: NSUTF8StringEncoding)!
		context = createContext()
		context?.evaluateScript(script as String)
	}

	private func createContext() -> PrototopeJSBridge.Context {
		let context = PrototopeJSBridge.Context()
		context.exceptionHandler = { [weak self] value in
			let lineNumber = value.objectForKeyedSubscript("line")
			let exception = ("Line \(lineNumber): \(value)")
			self?.exceptionHandler(exception)
		}
		context.consoleLogHandler = { [weak self] message in
			self?.consoleLogHandler(message)
			return
		}
		return context
	}
}
