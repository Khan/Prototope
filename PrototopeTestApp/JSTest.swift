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
	let vm = JSVirtualMachine()
	let context = JSContext(virtualMachine: vm)
	context.exceptionHandler = { _, value in println("Exception: \(value)") }
    LayerBridge.addToContext(context)
    ColorBridge.addToContext(context)
	println(context.evaluateScript("var layer = new Layer(Layer.root, 'foo'); layer.frame = {x: 75, y: 80, width: 40, height: 40}; layer.backgroundColor = new Color(0.3, 0.2, 0.5);"))
}