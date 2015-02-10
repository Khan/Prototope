//
//  JSTest.swift
//  Prototope
//
//  Created by Andy Matuschak on 1/30/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import PrototopeJSBridge
import JavaScriptCore

func makeJSLayer() {
	let context = Context()
	context.exceptionHandler = { value in
		let lineNumber = value.objectForKeyedSubscript("line")
		println("Exception on line \(lineNumber): \(value)")
	}
    
    let script = NSString(contentsOfURL: NSBundle.mainBundle().URLForResource("JSTest", withExtension: "js")!, encoding: NSUTF8StringEncoding, error: nil)!
	println(context.evaluateScript(script as String))
}