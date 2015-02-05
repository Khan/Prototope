//
//  AnimationBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/5/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import JavaScriptCore
import Prototope

let animateWithDurationBridgingTrampoline: @objc_block JSValue -> Void = { args in
	let durationValue = args.valueForProperty("duration")
	let animationsHandler = args.valueForProperty("animations")
	let completionHandler = args.valueForProperty("completionHandler")

	if !durationValue.isUndefined() && !animationsHandler.isUndefined() {
		Prototope.Layer.animateWithDuration(
			durationValue.toDouble(),
			animations: {
				animationsHandler.callWithArguments([])
				return
			},
			completionHandler: completionHandler.isUndefined() ? nil : {
				completionHandler.callWithArguments([])
				return
			}
		)
	}
}