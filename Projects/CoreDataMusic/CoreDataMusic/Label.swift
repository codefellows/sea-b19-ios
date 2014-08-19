//
//  Label.swift
//  CoreDataMusic
//
//  Created by Bradley Johnson on 8/19/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import Foundation
import CoreData

class Label: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var artists: NSSet

}
