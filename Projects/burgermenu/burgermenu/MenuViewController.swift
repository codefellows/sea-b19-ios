//
//  MenuViewController.swift
//  burgermenu
//
//  Created by Bradley Johnson on 9/4/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UIGestureRecognizerDelegate, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var options = ["Home", "Search"]
    var childView = UIView()
    var childrenVC = [UIViewController]()
    var currentChildVC : UIViewController!
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //The childView is what we will place our children VC's views on, they will take up the entire screen.
        self.childView.frame = self.view.frame
        self.view.addSubview(childView)
        
        //add our children to our children array
        var blueVC = self.storyboard.instantiateViewControllerWithIdentifier("BlueVC") as UIViewController
        self.childrenVC.append(blueVC)
        var redVC = self.storyboard.instantiateViewControllerWithIdentifier("RedVC") as UIViewController
        self.childrenVC.append(redVC)
        
        
        //get initial child on screen
        self.addChildViewController(blueVC)
        blueVC.view.frame = self.childView.frame
        self.childView.addSubview(blueVC.view)
        blueVC.didMoveToParentViewController(self)
        self.currentChildVC = blueVC
        
        //setup pan gesture recognizer
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "movePanel:")
        //panRecognizer.delegate = self
        self.view.addGestureRecognizer(panRecognizer)
    
        // Do any additional setup after loading the view.
//        NSNotificationCenter.defaultCenter().addObserverForName(nil, object: nil, queue: nil) {
//            (note) -> Void in
//            println("Notification Received: \(note.name)")
//        }
    }
    
    
    func movePanel(sender : UIPanGestureRecognizer) {
    
        //grab the point and velocity of gesture
        var translatedPoint = sender.translationInView(self.view)
        var velocity = sender.velocityInView(self.view)
//        println(translatedPoint.x)
        
        if sender.state == UIGestureRecognizerState.Changed {
            if self.childView.frame.origin.x >= 0 {
            self.childView.center = CGPointMake(self.childView.center.x + translatedPoint.x, self.childView.center.y)
                //if we went over the bounds, go back!
                if self.childView.frame.origin.x < 0 {
                    self.childView.center = self.view.center
                }
            //resent translation so it doesnt build up
            sender.setTranslation(CGPoint(x: 0, y: 0), inView: self.view)
            }
        }
        
        else if sender.state == UIGestureRecognizerState.Ended {
            //check to see where the current child vc is, if its more than half open, move it to the side to show menu, if its barely open, close it back up.
        }
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel.text = self.options[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.options.count   
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        if indexPath.row == self.currentIndex {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.childView.frame = self.view.frame
            })
        }
        else {
            
            //slide the childView all the way to the right to get it off screen 
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.childView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.childView.frame.width, height: self.childView.frame.height)
            }, completion: { (success) -> Void in
                
                //make the switch - remove old child
                self.currentChildVC.willMoveToParentViewController(nil)
                self.currentChildVC.view.removeFromSuperview()
                self.currentChildVC.removeFromParentViewController()
                //figure out which VC to add
                var newVC = self.childrenVC[indexPath.row]
                self.currentIndex = indexPath.row
                //adding child
                self.addChildViewController(newVC)
                newVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:self.view.frame.height)
                self.childView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
                //slide it back to full screen
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    //this brings it back to take up full screen
                    self.childView.frame = self.view.frame
                })
            })
            
            
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
}
