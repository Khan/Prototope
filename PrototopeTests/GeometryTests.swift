//
//  GeometryTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/16/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import Prototope
import XCTest
import Foundation

class PointTests: XCTestCase {
	func testDistanceToPoint() {
		XCTAssertEqualWithAccuracy(Point(x: 5, y: 5).distanceToPoint(Point(x: 10, y:10)), sqrt(2) * 5, 0.001)
	}

	func testLength() {
		XCTAssertEqualWithAccuracy(Point(x: 3, y: 4).length, 5, 0.001)
	}
}
