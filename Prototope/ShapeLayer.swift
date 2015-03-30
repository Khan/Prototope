//
//  ShapeLayer.swift
//  Prototope
//
//  Created by Jason Brennan on Mar-27-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

public class ShapeLayer: Layer {
	
	public let path: Path
	
	/** The fill colour for the shape. Defaults to `Color.black`. This is distinct from the layer's background colour. */
	public var fillColor = Color.black
	
	
	/** The stroke colour for the shape. Defaults to `Color.black`. */
	public var strokeColor = Color.black
	
	
	/** The width of the stroke. Defaults to 1.0. */
	public var strokeWidth = 1.0
	
	
	/** Initialize the ShapeLayer with a given path. */
	public init(path: Path, parent: Layer? = nil, name: String? = nil) {
		self.path = path
		super.init(parent: parent, name: name, viewClass: ShapeView.self)
		
		self.bounds = self.path.bounds
		self.shapeViewLayer.path = self.path.bezierPath.CGPath
	}
	
	
	private var shapeViewLayer: CAShapeLayer {
		return self.view.layer as! CAShapeLayer
	}
	
	
	private class ShapeView: UIView {
		override class func layerClass() -> AnyClass {
			return CAShapeLayer.self
		}
	}
}


/** Paths represent the geometry of a shape or set of lines or curves. */
public class Path {

	
	/** Creates an empty path. */
	public init() {}
	
	
	/** Creates a path preconfigured to be a perfect circle with the given center and radius. */
	public init(circleCenter: Point, radius: Double) {}
	
	
	/** Creates an ovalular path within the given rectangle. */
	public init(ovalInRectangle: Rect) {}
	
	
	/** Creates a rectangular path with an optional corner radius. */
	public init(rectangle: Rect, cornerRadius: Double = 0) {}
	
	
	/** Creates a line path from two points. */
	public init(lineFromFirstPoint firstPoint: Point, toSecondPoint secondPoint: Point) {}
	
	
	/** Creates a regular polygon path with the given number of sides. */
	public init(polygonWithNumberOfSides: Int) {}
	
	
	init(segments: [Segment]) {
		self.segments = segments
	}
	
	
	// MARK: - Segments
	
	public var segments = [Segment]()
	public var firstSegment: Segment? {
		return segments.first
	}
	
	public var lastSegment: Segment? {
		return segments.last
	}
	
	
	public func addPoint(point: Point) {
		self.segments.append(Segment(point: point))
	}
	
	
	// MARK: - Geometry
	
	var bounds: Rect {
		return Rect(self.bezierPath.bounds)
	}
	
	
	var bezierPath: UIBezierPath {
		return UIBezierPath()
	}
	
}


public struct Segment {
	let point: Point
}

