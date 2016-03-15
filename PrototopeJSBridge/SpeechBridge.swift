//
//  SpeechBridge.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-17.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol SpeechJSExport: JSExport {
}

@objc public class SpeechBridge: NSObject, SpeechJSExport, BridgeType {
	
	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "Speech")
		let speechBridge = context.objectForKeyedSubscript("Speech")
		
		speechBridge.setFunctionForKey("say", fn: sayTrampoline)
	}
	
}


let sayTrampoline: @convention(block) JSValue -> Void = { args in
	let text = args.valueForProperty("text")
	
	if !text.isUndefined {
		Speech.say(text.toString())
	}

}


let shhhTrampoline: @convention(block) JSValue -> Void = { args in
	Speech.shhh()
}