//
//  Gesture.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/19/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit

public struct Touch {
	let globalLocation: Point
	let timestamp: Timestamp

	func locationInLayer(layer: Layer) -> Point {
		return layer.convertGlobalPointToLocalPoint(globalLocation)
	}
}

public protocol GestureType: _GestureType {}

public enum ContinuousGestureState {
	case Began
	case Changed
	case Ended
	case Cancelled
}

public class TapGesture: GestureType {
	public init(actionHandler: (localLocation: Point) -> (), numberOfTapsRequired: Int = 1, numberOfTouchesRequired: Int = 1) {
		tapGestureHandler = TapGestureHandler(actionHandler: actionHandler)
		tapGestureRecognizer = UITapGestureRecognizer(target: tapGestureHandler, action: "handleGestureRecognizer:")
	}


	deinit {
		tapGestureRecognizer.removeTarget(tapGestureHandler, action: "handleGestureRecognizer:")
	}

	public var numberOfTouchesRequired: Int {
		get { return tapGestureRecognizer.numberOfTouchesRequired }
		set { tapGestureRecognizer.numberOfTouchesRequired = newValue }
	}

	public var numberOfTapsRequired: Int {
		get { return tapGestureRecognizer.numberOfTapsRequired }
		set { tapGestureRecognizer.numberOfTapsRequired = newValue }
	}

	private let tapGestureRecognizer: UITapGestureRecognizer
	private let tapGestureHandler: TapGestureHandler

	public weak var hostLayer: Layer? {
		didSet {
			if hostLayer !== oldValue {
				oldValue?.view.removeGestureRecognizer(tapGestureRecognizer)
				hostLayer?.view.addGestureRecognizer(tapGestureRecognizer)
			}
		}
	}

	@objc class TapGestureHandler: NSObject {
		init(actionHandler: Point -> ()) {
			self.actionHandler = actionHandler
		}

		private let actionHandler: Point -> ()

		func handleGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
			actionHandler(Point(gestureRecognizer.locationInView(gestureRecognizer.view)))
		}
	}
}

public protocol _GestureType {
	weak var hostLayer: Layer? { get nonmutating set }
}

extension Touch {
	init(_ touch: UITouch) {
		globalLocation = Point(touch.locationInView(nil))
		timestamp = touch.timestamp
	}
}