//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Sachin Vas on 21/11/17.
//  Copyright © 2017 MobStac. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import Beaconstac
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("On")
        }
    }

    var window: UIWindow?
    var beaconstac: Beaconstac!
    var locationManager: CLLocationManager!
    var bluetoothManager: CBPeripheralManager!
    
    var MY_DEVELOPER_TOKEN = "<MY DEVELOPER TOKEN>"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {[weak self] (success, error) in
            if success {
                UNUserNotificationCenter.current().delegate = self
            } else {
                print(error ?? "")
            }
        }
        
        let options = [CBPeripheralManagerOptionShowPowerAlertKey: true]
        bluetoothManager = CBPeripheralManager(delegate: self, queue: nil, options: options)

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if let viewController = (self.window?.rootViewController as? UINavigationController)?.topViewController as? ViewController {
                Beaconstac.sharedInstance(MY_DEVELOPER_TOKEN, delegate: viewController, completion: {[weak self] (beaconstacInstance, error) in
                    if let instance = beaconstacInstance {
                        self?.beaconstac = instance
                        self?.beaconstac.startScanningBeacons()
                        self?.beaconstac.notificationDelegate = viewController
                        self?.beaconstac.webhookDelegate = viewController
                        self?.beaconstac.ruleDelegate = viewController
                    }
                })
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var notificationPresentationOptions: UNNotificationPresentationOptions
        if let notificationOption = beaconstac.notificationOptionsForBeaconstacNotification(notification) {
            notificationPresentationOptions = notificationOption
        } else {
            // Your configuration...
            notificationPresentationOptions = .sound
        }
        completionHandler(notificationPresentationOptions)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        if beaconstac.showCardViewerForLocalNotification(notification) {
            // We will handle the notification...
        } else {
            // Leave it to us...
        }
        completionHandler()
    }
}
