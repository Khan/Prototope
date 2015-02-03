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

@objc public protocol PointJSExport: JSExport {
	// TODO make these writable, add observers to the bridges which vend them
	var x: Double { get }
	var y: Double { get }
	init(args: NSDictionary)
	func distanceToPoint(point: PointJSExport) -> Double
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
		pointBridge.setObject(self(args: ["x": 0, "y": 0]), forKeyedSubscript: "zero")
	}

	var point: Prototope.Point
	public required init(args: NSDictionary) {
		point = Point(
			x: (args["x"] as Double?) ?? 0,
			y: (args["x"] as Double?) ?? 0
		)
		super.init()
	}

	init(_ point: Prototope.Point) {
		self.point = point
		super.init()
	}

	public var x: Double { return point.x }
	public var y: Double { return point.y }

	public func distanceToPoint(other: PointJSExport) -> Double {
		return point.distanceToPoint((other as JSExport as PointBridge).point)
	}

	public var length: Double { return point.length }

	public func equals(other: PointJSExport) -> Bool {
		return point == (other as JSExport as PointBridge).point
	}

	public func add(other: PointJSExport) -> PointJSExport {
		return PointBridge(point + (other as JSExport as PointBridge).point)
	}

	public func subtract(other: PointJSExport) -> PointJSExport {
		return PointBridge(point - (other as JSExport as PointBridge).point)
	}

	public func multiply(scalar: Double) -> PointJSExport {
		return PointBridge(point * scalar)
	}

	public func divide(scalar: Double) -> PointJSExport {
		return PointBridge(point / scalar)
	}
}