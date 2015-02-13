//
//  Layer+Layout.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-13.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit

/** Positioning layers. */
extension Layer {
	
	
	/** The minX of the layer's frame. */
	public var frameMinX: Double {
		get { return self.frame.minX }
		set { self.frame.origin.x = newValue }
	}
	
	
	/** The maxX of the layer's frame. */
	public var frameMaxX: Double { return self.frame.maxX }
	
	
	/** The minY of the layer's frame. */
	public var frameMinY: Double {
		get { return self.frame.minY }
		set { self.frame.origin.y = newValue }
	}
	
	
	/** The maxY of the layer's frame. */
	public var frameMaxY: Double { return self.frame.maxY }
	
	
	/** Moves the receiver to the right of the given sibling layer. */
	public func moveToRightOfSiblingLayer(siblingLayer: Layer, margin: Double = 0.0) {
		self.frameMinX = floor(siblingLayer.frameMaxX + margin)
	}
	
	
	/** Moves the receiver to the left of the given sibling layer. */
	public func moveToLeftOfSiblingLayer(siblingLayer: Layer, margin: Double = 0.0) {
		self.frameMinX = floor(siblingLayer.frameMinX - (self.width + margin))
	}
	
	
	/** Moves the receiver vertically below the given sibling layer. Does not horizontally align automatically. */
	public func moveBelowSiblingLayer(siblingLayer: Layer, margin: Double = 0.0) {
		self.frameMinY = siblingLayer.frameMaxY + margin
	}
	
	
	/** Moves the receiver vertically above the given sibling layer. Does not horizontally align automatically. */
	public func moveAboveSiblingView(siblingView: Layer, margin: Double = 0.0) {
		self.frameMinY = siblingView.frameMinY - (self.height + margin)
	}
	
	
	/** Moves the receiver so that its right side is aligned with the right side of its parent layer. */
	public func moveToRightSideOfParentLayer(margin: Double = 0.0) {
		if let parent = self.parent {
			self.frameMinX = floor(parent.width - self.width - margin)
		}
	}
	
	
	/** Moves the receiver to be vertically centred in its parent. */
	public func moveToVerticalCenterOfParentLayer() {
		if let parent = self.parent {
			self.frameMinY = floor(parent.height / 2.0 - self.height / 2.0)
		}
	}
	
	
	/** Moves the receiver to be horizontally centred in its parent. */
	public func moveToHorizontalCenterOfParentLayer() {
		if let parent = self.parent {
			self.frameMinX = floor(parent.width / 2.0 - self.width / 2.0)
		}
	}
	
	
	/** Moves the receiver to be centered in its parent. */
	public func moveToCenterOfParentLayer() {
		self.moveToVerticalCenterOfParentLayer()
		self.moveToHorizontalCenterOfParentLayer()
	}
	
}

