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
	var preciseGlobalLocation: PointJSExport { get }
	var timestamp: Double { get }
	var force: Double { get }
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

		if !globalLocationValue.isUndefined && !timestampValue.isUndefined {
			touchSample = Prototope.TouchSample(
				globalLocation: (globalLocationValue.toObject() as! JSExport as! PointBridge).point,
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
	public var preciseGlobalLocation: PointJSExport { return PointBridge(touchSample.preciseGlobalLocation) }
	
	public var timestamp: Double { return touchSample.timestamp.nsTimeInterval }
	public var force: Double { return touchSample.force }
	
	public func locationInLayer(layer: LayerJSExport) -> PointJSExport {
		return PointBridge(touchSample.locationInLayer((layer as JSExport as! LayerBridge).layer))
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
		return uiTouchID == (other as JSExport as! UITouchIDBridge).uiTouchID
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

		if !samplesValue.isUndefined && !idValue.isUndefined {
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

		if !samplesValue.isUndefined && !idValue.isUndefined {
			let sampleBridges = samplesValue.toArray() as! [TouchSampleBridge]
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
		let velocity = touchSequence.currentVelocityInLayer((layer as JSExport as! LayerBridge).layer)
		return PointBridge(velocity)
	}

	public func currentGlobalVelocity() -> PointJSExport {
		return PointBridge(touchSequence.currentGlobalVelocity())
	}

	public func sampleSequenceByAppendingSample(sampleBridge: TouchSampleJSExport) -> TouchSequenceJSExport {
		let sample = (sampleBridge as JSExport as! TouchSampleBridge).touchSample
		return TouchSequenceBridge(touchSequence.sampleSequenceByAppendingSample(sample))
	}
}

// MARK: - Gestures

// Yuuuuuck. There should be a better way to use generics or protocols to accomplish this, but swiftc is getting really crashy when I try.
func gestureBridgeForGesture(gesture: GestureType) -> GestureBridgeType {
	switch gesture {
	case is TapGesture: return TapGestureBridge(gesture as! TapGesture)
	case is PanGesture: return PanGestureBridge(gesture as! PanGesture)
	case is RotationGesture: return RotationGestureBridge(gesture as! RotationGesture)
	case is PinchGesture: return PinchGestureBridge(gesture as! PinchGesture)
	default: abort()
	}
}

func gestureForGestureBridge(gestureBridge: GestureBridgeType) -> GestureType {
	switch gestureBridge {
	case is TapGestureBridge: return (gestureBridge as! TapGestureBridge).tapGesture
	case is PanGestureBridge: return (gestureBridge as! PanGestureBridge).panGesture
	case is RotationGestureBridge: return (gestureBridge as! RotationGestureBridge).rotationGesture
	case is PinchGestureBridge: return (gestureBridge as! PinchGestureBridge).pinchGesture
	default: abort()
	}
}

@objc public protocol GestureBridgeType {}

// MARK: TapGesture

@objc protocol TapGestureJSExport: JSExport {
	init?(args: JSValue)
	var numberOfTouchesRequired: Int { get }
	var numberOfTapsRequired: Int { get }
    var shouldRecognizeSimultaneouslyWithGesture: JSValue? { get set }
}

@objc public class TapGestureBridge: NSObject, TapGestureJSExport, BridgeType, GestureBridgeType {
	let tapGesture: Prototope.TapGesture!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "TapGesture")
	}
    
    public var shouldRecognizeSimultaneouslyWithGesture: JSValue? {
        didSet {
            if let f = shouldRecognizeSimultaneouslyWithGesture {
                tapGesture.shouldRecognizeSimultaneouslyWithGesture = { gesture in
                    let bridgedGesture = gestureBridgeForGesture(gesture)
                    let result = f.callWithArguments([bridgedGesture])
                    return result.toBool()
                }
            } else {
                tapGesture.shouldRecognizeSimultaneouslyWithGesture = { _ in return false }
            }
        }
    }

	public required init?(args: JSValue) {
		let handler = args.valueForProperty("handler")
		if !handler.isUndefined {
			let cancelsTouchesInLayerValue = args.valueForProperty("cancelsTouchesInLayer")
			let cancelsTouchesInLayer = cancelsTouchesInLayerValue.isUndefined ? true : cancelsTouchesInLayerValue.toBool()

			let numberOfTapsRequiredValue = args.valueForProperty("numberOfTapsRequired")
			let numberOfTapsRequired = numberOfTapsRequiredValue.isUndefined ? 1 : Int(numberOfTapsRequiredValue.toInt32())

			let numberOfTouchesRequiredValue = args.valueForProperty("numberOfTouchesRequired")
			let numberOfTouchesRequired = numberOfTouchesRequiredValue.isUndefined ? 1 : Int(numberOfTouchesRequiredValue.toInt32())

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
			tapGesture = nil
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

// MARK: ContinuousGesturePhase

public class ContinuousGesturePhaseBridge: NSObject, BridgeType {
	enum RawPhase: Int {
		case Began = 0
		case Changed
		case Ended
		case Cancelled
	}

	public class func addToContext(context: JSContext) {
		let continuousGesturePhaseObject = JSValue(newObjectInContext: context)
		continuousGesturePhaseObject.setObject(RawPhase.Began.rawValue, forKeyedSubscript: "Began")
		continuousGesturePhaseObject.setObject(RawPhase.Changed.rawValue, forKeyedSubscript: "Changed")
		continuousGesturePhaseObject.setObject(RawPhase.Ended.rawValue, forKeyedSubscript: "Ended")
		continuousGesturePhaseObject.setObject(RawPhase.Cancelled.rawValue, forKeyedSubscript: "Cancelled")
		context.setObject(continuousGesturePhaseObject, forKeyedSubscript: "ContinuousGesturePhase")
	}

	public class func encodePhase(phase: ContinuousGesturePhase, inContext context: JSContext) -> JSValue {
		var rawPhase: RawPhase
		switch phase {
		case .Began: rawPhase = .Began
		case .Changed: rawPhase = .Changed
		case .Ended: rawPhase = .Ended
		case .Cancelled: rawPhase = .Cancelled
		}
		return JSValue(int32: Int32(rawPhase.rawValue), inContext: context)
	}
}

// MARK: PanGesture

@objc protocol PanGestureJSExport: JSExport {
	init?(args: JSValue)
    var shouldRecognizeSimultaneouslyWithGesture: JSValue? { get set }
}

@objc public class PanGestureBridge: NSObject, PanGestureJSExport, BridgeType, GestureBridgeType {
	let panGesture: Prototope.PanGesture!
    
    public var shouldRecognizeSimultaneouslyWithGesture: JSValue? {
        didSet {
            if let f = shouldRecognizeSimultaneouslyWithGesture {
                panGesture.shouldRecognizeSimultaneouslyWithGesture = { gesture in
                    let bridgedGesture = gestureBridgeForGesture(gesture)
                    let result = f.callWithArguments([bridgedGesture])
                    return result.toBool()
                }
            } else {
                panGesture.shouldRecognizeSimultaneouslyWithGesture = { _ in return false }
            }
        }
    }

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "PanGesture")
	}

	public required init?(args: JSValue) {
		let handler = args.valueForProperty("handler")
		if !handler.isUndefined {
			let cancelsTouchesInLayerValue = args.valueForProperty("cancelsTouchesInLayer")
			let cancelsTouchesInLayer = cancelsTouchesInLayerValue.isUndefined ? true : cancelsTouchesInLayerValue.toBool()

			let minimumNumberOfTouchesValue = args.valueForProperty("minimumNumberOfTouches")
			let minimumNumberOfTouches = minimumNumberOfTouchesValue.isUndefined ? 1 : Int(minimumNumberOfTouchesValue.toInt32())

			let maximumNumberOfTouchesValue = args.valueForProperty("maximumNumberOfTouches")
			let maximumNumberOfTouches = maximumNumberOfTouchesValue.isUndefined ? Int.max : Int(maximumNumberOfTouchesValue.toInt32())

			panGesture = PanGesture(
				minimumNumberOfTouches: minimumNumberOfTouches,
				maximumNumberOfTouches: maximumNumberOfTouches,
				cancelsTouchesInLayer: cancelsTouchesInLayer,
				handler: { [context = JSContext.currentContext()] (phase, sequence) in
					let bridgedID = JSValue(int32: Int32(sequence.id), inContext: context)
					let bridgedSequence = TouchSequenceBridge(TouchSequence(samples: sequence.samples, id: bridgedID))
					handler.callWithArguments([
						ContinuousGesturePhaseBridge.encodePhase(phase, inContext: context),
						bridgedSequence
					])
					return
				}
			)
			super.init()
		} else {
			panGesture = nil
			super.init()
			return nil
		}
	}

	public init(_ gesture: PanGesture) {
		self.panGesture = gesture
		super.init()
	}
}

// MARK: RotationGesture

@objc public protocol RotationSampleJSExport: JSExport {
	var rotationRadians: Double { get }
	var velocityRadians: Double { get }
	var rotationDegrees: Double { get }
	var velocityDegrees: Double { get }
	var centroid: TouchSampleJSExport { get }
}

@objc public class RotationSampleBridge: NSObject, RotationSampleJSExport, BridgeType {
	var rotationSample: Prototope.RotationSample!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "RotationSample")
	}

	init(_ rotationSample: RotationSample) {
		self.rotationSample = rotationSample
		super.init()
	}

	public var rotationRadians: Double { return rotationSample.rotationRadians }
	public var velocityRadians: Double { return rotationSample.velocityRadians }
	public var rotationDegrees: Double { return rotationSample.rotationDegrees }
	public var velocityDegrees: Double { return rotationSample.velocityDegrees }
	public var centroid: TouchSampleJSExport { return TouchSampleBridge(rotationSample.centroid) }
}

