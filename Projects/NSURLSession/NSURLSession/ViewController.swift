//
//  ViewController.swift
//  NSURLSession
//
//  Created by John Clem on 7/29/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var progressView: ASProgressPopUpView!
    
    let downloadQueue = NSOperationQueue()
    var session : NSURLSession!
    var downloadTask : NSURLSessionDownloadTask!
    var resumeData : NSData?
    var isDownloading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleDownload(sender : UIButton!) {
        if isDownloading {
            downloadTask.cancelByProducingResumeData() {
                (resumeData) in
                self.resumeData = resumeData
                self.isDownloading = false
                sender.titleLabel.text = "Resume"
                self.progressView.hidePopUpViewAnimated(true)
            }
        } else if sender.titleLabel.text == "Resume" {
            if let resumeData : NSData = self.resumeData {
                downloadTask = session.downloadTaskWithResumeData(resumeData)
                downloadTask.resume()
                self.isDownloading = true
                sender.titleLabel.text = "Pause"
                self.progressView.showPopUpViewAnimated(true)
            }
        } else {
            let downloadURL = "http://devstreaming.apple.com/videos/wwdc/2014/228xxnfgueiskhi/228/228_hd_a_look_inside_presentation_controllers.mov?dl=1"
            let request = NSURLRequest(URL: NSURL(string: downloadURL))
            downloadTask = session.downloadTaskWithRequest(request)
            downloadTask.resume()
            self.isDownloading = true
            self.progressView.showPopUpViewAnimated(true)
            sender.titleLabel.text = "Pause"
        }
    }
    
    //MARK: NSURLSessionDownloadDelegate
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentDownloaded = Double(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
        println("Downloaded: \(percentDownloaded * 100.0)%")
        progressView.progress = Float(percentDownloaded)
    }
    
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        println("did resume downloading")
    }
    
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didFinishDownloadingToURL location: NSURL!) {
        println("did finish downloading")
    }
}

