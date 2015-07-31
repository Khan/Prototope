//
//  MathBridge.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import Prototope
import JavaScriptCore

public struct MathBridge: BridgeType {
	public static func addToContext(context: JSContext) {
		let interpolateTrampoline: @objc_block NSDictionary -> Double = { args in
			Prototope.interpolate(
				from: (args["from"] as! Double?) ?? 0,
				to: (args["to"] as! Double?) ?? 0,
				at: (args["at"] as! Double?) ?? 0
			)
		}
		context.setFunctionForKey("interpolate", fn: interpolateTrampoline)

		let mapTrampoline: @objc_block NSDictionary -> Double = { args in
			let fromInterval = (args["fromInterval"] as! [Double]?) ?? [0, 0]
			let toInterval = (args["toInterval"] as! [Double]?) ?? [0, 0]
			return Prototope.map(
				(args["value"] as! Double?) ?? 0,
				fromInterval: (fromInterval[0], fromInterval[1]),
				toInterval: (toInterval[0], toInterval[1])
			)
		}
		context.setFunctionForKey("map", fn: mapTrampoline)

		let clipTrampoline: @objc_block NSDictionary -> Double = { args in
			Prototope.clip(
				(args["value"] as! Double?) ?? 0,
				min: (args["min"] as! Double?) ?? 0,
				max: (args["max"] as! Double?) ?? 0
			)
		}
		context.setFunctionForKey("clip", fn: clipTrampoline)
		
		let pixelAwareCeil: @objc_block NSDictionary -> Double = { args in
			Prototope.pixelAwareCeil(
				(args["value"] as! Double?) ?? 0
			)
		}
		context.setFunctionForKey("pixelAwareCeil", fn: pixelAwareCeil)
		
		let pixelAwareFloor: @objc_block NSDictionary -> Double = { args in
			Prototope.pixelAwareFloor(
				(args["value"] as! Double?) ?? 0
			)
		}
		context.setFunctionForKey("pixelAwareFloor", fn: pixelAwareCeil)
	}
}
