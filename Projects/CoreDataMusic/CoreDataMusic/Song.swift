//
//  Song.swift
//  CoreDataMusic
//
//  Created by Bradley Johnson on 8/19/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import Foundation
import CoreData

class Song: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var year: NSNumber
    @NSManaged var artist: Artist

}
