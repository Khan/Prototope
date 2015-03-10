//
//  ParticleBridge.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-10.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore


@objc public protocol ParticleJSExport: JSExport {
	init?(args: NSDictionary)
	
	
	var lifetime: Double { get set }
	var lifetimeRange: Double { get set }
	var birthRate: Double { get set }
	var scale: Double { get set }
	var scaleRange: Double { get set }
	var spin: Radian { get set }
	var spinRange: Radian { get set }
	var velocity: Double { get set }
	var velocityRange: Double { get set }
	var emissionRange: Radian { get set }
	var color: ColorBridge { get set }
	var redRange: Double { get set }
	var blueRange: Double { get set }
	var greenRange: Double { get set }
	var alphaRange: Double { get set }
	var redSpeed: Double { get set }
	var blueSpeed: Double { get set }
	var greenSpeed: Double { get set }
	var alphaSpeed: Double { get set }
	var xAcceleration: Double { get set }
	var yAcceleration: Double { get set }
	var zAcceleration: Double { get set }
}

@objc public class ParticleBridge: NSObject, ParticleJSExport, BridgeType {
	var particle: Particle!
	
	public class func bridgedPrototypeInContext(context: JSContext) -> JSValue { return JSValue(object: self, inContext: context) }
	public static var bridgedConstructorName: String = "Particle"

	required public init?(args: NSDictionary) {
		if let imageName = args["imageName"] as! String? {
			// TODO(jb): Particle preset.
			self.particle = Particle(imageName: imageName)
			super.init()
		} else {
			super.init()
			return nil
		}
	}
	
	
	// MARK: - Particle properties
	
	/** The lifetime, in seconds, of particles. */
	public var lifetime: Double {
		get { return self.particle.lifetime }
		set { self.particle.lifetime = newValue }
	}
	
	
	/** The range of variation for the particle's lifetime. */
	public var lifetimeRange: Double {
		get { return self.particle.lifetimeRange }
		set { self.particle.lifetimeRange = newValue }
	}
	
	
	/** The birth rate, in particle / second, for new particles. */
	public var birthRate: Double {
		get { return self.particle.birthRate }
		set { self.particle.birthRate = newValue }
	}
	
	
	/** The scale of the particles. */
	public var scale: Double {
		get { return self.particle.scale }
		set { self.particle.scale = newValue }
	}
	
	
	/** The range of particle scale. */
	public var scaleRange: Double {
		get { return self.particle.scaleRange }
		set { self.particle.scaleRange = newValue }
	}
	
	
	/** The spin of particles. Positive values spin clockwise, negative values spin counter-clockwise. */
	public var spin: Radian {
		get { return self.particle.spin }
		set { self.particle.spin = newValue }
	}
	
	
	/** The spin range of particles. Positive values spin clockwise, negative values spin counter-clockwise. */
	public var spinRange: Radian {
		get { return self.particle.spinRange }
		set { self.particle.spinRange = newValue }
	}
	
	
	/** The velocity of particles. */
	public var velocity: Double {
		get { return self.particle.velocity }
		set { self.particle.velocity = newValue }
	}
	
	
	/** The velocity range of particles. */
	public var velocityRange: Double {
		get { return self.particle.velocityRange }
		set { self.particle.velocityRange = newValue }
	}
	
	
	/** The emission range, in radians. Particles are uniformly distributed in this range.
		
		Set to a full circle (2π) for a full circular range. */
	public var emissionRange: Radian {
		get { return self.particle.emissionRange }
		set { self.particle.emissionRange = newValue }
	}
	
	
	/** The colour of the particle. */
	public var color: ColorBridge {
		get { return ColorBridge(self.particle.color) }
		set { self.particle.color = newValue.color }
	}
	
	
	/** The range of red in the particle. */
	public var redRange: Double {
		get { return self.particle.redRange }
		set { self.particle.redRange = newValue }
	}
	
	/** The range of blue in the particle. */
	public var blueRange: Double {
		get { return self.particle.blueRange }
		set { self.particle.blueRange = newValue }
	}
	
	/** The range of green in the particle. */
	public var greenRange: Double {
		get { return self.particle.greenRange }
		set { self.particle.greenRange = newValue }
	}
	
	/** The range of alpha in the particle. */
	public var alphaRange: Double {
		get { return self.particle.alphaRange }
		set { self.particle.alphaRange = newValue }
	}
	
	
	/** The speed of red in the particle. */
	public var redSpeed: Double {
		get { return self.particle.redSpeed }
		set { self.particle.redSpeed = newValue }
	}
	
	/** The speed of blue in the particle. */
	public var blueSpeed: Double {
		get { return self.particle.blueSpeed }
		set { self.particle.blueSpeed = newValue }
	}
	
	/** The speed of green in the particle. */
	public var greenSpeed: Double {
		get { return self.particle.greenSpeed }
		set { self.particle.greenSpeed = newValue }
	}
	
	/** The speed of alpha in the particle. */
	public var alphaSpeed: Double {
		get { return self.particle.alphaSpeed }
		set { self.particle.alphaSpeed = newValue }
	}
	
	
	/** The x acceleration of particles. */
	public var xAcceleration: Double {
		get { return self.particle.xAcceleration }
		set { self.particle.xAcceleration = newValue }
	}
	
	
	/** The y acceleration of particles. */
	public var yAcceleration: Double {
		get { return self.particle.yAcceleration }
		set { self.particle.yAcceleration = newValue }
	}
	
	
	/** The z acceleration of particles. */
	public var zAcceleration: Double {
		get { return self.particle.zAcceleration }
		set { self.particle.zAcceleration = newValue }
	}

	

}
