//
//  TunableBridgeTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import PrototopeJSBridge
import XCTest

class TunableBridgeTests: JSBridgeTestCase {
	func testTunableBridging() {
		XCTAssertEqual(context.evaluateScript("tunable({name: 'foo', defaultValue: 1.0})").toDouble(), 1)
		XCTAssertEqual(context.evaluateScript("tunable({name: 'bar', defaultValue: true})").toBool(), true)
		XCTAssertEqual(context.evaluateScript("var output = null; tunable({name: 'baz', defaultValue: 50, maintain: function (value) { output = value; }}); output").toDouble(), 50)
		XCTAssertEqual(context.evaluateScript("var output = null; tunable({name: 'bat', defaultValue: true, maintain: function (value) { output = value; }}); output").toBool(), true)
	}
}