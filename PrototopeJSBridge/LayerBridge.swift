//
//  LayerBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 1/29/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol LayerJSExport: JSExport {
	class var root: LayerBridge { get } // Not automatically imported via JSExport.
	init(parent: LayerJSExport /* JSC crashes if I write LayerBridge here */, name: String)
	var frame: CGRect { get set }
}

@objc public class LayerBridge: NSObject, LayerJSExport {
	public var layer: Layer

	public class var root: LayerBridge {
		let result = LayerBridge(wrappingLayer: Layer.root)
		return result
	}

	private init(wrappingLayer: Layer) {
		layer = wrappingLayer
		super.init()
	}

	required public init(parent: LayerJSExport, name: String) {
		layer = Layer(parent: (parent as LayerBridge).layer, name: name)
		layer.backgroundColor = Color.green
		super.init()
	}

	public var frame: CGRect {
		get { return CGRect(layer.frame) }
		set { layer.frame = Rect(newValue) }
	}

}
