//
//  Heartbeat.swift
//  Prototope
//
//  Created by Andy Matuschak on 11/19/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import QuartzCore

public class Heartbeat {
	public var paused: Bool {
		get { return displayLink.paused }
		set { displayLink.paused = newValue }
	}

	public var timestamp: Timestamp {
		return displayLink.timestamp
	}

	private let handler: Heartbeat -> ()
	private let displayLink: CADisplayLink!

	public init(handler: Heartbeat -> ()) {
		self.handler = handler
		displayLink = CADisplayLink(target: self, selector: "handleDisplayLink:")
		displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
	}

	public func stop() {
		displayLink.invalidate()
	}

	@objc private func handleDisplayLink(sender: CADisplayLink) {
		precondition(displayLink === sender)
		handler(self)
	}
}