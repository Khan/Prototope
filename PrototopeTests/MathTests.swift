//
//  MathTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/16/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import Prototope
import XCTest
import Foundation

class MathTests: XCTestCase {
	func testInterpolate() {
		XCTAssertEqual(interpolate(from: 3, to: 9, at: 0.25), 4.5)
		XCTAssertEqual(interpolate(from: 10, to: 4, at: 0.5), 7)
	}

	func testMap() {
		XCTAssertEqual(map(4, fromInterval: (2, 8), toInterval: (1, 4)), 2)
	}

	func testClip() {
		var result: Double = clip(5, min: 3, max: 4)
		XCTAssertEqual(result, 4)
		result = clip(2, min: 3, max: 4)
		XCTAssertEqual(result, 3)
		result = clip(3.5, min: 3, max: 4)
		XCTAssertEqual(result, 3.5)
	}
}
