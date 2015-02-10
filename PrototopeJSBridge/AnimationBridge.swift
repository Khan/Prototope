//
//  AnimationBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/5/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import JavaScriptCore
import Prototope

let animateWithDurationBridgingTrampoline: @objc_block JSValue -> Void = { args in
	let durationValue = args.valueForProperty("duration")
	let curveValue = args.valueForProperty("curve")
	let animationsHandler = args.valueForProperty("animations")
	let completionHandler = args.valueForProperty("completionHandler")

	if !durationValue.isUndefined() && !animationsHandler.isUndefined() {
		let animationsHandler: () -> Void = {
			animationsHandler.callWithArguments([])
			return
		}
		let completionHandler: (() -> Void)? = completionHandler.isUndefined() ? nil : {
			completionHandler.callWithArguments([])
			return
		}
		if curveValue.isUndefined() {
			Prototope.Layer.animateWithDuration(
				durationValue.toDouble(),
				animations: animationsHandler,
				completionHandler: completionHandler
			)
		} else {
			Prototope.Layer.animateWithDuration(
				durationValue.toDouble(),
				curve: AnimationCurveBridge.decodeCurve(curveValue)!,
				animations: animationsHandler,
				completionHandler: completionHandler
			)
		}
	}
}

@objc public protocol LayerAnimatorStoreJSExport: JSExport {
	var x: AnimatorJSExport { get }
	var y: AnimatorJSExport { get }
	var position: AnimatorJSExport { get }
	var size: AnimatorJSExport { get }
	var frame: AnimatorJSExport { get }
	var bounds: AnimatorJSExport { get }
	var backgroundColor: AnimatorJSExport { get }
	var alpha: AnimatorJSExport { get }
	var rotationRadians: AnimatorJSExport { get }
	var scale: AnimatorJSExport { get }
}

@objc public class LayerAnimatorStoreBridge: NSObject, LayerAnimatorStoreJSExport {
	let animatorStore: LayerAnimatorStore
	init(_ animatorStore: LayerAnimatorStore) {
		self.animatorStore = animatorStore
		super.init()
	}

	public var x: AnimatorJSExport { return DoubleAnimatorBridge(animatorStore.x) }
	public var y: AnimatorJSExport { return DoubleAnimatorBridge(animatorStore.y) }
	public var position: AnimatorJSExport { return PointAnimatorBridge(animatorStore.position) }
	public var size: AnimatorJSExport { return SizeAnimatorBridge(animatorStore.size) }
	public var frame: AnimatorJSExport { return RectAnimatorBridge(animatorStore.frame) }
	public var bounds: AnimatorJSExport { return RectAnimatorBridge(animatorStore.bounds) }
	public var backgroundColor: AnimatorJSExport { return ColorAnimatorBridge(animatorStore.backgroundColor) }
	public var alpha: AnimatorJSExport { return DoubleAnimatorBridge(animatorStore.alpha) }
	public var rotationRadians: AnimatorJSExport { return DoubleAnimatorBridge(animatorStore.rotationRadians) }
	public var scale: AnimatorJSExport { return PointAnimatorBridge(animatorStore.scale) }
}

@objc public protocol AnimatorJSExport: JSExport {
	var target: JSValue? { get set }
	var springSpeed: Double { get set }
	var springBounciness: Double { get set }
	var velocity: JSValue? { get set }
	var completionHandler: JSValue? { get set }
}

@objc public class DoubleAnimatorBridge: NSObject, AnimatorJSExport {
	let animator: Animator<Double>

	init(_ animator: Animator<Double>) {
		self.animator = animator
		super.init()
	}

	public var target: JSValue? {
		get { return animator.target != nil ? JSValue(double: animator.target!, inContext: JSContext.currentContext()) : nil }
		set { animator.target = newValue != nil ? newValue!.toDouble() : nil }
	}

	public var springSpeed: Double {
		get { return animator.springSpeed }
		set { animator.springSpeed = newValue }
	}

	public var springBounciness: Double {
		get { return animator.springBounciness }
		set { animator.springBounciness = newValue }
	}

	public var velocity: JSValue? {
		get { return animator.velocity != nil ? JSValue(double: animator.velocity!, inContext: JSContext.currentContext()) : nil }
		set { animator.velocity = newValue != nil ? newValue!.toDouble() : nil }
	}

	public var completionHandler: JSValue? {
		get {
			return JSValue(object: unsafeBitCast(animator.completionHandler, AnyObject.self), inContext: JSContext.currentContext())
		}
		set {
			if let completionHandler = newValue {
				animator.completionHandler = { completionHandler.callWithArguments([]); return }
			} else {
				animator.completionHandler = nil
			}
		}
	}
}

@objc public class PointAnimatorBridge: NSObject, AnimatorJSExport {
	let animator: Animator<Prototope.Point>

	init(_ animator: Animator<Prototope.Point>) {
		self.animator = animator
		super.init()
	}

	public var target: JSValue? {
		get { return animator.target != nil ? JSValue(object: PointBridge(animator.target!), inContext: JSContext.currentContext()) : nil }
		set { animator.target = (newValue?.toObject() as! PointBridge?)?.point }
	}

	public var springSpeed: Double {
		get { return animator.springSpeed }
		set { animator.springSpeed = newValue }
	}

	public var springBounciness: Double {
		get { return animator.springBounciness }
		set { animator.springBounciness = newValue }
	}

	public var velocity: JSValue? {
		get { return animator.velocity != nil ? JSValue(object: PointBridge(animator.velocity!), inContext: JSContext.currentContext()) : nil }
		set { animator.velocity = (newValue?.toObject() as! PointBridge?)?.point }
	}

