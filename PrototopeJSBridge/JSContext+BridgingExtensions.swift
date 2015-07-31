//
//  JSContext+BridgingExtensions.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import JavaScriptCore

extension JSContext {
	func setFunctionForKey<T>(key: String, fn: T) {
		// Some grossness is needed to persuade Swift to treat closures as objects.
		setObject(unsafeBitCast(fn, AnyObject.self), forKeyedSubscript: key)
	}
}

extension JSValue {
	func setFunctionForKey<T>(key: String, fn: T) {
		// Some grossness is needed to persuade Swift to treat closures as objects.
		setObject(unsafeBitCast(fn, AnyObject.self), forKeyedSubscript: key)
	}
}
