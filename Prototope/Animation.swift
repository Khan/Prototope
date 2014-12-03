//
//  Animation.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/8/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit

// MARK: - Dynamic animation APIs

extension Layer {
	/** Provides access to a collection of dynamic animators for the properties on this layer.
		If you want a layer to animate towards a point in a physical fashion (i.e. with speed
		determined by physical parameters, not a fixed duration), or if you want to take into
		account gesture velocity, this is your API.

		For example, this dynamically animates someLayer's x value to 400 using velocity from
		a touch sequence:

			someLayer.animators.x.target = 400
			someLayer.animators.x.velocity = touchSequence.currentVelocityInLayer(someLayer.superlayer!)
	
		See documentation for LayerAnimatorStore and Animator for more information.
	
		If you just want to change a bunch of values in a fixed-time animation, see
		Layer.animateWithDuration(:, animations:, completionHandler:). */
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

/** See documentation for Layer.animators for more detail on the role of this object. */
public class LayerAnimatorStore {
	public var x: Animator<Double>
	public var y: Animator<Double>
	public var position: Animator<Point>
	public var size: Animator<Size>
	public var frame: Animator<Rect>
	public var bounds: Animator<Rect>
	public var backgroundColor: Animator<Color>
	public var alpha: Animator<Double>
/*	TODO:
	width, height, anchorPoint, cornerRadius,
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

// TODO: support decay-type animations too.
/** See documentation for Layer.animators for more detail on the role of this object. */
public class Animator<Target: AnimatorValueConvertible> {
	/** The target value of this animator. Will update the corresponding property on the
		associated layer during the animation. When the animation completes, the target
		value will be set back to nil. */
	public var target: Target? {
		didSet {
			if target != nil {
				updateAnimationCreatingIfNecessary(true)
			} else {
				stop()
			}
		}
	}

	/** How quickly the animation resolves to the target value. Valid range from 0 to 20. */
	public var springSpeed: Double = 4.0 {
		didSet { updateAnimationCreatingIfNecessary(false) }
	}

	/** How springily the animation resolves to the target value. Valid range from 0 to 20. */
	public var springBounciness: Double = 12.0 {
		didSet { updateAnimationCreatingIfNecessary(false) }
	}

	/** The instantaneous velocity of the layer, specified in (target type units) per second.
		For instance, if this animator affects x, the velocity is specified in points per second. */
	public var velocity: Target? {
		didSet { updateAnimationCreatingIfNecessary(false) }
	}

	// TODO: This API is not robust. Need to think this through more.
	/** This function is called whenever the animation resolves to its target value. */
	public var completionHandler: (() -> Void)? {
		didSet {
			animationDelegate.completionHandler = { [weak self] in
				self?.completionHandler?()
				self?.target = nil
			}
		}
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

	/** Immediately stops the animation. */
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
			precondition(target != nil)
			animation.springSpeed = CGFloat(springSpeed)
			animation.springBounciness = CGFloat(springBounciness)
			animation.toValue = target?.toAnimatorValue()
			if let velocityValue: AnyObject = target?.toAnimatorValue() {
				animation.velocity = velocityValue
			}
		}
	}
}

// MARK: - Traditional time-based animation APIs
// TODO: Revisit. Don't really like these yet.

extension Layer {
	/** Traditional cubic bezier animation curves. */
	public enum AnimationCurve {
		case Linear
		case EaseIn
		case EaseOut
		case EaseInOut
	}

	/** Implicitly animates all animatable changes made inside the animations block and calls the
		completion handler when they're complete. Attempts to compose reasonably with animations
		that are already in flight, but that's not always possible. If you're looking to take into
		account initial velocity or to have a more realistic physical simulation, see Layer.animators. */
	public class func animateWithDuration(duration: NSTimeInterval, animations: () -> Void, completionHandler: (() -> Void)? = nil) {
		animateWithDuration(duration, curve: .EaseInOut, animations: animations, completionHandler: completionHandler)
	}

	/** Implicitly animates all animatable changes made inside the animations block and calls the
		completion handler when they're complete. Attempts to compose reasonably with animations
		that are already in flight, but that's not always possible. If you're looking to take into
		account initial velocity or to have a more realistic physical simulation, see Layer.animators. */
	public class func animateWithDuration(duration: NSTimeInterval, curve: AnimationCurve, animations: () -> Void, completionHandler: (() -> Void)? = nil) {
		var curveOption: UIViewAnimationOptions = nil
		switch curve {
		case .Linear:
			curveOption = .CurveLinear
		case .EaseIn:
			curveOption = .CurveEaseIn
		case .EaseOut:
			curveOption = .CurveEaseOut
		case .EaseInOut:
			curveOption = .CurveEaseInOut
		}
		UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction | curveOption, animations: animations, completion: { _ in completionHandler?(); return })
	}

}

// MARK: - Internal interfaces

@objc private class AnimationDelegate: NSObject, POPAnimationDelegate {
	var completionHandler: (() -> Void)?

	func pop_animationDidStop(animation: POPAnimation, finished: Bool) {
		completionHandler?()
	}
}

public protocol AnimatorValueConvertible: _AnimatorValueConvertible {}
public protocol _AnimatorValueConvertible {
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

private var layersToAnimatorStores = [Layer: LayerAnimatorStore]()