@objc protocol RotationGestureJSExport: JSExport {
	init?(args: JSValue)
    var shouldRecognizeSimultaneouslyWithGesture: JSValue? { get set }
}

@objc public class RotationGestureBridge: NSObject, RotationGestureJSExport, BridgeType, GestureBridgeType {
	let rotationGesture: Prototope.RotationGesture!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "RotationGesture")
	}
    
    public var shouldRecognizeSimultaneouslyWithGesture: JSValue? {
        didSet {
            if let f = shouldRecognizeSimultaneouslyWithGesture {
                rotationGesture.shouldRecognizeSimultaneouslyWithGesture = { gesture in
                    let bridgedGesture = gestureBridgeForGesture(gesture)
                    let result = f.callWithArguments([bridgedGesture])
                    return result.toBool()
                }
            } else {
                rotationGesture.shouldRecognizeSimultaneouslyWithGesture = { _ in return false }
            }
        }
    }

	public required init?(args: JSValue) {
		let handler = args.valueForProperty("handler")
		if !handler.isUndefined {
			let cancelsTouchesInLayerValue = args.valueForProperty("cancelsTouchesInLayer")
			let cancelsTouchesInLayer = cancelsTouchesInLayerValue.isUndefined ? true : cancelsTouchesInLayerValue.toBool()

			rotationGesture = RotationGesture(
				cancelsTouchesInLayer: cancelsTouchesInLayer,
				handler: { [context = JSContext.currentContext()] (phase, sequence) in
					let bridgedID = JSValue(int32: Int32(sequence.id), inContext: context)
					let bridgedSamples = sequence.samples.map { JSValue(object: RotationSampleBridge($0), inContext: context)! }
					let bridgedSequence = SampleSequenceBridge(SampleSequence(samples: bridgedSamples, id: bridgedID))
					handler.callWithArguments([
						ContinuousGesturePhaseBridge.encodePhase(phase, inContext: context),
						bridgedSequence
					])
					return
				}
			)
			super.init()
		} else {
			rotationGesture = nil
			super.init()
			return nil
		}
	}

	public init(_ gesture: RotationGesture) {
		self.rotationGesture = gesture
		super.init()
	}
}

