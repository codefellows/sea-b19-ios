//
//  BinarySearchTree.swift
//  BST
//
//  Created by Bradley Johnson on 9/3/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import Foundation

class BinarySearchTree {
    
    var root : Node?
    
    
    init () {
        
    }
    func addValue(value : Int) {
        
        var newNode = Node(value: value)
        
        if root == nil {
            self.root = newNode
        } else {
            self.root!.addNode(newNode)
        }
    }
    
    func findNodeForValue(value : Int) -> Node? {
        
        //start with root in our search
        var foundNode = self.findValue(value, forNode: self.root!)
        
        return foundNode
    }
    
    func findValue(value:Int, forNode node: Node?) -> Node?{
        if node != nil {
            if value == node!.value {
                //found our value!
                return node
            } else {
                if value < node!.value {
                    //more recursion
                    return self.findValue(value, forNode: node!.leftNode!)
                }
                else if value > node!.value {
                    return self.findValue(value, forNode: node!.rightNode!)
                }
            }
        }
        return nil
    }
    
}

class Node {
    
    var value : Int
    
    var leftNode : Node?
    var rightNode : Node?
    
    init(value: Int) {
        self.value = value
    }
    
    func addNode(newNode : Node) {
        
        //ignoring duplicates
        if newNode.value < self.value {
            
            //if less than, go to the left!
            
            if self.leftNode == nil {
                //this is the case when we have node with a value less than ours, and we dont have a left child.
                self.leftNode = newNode
            } else {
                //recursion
                self.leftNode?.addNode(newNode)
            }
            
        }
        else if newNode.value > self.value {
            
            if self.rightNode == nil {
                self.rightNode = newNode
            } else {
                //recursion
                self.rightNode?.addNode(newNode)
            }
        }
    }
}