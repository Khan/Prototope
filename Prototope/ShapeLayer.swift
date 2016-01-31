//
//  ShapeLayer.swift
//  Prototope
//
//  Created by Jason Brennan on Mar-27-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit


/** This layer represents a 2D shape, which is drawn from a list of Segments. This class is similar to the Paths in paper.js. */
public class ShapeLayer: Layer {
	
	
	/** Creates a circle with the given center and radius. */
	convenience public init(circleCenter: Point, radius: Double, parent: Layer? = nil, name: String? = nil) {
		self.init(ovalInRectangle: Rect(
			x: circleCenter.x - radius, 
			y: circleCenter.y - radius, 
			width: radius * 2, 
			height: radius * 2), parent: parent, name: name)
	}
	
	
	/** Creates an oval within the given rectangle. */
	convenience public init(ovalInRectangle: Rect, parent: Layer? = nil, name: String? = nil) {
		var renderRect = ovalInRectangle
		renderRect.origin = Point()
		self.init(segments: Segment.segmentsForOvalInRect(renderRect), closed: true, parent: parent, name: name)
		self.frame = ovalInRectangle
	}
	
	
	/** Creates a rectangle with an optional corner radius. */
	convenience public init(rectangle: Rect, cornerRadius: Double = 0, parent: Layer? = nil, name: String? = nil) {
		var renderRect = rectangle
		renderRect.origin = Point()
		self.init(segments: Segment.segmentsForRect(renderRect, cornerRadius: cornerRadius), closed: true, parent: parent, name: name)
		self.frame = rectangle
	}
	
	
	/** Creates a line from two points. */
	convenience public init(lineFromFirstPoint firstPoint: Point, toSecondPoint secondPoint: Point, parent: Layer? = nil, name: String? = nil) {
		let difference = secondPoint - firstPoint
		self.init(segments: Segment.segmentsForLineFromFirstPoint(Point(), secondPoint: difference), parent: parent, name: name)
		self.frame = Rect(x: firstPoint.x, y: firstPoint.y, width: abs(difference.x), height: abs(difference.y))
	}
	
	
	/** Creates a regular polygon path with the given number of sides. */
	convenience public init(polygonCenteredAtPoint centerPoint: Point, radius: Double, numberOfSides: Int, parent: Layer? = nil, name: String? = nil) {
		let frame = Rect(x: centerPoint.x - radius, y: centerPoint.y - radius, width: radius * 2, height: radius * 2)
        self.init(segments: Segment.segmentsForPolygonCenteredAtPoint(Point(x: radius, y: radius), radius: radius, numberOfSides: numberOfSides), closed: true, parent: parent, name: name)
        
		self.frame = frame
	}
	
	
	/** Initialize the ShapeLayer with a given path. */
	public init(segments: [Segment], closed: Bool = false, parent: Layer? = nil, name: String? = nil) {
		
		self.segments = segments
		self.closed = closed
		
		super.init(parent: parent, name: name, viewClass: ShapeView.self)
		
		let view = self.view as! ShapeView
		view.displayHandler = {
			[weak self] in
			if let aliveSelf = self {
				aliveSelf.shapeViewLayer.path = aliveSelf.bezierPath.CGPath
			}
		}
		
		self.setNeedsDisplay()
		self.shapeViewLayerStyleDidChange()
		
	}
	
	
	// MARK: - Segments
	
