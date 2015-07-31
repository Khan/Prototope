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
	public init(parent: Layer? = nil, name: String? = nil) {
		super.init(parent: parent, name: name, viewClass: UIScrollView.self)
		scrollView.delegate = scrollViewDelegate
	}

	deinit {
		scrollView.delegate = nil
	}
	
	var scrollView: UIScrollView {
		return self.view as! UIScrollView
	}

	private var scrollViewDelegate = ScrollViewDelegate()
	
	// MARK: - Properties
	
	/** The scroll position of the scroll layer in its own coordinates. */
	public var scrollPosition: Point {
		get { return Point(self.scrollView.contentOffset) }
		set { self.scrollView.contentOffset = CGPoint(newValue) }
	}
	
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

	/** This handler provides an opportunity to change the way a scroll layer decelerates.

		It will be called when the user lifts their finger from the scroll layer. The system will provide the user's velocity (in points per second) when they lifted their finger, along with a computed deceleration target (i.e. the point where the scroll view will stop decelerating). If you specify a non-nil handler, the point you return from this handler will be used as the final deceleration target for a decelerating scroll layer. You can return the original deceleration target if you don't need to modify it. **/
	public var decelerationRetargetingHandler: ((velocity: Point, decelerationTarget: Point) -> Point)? {
		get { return scrollViewDelegate.decelerationRetargetingHandler }
		set { scrollViewDelegate.decelerationRetargetingHandler = newValue }
	}
	
	
	/** This handler is called when the scrollView scrolls. */
	public var didScrollHandler: (() -> ())? {
		didSet {
			self.scrollViewDelegate.didScrollHandler = didScrollHandler
		}
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

	@objc private class ScrollViewDelegate: NSObject, UIScrollViewDelegate {
		var decelerationRetargetingHandler: ((velocity: Point, decelerationTarget: Point) -> Point)?
		var didScrollHandler: (() -> ())?

		@objc func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
			if let decelerationRetargetingHandler = decelerationRetargetingHandler {
				let newTargetContentOffset = decelerationRetargetingHandler(velocity: Point(velocity), decelerationTarget: Point(targetContentOffset.memory))
				targetContentOffset.memory = CGPoint(newTargetContentOffset)
			}
		}
		
		@objc func scrollViewDidScroll(scrollView: UIScrollView) {
			if let didScrollHandler = self.didScrollHandler {
				didScrollHandler()
			}
		}
	}
}
