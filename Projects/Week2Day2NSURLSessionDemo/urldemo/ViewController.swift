//
//  ViewController.swift
//  urldemo
//
//  Created by Bradley Johnson on 7/28/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit

class ViewController: UIViewController,NetworkControllerDelegate {
    
    let networkController = NetworkController()

    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.networkController.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var downloadImage: UIButton!

    @IBAction func download(sender: AnyObject) {
        
//        //setup url
//        var url = NSURL(string: "http://blogimages.thescore.com/nfl/files/2014/02/russell-Wilson-again.jpg")
//        self.networkController.downloadImage(url, callback: {(image : UIImage) -> Void in
//        self.imageVIew.image = image
//            self.view.backgroundColor = UIColor.redColor()
//        })
        
        self.networkController.downloadPDFWithDelegate()
        
    }
    
    //MARK: NetworkControllerDelegate
    
    func didUpdateDownloadPercentage(percent: Double) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.progressView.progress = Float(percent)
        }
    }
}

