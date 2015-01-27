//
//  Gesture.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/19/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import UIKit

// MARK: - Touches

/** Represents the state of a touch at a particular time. */
public struct TouchSample {
	/** The location of the touch sample in the root layer's coordinate system. */
	public let globalLocation: Point

	/** The time at which the touch arrived. */
	public let timestamp: Timestamp

	/** The location of the touch sample, converted into a target layer's coordinate system. */
	public func locationInLayer(layer: Layer) -> Point {
		return layer.convertGlobalPointToLocalPoint(globalLocation)
	}
}

extension TouchSample: Printable {
	public var description: String {
		return "<TouchSample: globalLocation: \(globalLocation), timestamp: \(timestamp)>"
	}
}

/** Represents a series of touch samples over time. */
public struct TouchSequence<ID: Printable>: Printable {
	/** Touch samples ordered by arrival time. */
	public let samples: [TouchSample]

	/** An identifier that can be used to distinguish this touch sequence from e.g. other
		touch sequences that might be proceeding simultaneously. You might think of it as
		a "finger identifier". */
	public var id: ID

	/** The first touch sample. */
	public var firstSample: TouchSample! {
		return samples.first // Touch sequences, when exposed to API clients, always have at least one sample.
	}

	/** The next-to-last touch sample (if one exists). */
	public var previousSample: TouchSample? {
		let index = samples.count - 2
		return index >= 0 ? samples[index] : nil
	}

	/** The most recent touch sample. */
	public var currentSample: TouchSample! {
		return samples.last // Touch sequences, when exposed to API clients, always have at least one sample.
	}

	/** The approximate current velocity of the touch sequence, specified in points per second
		in the layer's coordinate space. */
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

	/** The approximate current velocity of the touch sequence, specified in points per second
		in the root layer's coordinate space. */
	public func currentGlobalVelocity() -> Point {
		return currentVelocityInLayer(Layer.root)
	}

	public init(samples: [TouchSample], id: ID) {
		precondition(samples.count >= 0)
		self.samples = samples
		self.id = id
	}

	/** Create a new touch sequence by adding a sample onto the end of the sample list. */
	public func touchSequenceByAppendingSample(sample: TouchSample) -> TouchSequence<ID> {
		return TouchSequence(samples: samples + [sample], id: id)
	}

	public var description: String {
		return "{id: \(id), samples: \(samples)}"
	}
}

/** Creates a new touch sequence by adding the samples in the constituent sequences. */
public func +<ID>(a: TouchSequence<ID>, b: TouchSequence<ID>) -> TouchSequence<ID> {
	return TouchSequence(samples: a.samples + b.samples, id: a.id)
}

/** Only public because Swift requires it. Intended to be an opaque wrapper of UITouches. */
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


// MARK: - Gesture

/* See conceptual documentation at Layer.gestures. */

/** A gesture which recognizes standard iOS taps. */
public class TapGesture: GestureType {
	/** The handler will be invoked with the location the tap occurred, expressed in the root layer's
		coordinate space. */
	public convenience init(_ handler: (globalLocation: Point) -> ()) {
		self.init(handler: handler)
	}

	/** When cancelsTouchesInLayer is true, touches being handled via touchXXXHandlers will be cancelled
		(and touch[es]CancelledHandler will be invoked) when the gesture recognizes.
		
		The handler will be invoked with the location the tap occurred, expressed in the root layer's
		coordinate space. */
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

	/** The number of fingers which must simultaneously touch the gesture's view to count as a tap. */
	public var numberOfTouchesRequired: Int {
		get { return tapGestureRecognizer.numberOfTouchesRequired }
		set { tapGestureRecognizer.numberOfTouchesRequired = newValue }
	}

	/** The number of sequential taps which must be recognized before the gesture's handler is fired. */
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

/** A pan gesture recognizes a standard iOS pan: it doesn't begin until the user's moved at least 10
	points, then it tracks new touches coming and going over time (up to the maximumNumberOfTouches).
	It exposes simple access to the path of the center of all the touches. */
public class PanGesture: GestureType {
	/** The handler will be invoked as the gesture recognizes and updates; it's passed both the gesture's current
		phase (see ContinuousGesturePhase documentation) and also a touch sequence representing the center of
		all the touches involved in the pan gesture. */
	public convenience init(_ handler: (phase: ContinuousGesturePhase, centroidSequence: TouchSequence<Int>) -> ()) {
		self.init(handler: handler)
	}

	/** The pan gesture won't recognize until minimumNumberOfTouches arrive, and it will ignore all touches
		beyond maximumNumberOfTouches (but won't be cancelled if that many arrive once the gesture has already
		begun).

		When cancelsTouchesInLayer is true, touches being handled via touchXXXHandlers will be cancelled
		(and touch[es]CancelledHandler will be invoked) when the gesture recognizes.

		The handler will be invoked as the gesture recognizes and updates; it's passed both the gesture's current
		phase (see ContinuousGesturePhase documentation) and also a touch sequence representing the center of
		all the touches involved in the pan gesture. */
	public init(minimumNumberOfTouches: Int = 1, maximumNumberOfTouches: Int = Int.max, cancelsTouchesInLayer: Bool = true, handler: (phase: ContinuousGesturePhase, centroidSequence: TouchSequence<Int>) -> ()) {
		panGestureHandler = PanGestureHandler(actionHandler: handler)
		panGestureRecognizer = UIPanGestureRecognizer(target: panGestureHandler, action: "handleGestureRecognizer:")
		panGestureRecognizer.cancelsTouchesInView = cancelsTouchesInLayer
		panGestureRecognizer.minimumNumberOfTouches = minimumNumberOfTouches
		panGestureRecognizer.maximumNumberOfTouches = maximumNumberOfTouches
	}

