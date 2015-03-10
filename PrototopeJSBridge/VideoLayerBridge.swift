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


@objc public class VideoLayerBridge: LayerBridge, VideoLayerJSExport, BridgeType {
	var videoLayer: VideoLayer { return layer as! VideoLayer }
	
	public override class func bridgedPrototypeInContext(context: JSContext) -> JSValue { return JSValue(object: self, inContext: context) }
	public static var bridgedConstructorName: String = "VideoLayer"

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