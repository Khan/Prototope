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
		XCTAssertEqual(Point(x: 3, y: 4).length, 5)
	}
}

class RectTests: XCTestCase {
	func testComputedLocations() {
		let testRect = Rect(x: 5, y: 10, width: 20, height: 30)
		XCTAssertEqual(testRect.minX, 5)
		XCTAssertEqual(testRect.midX, 15)
		XCTAssertEqual(testRect.maxX, 25)
		XCTAssertEqual(testRect.minY, 10)
		XCTAssertEqual(testRect.midY, 25)
		XCTAssertEqual(testRect.maxY, 40)

		XCTAssertEqual(testRect.center, Point(x: 15, y: 25))
		var updatedRect = testRect
		updatedRect.center += Point(x: 15, y: 10)
		XCTAssertEqual(updatedRect.center, Point(x: 30, y: 35))
	}
}
