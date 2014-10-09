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

	func testAncestorNamed() {
		let superparent = Layer(parent: nil, name: "A")
		let parent = Layer(parent: superparent, name: "B")
		let child = Layer(parent: parent, name: "C")

		XCTAssertEqual(child.ancestorNamed("A")!, superparent)
		XCTAssertNil(child.ancestorNamed("D"))

		let alternativeParent = Layer(parent: superparent, name: "A")
		child.parent = alternativeParent
		XCTAssertEqual(child.ancestorNamed("A")!, alternativeParent)
	}

	func testSublayerAtFront() {
		let parent = Layer(parent: nil)
		let child1 = Layer(parent: parent)
		let child2 = Layer(parent: parent)

		XCTAssertEqual(parent.sublayerAtFront!, child2)
		XCTAssertNil(child2.sublayerAtFront)
	}

	func testSublayerNamed() {
		let parent = Layer(parent: nil)
		let child1 = Layer(parent: parent, name: "A")
		let child2 = Layer(parent: parent, name: "B")
		XCTAssertEqual(parent.sublayerNamed("A")!, child1)
		XCTAssertEqual(parent.sublayerNamed("B")!, child2)
	}

	func testAccessorsOfClass() {
		class MyLayer: Layer {}
		let parent = MyLayer(parent: nil)
		let child1 = Layer(parent: parent)
		let child2 = MyLayer(parent: parent)
		XCTAssertEqual(parent.sublayerOfClass(MyLayer.self)!, child2)
		XCTAssertEqual(child2.ancestorOfClass(MyLayer.self)!, parent)
		XCTAssertNil(child2.sublayerOfClass(MyLayer.self))
		XCTAssertNil(parent.ancestorOfClass(MyLayer.self))
	}

	func testDescendentNamed() {
		let superparent = Layer(parent: nil, name: "A")
		let redHerring = Layer(parent: superparent, name: "Nope")
		let parent = Layer(parent: superparent, name: "B")
		let child = Layer(parent: parent, name: "C")

		XCTAssertEqual(superparent.descendentNamed("C")!, child)
		XCTAssertNil(superparent.descendentNamed("What?"))

		XCTAssertEqual(superparent.descendentAtPath(["B", "C"])!, child)
		XCTAssertNil(superparent.descendentAtPath(["C"]))
	}
}
