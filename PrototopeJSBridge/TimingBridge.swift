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
    public class func addToContext(context: JSContext) {
    	let timestampObject = JSValue(newObjectInContext: context)
    	context.setObject(timestampObject, forKeyedSubscript: "Timestamp")

    	let currentTimestampFunction: @convention(block) Void -> Double = { return Prototope.Timestamp.currentTimestamp.nsTimeInterval }
    	timestampObject.setFunctionForKey("currentTimestamp", fn: currentTimestampFunction)

    	let afterDurationFunction: @convention(block) (Double, JSValue) -> Void = { duration, callable in
    		Prototope.afterDuration(duration) {
    			callable.callWithArguments([])
				return
    		}
    	}
		context.setFunctionForKey("afterDuration", fn: afterDurationFunction)
    }
}