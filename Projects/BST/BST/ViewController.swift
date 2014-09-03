//
//  ViewController.swift
//  BST
//
//  Created by Bradley Johnson on 9/3/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var BST = BinarySearchTree()
        BST.addValue(34)
        BST.addValue(12)
        BST.addValue(74)
        BST.addValue(100)
        BST.addValue(5)
        BST.addValue(13)
        BST.addValue(2)
        BST.addValue(61)
        BST.addValue(98)
        
        
        var searchNode = BST.findNodeForValue(98)
        
        println(searchNode!.value)
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

