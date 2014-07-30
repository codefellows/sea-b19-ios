//
//  self.swift
//  stackoverflowapp
//
//  Created by Bradley Johnson on 7/30/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import Foundation


class Question {
    var title : String?
    var questionID : Int?
    var tags : [String]?
    var answer_count : Int?
    var view_count : Int?
    var displayName : String?
    var userID : Int?
    var last_edit_date : NSDate?
    
    init(itemDict : NSDictionary) {
        self.title = itemDict["title"] as? String
        self.questionID = itemDict["question_id"] as? Int
        self.answer_count = itemDict["answer_count"] as? Int
        self.view_count = itemDict["view_count"] as? Int
        self.displayName = itemDict["display_name"] as? String
        self.userID = itemDict["user_id"] as? Int
        self.tags = itemDict["tags"] as? [String]
        if let editDateEpoch = itemDict["last_edit_date"] as? Double {
            self.last_edit_date = NSDate(timeIntervalSince1970: editDateEpoch)
        }
    }
}