//
//  Layer.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/3/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit

public private(set) var RootLayer: Layer!
public func setRootLayer(fromView view: UIView) {
	RootLayer = Layer(wrappingView: view, name: "Root")
}

public class Layer: Equatable {
	public init(parent: Layer? = nil, name: String? = nil) {
		self.parent = parent
		self.view = UIView()
		self.name = name

		self.parentDidChange()
	}

	private init(wrappingView: UIView, name: String? = nil) {
		view = wrappingView
		self.name = name
	}

	public weak var parent: Layer? {
		willSet {
			if let parentSublayers = self.parent?.sublayers {
				self.parent!.sublayers = parentSublayers.filter{ $0 !== self }
			}
		}
		didSet {
			parentDidChange()
		}
	}
	
	private func parentDidChange() {
		parentView = parent?.view
		parent?.sublayers.append(self)
	}

	public private(set) var sublayers: [Layer] = []

	public var sublayerAtFront: Layer? { return sublayers.last }

	private var parentView: UIView? {
		get { return view.superview }
		set { newValue?.addSubview(view) }
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

	public var frame: Rect {
		get { return Rect(layer.frame) }
		set { layer.frame = CGRect(newValue) }
	}

	public var bounds: Rect {
		get { return Rect(layer.bounds) }
		set { layer.bounds = CGRect(newValue) }
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

	public var userInteractionEnabled: Bool {
		get { return view.userInteractionEnabled }
		set { view.userInteractionEnabled = newValue }
	}

	public var globalPosition: Point {
		get { return Point(view.convertPoint(view.center, toCoordinateSpace: UIScreen.mainScreen().coordinateSpace)) }
		set { view.center = view.convertPoint(CGPoint(newValue), fromCoordinateSpace: UIScreen.mainScreen().coordinateSpace) }
	}

  public func ancestorNamed(name: String) -> Layer? {
    var currentLayer = parent
    while currentLayer != nil {
      if currentLayer!.name == name {
        return currentLayer
      }
      currentLayer = currentLayer!.parent
    }
    return nil
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

extension Layer: Printable {
	public var description: String {
		var output = ""
		if let name = name {
			output += "\(name): "
		}
		output += view.description
		return output
	}
}

public func ==(a: Layer, b: Layer) -> Bool {
	return a === b
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
