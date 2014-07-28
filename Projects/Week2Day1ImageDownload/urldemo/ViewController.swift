//
//  ViewController.swift
//  urldemo
//
//  Created by Bradley Johnson on 7/28/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet weak var imageVIew: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var downloadImage: UIButton!

    @IBAction func download(sender: AnyObject) {
        
        //setup url
        var url = NSURL(string: "http://blogimages.thescore.com/nfl/files/2014/02/russell-Wilson-again.jpg")
        var myQueue = NSOperationQueue()
        myQueue.maxConcurrentOperationCount = 1
        myQueue.addOperationWithBlock( {() -> Void in
        
           var data = NSData(contentsOfURL: url)
            
            NSOperationQueue.mainQueue().addOperationWithBlock( {() -> Void in
                var myImage = UIImage(data: data)
                self.imageVIew.image = myImage
                })
            })
        
        var imageOperation = NSOperation()
        var blockOperation = NSBlockOperation({() -> Void in
            
            
            //do something
            })
        
        myQueue.addOperation(blockOperation)
    }
}

