//
//  ShapeLayerBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 4/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol ShapeLayerJSExport: JSExport {
    init?(args: NSDictionary)
    var segments: [SegmentJSExport] { get set }
    var firstSegment: SegmentJSExport? { get }
    var lastSegment: SegmentJSExport? { get }
    func addPoint(point: PointJSExport)
	func enclosesPoint(point: PointJSExport) -> Bool
	
    var fillColor: ColorJSExport? { get set }
    var strokeColor: ColorJSExport? { get set }
    var strokeWidth: Double { get set }
    var closed: Bool { get set }
    var lineCapStyle: JSValue { get set }
    var lineJoinStyle: JSValue { get set }
}

@objc public class ShapeLayerBridge: LayerBridge, ShapeLayerJSExport, BridgeType {
    var shapeLayer: ShapeLayer { return layer as! ShapeLayer }
    
    public override class func addToContext(context: JSContext) {
        let bridgedShapeLayer = JSValue(object: self, inContext: context)
        bridgedShapeLayer.setObject(ShapeLayerCircleBridge.self, forKeyedSubscript: "Circle")
        bridgedShapeLayer.setObject(ShapeLayerOvalBridge.self, forKeyedSubscript: "Oval")
        bridgedShapeLayer.setObject(ShapeLayerRectangleBridge.self, forKeyedSubscript: "Rectangle")
        bridgedShapeLayer.setObject(ShapeLayerLineBridge.self, forKeyedSubscript: "Line")
        bridgedShapeLayer.setObject(ShapeLayerPolygonBridge.self, forKeyedSubscript: "Polygon")
        context.setObject(bridgedShapeLayer, forKeyedSubscript: "ShapeLayer")
    }
    
    public required init?(args: NSDictionary) {
        let parentLayer = (args["parent"] as? LayerBridge)?.layer
        let name = args["name"] as? String
        let segments = ((args["segments"] as? [SegmentBridge]) ?? []).map { $0.segment! }
        let closed = (args["closed"] as? Bool) ?? false
        super.init(ShapeLayer(segments: segments, closed: closed, parent: parentLayer, name: name))
    }
    
    init?(_ wrappingLayer: ShapeLayer?) {
        super.init(wrappingLayer)
    }
    
    public var segments: [SegmentJSExport] {
        get { return shapeLayer.segments.map { SegmentBridge($0) } }
        set { shapeLayer.segments = newValue.map { ($0 as! SegmentBridge).segment } }
    }
    
    public var firstSegment: SegmentJSExport? {
        return shapeLayer.firstSegment != nil ? SegmentBridge(shapeLayer.firstSegment!) : nil
    }
    
    public var lastSegment: SegmentJSExport? {
        return shapeLayer.lastSegment != nil ? SegmentBridge(shapeLayer.lastSegment!) : nil
    }
    
    public func addPoint(point: PointJSExport) {
        shapeLayer.addPoint((point as! PointBridge).point)
    }
	
	
	/** Returns if the the given point is enclosed within the shape. If the shape is not closed, this always returns `false`. */
	public func enclosesPoint(point: PointJSExport) -> Bool {
		return shapeLayer.enclosesPoint((point as! PointBridge).point)
	}
    
    public var fillColor: ColorJSExport? {
        get { return shapeLayer.fillColor != nil ? ColorBridge(shapeLayer.fillColor!) : nil }
        set { shapeLayer.fillColor = (newValue as! ColorBridge?)?.color }
    }

    public var strokeColor: ColorJSExport? {
        get { return shapeLayer.strokeColor != nil ? ColorBridge(shapeLayer.strokeColor!) : nil }
        set { shapeLayer.strokeColor = (newValue as! ColorBridge?)?.color }
    }
    
    public var strokeWidth: Double {
        get { return shapeLayer.strokeWidth }
        set { shapeLayer.strokeWidth = newValue }
    }
    
    public var closed: Bool {
        get { return shapeLayer.closed }
        set { shapeLayer.closed = newValue }
    }
    
    public var lineCapStyle: JSValue {
        get { return LineCapStyleBridge.encodeLineCapStyle(shapeLayer.lineCapStyle, inContext: JSContext.currentContext()) }
        set { shapeLayer.lineCapStyle = LineCapStyleBridge.decodeLineCapStyle(newValue) }
    }

    public var lineJoinStyle: JSValue {
        get { return LineJoinStyleBridge.encodeLineJoinStyle(shapeLayer.lineJoinStyle, inContext: JSContext.currentContext()) }
        set { shapeLayer.lineJoinStyle = LineJoinStyleBridge.decodeLineJoinStyle(newValue) }
    }
}


// MARK: - Convenience constructors

// We want prototypers to be able to say "new ShapeLayer.Circle({center: pt, radius: r})". These stub classes exist only to have bridged constructors.

