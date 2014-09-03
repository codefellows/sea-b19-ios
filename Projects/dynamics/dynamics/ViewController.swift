//
//  ViewController.swift
//  dynamics
//
//  Created by Bradley Johnson on 9/3/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
                            
    @IBOutlet weak var redBarrier: UIView!
    @IBOutlet weak var blueSquare: UIView!
    
    var animator : UIDynamicAnimator!
    var gravityBehavior : UIGravityBehavior!
    var collisionBehavior : UICollisionBehavior!
    var snapBehavior : UISnapBehavior!
    
    override func viewDidAppear(animated: Bool) {
        //setup animator with reference view
        self.animator = UIDynamicAnimator(referenceView: self.view)
        //init the gravity behavior with our blue square
        self.gravityBehavior = UIGravityBehavior(items: [self.blueSquare])
        self.animator.addBehavior(self.gravityBehavior)
        
        //init the collision behavior with the blue square and become the delegate
        self.collisionBehavior = UICollisionBehavior(items: [blueSquare])
        self.collisionBehavior.collisionDelegate = self
        
        self.collisionBehavior.addBoundaryWithIdentifier("barrier", forPath: UIBezierPath(rect: self.redBarrier.frame))
        //this will make our reference view the boundary
        self.collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(collisionBehavior)
        
        //add cool stuff
        let itemBehavior = UIDynamicItemBehavior(items: [blueSquare])
        itemBehavior.elasticity = 0.6
        animator.addBehavior(itemBehavior)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches.anyObject() as UITouch
        animator.removeBehavior(snapBehavior)
        
        self.snapBehavior = UISnapBehavior(item: self.blueSquare, snapToPoint: touch.locationInView(self.view))
        self.animator.addBehavior(self.snapBehavior)
        
    }
    
    func collisionBehavior(behavior: UICollisionBehavior!, beganContactForItem item: UIDynamicItem!, withBoundaryIdentifier identifier: NSCopying!, atPoint p: CGPoint) {
        
        println("Boundary contact occured - \(identifier)")
        
        let collidingView = item as UIView
        
        collidingView.backgroundColor = UIColor.yellowColor()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            collidingView.backgroundColor = UIColor.blueColor()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

