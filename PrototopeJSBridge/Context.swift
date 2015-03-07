//
//  Context.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import JavaScriptCore

public class Context {
	public var exceptionHandler: (JSValue -> Void)? {
		didSet {
			context.exceptionHandler = { [exceptionHandler = self.exceptionHandler] context, value in
				exceptionHandler?(value)
				context.exception = nil
				return
			}
		}
	}

    public var consoleLogHandler: (String -> Void)? = { str in
        println(str)
    }

	private let vm = JSVirtualMachine()
	private let context: JSContext

	public init() {
		context = JSContext(virtualMachine: vm)
		addBridgedTypes()
	}

	public func evaluateScript(script: String!) -> JSValue {
		return context.evaluateScript("\"use strict\";" + script)
	}

	private func addBridgedTypes() {
		let console = JSValue(newObjectInContext: context)
		let loggingTrampoline: @objc_block JSValue -> Void = { [weak self] value in
			self?.consoleLogHandler?(value.toString())
			return
		}
		console.setFunctionForKey("log", fn: loggingTrampoline)
		context.setObject(console, forKeyedSubscript: "console")

		LayerBridge.addToContext(context)
		ColorBridge.addToContext(context)
		BorderBridge.addToContext(context)
		ShadowBridge.addToContext(context)
		ImageBridge.addToContext(context)
		PointBridge.addToContext(context)
		SizeBridge.addToContext(context)
		RectBridge.addToContext(context)
		TunableBridge.addToContext(context)
		TimingBridge.addToContext(context)
		MathBridge.addToContext(context)
		HeartbeatBridge.addToContext(context)
		SoundBridge.addToContext(context)
		TouchSampleBridge.addToContext(context)
		TouchSequenceBridge.addToContext(context)
		TapGestureBridge.addToContext(context)
		PanGestureBridge.addToContext(context)
		SampleSequenceBridge.addToContext(context)
		ContinuousGesturePhaseBridge.addToContext(context)
		RotationSampleBridge.addToContext(context)
		RotationGestureBridge.addToContext(context)
		PinchSampleBridge.addToContext(context)
		PinchGestureBridge.addToContext(context)
		AnimationCurveBridge.addToContext(context)
		VideoBridge.addToContext(context)
		VideoLayerBridge.addToContext(context)
		ParticleBridge.addToContext(context)
		ParticleEmitterBridge.addToContext(context)
		ScrollLayerBridge.addToContext(context)
        CollisionBehaviorBridge.addToContext(context)
        ActionBehaviorBridge.addToContext(context)
        CollisionBehaviorKindBridge.addToContext(context)
		TextLayerBridge.addToContext(context)
		SpeechBridge.addToContext(context)
		TextAlignmentBridge.addToContext(context)
		CameraLayerBridge.addToContext(context)
		CameraPositionBridge.addToContext(context)

		// TODO: Wrap all of these types
		wrapBridgedType("TextLayer")
	}

	/// Wraps the global context variable `jsName` in a guard that throws a JS error if the constructor is called as a function, to prevent JavaScriptCore from crashing hard. See https://github.com/Khan/Prototope/issues/25.
	private func wrapBridgedType(jsName: String) {
		let originalType = context.objectForKeyedSubscript(jsName)
		let wrappedType = bridgedTypeWrapper.callWithArguments([originalType])
		context.setObject(wrappedType, forKeyedSubscript: jsName)
	}

	private var bridgedTypeWrapper: JSValue {
		let script = [
			"(function wrap(OriginalConstructor) {",
				"function Constructor() {",
					"if (!(this instanceof Constructor)) {",
						"// TODO: This uses the Swift class name, not the JavaScript name",
						"throw new Error('Use `new` to instantiate ' + OriginalConstructor.name);",
					"}",
					"return new (Function.prototype.bind.apply(OriginalConstructor, arguments));",
				"}",
				"Constructor.prototype = OriginalConstructor.prototype;",
				"// This is sketchy and mutates the original prototype, but seems to work.",
				"Constructor.prototype.constructor = Constructor;",
				"return Constructor;",
			"})"
		]
		return context.evaluateScript("\n".join(script))
	}
}
