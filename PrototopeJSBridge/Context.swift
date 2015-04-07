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
		
		
		
		func addBridgedType<T: BridgeType>(bridgedType: T.Type, toContext context: JSContext) {
			bridgedType.addToContext(context)
			
			if let bridgedNSObject: AnyObject = bridgedType as? NSObject.Type {
				
				let bridgedConstructor = JSValue(object: bridgedNSObject, inContext: context)
				let prototype = bridgedConstructor.valueForProperty("prototype")
				let toStringImpl: @objc_block () -> String = {
					let this = JSContext.currentThis()
					return this.description 
				}
				prototype.setFunctionForKey("toString", fn: toStringImpl)
			}
		}
		
		addBridgedType(LayerBridge.self, toContext: context)
		addBridgedType(ColorBridge.self, toContext: context)
		addBridgedType(BorderBridge.self, toContext: context)
		addBridgedType(ShadowBridge.self, toContext: context)
		addBridgedType(ImageBridge.self, toContext: context)
		addBridgedType(PointBridge.self, toContext: context)
		addBridgedType(SizeBridge.self, toContext: context)
		addBridgedType(RectBridge.self, toContext: context)
		addBridgedType(TunableBridge.self, toContext: context)
		addBridgedType(TimingBridge.self, toContext: context)
		addBridgedType(MathBridge.self, toContext: context)
		addBridgedType(HeartbeatBridge.self, toContext: context)
		addBridgedType(SoundBridge.self, toContext: context)
		addBridgedType(TouchSampleBridge.self, toContext: context)
		addBridgedType(TouchSequenceBridge.self, toContext: context)
		addBridgedType(TapGestureBridge.self, toContext: context)
		addBridgedType(PanGestureBridge.self, toContext: context)
		addBridgedType(SampleSequenceBridge.self, toContext: context)
		addBridgedType(ContinuousGesturePhaseBridge.self, toContext: context)
		addBridgedType(RotationSampleBridge.self, toContext: context)
		addBridgedType(RotationGestureBridge.self, toContext: context)
		addBridgedType(PinchSampleBridge.self, toContext: context)
		addBridgedType(PinchGestureBridge.self, toContext: context)
		addBridgedType(AnimationCurveBridge.self, toContext: context)
		addBridgedType(VideoBridge.self, toContext: context)
		addBridgedType(VideoLayerBridge.self, toContext: context)
		addBridgedType(ParticleBridge.self, toContext: context)
		addBridgedType(ParticleEmitterBridge.self, toContext: context)
		addBridgedType(ScrollLayerBridge.self, toContext: context)
        addBridgedType(CollisionBehaviorBridge.self, toContext: context)
        addBridgedType(ActionBehaviorBridge.self, toContext: context)
        addBridgedType(CollisionBehaviorKindBridge.self, toContext: context)
		addBridgedType(TextLayerBridge.self, toContext: context)
		addBridgedType(SpeechBridge.self, toContext: context)
		addBridgedType(TextAlignmentBridge.self, toContext: context)
		addBridgedType(CameraLayerBridge.self, toContext: context)
		addBridgedType(CameraPositionBridge.self, toContext: context)
        addBridgedType(ShapeLayerBridge.self, toContext: context)
        addBridgedType(SegmentBridge.self, toContext: context)
        addBridgedType(LineCapStyleBridge.self, toContext: context)
        addBridgedType(LineJoinStyleBridge.self, toContext: context)
	}
}