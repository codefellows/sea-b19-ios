//
//  Tag.swift
//  Swift Overflow
//
//  Created by John Clem on 8/1/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import Foundation
import CoreData

class Tag: NSManagedObject {

    @NSManaged var text: String
    @NSManaged var questions: NSSet

}
