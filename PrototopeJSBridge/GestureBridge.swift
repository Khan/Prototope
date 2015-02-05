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

// MARK: - Sample Sequences

extension JSValue: SampleType {}

@objc public protocol SampleSequenceJSExport: JSExport {
	init?(args: JSValue)
	var samples: NSArray { get }
	var id: JSValue { get }
	var firstSample: JSValue { get }
	var previousSample: JSValue? { get }
	var currentSample: JSValue { get }
	func sampleSequenceByAppendingSample(sample: JSValue) -> SampleSequenceJSExport
}

@objc public class SampleSequenceBridge: NSObject, SampleSequenceJSExport, BridgeType {
	var sampleSequence: Prototope.SampleSequence<JSValue, JSValue>!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "SampleSequence")
	}

	public required init?(args: JSValue) {
		let samplesValue = args.valueForProperty("samples")
		let idValue = args.valueForProperty("id")

		if !samplesValue.isUndefined() && !idValue.isUndefined() {
			let sampleBridges = samplesValue.toArray().map { JSValue(object: $0, inContext: JSContext.currentContext())! }
			sampleSequence = Prototope.SampleSequence(samples: sampleBridges, id: idValue)
			super.init()
		} else {
			super.init()
			return nil
		}
	}

	init(_ sampleSequence: Prototope.SampleSequence<JSValue, JSValue>) {
		self.sampleSequence = sampleSequence
		super.init()
	}

	public var samples: NSArray { return sampleSequence.samples }
	public var id: JSValue { return sampleSequence.id }
	public var firstSample: JSValue { return sampleSequence.firstSample }
	public var previousSample: JSValue? { return sampleSequence.previousSample }
	public var currentSample: JSValue { return sampleSequence.currentSample }

	public func sampleSequenceByAppendingSample(sample: JSValue) -> SampleSequenceJSExport {
		return SampleSequenceBridge(sampleSequence.sampleSequenceByAppendingSample(sample))
	}
}

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

// MARK: - Touch Sequences

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

// MARK: Gestures

// Yuuuuuck. There should be a better way to use generics or protocols to accomplish this, but swiftc is getting really crashy when I try.
func gestureBridgeForGesture(gesture: GestureType) -> GestureBridgeType {
	switch gesture {
	case is TapGesture: return TapGestureBridge(gesture as TapGesture)
	case is PanGesture: return PanGestureBridge(gesture as PanGesture)
	default: abort()
	}
}

func gestureForGestureBridge(gestureBridge: GestureBridgeType) -> GestureType {
	switch gestureBridge {
	case is TapGestureBridge: return (gestureBridge as TapGestureBridge).tapGesture
	case is PanGestureBridge: return (gestureBridge as PanGestureBridge).panGesture
	default: abort()
	}
}

@objc public protocol GestureBridgeType {}

@objc protocol TapGestureJSExport: JSExport {
	init?(args: JSValue)
	var numberOfTouchesRequired: Int { get }
	var numberOfTapsRequired: Int { get }
}

@objc public class TapGestureBridge: NSObject, TapGestureJSExport, BridgeType, GestureBridgeType {
	let tapGesture: Prototope.TapGesture!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "TapGesture")
	}

	public required init?(args: JSValue) {
		let handler = args.valueForProperty("handler")
		if !handler.isUndefined() {
			let cancelsTouchesInLayerValue = args.valueForProperty("cancelsTouchesInLayer")
			let cancelsTouchesInLayer = cancelsTouchesInLayerValue.isUndefined() ? true : cancelsTouchesInLayerValue.toBool()

			let numberOfTapsRequiredValue = args.valueForProperty("numberOfTapsRequired")
			let numberOfTapsRequired = numberOfTapsRequiredValue.isUndefined() ? 1 : Int(numberOfTapsRequiredValue.toInt32())

			let numberOfTouchesRequiredValue = args.valueForProperty("numberOfTouchesRequired")
			let numberOfTouchesRequired = numberOfTouchesRequiredValue.isUndefined() ? 1 : Int(numberOfTouchesRequiredValue.toInt32())

			tapGesture = TapGesture(
				cancelsTouchesInLayer: cancelsTouchesInLayer,
				numberOfTapsRequired: numberOfTapsRequired,
				numberOfTouchesRequired: numberOfTouchesRequired,
				handler: { location in
					handler.callWithArguments([PointBridge(location)])
					return
				}
			)
			super.init()
		} else {
			super.init()
			return nil
		}
	}

	public init(_ gesture: TapGesture) {
		self.tapGesture = gesture
		super.init()
	}

	public var numberOfTouchesRequired: Int { return tapGesture.numberOfTouchesRequired }
	public var numberOfTapsRequired: Int { return tapGesture.numberOfTapsRequired }

}

@objc protocol PanGestureJSExport: JSExport {
	init?(args: JSValue)
}

func encodeContinuousGesturePhase(phase: ContinuousGesturePhase) -> Int {
	switch phase {
	case .Began: return 0
	case .Changed: return 1
	case .Ended: return 2
	case .Cancelled: return 3
	}
}

func decodeContinuousGesturePhase(encodedPhase: Int) -> ContinuousGesturePhase? {
	switch encodedPhase {
	case 0: return .Began
	case 1: return .Changed
	case 2: return .Ended
	case 3: return .Cancelled
	default: return nil
	}
}

@objc public class PanGestureBridge: NSObject, PanGestureJSExport, BridgeType, GestureBridgeType {
	let panGesture: Prototope.PanGesture!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "PanGesture")
		// TODO: expose phase constants
	}

	public required init?(args: JSValue) {
		let handler = args.valueForProperty("handler")
		if !handler.isUndefined() {
			let cancelsTouchesInLayerValue = args.valueForProperty("cancelsTouchesInLayer")
			let cancelsTouchesInLayer = cancelsTouchesInLayerValue.isUndefined() ? true : cancelsTouchesInLayerValue.toBool()

			let minimumNumberOfTouchesValue = args.valueForProperty("minimumNumberOfTouches")
			let minimumNumberOfTouches = minimumNumberOfTouchesValue.isUndefined() ? 1 : Int(minimumNumberOfTouchesValue.toInt32())

			let maximumNumberOfTouchesValue = args.valueForProperty("maximumNumberOfTouches")
			let maximumNumberOfTouches = maximumNumberOfTouchesValue.isUndefined() ? Int.max : Int(maximumNumberOfTouchesValue.toInt32())

			panGesture = PanGesture(
				minimumNumberOfTouches: minimumNumberOfTouches,
				maximumNumberOfTouches: maximumNumberOfTouches,
				cancelsTouchesInLayer: cancelsTouchesInLayer,
				handler: { [context = JSContext.currentContext()] (phase, sequence) in
					let bridgedID = JSValue(int32: Int32(sequence.id), inContext: context)
					let bridgedSequence = TouchSequenceBridge(TouchSequence(samples: sequence.samples, id: bridgedID))
					handler.callWithArguments([
						JSValue(int32: Int32(encodeContinuousGesturePhase(phase)), inContext: context),
						bridgedSequence
					])
					return
				}
			)
			super.init()
		} else {
			super.init()
			return nil
		}
	}

	public init(_ gesture: PanGesture) {
		self.panGesture = gesture
		super.init()
	}
}