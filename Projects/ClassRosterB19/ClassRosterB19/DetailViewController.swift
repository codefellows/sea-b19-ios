//
//  DetailViewController.swift
//  ClassRosterB19
//
//  Created by Bradley Johnson on 7/22/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var firstNameTextField: UITextField?
    @IBOutlet var lastNameTextField: UITextField?
    @IBOutlet var imageView : UIImageView?
    
    let textFieldPadding : CGFloat = 100.0
    
    var person : Person!

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField!.text = person.firstName
        lastNameTextField!.text = person.lastName
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView!.layer.cornerRadius = 0.5 * self.imageView!.frame.width
        self.imageView!.layer.masksToBounds = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        person.firstName = firstNameTextField!.text
        person.lastName = lastNameTextField!.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        println("began editing")
        
        let currentWidth = self.view.bounds.width
        let currentHeight = self.view.bounds.height
        let newY = textField.frame.origin.y - self.textFieldPadding
        let currentX = self.view.bounds.origin.x
        
        UIView.animateWithDuration(0.3, animations:{ () -> Void
            in
            
//            self.view.bounds = CGRect(x: currentX, y: newY, width: currentWidth, height:currentHeight)
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0.0, -120.0)
            
            })
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        println("did end editing")
        
        let currentWidth = self.view.bounds.width
        let currentHeight = self.view.bounds.height
//        UIView.animateWithDuration(0.3, animations:{ () -> Void
//            in
//            
//            self.view.bounds = CGRect(x: 0, y: 0, width: currentWidth, height:currentHeight)
//            
//            })

        UIView.animateWithDuration(0.3) {
//            self.view.bounds = CGRect(x: 0, y: 0, width: currentWidth, height:currentHeight)
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0.0, 120.0)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
//        for control in self.view.subviews {
//            if let theControl = control as? UITextField {
//                theControl.resignFirstResponder()
//            }
        self.view.endEditing(true)
        //}
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
