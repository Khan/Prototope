//
//  Particle.swift
//  Prototope
//
//  Created by Jason Brennan on Feb-03-2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

public struct Particle {
	
	let image: Image
	private let emitterCell: CAEmitterCell
	
	public init(image: Image) {
		self.image = image
		
		self.emitterCell = CAEmitterCell()
		self.emitterCell.contents = self.image.uiImage.CGImage
		
		self.lifetime = 3
		self.lifetimeRange = 3
		
		self.birthRate = 80
		
		self.velocity = 100
		
		self.emissionRangeInRadians = M_PI * 2.0
		
		self.color = Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
		
		self.redRange = 1.0
		self.blueRange = 1.0
		self.greenRange = 1.0
		self.alphaRange = 1.0
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
	
	
	/** The velocity of particles. */
	public var velocity: Double {
		get { return Double(self.emitterCell.velocity) }
		set { self.emitterCell.velocity = CGFloat(newValue) }
	}
	
	
	/** The emission range, in radians. Particles are uniformly distributed in this range.
		
		Set to a full circle (2π) for a full circular range. */
	public var emissionRangeInRadians: Double {
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
}


extension Layer {
	
	public func emitParticle(particle: Particle) {
		let emitter = CAEmitterLayer()
		emitter.birthRate = 1
		emitter.emitterCells = [particle.emitterCell]
		emitter.renderMode = kCAEmitterLayerAdditive
		emitter.bounds = self.view.layer.bounds
		emitter.backgroundColor = UIColor.blackColor().CGColor
		
		self.view.layer.addSublayer(emitter)
		self.view.clipsToBounds = false
	}
}
