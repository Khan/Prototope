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
public struct TouchSample: SampleType {
	/** The location of the touch sample in the root layer's coordinate system. */
	public let globalLocation: Point

	/** The time at which the touch arrived. */
	public let timestamp: Timestamp

	/** The location of the touch sample, converted into a target layer's coordinate system. */
	public func locationInLayer(layer: Layer) -> Point {
		return layer.convertGlobalPointToLocalPoint(globalLocation)
	}

	public init(globalLocation: Point, timestamp: Timestamp) {
		self.globalLocation = globalLocation
		self.timestamp = timestamp
	}
}

extension TouchSample: Printable {
	public var description: String {
		return "<TouchSample: globalLocation: \(globalLocation), timestamp: \(timestamp)>"
	}
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
        shouldRecognizeSimultaneouslyWithGesture = { _ in return false }
        tapGestureDelegate = GestureRecognizerBridge(self)
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
    private var tapGestureDelegate: UIGestureRecognizerDelegate!
    
    public var underlyingGestureRecognizer: UIGestureRecognizer {
        return tapGestureRecognizer
    }
    
    public var shouldRecognizeSimultaneouslyWithGesture: GestureType -> Bool

	public weak var hostLayer: Layer? {
		didSet { handleTransferOfGesture(self, oldValue, hostLayer) }
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
        
        shouldRecognizeSimultaneouslyWithGesture = { _ in return false }
        panGestureDelegate = GestureRecognizerBridge(self)
	}

	private let panGestureRecognizer: UIPanGestureRecognizer
	private let panGestureHandler: PanGestureHandler
    private var panGestureDelegate: UIGestureRecognizerDelegate!
    
    public var underlyingGestureRecognizer: UIGestureRecognizer {
        return panGestureRecognizer
    }
    
    public var shouldRecognizeSimultaneouslyWithGesture: GestureType -> Bool

