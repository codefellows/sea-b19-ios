//
//  Person.swift
//  ClassRosterB19
//
//  Created by John Clem on 7/21/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import UIKit

class Person : NSObject {
    var firstName : String
    var lastName : String
    
    init(firstName : String, lastName : String) {
        self.firstName = firstName
        self.lastName = lastName
        super.init()
    }
}

class SwiftPerson {
    
    var firstName : String
    var lastName : String

    init(firstName : String, lastName : String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}
