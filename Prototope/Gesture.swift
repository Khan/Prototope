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

	public func locationInLayer(layer: Layer) -> Point {
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

	public func currentVelocityInLayer(layer: Layer) -> Point {
		if samples.count <= 1 {
			return Point()
		} else {
			let velocitySmoothingFactor = 0.6
			func velocitySampleFromSample(a: TouchSample, toSample b: TouchSample) -> Point {
				return (b.locationInLayer(layer) - a.locationInLayer(layer)) / (b.timestamp - a.timestamp)
			}

			var velocity = velocitySampleFromSample(samples[0], toSample: samples[1])
			for sampleIndex in 2..<samples.count {
				velocity = velocity * velocitySmoothingFactor + velocitySampleFromSample(samples[sampleIndex - 1], toSample: samples[sampleIndex]) * (1 - velocitySmoothingFactor)
			}
			return velocity
		}
	}

	public func currentGlobalVelocity() -> Point {
		return currentVelocityInLayer(Layer.root)
	}

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

public enum ContinuousGesturePhase {
	case Began
	case Changed
	case Ended
	case Cancelled
}

extension ContinuousGesturePhase: Printable {
	public var description: String {
		switch self {
		case .Began:
			return "Began"
		case .Changed:
			return "Changed"
		case .Ended:
			return "Ended"
		case .Cancelled:
			return "Cancelled"
		}
	}
}

private extension ContinuousGesturePhase {
	init?(_ uiGestureState: UIGestureRecognizerState) {
		switch uiGestureState {
		case .Possible, .Failed:
			return nil
		case .Began:
			self = .Began
		case .Changed:
			self = .Changed
		case .Ended:
			self = .Ended
		case .Cancelled:
			self = .Cancelled
		}
	}
}

public class TapGesture: GestureType {
	public convenience init(_ handler: (globalLocation: Point) -> ()) {
		self.init(handler: handler)
	}

	public init(cancelsTouchesInLayer: Bool = true, numberOfTapsRequired: Int = 1, numberOfTouchesRequired: Int = 1, handler: (globalLocation: Point) -> ()) {
		tapGestureHandler = TapGestureHandler(actionHandler: handler)
		tapGestureRecognizer = UITapGestureRecognizer(target: tapGestureHandler, action: "handleGestureRecognizer:")
		tapGestureRecognizer.cancelsTouchesInView = cancelsTouchesInLayer
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
		didSet { handleTransferOfGesture(tapGestureRecognizer, oldValue, hostLayer) }
	}

	@objc class TapGestureHandler: NSObject {
		init(actionHandler: Point -> ()) {
			self.actionHandler = actionHandler
		}

		private let actionHandler: Point -> ()

		func handleGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
			actionHandler(Point(gestureRecognizer.locationInView(nil)))
		}
	}
}

public class PanGesture: GestureType {

	private let panGestureRecognizer: UIPanGestureRecognizer
	private let panGestureHandler: PanGestureHandler

	public weak var hostLayer: Layer? {
		didSet { handleTransferOfGesture(panGestureRecognizer, oldValue, hostLayer) }
	}

	public convenience init(_ handler: (phase: ContinuousGesturePhase, centroidSequence: TouchSequence<Int>) -> ()) {
		self.init(handler: handler)
	}

	public init(minimumNumberOfTouches: Int = 1, maximumNumberOfTouches: Int = Int.max, cancelsTouchesInLayer: Bool = true, handler: (phase: ContinuousGesturePhase, centroidSequence: TouchSequence<Int>) -> ()) {
		panGestureHandler = PanGestureHandler(actionHandler: handler)
		panGestureRecognizer = UIPanGestureRecognizer(target: panGestureHandler, action: "handleGestureRecognizer:")
		panGestureRecognizer.cancelsTouchesInView = cancelsTouchesInLayer
		panGestureRecognizer.minimumNumberOfTouches = minimumNumberOfTouches
		panGestureRecognizer.maximumNumberOfTouches = maximumNumberOfTouches
	}

	deinit {
		panGestureRecognizer.removeTarget(panGestureHandler, action: "handleGestureRecognizer:")
	}

	public struct State {
		public let phase: ContinuousGesturePhase
		public let centroidSequence: TouchSequence<Int>
	}

	@objc class PanGestureHandler: NSObject {
		private let actionHandler: (phase: ContinuousGesturePhase, centroidSequence: TouchSequence<Int>) -> ()
		private var centroidSequence: TouchSequence<Int>?

		init(actionHandler: (phase: ContinuousGesturePhase, centroidSequence: TouchSequence<Int>) -> ()) {
			self.actionHandler = actionHandler
		}

		func handleGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
			let panGesture = gestureRecognizer as UIPanGestureRecognizer
			switch panGesture.state {
			case .Began:
				// Reset the gesture to record translation relative to the starting centroid; we'll interpret subsequent translations as centroid positions.
				let centroidWindowLocation = panGesture.locationInView(nil)
				panGesture.setTranslation(centroidWindowLocation, inView: nil)

				struct IDState { static var nextCentroidSequenceID = 0 }
				centroidSequence = TouchSequence(samples: [TouchSample(globalLocation: Point(centroidWindowLocation), timestamp: CACurrentMediaTime())], id: IDState.nextCentroidSequenceID)
				IDState.nextCentroidSequenceID++
			case .Changed, .Ended, .Cancelled:
				centroidSequence = centroidSequence!.touchSequenceByAppendingSample(TouchSample(globalLocation: Point(panGesture.translationInView(panGesture.view!.window!)), timestamp: CACurrentMediaTime()))
			case .Possible, .Failed:
				fatalError("Unexpected gesture state")
			}

			actionHandler(phase: ContinuousGesturePhase(panGesture.state)!, centroidSequence: centroidSequence!)

			switch panGesture.state {
			case .Ended, .Cancelled:
				centroidSequence = nil
			case .Began, .Changed, .Possible, .Failed:
				break
			}
		}
	}
}

private func handleTransferOfGesture(gesture: UIGestureRecognizer, fromLayer: Layer?, toLayer: Layer?) {
	if fromLayer !== toLayer {
		fromLayer?.view.removeGestureRecognizer(gesture)
		toLayer?.view.addGestureRecognizer(gesture)
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