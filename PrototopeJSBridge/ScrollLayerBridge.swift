//
//  ScrollLayerBridge.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-11.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol ScrollLayerJSExport: JSExport {
	init?(args: NSDictionary)
	
	
	var scrollableSize: SizeBridge { get set }
	var showsVerticalScrollIndicator: Bool { get set }
	var showsHorizontalScrollIndicator: Bool { get set }
	func updateScrollableSizeToFitSublayers()
}


@objc public class ScrollLayerBridge: LayerBridge, ScrollLayerJSExport, BridgeType {
	var scrollLayer: ScrollLayer { return layer as! ScrollLayer }
	
	public override class func bridgedPrototypeInContext(context: JSContext) -> JSValue { return JSValue(object: self, inContext: context) }
	public static var bridgedConstructorName: String = "ScrollLayer"

	required public init?(args: NSDictionary) {
		let parentLayer = (args["parent"] as! LayerBridge?)?.layer
		let name = args["name"] as! String?
		
		let scrollLayer = ScrollLayer(parent: parentLayer, name: name)
		super.init(scrollLayer)
		
	}
	
	
	/** The scrollable size of the layer. */
	public var scrollableSize: SizeBridge {
		get { return SizeBridge(self.scrollLayer.scrollableSize) }
		set { self.scrollLayer.scrollableSize = newValue.size }
	}
	
	
	/** Controls whether or not the vertical scroll indicator shows on scroll. Defaults to `true`. */
	public var showsVerticalScrollIndicator: Bool {
		get { return self.scrollLayer.showsVerticalScrollIndicator }
		set { self.scrollLayer.showsVerticalScrollIndicator = newValue }
	}
	
	
	/** Controls whether or not the horizontal scroll indicator shows on scroll. Defaults to `true`. */
	public var showsHorizontalScrollIndicator: Bool {
		get { return self.scrollLayer.showsHorizontalScrollIndicator }
		set { self.scrollLayer.showsHorizontalScrollIndicator = newValue }
	}


	/** Updates the scrollable size of the layer to fit its subviews exactly. Does not change the size of the layer, just its scrollable area. */
	public func updateScrollableSizeToFitSublayers() {
		self.scrollLayer.updateScrollableSizeToFitSublayers()
	}
}