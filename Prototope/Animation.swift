//
//  Animation.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/8/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit


private var layersToAnimatorStores = [Layer: LayerAnimatorStore]()

extension Layer {
	public var animators: LayerAnimatorStore {
		if let animatorStore = layersToAnimatorStores[self] {
			return animatorStore
		} else {
			let animatorStore = LayerAnimatorStore(layer: self)
			layersToAnimatorStores[self] = animatorStore
			return animatorStore
		}
	}
}

public class LayerAnimatorStore {
	public var x: Animator<Double>
	public var y: Animator<Double>
	public var position: Animator<Point>
//	public var width: Animator<Double>
//	public var height: Animator<Double>
	public var size: Animator<Size>
	public var frame: Animator<Rect>
	public var bounds: Animator<Rect>
	public var backgroundColor: Animator<Color>
	public var alpha: Animator<Double>
//	public var anchorPoint: Animator<Point>
//	public var cornerRadius: Animator<Double>
/*	TODO:
	scale, scaleX, scaleY, rotationDegrees, rotationRadians,
	border, shadow, globalPosition
*/

	private weak var layer: Layer?

	init(layer: Layer) {
		self.layer = layer
		x = Animator(layer: layer, propertyName: kPOPLayerPositionX)
		y = Animator(layer: layer, propertyName: kPOPLayerPositionY)
		position = Animator(layer: layer, propertyName: kPOPLayerPosition)
		size = Animator(layer: layer, propertyName: kPOPLayerSize)
		bounds = Animator(layer: layer, propertyName: kPOPLayerBounds)
		frame = Animator(layer: layer, propertyName: kPOPViewFrame)
		backgroundColor = Animator(layer: layer, propertyName: kPOPViewBackgroundColor)
		alpha = Animator(layer: layer, propertyName: kPOPViewAlpha)
 	}
}

public class Animator<Target: AnimatorValueConvertible> {
	// TODO(andy): Clear target value when animation completes.
	public var target: Target? {
		didSet { updateAnimationCreatingIfNecessary(true) }
	}

	public var speed: Double = 4.0 {
		didSet { updateAnimationCreatingIfNecessary(false) }
	}

	public var bounciness: Double = 12.0 {
		didSet { updateAnimationCreatingIfNecessary(false) }
	}

	public var velocity: Target? {
		didSet { updateAnimationCreatingIfNecessary(false) }
	}

	public var completionHandler: (() -> Void)? {
		get { return animationDelegate.completionHandler }
		set { animationDelegate.completionHandler = newValue }
	}

	let property: POPAnimatableProperty
	private weak var layer: Layer?
	private let animationDelegate = AnimationDelegate()

	init(layer: Layer, property: POPAnimatableProperty) {
		self.property = property
		self.layer = layer
	}

	convenience init(layer: Layer, propertyName: String) {
		let property = POPAnimatableProperty.propertyWithName(propertyName) as POPAnimatableProperty
		self.init(layer: layer, property: property)
	}

	public func stop() {
		layer?.view.pop_removeAnimationForKey(property.name)
	}

	private func updateAnimationCreatingIfNecessary(createIfNecessary: Bool) {
		var animation = layer?.view.pop_animationForKey(property.name) as POPSpringAnimation?
		if animation == nil && createIfNecessary {
			animation = POPSpringAnimation()
			animation!.delegate = animationDelegate
			animation!.property = property
			layer?.view.pop_addAnimation(animation!, forKey: property.name)
		}

		if let animation = animation {
			animation.springSpeed = CGFloat(speed)
			animation.springBounciness = CGFloat(bounciness)
			animation.toValue = target?.toAnimatorValue()
			if let velocityValue: AnyObject = target?.toAnimatorValue() {
				animation.velocity = velocityValue
			}
		}
	}
}

@objc private class AnimationDelegate: NSObject, POPAnimationDelegate {
	var completionHandler: (() -> Void)?

	func pop_animationDidStop(animation: POPAnimation, finished: Bool) {
		completionHandler?()
	}
}

public protocol AnimatorValueConvertible {
	func toAnimatorValue() -> AnyObject
}

extension Double: AnimatorValueConvertible {
	public func toAnimatorValue() -> AnyObject {
		return NSNumber(double: self)
	}
}

extension Point: AnimatorValueConvertible {
	public func toAnimatorValue() -> AnyObject {
		return NSValue(CGPoint: CGPoint(self))
	}
}

extension Size: AnimatorValueConvertible {
	public func toAnimatorValue() -> AnyObject {
		return NSValue(CGSize: CGSize(self))
	}
}

extension Rect: AnimatorValueConvertible {
	public func toAnimatorValue() -> AnyObject {
		return NSValue(CGRect: CGRect(self))
	}
}

extension Color: AnimatorValueConvertible {
	public func toAnimatorValue() -> AnyObject {
		return self.uiColor
	}
}

// TODO: Revisit. Don't really like these yet.

public func animateWithDuration(duration: NSTimeInterval, #animations: () -> Void, completionHandler: (() -> Void)? = nil) {
	UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: animations, completion: { _ in completionHandler?(); return })
}
