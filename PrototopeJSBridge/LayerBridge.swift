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
	class var root: LayerJSExport { get } // Not automatically imported via JSExport.
    
    // MARK: Creating and identifying layers
	init(args: NSDictionary)
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
    var position: PointJSExport { get set }
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

	// MARK: Convenience utilities
	var willBeRemovedSoon: Bool { get }
	func removeAfterDuration(duration: Double)
	func fadeOutAndRemoveAfterDuration(duration: Double)

    // MARK: Touches and gestures
    var userInteractionEnabled: Bool { get set }
    var activeTouchSequences: JSValue { get }
    var touchesBeganHandler: JSValue? { get set }
    var touchesMovedHandler: JSValue? { get set }
    var touchesEndedHandler: JSValue? { get set }
    var touchesCancelledHandler: JSValue? { get set }
    var touchBeganHandler: JSValue? { get set }
    var touchMovedHandler: JSValue? { get set }
    var touchEndedHandler: JSValue? { get set }
    var touchCancelledHandler: JSValue? { get set }
}

@objc public class LayerBridge: NSObject, LayerJSExport, Printable, BridgeType {
    
    public class func addToContext(context: JSContext) {
        context.setObject(LayerBridge.self, forKeyedSubscript: "Layer")
        context.objectForKeyedSubscript("Layer").setObject(LayerBridge.root, forKeyedSubscript: "root")
    }
    
    public var layer: Layer!
    
    public class var root: LayerJSExport {
        return LayerBridge(wrappingLayer: Layer.root)!
    }
    
    private init?(wrappingLayer: Layer?) {
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

    required public init(args: NSDictionary) {
		let parentLayer = (args["parent"] as LayerBridge?)?.layer
		if let imageName = args["imageName"] as String? {
			layer = Layer(parent: parentLayer, imageName: imageName)
		} else {
			layer = Layer(parent: parentLayer, name: (args["name"] as String?))
		}
        super.init()
    }
    
    public var name: String? {
        get { return layer.name }
    }
    
    // MARK: Layer hierarchy access and manipulation
    
    public var parent: LayerJSExport! {
        get { return layer.parent != nil ? LayerBridge(wrappingLayer: layer.parent!) : nil }
        set {
            if let newParent = newValue {
                layer.parent = (newParent as JSExport as LayerBridge).layer
            } else {
                layer.parent = nil
            }
        }
    }
    
    public var sublayers: [LayerJSExport] {
        return layer.sublayers.map { LayerBridge(wrappingLayer: $0)! }
    }
    
    public func removeAllSublayers() { layer.removeAllSublayers() }
    
    public var sublayerAtFront: LayerJSExport? { return LayerBridge(wrappingLayer: layer.sublayerAtFront) }
    
    public func sublayerNamed(name: String) -> LayerJSExport? { return LayerBridge(wrappingLayer: layer.sublayerNamed(name)) }
    
    public func descendentNamed(name: String) -> LayerJSExport? { return LayerBridge(wrappingLayer: layer.descendentNamed(name)) }
    
    public func descendentAtPath(pathElements: [String]) -> LayerJSExport? { return LayerBridge(wrappingLayer: layer.descendentAtPath(pathElements)) }
    
    public func ancestorNamed(name: String) -> LayerJSExport? { return LayerBridge(wrappingLayer: layer.ancestorNamed(name)) }
    
    // MARK: Geometry
    
    public var x: Double {
        get { return layer.x }
        set { layer.x = newValue }
    }
    
    public var y: Double {
        get { return layer.y }
        set { layer.y = newValue }
    }
    
    public var position: PointJSExport {
        get { return PointBridge(layer.position) }
        set { layer.position = (newValue as JSExport as PointBridge).point }
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
        set { layer.size = (newValue as JSExport as SizeBridge).size }
    }
    
    public var frame: RectJSExport {
        get { return RectBridge(layer.frame) }
        set { layer.frame = (newValue as JSExport as RectBridge).rect }
    }
    
    public var bounds: RectJSExport {
        get { return RectBridge(layer.bounds) }
        set { layer.bounds = (newValue as JSExport as RectBridge).rect }
    }
    
    public var anchorPoint: PointJSExport {
        get { return PointBridge(layer.anchorPoint) }
        set { layer.anchorPoint = (newValue as JSExport as PointBridge).point }
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
        set { layer.globalPosition = (newValue as JSExport as PointBridge).point }
    }
    
    public func containsGlobalPoint(point: PointJSExport) -> Bool { return layer.containsGlobalPoint((point as JSExport as PointBridge).point) }
    public func convertGlobalPointToLocalPoint(globalPoint: PointJSExport) -> PointJSExport { return PointBridge(layer.convertGlobalPointToLocalPoint((globalPoint as JSExport as PointBridge).point)) }
    public func convertLocalPointToGlobalPoint(localPoint: PointJSExport) -> PointJSExport { return PointBridge(layer.convertLocalPointToGlobalPoint((localPoint as JSExport as PointBridge).point)) }
    
    // MARK: Appearance
    
    public var backgroundColor: ColorJSExport? {
        get { return layer.backgroundColor != nil ? ColorBridge(layer.backgroundColor!) : nil }
        set { layer.backgroundColor = (newValue as ColorBridge).color }
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
			layer.image = (newValue as JSExport as ImageBridge).image
		}
	}

	public var border: BorderJSExport? {
		get {
			return BorderBridge(layer.border)
		}
		set {
			if let border = border {
				layer.border = (newValue as JSExport as BorderBridge).border
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
				layer.shadow = (newValue as JSExport as ShadowBridge).shadow
			} else {
				layer.shadow = Shadow(color: Color.clear, alpha: 0, offset: Size(width: 0, height: 0), radius: 0)
			}
		}
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
        let bridgedID = JSValue(object: UITouchIDBridge(sequence.id), inContext: context)!
        let jsValueIDedSequence = TouchSequence(samples: sequence.samples, id: bridgedID)
        let bridge = TouchSequenceBridge(jsValueIDedSequence)
        return bridge
    }

    public var activeTouchSequences: JSValue {
        return LayerBridge.bridgeTouchSequenceMapping(layer.activeTouchSequences, context: JSContext.currentContext())
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



}
