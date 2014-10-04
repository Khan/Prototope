//
//  Layer.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/3/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit

public typealias View = UIView

private var viewToNameMap: [View: String] = [:]

extension UIView {
	public convenience init(parent: UIView, name: String? = nil) {
		self.init()
		parent.addSubview(self)
		if let name = name {
			self.name = name
		}
	}

	public var name: String {
		get {
			var name = viewToNameMap[self]
			if name == nil {
				name = "Layer \(self)"
				viewToNameMap[self] = name
			}
			return name!
		}
		set {
			viewToNameMap[self] = newValue
		}
	}

	public var x: CGFloat {
		get { return center.x }
		set { center.x = newValue }
	}

	public var y: CGFloat {
		get { return center.y }
		set { center.y = newValue }
	}

	public var position: CGPoint {
		get { return center }
		set { center = newValue }
	}

	public var width: CGFloat {
		get { return bounds.size.width }
		set { bounds.size.width = newValue }
	}

	public var height: CGFloat {
		get { return bounds.size.height }
		set { bounds.size.height = newValue }
	}

	public var size: CGSize {
		get { return bounds.size }
		set { bounds.size = newValue }
	}

	public var anchorPoint: CGPoint {
		get { return layer.anchorPoint }
		set { layer.anchorPoint = newValue }
	}

	public var cornerRadius: CGFloat {
		get { return layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}

	public var border: Border {
		get {
			return Border(color: UIColor(CGColor: layer.borderColor), width: layer.borderWidth)
		}
		set {
			layer.borderColor = newValue.color.CGColor
			layer.borderWidth = newValue.width
		}
	}

	public var shadow: Shadow {
		get {
			return Shadow(color: UIColor(CGColor: layer.shadowColor), alpha: CGFloat(layer.shadowOpacity), offset: layer.shadowOffset, radius: layer.shadowRadius)
		}
		set {
			layer.shadowColor = newValue.color.CGColor
			layer.shadowOpacity = Float(newValue.alpha)
			layer.shadowOffset = newValue.offset
			layer.shadowRadius = newValue.radius
		}
	}
}

public struct Border {
	public var color: UIColor
	public var width: CGFloat

	public init(color: UIColor, width: CGFloat) {
		self.color = color
		self.width = width
	}
}

public struct Shadow {
	public var color: UIColor
	public var alpha: CGFloat
	public var offset: CGSize
	public var radius: CGFloat
	
	public init(color: UIColor, alpha: CGFloat, offset: CGSize, radius: CGFloat) {
		self.color = color
		self.alpha = alpha
		self.offset = offset
		self.radius = radius
	}
}
