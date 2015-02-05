//
//  GestureBridgeTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/4/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import PrototopeJSBridge
import XCTest

class GestureBridgeTests: JSBridgeTestCase {
	func testTouchSampleBridging() {
		let touchSampleValue = context.evaluateScript("new TouchSample({globalLocation: new Point({x: 5, y: 10}), timestamp: 20.0})")
		let globalLocationBridge = touchSampleValue.valueForProperty("globalLocation").toObject() as PointBridge
		XCTAssertEqual(globalLocationBridge.x, 5)
		XCTAssertEqual(globalLocationBridge.y, 10)
		XCTAssertEqual(touchSampleValue.valueForProperty("timestamp").toDouble(), 20)
	}
}
