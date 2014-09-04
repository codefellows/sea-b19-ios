// Playground - noun: a place where people can play

import UIKit

var array = [1, 2, 3, 4, 5, 6]

//var rowCount : Int!
//if array.count > 5 {
//    rowCount = array.count
//} else {
//    rowCount = 5
//}

var rowCount = array.count > 5 ? array.count : 5

 func * (left: String, right: Int) -> String {
    if right <= 0 {
        return ""
    }
    
    var result = left
    for _ in 1..<right {
        result += left
    }
    
    return result
}

"a" * 6
/*
Pre-Requisites for NSNotificationCenter
1. Name of the notification
2. Optionally listen to a specific object
3. Optionally specify a callback queue
4. Code inside a closure to run every time notification fires
*/
NSNotificationCenter.defaultCenter().addObserverForName(
    UITextFieldTextDidChangeNotification, // Step 1
    object: nil,
    queue: NSOperationQueue.mainQueue() ) {
        (note) in
        // any code written here will run every time notification fires
}

NSNotificationCenter.defaultCenter().addObserverForName(nil, object: nil, queue: nil) {
    (note) -> Void in
    println("Notification Received: \(note.name)")
}

//[[NSNotificationCenter defaultCenter] addObserverForName:nil
//    object:nil
//    queue:instance.eventQueue
//    usingBlock:^(NSNotification *note) {
//    if ([instance.tagManager.dataLayer get:note.name]) {
//    NSLog(@"Notification Received: %@", note.name);
//    }
//    }];
