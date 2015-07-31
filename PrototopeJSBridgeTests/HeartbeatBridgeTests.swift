//
//  HeartbeatBridgeTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import PrototopeJSBridge
import XCTest

class HeartbeatBridgeTests: JSBridgeTestCase {
	func testHeartbeatBridging() {
		var expectation = expectationWithDescription("heartbeat")
		var heartbeatCount: Int = 0
		context.exceptionHandler = { heartbeatValue in
			heartbeatCount++
			if heartbeatCount >= 5 {
				heartbeatValue.invokeMethod("stop", withArguments: [])
				expectation.fulfill()
			}
		}
		context.evaluateScript("var h = new Heartbeat({handler: function(heartbeat) { throw heartbeat } })")

		waitForExpectationsWithTimeout(0.5, handler: nil)

	}
}

