//
//  GestureBridgeTests.swift
//  Prototope
//
//  Created by Andy Matuschak on 2/4/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import PrototopeJSBridge
import XCTest

class GestureBridgeTests: JSBridgeTestCase {
	func testTouchSampleBridging() {
		let touchSampleValue = context.evaluateScript("new TouchSample({globalLocation: new Point({x: 5, y: 10}), timestamp: 20.0})")
		let globalLocationBridge = touchSampleValue.valueForProperty("globalLocation").toObject() as! PointBridge
		XCTAssertEqual(globalLocationBridge.x, 5)
		XCTAssertEqual(globalLocationBridge.y, 10)
		XCTAssertEqual(touchSampleValue.valueForProperty("timestamp").toDouble(), 20)
	}

	func testTouchSequenceBridging() {
		let touchSequenceValue = context.evaluateScript("var a = new TouchSample({globalLocation: new Point({x: 5, y: 10}), timestamp: 20.0}); var b = new TouchSample({globalLocation: new Point({x: 10, y: 20}), timestamp: 21.0}); new TouchSequence({samples: [a, b], id: 42})")
		let samples = touchSequenceValue.valueForProperty("samples").toArray() as! [TouchSampleBridge]
		XCTAssertEqual(samples[0].globalLocation.x, 5)
		XCTAssertEqual(samples[1].globalLocation.x, 10)
		XCTAssertEqual(touchSequenceValue.valueForProperty("firstSample").valueForProperty("timestamp").toDouble(), 20)
		XCTAssertEqual(touchSequenceValue.valueForProperty("previousSample").valueForProperty("timestamp").toDouble(), 20)
		XCTAssertEqual(touchSequenceValue.valueForProperty("currentSample").valueForProperty("timestamp").toDouble(), 21)
		XCTAssertEqual(touchSequenceValue.valueForProperty("id").toDouble(), 42)

		let touchSampleValue = context.evaluateScript("new TouchSample({globalLocation: new Point({x: 20, y: 30}), timestamp: 22.0})")
		let appendedSequenceValue = touchSequenceValue.invokeMethod("sampleSequenceByAppendingSample", withArguments: [touchSampleValue])
		let appendedSamples = appendedSequenceValue.valueForProperty("samples").toArray() as! [TouchSampleBridge]
		XCTAssertEqual(appendedSamples.count, 3)
	}

	func testSampleSequenceBridging() {
		let touchSequenceValue = context.evaluateScript("var a = new TouchSample({globalLocation: new Point({x: 5, y: 10}), timestamp: 20.0}); var b = new TouchSample({globalLocation: new Point({x: 10, y: 20}), timestamp: 21.0}); new SampleSequence({samples: [a, b], id: 42})")
		let samples = touchSequenceValue.valueForProperty("samples").toArray() as! [TouchSampleBridge]
		XCTAssertEqual(samples[0].globalLocation.x, 5)
		XCTAssertEqual(samples[1].globalLocation.x, 10)
		XCTAssertEqual(touchSequenceValue.valueForProperty("firstSample").valueForProperty("timestamp").toDouble(), 20)
		XCTAssertEqual(touchSequenceValue.valueForProperty("previousSample").valueForProperty("timestamp").toDouble(), 20)
		XCTAssertEqual(touchSequenceValue.valueForProperty("currentSample").valueForProperty("timestamp").toDouble(), 21)
		XCTAssertEqual(touchSequenceValue.valueForProperty("id").toDouble(), 42)

		let touchSampleValue = context.evaluateScript("new TouchSample({globalLocation: new Point({x: 20, y: 30}), timestamp: 22.0})")
		let appendedSequenceValue = touchSequenceValue.invokeMethod("sampleSequenceByAppendingSample", withArguments: [touchSampleValue])
		let appendedSamples = appendedSequenceValue.valueForProperty("samples").toArray() as! [TouchSampleBridge]
		XCTAssertEqual(appendedSamples.count, 3)
	}
}
