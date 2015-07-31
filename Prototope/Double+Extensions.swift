//
//  Double+Extensions.swift
//  Prototope
//
//  Created by Jason Brennan on Apr-21-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

public extension Double {
	
	/** If self is not a number (i.e., NaN), returns 0. Otherwise returns self. */
	var notNaNValue: Double {
		return self.isNaN ? 0 : self
	}
}
