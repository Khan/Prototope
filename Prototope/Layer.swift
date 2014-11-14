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
		self.name = name
		self.view = TouchForwardingImageView() // TODO: dynamic switch the view type depending on whether we're using an image or not
		self.view.userInteractionEnabled = true

		self.parentDidChange()
	}

	public convenience init(parent: Layer?, imageName: String) {
		self.init(parent: parent, name: imageName)
		self.image = Image(name: imageName)
		imageDidChange()
	}

	private init(wrappingView: UIView, name: String? = nil) {
		view = wrappingView
		self.name = name
	}

	public weak var parent: Layer? {
		willSet {
			if let parent = self.parent {
				parent.sublayers.removeAtIndex(find(parent.sublayers, self)!)
				view.removeFromSuperview()
			}
		}
		didSet {
			parentDidChange()
		}
	}
	
	public private(set) var sublayers: [Layer] = []

	public func removeAllSublayers() {
		// TODO: This could be way faster.
		for sublayer in sublayers {
			sublayer.parent = nil
		}
	}

	public var sublayerAtFront: Layer? { return sublayers.last }

	public func sublayerNamed(name: String) -> Layer? {
		return filter(sublayers){ $0.name == name }.first
	}

	public func sublayerOfClass<Class: Layer>(klass: Class.Type) -> Layer? {
		return filter(sublayers){ $0 is Class }.first
	}

	public func descendentNamed(name: String) -> Layer? {
		if self.name == name {
			return self
		}

		for sublayer in sublayers {
			if let match = sublayer.descendentNamed(name) {
				return match
			}
		}

		return nil
	}

	public func descendentAtPath(pathElements: [String]) -> Layer? {
		return reduce(pathElements, self) { $0?.sublayerNamed($1) }
	}

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

	public var alpha: Double {
		get { return Double(view.alpha) }
		set { view.alpha = CGFloat(newValue) }
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
		get { return convertLocalPointToGlobalPoint(position) }
		set { position = convertGlobalPointToLocalPoint(newValue) }
	}

	public func containsGlobalPoint(point: Point) -> Bool {
		return view.pointInside(CGPoint(convertGlobalPointToLocalPoint(point)), withEvent: nil)
	}

	public func convertGlobalPointToLocalPoint(globalPoint: Point) -> Point {
		return Point(view.convertPoint(CGPoint(globalPoint), fromCoordinateSpace: UIScreen.mainScreen().coordinateSpace))
	}

	public func convertLocalPointToGlobalPoint(localPoint: Point) -> Point {
		return Point(view.convertPoint(CGPoint(localPoint), toCoordinateSpace: UIScreen.mainScreen().coordinateSpace))
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

	public func ancestorOfClass<Class: Layer>(klass: Class.Type) -> Layer? {
		var currentLayer = parent
		while currentLayer != nil {
			if currentLayer! is Class {
				return currentLayer
			}
			currentLayer = currentLayer!.parent
		}
		return nil
	}

	public let name: String?

	public var image: Image? {
		didSet { imageDidChange() }
	}

	public var rotationDegrees: Double {
		get {
			return rotationRadians * 180 / M_PI
		}
		set {
			rotationRadians = newValue * M_PI / 180
		}
	}

	public var rotationRadians: Double = 0 {
		didSet { updateTransform() }
	}

	public var scale: Double {
		get { return scaleX }
		set {
			scaleX = newValue
			scaleY = newValue
		}
	}

	public var scaleX: Double = 1 {
		didSet { updateTransform() }
	}

	public var scaleY: Double = 1 {
		didSet { updateTransform() }
	}

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

	public private(set) var willBeRemovedSoon: Bool = false
	public func removeAfterDuration(duration: NSTimeInterval) {
		willBeRemovedSoon = true
		afterDuration(duration) {
			self.parent = nil
		}
	}

	public func fadeOutAndRemoveAfterDuration(duration: NSTimeInterval) {
		willBeRemovedSoon = true
		animateWithDuration(duration, animations: {
			self.alpha = 0
		}, completionHandler: {
			self.parent = nil
		})
	}

	public var gestures: [GestureType] = [] {
		didSet {
			for gesture in gestures {
				gesture.hostLayer = self
			}
		}
	}

	public typealias TouchesHandler = [UITouchID: TouchSequence<UITouchID>] -> Bool

	public var touchesBeganHandler: TouchesHandler? {
		get { return imageView.touchesBeganHandler }
		set { imageView.touchesBeganHandler = newValue }
	}

	public var touchesMovedHandler: TouchesHandler? {
		get { return imageView.touchesMovedHandler }
		set { imageView.touchesMovedHandler = newValue }
	}

	public var touchesEndedHandler: TouchesHandler? {
		get { return imageView.touchesEndedHandler }
		set { imageView.touchesEndedHandler = newValue }
	}

	public var touchesCancelledHandler: TouchesHandler? {
		get { return imageView.touchesCancelledHandler }
		set { imageView.touchesCancelledHandler = newValue }
	}

	// MARK: Internal interfaces

	private func updateTransform() {
		layer.transform = CATransform3DRotate(CATransform3DMakeScale(CGFloat(scaleX), CGFloat(scaleY), 1), CGFloat(rotationRadians), 0, 0, 1)
	}

	private func parentDidChange() {
		parentView = parent?.view
		parent?.sublayers.append(self)
	}

	private func imageDidChange() {
		if let image = image {
			imageView.image = image.uiImage
			size = image.size
		}
	}

	var view: UIView
	private var layer: CALayer { return view.layer }
	private var imageView: TouchForwardingImageView { return view as TouchForwardingImageView }


	class TouchForwardingImageView: UIImageView {
		required init(coder aDecoder: NSCoder) {
			fatalError("This method intentionally not implemented.")
		}

		override init(frame: CGRect) {
			super.init(frame: frame)
		}

		override convenience init() {
			self.init(frame: CGRect())
		}

		var touchesBeganHandler: TouchesHandler?
		override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
			let shouldForward = touchesBeganHandler?(touches.allObjects.map { Touch($0 as UITouch) }) ?? true
			if shouldForward {
				super.touchesBegan(touches, withEvent: event)
			}
		}

		var touchesMovedHandler: TouchesHandler?
		override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
			let shouldForward = touchesMovedHandler?(touches.allObjects.map { Touch($0 as UITouch) }) ?? true
			if shouldForward {
				super.touchesBegan(touches, withEvent: event)
			}
		}

		var touchesEndedHandler: TouchesHandler?
		override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
			let shouldForward = touchesEndedHandler?(touches.allObjects.map { Touch($0 as UITouch) }) ?? true
			if shouldForward {
				super.touchesBegan(touches, withEvent: event)
			}
		}

		var touchesCancelledHandler: TouchesHandler?
		override func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
			let shouldForward = touchesCancelledHandler?(touches.allObjects.map { Touch($0 as UITouch) }) ?? true
			if shouldForward {
				super.touchesBegan(touches, withEvent: event)
			}
		}
	}
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
