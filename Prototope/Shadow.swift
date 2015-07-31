//
//  Shadow.swift
//  Prototope
//
//  Created by Andy Matuschak on 12/2/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

/** A simple specification of a layer shadow. */
public struct Shadow {
	public var color: Color
	public var alpha: Double
	public var offset: Size
	public var radius: Double

	public init(color: Color, alpha: Double, offset: Size, radius: Double) {
		self.color = color
		self.alpha = alpha
		self.offset = offset
		self.radius = radius
	}
}

