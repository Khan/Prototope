//
//  Particle.swift
//  Prototope
//
//  Created by Jason Brennan on Feb-03-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit


/** Particles represent little pieces of some kind of animation, like confetti or rain drops or sparkles or flames, etc. */
public struct Particle {
	
	let image: Image
	let emitterCell: CAEmitterCell
	
	
	/** Create a new particle with the given image name and optional preset. */
	public init(imageName: String, preset: ParticlePreset = .IKnowWhatImDoing) {
		self.image = Image(name: imageName)
		
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
	
	
	/** The spin of particles. Positive values spin clockwise, negative values spin counter-clockwise. */
	public var spin: Radian {
		get { return Radian(self.emitterCell.spin) }
		set { self.emitterCell.spin = CGFloat(newValue) }
	}
	
	
	/** The spin range of particles. Positive values spin clockwise, negative values spin counter-clockwise. */
	public var spinRange: Radian {
		get { return Radian(self.emitterCell.spinRange) }
		set { self.emitterCell.spinRange = CGFloat(newValue) }
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
	
	
	/** The speed of red in the particle. */
	public var redSpeed: Double {
		get { return Double(self.emitterCell.redSpeed) }
		set { self.emitterCell.redSpeed = Float(newValue) }
	}
	
	/** The speed of blue in the particle. */
	public var blueSpeed: Double {
		get { return Double(self.emitterCell.blueSpeed) }
		set { self.emitterCell.blueSpeed = Float(newValue) }
	}
	
	/** The speed of green in the particle. */
	public var greenSpeed: Double {
		get { return Double(self.emitterCell.greenSpeed) }
		set { self.emitterCell.greenSpeed = Float(newValue) }
	}
	
	/** The speed of alpha in the particle. */
	public var alphaSpeed: Double {
		get { return Double(self.emitterCell.alphaSpeed) }
		set { self.emitterCell.alphaSpeed = Float(newValue) }
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

