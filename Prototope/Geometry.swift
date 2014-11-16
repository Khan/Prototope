//
//  Geometry.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/7/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import CoreGraphics

// Mark: Point

public struct Point {
	public var x: Double
	public var y: Double

	public init(x: Double = 0, y: Double = 0) {
		self.x = x
		self.y = y
	}

	public init(_ point: CGPoint) {
		self.x = Double(point.x)
		self.y = Double(point.y)
	}

	public func distanceToPoint(point: Point) -> Double {
		let dx = point.x - self.x
		let dy = point.y - self.y
		return sqrt(dx*dx + dy*dy)
	}
}

extension Point: Printable {
	public var description: String {
		return "{x: \(x), y: \(y)}"
	}
}

public func +(a: Point, b: Point) -> Point {
	return Point(x: a.x + b.x, y: a.y + b.y)
}

public func -(a: Point, b: Point) -> Point {
	return Point(x: a.x - b.x, y: a.y - b.y)
}

public func *(a: Point, scalar: Double) -> Point {
	return Point(x: a.x * scalar, y: a.y * scalar)
}

public func /(a: Point, scalar: Double) -> Point {
	return a * (1.0 / scalar)
}

extension CGPoint {
	public init(_ point: Point) {
		self.x = CGFloat(point.x)
		self.y = CGFloat(point.y)
	}
}

// MARK: Size

public struct Size {
	public var width: Double
	public var height: Double

	public init(width: Double = 0, height: Double = 0) {
		self.width = width
		self.height = height
	}

	public init(_ size: CGSize) {
		self.width = Double(size.width)
		self.height = Double(size.height)
	}
}

public func *(a: Size, scalar: Double) -> Size {
	return Size(width: a.width * scalar, height: a.height * scalar)
}

extension CGSize {
	public init(_ size: Size) {
		self.width = CGFloat(size.width)
		self.height = CGFloat(size.height)
	}
}

// MARK: Rect

public struct Rect {
	public var origin: Point
	public var size: Size

	public init(x: Double = 0, y: Double = 0, width: Double = 0, height: Double = 0) {
		origin = Point(x: x, y: y)
		size = Size(width: width, height: height)
	}

	public init(_ rect: CGRect) {
		origin = Point(rect.origin)
		size = Size(rect.size)
	}

	// TODO: .midX, .minY, etc.
}

extension CGRect {
	public init(_ rect: Rect) {
		self.origin = CGPoint(rect.origin)
		self.size = CGSize(rect.size)
	}
}