	public weak var hostLayer: Layer? {
		didSet { handleTransferOfGesture(self, oldValue, hostLayer) }
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
			let panGesture = gestureRecognizer as! UIPanGestureRecognizer
			switch panGesture.state {
			case .Began:
				// Reset the gesture to record translation relative to the starting centroid; we'll interpret subsequent translations as centroid positions.
				let centroidWindowLocation = panGesture.locationInView(nil)
				panGesture.setTranslation(centroidWindowLocation, inView: nil)

				struct IDState { static var nextCentroidSequenceID = 0 }
				centroidSequence = TouchSequence(samples: [TouchSample(globalLocation: Point(centroidWindowLocation), timestamp: Timestamp.currentTimestamp)], id: IDState.nextCentroidSequenceID)
				IDState.nextCentroidSequenceID++
			case .Changed, .Ended, .Cancelled:
				centroidSequence = centroidSequence!.sampleSequenceByAppendingSample(TouchSample(globalLocation: Point(panGesture.translationInView(panGesture.view!.window!)), timestamp: Timestamp.currentTimestamp))
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

/** A rotation sample represents the state of a rotation gesture at a single point in time */
public struct RotationSample: SampleType {
    public let rotationRadians: Double
    public let velocityRadians: Double
    
    public var rotationDegrees: Double {
        get {
            return rotationRadians * 180 / M_PI
        }
    }
    
    public var velocityDegrees: Double {
        get {
            return velocityRadians * 180 / M_PI
        }
    }
    
    public let centroid: TouchSample

    public var description: String {
        return "<RotationSample: ⟳\(rotationDegrees)° ∂⟳\(velocityDegrees)°/s, \(rotationRadians)rad \(velocityRadians)rad/s, @\(centroid)>"
    }
}

/** A rotation gesture recognizes a standard iOS rotation: it doesn't begin until the user's rotated by some number of degrees, then it tracks new touches coming and going over time as well as rotation relative to the beginning of the gesture and the current rotation velocity. It exposes simple access to the sequence of rotation samples representing the series of the gesture's state over time. */
public class RotationGesture: GestureType {
    /** The handler will be invoked as the gesture recognizes and updates; it's passed the gesture's current
    phase (see ContinuousGesturePhase documentation) and a sequence of rotation samples representing the series of the gesture's state over time. */
    public convenience init(_ handler: (phase: ContinuousGesturePhase, sampleSequence: SampleSequence<RotationSample, Int>) -> ()) {
        self.init(handler: handler)
    }
    
    /**
    When cancelsTouchesInLayer is true, touches being handled via touchXXXHandlers will be cancelled
    (and touch[es]CancelledHandler will be invoked) when the gesture recognizes.
    
    The handler will be invoked as the gesture recognizes and updates; it's passed the gesture's current
    phase (see ContinuousGesturePhase documentation) and a sequence of rotation samples representing the series of the gesture's state over time. */
    public init(cancelsTouchesInLayer: Bool = true, handler: (phase: ContinuousGesturePhase, sampleSequence: SampleSequence<RotationSample, Int>) -> ()) {
        rotationGestureHandler = RotationGestureHandler(actionHandler: handler)
        rotationGestureRecognizer = UIRotationGestureRecognizer(target: rotationGestureHandler, action: "handleGestureRecognizer:")
        rotationGestureRecognizer.cancelsTouchesInView = cancelsTouchesInLayer
        
        shouldRecognizeSimultaneouslyWithGesture = { _ in return false }
        rotationGestureDelegate = GestureRecognizerBridge(self)
    }
    
    private let rotationGestureRecognizer: UIRotationGestureRecognizer
    private let rotationGestureHandler: RotationGestureHandler
    private var rotationGestureDelegate: UIGestureRecognizerDelegate!
    
    public var underlyingGestureRecognizer: UIGestureRecognizer {
        return rotationGestureRecognizer
    }
    
    public var shouldRecognizeSimultaneouslyWithGesture: GestureType -> Bool
    
    public weak var hostLayer: Layer? {
        didSet { handleTransferOfGesture(self, oldValue, hostLayer) }
    }
    
    deinit {
        rotationGestureRecognizer.removeTarget(rotationGestureHandler, action: "handleGestureRecognizer:")
    }
    
    @objc class RotationGestureHandler: NSObject {
        private let actionHandler: (phase: ContinuousGesturePhase, sampleSequence: SampleSequence<RotationSample, Int>) -> ()
        private var sampleSequence: SampleSequence<RotationSample, Int>?
        
        init(actionHandler: (phase: ContinuousGesturePhase, sampleSequence: SampleSequence<RotationSample, Int>) -> ()) {
            self.actionHandler = actionHandler
        }
        
        func handleGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
            let rotationGesture = gestureRecognizer as! UIRotationGestureRecognizer
            
            let rotation = Double(rotationGesture.rotation)
            let velocity = Double(rotationGesture.velocity)
            
            let centroidPoint = rotationGesture.locationInView(nil)
            let touchSample = TouchSample(globalLocation: Point(centroidPoint), timestamp: Timestamp.currentTimestamp)
            let sample = RotationSample(rotationRadians: rotation, velocityRadians: velocity, centroid: touchSample)
            
            switch rotationGesture.state {
            case .Began:
                struct IDState { static var nextSequenceID = 0 }
                sampleSequence = SampleSequence(samples: [sample], id: IDState.nextSequenceID)
                IDState.nextSequenceID++
                
            case .Changed, .Ended, .Cancelled:
                sampleSequence = sampleSequence!.sampleSequenceByAppendingSample(sample)
                
            case .Possible, .Failed:
                fatalError("Unexpected gesture state")
            }
            
            actionHandler(phase: ContinuousGesturePhase(rotationGesture.state)!, sampleSequence: sampleSequence!)
            
            switch rotationGesture.state {
            case .Ended, .Cancelled:
                sampleSequence = nil
            case .Began, .Changed, .Possible, .Failed:
                break
            }
        }
    }
}

/** A pinch sample represents the state of a pinch gesture at a single point in time */
public struct PinchSample: SampleType {
    public let scale: Double
    public let velocity: Double
    public let centroid: TouchSample
    
    public var description: String {
        return "<PinchSample: scale: \(scale) velocity: \(velocity) @\(centroid)>"
    }
}

/** A pinch gesture recognizes a standard iOS pinch: it doesn't begin until the user's pinched some number of points, then it tracks new touches coming and going over time as well as scale relative to the beginning of the gesture and the current scale velocity. It exposes simple access to the sequence of pinch samples representing the series of the gesture's state over time. */
public class PinchGesture: GestureType {
    /** The handler will be invoked as the gesture recognizes and updates; it's passed the gesture's current
    phase (see ContinuousGesturePhase documentation), scale relative to the state at the beginning
    of the gesture, scale velocity in scale per second and also a touch sequence representing the center of all the touches involved in the pinch gesture. */
    public convenience init(_ handler: (phase: ContinuousGesturePhase, sampleSequence: SampleSequence<PinchSample, Int>) -> ()) {
        self.init(handler: handler)
    }
    
    /**
    
    When cancelsTouchesInLayer is true, touches being handled via touchXXXHandlers will be cancelled
    (and touch[es]CancelledHandler will be invoked) when the gesture recognizes.
    
    The handler will be invoked as the gesture recognizes and updates; it's passed the gesture's current
    phase (see ContinuousGesturePhase documentation), scale relative to the state at the beginning
    of the gesture, scale velocity in scale per second and also a touch sequence representing the center of all the touches involved in the pinch gesture. */
    public init(cancelsTouchesInLayer: Bool = true, handler: (phase: ContinuousGesturePhase, sampleSequence: SampleSequence<PinchSample, Int>) -> ()) {
        pinchGestureHandler = PinchGestureHandler(actionHandler: handler)
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: pinchGestureHandler, action: "handleGestureRecognizer:")
        pinchGestureRecognizer.cancelsTouchesInView = cancelsTouchesInLayer
        shouldRecognizeSimultaneouslyWithGesture = { _ in return false }
        
        pinchGestureDelegate = GestureRecognizerBridge(self)
    }
    
    internal let pinchGestureRecognizer: UIPinchGestureRecognizer
    private let pinchGestureHandler: PinchGestureHandler
    private var pinchGestureDelegate: UIGestureRecognizerDelegate!
    
    public var underlyingGestureRecognizer: UIGestureRecognizer {
        return pinchGestureRecognizer
    }

    public var shouldRecognizeSimultaneouslyWithGesture: GestureType -> Bool
    
    public weak var hostLayer: Layer? {
        didSet { handleTransferOfGesture(self, oldValue, hostLayer) }
    }
    
    deinit {
        pinchGestureRecognizer.removeTarget(pinchGestureHandler, action: "handleGestureRecognizer:")
    }
    
    @objc class PinchGestureHandler: NSObject {
        private let actionHandler: (phase: ContinuousGesturePhase, sampleSequence: SampleSequence<PinchSample, Int>) -> ()
        private var sampleSequence: SampleSequence<PinchSample, Int>?
        
        init(actionHandler: (phase: ContinuousGesturePhase, sampleSequence: SampleSequence<PinchSample, Int>) -> ()) {
            self.actionHandler = actionHandler
        }
        
        func handleGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
            let scaleGesture = gestureRecognizer as! UIPinchGestureRecognizer
            
            let scale = Double(scaleGesture.scale)
            let velocity = Double(scaleGesture.velocity)
            
            let centroidPoint = scaleGesture.locationInView(nil)
            let touchSample = TouchSample(globalLocation: Point(centroidPoint), timestamp: Timestamp.currentTimestamp)
            let sample = PinchSample(scale: scale, velocity: velocity, centroid: touchSample)
            
            switch scaleGesture.state {
            case .Began:
                struct IDState { static var nextSequenceID = 0 }
                sampleSequence = SampleSequence(samples: [sample], id: IDState.nextSequenceID)
                IDState.nextSequenceID++
                
            case .Changed, .Ended, .Cancelled:
                sampleSequence = sampleSequence!.sampleSequenceByAppendingSample(sample)
                
            case .Possible, .Failed:
                fatalError("Unexpected gesture state")
            }
            
            actionHandler(phase: ContinuousGesturePhase(scaleGesture.state)!, sampleSequence: sampleSequence!)
            
            switch scaleGesture.state {
            case .Ended, .Cancelled:
                sampleSequence = nil
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

// MARK: - Samples and sequences

public protocol SampleType: Printable {
    
}

// MARK: SampleSequenceType
public protocol SampleSequenceType : Printable {
    typealias Sample
    typealias ID : Printable
    
    var samples: [Sample] { get }
    
    var id: ID { get }
    
    var firstSample: Sample! { get }
    
    var previousSample: Sample? { get }
    
    var currentSample: Sample! { get }
    
    init(samples: [Sample], id: ID)
    
    func sampleSequenceByAppendingSample(sample: Sample) -> Self
    
    func +(a: Self, b: Sample) -> Self

    func +(a: Self, b: Self) -> Self
}

public func +<Seq: SampleSequenceType, S where S == Seq.Sample>(a: Seq, b: S) -> Seq {
    return a.sampleSequenceByAppendingSample(b)
}

public func +<Seq: SampleSequenceType>(a: Seq, b: Seq) -> Seq {
    return Seq(samples:a.samples + b.samples, id:a.id)
}

// MARK: Concrete SampleSequence

/** Represents a series of samples over time.
    Provides convenience methods for accessing samples that might be relevant
    when processing gestures. */
public struct SampleSequence<S: SampleType, I: Printable> : SampleSequenceType {
    typealias Sample = S
    typealias ID = I

    /** Samples ordered by arrival time. */
    public let samples: [Sample]
    
    /** An identifier that can be used to distinguish this sequence from e.g. other
    sequences that might be proceeding simultaneously. You might think of it as
    a "finger identifier". */
    public var id: ID
    
    /** The first sample. */
    public var firstSample: Sample! {
        return samples.first
    }
    
    /** The next-to-last sample (if one exists). */
    public var previousSample: Sample? {
        let index = samples.count - 2
        return index >= 0 ? samples[index] : nil
    }
    
    /** The most recent sample. */
    public var currentSample: Sample! {
        return samples.last
    }
    
    public init(samples: [Sample], id: ID) {
        precondition(samples.count >= 0)
        self.samples = samples
        self.id = id
    }
    
    /** Create a new sequence by adding a sample onto the end of the sample list. */
    public func sampleSequenceByAppendingSample(sample: Sample) -> SampleSequence<Sample, ID> {
        return SampleSequence(samples: samples + [sample], id: id)
    }
    
    public var description: String {
        return "{id: \(id), samples: \(samples)}"
    }
}

// MARK: TouchSequence Decorator

/** Represents a series of touch samples over time.
This is a decorator on SampleSequence, specializing it to use touch samples
and extending it with velocity calculation and smoothing methods */
public struct TouchSequence<I: Printable> : SampleSequenceType {
    typealias Sample = TouchSample
    typealias ID = I
    
    /** Inner sequence */
    private let sequence: SampleSequence<TouchSample, ID>
    
    /** Touch samples ordered by arrival time. */
    public var samples: [TouchSample] {
        return sequence.samples
    }
    
    /** An identifier that can be used to distinguish this touch sequence from e.g. other
    touch sequences that might be proceeding simultaneously. You might think of it as
    a "finger identifier". */
    public var id: ID {
        return sequence.id
    }
    
    /** The first touch sample. */
    public var firstSample: TouchSample! {
        return sequence.firstSample
    }
    
    /** The next-to-last touch sample (if one exists). */
    public var previousSample: TouchSample? {
        return sequence.previousSample
    }
    
    /** The most recent touch sample. */
    public var currentSample: TouchSample! {
        return sequence.currentSample
    }
    
    public init(samples: [TouchSample], id: ID) {
        self.sequence = SampleSequence(samples: samples, id: id)
    }
    
    /** The approximate current velocity of the touch sequence, specified in points per second
    in the layer's coordinate space. */
    public func currentVelocityInLayer(layer: Layer) -> Point {
        if samples.count <= 1 {
            return Point()
        } else {
            let velocitySmoothingFactor = 0.1
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
    
    /** Create a new touch sequence by adding a sample onto the end of the sample list. */
    public func sampleSequenceByAppendingSample(sample: TouchSample) -> TouchSequence<ID> {
        return TouchSequence(samples: samples + [sample], id: id)
    }
    
    public var description: String {
        return sequence.description
    }
}

// MARK: Gesture-to-gesture interaction

//Need to have a way to map Gestures to UIGestureRecognizers
var gestureMap = [UIGestureRecognizer:GestureType]()

func gestureForGestureRecognizer(gestureRecognizer: UIGestureRecognizer) -> GestureType? {
    return gestureMap[gestureRecognizer]
}

@objc class GestureRecognizerBridge: NSObject, UIGestureRecognizerDelegate {
    let gesture: GestureType
    
    init(_ gesture: GestureType) {
        self.gesture = gesture
        super.init()
        gesture.underlyingGestureRecognizer.delegate = self
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let otherGesture = gestureForGestureRecognizer(otherGestureRecognizer) {
            return gesture.shouldRecognizeSimultaneouslyWithGesture(otherGesture)
        }
        return false
    }
}

// MARK: - Internal interfaces

public protocol GestureType: _GestureType {
    var shouldRecognizeSimultaneouslyWithGesture: GestureType -> Bool { get set }
}

private func handleTransferOfGesture(gesture:GestureType, fromLayer: Layer?, toLayer: Layer?) {
    let recognizer = gesture.underlyingGestureRecognizer
    
    switch (fromLayer, toLayer) {
    case (.None, .Some):
        gestureMap[recognizer] = gesture
    case (.Some, .None):
        gestureMap.removeValueForKey(recognizer)
    default:
        ()
    }
    
	if fromLayer !== toLayer {
		fromLayer?.view.removeGestureRecognizer(recognizer)
		toLayer?.view.addGestureRecognizer(recognizer)
	}
}

public protocol _GestureType {
	weak var hostLayer: Layer? { get nonmutating set }
    var underlyingGestureRecognizer: UIGestureRecognizer { get }
}

public func ==(lhs: _GestureType,rhs: _GestureType) -> Bool {
    return lhs.underlyingGestureRecognizer == rhs.underlyingGestureRecognizer
}

extension TouchSample {
	init(_ touch: UITouch) {
		globalLocation = Point(touch.locationInView(nil))
		timestamp = Timestamp(touch.timestamp)
	}
}