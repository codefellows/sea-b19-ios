//
//  FilteredImageView.swift
//  Swiftagram
//
//  Created by John Clem on 8/6/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import UIKit

@IBDesignable class FilteredImageView: UIImageView {

    var sepiaFilter = CIFilter(name: "CISepiaTone")
    
    @IBInspectable var sepiaIntensity : CGFloat = 1.0 {
        didSet {
            sepiaFilter.setValue(self.coreImageBackedImage(), forKey: kCIInputImageKey)
            sepiaFilter.setValue(sepiaIntensity, forKey: kCIInputIntensityKey)
            self.image = UIImage(CIImage: sepiaFilter.outputImage)
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            self.layer.setNeedsDisplay()
        }
    }
    
    func coreImageBackedImage() -> CIImage {
        let ciImage = CIImage(CGImage: self.image.CGImage)
        return ciImage
    }
}
