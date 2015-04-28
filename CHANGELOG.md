## v0.9.15 released on April 27, 2015

Features:

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
