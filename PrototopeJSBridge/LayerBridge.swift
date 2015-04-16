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
	static var root: LayerJSExport { get } // Not automatically imported via JSExport.
    
    // MARK: Creating and identifying layers
	init?(args: NSDictionary)
    var name: String? { get }
    
    // MARK: Layer hierarchy access and manipulation
    var parent: LayerJSExport! { get set }
    var sublayers: [LayerJSExport] { get}
    func removeAllSublayers()
    var sublayerAtFront: LayerJSExport? { get }
    func sublayerNamed(name: String) -> LayerJSExport?
    func descendentNamed(name: String) -> LayerJSExport?
    func descendentAtPath(pathElements: [String]) -> LayerJSExport?
    func ancestorNamed(name: String) -> LayerJSExport?
    
    // MARK: Geometry
    var x: Double { get set }
    var y: Double { get set }
    var origin: PointJSExport { get set }
    var position: PointJSExport { get set }
	var zPosition: Double { get set }
    var width: Double { get set }
    var height: Double { get set }
    var size: SizeJSExport { get set }
    var frame: RectJSExport { get set }
    var bounds: RectJSExport { get set }
    var anchorPoint: PointJSExport { get set }
    var rotationDegrees: Double { get set }
    var rotationRadians: Double { get set }
    var scale: Double { get set }
    var scaleX: Double { get set }
    var scaleY: Double { get set }
    var globalPosition: PointJSExport { get set }
    func containsGlobalPoint(point: PointJSExport) -> Bool
    func convertGlobalPointToLocalPoint(globalPoint: PointJSExport) -> PointJSExport
    func convertLocalPointToGlobalPoint(localPoint: PointJSExport) -> PointJSExport
    
    // MARK: Appearance
    var backgroundColor: ColorJSExport? { get set }
    var alpha: Double { get set }
    var cornerRadius: Double { get set }
    var image: ImageJSExport? { get set }
    var border: BorderJSExport? { get set }
    var shadow: ShadowJSExport? { get set }
    var maskLayer: LayerJSExport? { get set }

	// MARK: Convenience utilities
	var willBeRemovedSoon: Bool { get }
	func removeAfterDuration(duration: Double)
	func fadeOutAndRemoveAfterDuration(duration: Double)

    // MARK: Touches and gestures
    var userInteractionEnabled: Bool { get set }
    var activeTouchSequences: JSValue { get }
	var numberOfActiveTouches: Int32 { get }
    var gestures: [GestureBridgeType] { get set }
    var touchesBeganHandler: JSValue? { get set }
    var touchesMovedHandler: JSValue? { get set }
    var touchesEndedHandler: JSValue? { get set }
    var touchesCancelledHandler: JSValue? { get set }
    var touchBeganHandler: JSValue? { get set }
    var touchMovedHandler: JSValue? { get set }
    var touchEndedHandler: JSValue? { get set }
    var touchCancelledHandler: JSValue? { get set }
    var touchedDescendents: [LayerJSExport] { get }

    // MARK: Animations
    var animators: LayerAnimatorStoreJSExport { get }
	
	// MARK: Particle emitters
	func addParticleEmitter(emitterBridge: ParticleEmitterJSExport)
	func removeParticleEmitter(emitterBridge: ParticleEmitterJSExport)
    
    // MARK: Behaviors
    var behaviors: [BehaviorBridgeType] { get set }
    
    
    // MARK: Layout
    
    var originX: Double { get set }
    var frameMaxX: Double { get }
    var originY: Double { get set }
    var frameMaxY: Double { get }
    
	func moveToRightOfSiblingLayer(args: JSValue)
    func moveToLeftOfSiblingLayer(args: JSValue)
    func moveBelowSiblingLayer(args: JSValue)
    func moveAboveSiblingLayer(args: JSValue)
    func moveToRightSideOfParentLayer(margin: Double)
	func moveToLeftSideOfParentLayer(margin: Double)
	func moveToTopSideOfParentLayer(margin: Double)
	func moveToBottomSideOfParentLayer(margin: Double)
    func moveToVerticalCenterOfParentLayer()
    func moveToHorizontalCenterOfParentLayer()
    func moveToCenterOfParentLayer()
}

@objc public class LayerBridge: NSObject, LayerJSExport, Printable, BridgeType {
    
    public class func addToContext(context: JSContext) {
        context.setObject(LayerBridge.self, forKeyedSubscript: "Layer")
        let layerBridge = context.objectForKeyedSubscript("Layer")
        layerBridge.setObject(LayerBridge.root, forKeyedSubscript: "root")
        layerBridge.setFunctionForKey("animate", fn: animateWithDurationBridgingTrampoline)
    }
    