	public var completionHandler: JSValue? {
		get {
			return JSValue(object: unsafeBitCast(animator.completionHandler, AnyObject.self), inContext: JSContext.currentContext())
		}
		set {
			if let completionHandler = newValue {
				animator.completionHandler = { completionHandler.callWithArguments([]); return }
			} else {
				animator.completionHandler = nil
			}
		}
	}
}

@objc public class SizeAnimatorBridge: NSObject, AnimatorJSExport {
	let animator: Animator<Prototope.Size>

	init(_ animator: Animator<Prototope.Size>) {
		self.animator = animator
		super.init()
	}

	public var target: JSValue? {
		get { return animator.target != nil ? JSValue(object: SizeBridge(animator.target!), inContext: JSContext.currentContext()) : nil }
		set { animator.target = (newValue?.toObject() as! SizeBridge?)?.size }
	}

	public var springSpeed: Double {
		get { return animator.springSpeed }
		set { animator.springSpeed = newValue }
	}

	public var springBounciness: Double {
		get { return animator.springBounciness }
		set { animator.springBounciness = newValue }
	}

	public var velocity: JSValue? {
		get { return animator.velocity != nil ? JSValue(object: SizeBridge(animator.velocity!), inContext: JSContext.currentContext()) : nil }
		set { animator.velocity = (newValue?.toObject() as! SizeBridge?)?.size }
	}

	public var completionHandler: JSValue? {
		get {
			return JSValue(object: unsafeBitCast(animator.completionHandler, AnyObject.self), inContext: JSContext.currentContext())
		}
		set {
			if let completionHandler = newValue {
				animator.completionHandler = { completionHandler.callWithArguments([]); return }
			} else {
				animator.completionHandler = nil
			}
		}
	}
}

@objc public class RectAnimatorBridge: NSObject, AnimatorJSExport {
	let animator: Animator<Prototope.Rect>

	init(_ animator: Animator<Prototope.Rect>) {
		self.animator = animator
		super.init()
	}

	public var target: JSValue? {
		get { return animator.target != nil ? JSValue(object: RectBridge(animator.target!), inContext: JSContext.currentContext()) : nil }
		set { animator.target = (newValue?.toObject() as! RectBridge?)?.rect }
	}

	public var springSpeed: Double {
		get { return animator.springSpeed }
		set { animator.springSpeed = newValue }
	}

	public var springBounciness: Double {
		get { return animator.springBounciness }
		set { animator.springBounciness = newValue }
	}

	public var velocity: JSValue? {
		get { return animator.velocity != nil ? JSValue(object: RectBridge(animator.velocity!), inContext: JSContext.currentContext()) : nil }
		set { animator.velocity = (newValue?.toObject() as! RectBridge?)?.rect }
	}

	public var completionHandler: JSValue? {
		get {
			return JSValue(object: unsafeBitCast(animator.completionHandler, AnyObject.self), inContext: JSContext.currentContext())
		}
		set {
			if let completionHandler = newValue {
				animator.completionHandler = { completionHandler.callWithArguments([]); return }
			} else {
				animator.completionHandler = nil
			}
		}
	}
}

@objc public class ColorAnimatorBridge: NSObject, AnimatorJSExport {
	let animator: Animator<Prototope.Color>

	init(_ animator: Animator<Prototope.Color>) {
		self.animator = animator
		super.init()
	}

	public var target: JSValue? {
		get { return animator.target != nil ? JSValue(object: ColorBridge(animator.target!), inContext: JSContext.currentContext()) : nil }
		set { animator.target = (newValue?.toObject() as! ColorBridge?)?.color }
	}

	public var springSpeed: Double {
		get { return animator.springSpeed }
		set { animator.springSpeed = newValue }
	}

	public var springBounciness: Double {
		get { return animator.springBounciness }
		set { animator.springBounciness = newValue }
	}

	public var velocity: JSValue? {
		get { return animator.velocity != nil ? JSValue(object: ColorBridge(animator.velocity!), inContext: JSContext.currentContext()) : nil }
		set { animator.velocity = (newValue?.toObject() as! ColorBridge?)?.color }
	}

	public var completionHandler: JSValue? {
		get {
			return JSValue(object: unsafeBitCast(animator.completionHandler, AnyObject.self), inContext: JSContext.currentContext())
		}
		set {
			if let completionHandler = newValue {
				animator.completionHandler = { completionHandler.callWithArguments([]); return }
			} else {
				animator.completionHandler = nil
			}
		}
	}
}


public class AnimationCurveBridge: NSObject, BridgeType {
	private enum RawCurve: Int {
		case Linear = 0
		case EaseIn
		case EaseOut
		case EaseInOut
	}

	public class func addToContext(context: JSContext) {
		let animationCurveBridge = JSValue(newObjectInContext: context)
		animationCurveBridge.setObject(RawCurve.Linear.rawValue, forKeyedSubscript: "Linear")
		animationCurveBridge.setObject(RawCurve.EaseIn.rawValue, forKeyedSubscript: "EaseIn")
		animationCurveBridge.setObject(RawCurve.EaseOut.rawValue, forKeyedSubscript: "EaseOut")
		animationCurveBridge.setObject(RawCurve.EaseInOut.rawValue, forKeyedSubscript: "EaseInOut")
		context.setObject(animationCurveBridge, forKeyedSubscript: "AnimationCurve")
	}

	public class func decodeCurve(bridgedCurve: JSValue) -> Prototope.Layer.AnimationCurve? {
		if let rawCurve = RawCurve(rawValue: Int(bridgedCurve.toInt32())) {
			switch rawCurve {
			case .Linear: return .Linear
			case .EaseIn: return .EaseIn
			case .EaseOut: return .EaseOut
			case .EaseInOut: return .EaseInOut
			}
		} else {
			return nil
		}
	}
}
