//
//  Heartbeat.swift
//  Prototope
//
//  Created by Andy Matuschak on 11/19/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import QuartzCore

/** Allows you to run code once for every frame the display will render. */
public class Heartbeat {
	/** The heartbeat's handler won't be called when paused is true. Defaults to false. */
	public var paused: Bool {
		get { return displayLink.paused }
		set { displayLink.paused = newValue }
	}

	/** The current timestamp of the heartbeat. Only valid to call from the handler block. */
	public var timestamp: Timestamp {
		return Timestamp(displayLink.timestamp)
	}

	/** The handler will be invoked for every frame to be rendered. It will be passed the
		Heartbeat instance initialized by this constructor (which permits you to access its
		properties from within the closure). */
	public init(handler: Heartbeat -> ()) {
		self.handler = handler
		#if os(iOS)
		displayLink = SystemDisplayLink(target: self, selector: "handleDisplayLink:")
			#else
			displayLink = SystemDisplayLink(heartbeatCallback: handleDisplayLink)
			#endif
		displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
	}

	/** Permanently stops the heartbeat. */
	public func stop() {
		displayLink.invalidate()
	}

    // MARK: Private interfaces
    
    private let handler: Heartbeat -> ()
    private var displayLink: SystemDisplayLink!
    
    @objc private func handleDisplayLink(sender: SystemDisplayLink) {
        precondition(displayLink === sender)
        handler(self)
    }
}


#if os(iOS)
	import UIKit
	typealias SystemDisplayLink = CADisplayLink
	#else
	import AppKit
	typealias SystemDisplayLink = DisplayLink
#endif