    public var layer: Layer!
    
    public class var root: LayerJSExport {
        return LayerBridge(Layer.root)!
    }
    
    internal init?(_ wrappingLayer: Layer?) {
        super.init()
        if let wrappingLayer = wrappingLayer {
            layer = wrappingLayer
        } else {
            return nil
        }
    }
    
    public override var description: String {
        return "<LayerBridge: \(layer)>"
    }
    
    // MARK: Creating and identifying layers

    required public init?(args: NSDictionary) {
		let parentLayer = (args["parent"] as! LayerBridge?)?.layer
		if let imageName = args["imageName"] as! String? {
			layer = Layer(parent: parentLayer, imageName: imageName)
		} else {
			layer = Layer(parent: parentLayer, name: (args["name"] as! String?))
		}
        super.init()
    }
    
    public var name: String? {
        get { return layer.name }
    }
    
    // MARK: Layer hierarchy access and manipulation
    
    public var parent: LayerJSExport! {
        get { return layer.parent != nil ? LayerBridge(layer.parent!) : nil }
        set {
            if let newParent = newValue {
                layer.parent = (newParent as JSExport as! LayerBridge).layer
            } else {
                layer.parent = nil
            }
        }
    }
    
    public var sublayers: [LayerJSExport] {
        return layer.sublayers.map { LayerBridge($0)! }
    }
    
    public func removeAllSublayers() { layer.removeAllSublayers() }
    
    public var sublayerAtFront: LayerJSExport? { return LayerBridge(layer.sublayerAtFront) }
    
    public func sublayerNamed(name: String) -> LayerJSExport? { return LayerBridge(layer.sublayerNamed(name)) }
    
    public func descendentNamed(name: String) -> LayerJSExport? { return LayerBridge(layer.descendentNamed(name)) }
    
    public func descendentAtPath(pathElements: [String]) -> LayerJSExport? { return LayerBridge(layer.descendentAtPath(pathElements)) }
    
    public func ancestorNamed(name: String) -> LayerJSExport? { return LayerBridge(layer.ancestorNamed(name)) }
    
    // MARK: Geometry
    
    public var x: Double {
        get { return layer.x }
        set { layer.x = newValue }
    }
    
    public var y: Double {
        get { return layer.y }
        set { layer.y = newValue }
    }
    
    public var origin: PointJSExport {
        get { return PointBridge(layer.origin) }
        set { layer.origin = (newValue as JSExport as! PointBridge).point }
    }
    
    public var position: PointJSExport {
        get { return PointBridge(layer.position) }
        set { layer.position = (newValue as JSExport as! PointBridge).point }
    }

	public var zPosition: Double {
		get { return layer.zPosition }
		set { layer.zPosition = newValue }
	}
    
    public var width: Double {
        get { return layer.width }
        set { layer.width = newValue }
    }
    
    public var height: Double {
        get { return layer.height }
        set { layer.height = newValue }
    }
    
    public var size: SizeJSExport {
        get { return SizeBridge(layer.size) }
        set { layer.size = (newValue as JSExport as! SizeBridge).size }
    }
    
    public var frame: RectJSExport {
        get { return RectBridge(layer.frame) }
        set { layer.frame = (newValue as JSExport as! RectBridge).rect }
    }
    
    public var bounds: RectJSExport {
        get { return RectBridge(layer.bounds) }
        set { layer.bounds = (newValue as JSExport as! RectBridge).rect }
    }
    
    public var anchorPoint: PointJSExport {
        get { return PointBridge(layer.anchorPoint) }
        set { layer.anchorPoint = (newValue as JSExport as! PointBridge).point }
    }
    
    public var rotationDegrees: Double {
        get { return layer.rotationDegrees }
        set { layer.rotationDegrees = newValue }
    }
    
    public var rotationRadians: Double {
        get { return layer.rotationRadians }
        set { layer.rotationRadians = newValue }
    }
    
    public var scale: Double {
        get { return layer.scale }
        set { layer.scale = newValue }
    }
    
    public var scaleX: Double {
        get { return layer.scaleX }
        set { layer.scaleX = newValue }
    }
    
    public var scaleY: Double {
        get { return layer.scaleY }
        set { layer.scaleY = newValue }
    }
    
    public var globalPosition: PointJSExport {
        get { return PointBridge(layer.globalPosition) }
        set { layer.globalPosition = (newValue as JSExport as! PointBridge).point }
    }
    
