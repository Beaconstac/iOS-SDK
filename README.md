# iOS-SDK

## Introduction

Beaconstac SDK is an easy way to enable proximity marketing and location analytics through an iBeacon-compliant BLE network.

## Documentation

* Please refer to the [API reference](http://cocoadocs.org/docsets/Beaconstac).
* Tutorials and Programming guide available at http://docs.beaconstac.com/docs/references.html

## Demo app

Try out the Beaconstac Demo app on the [iTunes App Store](https://itunes.apple.com/us/app/beaconstac/id956442796?mt=8).

## Installation
##### Using Cocoapods (recommended):
Add the following to your Podfile in your project

```pod
pod 'Beaconstac'
```

Run `pod install` in the project directory


#### Manually:

1. Download or clone this repo on your system.
2. Drag and drop the Beaconstac.framework file into your Xcode project. Make sure that "Copy Items to Destination's Group Folder" is checked.
<img src="images/frameworkdrop.png" alt="Build Phases" width="600">

3. Navigate to Beaconstac.framework/Resources folder in Finder and drop the Beaconstac.bundle into Project navigator area. Make sure that "Copy Items to Destination's Group Folder" checked.
<img src="images/bundledrop.png" alt="Build Phases" width="600">

4. In Build Phases under Target, add the following frameworks in â€œLink Binary With Librariesâ€ section:
- CoreData.framework
- SystemConfiguration.framework
- CoreBluetooth.framework
- CoreLocation.framework

## Configure your project

1. In Info.plist, add a new field, NSLocationAlwaysUsageDescription, NSLocationAlwaysAndWhenInUsageDescription with relevant value that you want to show to the user. This is mandatory for iOS 10 and above.
<img src="images/usagedescription.png" alt="Build Phases" width="600">

## Pre-requisite

__Location__

The app should take care of handling the permissions as required by your set up.

__Bluetooth__

The app should take care of enabling the bluetooth to range beacons.

__MY_DEVELOPER_TOKEN__

The app should provide the developer token while initializing the SDK. Get it from [Beaconstac Dashboard Account Page](https://dashboard.beaconstac.com/#/account).

## Set Up

1. Import the framework header in your class

```swift
import Beaconstac
```

2. Initialize Beaconstac using __one-line initialization__, the initialization starts scanning for beacons immediately.

```swift
do {
beaconstacInstance = try Beaconstac.sharedInstance("My_DEVELOPER_TOKEN")
} catch let error {
print(error)
}
```


3. If you want to use the advacnced integration, use __iBeaconOption__ as defined below

| iBeaconOption                  |    Location Authorization      | Monitoring                                | Ranging                     | Description                                       |
|:------------------------------:|:--------------------------:|:--------------------------------:| :------------------------:|:----------------------------------------------:|
|              WhenInUse              |    When In Use Authorization | CoreLocation API doesn't support | CoreLocation API supports | App should be in the foreground                  |
| BackgroundRangeOnDisplayWakeUp |    Always Authorization       | CoreLocation API supports           | CoreLocation API supports | App can be in the background but doesn't range |

```swift
do {
beaconstacInstance = try Beaconstac.sharedInstance("My_DEVELOPER_TOKEN", ibeaconOption: .BackgroundRangeOnDisplayWakeUp, delegate: self, completion: : { (beaconstac, error) in
if error == nil {
beaconstac?.startScanningBeacons()
// Initialization successful, it just works...
}
})
} catch let error {
print(error)
}
```

4. If you wish to get the ___sharedInstance()___ of the Beaconstac SDK, after you initialize the Beaconstac SDK at any point in a single application life cycle

```swift
do {
beaconstacInstance = try Beaconstac.sharedInstance()
} catch let error {
print(error)
}
```

5. If you wish to control start and stop of scanning for beacons:

```swift
beaconstac.startScanningBeacons() // Starts scanning for beacons...
beaconstac.stopScanningBeacons() // Stops scanning for beacons...
```

6. Implement BeaconDelegate protocol methods to receive callbacks when beacons are scanned

```swift

// In the class where you want to listen to the beacon scanning events...
beaconstacInstance = try! Beaconstac.sharedInstance()
beaconstacInstance.delegate = self

// required
func didFail(_ error: Error) {
print(error)
}

//Optional
func didEnterRegion(_ region: String) {
print(region)
}

func didRangeBeacons(_ beacons: [NSObject]) {
print(beacons)
}

func campOnBeacon(_ beacon: Beacon) {
print(beacon)
}

func exitBeacon(_ beacon: Beacon) {
print(beacon)
}

func didExitRegion(_ region: String) {
print(region)
}
```

7. Implement RuleProcessorDelegate protocol methods to receive callbacks when rules are triggered

```swift

// In the class where you want to listen to the rule triggering events...
beaconstacInstance = try! Beaconstac.sharedInstance()
beaconstacInstance.ruleDelegate = self

func willTriggerRule(_ rule: Rule) {
// read which rule is about to trigger and the actions, filters set by the marketers...
}

func didTriggerRule(_ rule: Rule) {
// read which rule is triggered and the actions, filters set by the marketers...
}
```

8. Implement NotificationDelegate protocol methods to override the display of the Local Notification.

```swift

// In the class where you want to listen to notification events...
beaconstacInstance = try! Beaconstac.sharedInstance()
beaconstacInstance.notificationDelegate = self

func overrideNotification(_ notification: Notification) {
// If you override, you should handle everything from configuring, triggering and displaying of the notification.
}
```

9. Implement WebhookDelegate protocol methods to add additional parameters to be sent to the webhook.

```swift
// In the class where you want to listen to webhook events...
beaconstacInstance = try! Beaconstac.sharedInstance()
beaconstacInstance.webhookDelegate = self

func addParameters(_ webhook: Webhook) -> Dictionary<String, Any> {
// If you override, make sure the keys of the previously added
}
```

10. The difference between the rssi of the camp on beacon (-75) and exit beacon is defined using the BEACON_EXIT_BIAS, defaults to 10. You can override this behaviour by setting a new value.

```swift
beaconstacInstance = try! Beaconstac.sharedInstance()
beaconstacInstance.BEACON_EXIT_BIAS = 15 // Set the difference value
```

11. If you don't listen to the NotificationDelegate protocol, the SDK configures, triggers UNNotification. However to present the notification do the following.

```swift

// Check if the notification is from SDK and provide UNNotificationPresentationOptions or nil by invoking the below method.
public func notificatoinOptionsForBeaconstacNotification(_ notification: UNNotification) -> UNNotificationPresentationOptions?


// EXAMPLE:
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
var notificationPresentationOptions: UNNotificationPresentationOptions
if let notificationOption = try! beaconstac.sharedInstance().notificatoinOptionsForBeaconstacNotification(notification) {
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

12. You are required to add filters regarding the app user, if the marketer has provided the filters. To do so

```swift
// Provide the filters to the SDK as Key-Value pairs using dictionary. Note keys are keys insensitive.
func addFilters(_ filters: Dictionary<String, Any>)
```
__Note__: If the rule contains the filters and app doesn't provide it, the rule will be treated as a filter validation failed and we won't trigger that particular rule.

13. The SDK collects analytics regarding how your app user(Visitor) sees the iBeacon related information. If you know information about your app user, create a Visitor object and provide it to us.

```swift
// If you know the your app visitor, create a Visitor object and call this on the Beaconstac instance.
func setVisitor(_ visitor: Visitor)
```
