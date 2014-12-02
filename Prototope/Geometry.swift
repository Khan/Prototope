//
//  Geometry.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/7/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import CoreGraphics

// - MARK: Point

/** Represents a 2D point (or vector). */
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

	/** Computes traditional 2D (i.e. Euclidean) distance to another point. */
	public func distanceToPoint(point: Point) -> Double {
		let dx = point.x - self.x
		let dy = point.y - self.y
		return sqrt(dx*dx + dy*dy)
	}

	/** Computes the magnitude of the point, interpreted as a vector. */
	public var length: Double {
		return sqrt(x*x + y*y)
	}
}

extension Point: Printable {
	public var description: String {
		return "{x: \(x), y: \(y)}"
	}
}

/** Performs vector addition. */
public func +(a: Point, b: Point) -> Point {
	return Point(x: a.x + b.x, y: a.y + b.y)
}

/** Performs vector addition. */
public func +=(inout a: Point, b: Point) {
	a = a + b
}

/** Performs vector subtraction. */
public func -(a: Point, b: Point) -> Point {
	return Point(x: a.x - b.x, y: a.y - b.y)
}

/** Performs vector subtraction. */
public func -=(inout a: Point, b: Point) {
	a = a - b
}

/** Multiplies both point dimensions by scalar. */
public func *(a: Point, scalar: Double) -> Point {
	return Point(x: a.x * scalar, y: a.y * scalar)
}

/** Multiplies both point dimensions by scalar. */
public func *=(inout a: Point, scalar: Double) {
	a = a * scalar
}

/** Divides both point dimensions by scalar. */
public func /(a: Point, scalar: Double) -> Point {
	return a * (1.0 / scalar)
}

/** Divides both point dimensions by scalar. */
public func /=(inout a: Point, scalar: Double) {
	a = a / scalar
}

extension CGPoint {
	/** Converts a CGPoint to a Point. */
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

public func +(a: Size, b: Size) -> Size {
	return Size(width: a.width + b.width, height: a.height + b.height)
}

public func +=(inout a: Size, b: Size) {
	a = a + b
}

public func *(a: Size, scalar: Double) -> Size {
	return Size(width: a.width * scalar, height: a.height * scalar)
}

public func *=(inout a: Size, scalar: Double) {
	a = a * scalar
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
