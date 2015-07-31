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
			var handlingException = false
			context.exceptionHandler = { [weak self] context, value in
				if let strongSelf = self {
					if handlingException {
						// Exception thrown while normalizing or presenting error -- this indicates a mistake in this code, but bail out here to prevent an infinite loop of exceptions
						let stack = value.valueForProperty("stack")
						println("JS error thrown while handling error:\n\(value)\n\n\(stack)")
						abort()
					}
					handlingException = true
					let normalizedError = strongSelf.normalizeError(value)
					strongSelf.exceptionHandler?(normalizedError)
					handlingException = false
				}
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

	private var scriptCount = 0
	// Map from filename to JS function mapping (line, col) to source info
	private var sourceMappers = [String: JSValue]()

	public init() {
		context = JSContext(virtualMachine: vm)

		loadRuntime()
		addBridgedTypes()
	}

	public func evaluateScript(script: String!) -> JSValue {
		let transformed = context.objectForKeyedSubscript("Protoscope").invokeMethod("transform", withArguments: [script])
		if transformed.isUndefined() {
			// In case of a transform error, an exception will be thrown (and handled by the exception handler), so we get undefined back here and can pass that up in turn.
			return transformed
		}

		// We store the source maps by filename, so that if an exception is thrown (involving code from any loaded script) we can look up the original line number
		let filename = scriptCount == 0 ? "script.js" : "script\(scriptCount + 1).js"
		scriptCount++
		sourceMappers[filename] = transformed.valueForProperty("originalSourcePositionFor")

		let code = transformed.valueForProperty("code").toString()
		return context.evaluateScript(code, withSourceURL: NSURL(string: filename))
	}

	private func originalSourcePositionFor(filename: String, line: Int32, column: Int32) -> (Int32, Int32)? {
		if let mapper = sourceMappers[filename] {
			let position = mapper.callWithArguments([
				JSValue(int32: line, inContext: context),
				JSValue(int32: column, inContext: context)
			])
			let newLine = position.valueForProperty("line").toInt32()
			let newColumn = position.valueForProperty("line").toInt32()
			return (newLine, newColumn)
		} else {
			return nil
		}
	}

	private func normalizeError(error: JSValue) -> JSValue {
		return context.objectForKeyedSubscript("Protoscope").invokeMethod("normalizeError", withArguments: [error, sourceMappers as NSDictionary])
	}

	private func loadRuntime() {
		let path = NSBundle.mainBundle().pathForResource("protoscope-bundle", ofType: "js")
		context.evaluateScript(String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil), withSourceURL: NSURL(string: "protoscope-bundle.js"))
	}

	private func addBridgedTypes() {
		let console = JSValue(newObjectInContext: context)
		let loggingTrampoline: @objc_block JSValue -> Void = { [weak self] value in
			self?.consoleLogHandler?(value.toString())
			return
		}
		console.setFunctionForKey("log", fn: loggingTrampoline)
		context.setObject(console, forKeyedSubscript: "console")
		
		
		// Capturing `context` here (instead of passing it in as a parameter) causes the compiler to segfault as of Swift 1.2b4.
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