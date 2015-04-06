//
//  GeometryBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/2/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import JavaScriptCore
import Prototope

// MARK: Point

@objc public protocol PointJSExport: JSExport {
	// TODO make these writable, add observers to the bridges which vend them
	var x: Double { get }
	var y: Double { get }
	static var zero: PointJSExport { get } // exported manually
	init(args: NSDictionary) 
	func distanceToPoint(point: PointJSExport) -> Double
	func slopeToPoint(point: PointJSExport) -> Double
	var length: Double { get }

	func equals(point: PointJSExport) -> Bool
	func add(point: PointJSExport) -> PointJSExport
	func subtract(point: PointJSExport) -> PointJSExport
	func multiply(scalar: Double) -> PointJSExport
	func divide(scalar: Double) -> PointJSExport
}

@objc public class PointBridge: NSObject, PointJSExport, BridgeType {
	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Point")
		let pointBridge = context.objectForKeyedSubscript("Point")
		pointBridge.setObject(zero, forKeyedSubscript: "zero")
	}

	var point: Prototope.Point
	public required init(args: NSDictionary) {
		point = Point(
			x: (args["x"] as! Double?) ?? 0,
			y: (args["y"] as! Double?) ?? 0
		)
		super.init()
	}

	init(_ point: Prototope.Point) {
		self.point = point
		super.init()
	}

	public var x: Double { return point.x }
	public var y: Double { return point.y }

	public class var zero: PointJSExport { return PointBridge(Prototope.Point.zero) }

	public func distanceToPoint(other: PointJSExport) -> Double {
		return point.distanceToPoint((other as JSExport as! PointBridge).point)
	}
	
	
	public func slopeToPoint(point: PointJSExport) -> Double {
		return self.point.slopeToPoint((point as JSExport as! PointBridge).point) ?? 0.0
	}

	public var length: Double { return point.length }

	public func equals(other: PointJSExport) -> Bool {
		return point == (other as JSExport as! PointBridge).point
	}

	public func add(other: PointJSExport) -> PointJSExport {
		return PointBridge(point + (other as JSExport as! PointBridge).point)
	}

	public func subtract(other: PointJSExport) -> PointJSExport {
		return PointBridge(point - (other as JSExport as! PointBridge).point)
	}

	public func multiply(scalar: Double) -> PointJSExport {
		return PointBridge(point * scalar)
	}

	public func divide(scalar: Double) -> PointJSExport {
		return PointBridge(point / scalar)
	}
}

// MARK: Size

@objc public protocol SizeJSExport: JSExport {
	var width: Double { get }
	var height: Double { get }
	static var zero: SizeJSExport { get } // exported manually
	init(args: NSDictionary)

	func equals(other: SizeJSExport) -> Bool
	func add(other: SizeJSExport) -> SizeJSExport
	func multiply(scalar: Double) -> SizeJSExport
}

@objc public class SizeBridge: NSObject, SizeJSExport, BridgeType {
	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Size")
		let sizeBridge = context.objectForKeyedSubscript("Size")
		sizeBridge.setObject(zero, forKeyedSubscript: "zero")
	}

	public class var zero: SizeJSExport { return SizeBridge(Prototope.Size.zero) }

	var size: Prototope.Size
	public required init(args: NSDictionary) {
		size = Prototope.Size(
			width: (args["width"] as! Double?) ?? 0,
			height: (args["height"] as! Double?) ?? 0
		)
		super.init()
	}

	init(_ size: Prototope.Size) {
		self.size = size
		super.init()
	}

	public var width: Double { return size.width }
	public var height: Double { return size.height }

	public func equals(other: SizeJSExport) -> Bool {
		return size == (other as JSExport as! SizeBridge).size
	}

	public func add(other: SizeJSExport) -> SizeJSExport {
		return SizeBridge(size + (other as JSExport as! SizeBridge).size)
	}

	public func multiply(scalar: Double) -> SizeJSExport {
		return SizeBridge(size * scalar)
	}
}

// MARK: Rect

@objc public protocol RectJSExport: JSExport {
	var origin: PointJSExport { get }
	var size: SizeJSExport { get }
	var minX: Double { get }
	var midX: Double { get }
	var maxX: Double { get }
	var minY: Double { get }
	var midY: Double { get }
	var maxY: Double { get }
	var center: PointJSExport { get }
	static var zero: RectJSExport { get }
	init(args: NSDictionary)
    func inset(args: NSDictionary) -> RectJSExport
}

@objc public class RectBridge: NSObject, RectJSExport, BridgeType {
	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Rect")
		let rectBridge = context.objectForKeyedSubscript("Rect")
		rectBridge.setObject(zero, forKeyedSubscript: "zero")
	}

	public class var zero: RectJSExport { return RectBridge(Rect.zero) }

	var rect: Prototope.Rect
	public required init(args: NSDictionary) {
		rect = Rect(
			x: (args["x"] as! Double?) ?? 0,
			y: (args["y"] as! Double?) ?? 0,
			width: (args["width"] as! Double?) ?? 0,
			height: (args["height"] as! Double?) ?? 0
		)
		super.init()
	}

	init(_ rect: Prototope.Rect) {
		self.rect = rect
		super.init()
	}
    
    public func inset(args: NSDictionary) -> RectJSExport {
        let hasKey = { (key: String) -> Bool in
            return (args.objectForKey(key) as? Double) != nil
        }
        let getValue = { (key: String) -> Double in
            return (args.objectForKey(key) as! Double?) ?? 0
        }
        
        let justValue = hasKey("value")
        let simplified = hasKey("vertical") || hasKey("horizontal")
        let core = hasKey("top") || hasKey("right") || hasKey("bottom") || hasKey("left")
        
        // This switch statement guarantees that only one of the three possible sets
        // of arguments was passed in.
        switch (justValue, simplified, core) {
        case (true, false, false): // "value"
            return RectBridge(rect.inset(value: getValue("value")))
        case (false, true, false): // "vertical", "horizontal"
            return RectBridge(rect.inset(vertical: getValue("vertical"), horizontal: getValue("horizontal")))
        case (false, false, true): // "top", "right", "bottom" "left"
            return RectBridge(rect.inset(top: getValue("top"), right: getValue("right"), bottom: getValue("bottom"), left: getValue("left")))
        default:
            Environment.currentEnvironment?.exceptionHandler("Trying to call inset on with invalid parameters: \(args)")
            return self
        }
    }

	public var origin: PointJSExport { return PointBridge(rect.origin) }
	public var size: SizeJSExport { return SizeBridge(rect.size) }
	public var minX: Double { return rect.minX }
	public var midX: Double { return rect.midX }
	public var maxX: Double { return rect.maxX }
	public var minY: Double { return rect.minY }
	public var midY: Double { return rect.midY }
	public var maxY: Double { return rect.maxY }
	public var center: PointJSExport { return PointBridge(rect.center) }
}
