//
//  ViewController.swift
//  Week3FIlterApp
//
//  Created by Bradley Johnson on 8/4/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate {
    
    let photoPicker = UIImagePickerController()
    let cameraPicker = UIImagePickerController()
    var imageViewSize : CGSize!
    let alertView = UIAlertController(title: "Alert!", message: "stop", preferredStyle: UIAlertControllerStyle.Alert)
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.photoPicker.allowsEditing = true
        self.photoPicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageViewSize = self.imageView.frame.size
    }
    
    lazy var actionController : UIAlertController = {
        var actionController = UIAlertController(title: "Title", message: "message", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {( action: UIAlertAction!) -> Void in
            //present the camera picker
            self.presentViewController(self.alertView, animated: true, completion: nil)

            })
        let photoAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: {(action : UIAlertAction!) -> Void in
            //present the photo library
            self.presentViewController(self.photoPicker, animated: true, completion: nil)
            })
        actionController.addAction(cameraAction)
        actionController.addAction(photoAction)
        return actionController
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlePhotoButtonPressed(sender: AnyObject) {
        
        self.presentViewController(self.actionController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        var editedImage = info[UIImagePickerControllerEditedImage] as UIImage
        
//        //creating graphics context
//         UIGraphicsBeginImageContextWithOptions(self.imageViewSize, true, UIScreen.mainScreen().scale)
//        let context = UIGraphicsGetCurrentContext()
//        CGContextTranslateCTM(context, 0.0, self.imageViewSize.height)
//        CGContextScaleCTM(context, 1.0, -1.0)
//        //drawing image in context
//        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: self.imageViewSize.width, height: self.imageViewSize.height), editedImage.CGImage)
//        //getting output image from context
//        var outputImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        println("Edited Image Size: \(editedImage.size)")
//        
//        var outputImage = UIImage(CGImage: editedImage.CGImage, scale: 0.5, orientation: editedImage.imageOrientation)
//        
//        println("Output Image Size: \(outputImage.size)")

        self.imageView.image = editedImage
        self.dismissViewControllerAnimated(true, completion: nil)
        editedImage.CIImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        println("user canceled")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