@objc public protocol ShapeLayerConvenienceConstructorJSExport: JSExport {
    init?(args: NSDictionary)
}

@objc public class ShapeLayerCircleBridge: ShapeLayerBridge, ShapeLayerConvenienceConstructorJSExport {
    public required init?(args: NSDictionary) {
        let parentLayer = (args["parent"] as? LayerBridge)?.layer
        let name = args["name"] as? String
        let center = (args["center"] as? PointBridge)?.point
        let radius = args["radius"] as? Double
        if let center = center, let radius = radius {
            super.init(ShapeLayer(circleCenter: center, radius: radius, parent: parentLayer, name: name))
        } else {
            Environment.currentEnvironment!.exceptionHandler("ShapeLayer.Circle missing center or radius")
            super.init(args: [:])
            return nil
        }
    }
}

@objc public class ShapeLayerOvalBridge: ShapeLayerBridge, ShapeLayerConvenienceConstructorJSExport {
    public required init?(args: NSDictionary) {
        let parentLayer = (args["parent"] as? LayerBridge)?.layer
        let name = args["name"] as? String
        let rectangle = (args["rectangle"] as? RectBridge)?.rect
        if let rectangle = rectangle {
            super.init(ShapeLayer(ovalInRectangle: rectangle, parent: parentLayer, name: name))
        } else {
            Environment.currentEnvironment!.exceptionHandler("ShapeLayer.Oval missing rectangle")
            super.init(args: [:])
            return nil
        }
    }
}

@objc public class ShapeLayerRectangleBridge: ShapeLayerBridge, ShapeLayerConvenienceConstructorJSExport {
    public required init?(args: NSDictionary) {
        let parentLayer = (args["parent"] as? LayerBridge)?.layer
        let name = args["name"] as? String
        let rectangle = (args["rectangle"] as? RectBridge)?.rect
        let cornerRadius = (args["cornerRadius"] as? Double) ?? 0
        if let rectangle = rectangle {
            super.init(ShapeLayer(rectangle: rectangle, cornerRadius: cornerRadius, parent: parentLayer, name: name))
        } else {
            Environment.currentEnvironment!.exceptionHandler("ShapeLayer.Rectangle missing rectangle")
            super.init(args: [:])
            return nil
        }
    }
}

@objc public class ShapeLayerLineBridge: ShapeLayerBridge, ShapeLayerConvenienceConstructorJSExport {
    public required init?(args: NSDictionary) {
        let parentLayer = (args["parent"] as? LayerBridge)?.layer
        let name = args["name"] as? String
        let from = (args["from"] as? PointBridge)?.point
        let to = (args["to"] as? PointBridge)?.point
        if let from = from, let to = to {
            super.init(ShapeLayer(lineFromFirstPoint: from, toSecondPoint: to, parent: parentLayer, name: name))
        } else {
            Environment.currentEnvironment!.exceptionHandler("ShapeLayer.Line missing from or to")
            super.init(args: [:])
            return nil
        }
    }
}

@objc public class ShapeLayerPolygonBridge: ShapeLayerBridge, ShapeLayerConvenienceConstructorJSExport {
    public required init?(args: NSDictionary) {
        let parentLayer = (args["parent"] as? LayerBridge)?.layer
        let name = args["name"] as? String
        let center = (args["center"] as? PointBridge)?.point
        let radius = args["radius"] as? Double
        let numberOfSides = args["numberOfSides"] as? Double
        if let center = center, let radius = radius, let numberOfSides = numberOfSides {
            super.init(ShapeLayer(polygonCenteredAtPoint: center, radius: radius, numberOfSides: Int(numberOfSides), parent: parentLayer, name: name))
        } else {
            Environment.currentEnvironment!.exceptionHandler("ShapeLayer.Line missing center, radius, or numberOfSides")
            super.init(args: [:])
            return nil
        }
    }
}


//============================================================================
// MARK: - Segment

@objc public protocol SegmentJSExport: JSExport {
    init?(args: JSValue)
    var point: PointJSExport { get set }
    var handleIn: PointJSExport? { get set }
    var handleOut: PointJSExport? { get set }
}

@objc public class SegmentBridge: NSObject, SegmentJSExport, BridgeType {
    var segment: Segment!
    
    public static func addToContext(context: JSContext) {
        context.setObject(self, forKeyedSubscript: "Segment")
    }
    
    required public init?(args: JSValue) {
        var segment = Segment(point: Point.zero)
        if let pointBridge = args.toObjectOfClass(PointBridge.self) as! PointBridge? {
            segment.point = pointBridge.point
        } else if let pointBridge = args.objectForKeyedSubscript("point").toObjectOfClass(PointBridge.self) as! PointBridge? {
            segment.point = pointBridge.point
            segment.handleIn = (args.objectForKeyedSubscript("handleIn").toObjectOfClass(PointBridge.self) as! PointBridge?)?.point
            segment.handleOut = (args.objectForKeyedSubscript("handleOut").toObjectOfClass(PointBridge.self) as! PointBridge?)?.point
        } else {
            Environment.currentEnvironment!.exceptionHandler("Segment cannot be initialized without a point")
            super.init()
            return nil
        }
        
        self.segment = segment
        super.init()
    }
    
