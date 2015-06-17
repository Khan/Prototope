//
//  Screen.swift
//  Prototope
//
//  Created by Jason Brennan on Jun-16-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//
//	Swifty re-write of https://github.com/adamwulf/ios-uitouch-bluedots

import UIKit
import UIKit.UIGestureRecognizerSubclass


/** Type representing the Screen of the device. */
public struct Screen {
	
	public static var touchDotsEnabled: Bool = false {
		didSet {
			if touchDotsEnabled {
				enableTouchDots()
			} else {
				removeTouchDots()
			}
		}
	}
	
	private static var overlayView: TouchDotOverlayView? = nil
	private static func enableTouchDots() {
		overlayView = TouchDotOverlayView(frame: CGRect(Layer.root.frame))
		let window = UIApplication.sharedApplication().delegate?.window
		window!!.addSubview(overlayView!)
	}
	
	
	private static func removeTouchDots() {
		overlayView?.removeFromSuperview()
	}
}


/** Internal view subclass to act as a passthrough and to show touch dots. */
class TouchDotOverlayView: UIView {
	
	let gestureRecognizer = TouchDotGestureRecognizer()
	var dotViews = [Int: UIImageView]()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.autoresizingMask = .FlexibleHeight | .FlexibleWidth
		self.userInteractionEnabled = true
		self.backgroundColor = UIColor.clearColor()
		self.opaque = false
		
		self.gestureRecognizer.touchDelegate = self
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}


// UIView hierarchy overrides
extension TouchDotOverlayView {
	
	override func didMoveToSuperview() {
		self.gestureRecognizer.view?.removeGestureRecognizer(self.gestureRecognizer)
		self.superview?.addGestureRecognizer(self.gestureRecognizer)
	}
	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		return nil
	}
	
	override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
		return false
	}
}


// Touch dot management
extension TouchDotOverlayView {
	func updateTouch(touch: UITouch) {
		let location = touch.locationInView(self)
		let key = touch.hash
		
		var view = self.dotViews[key]
		if view == nil {
			let image = UIImage(named: "finger", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
			view = UIImageView(image: image)
			view?.sizeToFit()
			self.addSubview(view!)
			self.dotViews[key] = view
		}
		
		view?.center = location
	}
	
	
	func removeViewForTouch(touch: UITouch) {
		let view = self.dotViews.removeValueForKey(touch.hash)
		view?.removeFromSuperview()
	}
}


// Touch handling from the gesture recognizer
extension TouchDotOverlayView: TouchDotGestureRecognizerDelegate {
	func touchesBegan(touches: Set<UITouch>) {
		// ensure we are topmost
		self.superview?.bringSubviewToFront(self)
		for touch in touches {
			self.updateTouch(touch)
		}
	}
	
	
	func touchesMoved(touches: Set<UITouch>) {
		for touch in touches {
			self.updateTouch(touch)
		}
	}
	
	
	func touchesEnded(touches: Set<UITouch>) {
		for touch in touches {
			self.removeViewForTouch(touch)
		}
	}
	
}


/** Internal gesture recognizer class to handle where touches are and how they interact with other GR in the system. */
class TouchDotGestureRecognizer: UIGestureRecognizer, UIGestureRecognizerDelegate {
	
	var activeTouches = Set<UITouch>()
	weak var touchDelegate: TouchDotGestureRecognizerDelegate?

	init() {
		
		// TODO(jb): I'm not sure how to hack around this, I don't intend on messaging the target, but I've got to initialize super...
		super.init(target: NSObject(), action: "description")
		self.removeTarget(nil, action: "description")
		self.delaysTouchesBegan = false
		self.delaysTouchesEnded = false
		self.cancelsTouchesInView = false
		
		self.delegate = self
	}
	
	
	// MARK: - Touch handling
	override func touchesBegan(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		self.activeTouches.unionInPlace(touches as! Set<UITouch>)
		
		switch self.state {
		case .Possible:
			self.state = .Began
			
		default:
			self.state = .Changed
		}
		
		self.touchDelegate?.touchesBegan(touches as! Set<UITouch>)
	}
	
	
	override func touchesMoved(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		self.state = .Changed
		self.touchDelegate?.touchesMoved(touches as! Set<UITouch>)
	}
	
	
	override func touchesEnded(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		self.touchesCompleted(touches as! Set<UITouch>)
	}
	
	
	override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		self.touchesCompleted(touches as! Set<UITouch>)
	}
	
	func touchesCompleted(touches: Set<UITouch>) {
		self.activeTouches.subtractInPlace(touches)
		if self.activeTouches.count < 1 {
			self.state = .Ended
		}
		self.touchDelegate?.touchesEnded(touches)
	}
	
	
	// MARK: - Gesture interaction
	override func canBePreventedByGestureRecognizer(preventingGestureRecognizer: UIGestureRecognizer!) -> Bool {
		return false
	}
	
	
	override func shouldBeRequiredToFailByGestureRecognizer(otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
		return false
	}
	
	
	// MARK: - Gesture recognizer delegate methods
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return false
	}
	
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return false
	}
}


protocol TouchDotGestureRecognizerDelegate: class {
	func touchesBegan(touches: Set<UITouch>)
	func touchesMoved(touches: Set<UITouch>)
	func touchesEnded(touches: Set<UITouch>)
}
