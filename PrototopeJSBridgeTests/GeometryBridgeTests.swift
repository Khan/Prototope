//
//  GeometryBridgeTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import PrototopeJSBridge
import XCTest

class GeometryBridgeTests: JSBridgeTestCase {
	func testPointBridging() {
		XCTAssertEqual(context.evaluateScript("(new Point({x: 5, y: 10})).y").toDouble(), 10)
		XCTAssertEqual(context.evaluateScript("Point.zero.x").toDouble(), 0)
		XCTAssertEqual(context.evaluateScript("(new Point({x: 2, y: 3})).add(new Point({x: 5})).x").toDouble(), 7)
	}
}