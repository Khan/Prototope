//
//  ScrollLayer.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-11.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import UIKit


/** This layer allows you to scroll sublayers, with inertia and rubber-banding. */
public class ScrollLayer: Layer {
	
	/** Create a layer with an optional parent layer and name. */
	public init(parent: Layer?, name: String?) {
		super.init(parent: parent, name: name, viewClass: UIScrollView.self)
	}
	
	
	var scrollView: UIScrollView {
		return self.view as! UIScrollView
	}
	
	// MARK: - Properties
	
	/** The scrollable size of the layer. */
	public var scrollableSize: Size {
		get { return Size(self.scrollView.contentSize) }
		set { self.scrollView.contentSize = CGSize(newValue) }
	}
	
	
	/** Controls whether or not the vertical scroll indicator shows on scroll. Defaults to `true`. */
	public var showsVerticalScrollIndicator: Bool {
		get { return self.scrollView.showsVerticalScrollIndicator }
		set { self.scrollView.showsVerticalScrollIndicator = newValue }
	}
	
	
	/** Controls whether or not the horizontal scroll indicator shows on scroll. Defaults to `true`. */
	public var showsHorizontalScrollIndicator: Bool {
		get { return self.scrollView.showsHorizontalScrollIndicator }
		set { self.scrollView.showsHorizontalScrollIndicator = newValue }
	}
	
	
	// MARK: - Methods
	
	/** Updates the scrollable size of the layer to fit its subviews exactly. Does not change the size of the layer, just its scrollable area. */
	public func updateScrollableSizeToFitSublayers() {
		var maxRect = CGRect()
		for sublayer in self.sublayers {
			maxRect = CGRectUnion(maxRect, CGRect(sublayer.frame))
		}
		
		self.scrollableSize = Size(maxRect.size)
	}
}
