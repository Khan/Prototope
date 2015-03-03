//
//  ContextBridgeTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 3/2/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import PrototopeJSBridge
import XCTest

class ContextTests: JSBridgeTestCase {
	func testContextExecutesInStrictMode() {
		let context = Context()
		var hitException = false
		context.exceptionHandler = { _ in hitException = true }
		context.evaluateScript("x = 4")
		XCTAssertTrue(hitException)
	}
}
