//
//  ViewTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 10/7/14.
//  Copyright (c) 2014 Khan Academy. All rights reserved.
//

import Prototope
import XCTest
import Foundation

class ViewTests: XCTestCase {
	func testSublayers() {
		let parent1 = Layer(parent: nil)
		let child = Layer(parent: parent1)
		XCTAssertEqual(parent1.sublayers, [child])
		XCTAssertEqual(child.parent!, parent1)

		let parent2 = Layer(parent: nil)
		child.parent = parent2
		XCTAssertEqual(parent1.sublayers, [])
		XCTAssertEqual(parent2.sublayers, [child])
	}
}
