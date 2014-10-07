//
//  Layer.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/3/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit

public class Layer {
	public convenience init(parent: Layer? = nil, name: String? = nil) {
		self.init(parent: parent?.view, name: name)
	}

	public init(parent: UIView? = nil, name: String? = nil) {
		view = UIView()
		parent?.addSubview(view)

		self.name = name // TODO: Dynamic UIView subclassing so the name shows up in Reveal.
	}

	public var x: Double {
		get { return Double(layer.position.x) }
		set { layer.position.x = CGFloat(newValue) }
	}

	public var y: Double {
		get { return Double(layer.position.y) }
		set { layer.position.y = CGFloat(newValue) }
	}

	public var position: Point {
		get { return Point(layer.position) }
		set { layer.position = CGPoint(newValue) }
	}

	public var width: Double {
		get { return Double(layer.bounds.size.width) }
		set { layer.bounds.size.width = CGFloat(newValue) }
	}

	public var height: Double {
		get { return Double(layer.bounds.size.height) }
		set { layer.bounds.size.height = CGFloat(newValue) }
	}

	public var size: Size {
		get { return Size(layer.bounds.size) }
		set { layer.bounds.size = CGSize(newValue) }
	}

	public var backgroundColor: UIColor? {
		get { return view.backgroundColor }
		set { view.backgroundColor = newValue }
	}

	public var anchorPoint: Point {
		get { return Point(layer.anchorPoint) }
		set { layer.anchorPoint = CGPoint(newValue) }
	}

	public var cornerRadius: Double {
		get { return Double(layer.cornerRadius) }
		set { layer.cornerRadius = CGFloat(newValue) }
	}

	public let name: String?

	public var border: Border {
		get {
			return Border(color: UIColor(CGColor: layer.borderColor), width: Double(layer.borderWidth))
		}
		set {
			layer.borderColor = newValue.color.CGColor
			layer.borderWidth = CGFloat(newValue.width)
		}
	}

	public var shadow: Shadow {
		get {
			return Shadow(color: UIColor(CGColor: layer.shadowColor), alpha: Double(layer.shadowOpacity), offset: Size(layer.shadowOffset), radius: Double(layer.shadowRadius))
		}
		set {
			layer.shadowColor = newValue.color.CGColor
			layer.shadowOpacity = Float(newValue.alpha)
			layer.shadowOffset = CGSize(newValue.offset)
			layer.shadowRadius = CGFloat(newValue.radius)
		}
	}

	private var view: UIView
	private var layer: CALayer { return view.layer }
}

public struct Border {
	public var color: UIColor
	public var width: Double

	public init(color: UIColor, width: Double) {
		self.color = color
		self.width = width
	}
}

public struct Shadow {
	public var color: UIColor
	public var alpha: Double
	public var offset: Size
	public var radius: Double

	public init(color: UIColor, alpha: Double, offset: Size, radius: Double) {
		self.color = color
		self.alpha = alpha
		self.offset = offset
		self.radius = radius
	}
}
