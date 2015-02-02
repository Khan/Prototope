//
//  ImageBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/2/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol ImageJSExport: JSExport {
	init(name: String)
}

@objc public class ImageBridge: NSObject, ImageJSExport, BridgeType {
	var image: Image

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Image")
	}

	required public init(name: String) {
		image = Image(name: name)
		super.init()
	}

	init(_ image: Image) {
		self.image = image
		super.init()
	}
}
