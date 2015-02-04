//
//  Context.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import JavaScriptCore

public class Context {
	public var exceptionHandler: (JSValue -> Void)? {
		didSet {
			context.exceptionHandler = { [exceptionHandler = self.exceptionHandler] _, value in
				exceptionHandler?(value)
				return
			}
		}
	}

	private let vm = JSVirtualMachine()
	private let context: JSContext

	public init() {
		context = JSContext(virtualMachine: vm)
		addBridgedTypes()
	}

	public func evaluateScript(script: String!) -> JSValue {
		return context.evaluateScript(script)
	}

	private func addBridgedTypes() {
		LayerBridge.addToContext(context)
		ColorBridge.addToContext(context)
		BorderBridge.addToContext(context)
		ShadowBridge.addToContext(context)
		ImageBridge.addToContext(context)
		PointBridge.addToContext(context)
		SizeBridge.addToContext(context)
		RectBridge.addToContext(context)
		TunableBridge.addToContext(context)
	}
}