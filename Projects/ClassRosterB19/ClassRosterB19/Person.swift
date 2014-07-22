//
//  Person.swift
//  ClassRosterB19
//
//  Created by Bradley Johnson on 7/21/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import Foundation


class Person {
    
    var firstName : String
    var lastName : String
    
    init(firstName : String, lastName : String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func fullName() -> String {
        return self.firstName + self.lastName
    }
    
    class func loadPeopleFromPlist () -> Array<Person> {
        var people = Array<Person>()
        let plistPath = NSBundle.mainBundle().pathForResource("People", ofType: "plist")
        let peopleArray = NSArray(contentsOfFile: plistPath)
        
        for person in peopleArray {
            if let thePerson = person as? Dictionary<String, String> {
                let firstName = thePerson["firstName"] as String
                let lastName = thePerson["lastName"] as String
                let newPerson = Person(firstName: firstName, lastName: lastName)
                people += newPerson
            }
        }
        return people
    }

    
    
    
    
    
    
    
    
    
}