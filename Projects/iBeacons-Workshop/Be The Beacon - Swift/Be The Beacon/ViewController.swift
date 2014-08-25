//
//  ViewController.swift
//  Be The Beacon
//
//  Created by John Clem on 8/21/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController, CBPeripheralManagerDelegate {
    
    let THE_EAST_ROOM_UUID = NSUUID(UUIDString: "46003A0A-862B-40C4-9C5F-D1F43FF7E9BB")
    let CODE_FELLOWS_REGION_ID = "org.codefellows.the_east_room"
    
    var region : CLBeaconRegion!
    var beaconData : NSDictionary!
    var peripheralManager : CBPeripheralManager!
    
    @IBOutlet var statusLabel : UILabel!
    @IBOutlet var startButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        region = CLBeaconRegion(proximityUUID: THE_EAST_ROOM_UUID, identifier: CODE_FELLOWS_REGION_ID)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        startButton.setTitle("Start", forState: .Normal)
    }
    
    @IBAction func toggleBroadcast(sender: AnyObject!) {
        // Get the beacon data to advertise
        beaconData = region.peripheralDataWithMeasuredPower(nil)
        
        // Start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    //MARK: CBPeripheralManagerDelegate
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
        var nextColor = UIColor.darkGrayColor()
        
        switch peripheral.state {
        case .PoweredOn:
            nextColor = UIColor(red: 0.4, green: 0.8, blue: 0.6, alpha: 1.0)
            self.startBroadcasting()
        case .PoweredOff:
            nextColor = UIColor(red: 0.8, green: 0.447, blue: 0.404, alpha: 1.0)
            self.stopBroadcasting()
        default:
            self.deviceNotSupported()
        }
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.backgroundColor = nextColor
        })
    }
    
    func startBroadcasting() {
        self.statusLabel.text = "Broadcasting..."
        self.startButton.setTitle("Stop", forState: .Normal)
        self.peripheralManager.startAdvertising(beaconData)
    }
    
    func stopBroadcasting() {
        // Update our status label
        self.statusLabel.text = "Stopped"
        self.startButton.setTitle("Start", forState: .Normal)
        // Bluetooth isn't on. Stop broadcasting
        self.peripheralManager.stopAdvertising()
    }
    
    func deviceNotSupported() {
        
    }
}

