//
//  Timing.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/8/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import QuartzCore

/** Represents an interval between two times. */
public typealias TimeInterval = NSTimeInterval

/** Represents an instant in time. */
public struct Timestamp: Comparable, Hashable {
	public let nsTimeInterval: NSTimeInterval

	public static var currentTimestamp: Timestamp {
		return Timestamp(CACurrentMediaTime())
	}

	init(_ nsTimeInterval: NSTimeInterval) {
		self.nsTimeInterval = nsTimeInterval
	}

	public var hashValue: Int {
		return nsTimeInterval.hashValue
	}
}

public func <(a: Timestamp, b: Timestamp) -> Bool {
	return a.nsTimeInterval < b.nsTimeInterval
}

public func ==(a: Timestamp, b: Timestamp) -> Bool {
	return a.nsTimeInterval == b.nsTimeInterval
}

public func -(a: Timestamp, b: Timestamp) -> TimeInterval {
	return a.nsTimeInterval - b.nsTimeInterval
}


// MARK: -

/** Performs an action after a duration. */
public func afterDuration(duration: TimeInterval, action: () -> Void) {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), action)
}
