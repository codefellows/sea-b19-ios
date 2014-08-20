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
    
    var myContext : NSManagedObjectContext!
    @IBOutlet weak var labelNameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.myContext = appDelegate.managedObjectContext

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveLabelPressed(sender: AnyObject) {
        
        var newLabel = NSEntityDescription.insertNewObjectForEntityForName("Label", inManagedObjectContext: self.myContext) as Label
        newLabel.name = self.labelNameField.text
        var error : NSError?
        self.myContext.save(&error)
        if error != nil {
            println(error?.localizedDescription)
        }
        
        self.navigationController.popToRootViewControllerAnimated(true)
    
    }

}
