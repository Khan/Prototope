//
//  Border.swift
//  Prototope
//
//  Created by Andy Matuschak on 12/1/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

/** A simple specification of a layer border. */
public struct Border {
	public var color: Color

	/** Specifies the width of the border in the border-owning layer's coordinate space. */
	public var width: Double

	public init(color: Color, width: Double) {
		self.color = color
		self.width = width
	}
}