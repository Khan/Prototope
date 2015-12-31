//
//  DisplayLink.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-08-10.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

/******************************************

OS X Only, folks
(also it's currently pretty broken, sorry!)

*/
import AppKit


typealias HeartbeatDisplayLinkCallback = (sender: SystemDisplayLink) -> Void

/** Crappy wrapper around CVDisplayLink to act pretty close to a CADisplayLink. Only OS X kids get this. */
class DisplayLink: NSObject {

	private let displayLink:CVDisplayLink? = {
		var linkRef:Unmanaged<CVDisplayLink>?
		CVDisplayLinkCreateWithActiveCGDisplays(&linkRef)
		
		return linkRef?.takeUnretainedValue()
	}()
	
	
	/** Starts or stops the display link. */
	var paused: Bool {
		get { return CVDisplayLinkIsRunning(self.displayLink) > 0 }
		set {
			if newValue {
				CVDisplayLinkStop(self.displayLink)
			} else {
				CVDisplayLinkStart(self.displayLink)
			}
		}
	}
	
	var timestamp: NSTimeInterval {
		var outTime: CVTimeStamp = CVTimeStamp()
		CVDisplayLinkGetCurrentTime(self.displayLink, &outTime)
		
		// TODO(jb): I don't know if hostTime is what I want
		return NSTimeInterval(outTime.hostTime)
	}
	
	/** Initialize with a given callback. */
	init(heartbeatCallback: HeartbeatDisplayLinkCallback) {
		
		super.init()
		
		let callback = {(
			_:CVDisplayLink!,
			_:UnsafePointer<CVTimeStamp>,
			_:UnsafePointer<CVTimeStamp>,
			_:CVOptionFlags,
			_:UnsafeMutablePointer<CVOptionFlags>,
			_:UnsafeMutablePointer<Void>)->Void in
			
			heartbeatCallback(sender: self)
		}
		self.dynamicType.DisplayLinkSetOutputCallback(self.displayLink!, callback: callback)
	}
	
	/** Starts the display link, but ignores the parameters. They only exist to keep a compatible API. */
	func addToRunLoop(runLoop: NSRunLoop, forMode: String) {
		self.paused = false
	}
	
	
	/** Stops the display link. */
	func invalidate() {
		self.paused = true
	}

}


// Junk related to wrapping the CVDisplayLink callback function.
extension DisplayLink {
	private typealias DisplayLinkCallback = @objc_block ( CVDisplayLink!, UnsafePointer<CVTimeStamp>, UnsafePointer<CVTimeStamp>, CVOptionFlags, UnsafeMutablePointer<CVOptionFlags>, UnsafeMutablePointer<Void>)->Void
	
	private class func DisplayLinkSetOutputCallback(displayLink:CVDisplayLink, callback:DisplayLinkCallback) {
		let block:DisplayLinkCallback = callback
		let myImp = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
		let callback = unsafeBitCast(myImp, CVDisplayLinkOutputCallback.self)
		
		CVDisplayLinkSetOutputCallback(displayLink, callback, UnsafeMutablePointer<Void>())
	}
}