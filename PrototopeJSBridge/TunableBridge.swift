//
//  TunableBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

public struct TunableBridge: BridgeType {
	public static func addToContext(context: JSContext) {
		let tunableTrampoline: @objc_block JSValue -> NSNumber = { TunableBridge.tunable($0) }
		context.setFunctionForKey("tunable", fn: tunableTrampoline)
	}

	private static func tunable(args: JSValue) -> NSNumber {
		let nameValue = args.objectForKeyedSubscript("name")
		let defaultValueValue = args.objectForKeyedSubscript("default")
		let minValue = args.objectForKeyedSubscript("min")
		let maxValue = args.objectForKeyedSubscript("max")
		let maintainValue = args.objectForKeyedSubscript("changeHandler")

		let name = nameValue.isUndefined() ? nil : nameValue.toString()
		let defaultValue = defaultValueValue.isUndefined() ? nil : defaultValueValue.toNumber()
		let min: Double? = minValue.isUndefined() ? nil : minValue.toDouble()
		let max: Double? = maxValue.isUndefined() ? nil : maxValue.toDouble()
		let maintain: JSValue? = maintainValue.isUndefined() ? nil : maintainValue

		if let name = name {
			if let defaultValue = defaultValue {
				let someDouble: NSNumber = 1.0
				if String.fromCString(defaultValue.objCType) == String.fromCString(someDouble.objCType) {
						if let maintainCallable = maintain {
						var result: Double = 0
						Prototope.tunable(defaultValue.doubleValue, name: name, min: min, max: max, changeHandler: { value in
							result = value
							maintainCallable.callWithArguments([value])
						})
						return result
					} else {
						return Prototope.tunable(defaultValue.doubleValue, name: name, min: min, max: max)
					}
				} else {
					if let maintainCallable = maintain {
						var result = false
						Prototope.tunable(defaultValue.boolValue, name: name, changeHandler: { value in
							result = value
							maintainCallable.callWithArguments([value])
						})
						return result
					} else {
						return Prototope.tunable(defaultValue.boolValue, name: name)
					}
				}
			}
		}
		return 0
	}
}
