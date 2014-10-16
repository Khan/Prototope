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
