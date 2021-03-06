//
//  VideoLayerBridge.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-10.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol VideoLayerJSExport: JSExport {
	init?(args: NSDictionary)
	func play()
	func pause()
}


@objc public class VideoLayerBridge: LayerBridge, VideoLayerJSExport {
	var videoLayer: VideoLayer { return layer as! VideoLayer }
	
	public override class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "VideoLayer")
	}
	
	required public init?(args: NSDictionary) {
		let parentLayer = (args["parent"] as! LayerBridge?)?.layer
		let video = (args["video"] as! VideoBridge?)?.video
		
		let videoLayer = VideoLayer(parent: parentLayer, video: video)
		super.init(videoLayer)
		
	}
	
	public func play() {
		videoLayer.play()
	}
	
	public func pause() {
		videoLayer.pause()
	}
}