//
//  ViewController.swift
//  SwiftExample
//
//  Copyright © 2016 Mobstac Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BeaconstacDelegate
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        MSLogger.sharedInstance().loglevel = .Verbose
        
        let beaconstac = Beaconstac.sharedInstanceWithOrganizationId(10, developerToken: "1ccxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
        beaconstac.allowRangingInBackground = true
        beaconstac.delegate = self
        beaconstac.startRangingBeaconsWithUUIDString("F94DBB23-2266-7822-3782-57BEAC0952AC", beaconIdentifier: "MobstacRegion", filterOptions: ["myBeacons":true])
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func triggerLocalNotificationWithMessage(message: String) {
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 0.1)
        notification.alertBody = message
        notification.alertAction = "open"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // MARK: Beaconstac Delegate
    func beaconstac(beaconstac: Beaconstac!, didEnterBeaconRegion region: CLBeaconRegion!) {
        print("Beacon region entered \(region.identifier)")
        
        triggerLocalNotificationWithMessage("Entered beacon region \(region.identifier)")
    }
    
    func beaconstac(beaconstac: Beaconstac!, didExitBeaconRegion region: CLBeaconRegion!) {
        print("Beacon region exited \(region.identifier)")
        
        triggerLocalNotificationWithMessage("Exited beacon region \(region.identifier)")
    }
    
    
    func beaconstac(beaconstac: Beaconstac!, rangedBeacons beaconsDictionary: [NSObject : AnyObject]!) {
        print("Ranged beacons \(beaconsDictionary)")
    }
    
    func beaconstac(beaconstac: Beaconstac!, campedOnBeacon beacon: MSBeacon!, amongstAvailableBeacons beaconsDictionary: [NSObject : AnyObject]!) {
        print("Camped on beacon \(beacon)")
        
        triggerLocalNotificationWithMessage("Beacon camped on \(beacon.beaconKey)")
    }
    
    func beaconstac(beaconstac: Beaconstac!, exitedBeacon beacon: MSBeacon!) {
        print("Exited beacon \(beacon)")
    }
    
    func beaconstac(beaconstac: Beaconstac!, triggeredRuleWithRuleName ruleName: String!, actionArray: [AnyObject]!) {
        print("Triggered rule \(ruleName) with actions \(actionArray)")
    }
    
    func beaconstac(beaconstac: Beaconstac!, didEnterGeofenceRegion region: CLRegion!) {
        print("Entered geofence region \(region.identifier)")
    }
    
    func beaconstac(beaconstac: Beaconstac!, didExitGeofenceRegion region: CLRegion!) {
        print("Exited geofence region \(region.identifier)")
    }
    
    func beaconstac(beaconstac: Beaconstac!, didSyncRules ruleDict: [NSObject : AnyObject]!, withError error: NSError!) {
        print("Rules synced \(ruleDict)")
    }
    
    func beaconstac(beaconstac: Beaconstac!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        print("User Location updated from \(oldLocation) to \(newLocation)")
    }
}

