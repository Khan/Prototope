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
	var textAlignment: JSValue { get set }
	var baselineHeight: Double { get }
	func alignWithBaselineOf(layer: TextLayerJSExport)
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
	
	public var textAlignment: JSValue {
		get { return TextAlignmentBridge.encodeAlignment(textLayer.textAlignment, inContext: JSContext.currentContext()) }
		set { textLayer.textAlignment = TextAlignmentBridge.decodeAlignment(newValue) }
	}
	
	public var baselineHeight: Double {
		return textLayer.baselineHeight
	}
	
	public func alignWithBaselineOf(otherLayer: TextLayerJSExport) {
		textLayer.alignWithBaselineOf((otherLayer as JSExport as! TextLayerBridge).textLayer)
	}
}

public class TextAlignmentBridge: NSObject, BridgeType {
	enum RawAlignment: Int {
		case Left = 0
		case Center = 1
		case Right = 2
		case Justified = 3
		case Natural = 4
	}
	
	public class func addToContext(context: JSContext) {
		let alignmentObject = JSValue(newObjectInContext: context)
		alignmentObject.setObject(RawAlignment.Left.rawValue, forKeyedSubscript: "Left")
		alignmentObject.setObject(RawAlignment.Center.rawValue, forKeyedSubscript: "Center")
		alignmentObject.setObject(RawAlignment.Right.rawValue, forKeyedSubscript: "Right")
		alignmentObject.setObject(RawAlignment.Justified.rawValue, forKeyedSubscript: "Justified")
		alignmentObject.setObject(RawAlignment.Natural.rawValue, forKeyedSubscript: "Natural")
		context.setObject(alignmentObject, forKeyedSubscript: "TextAlignment")
	}
	
	public class func encodeAlignment(kind: Prototope.TextLayer.Alignment, inContext context: JSContext) -> JSValue {
		var rawAlignment: RawAlignment
		switch kind {
		case .Left: rawAlignment = .Left
		case .Center: rawAlignment = .Center
		case .Right: rawAlignment = .Right
		case .Justified: rawAlignment = .Justified
		case .Natural: rawAlignment = .Natural
		}
		return JSValue(int32: Int32(rawAlignment.rawValue), inContext: context)
	}
	
	public class func decodeAlignment(bridgedAlignment: JSValue) -> Prototope.TextLayer.Alignment {
		if let rawAlignment = RawAlignment(rawValue: Int(bridgedAlignment.toInt32())) {
			switch rawAlignment {
			case .Left: return .Left
			case .Center: return .Center
			case .Right: return .Right
			case .Justified: return .Justified
			case .Natural: return .Natural
			}
		} else {
			return .Natural
		}
	}
}

