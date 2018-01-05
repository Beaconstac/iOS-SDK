### v3.0.7 released on January 5, 2018

* Fixing rule deletion casuing core data errors
* Fixing nil urls in notification

### v3.0.1 released on December 14, 2017

* Event Logging changes.
* Fix defnition of `BeaconDelegate`'s didRagneBeacons to return `MBeacon` objects.
* Fix method signature.

### v3.0 released on Decemeber 14, 2017
* Introducing a completely new Beaconstac SDK written completely in Swift.
* One line initialisation making it easier than ever to integrate Beaconstac into your app.
* Light-weight and added bitcode support.
* A new way to handle location permission for battery efficient BLE scanning and conforming to Apple App Store guidelines.
* Uses the much improved Beaconstac API v2 for faster and intelligent syncing of rules.
* Offline support with persistent caching of rules.

### v1.5.3 released on February 13, 2017

* Introducing beacon ranging on display wakeup.
* Added a new property usageRequirement in Beaconstac.h to better manage user location permissions based on the applications requirement.
* Removed allowRangingInBackground property from Beaconstac.h. Instead use the property usageRequirement for setting your applications options.
* Added a new MSNotification property in MSCard to display notification attached to the card.

### v1.5.2 released on October 4, 2016

* Fixed a bug which was causing crash on iOS 10.

### v1.5.1 released on July 20, 2016

* Improvements in user analytics. This update is recommended for all users.


### v1.5 released on July 8, 2016

* Introducing Rules by Places. This allows assigning a MSRule to a MSPlace object instead of a single MSBeacon or a MSTag on beacons. Check Beaconstac Admin Console on how to set it up.
* Added a new property for assigning GooglePlaceID to a given MSPlace object.
* Added a new property in MSRule - placesBeacons, which is an array of beacons attached to a place in case this MSRule is assigned to a MSPlace.
* SDK automatically syncs notifications from Beaconstac Admin Conole and registers UserNotificationCategory for each CTA created under Notifications.

### v1.4.2 released on April 5, 2016

* Fixed a bug which was causing Custom attributes to not work properly. 

### v1.4.1 released on March 17, 2016

* Fixed a bug which was causing name and email to be not reported on Analytics dashboard (https://manage.beaconstac.com/reporting/visitors) 
* Introduced new property in Beaconstac to check if beacon ranging is enabled
* Introduced new api in MSRuleProcessor to fetch rules from server, ignoring the local cached version
* MSRuleProcessor cannot be accessed as [MSRuleProcessor sharedInstance] anymore. Instead, use the property in Beaconstac instance: [[Beaconstac sharedInstance] ruleProcessor]


### v1.4 released on February 8, 2016

* New classes for Webpage, Custom and Popup action types. All action types now inherit from MSAction. Check the Example code for how to access these.
* Improvement in 'allowRangingInBackground' property

### v1.3.2 released on January 21, 2016

* New Webhook class and delegate methods. See the updated Admin Console for including Webhook parameters.
* Example app updated to include Summary Card and Photo Card UI

### v1.3.1 released on January 7, 2016

* Fixed issues with geo-fence monitoring for reliable sync when changes are made on the admin console

### v1.3 released on December 17, 2015

* Added support for syncing and showing notifications associated with cards or created as a standalone action
* Added a method to enable/disable background ranging

### v1.2 released on December 9, 2015

* Added compatibility for background beacon ranging on iOS9
* Added a new delegate method which is triggered when Rule sync with server completes
* Performance improvement in rule triggering
* Cleanup all data on destroying Beaconstac shared instance

### v1.1.1 released on August 12, 2015

* Rules assigned to Tags will trigger callbacks when camped on the tagged beacon
* Added a property in MSBeaconManager to get the currently campedOnBeacon
* Fixed a bug which prevented Exit Rules to not trigger if there were multiple Exit Rules on same beacon

### v1.1 released on August 4, 2015

* Added MSTags class to enable grouping beacons by tags
* Start/Stop Geo-fence api changed 
* Added delegate callback if SDK fails to sync rule with the server
* Shows error in Console if an invalid UUID is entered

### v1.0 released on June 4, 2015

* Added MSPlace class to enable grouping beacons by places
* Ability to add Geo-fences around MSPlace with entry/exit callbacks 
* Version number dropped from framework name

### v0.9.16 released on April 29, 2015

* Added ability to track sessions based on change in time and location

### v0.9.15 released on April 27, 2015

* Added ability to reset a Beaconstac sharedInstance in case of switching user accounts

### v0.9.14 released on Apr 15, 2015

* Rule processor Action type webhook - webhook parameters now contain more contextual information

### v0.9.13 released on Apr 9, 2015

* Delegate method names updated to include sender object as the first parameter in Beaconstac, MSBeaconManager and MSRuleProcessor classes
* Added more fields to event log packet like campon duration on a beacon
* Added a description property to MSBeacon class
* Major improvement in beacon campon and exit behavior
* Minor bug fixes and improvements

### v0.9.12 released on Feb 9, 2015

* Added more fields to event logger
* Added support for Beaconstac delegates to be optional
* Major bug fix - First time beacon detection bug fixed
* Minor bug fixes

### v0.9.11 released on Jan 7, 2014

* Added GET, POST, PUT, DELETE methods to MSNetwork class
* Deprecated postToServer and fetchDataForURL methods in MSNetwork class
* Added MSUIAction enum for action type in MSAnalytics. Deprecated MSActionType in MSAnalytics
* Added created, modified and status properties to MSAction class
* Added MSCard and MSMedia classes to Beaconstac for handling card action type and media in card action type
* Fixed bug - Ranging and monitoring beacons specific to region
* Fixed bug - Removed ambiguity with class name for Reachability.h
* Fixed bug - webhook action type post parameters
* Fixed bug - Added Dwell time implementation to exit beacon event

### v0.9.10 released on Dec 18, 2014

* Added sharedInstanceWithOrganizationId: developerToken method for creating a Beaconstac shared instance
* Added method for start ranging beacons with UUID and identifier in Beaconstac and MSBeaconManager classes
* Added support for filter options while ranging beacons 
* Added method for stopping beacon ranging in Beaconstac and MSBeaconManager classes
* Added support for triggering rules based on exit beacon event
* Deprecated setUpOrganizationId: userToken: beaconUUID: beaconIdentifier method from Beaconstac class
* Deprecated sharedInstance method in Beaconstac class
* Modified initUserIdentity method to setUserIdentity in Beaconstac class



