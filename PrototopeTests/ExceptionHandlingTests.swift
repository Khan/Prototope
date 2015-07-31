//
//  ExceptionHandlingTests.swift
//  Prototope
//
//  Created by Saniul Ahmed on 05/03/2015.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Prototope
import XCTest
import Foundation

class ExceptionHandlingTests: XCTestCase {
    
    var exceptionHandled = false
    
    override func setUp() {
        let aView = UIView()
        
		let env = Environment(rootView: aView, imageProvider: { _ in return nil }, soundProvider: { _ in return nil }, fontProvider: { _ in return nil }, exceptionHandler: { _ in self.exceptionHandled = true })
        
        Environment.runWithEnvironment(env) {
        }
        
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.exceptionHandled = false
    }
    
    func testNonexistentImage() {
        let img = Image(name: "nonexistentImage")
        XCTAssertTrue(exceptionHandled)
    }
    
    func testNonexistentSound() {
        let img = Sound(name: "nonexistentSound")
        XCTAssertTrue(exceptionHandled)
    }
    
    func testNonexistentVideo() {
        let img = Video(name: "nonexistentVideo")
        XCTAssertTrue(exceptionHandled)
    }
    
}
