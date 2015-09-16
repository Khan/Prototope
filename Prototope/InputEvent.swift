//
//  InputEvent.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-08-17.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import AppKit

/* Represents input from a person, like pointer (mouse) or keyboard. */
public struct InputEvent {
	let event: NSEvent
	
	public var globalLocation: Point {
		let rootView = Environment.currentEnvironment!.rootLayer.view
		return Point(rootView.convertPoint(event.locationInWindow, fromView: nil))
	}
}
