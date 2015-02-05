//
//  ParticleEmitter.swift
//  Prototope
//
//  Created by Jason Brennan on Feb-05-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

public class ParticleEmitter {
	let particles: [Particle]
	
	let emitterLayer = CAEmitterLayer()
	
	public init(particles: [Particle]) {
		self.particles = particles
		self.emitterLayer.emitterCells = self.particles.map {
			(particle: Particle) -> AnyObject in
			return particle.emitterCell
		}
	}
	
	
	/** The render mode of the emitter. */
	public var renderMode: String {
		get { return self.emitterLayer.renderMode }
		set { self.emitterLayer.renderMode = newValue }
	}
	
	
	/** The shape of the emitter. c.f., CAEmitterLayer for valid strings. */
	public var emitterShape: String {
		get { return self.emitterLayer.emitterShape }
		set { self.emitterLayer.emitterShape = newValue }
	}
	
	
	/** The render mode of the emitter. */
	public var size: Size {
		get { return Size(self.emitterLayer.emitterSize) }
		set { self.emitterLayer.emitterSize = CGSize(newValue) }
	}
	
	
	/** The render mode of the emitter. */
	public var position: Point {
		get { return Point(self.emitterLayer.emitterPosition) }
		set { self.emitterLayer.emitterPosition = CGPoint(newValue) }
	}

	public var x: Double {
		get { return self.position.x }
		set { self.position = Point(x: newValue, y: self.y) }
	}
	
	
	public var y: Double {
		get { return self.position.y }
		set { self.position = Point(x: self.x, y: newValue) }
	}
}


//extension Layer {
//	
//	public func emitParticle(particle: Particle) {
//		let emitter = CAEmitterLayer()
//		
//		emitter.emitterCells = [particle.emitterCell]
//		emitter.renderMode = kCAEmitterLayerAdditive
//		emitter.frame = self.view.layer.bounds
//		emitter.emitterShape = kCAEmitterLayerLine
//		
//		self.view.layer.addSublayer(emitter)
//		self.view.clipsToBounds = false
//		
//		emitter.emitterPosition = emitter.position
//		emitter.emitterSize = emitter.bounds.size
//	}
//}