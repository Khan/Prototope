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
	/** Creates a sound from a filename. No need to include the file extension: Prototope will
		try all the valid extensions. */
	public init!(name: String) {
		if let cachedSound = cachedSounds[name] {
			self = cachedSound
		} else {
			if let URL = Sound.bundleURLForSoundNamed(name) {
				player = AVAudioPlayer(contentsOfURL: URL, error: nil)
				cachedSounds[name] = self
			} else {
				return nil
			}
		}
	}

	public func play() {
		player.play()
	}

	// MARK: Private interfaces

	private static let validExtensions = ["caf", "aif", "aiff", "wav"]
	private let player: AVAudioPlayer

	private static func bundleURLForSoundNamed(name: String) -> NSURL? {
		for fileExtension in validExtensions {
			if let URL = NSBundle.mainBundle().URLForResource(name, withExtension: fileExtension) {
				return URL
			}
		}
		return nil
	}
}

// They live forever, of course. If that's a problem, we'll deal with it later.
private var cachedSounds = [String: Sound]()
