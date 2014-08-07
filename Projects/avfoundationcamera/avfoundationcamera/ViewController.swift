//
//  ViewController.swift
//  avfoundationcamera
//
//  Created by Bradley Johnson on 8/7/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit
import AVFoundation
import CoreVideo
import ImageIO
import QuartzCore
import CoreMedia

class ViewController: UIViewController {
    
    //used for capturing a photo from AVCaptureSession
    var stillImageOutput = AVCaptureStillImageOutput()
                            
   
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //create a capturesession
        var captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        //setup preview layer
        var layer = self.view.layer
        var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        println(self.view.bounds)
        previewLayer.frame = self.view.bounds
        self.view.layer.addSublayer(previewLayer)
        
        //setup input device
        var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError?
        var input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as AVCaptureDeviceInput!
        
            if error != nil {
                //will print error if creating the input device does not work, IE simulator
            println(error!.localizedDescription)
            }
            else {
                captureSession.addInput(input)
                
                //create ouput
                var outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                self.stillImageOutput.outputSettings = outputSettings
                captureSession.addOutput(self.stillImageOutput)
                captureSession.startRunning()
        }
        }
        
    @IBAction func takePhoto(sender: AnyObject) {
        
        var videoConnection : AVCaptureConnection?
        
        for connection in self.stillImageOutput.connections {
            
            if let cameraConnection = connection as? AVCaptureConnection {
                for port in cameraConnection.inputPorts {
                    if let videoPort = port as? AVCaptureInputPort {
                        
                        if videoPort.mediaType == AVMediaTypeVideo {
                            videoConnection = cameraConnection
                        }
                    }
                }
                
            }
            
        }
        
self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (buffer, error) -> Void in
    
//    if let dict = CMGetAttachment(buffer, kCGImagePropertyExifDictionary, nil) as? Unmanaged<CFDictionaryRef> {
//        
//    }
    
                var data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                var image = UIImage(data: data)
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            self.imageView.image = image
        })
    
})
        
    }
        
    }




