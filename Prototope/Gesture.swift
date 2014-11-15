//
//  Gesture.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/19/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit

// MARK: Touch

public struct TouchSample {
	public let globalLocation: Point
	public let timestamp: Timestamp

	func locationInLayer(layer: Layer) -> Point {
		return layer.convertGlobalPointToLocalPoint(globalLocation)
	}
}

extension TouchSample: Printable {
	public var description: String {
		return "{globalLocation: \(globalLocation), timestamp: \(timestamp)}"
	}
}

public struct TouchSequence<ID: Printable>: Printable {
	public let samples: [TouchSample]
	public var id: ID

	public var firstSample: TouchSample {
		return samples.first! // Touch sequences must have at least one touch sample
	}

	public var previousSample: TouchSample? {
		let index = samples.count - 2
		return index >= 0 ? samples[index] : nil
	}

	public var currentSample: TouchSample {
		return samples.last! // Touch sequences must have at least one touch sample
	}

	public init(samples: [TouchSample], id: ID) {
		precondition(samples.count >= 0)
		self.samples = samples
		self.id = id
	}

	public func touchSequenceByAppendingSample(sample: TouchSample) -> TouchSequence<ID> {
		return TouchSequence(samples: samples + [sample], id: id)
	}

	// TODO: velocity...

	public var description: String {
		return "{id: \(id), samples: \(samples)}"
	}
}

public func +<ID>(a: TouchSequence<ID>, b: TouchSequence<ID>) -> TouchSequence<ID> {
	return TouchSequence(samples: a.samples + b.samples, id: a.id)
}

public struct UITouchID: Hashable, Printable {
	init(_ touch: UITouch) {
		self.touch = touch
		if UITouchID.touchesToIdentifiers[touch] == nil {
			UITouchID.touchesToIdentifiers[touch] = UITouchID.nextIdentifier
			UITouchID.nextIdentifier++
		}
	}

	private static var touchesToIdentifiers = [UITouch: Int]()
	private static var nextIdentifier = 0

	public var hashValue: Int {
		return self.touch.hashValue
	}

	public var description: String { return "\(UITouchID.touchesToIdentifiers[touch]!)" }

	private let touch: UITouch

}

public func ==(a: UITouchID, b: UITouchID) -> Bool {
	return a.touch === b.touch
}


// MARK: Gesture

public protocol GestureType: _GestureType {}

public enum ContinuousGestureState {
	case Began
	case Changed
	case Ended
	case Cancelled
}

public class TapGesture: GestureType {
	public init(_ handler: (localLocation: Point) -> (), numberOfTapsRequired: Int = 1, numberOfTouchesRequired: Int = 1) {
		tapGestureHandler = TapGestureHandler(actionHandler: handler)
		tapGestureRecognizer = UITapGestureRecognizer(target: tapGestureHandler, action: "handleGestureRecognizer:")
		tapGestureRecognizer.numberOfTapsRequired = numberOfTapsRequired
		tapGestureRecognizer.numberOfTouchesRequired = numberOfTouchesRequired
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

extension TouchSample {
	init(_ touch: UITouch) {
		globalLocation = Point(touch.locationInView(nil))
		timestamp = touch.timestamp
	}
}