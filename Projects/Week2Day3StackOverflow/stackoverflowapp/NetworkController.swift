//
//  NetworkController.swift
//  stackoverflowapp
//
//  Created by Bradley Johnson on 7/30/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import Foundation

class NetworkController {
    
    let apiDomain = "http://api.stackexchange.com/2.2"
    let searchEndpoint = "/search?order=desc&sort=activity&site=stackoverflow"
    
    func parseSuccessfulResponse(responseData : NSData) -> [Question]{
        var questions = [Question]()
        if let responseDict = NSJSONSerialization.JSONObjectWithData(responseData, options: nil, error: nil) as? NSDictionary {
            
            if let items = responseDict["items"] as? NSArray {
                for item in items {
                    if let itemDict = item as? NSDictionary {
                        let question = Question(itemDict: itemDict)
                        questions += question
                    }
                }
            }
        }
        return questions
    }
    func fetchQuestionsFromSampleData(callback : (questions : [Question]?, errorDescription : String?) -> Void) {
        let sampleData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("SampleResponse", ofType: "json"))
        var questions = self.parseSuccessfulResponse(sampleData)
        callback(questions: questions, errorDescription: nil)
    }
    
    func fetchQuestionsForSearchTerm(searchTerm : String, callback : (questions : [Question]?, errorDescription : String?) -> Void) {
        
        var url = NSURL(string: apiDomain + searchEndpoint + "&tagged=\(searchTerm)")
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data : NSData!,response : NSURLResponse!, error :  NSError!) -> Void in
            
            if error {
                //checking for a general error
                //execute callback, passing an error description and no questions
                callback(questions: nil, errorDescription: "Hey sorry! try again next time")
                return
            }
            else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                        case 200:
                        self.parseSuccessfulResponse(data)
                        case 404:
                        println("not found")
                        callback(questions: nil, errorDescription: "404 not found")
                        case 400:
                        println("not found")
                        callback(questions: nil, errorDescription: "400 bad parameters")
                        case 401:
                        callback(questions: nil, errorDescription: "You need to be signed           in to use this feature")
                        case 500:
                        callback(questions: nil, errorDescription: "Try again Later")
                        default:
                        callback(questions: nil, errorDescription: "Hey sorry! try again next time")
                    }
                }

            }
        
            })
        task.resume()
    }
}