// MARK: PinchGesture

@objc public protocol PinchSampleJSExport: JSExport {
	var scale: Double { get }
	var velocity: Double { get }
	var centroid: TouchSampleJSExport { get }
}

@objc public class PinchSampleBridge: NSObject, PinchSampleJSExport, BridgeType {
	var pinchSample: Prototope.PinchSample!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "PinchSample")
	}

	init(_ pinchSample: PinchSample) {
		self.pinchSample = pinchSample
		super.init()
	}

	public var scale: Double { return pinchSample.scale }
	public var velocity: Double { return pinchSample.velocity }
	public var centroid: TouchSampleJSExport { return TouchSampleBridge(pinchSample.centroid) }
}

@objc protocol PinchGestureJSExport: JSExport {
	init?(args: JSValue)
    var shouldRecognizeSimultaneouslyWithGesture: JSValue? { get set }
}

@objc public class PinchGestureBridge: NSObject, PinchGestureJSExport, BridgeType, GestureBridgeType {
	let pinchGesture: Prototope.PinchGesture!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "PinchGesture")
	}

    public var shouldRecognizeSimultaneouslyWithGesture: JSValue? {
        didSet {
            if let f = shouldRecognizeSimultaneouslyWithGesture {
                pinchGesture.shouldRecognizeSimultaneouslyWithGesture = { gesture in
                    let bridgedGesture = gestureBridgeForGesture(gesture)
                    let result = f.callWithArguments([bridgedGesture])
                    return result.toBool()
                }
            } else {
                pinchGesture.shouldRecognizeSimultaneouslyWithGesture = { _ in return false }
            }
        }
    }

	public required init?(args: JSValue) {
		let handler = args.valueForProperty("handler")
		if !handler.isUndefined {
			let cancelsTouchesInLayerValue = args.valueForProperty("cancelsTouchesInLayer")
			let cancelsTouchesInLayer = cancelsTouchesInLayerValue.isUndefined ? true : cancelsTouchesInLayerValue.toBool()

			pinchGesture = PinchGesture(
				cancelsTouchesInLayer: cancelsTouchesInLayer,
				handler: { [context = JSContext.currentContext()] (phase, sequence) in
					let bridgedID = JSValue(int32: Int32(sequence.id), inContext: context)
					let bridgedSamples = sequence.samples.map { JSValue(object: PinchSampleBridge($0), inContext: context)! }
					let bridgedSequence = SampleSequenceBridge(SampleSequence(samples: bridgedSamples, id: bridgedID))
					handler.callWithArguments([
						ContinuousGesturePhaseBridge.encodePhase(phase, inContext: context),
						bridgedSequence
					])
					return
				}
			)
			super.init()
		} else {
			pinchGesture = nil
			super.init()
			return nil
		}
	}

	public init(_ gesture: PinchGesture) {
		self.pinchGesture = gesture
		super.init()
	}
}