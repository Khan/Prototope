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
    
    // MARK: Creating and identifying layers

    // TODO: what to do with the imageName Layer initializer?
	init(parent: LayerJSExport? /* JSC crashes if I write LayerBridge here */, name: String?)
    var name: String? { get }
    
    // MARK: Layer hierarchy access and manipulation
    
    var parent: LayerBridge? { get set }
    var sublayers: [LayerBridge] { get}
    func removeAllSublayers()
    var sublayerAtFront: LayerBridge? { get }
    func sublayerNamed(name: String) -> LayerBridge?
    func descendentNamed(name: String) -> LayerBridge?
    func descendentAtPath(pathElements: [String]) -> LayerBridge?
    func ancestorNamed(name: String) -> LayerBridge?
    
    // MARK: Geometry
    
    var x: Double { get set }
    var y: Double { get set }
    var position: CGPoint { get set }
    var width: Double { get set }
    var height: Double { get set }
    var size: CGSize { get set }
    var frame: CGRect { get set }
    var bounds: CGRect { get set }
    var anchorPoint: CGPoint { get set }
    var rotationDegrees: Double { get set }
    var rotationRadians: Double { get set }
    var scale: Double { get set }
    var scaleX: Double { get set }
    var scaleY: Double { get set }
    var globalPosition: CGPoint { get set }
    func containsGlobalPoint(point: CGPoint) -> Bool
    func convertGlobalPointToLocalPoint(globalPoint: CGPoint) -> CGPoint
    func convertLocalPointToGlobalPoint(localPoint: CGPoint) -> CGPoint
}

@objc public class LayerBridge: NSObject, LayerJSExport, Printable {
	public var layer: Layer!

	public class var root: LayerBridge {
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

	required public init(parent: LayerJSExport?, name: String?) {
		layer = Layer(parent: (parent as LayerBridge).layer, name: name)
		layer.backgroundColor = Color.green
		super.init()
	}
    
    public var name: String? {
        get { return layer.name }
    }
    
    // MARK: Layer hierarchy access and manipulation

    public var parent: LayerBridge? {
        get { return layer.parent != nil ? LayerBridge(wrappingLayer: layer.parent!) : nil }
        set { layer.parent = newValue?.layer }
    }
    
    public var sublayers: [LayerBridge] {
        return layer.sublayers.map { LayerBridge(wrappingLayer: $0)! }
    }
    
    public func removeAllSublayers() { layer.removeAllSublayers() }
    
    public var sublayerAtFront: LayerBridge? { return LayerBridge(wrappingLayer: layer.sublayerAtFront) }
    
    public func sublayerNamed(name: String) -> LayerBridge? { return LayerBridge(wrappingLayer: layer.sublayerNamed(name)) }
    
    public func descendentNamed(name: String) -> LayerBridge? { return LayerBridge(wrappingLayer: layer.descendentNamed(name)) }
    
    public func descendentAtPath(pathElements: [String]) -> LayerBridge? { return LayerBridge(wrappingLayer: layer.descendentAtPath(pathElements)) }
    
    public func ancestorNamed(name: String) -> LayerBridge? { return LayerBridge(wrappingLayer: layer.ancestorNamed(name)) }
    
    // MARK: Geometry

    public var x: Double {
    get { return layer.x }
    set { layer.x = newValue }
    }

    public var y: Double {
    get { return layer.y }
    set { layer.y = newValue }
    }
    
    public var position: CGPoint {
    get { return CGPoint(layer.position) }
    set { layer.position = Point(newValue) }
    }

    public var width: Double {
    get { return layer.width }
    set { layer.width = newValue }
    }
    
    public var height: Double {
    get { return layer.height }
    set { layer.height = newValue }
    }

    public var size: CGSize {
    get { return CGSize(layer.size) }
    set { layer.size = Size(newValue) }
    }
    
    public var frame: CGRect {
    get { return CGRect(layer.frame) }
    set { layer.frame = Rect(newValue) }
    }
    
    public var bounds: CGRect {
    get { return CGRect(layer.bounds) }
    set { layer.bounds = Rect(newValue) }
    }
    
    public var anchorPoint: CGPoint {
    get { return CGPoint(layer.anchorPoint) }
    set { layer.anchorPoint = Point(newValue) }
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

    public var globalPosition: CGPoint {
    get { return CGPoint(layer.globalPosition) }
    set { layer.globalPosition = Point(newValue) }
    }
    
    public func containsGlobalPoint(point: CGPoint) -> Bool { return layer.containsGlobalPoint(Point(point)) }
    public func convertGlobalPointToLocalPoint(globalPoint: CGPoint) -> CGPoint { return CGPoint(layer.convertGlobalPointToLocalPoint(Point(globalPoint))) }
    public func convertLocalPointToGlobalPoint(localPoint: CGPoint) -> CGPoint { return CGPoint(layer.convertLocalPointToGlobalPoint(Point(localPoint))) }
    

}
