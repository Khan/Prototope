//
//  TextLayerBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/15/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol TextLayerJSExport: JSExport {
	var text: String? { get set }
	var fontName: String { get set }
	var fontSize: Double { get set }
	var textColor: ColorJSExport { get set }
	var wraps: Bool { get set }
}


@objc public class TextLayerBridge: LayerBridge, TextLayerJSExport, BridgeType {
	var textLayer: TextLayer { return layer as! TextLayer }

	public override class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "TextLayer")
	}

	public required init?(args: NSDictionary) {
		let parentLayer = (args["parent"] as! LayerBridge?)?.layer
		let textLayer = TextLayer(parent: parentLayer, name: (args["name"] as! String?))
		super.init(textLayer)
	}

	public var text: String? {
		get { return textLayer.text }
		set { textLayer.text = newValue }
	}


	public var fontName: String {
		get { return textLayer.fontName }
		set { textLayer.fontName = newValue }
	}

	public var fontSize: Double {
		get { return textLayer.fontSize }
		set { textLayer.fontSize = newValue }
	}

	public var textColor: ColorJSExport {
		get { return ColorBridge(textLayer.textColor) }
		set { textLayer.textColor = (newValue as! ColorBridge).color }
	}

	public var wraps: Bool {
		get { return textLayer.wraps }
		set { textLayer.wraps = newValue }
	}
}
