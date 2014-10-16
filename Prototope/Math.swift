//
//  Math.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/16/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import Foundation

/// Like Processing's lerp()
public func interpolate(from fromValue: Double, to toValue: Double, at fraction: Double) -> Double {
	return fraction * (toValue - fromValue) + fromValue
}

/// Maps a value from one interval to another.
public func map(value: Double, #fromInterval: (Double, Double), #toInterval: (Double, Double)) -> Double {
	return interpolate(from: toInterval.0, to: toInterval.1, at: (value - fromInterval.0) / (fromInterval.1 - fromInterval.0))
}

public func clip<T: Comparable>(value: T, min minValue: T, max maxValue: T) -> T {
	return max(min(value, maxValue), minValue)
}
