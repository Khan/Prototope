//
//  MathBridgeTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//


import Foundation
import Prototope
import PrototopeJSBridge
import XCTest

class MathBridgeTests: JSBridgeTestCase {
	func testMathBridging() {
		XCTAssertEqual(context.evaluateScript("interpolate({from: 5, to: 10, at: 0.4})").toDouble(), interpolate(from: 5, to: 10, at: 0.4))
		XCTAssertEqual(context.evaluateScript("map({value: 0.3, fromInterval: [0, 1], toInterval: [0, 10]})").toDouble(), map(0.3, fromInterval: (0, 1), toInterval: (0, 10)))

		let clipResult: Double = clip(5, min: 1, max: 3)
		XCTAssertEqual(context.evaluateScript("clip({value: 5, min: 1, max: 3})").toDouble(), clipResult)
	}
}
