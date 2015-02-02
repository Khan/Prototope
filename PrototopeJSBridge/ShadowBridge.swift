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
	init(color: ColorJSExport, alpha: Double, offset: CGSize, radius: Double)
	// TODO make mutable properties, but will need to notify layerbridge owner on changes (yuuuck)
}

@objc public class ShadowBridge: NSObject, ShadowJSExport, BridgeType {
	var shadow: Shadow

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Shadow")
	}

	required public init(color: ColorJSExport, alpha: Double, offset: CGSize, radius: Double) {
		shadow = Shadow(color: (color as JSExport as ColorBridge).color, alpha: alpha, offset: Size(offset), radius: radius)
		super.init()
	}

	init(_ shadow: Shadow) {
		self.shadow = shadow
		super.init()
	}
}
