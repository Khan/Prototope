//
//  HeartbeatBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol HeartbeatJSExport: JSExport {
	init?(args: JSValue)
	var paused: Bool { get set }
	var timestamp: Double { get }
	func stop()
}

@objc public class HeartbeatBridge: NSObject, HeartbeatJSExport, BridgeType {
	var heartbeat: Heartbeat!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Heartbeat")
	}

	required public init?(args: JSValue) {
		super.init()
		let handler = args.objectForKeyedSubscript("handler")
		if !handler.isUndefined() {
			heartbeat = Heartbeat { [weak self] heartbeat in
				if let strongSelf = self {
					handler.callWithArguments([strongSelf])
				}
			}
			JSContext.currentContext().virtualMachine.addManagedReference(self, withOwner: self)
		} else {
			return nil
		}
	}

	public var paused: Bool {
		get { return heartbeat.paused }
		set { heartbeat.paused = paused }
	}

	public var timestamp: Double {
		return heartbeat.timestamp.nsTimeInterval
	}

	public func stop() {
		heartbeat.stop()
		JSContext.currentContext().virtualMachine.removeManagedReference(self, withOwner: self)
	}
}
