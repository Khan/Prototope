//
//  ParticleEmitterBridge.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-11.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol ParticleEmitterJSExport: JSExport {
	init?(args: NSDictionary)
	
	
	var birthRate: Double { get set }
	var renderMode: String { get set }
	var shape: String { get set }
	var size: SizeBridge { get set }
	var position: PointBridge { get set }
	var x: Double { get set }
	var y: Double { get set }
	var emitterBridge: ParticleEmitterBridge { get }
}

@objc public class ParticleEmitterBridge: NSObject, ParticleEmitterJSExport, BridgeType {
	var emitter: ParticleEmitter!
	
	public class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "ParticleEmitter")
	}
	
	required public init?(args: NSDictionary) {
		if let particleBridge = args["particle"] as! ParticleBridge? {
			self.emitter = ParticleEmitter(particle: particleBridge.particle)
			super.init()
		} else {
			super.init()
			return nil
		}
	}
	
	
	// MARK: Properties
	
	/** How often new baby particles are born. */
	public var birthRate: Double {
		get { return self.emitter.birthRate }
		set { self.emitter.birthRate = newValue }
	}
	
	
	/** The render mode of the emitter. */
	public var renderMode: String {
		get { return self.emitter.renderMode }
		set { self.emitter.renderMode = newValue }
	}
	
	
	/** The shape of the emitter. c.f., CAemitter for valid strings. */
	public var shape: String {
		get { return self.emitter.shape }
		set { self.emitter.shape = newValue }
	}
	
	
	/** The render mode of the emitter. */
	public var size: SizeBridge {
		get { return SizeBridge(self.emitter.size) }
		set { self.emitter.size = newValue.size }
	}
	
	
	/** The render mode of the emitter. */
	public var position: PointBridge {
		get { return PointBridge(self.emitter.position) }
		set { self.emitter.position = newValue.point }
	}
	
	
	/** The x position of the emitter. This is a shortcut for `position`. */
	public var x: Double {
		get { return self.position.x }
		set { self.position = PointBridge(Point(x: newValue, y: self.y)) }
	}
	
	
	/** The y position of the emitter. This is a shortcut for `position`. */
	public var y: Double {
		get { return self.position.y }
		set { self.position = PointBridge(Point(x: self.x, y: newValue)) }
	}
	
	
	public var emitterBridge: ParticleEmitterBridge {
		return self
	}
}