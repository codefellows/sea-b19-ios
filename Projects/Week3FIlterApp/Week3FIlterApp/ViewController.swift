//
//  ViewController.swift
//  Week3App
//
//  Created by Bradley Johnson on 8/3/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, SelectedPhotoDelegate, PHPhotoLibraryChangeObserver {
    
    var collectionsFetchResults = [PHFetchResult]()
    var collectionsLocalizedTitles = [String]()
    
    var selectedAsset : PHAsset?
    
    let adjustmentFormatterIndentifier = "com.filterappdemo.cf"
    
    var context = CIContext(options: nil)
                            

    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
//        var smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: PHAssetCollectionSubtype.AlbumRegular, options: nil)
//        var topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
//        self.collectionsFetchResults = [smartAlbums,topLevelUserCollections]
//        self.collectionsLocalizedTitles = ["Smart Albums", "Albums"]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
//    
//    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
//        
//        return 1 + self.collectionsFetchResults.count
//    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        
//        if segue.identifier == "Photo" {
//            var gridVC = segue.destinationViewController as GridViewController
//            gridVC.assetsFetchResults = PHAsset.fetchAssetsWithOptions(nil)
//            
//        }
//    }
    
    //MARK: UICollectionViewDataSource
    
//    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
//        
//        if section == 0 {
//            return 1
//        }
//        else {
//            var fetchResult = self.collectionsFetchResults[section - 1] as PHFetchResult
//            var numberOfRows = fetchResult.count
//            return numberOfRows
//        }
//    }
//    
//    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!  {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumsCell", forIndexPath: indexPath) as UITableViewCell
//        if indexPath.section == 0 {
//            cell.textLabel.text = "All Photos"
//        }
//        else {
//            var fetchResult = self.collectionsFetchResults[indexPath.section - 1]
//            var collection = fetchResult[indexPath.row] as PHCollection
//            cell.textLabel.text = collection.localizedTitle
//        }
//        return cell
//    }
//    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "ShowGrid" {
            let gridVC = segue.destinationViewController as GridViewController
            gridVC.assetsFetchResults = PHAsset.fetchAssetsWithOptions(nil)
            gridVC.delegate = self
        }
    }
    
    func photoSelected(asset : PHAsset) -> Void {
        
        self.selectedAsset = asset
        self.updateImage()
        
//        var targetSize = CGSize(width: CGRectGetWidth(self.imageView.bounds), height: CGRectGetHeight(self.imageView.bounds))
//        
//        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFit, options: nil, resultHandler: {(result : UIImage!, [NSObject : AnyObject]!) -> Void in
//            
//            if result {
//                self.imageView.image = result
//            }
//            
//            })

        
        
        
    }
    
    @IBAction func handleSepiaPressed(sender: AnyObject) {
        
        var options = PHContentEditingInputRequestOptions()
        options.canHandleAdjustmentData = {(data : PHAdjustmentData!) -> Bool in
            
            return data.formatIdentifier == self.adjustmentFormatterIndentifier && data.formatVersion == "1.0"
        }
        
        self.selectedAsset!.requestContentEditingInputWithOptions(options, completionHandler: { ( contentEditingInput : PHContentEditingInput!, info : [NSObject : AnyObject]!) -> Void in
            
            //grabbing the image and converting it to CIImage
            var url = contentEditingInput.fullSizeImageURL
            var orientation = contentEditingInput.fullSizeImageOrientation
            var inputImage = CIImage(contentsOfURL: url)
            inputImage = inputImage.imageByApplyingOrientation(orientation)
            
            //creating the filter
            var filterName = "CISepiaTone"
            var filter = CIFilter(name: filterName)
            filter.setDefaults()
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            var outputImage = filter.outputImage
            
            var cgimg = self.context.createCGImage(outputImage, fromRect: outputImage.extent())
            var finalImage = UIImage(CGImage: cgimg)
            var jpegData = UIImageJPEGRepresentation(finalImage, 1.0)
            
            //create our adjustmentdata
            var adjustmentData = PHAdjustmentData(formatIdentifier: self.adjustmentFormatterIndentifier, formatVersion: "1.0", data: jpegData)
            var contentEditingOutput = PHContentEditingOutput(contentEditingInput:contentEditingInput)
            jpegData.writeToURL(contentEditingOutput.renderedContentURL, atomically: true)
            contentEditingOutput.adjustmentData = adjustmentData
            
            //requesting the change
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                //change block
                var request = PHAssetChangeRequest(forAsset: self.selectedAsset)
                request.contentEditingOutput = contentEditingOutput

                }, completionHandler: { (success : Bool,error : NSError!) -> Void in
                    //completionHandler for the change
                    if !success {
                        println(error.localizedDescription)
                    }
                
            })
            
            
        })
    }
    
    func updateImage() {
        
        var targetSize = self.imageView.frame.size
        PHImageManager.defaultManager().requestImageForAsset(self.selectedAsset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (result : UIImage!, info : [NSObject : AnyObject]!) -> Void in
            self.imageView.image = result
        }
        
    }
    
    func photoLibraryDidChange(changeInstance: PHChange!) {
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            
            if self.selectedAsset != nil {
                var changeDetails = changeInstance.changeDetailsForObject(self.selectedAsset)
                if changeDetails != nil {
                    self.selectedAsset = changeDetails.objectAfterChanges as? PHAsset
                    
                    if changeDetails.assetContentChanged {
                        
                        self.updateImage()
                    
                    }
                    
                }
            }
        }
    }
}

