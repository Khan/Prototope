//
//  Video.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-09.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import AVFoundation

/** Represents a video object. Can be any kind iOS natively supports. */
public struct Video {
	
	let name: String
	let player: AVPlayer
	
	/** Initialize the video with a filename. The name must include the file extension. */
	public init?(name: String) {
		self.name = name
		
		if let URL = NSBundle.mainBundle().URLForResource(name, withExtension: nil) {
			self.player = AVPlayer(URL: URL)
		} else {
            Environment.currentEnvironment?.exceptionHandler("⚠️ Video named \(name) not found")
            return nil
		}
	}
}