//
//  HashTable.swift
//  hashtable
//
//  Created by Bradley Johnson on 9/2/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import Foundation

class HashTable {
    
    var size : Int
    var hashArray = [HashBucket]()
    var count = 0
    
    init(size : Int) {
        self.size = size
        
        for i in 0..<size {
            var bucket = HashBucket()
            self.hashArray.append(bucket)
        }
    }
    
    func hash(key : String) -> Int{
        
        var total = 0
        
        for character in key.unicodeScalars {
            
            var asc = Int(character.value)
            total += asc
        }
        println(total % self.size)
        return total % self.size
    }
    
    func setObject(objectToStore : AnyObject, key : String) {
        
        var bucket = HashBucket()
        var index = self.hash(key)
        
        bucket.value = objectToStore
        bucket.key = key
        
        self.removeObjectForKey(key)
        
        bucket.next = self.hashArray[index]
        self.hashArray[index] = bucket
        
        self.count++
    }
    
    func removeObjectForKey(key : String) {
        
        var index = self.hash(key)
        var previousBucket : HashBucket?
        var bucket : HashBucket? = self.hashArray[index]
        
        while (bucket != nil) {
            
            if bucket!.key == key {
            
                if previousBucket == nil {
                    //we found the key we are looking for
                    //making sure we dont lose the linked list
                    var nextBucket = bucket?.next
                    self.hashArray[index] ?? bucket?.next!
                } else {
                    previousBucket!.next = bucket?.next
                }
                self.count--
                return
            }
            
            previousBucket = bucket
            
            if let nextBucket = bucket?.next {
                bucket = nextBucket
            } else {
                bucket = nil
            }
            
        }
    }
    
    func objectForKey(key : String) -> AnyObject? {
        var index = self.hash(key)
        
        var bucket = self.hashArray[index]
        
        while (bucket != nil) {
            if bucket.key == key {
                //we found our object for the key they were searching for
                return bucket.value
            } else {
                bucket = bucket.next!
            }
        }
        
        return nil
    }
    
}