//
//  Question.swift
//  stackoverflowapp
//
//  Created by John Clem on 8/3/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
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
    @NSManaged var owner: User
    @NSManaged var tags: NSSet

    init(itemDict : NSDictionary, entity: NSEntityDescription?, insertIntoManagedObjectContext: NSManagedObjectContext) {
        super.init(entity: entity, insertIntoManagedObjectContext: insertIntoManagedObjectContext)
        self.answer_count = itemDict["answer_count"] as NSNumber
        var creation_date_epoch = itemDict["creation_date"] as NSTimeInterval
        self.creation_date = NSDate(timeIntervalSince1970: creation_date_epoch)
        self.is_answered = itemDict["is_answered"] as NSNumber
        self.link = itemDict["link"] as String
        self.question_id = itemDict["question_id"] as NSNumber
        self.score = itemDict["score"] as NSNumber
        self.title = itemDict["title"] as String
        self.view_count = itemDict["view_count"] as NSNumber        
    }

}
