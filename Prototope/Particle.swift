//
//  Particle.swift
//  Prototope
//
//  Created by Jason Brennan on Feb-03-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit


public enum ParticlePreset {
	case Explode
	case Rain
	
	func configureParticle(var particle: Particle) {
		switch self {
		case Explode:
			particle.lifetime = 3
			particle.lifetimeRange = 3
			
			particle.birthRate = 80
			
			particle.velocity = 100
			
			particle.emissionRange = M_PI * 2.0
			
			particle.color = Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
			
			particle.redRange = 1.0
			particle.blueRange = 1.0
			particle.greenRange = 1.0
			particle.alphaRange = 1.0
			
		case Rain:
			particle.lifetime = 4
			particle.lifetimeRange = 5
			particle.birthRate = 25
			particle.velocity = 70
			particle.velocityRange = 160
			particle.yAcceleration = 1000
			particle.emissionRange = Radian.circle
			
			particle.color = Color(red: 0, green: 0, blue: 1, alpha: 0.3)
			particle.redRange = 0
			particle.greenRange = 0
			particle.blueRange = 1.0
			particle.alphaRange = 0.55
			
			particle.scale = 0.4
		}
	}
}

public struct Particle {
	
	let image: Image
	private let emitterCell: CAEmitterCell
	
	
	public init(image: Image, preset: ParticlePreset) {
		self.image = image
		
		self.emitterCell = CAEmitterCell()
		self.emitterCell.contents = self.image.uiImage.CGImage
		
		preset.configureParticle(self)
	}
	
	
	// MARK: - Particle properties
	
	/** The lifetime, in seconds, of particles. */
	public var lifetime: Double {
		get { return Double(self.emitterCell.lifetime) }
		set { self.emitterCell.lifetime = Float(newValue) }
	}
	
	
	/** The range of variation for the particle's lifetime. */
	public var lifetimeRange: Double {
		get { return Double(self.emitterCell.lifetimeRange) }
		set { self.emitterCell.lifetimeRange = Float(newValue) }
	}
	
	
	/** The birth rate, in particle / second, for new particles. */
	public var birthRate: Double {
		get { return Double(self.emitterCell.birthRate) }
		set { self.emitterCell.birthRate = Float(newValue) }
	}
	
	
	/** The scale of the particles. */
	public var scale: Double {
		get { return Double(self.emitterCell.scale) }
		set { self.emitterCell.scale = CGFloat(newValue) }
	}
	
	
	/** The range of particle scale. */
	public var scaleRange: Double {
		get { return Double(self.emitterCell.scaleRange) }
		set { self.emitterCell.scaleRange = CGFloat(newValue) }
	}
	
	
	/** The velocity of particles. */
	public var velocity: Double {
		get { return Double(self.emitterCell.velocity) }
		set { self.emitterCell.velocity = CGFloat(newValue) }
	}
	
	
	/** The velocity range of particles. */
	public var velocityRange: Double {
		get { return Double(self.emitterCell.velocityRange) }
		set { self.emitterCell.velocityRange = CGFloat(newValue) }
	}
	
	
	/** The emission range, in radians. Particles are uniformly distributed in this range.
		
		Set to a full circle (2π) for a full circular range. */
	public var emissionRange: Radian {
		get { return Double(self.emitterCell.emissionRange) }
		set { self.emitterCell.emissionRange = CGFloat(newValue) }
	}
	
	
	/** The colour of the particle. */
	public var color: Color {
		get { return Color(UIColor(CGColor: self.emitterCell.color)) }
		set { self.emitterCell.color = newValue.CGColor }
	}
	
	
	/** The range of red in the particle. */
	public var redRange: Double {
		get { return Double(self.emitterCell.redRange) }
		set { self.emitterCell.redRange = Float(newValue) }
	}
	
	/** The range of blue in the particle. */
	public var blueRange: Double {
		get { return Double(self.emitterCell.blueRange) }
		set { self.emitterCell.blueRange = Float(newValue) }
	}
	
	/** The range of green in the particle. */
	public var greenRange: Double {
		get { return Double(self.emitterCell.greenRange) }
		set { self.emitterCell.greenRange = Float(newValue) }
	}
	
	/** The range of alpha in the particle. */
	public var alphaRange: Double {
		get { return Double(self.emitterCell.alphaRange) }
		set { self.emitterCell.alphaRange = Float(newValue) }
	}
	
	
	/** The x acceleration of particles. */
	public var xAcceleration: Double {
		get { return Double(self.emitterCell.xAcceleration) }
		set { self.emitterCell.xAcceleration = CGFloat(newValue)}
	}
	
	
	/** The y acceleration of particles. */
	public var yAcceleration: Double {
		get { return Double(self.emitterCell.yAcceleration) }
		set { self.emitterCell.yAcceleration = CGFloat(newValue)}
	}
	
	
	/** The z acceleration of particles. */
	public var zAcceleration: Double {
		get { return Double(self.emitterCell.zAcceleration) }
		set { self.emitterCell.zAcceleration = CGFloat(newValue)}
	}
	
	
}


extension Layer {
	
	public func emitParticle(particle: Particle) {
		let emitter = CAEmitterLayer()
		emitter.birthRate = 1
		emitter.emitterCells = [particle.emitterCell]
		emitter.renderMode = kCAEmitterLayerAdditive
		emitter.frame = self.view.layer.bounds
		emitter.emitterShape = kCAEmitterLayerLine

		self.view.layer.addSublayer(emitter)
		self.view.clipsToBounds = false
		
		emitter.emitterPosition = emitter.position
		emitter.emitterSize = emitter.bounds.size
	}
}
