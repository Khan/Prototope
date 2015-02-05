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

	init(_ touchSample: TouchSample) {
		self.touchSample = touchSample
		super.init()
	}

	public var globalLocation: PointJSExport { return PointBridge(touchSample.globalLocation) }
	public var timestamp: Double { return touchSample.timestamp.nsTimeInterval }
	public func locationInLayer(layer: LayerJSExport) -> PointJSExport {
		return PointBridge(touchSample.locationInLayer((layer as JSExport as LayerBridge).layer))
	}
}

@objc public protocol UITouchIDJSExport: JSExport {
	func equals(other: UITouchIDBridge) -> Bool
}

@objc public class UITouchIDBridge: NSObject, UITouchIDJSExport, BridgeType {
	var uiTouchID: UITouchID

	public class func addToContext(context: JSContext) {}

	init(_ uiTouchID: UITouchID) {
		self.uiTouchID = uiTouchID
		super.init()
	}

	public func equals(other: UITouchIDBridge) -> Bool {
		return uiTouchID == (other as JSExport as UITouchIDBridge).uiTouchID
	}
}

// MARK: - Touch Sequences

@objc public protocol TouchSequenceJSExport: JSExport {
	init?(args: JSValue)
	var samples: NSArray { get }
	var id: JSValue { get }
	var firstSample: TouchSampleJSExport { get }
	var previousSample: TouchSampleJSExport? { get }
	var currentSample: TouchSampleJSExport { get }
	func currentVelocityInLayer(layer: LayerJSExport) -> PointJSExport
	func currentGlobalVelocity() -> PointJSExport
	func sampleSequenceByAppendingSample(sample: TouchSampleJSExport) -> TouchSequenceJSExport
}

@objc public class TouchSequenceBridge: NSObject, TouchSequenceJSExport, BridgeType {
	var touchSequence: Prototope.TouchSequence<JSValue>!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "TouchSequence")
	}

	public required init?(args: JSValue) {
		super.init()

		let samplesValue = args.valueForProperty("samples")
		let idValue = args.valueForProperty("id")

		if !samplesValue.isUndefined() && !idValue.isUndefined() {
			let sampleBridges = samplesValue.toArray() as [TouchSampleBridge]
			touchSequence = Prototope.TouchSequence(
				samples: sampleBridges.map { $0.touchSample },
				id: idValue
			)
		} else {
			return nil
		}
	}

	init(_ touchSequence: Prototope.TouchSequence<JSValue>) {
		self.touchSequence = touchSequence
		super.init()
	}

	public var samples: NSArray {
		return touchSequence.samples.map { TouchSampleBridge($0) }
	}

	public var id: JSValue { return touchSequence.id }

	public var firstSample: TouchSampleJSExport { return TouchSampleBridge(touchSequence.firstSample) }

	public var previousSample: TouchSampleJSExport? {
		if let previousSample = touchSequence.previousSample {
			return TouchSampleBridge(previousSample)
		} else {
			return nil
		}
	}
	
	public var currentSample: TouchSampleJSExport { return TouchSampleBridge(touchSequence.currentSample) }

	public func currentVelocityInLayer(layer: LayerJSExport) -> PointJSExport {
		let velocity = touchSequence.currentVelocityInLayer((layer as JSExport as LayerBridge).layer)
		return PointBridge(velocity)
	}

	public func currentGlobalVelocity() -> PointJSExport {
		return PointBridge(touchSequence.currentGlobalVelocity())
	}

	public func sampleSequenceByAppendingSample(sampleBridge: TouchSampleJSExport) -> TouchSequenceJSExport {
		let sample = (sampleBridge as JSExport as TouchSampleBridge).touchSample
		return TouchSequenceBridge(touchSequence.sampleSequenceByAppendingSample(sample))
	}
}
