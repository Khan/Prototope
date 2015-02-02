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
	init(color: ColorJSExport, width: Double)
	// TODO: make these work again... will require notifying the owning layer bridge of a change. yuck.
//	var color: ColorJSExport { get set }
//	var width: Double { get set }
}

@objc public class BorderBridge: NSObject, BorderJSExport, BridgeType {
	var border: Border

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Border")
	}

	required public init(color: ColorJSExport, width: Double) {
		border = Border(color: (color as JSExport as ColorBridge).color, width: width)
		super.init()
	}

	init(_ border: Border) {
		self.border = border
		super.init()
	}

	/*public var color: ColorJSExport {
		get { return ColorBridge(border.color) }
		set { border.color = (color as JSExport as ColorBridge).color }
	}

	public var width: Double {
		get { return border.width }
		set { border.width = newValue }
	}*/
}
