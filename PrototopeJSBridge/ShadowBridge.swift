//
//  ShadowBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/2/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol ShadowJSExport: JSExport {
	init(args: NSDictionary)
	// TODO make mutable properties, but will need to notify layerbridge owner on changes (yuuuck)
}

@objc public class ShadowBridge: NSObject, ShadowJSExport, BridgeType {
	var shadow: Shadow

	public class func bridgedPrototypeInContext(context: JSContext) -> JSValue { return JSValue(object: self, inContext: context) }
	public static var bridgedConstructorName: String = "Shadow"

	required public init(args: NSDictionary) {
		shadow = Shadow(
			color: (args["color"] as! ColorBridge?)?.color ?? Color.black,
			alpha: (args["alpha"] as! Double?) ?? 1.0,
			offset: (args["offset"] as! SizeBridge?)?.size ?? Size.zero,
			radius: (args["radius"] as! Double?) ?? 3.0
		)
		super.init()
	}

	init(_ shadow: Shadow) {
		self.shadow = shadow
		super.init()
	}
}
