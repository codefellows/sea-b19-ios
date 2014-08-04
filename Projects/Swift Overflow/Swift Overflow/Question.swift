//
//  Question.swift
//  Swift Overflow
//
//  Created by John Clem on 8/1/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import Foundation
import CoreData

class Question: NSManagedObject {

    @NSManaged var answer_count: NSNumber
    @NSManaged var creation_date: NSDate
    @NSManaged var is_answered: NSNumber
    @NSManaged var last_activity_date: NSDate
    @NSManaged var last_edit_date: NSDate
    @NSManaged var link: String
    @NSManaged var question_id: NSNumber
    @NSManaged var score: NSNumber
    @NSManaged var title: String
    @NSManaged var view_count: NSNumber
    @NSManaged var owner: NSManagedObject
    @NSManaged var tags: NSSet

}
