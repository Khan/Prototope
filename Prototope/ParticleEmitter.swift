//
//  ParticleEmitter.swift
//  Prototope
//
//  Created by Jason Brennan on Feb-05-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation

/** A particle emitter shows one or more kinds of Particles, and can show them in different formations. */
public class ParticleEmitter {
	let particles: [Particle]
	
	let emitterLayer = CAEmitterLayer()
	
	/** Creates a particle emitter with an array of particles. */
	public init(particles: [Particle]) {
		self.particles = particles
		self.emitterLayer.emitterCells = self.particles.map {
			(particle: Particle) -> AnyObject in
			return particle.emitterCell
		}
	}
	
	
	/** Creates a particle emitter with one kind of particle. */
	public convenience init(particle: Particle) {
		self.init(particles: [particle])
	}
	
	
	/** How often new baby particles are born. */
	public var birthRate: Double {
		get { return Double(self.emitterLayer.birthRate) }
		set { self.emitterLayer.birthRate = Float(newValue) }
	}
	
	/** The render mode of the emitter. */
	public var renderMode: String {
		get { return self.emitterLayer.renderMode }
		set { self.emitterLayer.renderMode = newValue }
	}
	
	
	/** The shape of the emitter. c.f., CAEmitterLayer for valid strings. */
	public var shape: String {
		get { return self.emitterLayer.emitterShape }
		set { self.emitterLayer.emitterShape = newValue }
	}

	/** The mode of the emission shape. c.f. CAEmitterLayer for valid strings.
		TODO make a real enum for this, lazy bum. */
	public var shapeMode: String {
		get { return self.emitterLayer.emitterMode }
		set { self.emitterLayer.emitterMode = newValue }
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
	
	
	/** The x position of the emitter. This is a shortcut for `position`. */
	public var x: Double {
		get { return self.position.x }
		set { self.position = Point(x: newValue, y: self.y) }
	}
	
	
	/** The y position of the emitter. This is a shortcut for `position`. */
	public var y: Double {
		get { return self.position.y }
		set { self.position = Point(x: self.x, y: newValue) }
	}
}
