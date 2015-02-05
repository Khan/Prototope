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
	println(context.evaluateScript("var layer = new Layer({parent: Layer.root, imageName: 'paint'}); layer.gestures = [new PanGesture({handler: function(phase, sequence) {console.log(sequence.currentSample.globalLocation.x)}})]; layer.backgroundColor = new Color({red: 0.5, green: 0.7, blue: 0.1, alpha: 0.7}); layer.frame = new Rect({x: 75, y: 80, width: 40, height: 40}); layer.border = new Border({color: Color.black, width: 2}); layer.shadow = new Shadow({alpha: 1.0}); layer.size = new Size({width: 76, height: 100}); (new Sound({name: 'Glass'})).play()"))
}