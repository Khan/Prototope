//
//  BridgeType.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/1/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import JavaScriptCore

public protocol BridgeType {
	static func bridgedPrototypeInContext(context: JSContext) -> JSValue
	static var bridgedConstructorName: String { get }

//    optional static func addToContext(context: JSContext)
}
