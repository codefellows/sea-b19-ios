//
//  PhotoEditingViewController.swift
//  Photo Filter
//
//  Created by John Clem on 8/6/14.
//
//

import UIKit
import AVFoundation
import CoreImage
import CoreMedia
import Photos
import PhotosUI

class PhotoEditingViewController: UIViewController, PHContentEditingController, UICollectionViewDataSource, UICollectionViewDelegate {

    let kFilterInfoFilterNameKey = "filterName"
    let kFilterInfoDisplayNameKey = "displayName"
    let kFilterInfoPreviewImageKey = "previewImage"
    let kPhotoExtensionBundleID = "org.codefellows.coreimage.extension"
    let kCurrentReleaseVersion = "1.0"
    
    @IBOutlet var collectionView : UICollectionView?
    @IBOutlet var filterPreviewView : UIImageView?
    
    var availableFilterInfos = NSArray()
    var selectedFilterName = "CISepiaTone"
    var initialFilterName = "CISepiaTone"
    var inputImage : UIImage?
    var ciFilter = CIFilter(name: "CISepiaTone")
    var ciContext = CIContext(options: nil)
    
    var contentEditingInput : PHContentEditingInput?
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadAvailableFilters()
    }
    
    func configureCollectionView() {
        if let collectionView = self.collectionView {
            collectionView.alwaysBounceHorizontal = true
            collectionView.allowsMultipleSelection = false
            collectionView.allowsSelection = true
        }
    }
    
    func loadAvailableFilters() {
        let plist = NSBundle.mainBundle().pathForResource("Filters", ofType: "plist")
        self.availableFilterInfos = NSArray(contentsOfFile: plist)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update the selection UI
        var item : Int?
        
        for i in 0..<self.availableFilterInfos.count {
            let filterInfo = self.availableFilterInfos[i] as Dictionary<String,String>
            let filterName = filterInfo[kFilterInfoFilterNameKey]
            if filterName == self.selectedFilterName {
                item = i
                break
            }
        }
        
        if item != nil {
            let indexPath = NSIndexPath(forItem: item!, inSection: 0)
            if self.collectionView != nil {
                self.collectionView!.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
                self.updateSelectionForCell(self.collectionView!.cellForItemAtIndexPath(indexPath))
            }
        }
    }
    
    // MARK: - PHContentEditingController
    
    func canHandleAdjustmentData(adjustmentData: PHAdjustmentData!) -> Bool {
        var result = adjustmentData.formatIdentifier == kPhotoExtensionBundleID
        result &= adjustmentData.formatVersion == kCurrentReleaseVersion
        return result
    }
    
    func startContentEditingWithInput(contentEditingInput: PHContentEditingInput!, placeholderImage: UIImage!) {
        self.contentEditingInput = contentEditingInput
        
        // Load input image
        switch self.contentEditingInput!.mediaType {
        case .Image:
            self.inputImage = self.contentEditingInput!.displaySizeImage
        case .Video:
            self.inputImage = self.imageForAVAsset(self.contentEditingInput!.avAsset, atTime: 0.0)
        default:
            break
        }
        
        // Load adjustment data, if any
        if let adjustmentData = self.contentEditingInput!.adjustmentData {
            self.selectedFilterName = NSKeyedUnarchiver.unarchiveObjectWithData(adjustmentData.data) as String
        }
        
        if self.selectedFilterName == nil {
            self.selectedFilterName = "CISepiaTone"
        }
        
        self.initialFilterName = self.selectedFilterName
        
        // Update filter and image
        self.updateFilter()
        self.updateFilterPreview()
    }
    
    func finishContentEditingWithCompletionHandler(completionHandler: ((PHContentEditingOutput!) -> Void)!) {
        let contentEditingOutput = PHContentEditingOutput(contentEditingInput: contentEditingInput)
        
        // Adjustment Data
        let archivedData = NSKeyedArchiver.archivedDataWithRootObject(self.selectedFilterName)
        let adjustmentData = PHAdjustmentData(formatIdentifier: kPhotoExtensionBundleID, formatVersion: self.kCurrentReleaseVersion, data: archivedData)
        contentEditingOutput.adjustmentData = adjustmentData
        
        if contentEditingInput != nil {
            switch contentEditingInput!.mediaType {
            case .Image:
                // Get the full size image
                let url = contentEditingInput!.fullSizeImageURL
                var orientation = Int(contentEditingInput!.fullSizeImageOrientation)
                
                // Generate rendered JPEG data
                var image = UIImage(contentsOfFile: url.path)
                image = self.transformedImage(image, withOrientation: orientation, usingFilter: ciFilter)
                let renderedJPEGData = UIImageJPEGRepresentation(image, 0.9)
                
                // Save JPEG data
                var error : NSError?
                let success = renderedJPEGData.writeToURL(contentEditingOutput.renderedContentURL, options: NSDataWritingOptions.AtomicWrite, error: &error)
                if success {
                    completionHandler(contentEditingOutput)
                } else {
                    println("Error writing JPEG data: \(error?.localizedDescription)")
                    completionHandler(nil)
                }
            case .Video:
                println("need to implement video support here")
            default:
                break
            }
            
        }
    }
    
    func cancelContentEditing() {
        // Handle cancellation
    }
    
    var shouldShowCancelConfirmation : Bool {
        return self.selectedFilterName != self.initialFilterName
    }
    
    // MARK: - Image Filtering
    
    func updateFilter() {
        self.ciFilter = CIFilter(name: self.selectedFilterName)
        
        if self.inputImage != nil {
            var inputImage = CIImage(CGImage: self.inputImage?.CGImage)
            let orientation = self.orientationFromImageOrientation(self.inputImage!.imageOrientation)
            inputImage = inputImage.imageByApplyingOrientation(orientation)
            self.ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
        }
        
    }
    
    func updateFilterPreview() {
        let cgImage = ciContext.createCGImage(ciFilter.outputImage, fromRect: ciFilter.outputImage.extent())
        filterPreviewView?.image = UIImage(CGImage: cgImage)
    }
    
    // MARK: AAPLAVReaderWriterAdjustDelegate (Video Filtering)
    
    func adjustPixelBuffer(inputBuffer: CVPixelBufferRef, toOutputBuffer outputBuffer: CVPixelBufferRef) {
        var img = CIImage(CVPixelBuffer: inputBuffer)
        
        self.ciFilter.setValue(img, forKey: kCIInputImageKey)
        img = self.ciFilter.outputImage
        
        self.ciContext.render(img, toCVPixelBuffer: outputBuffer)
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let filterInfo = availableFilterInfos[indexPath.item] as NSDictionary
        let displayName = filterInfo[kFilterInfoDisplayNameKey] as String
        let previewImageName = filterInfo[kFilterInfoPreviewImageKey] as String
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoFilterCell", forIndexPath: indexPath) as UICollectionViewCell
        
        if let imageView = cell.viewWithTag(999) as? UIImageView {
            imageView.image = UIImage(named: previewImageName)
        }
        
        if let label = cell.viewWithTag(998) as? UILabel {
            label.text = displayName
        }
        
        self.updateSelectionForCell(cell)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return self.availableFilterInfos.count
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        if let filterName = availableFilterInfos[indexPath.item][kFilterInfoFilterNameKey] as? String {
            self.selectedFilterName = filterName
            self.updateFilter()
        }
        
        self.updateSelectionForCell(collectionView.cellForItemAtIndexPath(indexPath))
        
        self.updateFilterPreview()
    }
    
    func collectionView(collectionView: UICollectionView!, didDeselectItemAtIndexPath indexPath: NSIndexPath!) {
        self.updateSelectionForCell(collectionView.cellForItemAtIndexPath(indexPath))
    }
    
    func updateSelectionForCell(cell: UICollectionViewCell) {
        var isSelected = cell.selected
        
        if let imageView = cell.viewWithTag(999) as? UIImageView {
            imageView.layer.borderColor = self.view.tintColor.CGColor
            imageView.layer.borderWidth = isSelected ? 2.0 : 0.0
        }
        
        if let label = cell.viewWithTag(998) as? UILabel {
            label.textColor = isSelected ? self.view.tintColor : UIColor.whiteColor()
        }
    }

    // MARK: Utilities
    
    func transformedImage(image: UIImage, withOrientation orientation: Int, usingFilter filter: CIFilter) -> UIImage {
        var inputImage = CIImage(CGImage: image.CGImage)
        inputImage = inputImage.imageByApplyingOrientation(Int32(orientation))
        
        self.ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage = self.ciFilter.outputImage
        
        let cgImage = self.ciContext.createCGImage(outputImage, fromRect: outputImage.extent())
        
        return UIImage(CGImage: cgImage)
    }
    
//* Returns the EXIF/TIFF orientation value corresponding to the given UIImageOrientation value
    func orientationFromImageOrientation(imageOrientation : UIImageOrientation) -> Int32 {
        
        var o : Int32!
        
        switch imageOrientation {
            case .Up:               o = 1
            case .Down:             o = 3
            case .Left:             o = 8
            case .Right:            o = 6
            case .UpMirrored:       o = 2
            case .DownMirrored:     o = 4
            case .LeftMirrored:     o = 5
            case .RightMirrored:    o = 7
            default:                o = 0
        }
        
        return o
    }
    
    func imageForAVAsset(asset: AVAsset, atTime time: NSTimeInterval) -> UIImage {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var posterImage = imageGenerator.copyCGImageAtTime(CMTimeMake(Int64(time), 100), actualTime: nil, error: nil)
        return UIImage(CGImage: posterImage)
    }
}
