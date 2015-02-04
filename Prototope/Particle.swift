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
		
		self.emitterCell.lifetime = 3
		self.emitterCell.lifetimeRange = 3
		
		self.emitterCell.birthRate = 80
		
		self.emitterCell.velocity = 100
		
		self.emitterCell.emissionRange = CGFloat(M_PI) * 2.0
		
		self.emitterCell.color = Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).CGColor
		
		self.emitterCell.redRange = 1.0
		self.emitterCell.blueRange = 1.0
		self.emitterCell.greenRange = 1.0
		self.emitterCell.alphaRange = 1.0
	}
}


extension Layer {
	
	public func emitParticle(particle: Particle) {
		let emitter = CAEmitterLayer()
		emitter.birthRate = 1
		emitter.emitterCells = [particle.emitterCell]
		emitter.emitterMode = kCAEmitterLayerAdditive
		
		self.view.layer.addSublayer(emitter)
		self.view.clipsToBounds = false
	}
}
