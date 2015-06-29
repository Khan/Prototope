//
//  SoundBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol SoundJSExport: JSExport {
	init?(args: NSDictionary)
	func play()
	func stop()
	var volume: Double { get set }
}

@objc public class SoundBridge: NSObject, SoundJSExport, BridgeType {
	var sound: Sound!

	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Sound")
	}

	required public init?(args: NSDictionary) {
		if let soundName = args["name"] as! String?, let sound = Sound(name: soundName) {
			self.sound = sound
			super.init()
		} else {
			super.init()
			return nil
		}
	}
	
	public override var description: String {
		return sound.description
	}

	public func play() {
		sound.play()
	}

	public func stop() {
		sound.stop()
	}

	/// From 0.0 to 1.0.
	public var volume: Double {
		get { return sound.volume }
		set { sound.volume = newValue }
	}
}
