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
		} else {
			return nil
		}
	}

	public func play() {
		player.play()
	}

	public static var supportedExtensions = ["caf", "aif", "aiff", "wav"]
}
