//
//  VideoLayer.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-09.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit
import AVFoundation

/** This layer can play a video object. */
public class VideoLayer: Layer {
	
	/** The layer's current video. */
	var video: Video? {
		didSet {
			if let video = video {
				self.playerLayer.player = video.player
			}
		}
	}
	
	
	private var playerLayer: AVPlayerLayer {
		return (self.view as VideoView).layer as AVPlayerLayer
	}
	
	/** Creates a video layer with the given video. */
	public init(parent: Layer? = nil, video: Video) {
		self.video = video
		super.init(parent: parent, name: video.name, viewClass: VideoView.self)
		self.playerLayer.player = video.player
	}
	
	
	/** Play the video. */
	public func play() {
		self.video?.player.play()
	}
	
	
	/** Pause the video. */
	public func pause() {
		self.video?.player.pause()
	}
	
	
	/** Underlying video view class. */
	private class VideoView: UIView {
		
		override class func layerClass() -> AnyClass {
			return AVPlayerLayer.self
		}
	}
}


