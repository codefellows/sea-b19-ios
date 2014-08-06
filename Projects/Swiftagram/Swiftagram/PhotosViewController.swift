//
//  ViewController.swift
//  Swiftagram
//
//  Created by John Clem on 8/5/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    var fetchResult : PHFetchResult!
    var imageManager = PHImageManager()
    var scrollOffset : CGFloat = 0.0
    var collectionViewSize : CGSize!
    
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollOffset = self.collectionView.frame.origin.y
        collectionViewSize = self.collectionView.frame.size
        
        fetchResult = PHAsset.fetchAssetsWithOptions(nil)
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Touch Handlers
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        println("Content Offset: \(scrollView.contentOffset.y)")
        
        var scrollAmount = scrollOffset - scrollView.contentOffset.y
        var adjustedSize = collectionViewSize
        adjustedSize.height = min(collectionViewSize.height, collectionViewSize.height + scrollView.contentOffset.y)
        
        println("Scroll Amount: \(scrollAmount)")

        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.collectionView.frame = CGRect(origin: CGPoint(x: 0.0, y: scrollAmount), size: adjustedSize)
        })

//        if header.bounds.origin.y < 0.0 {
//        }
//        
//        if scrollView.contentOffset.y < 0.0 {
//            if header.bounds.origin.y > 0.0 {
//                
//            }
//
//        }
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        for touch in touches {
            let header = self.collectionView(self.collectionView, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: 0))
            if touch.locationInView(header) != nil {
                println("Touches Began - Header")
            } else {
                super.touchesBegan(touches, withEvent: event)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        for touch in touches {
            let header = self.collectionView(self.collectionView, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: 0))
            if touch.locationInView(header) != nil {
                println("Touches Moved - Header")
            } else {
                super.touchesMoved(touches, withEvent: event)
            }
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        for touch in touches {
            let header = self.collectionView(self.collectionView, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: 0))
            if touch.locationInView(header) != nil {
                println("Touches Cancelled - Header")
            } else {
                super.touchesCancelled(touches, withEvent: event)
            }
        }

    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        for touch in touches {
            let header = self.collectionView(self.collectionView, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: 0))
            if touch.locationInView(header) != nil {
                println("Touches Ended - Header")
            } else {
                super.touchesEnded(touches, withEvent: event)
            }
        }
    }


    //MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView!, viewForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath!) -> UICollectionReusableView! {
        
        var header : PhotosCollectionHeaderView!
        
        if kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as PhotosCollectionHeaderView
        }
        
        return header
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.countOfAssetsWithMediaType(PHAssetMediaType.Image)
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as UICollectionViewCell
        
        var asset = fetchResult[indexPath.row] as PHAsset
        
        imageManager.requestImageForAsset(asset, targetSize: cell.bounds.size, contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
            var hasImageView = false
            var imageView : UIImageView?
            
            for subview in cell.subviews {
                if subview.isKindOfClass(UIImageView) {
                    imageView = subview as? UIImageView
                    hasImageView = true
                }
            }
            
            if imageView == nil {
                imageView = UIImageView(frame: cell.bounds)
                cell.addSubview(imageView!)
            }
            
            imageView!.image = image
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        var asset = fetchResult[indexPath.row] as PHAsset
        
        imageManager.requestImageForAsset(asset, targetSize: self.imageView.bounds.size, contentMode: PHImageContentMode.AspectFit, options: nil) { (image, info) -> Void in
            self.imageView!.image = image
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell.layer.borderColor = self.view.tintColor.CGColor
            cell.layer.borderWidth = 2.0
        }
    }
    
    func collectionView(collectionView: UICollectionView!, didDeselectItemAtIndexPath indexPath: NSIndexPath!) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell.layer.borderWidth = 0.0
    }
    
}

