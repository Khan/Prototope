//
//  TimingBridgeTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import PrototopeJSBridge
import XCTest

class TimingBridgeTests: JSBridgeTestCase {
	func testCurrentTimestampBridging() {
		let firstTimestamp = context.evaluateScript("Timestamp.currentTimestamp()").toDouble()
		let secondTimestamp = context.evaluateScript("Timestamp.currentTimestamp()").toDouble()
		XCTAssertGreaterThan(secondTimestamp, firstTimestamp)
	}

	func testAfterDurationBridging() {
		var output: Double = 0
		var expectation = expectationWithDescription("afterDuration")
		context.exceptionHandler = { value in
			output = value.toDouble()
			expectation.fulfill()
		}
		context.evaluateScript("afterDuration(0.25, function() { throw 3 })")

		waitForExpectationsWithTimeout(0.5, handler: nil)
		XCTAssertEqual(output, 3)
	}
}