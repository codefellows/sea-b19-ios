//
//  DetailViewController.swift
//  ClassRosterB19
//
//  Created by Bradley Johnson on 7/22/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField
    @IBOutlet var lastNameTextField: UITextField
    var person : Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.text = person.firstName
        lastNameTextField.text = person.lastName
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        person.firstName = firstNameTextField.text
        person.lastName = lastNameTextField.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