    init(_ segment: Segment) {
        self.segment = segment
    }
    
    public var point: PointJSExport {
        get { return PointBridge(segment.point) }
        set { segment.point = (newValue as! PointBridge).point }
    }
    
    public var handleIn: PointJSExport? {
        get { return segment.handleIn != nil ? PointBridge(segment.handleIn!) : nil }
        set { segment.handleIn = (newValue as! PointBridge).point }
    }

    public var handleOut: PointJSExport? {
        get { return segment.handleOut != nil ? PointBridge(segment.handleOut!) : nil }
        set { segment.handleOut = (newValue as! PointBridge).point }
    }
}

// MARK: - Enums

public class LineCapStyleBridge: NSObject, BridgeType {
    enum RawLineCapStyle: Int {
        case Butt = 0
        case Round = 1
        case Square = 2
    }
    
    public class func addToContext(context: JSContext) {
        let lineCapStyleObject = JSValue(newObjectInContext: context)
        lineCapStyleObject.setObject(RawLineCapStyle.Butt.rawValue, forKeyedSubscript: "Butt")
        lineCapStyleObject.setObject(RawLineCapStyle.Round.rawValue, forKeyedSubscript: "Round")
        lineCapStyleObject.setObject(RawLineCapStyle.Square.rawValue, forKeyedSubscript: "Square")
        context.setObject(lineCapStyleObject, forKeyedSubscript: "LineCapStyle")
    }
    
    public class func encodeLineCapStyle(lineCapStyle: Prototope.ShapeLayer.LineCapStyle, inContext context: JSContext) -> JSValue {
        var rawLineCapStyle: RawLineCapStyle
        switch lineCapStyle {
        case .Butt: rawLineCapStyle = .Butt
        case .Round: rawLineCapStyle = .Round
        case .Square: rawLineCapStyle = .Square
        }
        return JSValue(int32: Int32(rawLineCapStyle.rawValue), inContext: context)
    }
    
    public class func decodeLineCapStyle(bridgedLineCapStyle: JSValue) -> Prototope.ShapeLayer.LineCapStyle! {
        if let rawLineCapStyle = RawLineCapStyle(rawValue: Int(bridgedLineCapStyle.toInt32())) {
            switch rawLineCapStyle {
            case .Butt: return .Butt
            case .Round: return .Round
            case .Square: return .Square
            }
        } else {
            Environment.currentEnvironment!.exceptionHandler("Unknown line cap style: \(bridgedLineCapStyle)")
            return nil
        }
    }
}

public class LineJoinStyleBridge: NSObject, BridgeType {
    enum RawLineJoinStyle: Int {
        case Miter = 0
        case Round = 1
        case Bevel = 2
    }
    
    public class func addToContext(context: JSContext) {
        let lineJoinStyleObject = JSValue(newObjectInContext: context)
        lineJoinStyleObject.setObject(RawLineJoinStyle.Miter.rawValue, forKeyedSubscript: "Miter")
        lineJoinStyleObject.setObject(RawLineJoinStyle.Round.rawValue, forKeyedSubscript: "Round")
        lineJoinStyleObject.setObject(RawLineJoinStyle.Bevel.rawValue, forKeyedSubscript: "Bevel")
        context.setObject(lineJoinStyleObject, forKeyedSubscript: "LineJoinStyle")
    }
    
    public class func encodeLineJoinStyle(lineJoinStyle: Prototope.ShapeLayer.LineJoinStyle, inContext context: JSContext) -> JSValue {
        var rawLineJoinStyle: RawLineJoinStyle
        switch lineJoinStyle {
        case .Miter: rawLineJoinStyle = .Miter
        case .Round: rawLineJoinStyle = .Round
        case .Bevel: rawLineJoinStyle = .Bevel
        }
        return JSValue(int32: Int32(rawLineJoinStyle.rawValue), inContext: context)
    }
    
    public class func decodeLineJoinStyle(bridgedLineJoinStyle: JSValue) -> Prototope.ShapeLayer.LineJoinStyle! {
        if let rawLineJoinStyle = RawLineJoinStyle(rawValue: Int(bridgedLineJoinStyle.toInt32())) {
            switch rawLineJoinStyle {
            case .Miter: return .Miter
            case .Round: return .Round
            case .Bevel: return .Bevel
            }
        } else {
            Environment.currentEnvironment!.exceptionHandler("Unknown line join style: \(bridgedLineJoinStyle)")
            return nil
        }
    }
}

