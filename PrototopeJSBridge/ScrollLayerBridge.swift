//
//  ScrollLayerBridge.swift
//  Prototope
//
//  Created by Jason Brennan on 2015-02-11.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

@objc public protocol ScrollLayerJSExport: JSExport {
	init?(args: NSDictionary)

	var scrollableSize: SizeJSExport { get set }
	var showsVerticalScrollIndicator: Bool { get set }
	var showsHorizontalScrollIndicator: Bool { get set }

	var decelerationRetargetingHandler: JSValue { get set }

	func updateScrollableSizeToFitSublayers()
}


@objc public class ScrollLayerBridge: LayerBridge, ScrollLayerJSExport, BridgeType {
	var scrollLayer: ScrollLayer { return layer as! ScrollLayer }
	
	public override class func addToContext(context: JSContext) {
		context.setObject(self, forKeyedSubscript: "ScrollLayer")
	}
	
	required public init?(args: NSDictionary) {
		let parentLayer = (args["parent"] as! LayerBridge?)?.layer
		let name = args["name"] as! String?
		
		let scrollLayer = ScrollLayer(parent: parentLayer, name: name)
		super.init(scrollLayer)
		
	}
	
	
	/** The scrollable size of the layer. */
	public var scrollableSize: SizeJSExport {
		get { return SizeBridge(self.scrollLayer.scrollableSize) }
		set { self.scrollLayer.scrollableSize = (newValue as! SizeBridge).size }
	}
	
	
	/** Controls whether or not the vertical scroll indicator shows on scroll. Defaults to `true`. */
	public var showsVerticalScrollIndicator: Bool {
		get { return self.scrollLayer.showsVerticalScrollIndicator }
		set { self.scrollLayer.showsVerticalScrollIndicator = newValue }
	}
	
	
	/** Controls whether or not the horizontal scroll indicator shows on scroll. Defaults to `true`. */
	public var showsHorizontalScrollIndicator: Bool {
		get { return self.scrollLayer.showsHorizontalScrollIndicator }
		set { self.scrollLayer.showsHorizontalScrollIndicator = newValue }
	}

	/** This handler provides an opportunity to change the way a scroll layer decelerates.

	It will be called when the user lifts their finger from the scroll layer. The system will provide the user's velocity (in points per second) when they lifted their finger, along with a computed deceleration target (i.e. the point where the scroll view will stop decelerating). If you specify a non-nil handler, the point you return from this handler will be used as the final deceleration target for a decelerating scroll layer. You can return the original deceleration target if you don't need to modify it. **/
	public var decelerationRetargetingHandler: JSValue {
		get {
			return managedDecelerationRetargetingHandler?.value ?? JSValue(undefinedInContext: JSContext.currentContext())
		}
		set {
			managedDecelerationRetargetingHandler = JSManagedValue(value: newValue)
		}
	}

	private var managedDecelerationRetargetingHandler: JSManagedValue? {
		didSet {
			if let managedDecelerationRetargetingHandler = managedDecelerationRetargetingHandler?.value {
				scrollLayer.decelerationRetargetingHandler = { [weak scrollLayer = self.scrollLayer] velocity, target in
					let targetValue = managedDecelerationRetargetingHandler.callWithArguments([PointBridge(velocity), PointBridge(target)])
					if let newTarget = targetValue?.toObject() as? PointBridge {
						return newTarget.point
					} else {
						Environment.currentEnvironment?.exceptionHandler("Invalid retargeted deceleration for \(scrollLayer?.description)")
						return target
					}
				}
			} else {
				scrollLayer.decelerationRetargetingHandler = nil
			}
		}
	}


	/** Updates the scrollable size of the layer to fit its subviews exactly. Does not change the size of the layer, just its scrollable area. */
	public func updateScrollableSizeToFitSublayers() {
		self.scrollLayer.updateScrollableSizeToFitSublayers()
	}
}