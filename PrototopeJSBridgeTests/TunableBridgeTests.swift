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
		XCTAssertEqual(context.evaluateScript("tunable({name: 'foo', default: 1.0})").toDouble(), 1)
		XCTAssertEqual(context.evaluateScript("tunable({name: 'bar', default: true})").toBool(), true)
		XCTAssertEqual(context.evaluateScript("var output = null; tunable({name: 'baz', default: 50, changeHandler: function (value) { output = value; }}); output").toDouble(), 50)
		XCTAssertEqual(context.evaluateScript("var output = null; tunable({name: 'bat', default: true, changeHandler: function (value) { output = value; }}); output").toBool(), true)
	}
}