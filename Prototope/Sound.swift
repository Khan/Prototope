//
//  Sound.swift
//  Prototope
//
//  Created by Andy Matuschak on 11/19/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import Foundation
import AudioToolbox

public struct Sound {
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
}

// They live forever, of course. If that's a problem, we'll deal with it later.
private var cachedSounds = [String: Sound]()
