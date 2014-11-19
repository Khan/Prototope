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
	public var position: Animator<Point>

	private weak var layer: Layer?

	init(layer: Layer) {
		self.layer = layer
		x = Animator(layer: layer, propertyName: kPOPLayerPositionX)
		position = Animator(layer: layer, propertyName: kPOPLayerPosition)
	}
}

public class Animator<Target: NSValueConvertible> {
	public var target: Target? {
		didSet {
			updateAnimationCreatingIfNecessary(true)
		}
	}

	public var speed: Double = 4.0 {
		didSet {
			updateAnimationCreatingIfNecessary(false)
		}
	}

	public var bounciness: Double = 12.0 {
		didSet {
			updateAnimationCreatingIfNecessary(false)
		}
	}

	let propertyName: String
	private weak var layer: Layer?

	init(layer: Layer, propertyName: String) {
		self.propertyName = propertyName
		self.layer = layer
	}

	private func updateAnimationCreatingIfNecessary(createIfNecessary: Bool) {
		var animation = layer?.view.pop_animationForKey(propertyName) as POPSpringAnimation?
		if animation == nil && createIfNecessary {
			animation = POPSpringAnimation(propertyNamed: propertyName)
			layer?.view.pop_addAnimation(animation, forKey: propertyName)
		}
		if let animation = animation {
			animation.springSpeed = CGFloat(speed)
			animation.springBounciness = CGFloat(bounciness)
			animation.toValue = target?.toNSValue()
		}
	}
}

public protocol NSValueConvertible {
	func toNSValue() -> NSValue
}

extension Double: NSValueConvertible {
	public func toNSValue() -> NSValue {
		return NSNumber(double: self)
	}
}

extension Point: NSValueConvertible {
	public func toNSValue() -> NSValue {
		return NSValue(CGPoint: CGPoint(self))
	}
}

// TODO: Revisit. Don't really like these yet.

public func animateWithDuration(duration: NSTimeInterval, #animations: () -> Void) {
	UIView.animateWithDuration(duration, delay: 0.0, options: .AllowUserInteraction, animations: animations, completion: nil)
}

public func animateWithDuration(duration: NSTimeInterval, #animations: () -> Void, #completionHandler: () -> Void) {
	UIView.animateWithDuration(duration, delay: 0.0, options: .AllowUserInteraction, animations: animations, completion: { _ in completionHandler() })
}
