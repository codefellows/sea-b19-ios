//
//  PersonTests.swift
//  ClassRosterB19
//
//  Created by John Clem on 7/21/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import UIKit
import XCTest

class PersonTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
        
        let newPerson = Person(firstName: "John", lastName: "Clem")
    }

    

}
