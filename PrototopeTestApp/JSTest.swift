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
	println(context.evaluateScript("var layer = new Layer({parent: Layer.root}); Layer.animate({duration: 3.0, curve: AnimationCurve.EaseOut, animations: function() { layer.x = 400 }}); layer.gestures = [new PinchGesture({handler: function(phase, sequence) {console.log(sequence.currentSample.scale)}})]; layer.backgroundColor = new Color({red: 0.5, green: 0.7, blue: 0.1, alpha: 0.7}); layer.frame = new Rect({x: 75, y: 80, width: 400, height: 400}); layer.border = new Border({color: Color.black, width: 2}); layer.shadow = new Shadow({alpha: 1.0}); (new Sound({name: 'Glass'})).play()"))
}