	/** A list of all segments of this path. */
	public var segments: [Segment] {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	/** Gets the first segment of the path, if it exists. */
	public var firstSegment: Segment? {
		return segments.first
	}
	
	
	/** Gets the last segment of the path, if it exists. */
	public var lastSegment: Segment? {
		return segments.last
	}
	
	
	/** Convenience method to add a point by wrapping it in a segment. */
	public func addPoint(point: Point) {
		self.segments.append(Segment(point: point))
	}
		
    
	/** Redraws the path. You can call this after you change path segments. */
	private func setNeedsDisplay() {
		self.view.setNeedsDisplay()
	}
	
	
	// MARK: - Methods
	
	/** Returns if the the given point is enclosed within the shape. If the shape is not closed, this always returns `false`. */
	public func enclosesPoint(point: Point) -> Bool {
		if !self.closed {
			return false
		}
		
		let path = self.bezierPath
		return path.containsPoint(CGPoint(point))
	}
	
	
	// MARK: - Properties
	
	/** The fill colour for the shape. Defaults to `Color.black`. This is distinct from the layer's background colour. */
	public var fillColor: Color? = Color.black {
		didSet {
			shapeViewLayerStyleDidChange()
		}
	}
	
	
	/** The stroke colour for the shape. Defaults to `Color.black`. */
	public var strokeColor: Color? = Color.black {
		didSet {
			shapeViewLayerStyleDidChange()
		}
	}
	
	
	/** The width of the stroke. Defaults to 1.0. */
	public var strokeWidth = 1.0 {
		didSet {
			shapeViewLayerStyleDidChange()
		}
	}
	
	
	/** If the path is closed, the first and last segments will be connected. */
	public var closed: Bool {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	
	/** The dash length of the layer's stroke. This length is used for both the dashes and the space between dashes. Draws a solid stroke when nil. */
	public var dashLength: Double? {
		didSet {
			shapeViewLayerStyleDidChange()
		}
	}
	
	
	/** Represents the types of cap styles path segment endpoints will show. Only affects open paths. */
	public enum LineCapStyle {
		
		/** The line cap will have butts for ends. */
		case Butt
		
		/** The line cap will have round ends. */
		case Round
		
		/** The line cap will have square ends. */
		case Square
		
		func capStyleString() -> String {
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
			shapeViewLayerStyleDidChange()
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
		
		func joinStyleString() -> String {
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
			shapeViewLayerStyleDidChange()
		}
	}
	
	
	// MARK: - Private details
	
	private var shapeViewLayer: CAShapeLayer {
		return self.view.layer as! CAShapeLayer
	}
	
	
	private class ShapeView: UIView {
		var displayHandler: (() -> Void)?
		
		override class func layerClass() -> AnyClass {
			return CAShapeLayer.self
		}
		
		
		override func setNeedsDisplay() {
			// The UIKit implementation (reasonably) won't call through to `CALayer` if you don't implement `drawRect:`, so we do it ourselves.
			self.layer.setNeedsDisplay()
		}
		
		@objc override func displayLayer(layer: CALayer) {
			self.displayHandler?()
		}
	}
	
	
	private func shapeViewLayerStyleDidChange() {
		let layer = self.shapeViewLayer
		layer.lineCap = self.lineCapStyle.capStyleString()
		layer.lineJoin = self.lineJoinStyle.joinStyleString()
		
		if let fillColor = fillColor {
			layer.fillColor = fillColor.CGColor
		} else {
			layer.fillColor = nil
		}
		
		
		if let strokeColor = strokeColor {
			layer.strokeColor = strokeColor.CGColor
		} else {
			layer.strokeColor = nil
		}
		
		
		if let dashLength = dashLength {
			layer.lineDashPattern = [dashLength, dashLength]
		} else {
			layer.lineDashPattern = []
		}
		
		layer.lineWidth = CGFloat(strokeWidth)
	}
	
	
	private var bezierPath: UIBezierPath {
		
		/*	This is modelled on paper.js' implementation of path rendering.
			While iterating through the segments, this checks to see if a line or a curve should be drawn between them.
			Each segment has an optional handleIn and handleOut, which act as control points for curves on either side.
			See https://github.com/paperjs/paper.js/blob/1803cd216ae6b5adb6410b5e13285b0a7fc04526/src/path/Path.js#L2026
		*/
		
		let bezierPath = UIBezierPath()
		var isFirstSegment = true
		var currentPoint = Point()
		var previousPoint = Point()
		var currentHandleIn = Point()
		var currentHandleOut = Point()
		
		func drawSegment(segment: Segment) {
			currentPoint = segment.point
			
			if isFirstSegment {
				bezierPath.moveToPoint(CGPoint(currentPoint))
				isFirstSegment = false
			} else {
				if let segmentHandleIn = segment.handleIn {
					currentHandleIn = currentPoint + segmentHandleIn
				} else {
					currentHandleIn = currentPoint
				}
				
				
				if currentHandleIn == currentPoint && currentHandleOut == previousPoint {
					bezierPath.addLineToPoint(CGPoint(currentPoint))
				} else {
					bezierPath.addCurveToPoint(CGPoint(currentPoint), controlPoint1: CGPoint(currentHandleOut), controlPoint2: CGPoint(currentHandleIn))
				}
			}
			
			previousPoint = currentPoint
			if let segmentHandleOut = segment.handleOut {
				currentHandleOut = previousPoint + segmentHandleOut
			} else {
				currentHandleOut = previousPoint
			}
			
		}
		for segment in self.segments {
			drawSegment(segment)
		}
		
		if self.closed && self.segments.count > 0 {
			drawSegment(self.segments[0])
		}

		return bezierPath
	}
	
}

/** A segment represents a point on a path, and may optionally have control handles for a curve on either side. */
public struct Segment: CustomStringConvertible {
	
	/** The anchor point / location of this segment. */
	public var point: Point
	
	
	/** The control point going in to this segment, used when computing curves. */
	public var handleIn: Point?
	
	/** The control point coming out of this segment, used when computing curves. */
	public var handleOut: Point?
	
	
	/** Initialize a segment with the given point and optional handle points. */
	public init(point: Point, handleIn: Point? = nil, handleOut: Point? = nil) {
		self.point = point
		self.handleIn = handleIn
		self.handleOut = handleOut
	}
	
	public var description: String {
		return self.point.description
	}
}


/** Convenience functions for creating shapes. */
extension Segment {
	
	// Magic number for approximating ellipse control points.
	private static let kappa = 4.0 * (sqrt(2.0) - 1.0) / 3.0
	
	/** Creates a set of segments for drawing an oval in the given rect. Algorithm based on paper.js */
	static func segmentsForOvalInRect(rect: Rect) -> [Segment] {
		
		let kappaSegments = [
			Segment(point: Point(x: -1.0, y: 0.0), handleIn: Point(x: 0.0, y: kappa), handleOut: Point(x: 0.0, y: -kappa)),
			Segment(point: Point(x: 0.0, y: -1.0), handleIn: Point(x: -kappa, y: 0.0), handleOut: Point(x: kappa, y: 0.0)),
			Segment(point: Point(x: 1.0, y: 0.0), handleIn: Point(x: 0.0, y: -kappa), handleOut: Point(x: 0.0, y: kappa)),
			Segment(point: Point(x: 0.0, y: 1.0), handleIn: Point(x: kappa, y: 0.0), handleOut: Point(x: -kappa, y: 0.0))
		]
		
		var segments = [Segment]()
		let radius = Point(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
		let center = rect.center
		
		for index in 0..<kappaSegments.count {
			let kappaSegment = kappaSegments[index]
			
			let point = kappaSegment.point * radius + center
			let handleIn = kappaSegment.handleIn! * radius
			let handleOut = kappaSegment.handleOut! * radius
			
			segments.append(Segment(point: point, handleIn: handleIn, handleOut: handleOut))
		}
		return segments
	}
	
	
	/** Creates a set of segments for drawing a rectangle, optionally with a corner radius. Algorithm based on paper.js */
	static func segmentsForRect(rect: Rect, cornerRadius radius: Double) -> [Segment] {
		var segments = [Segment]()
		
		let topLeft = rect.origin
		let topRight = Point(x: rect.maxX, y: rect.minY)
		let bottomRight = Point(x: rect.maxX, y: rect.maxY)
		let bottomLeft = Point(x: rect.minX, y: rect.maxY)
		
		
		if radius <= 0.0 {
			segments.append(Segment(point: topLeft))
			segments.append(Segment(point: topRight))
			segments.append(Segment(point: bottomRight))
			segments.append(Segment(point: bottomLeft))
		} else {
			let handle = radius * kappa
			
			segments.append(Segment(point: bottomLeft + Point(x: radius, y: 0.0), handleIn: nil, handleOut: Point(x: -1.0 * handle, y: 0)))
			segments.append(Segment(point: bottomLeft - Point(x: 0.0, y: radius), handleIn: Point(x: 0.0, y: handle), handleOut: nil))
			
			segments.append(Segment(point: topLeft + Point(x: 0.0, y: radius), handleIn: nil, handleOut: Point(x: 0.0, y: -1.0 * handle)))
			segments.append(Segment(point: topLeft + Point(x: radius, y: 0.0), handleIn: Point(x: -handle, y: 0.0), handleOut: nil))
			
			segments.append(Segment(point: topRight - Point(x: radius, y: 0.0), handleIn: nil, handleOut: Point(x: handle, y: 0)))
			segments.append(Segment(point: topRight + Point(x: 0.0, y: radius), handleIn: Point(x: 0.0, y: -handle), handleOut: nil))
			
			segments.append(Segment(point: bottomRight - Point(x: 0.0, y: radius), handleIn: nil, handleOut: Point(x: 0.0, y: handle)))
			segments.append(Segment(point: bottomRight - Point(x: radius, y: 0.0), handleIn: Point(x: handle, y: 0), handleOut: nil))
			
		}
		return segments
	}
	
	
	/** Segments for a line. Algorithm based on something I just made up. */
	static func segmentsForLineFromFirstPoint(firstPoint: Point, secondPoint: Point) -> [Segment] {
		return [Segment(point: firstPoint), Segment(point: secondPoint)]
	}
	
	
	/** Segments for a polygon with the given number of sides. Must be >= 3 sides or else funnybusiness ensues. */
	static func segmentsForPolygonCenteredAtPoint(centerPoint: Point, radius: Double, numberOfSides: Int) -> [Segment] {
		var segments = [Segment]()
		
		if numberOfSides < 3 {
			Environment.currentEnvironment?.exceptionHandler("Please use at least 3 sides for your polygon (you used \(numberOfSides))")
			return segments
		}
		
		let angle = Radian(degrees: 360.0 / Double(numberOfSides))
        let fixedRotation = -M_PI_2 // By decree (and appeal to aesthetics): there should always be a vertex on top.
		
		for index in 0..<numberOfSides {
			let x = centerPoint.x + radius * cos(angle * Double(index) + fixedRotation)
			let y = centerPoint.y + radius * sin(angle * Double(index) + fixedRotation)
			segments.append(Segment(point: Point(x: x, y: y)))
		}
		
		return segments
	}
}

