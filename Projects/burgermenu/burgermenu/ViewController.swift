//
//  ViewController.swift
//  burgermenu
//
//  Created by Bradley Johnson on 9/4/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
            (note) -> Void in
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 222.0)
            })
            println("Keyboard is showing")
        }

        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
            (note) -> Void in
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.mainScreen().bounds.size)
            })
            println("Keyboard is hiding")
        }
        
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        for control in self.view.subviews {
            if let textField = control as? UITextField {
                textField.endEditing(true)
            }
        }
        
        let asapQueue = NSNotificationQueue(notificationCenter: NSNotificationCenter.defaultCenter())
        let asapNotification = NSNotification(name: "HeyThere", object: nil, userInfo: nil)
        asapQueue.enqueueNotification(asapNotification, postingStyle: NSPostingStyle.PostASAP)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

