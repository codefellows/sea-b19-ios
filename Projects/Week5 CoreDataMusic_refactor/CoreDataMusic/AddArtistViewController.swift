//
//  AddArtistViewController.swift
//  CoreDataMusic
//
//  Created by Bradley Johnson on 8/19/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit
import CoreData

class AddArtistViewController: UIViewController {
    
      var myContext : NSManagedObjectContext!
    var selectedLabel : Label?

    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameFIeld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        var labelContext = self.selectedLabel?.managedObjectContext
        
        var newArtist = NSEntityDescription.insertNewObjectForEntityForName("Artist", inManagedObjectContext: labelContext) as Artist
        newArtist.firstName = self.firstNameFIeld.text
        newArtist.lastName = self.lastNameField.text
        newArtist.label = self.selectedLabel!
        var error : NSError?
        labelContext?.save(&error)
        if error != nil {
            println(error?.localizedDescription)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
