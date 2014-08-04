//
//  Tag.swift
//  stackoverflowapp
//
//  Created by John Clem on 8/3/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import Foundation
import CoreData

class Tag: NSManagedObject {

    @NSManaged var text: String
    @NSManaged var questions: NSSet

}
