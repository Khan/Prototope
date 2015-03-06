//
//  Sound.swift
//  Prototope
//
//  Created by Andy Matuschak on 11/19/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import AVFoundation
import Foundation

/** Provides a simple way to play sound files. Supports .aif, .aiff, .wav, and .caf files. */
public struct Sound {

	private let player: AVAudioPlayer

	/** Creates a sound from a filename. No need to include the file extension: Prototope will
		try all the valid extensions. */
	public init!(name: String) {
		if let data = Environment.currentEnvironment!.soundProvider(name) {
			player = AVAudioPlayer(data: data, error: nil)
			player.prepareToPlay()
		} else {
            Environment.currentEnvironment?.exceptionHandler("⚠️ Sound named \(name) not found")
            return nil
		}
	}

	public func play() {
		player.currentTime = 0
		player.play()
	}

	public func stop() {
		player.stop()
	}

	public static var supportedExtensions = ["caf", "aif", "aiff", "wav"]
}
