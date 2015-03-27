//
//  ShapeLayer.swift
//  Prototope
//
//  Created by Jason Brennan on Mar-27-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

public class ShapeLayer: Layer {
	
	
	/** The fill colour for the shape. Defaults to `Color.black`. This is distinct from the layer's background colour. */
	public var fillColor = Color.black
	
	
	/** The stroke colour for the shape. Defaults to `Color.black`. */
	public var strokeColor = Color.black
	
	
	/** The width of the stroke. Defaults to 1.0. */
	public var strokeWidth = 1.0
	
	
	public init(rectangle: Rect, cornerRadius: Double = 0, parent: Layer? = nil, name: String? = nil) {
		self.path = UIBezierPath(roundedRect: CGRect(rectangle), cornerRadius: CGFloat(cornerRadius))
		super.init(parent: parent, name: name, viewClass: ShapeView.self)
		
		self.frame = rectangle
		self.shapeViewLayer.path = self.path.CGPath
	}
	
	
	public init(ovalInRectangle: Rect, parent: Layer? = nil, name: String? = nil) {
		self.path = UIBezierPath(ovalInRect: CGRect(ovalInRectangle))
		super.init(parent: parent, name: name, viewClass: ShapeView.self)
		self.frame = ovalInRectangle
	}
	
	
	/** Creates a regular polygon shape with the given number of sides.
		ShapeLayer: Please provide at least 3 sides for the shape.
		You: 2
		ShapeLayer: oh my god
	*/
	public init(numberOfSides: Int, parent: Layer? = nil, name: String? = nil) {
		if numberOfSides < 3 {
			Environment.currentEnvironment?.exceptionHandler("Tried to create a ShapeLayer with \(numberOfSides), but we need at least 3 to make a polygon. Triagain.")
		}
		
		// TODO(jb): finish this..
		self.path = UIBezierPath()
		super.init(parent: parent, name: name, viewClass: ShapeView.self)
		
	}
	
	
	public init(lineFromFirstPoint firstPoint: Point, toSecondPoint secondPoint: Point, parent: Layer? = nil, name: String? = nil) {
		self.path = UIBezierPath()
		self.path.moveToPoint(CGPoint(firstPoint))
		self.path.addLineToPoint(CGPoint(secondPoint))
		self.path.lineWidth = 1.0
		
		super.init(parent: parent, name: name, viewClass: ShapeView.self)
		self.frame = Rect(self.path.bounds)
		self.shapeViewLayer.path = self.path.CGPath
		self.shapeViewLayer.strokeColor = self.strokeColor.CGColor
	}
	
	
	private var path: UIBezierPath
	
	
	private var shapeViewLayer: CAShapeLayer {
		return self.view.layer as! CAShapeLayer
	}
	
	
	class ShapeView: UIView {
		override class func layerClass() -> AnyClass {
			return CAShapeLayer.self
		}
	}
}
