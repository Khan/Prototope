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

	private let vm = JSVirtualMachine()
	private let context: JSContext

	public init() {
		context = JSContext(virtualMachine: vm)
		addBridgedTypes()
	}

	public func evaluateScript(script: String!) -> JSValue {
		return context.evaluateScript(script)
	}

	private func addBridgedTypes() {
		let console = JSValue(newObjectInContext: context)
		let loggingTrampoline: @objc_block JSValue -> Void = { value in
			println(JSContext.currentArguments())
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
	}
}