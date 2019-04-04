# iOS-SDK

## Introduction

Beaconstac Advanced iOS SDK is meant only for specialized use cases. Please check with the support team before deciding to integrate this SDK.

## Documentation

* Please refer to the [API reference](http://cocoadocs.org/docsets/Beaconstac).

## Demo app

Try out the Beaconstac Demo app on the [iTunes App Store](https://itunes.apple.com/us/app/beaconstac/id956442796?mt=8).

## Installation
##### Using Cocoapods (recommended):
Add the following to your Podfile in your project, we are supporting iOS 10.0+ make sure your pod has proper platform set.

```pod
platform :ios, '10.0'
target '<My-App-Target>''
  pod 'Beaconstac', '~> 3.2'
end
```

Run `pod install` in the project directory


#### Manually:

1. Download or clone this repo on your system.
2. Drag and drop the Beaconstac.framework file into your Xcode project. Make sure that "Copy Items to Destination's Group Folder" is checked.
<img src="images/frameworkdrop.png" alt="Build Phases" width="600">

3. Add the `Beaconstac.framework` and `EddystoneScanner.framework` to the embedded binaries section of your destination app target.

4. In Build Phases under destination app target, add the following frameworks in Link Binary With Libraries section:
- CoreData.framework
- SystemConfiguration.framework
- CoreBluetooth.framework
- CoreLocation.framework
- EddystoneScanner.framework

## Configure your project

1. In Info.plist, add a new fields, `NSLocationAlwaysUsageDescription`, `NSLocationAlwaysAndWhenInUsageDescription`, `NSBluetoothPeripheralUsageDescription` with relevant values that you want to show to the user. This is mandatory for iOS 10 and above.
<img src="images/usagedescription.png" alt="Build Phases" width="600">

## Pre-requisites

### Location

The app should take care of handling permissions as required.

1. To receive notifications in the background you must first enable the `Location Updates` and `Uses Bluetooth LE accessories` Background Modes in the Capabilities tab of your app target.



```swift
var locationManager = CLLocationManager()
locationManager.delegate = self
locationManager.requestAlwaysAuthorization()

func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways {
        if beaconstac != nil {
            beaconstac?.startScanningBeacons()
        } else {
            // Initialise Beaconstac SDK
        }
    } else {
        beaconstac?.stopScanningBeacons()

        // Show Alert to enable alwyas permission
    }
}

// Make sure you retain the CLLocationManager for the callbacks
// You need to handle the case where user doesn't provide `Always` permission
```

```objective-c
CLLocationManager *locationmanager = [[CLLocationManager alloc] init];
locationManager.delegate = self;
[locationManager requestAlwaysAuthorization];

- (void)locationManager:(CLLocationManager *)manager 
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        if beaconstac != nil {
           [beaconstac startScanningBeacons];
        } else {
            // Initialise Beaconstac SDK
        }
    } else {
        [beaconstac stopScanningBeacons];

        // Show Alert to enable always permission
    }
}
// Make sure you retain the CLLocationManager for the callbacks
// You need to handle the case where user doesn't provide `Always` permission
```

2. To receive notifications only in the foreground

```swift
var locationManager = CLLocationManager()
locationManager.delegate = self
locationManager.requestWhenInUseAuthorization()

func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == authorizedWhenInUse || status == .authorizedAlways {
        if beaconstac != nil {
            beaconstac?.startScanningBeacons()
        } else {
            // Initialise Beaconstac SDK
        }
    } else {
        beaconstac?.stopScanningBeacons()

        // Show Alert to enable permission
    }
}

// Make sure you retain the CLLocationManager for the callbacks
// You need to handle the case where user doesn't provide permission
```

```objective-c
CLLocationManager *locationmanager = [[CLLocationManager alloc] init];
locationManager.delegate = self;
[locationManager requestWhenInUseAuthorization];

- (void)locationManager:(CLLocationManager *)manager 
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        if beaconstac != nil {
           [beaconstac startScanningBeacons];
        } else {
            // Initialise Beaconstac SDK
        }
    } else {
        [beaconstac stopScanningBeacons];

        // Show Alert to enable alwyas permission
    }
}
// Make sure you retain the CLLocationManager for the callbacks
// You need to handle the case where user doesn't provide permission
```


__Bluetooth__

The app should take care of enabling the bluetooth to range beacons.

```swift
var bluetoothManager = CBCentralManager(delegate: self, queue: nil, options: nil)

func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn {
        beaconstac?.startScanningBeacons()
    } else {
        beaconstac?.stopScanningBeacons()
    }
}

// Make sure you retain the CBCentralManager for the callbacks
// You need to handle the case where user doesn't provide permission
```

```objective-c
CBCentralManager *bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStatePoweredOn) {
        [beaconstac startScanningBeacons];
    } else {
        [beaconstac stopScanningBeacons];
    }
}
// Make sure you retain the CBCentralManager for the callbacks
// You need to handle the case where user doesn't provide permission
```

__MY_DEVELOPER_TOKEN__

The app should provide the developer token while initializing the SDK. Get it from [Beaconstac Dashboard Account Page](https://dashboard.beaconstac.com/#/account).

__Monitoring Regions__

If you are using the region monitoring API's from advanced location manager, make sure it won't affect the Beaconstac SDK.

## Set Up

1. Import the framework header in your class

```swift
import Beaconstac
```

```objective-c
import <Beaconstac/Beaconstac.h>
```

2. Initialize `Beaconstac` using __one-line initialization__, the initialization starts scanning for beacons immediately.

```swift
do {
    Beaconstac.sharedInstance("MY_DEVELOPER_TOKEN", completion: : { (beaconstac, error) in
      if let beaconstacInstance = beaconstac {
        // Successful...
      } else if let e = error {
        print(e)
      }
    }))
} catch let error {
    print(error)
}
```

```objective-c
[Beaconstac sharedInstance:"" ibeaconOption:iBeaconOptionWhenInUseRange organization:123 delegate:self completion:^(Beaconstac * _Nullable beaconstacInstance, NSError * _Nullable error){
    if (!error) {
        //Successfull
    } else {
        NSLog("%@", error);
    }
}];
```


3. If you want to use the `advacnced integration`, use __iBeaconOption__ as defined below

| iBeaconOption                  |    Location Authorization  | Monitoring                       | Ranging                   | Description                                       |
|:------------------------------:|:--------------------------:|:--------------------------------:| :------------------------:|:----------------------------------------------:|
|              WhenInUse         |  When In Use Authorization | CoreLocation API doesn't support | CoreLocation API supports | SDK works only in the foreground               |
| BackgroundRangeOnDisplayWakeUp |  Always Authorization      | CoreLocation API supports        | CoreLocation API supports | SDK works in the background as well            |

```swift
do {
    Beaconstac.sharedInstance("My_DEVELOPER_TOKEN", ibeaconOption: .BackgroundRangeOnDisplayWakeUp, delegate: self, completion: : { (beaconstac, error) in
      if let beaconstacInstance = beaconstac {
          beaconstac?.startScanningBeacons()
          // Initialization successful, it just works...
      } else if let e = error {
          print(e)
      }
    })
} catch let error {
    print(error)
}
```

```objective-c
[Beaconstac sharedInstance:"" ibeaconOption:iBeaconOptionWhenInUseRange organization:123 delegate:self completion:^(Beaconstac * _Nullable beaconstacInstance, NSError * _Nullable error){
    if (!error) {
        //Successfull
      [beaconstacInstance startScanningBeacons]; 
    } else {
        NSLog("%@", error);
    }
}];
```

4. If you wish to get the ___sharedInstance()___ of the Beaconstac SDK, after you initialize the Beaconstac SDK at any point in a single application life cycle

```swift
do {
    beaconstacInstance = try Beaconstac.sharedInstance()
} catch let error {
    print(error)
}
```

```objective-c
NSError *error = nil;
[Beaconstac sharedInstanceAndReturnError:&error];
```

5. If you wish to control start and stop of scanning for beacons:

```swift
beaconstac.startScanningBeacons() // Starts scanning for beacons...
beaconstac.stopScanningBeacons() // Stops scanning for beacons...
```

```objective-c
[beaconstacInstance startScanningBeacons];
[beaconstacInstance stopScanningBeacons];
```

6. Implement `BeaconDelegate` protocol methods to receive callbacks when beacons are scanned

```swift

// In the class where you want to listen to the beacon scanning events...
beaconstacInstance = try! Beaconstac.sharedInstance()
beaconstacInstance.delegate = self

// required
func didFail(_ beaconstac: Beaconstac, error: Error) {
    print(error)
}

//Optional
func didEnterRegion(_ beaconstac: Beaconstac, region: String) {
    print(region)
}

func didRangeBeacons(_ beaconstac: Beaconstac, beacons: [MBeacon]) {
    print(beacons)
}

func didEnterBeacon(_ beaconstac: Beaconstac, beacon: MBeacon) {
    print(beacon)
}

func didExitBeacon(_ beaconstac: Beaconstac, beacon: MBeacon) {
    print(beacon)
}

func didExitRegion(_ beaconstac: Beaconstac, region: String) {
    print(region)
}
```

```objective-c

// In the class where you want to listen to the beacon scanning events...
NSError *error = nil;
Beconstac *beaconstacInstance = [Beaconstac sharedInstanceAndReturnError:&error];
beaconstacInstance.delegate = self;

// required
- (void)didFail:(Beaconstac * _Nonnull)beaconstac error:(NSError * _Nonnull)error {
    NSLog("%@", error);
}

//Optional
- (void)didEnterRegion:(Beaconstac * _Nonnull)beaconstac region:(NSString * _Nonnull)region {
    NSLog("%@", region);
}
    
- (void)didRangeBeacons:(Beaconstac * _Nonnull)beaconstac beacons:(NSArray<MBeacon *> * _Nonnull)beacons {
    NSLog("%@", beacons);
}
    
- (void)campOnBeacon:(Beaconstac * _Nonnull)beaconstac beacon:(MBeacon * _Nonnull)beacon {
    NSLog("%@", beacon);
}
    
- (void)exitBeacon:(Beaconstac *)beaconstac beacon:(MBeacon *)beacon {
    NSLog("%@", beacon);
}
    
- (void)didExitRegion:(Beaconstac * _Nonnull)beaconstac region:(NSString * _Nonnull)region {
    NSLog("%@", region);
}
```

7. Implement `RuleProcessorDelegate` protocol methods to receive callbacks when rules are triggered

```swift

// In the class where you want to listen to the rule triggering events...
beaconstacInstance = try! Beaconstac.sharedInstance()
beaconstacInstance.ruleDelegate = self

func willTriggerRule(_ beaconstac: Beaconstac, rule: MRule) {
    // read which rule is about to trigger and the actions, filters set by the marketers...
}

func didTriggerRule(_ beaconstac: Beaconstac, rule: MRule) {
    // read which rule is triggered and the actions, filters set by the marketers...
}
```

```objective-c

// In the class where you want to listen to the rule triggering events...
NSError *error = nil;
Beconstac *beaconstacInstance = [Beaconstac sharedInstanceAndReturnError:&error];
beaconstacInstance.ruleDelegate = self;

- (void)willTriggerRule:(Beaconstac * _Nonnull)beaconstac rule:(MRule * _Nonnull)rule {
    // read which rule is about to trigger and the actions, filters set by the marketers...
}

- (void)didTriggerRule:(Beaconstac * _Nonnull)beaconstac rule:(MRule * _Nonnull)rule {
    // read which rule is triggered and the actions, filters set by the marketers...
}
```

8. Implement `NotificationDelegate` protocol methods to override the display of the Local Notification.

```swift

// In the class where you want to listen to notification events...
beaconstacInstance = try! Beaconstac.sharedInstance()
beaconstacInstance.notificationDelegate = self

func overrideNotification(_ beaconstac: Beaconstac, notification: MNotification) {
    // If you override, you should handle everything from configuring, triggering and displaying of the notification.
}
```

```objective-c

// In the class where you want to listen to notification events...
NSError *error = nil;
Beconstac *beaconstacInstance = [Beaconstac sharedInstanceAndReturnError:&error];
beaconstacInstance.notificationDelegate = self;

- (void)overrideNotification:(Beaconstac * _Nonnull)beaconstac notification:(MNotification * _Nonnull)notification {
    // If you override, you should handle everything from configuring, triggering and displaying of the notification.
}
```

9. Implement `WebhookDelegate` protocol methods to add additional parameters to be sent to the webhook.

```swift
// In the class where you want to listen to webhook events...
beaconstacInstance = try! Beaconstac.sharedInstance()
beaconstacInstance.webhookDelegate = self

func addParameters(_ beaconstac: Beaconstac, webhook: MWebhook) -> Dictionary<String, Any> {
    // If you override, make sure the keys of the previously added ones
}
```

```objective-c

// In the class where you want to listen to notification events...
NSError *error = nil;
Beconstac *beaconstacInstance = [Beaconstac sharedInstanceAndReturnError:&error];
beaconstacInstance.webhookDelegate = self;

- (NSDictionary<NSString *, id> * _Nonnull)addParameters:(Beaconstac * _Nonnull)beaconstac webhook:(MWebhook * _Nonnull)webhook {
    // If you override, make sure the keys of the previously added ones
}
```

10. The `Latch_Latency`, defines how the campOn/campOff behaviour is adjusted when the SDK finds the beacon. Lets say, the SDK camped on to a beacon and there is a beacon who's latest RSSI, is less than the latest RSSI of the camped On beacon + the latch latency, then SDK camps off from the current beacon and camps on to this beacon.

```swift
beaconstacInstance = try! Beaconstac.sharedInstance()
beaconstacInstance.latchLatency = HIGH
```

```objective-c
NSError *error = nil;
Beconstac *beaconstacInstance = [Beaconstac sharedInstanceAndReturnError:&error];
beaconstacInstance.latchLatency = LatchLatencyHIGH;
```

11. If you don't listen to the `NotificationDelegate` protocol, the SDK configures, triggers UNNotification. However to present the notification do the following.

```swift

// Check if the notification is from SDK and provide UNNotificationPresentationOptions or nil by invoking the below method.
public func notificationOptionsForBeaconstacNotification(_ notification: UNNotification) -> UNNotificationPresentationOptions?


// EXAMPLE:
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    var notificationPresentationOptions: UNNotificationPresentationOptions
    if let notificationOption = try! beaconstac.sharedInstance().notificationOptionsForBeaconstacNotification(notification) {
      notificationPresentationOptions = notificationOption
    } else {
      // My Presenation options...
    }
    completionHandler(notificationPresentationOptions)
}



// Check if SDK can handle the notification by invoking the below method.
public func showCardViewerForLocalNotification(_ notification: UNNotification) -> Bool


// EXAMPLE:
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let notification = response.notification
    if beaconstac.showCardViewerForLocalNotification(notification) {
        // We will handle the notification...
    } else {
        // Handle it...
    }
    completionHandler()
}

```

```objective-c

// Check if the notification is from SDK and provide UNNotificationPresentationOptions or nil by invoking the below method.
- (UNNotificationPresentationOptions)notificationOptionsForBeaconstacNotification:(UNNotification *)notification;

// EXAMPLE:
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    UNNotificationPresentationOptions notificationPresentationOptions;
    
    NSError *error;
    Beaconstac *i = [Beaconstac sharedInstanceAndReturnError:&error];
    
    int option = [i notificationOptionsForBeaconstacNotification:notification];
    
    if (option != 0) {
        notificationPresentationOptions = (UNNotificationPresentationOptions)option;
    } else {
        // My Presenation options...
    }
    
    completionHandler(notificationPresentationOptions);
}



// Check if SDK can handle the notification by invoking the below method.
- (BOOL)showCardViewerForLocalNotification:(UNNotification * _Nonnull)notification;


// EXAMPLE:
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    UNNotification *notification = response.notification;
    if ([i showCardViewerForLocalNotification:notification]) {
        // We will handle the notification...
    } else {
        // Handle it...
    }
    completionHandler();
}

```

12. You are required to `add filters` regarding the app user, if the marketer has provided the filters. To do so

```swift
// Provide the filters to the SDK as Key-Value pairs using dictionary. Note keys are case insensitive.
func addFilters(_ filters: Dictionary<String, Any>)
```

```objective-c
// Provide the filters to the SDK as Key-Value pairs using dictionary. Note keys are case insensitive.
- (void)addFilters:(NSDictionary<NSString *, id> * _Nonnull)filters;
```
__Note__: If the rule contains the filters and app doesn't provide it, the rule will be treated as a filter validation failed and we won't trigger that particular rule.

13. The SDK collects `analytics` regarding how we collect the `iBeacon` related information and tie it to app user(MVisitor). If you know information about your app user, create a MVisitor object and provide it to us.

```swift
// If you know the your app visitor, create a Visitor object and call this on the Beaconstac instance.
func setVisitor(_ visitor: MVisitor)
```

```objective-c
// If you know the your app visitor, create a Visitor object and call this on the Beaconstac instance.
- (void)setVisitor:(MVisitor * _Nonnull)visitor;
```
