//
//  ViewController.swift
//  SwiftExample
//
//  Copyright © 2015 Mobstac Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BeaconstacDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var beaconstac = Beaconstac.sharedInstanceWithOrganizationId(1xx, developerToken: "1ccxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
        MSLogger.sharedInstance().loglevel = MSLogLevel.Verbose
        
        beaconstac.delegate = self
        beaconstac.startRangingBeaconsWithUUIDString("F94DBB23-2266-7822-3782-57BEAC0952AC", beaconIdentifier: "MobstacRegion", filterOptions: nil)
    }

    func beaconstac(beaconstac: Beaconstac!, rangedBeacons beaconsDictionary: [NSObject : AnyObject]!)
    {
        print("Beacons ranged" + beaconsDictionary.description)
    }
    
    func beaconstac(beaconstac: Beaconstac!, campedOnBeacon beacon: MSBeacon!, amongstAvailableBeacons beaconsDictionary: [NSObject : AnyObject]!)
    {
        print("Camped On Beacon" + beacon.beaconKey)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

