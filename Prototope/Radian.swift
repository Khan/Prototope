//
//  Radian.swift
//  Prototope
//
//  Created by Jason Brennan on Feb-05-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

/** For when we're dealing with radians, this type makes it more explicit. */
public typealias Radian = Double

extension Radian {
	
	/** One full revolution in radians. */
	static let circle = 2.0 * M_PI
	
	
	/** Initialize a radian with degrees. */
	public init(degrees: Double) {
		self.init(degrees * M_PI / 180)
	}
}