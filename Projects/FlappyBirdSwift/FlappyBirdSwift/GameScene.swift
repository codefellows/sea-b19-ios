//
//  GameScene.swift
//  FlappyBirdSwift
//
//  Created by Bradley Johnson on 9/1/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var flappy = SKSpriteNode(imageNamed: "flappy")
    var pipes = [PipeNode]()
    var firstAvailable : PipeNode!
    
    var flappyIsDead = false
    
    var deltaTime = 0.0
    var nextPipeTime = 2.0
    var previousTime = 0.0
    var timeSinceLastPipe = 0.0
    
    //categories
    let flappyCategory  = 0x1 << 0
    let pipeCategory = 0x1 << 1
    
    let bottomPipeLowerBounds = -300
    let pipeHeight = 530
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //creating our main character
        
        //setup scrollingbackground
        self.setupBackground()
        println(self.frame)
        self.physicsWorld.contactDelegate = self
        
        //setup pipes list
        self.setupPipes()
        
        //setup flappy
        self.flappy.position = CGPoint(x: 100, y: 300)
        self.addChild(self.flappy)
        
        //adding physics to flappy
        self.flappy.physicsBody = SKPhysicsBody(rectangleOfSize: self.flappy.size)
        self.flappy.physicsBody.dynamic = true
        self.flappy.physicsBody.mass = 0.02
        self.flappy.physicsBody.categoryBitMask = UInt32(self.flappyCategory)
        self.flappy.physicsBody.contactTestBitMask = UInt32(self.pipeCategory)
        self.flappy.physicsBody.collisionBitMask = 0
        
        
    }
    
    func setupPipes() {
        
        
        for (var i = 0; i < 10;i++) {
            
            //pipe setup
            var pipeNode = PipeNode()
            pipeNode.pipe.position = CGPointMake(1100, 0)
            pipeNode.pipe.anchorPoint = CGPointZero
            pipeNode.pipe.physicsBody = SKPhysicsBody(rectangleOfSize: pipeNode.pipe.size)
            pipeNode.pipe.physicsBody.affectedByGravity = false
            pipeNode.pipe.physicsBody.dynamic = false
            pipeNode.pipe.physicsBody.categoryBitMask = UInt32(self.pipeCategory)
           
            pipeNode.pipe.physicsBody.contactTestBitMask = UInt32(self.flappyCategory)
            //pipeNode.pipe.hidden = true
            self.addChild(pipeNode.pipe)
            //insert pipe into array, assign next pointer for linked list
            self.pipes.insert(pipeNode, atIndex: 0)
            if self.pipes.count > 1 {
                pipeNode.nextNode = self.pipes[1]
            }
        }
        self.firstAvailable = self.pipes[0]
    }
    
    func fetchFirstAvailablePipe () -> PipeNode {
        var firstPipe = self.firstAvailable
        //replace current head with head's next
        if self.firstAvailable.nextNode != nil {
            self.firstAvailable = self.firstAvailable.nextNode
        }
        //firstPipe.pipe.hidden = false
        return firstPipe
    }
    
    func doneWithPipe(pipeNode : PipeNode) {
        //pipeNode.pipe.hidden = true
        pipeNode.nextNode = self.firstAvailable
        self.firstAvailable = pipeNode
        println("done with pipe")
    }
    
    func setupBackground() {
        
        //this creates 2 backgrounds
        for (var i = 0; i < 2;i++) {
          var bg = SKSpriteNode(imageNamed: "space.jpg")
            var newI = CGFloat(i)
            bg.anchorPoint = CGPointZero
            bg.position = CGPointMake(newI * bg.size.width, 90)
            bg.name = "background"
            self.addChild(bg)
        }
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        println("touches began")
        
        if flappyIsDead == false {
            
            self.flappy.physicsBody.velocity = CGVectorMake(0, 0)
            self.flappy.physicsBody.applyImpulse(CGVectorMake(0, 7))
        }
        
        
    }
    
    func movePipe(pipeNode : PipeNode, location : CGPoint){
        
        var moveAction = SKAction.moveTo(location, duration: 3)
        var completionAction = SKAction.runBlock({
            self.doneWithPipe(pipeNode)
        })
        var sequence = SKAction.sequence([moveAction,completionAction])
        
        pipeNode.pipe.runAction(sequence)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //figuring our delta time, aka time since last update:
        self.deltaTime = currentTime - self.previousTime
        self.previousTime = currentTime
        self.timeSinceLastPipe += self.deltaTime
        
        if self.timeSinceLastPipe > self.nextPipeTime {
            println("spawning pipe")
            
            //generate random number between 0 and -300
            var y = Int(arc4random_uniform(UInt32(300)))
            var randomY = CGFloat(y * -1)

            
            //its time to create a pipe
            var pipeNode = self.fetchFirstAvailablePipe()
            println("height of pipe : \(pipeNode.pipe.size.height)")
                
            pipeNode.pipe.position = CGPointMake(1100, randomY)
            //create location to tell pipe to move to with an action
            var location = CGPointMake(-70, randomY)
            self.movePipe(pipeNode, location: location)
        
//            var topY = CGFloat(self.pipeHeight) + 450 + randomY
////            spawn top pipe
//            var topPipe = self.fetchFirstAvailablePipe()
//            var rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.0)
//            topPipe.pipe.runAction(rotate)
//            
//            topPipe.pipe.position = CGPointMake(1100, topY)
//             var nextLocation = CGPointMake(-70, topY)
//            self.movePipe(topPipe, location: nextLocation)
//
//            reset timesincelastpipe to 0, since we just created a pipe
            self.timeSinceLastPipe = 0
        }
        
        
        
        
        
        
        //enumerate through our background nodes
self.enumerateChildNodesWithName("background", usingBlock: { (node, stop) -> Void in
    
    if let bg = node as? SKSpriteNode {
        //move the background to the left
        bg.position = CGPointMake(bg.position.x - 5, bg.position.y)
        //if background is completely off screen to left, move it to the right so it can be scrolled back on screen
        if bg.position.x <= bg.size.width * -1 {
            bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y)
        }
    }
    })
          }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        println("contact!")
        
        self.flappyIsDead = true
        var bird = contact.bodyB.node
        var slightUp = CGPointMake(bird.position.x, bird.position.y + 20)
        var moveUp = SKAction.moveTo(slightUp, duration: 0.1)
        var drop = CGPointMake(bird.position.x, 0)
        var moveDown = SKAction.moveTo(drop, duration: 0.5)
        
        var sequence = SKAction.sequence([moveUp,moveDown])
        
        bird.runAction(sequence)
        
        
       
    }
}
