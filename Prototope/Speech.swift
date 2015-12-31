//
//  Speech.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-17.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import AVFoundation

/** Speak text using the built in system text-to-speech system. */
public struct Speech {
	
	#if os(iOS)
	private let synthesizer = AVSpeechSynthesizer()
	#else
	private let synthesizer = NSSpeechSynthesizer()
	#endif
	
	
	private static var speech: Speech {
		struct InnerVoice {
			static let instance = Speech()
		}
		
		return InnerVoice.instance
	}
	
	
	/** Speak the given text with the default system voice. Optionally, specify a speech rate between 0 and 1. 
		Multiple calls to this queue up, so texts are read one after another until done. */
	public static func say(text: String, rate: Float = 0.2) {
		let speaker = Speech.speech.synthesizer
		speaker.say(text, atRate: rate)
	}
	
	
	/** Hush the speech synthesizer at the end of the next word. */
	public static func shhh() {
		let speaker = Speech.speech.synthesizer
		
	}
}


protocol Synthesizer {
	init()
	func say(text: String, atRate: Float)
	func shhh()
}


#if os(iOS)
	extension AVSpeechSynthesizer: Synthesizer {
		func say(text: String, atRate rate: Float) {
			let utterance = AVSpeechUtterance(string: text)
			utterance.rate = rate
			
			self.speakUtterance(utterance)
		}
		
		func shhh() {
			self.stopSpeakingAtBoundary(.Word)
		}
	}
	
	#else
	extension NSSpeechSynthesizer: Synthesizer {
		func say(text: String, atRate rate: Float) {
			self.rate = rate
			self.startSpeakingString(text)
		}
		
		func shhh() {
			self.stopSpeakingAtBoundary(.WordBoundary)
		}
	}
#endif