    public func containsGlobalPoint(point: PointJSExport) -> Bool { return layer.containsGlobalPoint((point as JSExport as! PointBridge).point) }
    public func convertGlobalPointToLocalPoint(globalPoint: PointJSExport) -> PointJSExport { return PointBridge(layer.convertGlobalPointToLocalPoint((globalPoint as JSExport as! PointBridge).point)) }
    public func convertLocalPointToGlobalPoint(localPoint: PointJSExport) -> PointJSExport { return PointBridge(layer.convertLocalPointToGlobalPoint((localPoint as JSExport as! PointBridge).point)) }
    
    // MARK: Appearance
    
    public var backgroundColor: ColorJSExport? {
        get { return layer.backgroundColor != nil ? ColorBridge(layer.backgroundColor!) : nil }
        set { layer.backgroundColor = (newValue as! ColorBridge).color }
    }
    
    public var alpha: Double {
        get { return layer.alpha }
        set { layer.alpha = newValue }
    }
    
    public var cornerRadius: Double {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

	public var image: ImageJSExport? {
		get {
			return layer.image != nil ? ImageBridge(layer.image!) : nil
		}
		set {
			layer.image = (newValue as! JSExport as! ImageBridge).image
		}
	}

	public var border: BorderJSExport? {
		get {
			return BorderBridge(layer.border)
		}
		set {
			if let border = border {
				layer.border = (newValue as! JSExport as! BorderBridge).border
			} else {
				layer.border = Border(color: Color.clear, width: 0)
			}
		}
	}

	public var shadow: ShadowJSExport? {
		get {
			return ShadowBridge(layer.shadow)
		}
		set {
			if let shadow = shadow {
				layer.shadow = (newValue as! JSExport as! ShadowBridge).shadow
			} else {
				layer.shadow = Shadow(color: Color.clear, alpha: 0, offset: Size(width: 0, height: 0), radius: 0)
			}
		}
	}
    
    public var maskLayer: LayerJSExport? {
        get { return LayerBridge(layer.maskLayer) }
        set { layer.maskLayer = (newValue as! LayerBridge?)?.layer }
    }

	// MARK: Convenience utilities

	public var willBeRemovedSoon: Bool { return layer.willBeRemovedSoon }
	public func removeAfterDuration(duration: Double) { layer.removeAfterDuration(duration) }
	public func fadeOutAndRemoveAfterDuration(duration: Double) { layer.fadeOutAndRemoveAfterDuration(duration) }

    // MARK: Touches and gestures

    public var userInteractionEnabled: Bool {
        get { return layer.userInteractionEnabled }
        set { layer.userInteractionEnabled = newValue }
    }

    private class func bridgeTouchSequenceMapping(mapping: [UITouchID: TouchSequence<UITouchID>], context: JSContext) -> JSValue {
        let output = JSValue(newObjectInContext: context)
        for (_, sequence) in mapping {
			let bridgedSequence = bridgeTouchSequence(sequence, context: context)
            output.setObject(bridgedSequence, forKeyedSubscript: bridgedSequence.id)
        }
        return output
    }

	private class func bridgeTouchSequence(sequence: TouchSequence<UITouchID>, context: JSContext) -> TouchSequenceBridge {
        let bridgedID = JSValue(object: sequence.id.description, inContext: context)!
        let jsValueIDedSequence = TouchSequence(samples: sequence.samples, id: bridgedID)
        let bridge = TouchSequenceBridge(jsValueIDedSequence)
        return bridge
    }

    public var activeTouchSequences: JSValue {
        return LayerBridge.bridgeTouchSequenceMapping(layer.activeTouchSequences, context: JSContext.currentContext())
    }

	// JavaScript "hashes" are actually just objects, and they don't have a convenient "length" method, so:
	public var numberOfActiveTouches: Int32 {
		return Int32(layer.activeTouchSequences.count)
	}

    public var gestures: [GestureBridgeType] {
        get {
            return layer.gestures.map { gesture in
                gestureBridgeForGesture(gesture)
            }
        }
        set {
            layer.gestures = newValue.map { gestureBridge in
                gestureForGestureBridge(gestureBridge)
            }
        }
    }
    
    public var behaviors: [BehaviorBridgeType] {
        get {
            return layer.behaviors.map(behaviorBridgeForBehavior)
        }

        set {
            layer.behaviors = newValue.map(behaviorForBehaviorBridge)
        }
    }

    public var touchesBeganHandler: JSValue? {
        get {
            if let handler = layer.touchesBeganHandler {
    			return JSValue(object: unsafeBitCast(handler, AnyObject.self), inContext: JSContext.currentContext())
            } else {
                return nil
            }
		}
        set {
            if let callable = newValue {
                layer.touchesBeganHandler = { [context = JSContext.currentContext()] sequenceMapping in
                    return callable.callWithArguments([LayerBridge.bridgeTouchSequenceMapping(sequenceMapping, context: context)]).toBool()
                }
            } else {
                layer.touchesBeganHandler = nil
            }
        }
    }

    public var touchesMovedHandler: JSValue? {
        get {
            if let handler = layer.touchesMovedHandler {
                return JSValue(object: unsafeBitCast(handler, AnyObject.self), inContext: JSContext.currentContext())
            } else {
                return nil
            }
        }
        set {
            if let callable = newValue {
                layer.touchesMovedHandler = { [context = JSContext.currentContext()] sequenceMapping in
                    return callable.callWithArguments([LayerBridge.bridgeTouchSequenceMapping(sequenceMapping, context: context)]).toBool()
                }
            } else {
                layer.touchesMovedHandler = nil
            }
        }
    }

    public var touchesEndedHandler: JSValue? {
        get {
            if let handler = layer.touchesEndedHandler {
                return JSValue(object: unsafeBitCast(handler, AnyObject.self), inContext: JSContext.currentContext())
            } else {
                return nil
            }
        }
        set {
            if let callable = newValue {
                layer.touchesEndedHandler = { [context = JSContext.currentContext()] sequenceMapping in
                    return callable.callWithArguments([LayerBridge.bridgeTouchSequenceMapping(sequenceMapping, context: context)]).toBool()
                }
            } else {
                layer.touchesEndedHandler = nil
            }
        }
    }

    public var touchesCancelledHandler: JSValue? {
        get {
            if let handler = layer.touchesCancelledHandler {
                return JSValue(object: unsafeBitCast(handler, AnyObject.self), inContext: JSContext.currentContext())
            } else {
                return nil
            }
        }
        set {
            if let callable = newValue {
                layer.touchesCancelledHandler = { [context = JSContext.currentContext()] sequenceMapping in
                    return callable.callWithArguments([LayerBridge.bridgeTouchSequenceMapping(sequenceMapping, context: context)]).toBool()
                }
            } else {
                layer.touchesCancelledHandler = nil
            }
        }
    }

    public var touchBeganHandler: JSValue? {
        get {
            if let handler = layer.touchBeganHandler {
                return JSValue(object: unsafeBitCast(handler, AnyObject.self), inContext: JSContext.currentContext())
            } else {
                return nil
            }
        }
        set {
            if let callable = newValue {
                layer.touchBeganHandler = { [context = JSContext.currentContext()] sequence in
                    callable.callWithArguments([LayerBridge.bridgeTouchSequence(sequence, context: context)])
                    return
                }
            } else {
                layer.touchBeganHandler = nil
            }
        }
    }

    public var touchMovedHandler: JSValue? {
        get {
            if let handler = layer.touchMovedHandler {
                return JSValue(object: unsafeBitCast(handler, AnyObject.self), inContext: JSContext.currentContext())
            } else {
                return nil
            }
        }
        set {
            if let callable = newValue {
                layer.touchMovedHandler = { [context = JSContext.currentContext()] sequence in
                    callable.callWithArguments([LayerBridge.bridgeTouchSequence(sequence, context: context)])
                    return
                }
            } else {
                layer.touchMovedHandler = nil
            }
        }
    }

    public var touchEndedHandler: JSValue? {
        get {
            if let handler = layer.touchEndedHandler {
                return JSValue(object: unsafeBitCast(handler, AnyObject.self), inContext: JSContext.currentContext())
            } else {
                return nil
            }
        }
        set {
            if let callable = newValue {
                layer.touchEndedHandler = { [context = JSContext.currentContext()] sequence in
                    callable.callWithArguments([LayerBridge.bridgeTouchSequence(sequence, context: context)])
                    return
                }
            } else {
                layer.touchEndedHandler = nil
            }
        }
    }

    public var touchCancelledHandler: JSValue? {
        get {
            if let handler = layer.touchCancelledHandler {
                return JSValue(object: unsafeBitCast(handler, AnyObject.self), inContext: JSContext.currentContext())
            } else {
                return nil
            }
        }
        set {
            if let callable = newValue {
                layer.touchCancelledHandler = { [context = JSContext.currentContext()] sequence in
                    callable.callWithArguments([LayerBridge.bridgeTouchSequence(sequence, context: context)])
                    return
                }
            } else {
                layer.touchCancelledHandler = nil
            }
        }
    }

    public var touchedDescendents: [LayerJSExport] {
        return layer.touchedDescendents.map { LayerBridge($0)! }
    }

    // MARK: Animations

    public var animators: LayerAnimatorStoreJSExport {
        return LayerAnimatorStoreBridge(layer.animators)
    }
	
	
	// MARK: Particle emitters
	
	public func addParticleEmitter(emitterBridge: ParticleEmitterJSExport) {
		layer.addParticleEmitter(emitterBridge.emitterBridge.emitter)
	}
	
	
	public func removeParticleEmitter(emitterBridge: ParticleEmitterJSExport) {
		layer.removeParticleEmitter(emitterBridge.emitterBridge.emitter)
	}
	
	
	// MARK: Layer layout

	
	/** The minX of the layer's frame. */
	public var originX: Double {
	    get { return self.layer.originX }
	    set { self.layer.originX = newValue }
	}
	
	
	/** The maxX of the layer's frame. */
	public var frameMaxX: Double { return self.layer.frameMaxX }
	
	
	/** The minY of the layer's frame. */
	public var originY: Double {
	    get { return self.layer.originY }
	    set { self.layer.originY = newValue }
	}
	
	
	/** The maxY of the layer's frame. */
	public var frameMaxY: Double { return self.layer.frameMaxY }
	
	
	/** Moves the receiver to the right of the given sibling layer. */
	public func moveToRightOfSiblingLayer(args: JSValue) {
		let (layer, margin) = layerAndMarginFromArgs(args)
		self.layer.moveToRightOfSiblingLayer(layer, margin: margin)
	}
	
	
	/** Moves the receiver to the left of the given sibling layer. */
	public func moveToLeftOfSiblingLayer(args: JSValue) {
		let (layer, margin) = layerAndMarginFromArgs(args)
		
		self.layer.moveToLeftOfSiblingLayer(layer, margin: margin)
	}
	
	
	/** Moves the receiver vertically below the given sibling layer. Does not horizontally align automatically. */
	public func moveBelowSiblingLayer(args: JSValue) {
		let (layer, margin) = layerAndMarginFromArgs(args)
	    self.layer.moveBelowSiblingLayer(layer, margin: margin)
	}
	
	
	/** Moves the receiver vertically above the given sibling layer. Does not horizontally align automatically. */
	public func moveAboveSiblingLayer(args: JSValue) {
		let (layer, margin) = layerAndMarginFromArgs(args)
	    self.layer.moveAboveSiblingLayer(layer, margin: margin)
	}
	
	
	/** Moves the receiver so that its right side is aligned with the right side of its parent layer. */
	public func moveToRightSideOfParentLayer(margin: Double) {
	    self.layer.moveToRightSideOfParentLayer(margin: margin)
	}
	
	
	/** Moves the receiver so that its left side is aligned with the left side of its parent layer. */
	public func moveToLeftSideOfParentLayer(margin: Double) {
		self.layer.moveToLeftSideOfParentLayer(margin: margin)
	}
	
	
	/** Moves the receiver so that its top side is aligned with the top side of its parent layer. */
	public func moveToTopSideOfParentLayer(margin: Double) {
		self.layer.moveToTopSideOfParentLayer(margin: margin)
	}
	
	
	/** Moves the receiver so that its bottom side is aligned with the bottom side of its parent layer. */
	public func moveToBottomSideOfParentLayer(margin: Double) {
		self.layer.moveToBottomSideOfParentLayer(margin: margin)
	}
	
	
	/** Moves the receiver to be vertically centred in its parent. */
	public func moveToVerticalCenterOfParentLayer() {
	    self.layer.moveToVerticalCenterOfParentLayer()
	}
	
	
	/** Moves the receiver to be horizontally centred in its parent. */
	public func moveToHorizontalCenterOfParentLayer() {
		self.layer.moveToHorizontalCenterOfParentLayer()
	}
	
	
	/** Moves the receiver to be centered in its parent. */
	public func moveToCenterOfParentLayer() {
	    self.layer.moveToCenterOfParentLayer()
	}
	
	
	private func layerAndMarginFromArgs(args: JSValue) -> (layer: Layer, margin: Double) {
		let siblingLayer = args.objectForKeyedSubscript("siblingLayer").toObject() as! LayerBridge
		
		var margin: Double = 0
		if let jsMargin = args.objectForKeyedSubscript("margin") {
			margin = jsMargin.toDouble()
			if margin.isNaN {
				margin = 0
			}
		}
		
		return (siblingLayer.layer, margin)
	}

}
