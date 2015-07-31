//
//  BorderBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/2/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol BorderJSExport: JSExport {
	init(args: NSDictionary)
	// TODO: make setters work again... will require notifying the owning layer bridge of a change. yuck.
	var color: ColorJSExport { get }
	var width: Double { get }
}

@objc public class BorderBridge: NSObject, BorderJSExport, BridgeType {
	var border: Border

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Border")
	}

	required public init(args: NSDictionary) {
		border = Border(
			color: (args["color"] as! ColorBridge?)?.color ?? Color.black,
			width: (args["width"] as! Double?) ?? 0.0
		)
		super.init()
	}

	init(_ border: Border) {
		self.border = border
		super.init()
	}

	public var color: ColorJSExport {
		return ColorBridge(border.color)
	}

	public var width: Double {
		return border.width
	}
}
