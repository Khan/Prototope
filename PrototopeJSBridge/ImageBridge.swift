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
	init?(args: NSDictionary)
}

@objc public class ImageBridge: NSObject, ImageJSExport, BridgeType {
	var image: Image!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Image")
	}

	required public init?(args: NSDictionary) {
		if let imageName = args["name"] as! String? {
			image = Image(name: imageName)
			super.init()
		} else {
			super.init()
			return nil
		}
	}

	init(_ image: Image) {
		self.image = image
		super.init()
	}
	
	
	public override var description: String {
		return image.description
	}
}
