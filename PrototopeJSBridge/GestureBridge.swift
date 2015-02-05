//
//  GestureBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/4/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

// MARK: - Touches

@objc public protocol TouchSampleJSExport: JSExport {
	init?(args: JSValue)
	var globalLocation: PointJSExport { get }
	var timestamp: Double { get }
	func locationInLayer(layer: LayerJSExport) -> PointJSExport
}

@objc public class TouchSampleBridge: NSObject, TouchSampleJSExport, BridgeType {
	var touchSample: Prototope.TouchSample!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "TouchSample")
	}

	public required init?(args: JSValue) {
		super.init()

		let globalLocationValue = args.valueForProperty("globalLocation")
		let timestampValue = args.valueForProperty("timestamp")

		if !globalLocationValue.isUndefined() && !timestampValue.isUndefined() {
			touchSample = Prototope.TouchSample(
				globalLocation: (globalLocationValue.toObject() as JSExport as PointBridge).point,
				timestamp: Prototope.Timestamp(timestampValue.toDouble())
			)
		} else {
			return nil
		}
	}

	public var globalLocation: PointJSExport { return PointBridge(touchSample.globalLocation) }
	public var timestamp: Double { return touchSample.timestamp.nsTimeInterval }
	public func locationInLayer(layer: LayerJSExport) -> PointJSExport {
		return PointBridge(touchSample.locationInLayer((layer as JSExport as LayerBridge).layer))
	}
}
