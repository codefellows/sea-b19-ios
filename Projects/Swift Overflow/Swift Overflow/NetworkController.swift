//
//  NetworkController.swift
//  Swift Overflow
//
//  Created by John Clem on 7/28/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import UIKit

class NetworkController: NSObject {
   
    let baseURL = "http://api.stackexchange.com/2.2/search?"
    
    func searchResultsForQueryString(query : String) -> Array<NSDictionary> {
        var items = Array<NSDictionary>()
        let searchTerm = baseURL + "order=desc&sort=activity&tagged=\(query)&site=stackoverflow"
        let defaultEndPoint = baseURL + searchTerm
        let JSONdata = NSData(contentsOfURL: NSURL(string: defaultEndPoint))
        var error : NSError?
        
        if let jsonObject = NSJSONSerialization.JSONObjectWithData(JSONdata, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let jsonArray = jsonObject["items"] as? NSArray{
                for object in jsonArray {
                    if let item = object as? NSDictionary{
                        items += item
                    }
                }
            }
        }

        return items
    }
}
