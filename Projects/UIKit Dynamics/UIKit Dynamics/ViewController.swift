import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var snap: UISnapBehavior!

    @IBOutlet var square: UIView!
    @IBOutlet var barrier: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureAnimatorAndBehaviors()
    }
    
    // MARK: In UIKit Dynamics, Order is Important! 
    // e.g. adding collision before gravity will yield undesirable results
    func configureAnimatorAndBehaviors() {
        // init the animator with self.view as the reference view
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // init the gravity behavior with appropriate items
        gravity = UIGravityBehavior(items: [square])
        animator.addBehavior(gravity)
        
        // initialize the collision behavior with self.square and become the delegate
        collision = UICollisionBehavior(items: [square])
        collision.collisionDelegate = self
        
        // add a boundary that has the same frame as the barrier
        collision.addBoundaryWithIdentifier("barrier", forPath: UIBezierPath(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        // add some elasticity to the squareView on our animator
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior!, beganContactForItem item: UIDynamicItem!, withBoundaryIdentifier identifier: NSCopying!, atPoint p: CGPoint) {
        
        // log out the collision
        println("Boundary contact occurred - \(identifier)")
        
        // get the colliding view, in our case it should be self.square
        let collidingView = item as UIView

        // animated the color of the square view after a collision occurs
        collidingView.backgroundColor = UIColor.yellowColor()
        UIView.animateWithDuration(0.3) {
            collidingView.backgroundColor = UIColor.grayColor()
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        // we only care about a single touch, so touches.anyObject() is sufficient
        let touch = touches.anyObject() as UITouch
        // remove the old snap behavior.  if snap is nil, this method fails gracefully
        animator.removeBehavior(snap)
        // init the snap behavior, snap it to the touch point, then add it to our animator
        snap = UISnapBehavior(item: square, snapToPoint: touch.locationInView(view))
        animator.addBehavior(snap)
    }
}
