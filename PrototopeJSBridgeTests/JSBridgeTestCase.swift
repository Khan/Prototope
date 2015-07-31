//
//  JSBridgeTestCase.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/3/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import PrototopeJSBridge
import XCTest

class JSBridgeTestCase: XCTestCase {
	var context: Context!

	override func setUp() {
		context = Context()
		context.exceptionHandler = { value in XCTFail("Received JS exception: \(value)") }
		super.setUp()
	}
}