	private let panGestureRecognizer: UIPanGestureRecognizer
	private let panGestureHandler: PanGestureHandler

	public weak var hostLayer: Layer? {
		didSet { handleTransferOfGesture(panGestureRecognizer, oldValue, hostLayer) }
	}

	deinit {
		panGestureRecognizer.removeTarget(panGestureHandler, action: "handleGestureRecognizer:")
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
				centroidSequence = TouchSequence(samples: [TouchSample(globalLocation: Point(centroidWindowLocation), timestamp: Timestamp.currentTimestamp)], id: IDState.nextCentroidSequenceID)
				IDState.nextCentroidSequenceID++
			case .Changed, .Ended, .Cancelled:
				centroidSequence = centroidSequence!.touchSequenceByAppendingSample(TouchSample(globalLocation: Point(panGesture.translationInView(panGesture.view!.window!)), timestamp: Timestamp.currentTimestamp))
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

/** A rotation gesture recognizes a standard iOS rotation: it doesn't begin until the user's moved some number of points, then it tracks new touches coming and going over time as well as rotation relative to the beginning of the gesture and the current rotation velocity. It exposes simple access to the path of the center of all the touches and the rotation and rotation velocity values. */
public class RotationGesture: GestureType {
    /** The handler will be invoked as the gesture recognizes and updates; it's passed the gesture's current
    phase (see ContinuousGesturePhase documentation), rotation relative to the state at the beginning 
    of the gesture in radians, rotation velocity in radians per second and also a touch sequence representing the center of all the touches involved in the rotation gesture. */
    public convenience init(_ handler: (phase: ContinuousGesturePhase, rotationRadians: Double, rotationVelocity: Double, centroidSequence: TouchSequence<Int>) -> ()) {
        self.init(handler: handler)
    }
    
    /** 
    
    When cancelsTouchesInLayer is true, touches being handled via touchXXXHandlers will be cancelled
    (and touch[es]CancelledHandler will be invoked) when the gesture recognizes.
    
    The handler will be invoked as the gesture recognizes and updates; it's passed the gesture's current
    phase (see ContinuousGesturePhase documentation), rotation relative to the state at the beginning
    of the gesture in radians, rotation velocity in radians per second and also a touch sequence representing the center of all the touches involved in the rotation gesture. */
    public init(cancelsTouchesInLayer: Bool = true, handler: (phase: ContinuousGesturePhase, rotationRadians: Double, rotationVelocity: Double, centroidSequence: TouchSequence<Int>) -> ()) {
        rotationGestureHandler = RotationGestureHandler(actionHandler: handler)
        rotationGestureRecognizer = UIRotationGestureRecognizer(target: rotationGestureHandler, action: "handleGestureRecognizer:")
        rotationGestureRecognizer.cancelsTouchesInView = cancelsTouchesInLayer
    }
    
    private let rotationGestureRecognizer: UIRotationGestureRecognizer
    private let rotationGestureHandler: RotationGestureHandler
    
    public weak var hostLayer: Layer? {
        didSet { handleTransferOfGesture(rotationGestureRecognizer, oldValue, hostLayer) }
    }
    
    deinit {
        rotationGestureRecognizer.removeTarget(rotationGestureHandler, action: "handleGestureRecognizer:")
    }
    
    @objc class RotationGestureHandler: NSObject {
        private let actionHandler: (phase: ContinuousGesturePhase, rotationRadians: Double, rotationVelocity: Double, centroidSequence: TouchSequence<Int>) -> ()
        private var centroidSequence: TouchSequence<Int>?
        
        init(actionHandler: (phase: ContinuousGesturePhase, rotationRadians: Double, rotationVelocity: Double, centroidSequence: TouchSequence<Int>) -> ()) {
            self.actionHandler = actionHandler
        }
        
        func handleGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
            let rotationGesture = gestureRecognizer as UIRotationGestureRecognizer
            switch rotationGesture.state {
            case .Began:
                // Reset the gesture to record rotation relative to the starting rotation
                let centroidWindowLocation = rotationGesture.locationInView(nil)
                
                struct IDState { static var nextCentroidSequenceID = 0 }
                centroidSequence = TouchSequence(samples: [TouchSample(globalLocation: Point(centroidWindowLocation), timestamp: Timestamp.currentTimestamp)], id: IDState.nextCentroidSequenceID)
                IDState.nextCentroidSequenceID++
            case .Changed, .Ended, .Cancelled:
                let centroid = rotationGesture.locationInView(nil)
                centroidSequence = centroidSequence!.touchSequenceByAppendingSample(TouchSample(globalLocation: Point(centroid), timestamp: Timestamp.currentTimestamp))
            case .Possible, .Failed:
                fatalError("Unexpected gesture state")
            }
            
            let rotation = rotationGesture.rotation
            let velocity = rotationGesture.velocity
            actionHandler(phase: ContinuousGesturePhase(rotationGesture.state)!, rotationRadians: Double(rotation), rotationVelocity: Double(velocity), centroidSequence: centroidSequence!)
            
            switch rotationGesture.state {
            case .Ended, .Cancelled:
                centroidSequence = nil
            case .Began, .Changed, .Possible, .Failed:
                break
            }
        }
    }
}

/** Continuous gestures are different from discrete gestures in that they pass through several phases.
	A discrete gesture simply recognizes--then it's done. A continuous gesture begins, then may change
	over the course of several events, then ends (or is cancelled). */
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

// MARK: -

public protocol GestureType: _GestureType {}

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
		timestamp = Timestamp(touch.timestamp)
	}
}