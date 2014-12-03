//
//  Sound.swift
//  Prototope
//
//  Created by Andy Matuschak on 11/19/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import Foundation
import AudioToolbox

/** Provides a simple way to play sound files. Supports .aif, .aiff, .wav, and .caf files. */
public struct Sound {
	/** Creates a sound from a filename. No need to include the file extension: Prototope will
		try all the valid extensions. */
	public init!(name: String) {
		if let cachedSound = cachedSounds[name] {
			self = cachedSound
		} else {
			if let path = Sound.bundlePathForSoundNamed(name) {
				var soundID: SystemSoundID = 0
				AudioServicesCreateSystemSoundID(NSURL(fileURLWithPath: path), &soundID)
				systemSoundID = soundID
				cachedSounds[name] = self
			} else {
				return nil
			}
		}
	}

	public func play() {
		AudioServicesPlaySystemSound(systemSoundID)
	}

	// MARK: Private interfaces

	private static let validExtensions = ["caf", "aif", "aiff", "wav"]
	private let systemSoundID: SystemSoundID!

	private static func bundlePathForSoundNamed(name: String) -> String? {
		for fileExtension in validExtensions {
			if let path = NSBundle.mainBundle().pathForResource(name, ofType: fileExtension) {
				return path
			}
		}
		return nil
	}
}

// They live forever, of course. If that's a problem, we'll deal with it later.
private var cachedSounds = [String: Sound]()
