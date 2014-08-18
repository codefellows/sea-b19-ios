//
//  ViewController.swift
//  mapkitdemo
//
//  Created by Bradley Johnson on 8/18/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController,UITextFieldDelegate,MKMapViewDelegate,CLLocationManagerDelegate {
                            
    @IBOutlet weak var mapVIew: MKMapView!
    @IBOutlet weak var latFIeld: UITextField!
    @IBOutlet weak var longField: UITextField!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() as CLAuthorizationStatus {
        case .Authorized:
            println("authorized, great!")
            //this status is for always requesting
              self.mapVIew.showsUserLocation = true
             self.locationManager.startUpdatingLocation()
            
        case .NotDetermined:
            println("must be firsh launch")
            self.locationManager.requestAlwaysAuthorization()
        case .Restricted:
            println("youre out of luck, sorry bro")
        case .AuthorizedWhenInUse:
            println("authorized for when in use")
            //when were authorized, show user location and start updating locations
            self.mapVIew.showsUserLocation = true
            //this one is for the high power, standard location services
            //self.locationManager.startUpdatingLocation()
            
            //this is the significant location monitoring, will only fire when location changes > 500 meters
           
            
        case .Denied:
            println("fire an alertview, pleading with the user about turning it on")
        }
        
        
        
        //creating a region at the start
//        var location = CLLocationCoordinate2D(latitude: 47.6, longitude: -122.3)
//        self.mapVIew.region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000)
        
        self.latFIeld.delegate = self
        self.longField.delegate = self
        
        var ground = CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0444)
        var eye = CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0442)
        
        var camera = MKMapCamera(lookingAtCenterCoordinate: ground, fromEyeCoordinate: eye, eyeAltitude: 50)
        self.mapVIew.camera = camera
        
        //setup our longpress gesture recognizer
//        var longPress = UILongPressGestureRecognizer(target: self, action: "mapPressed:")
//        self.mapVIew.addGestureRecognizer(longPress)
        
        var pan = UIPanGestureRecognizer(target: self, action: "mapPanned:")
        self.view.addGestureRecognizer(pan)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func mapPressed(sender : UILongPressGestureRecognizer) {
        switch sender.state {
        case .Began:
            println("Began")
        case .Changed:
            println("Changed")
        case .Ended:
            println("Ended")
        default:
            println("default")
        }
        
    }
    
    func mapPanned(sender : UIPanGestureRecognizer) {
        
        switch sender.state {
        case .Changed:
            var point = sender.translationInView(self.view)
            println(point)
        default:
            println("default")
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            println("they said yes")
            self.mapVIew.showsUserLocation = true
            self.locationManager.startUpdatingLocation()
            
        case .Denied:
            println("this is terrible")
        case .AuthorizedWhenInUse:
            println("they said yes, when in use")
            self.mapVIew.showsUserLocation = true
        default:
            println("auth did change, default")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("location did update")
        
        if let location = locations.last as? CLLocation {
            println(location.coordinate.latitude)
            println(location.coordinate.longitude)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func goPressed(sender: AnyObject) {
        
        var latString = NSString(string: self.latFIeld.text)
        var lat = latString.doubleValue
        
        var longString = NSString(string: self.longField.text)
        var long = longString.doubleValue
        
        var newLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        var region = MKCoordinateRegionMakeWithDistance(newLocation, 1000, 1000)
        
        self.mapVIew.setRegion(region, animated: true)
        
    }

}

