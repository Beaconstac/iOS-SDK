//
//  MSBeaconManager.h
//  BeaconstacSDK
//
//  Copyright© 2014, MobStac Inc. All rights reserved.
//
//  All information contained herein is, and remains the property of MobStac Inc.
//  The intellectual and technical concepts contained herein are proprietary to
//  MobStac Inc and may be covered by U.S. and Foreign Patents, patents in process,
//  and are protected by trade secret or copyright law. This product can not be
//  redistributed in full or parts without permission from MobStac Inc. Dissemination
//  of this information or reproduction of this material is strictly forbidden unless
//  prior written permission is obtained from MobStac Inc.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MSBeacon.h"

@class MSBeaconManager;

/**
 * Beacon affinity is how "sticky" we are to a beacon, once we're camped on it.
 */
typedef NS_ENUM (NSUInteger, MSBeaconAffinity)
{
    MSBeaconAffinityNone = 0,
    MSBeaconAffinityLow = 3,
    MSBeaconAffinityMedium = 4,
    MSBeaconAffinityHigh = 5
};

/**
 * Protocol used to receive beacon events
 */
@protocol MSBeaconManagerDelegate <NSObject>

@optional
/**
 * Gives a dictionary of all visible Beacon objects with 
 * <MSBeacon> as value and key as @"UUID:major:minor".
 */
- (void)beaconManager:(MSBeaconManager*)manager rangedBeacons:(NSDictionary*)beaconsDictionary;

/**
 * Gives a MSBeacon on which the device is currently camped 
 * on amongst all visible beacons dictionary.
 */
- (void)beaconManager:(MSBeaconManager*)manager campedOnBeacon:(MSBeacon*)beacon amongstAvailableBeacons:(NSDictionary*)beaconsDictionary;

/**
 * Method to report if the device just camped off a beacon <MSBeacon>
 */
- (void)beaconManager:(MSBeaconManager*)manager exitedBeacon:(MSBeacon*)beacon;

/*
 * Reports if the GPS location changed
 */
- (void)beaconManager:(MSBeaconManager*)manager updatedToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

/**
 * Invoked when the user enters a monitored region.
 */
- (void)beaconManager:(MSBeaconManager*)manager didEnterBeaconRegion:(CLRegion*)region;

/**
 * Invoked when the user exits a monitored region.
 */
- (void)beaconManager:(MSBeaconManager*)manager didExitBeaconRegion:(CLRegion*)region;

/**
 * Invoked when beacons are ranged for the first time in the monitored region.
 *
 * @param manager MSBeaconManager instance which is the sender of this message
 * @param beacon MSBeacon the first beacon which was ranged on entering the region
 * @param region CLRegion which the user just entered, inside which this beacon got ranged
 */
- (void)beaconManager:(MSBeaconManager*)manager didRangeFirstBeacon:(MSBeacon*)beacon onBeaconRegion:(CLRegion*)region;

/*
 * Invoked when beacons are ranged for the first time in the monitored region.
 *
 * @param manager MSBeaconManager instance which is the sender of this message
 * @param beaconsArray NSArray of CLBeacon objects which were ranged on entering the region
 * @param region CLRegion which the user just entered, inside which this beacon got ranged
 */
- (void)beaconManager:(MSBeaconManager*)manager didRangeBeaconsForFirstTime:(NSArray*)beaconsArray onBeaconRegion:(CLRegion*)region;

@end

/**
 * Type of services for setting the values of the Location Authorization
 */
typedef NS_ENUM (NSUInteger){
    AlwaysForRangingAndMonitoring = 0,
    WhenInUseForRanging = 1
} LocationAccessPermission;

/**
 * RegionMonitoringRequired: If selected, the app would be able to monitor.
 *
 * AllowRangingInBackground: If selected, the app would be able to range beacons and trigger rules while
 * in the background. Default state is False.
 * Note: You should enable the background location updates under the Capabilities
 * tab of your project target in Xcode.
 *
 * RangeOnDisplayWakeUp: If selected, the app would range for 10 seconds when woken up (when the phone is locked and display is on).
 */
typedef NS_OPTIONS (NSUInteger, Usage){
    UsageForegroundRangingRequired = 0,
    UsageRegionMonitoringRequired = 1 << 0,
    UsageAllowRangingInBackground = 1 << 1,
    UsageRangeOnDisplayWakeUp = 1 << 2
};

/**
 * Manages all the beacons around and presents callbacks using the protocol.
 */
@interface MSBeaconManager : NSObject<CLLocationManagerDelegate>

/**
 * Delegate to send events to.
 */
@property (nonatomic, weak) id <MSBeaconManagerDelegate> delegate;

/**
 * Current location, as reported by the OS.
 */
@property (strong, nonatomic) CLLocation *currentLocation;

/**
 * Beacon identification string. e.g. com.mobstac.foo
 */
@property (strong, nonatomic) NSString *regionIdentifier;

/**
 * UUID of the beacon.
 */
@property (strong, nonatomic) NSUUID *beaconUUID;

/**
 * Current affinity level.
 */
@property (nonatomic, assign) MSBeaconAffinity beaconaffinity;

/**
 * A dictionary of all the ranged beacons with beacon key(UUID:Major:Minor)
 * as the key and MSBeacon object as the value
 */
@property (strong, nonatomic) NSMutableDictionary *rangedBeacons;

/**
 * A boolean specifying if beacons are being ranged
 */
@property (nonatomic, readonly) BOOL isRangingBeacons;

/**
 * MSBeacon which is currently camped on
 */
@property (strong, nonatomic) MSBeacon *campedOnBeacon;

/**
 * If set to True, the app would be able to range beacons and trigger rules while
 * in the background. Default state is False.
 * Please note that you should enable the background location updates under the
 * Capabilities tab of your project target in Xcode.
 */
@property (nonatomic) BOOL allowRangingInBackground;

/**
 * Checks the apps Info Dictionary for background location updates under the Capabilities
 * tab of your project in Xcode.
 */
@property (nonatomic) BOOL isBackgroundLocationUpdatesEnabled;

/**
 * Allows to set the value of Location Authorization to access permission as per the requirement.
 */
@property (nonatomic, assign) LocationAccessPermission locationUsageRequirementType;

/**
 * If set to true, the app would range for 10 seconds when woken up (when the phone is locked and display is on).
 */
@property (nonatomic) BOOL checkIfRangingOnWakeUpNeeded;

/**
 * Initializes a MSBeaconManager to monitor all beacons with the
 * given UUID and identifier.
 * @param uuid This represents the unique Beacon UUID
 * @param identifier This represents a string identifier for the corresponding Beacon UUID
 */
- (id)initWithUUID:(NSUUID*)uuid forIdentifier:(NSString*)identifier;

/**
 * Stop sending location updates.
 */
- (void)stopLocationUpdates;

/**
 * Start ranging beacons. Returns a list of  beacons through delegate callback
 * filtered using criteria specified in options dictionary
 */
- (void)startRangingBeaconsWithFilterOptions:(NSDictionary*)options;

/**
 * Stop ranging beacons.
 */
- (void)stopRangingBeacons;

@end
