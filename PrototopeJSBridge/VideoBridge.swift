//
//  VideoBridge.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-10.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol VideoJSExport: JSExport {
	init?(args: NSDictionary)
	func play()
	func pause()
}

@objc public class VideoBridge: NSObject, VideoJSExport, BridgeType {
	var video: Video!
	
	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Video")
	}
	
	required public init?(args: NSDictionary) {
		if let videoName = args["name"] as! String? {
			video = Video(name: videoName)
			super.init()
		} else {
			super.init()
			return nil
		}
	}
	
	public func play() {
		video.play()
	}
	
	public func pause() {
		video.pause()
	}
}