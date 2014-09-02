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
