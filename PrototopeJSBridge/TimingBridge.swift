//
//  TimingBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import JavaScriptCore
import Prototope

public class TimingBridge: BridgeType {
	public class func bridgedPrototypeInContext(context: JSContext) -> JSValue {
		let timestampObject = JSValue(newObjectInContext: context)
		let currentTimestampFunction: @objc_block Void -> Double = { return Prototope.Timestamp.currentTimestamp.nsTimeInterval }
		timestampObject.setFunctionForKey("currentTimestamp", fn: currentTimestampFunction)
		return timestampObject
	}

	public static var bridgedConstructorName: String = "Timestamp"

    public class func addToContext(context: JSContext) {
    	let afterDurationFunction: @objc_block (Double, JSValue) -> Void = { duration, callable in
    		Prototope.afterDuration(duration) {
    			callable.callWithArguments([])
				return
    		}
    	}
		context.setFunctionForKey("afterDuration", fn: afterDurationFunction)
    }
}