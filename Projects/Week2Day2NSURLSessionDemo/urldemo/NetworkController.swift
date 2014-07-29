//
//  NetworkController.swift
//  urldemo
//
//  Created by Bradley Johnson on 7/29/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import Foundation
import UIKit

    protocol NetworkControllerDelegate {
        
         func didUpdateDownloadPercentage(percent : Double)
    
    }

class NetworkController : NSObject, NSURLSessionDownloadDelegate {
    
    var delegate : NetworkControllerDelegate?
    
    func downloadImage(url : NSURL, callback : (UIImage) -> Void) {
        
    
        var myQueue = NSOperationQueue()
        myQueue.maxConcurrentOperationCount = 1
        myQueue.addOperationWithBlock( {() -> Void in
            
            var data = NSData(contentsOfURL: url)
            
            NSOperationQueue.mainQueue().addOperationWithBlock( {() -> Void in
                
                var myImage = UIImage(data: data)
                callback(myImage)
                })
            })
    }
    
    
    func downloadPDFWithDelegate() {
        
        var url = NSURL(string: "http://devstreaming.apple.com/videos/wwdc/2014/231xx9bil1zgee7/231/231_advanced_cloudkit.pdf?dl=1")
        let request = NSURLRequest(URL: url)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                                   delegate: self,
                                   delegateQueue: nil)
        let downloadTask = session.downloadTaskWithRequest(request)
        downloadTask.resume()
    }
    
    func fetchQuestions (){
        //setting up the NSURLRequest
        let request = NSURLRequest(URL: NSURL(string: "www.espn.com"))
        //setting up the NSURLSEssion
         let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        //using our session to create a data ask for JSON fetch
        session.dataTaskWithRequest(request, completionHandler: { (data : NSData!, response : NSURLResponse!, error :NSError!) -> Void in
            
            if error {
                //do something for overall session error
            }
            else {
                //switch on your http response code
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        println("awesome")
                        //awesome!
                    case 404:
                        println("nah bro")
                        //bad
                    default:
                        println("uh oh")
                        //alert user of error
                    }
                }
            }
            
            })
    }
    
    //MARK: NSURLSessionDownloadDelegate
    
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentDownloaded = Double(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
        if self.delegate {
            self.delegate!.didUpdateDownloadPercentage(percentDownloaded)
        }
        println("Downloaded \(percentDownloaded * 100.0)%")
    }
    
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        println("did resume downloading")
    }
    
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didFinishDownloadingToURL location: NSURL!) {
        println("did finish downloading at \(location.description)")
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}