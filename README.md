# iOS-SDK

## Introduction

Beaconstac SDK is an easy way to enable proximity marketing and location analytics through an iBeacon-compliant BLE network. 

## Documentation

Please refer to the API documentation on [Beaconstac developer portal](https://developer.beaconstac.com/ios-sdk-reference).

## Demo app

Checkout Beaconstac Demo app on the [iTunes App Store](https://itunes.apple.com/us/app/beaconstac/id956442796?mt=8).

## Integration with your existing project in XCode

1. Download Beaconstac SDK from the link you receive in your email.
2. Drag and drop the Beaconstac.framework file into your Xcode project. Make sure that "Copy Items to Destination's Group Folder" is checked.
<img src="images/frameworkdrop.png" alt="Build Phases" width="600">

3. Navigate to Beaconstac_v_0_9_15.framework/Resources folder in Finder and drop the Beaconstac.bundle into Project navigator area. Make sure that "Copy Items to Destination's Group Folder" checked.
<img src="images/bundledrop.png" alt="Build Phases" width="600">

4. In Build Phases under Target, add the following frameworks in “Link Binary With Libraries” section:
	- CoreData.framework
	- SystemConfiguration.framework
	- CoreBluetooth.framework
	- CoreLocation.framework
	
5. In Info.plist, add a new field, NSLocationAlwaysUsageDescription with relevant value that you want to show to the user. This is mandatory for iOS 8 and above.
<img src="images/usagedescription.png" alt="Build Phases" width="600">

6. Import the framework header in your class and make sure the  class conforms to BeaconstacDelegate protocol

		#import <Beaconstac_v_0_9_15/Beaconstac.h>

7. Initialize Beaconstac using the factory method:
		
		beaconstacInstance = [Beaconstac sharedInstanceWithOrganizationId:<organizationId: Int> developerToken:<developerToken: String!>];
        beaconstacInstance.delegate = self;`

8. To start ranging beacons:
		
		[beaconstacInstance startRangingBeaconsWithUUIDString:@"Enter valid beacon UUID" beaconIdentifier:@"mobstacRegion" filterOptions:nil];
		
9. Implement delegate methods to receive callbacks when beacons are ranged:
		
		- (void)beaconstac:(Beaconstac *)beaconstac rangedBeacons:(NSDictionary *)beaconsDictionary
		{
    		NSLog(@"Beacons around %@",beaconsDictionary);
		}
		
