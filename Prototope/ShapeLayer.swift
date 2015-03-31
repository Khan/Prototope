//
//  ShapeLayer.swift
//  Prototope
//
//  Created by Jason Brennan on Mar-27-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

public class ShapeLayer: Layer {
	
	var path: Path
	
	// TODO(jb): These aren't actually setting properly on the shapeLayer on init(). Fixit!
	/** The fill colour for the shape. Defaults to `Color.black`. This is distinct from the layer's background colour. */
	public var fillColor: Color? = Color.black {
		didSet {
			shapeViewLayerStyleChanged()
		}
	}
	
	
	/** The stroke colour for the shape. Defaults to `Color.black`. */
	public var strokeColor: Color? = Color.black {
		didSet {
			shapeViewLayerStyleChanged()
		}
	}
	
	
	/** The width of the stroke. Defaults to 1.0. */
	public var strokeWidth = 1.0 {
		didSet {
			shapeViewLayerStyleChanged()
		}
	}
	
	
	/** Initialize the ShapeLayer with a given path. */
	public init(path: Path, parent: Layer? = nil, name: String? = nil) {
		self.path = path
		super.init(parent: parent, name: name, viewClass: ShapeView.self)
		
		self.bounds = self.path.bounds
		self.shapeViewLayer.path = self.path.bezierPath.CGPath
		self.shapeViewLayer.strokeColor = Color.black.CGColor
		self.shapeViewLayer.fillColor = nil
	}
	
	
	/** Update the shape layer to show a new path. */
	public func updatePath(newPath: Path) {
		self.path = newPath
		self.shapeViewLayer.path = self.path.bezierPath.CGPath
		self.bounds = self.path.bounds
	}
	
	
	/** Represents the types of cap styles path segment endpoints will show. Only affects open paths. */
	public enum LineCapStyle {
		
		/** The line cap will have butts for ends. */
		case Butt
		
		/** The line cap will have round ends. */
		case Round
		
		/** The line cap will have square ends. */
		case Square
		
		internal func capStyleString() -> String {
			switch self {
			case Butt:
				return kCALineCapButt
			case Round:
				return kCALineCapRound
			case Square:
				return kCALineCapSquare
			}
		}
	}
	
	
	/** The line cap style for the path. Defaults to LineCapStyle.Butt. */
	public var lineCapStyle: LineCapStyle = .Butt {
		didSet {
			shapeViewLayerStyleChanged()
		}
	}
	
	
	/** Represents the types of join styles path segments will show at their joins. */
	public enum LineJoinStyle {
		
		/** Lines will be joined with a miter style. */
		case Miter
		
		/** Lines will be joined with a round style. */
		case Round
		
		/** Line joins will have beveled edges. */
		case Bevel
		
		internal func joinStyleString() -> String {
			switch self {
			case Miter:
				return kCALineJoinMiter
			case Round:
				return kCALineJoinRound
			case Bevel:
				return kCALineJoinBevel
			}
		}
	}
	
	
	/** The line join style for path lines. Defaults to LineJoinStyle.Miter. */
	public var lineJoinStyle: LineJoinStyle = .Miter {
		didSet {
			shapeViewLayerStyleChanged()
		}
	}
	
	
	// MARK: - Private details
	
	private var shapeViewLayer: CAShapeLayer {
		return self.view.layer as! CAShapeLayer
	}
	
	
	private class ShapeView: UIView {
		override class func layerClass() -> AnyClass {
			return CAShapeLayer.self
		}
	}
	
	
	private func shapeViewLayerStyleChanged() {
		var layer = self.shapeViewLayer
		layer.lineCap = self.lineCapStyle.capStyleString()
		layer.lineJoin = self.lineJoinStyle.joinStyleString()
		
		if let fillColor = fillColor {
			self.shapeViewLayer.fillColor = fillColor.CGColor
		} else {
			self.shapeViewLayer.fillColor = nil
		}
		
		
		if let strokeColor = strokeColor {
			self.shapeViewLayer.strokeColor = strokeColor.CGColor
		} else {
			self.shapeViewLayer.strokeColor = nil
		}
		
		self.shapeViewLayer.lineWidth = CGFloat(strokeWidth)
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
	
	
	public func replaceSegmentAtIndex(index: Int, withSegment segment: Segment) {
		if index >= self.segments.count {
			Environment.currentEnvironment?.exceptionHandler("Tried to replace a path segment at index \(index) but there are only \(self.segments.count) elements")
			return
		}
		
		self.segments[index] = segment
		
	}
	
	
	/** If the path is closed, the first and last segments will be connected. */
	public var closed = false
	
	
	// MARK: - Geometry
	
	public var bounds: Rect {
		return Rect(self.bezierPath.bounds)
	}
	
	
	var bezierPath: UIBezierPath {
		// TODO(jb): Super naiive implementation. doesn't cache, doesn't handle "built in" shape paths, etc.
		let bezierPath = UIBezierPath()
		if let firstSegment = self.segments.first {
			bezierPath.moveToPoint(CGPoint(firstSegment.point))
			
			for segment in self.segments[1..<self.segments.count] {
				bezierPath.addLineToPoint(CGPoint(segment.point))
			}
		}
		
		if self.closed {
			bezierPath.closePath()
		}
		return bezierPath
	}
	
}


public struct Segment: Printable {
	public let point: Point
	
	public init(point: Point) {
		self.point = point
	}
	
	public var description: String {
		return self.point.description
	}
}

