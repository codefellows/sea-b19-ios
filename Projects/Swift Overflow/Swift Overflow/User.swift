//
//  User.swift
//  Swift Overflow
//
//  Created by John Clem on 8/1/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var accept_rate: NSNumber
    @NSManaged var display_name: String
    @NSManaged var link: String
    @NSManaged var profile_image: NSData
    @NSManaged var reputation: NSNumber
    @NSManaged var user_id: NSNumber
    @NSManaged var user_type: String
    @NSManaged var questions: NSSet

}
