//
//  Person.swift
//  ClassRosterB19
//
//  Created by John Clem on 7/21/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import UIKit

class Person {
    
    var firstName : String
    var lastName : String

    init(firstName : String, lastName : String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    class func defaultPeopleArray() -> Array<Person> {
        var people = Array<Person>()
        let plistPath = NSBundle.mainBundle().pathForResource("People", ofType: "plist")
        let personArray = NSArray(contentsOfFile: plistPath)
        
        for personDict in personArray {
            if let person = personDict as? Dictionary<String, String> {
                let newPerson = Person(firstName: person["firstName"] as String, lastName: person["lastName"] as String)
                people += newPerson
            }
        }
        return people
    }
}
