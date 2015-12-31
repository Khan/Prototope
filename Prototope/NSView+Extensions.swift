//
//  NSView+Extensions.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-08-17.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import AppKit

extension NSView {
	var frameCenter: Point {
		get { return Point(CGPoint(x: NSMidX(frame), y: NSMidY(frame))) }
		set {
			let center = CGPoint(newValue)
			setFrameOrigin(CGPoint(x: center.x - frame.width / 2.0, y: center.y - frame.height / 2.0))
		}
	}
}
