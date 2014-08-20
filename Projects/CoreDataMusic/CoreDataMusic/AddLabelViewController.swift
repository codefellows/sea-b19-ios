//
//  AddLabelViewController.swift
//  CoreDataMusic
//
//  Created by Bradley Johnson on 8/19/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit
import CoreData

class AddLabelViewController: UIViewController {
    
    lazy var myContext : NSManagedObjectContext? = {
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        return appDelegate.managedObjectContext
    }()
    @IBOutlet weak var labelNameField: UITextField!
    
    @IBAction func saveLabelPressed(sender: AnyObject) {
        
        var newLabel = NSEntityDescription.insertNewObjectForEntityForName("Label", inManagedObjectContext: self.myContext) as Label
        newLabel.name = self.labelNameField.text
        var error : NSError?
        self.myContext?.save(&error)
        if error != nil {
            println(error?.localizedDescription)
        } else {
            self.navigationController.popToRootViewControllerAnimated(true)
        }
        
    }

}
