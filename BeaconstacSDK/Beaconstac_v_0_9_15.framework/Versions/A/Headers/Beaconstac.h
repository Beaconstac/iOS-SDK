//
//  Beaconstac.h
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
#import "MSLogger.h"
#import "MSBeacon.h"
#import "MSBeaconManager.h"
#import "MSRuleProcessor.h"
#import "MSAction.h"
#import "MSCard.h"
#import "MSMedia.h"
#import "MSIdentity.h"

@class Beaconstac;

/**
 * Defines the delegate methods that will be used to receive beacon-triggered events, including ranging,
 * camping, entry, exit, and any rules that match defined criteria.
 */
@protocol BeaconstacDelegate <NSObject>

@optional
/**
 * Sent to the delegate when one or more beacons are detected by the device.
 *
 * @param beaconstac Beaconstac instance which is the sender of this message
 * @param beaconsDictionary A dictionary with beacon 'UUID:major:minor' as key 
 *                          and MSBeacon as value.
 */
- (void)beaconstac:(Beaconstac*)beaconstac rangedBeacons:(NSDictionary*)beaconsDictionary;

/**
 * Sent to the delegate when the device has crossed over the near proximity zone threshold for a beacon.
 *
 * @param beaconstac Beaconstac instance which is the sender of this message
 * @param beacon This returns the beacon object that a device has camped on to.
 * @param beaconsDictionary This returns a dictionary of all available beacons in the range of device.
 */
- (void)beaconstac:(Beaconstac*)beaconstac campedOnBeacon:(MSBeacon*)beacon amongstAvailableBeacons:(NSDictionary*)beaconsDictionary;

/**
 * Sent to the delegate when the device exited from the region of a beacon on which it was camped on.
 * 
 * @param beaconstac Beaconstac instance which is the sender of this message
 * @param beacon This returns the beacon that a device was previously camped on to and now has exited from beacon's range.
 */
- (void)beaconstac:(Beaconstac*)beaconstac exitedBeacon:(MSBeacon*)beacon;

/**
 * Sent to the delegate when a rule is triggered and an action needs to be performed.
 *
 * @param beaconstac Beaconstac instance which is the sender of this message
 * @param ruleName rule name for which an action needs to be performed.
 * @param actionArray Returns an array of actions to be performed when the rule is triggered. Each action is an object of type MSAction.
 */
- (void)beaconstac:(Beaconstac*)beaconstac triggeredRuleWithRuleName:(NSString*)ruleName actionArray:(NSArray*)actionArray;

/**
 * Invoked when the user enters a monitored region.
 * @param beaconstac Beaconstac instance which is the sender of this message
 * @param region Beacon region
 */
- (void)beaconstac:(Beaconstac*)beaconstac didEnterBeaconRegion:(CLRegion*)region;

/**
 * Invoked when the user exits a monitored region.
 * @param beaconstac Beaconstac instance which is the sender of this message
 * @param region Beacon region
 */
- (void)beaconstac:(Beaconstac*)beaconstac didExitBeaconRegion:(CLRegion*)region;

/**
 * Reports if the GPS location changed
 * @param beaconstac Beaconstac instance which is the sender of this message
 * @param newLocation A CLLocation object of the new location
 * @param oldLocation A CLLocation object of the previous location
 */
- (void)beaconstac:(Beaconstac*)beaconstac didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

@end

/**
 * This describes different action types that can be logged for Analytics
 */
typedef NS_ENUM (NSUInteger, MSUIAction){
    MSUIActionDelivered = 0,
    MSUIActionOpened = 1,
    MSUIActionClicked = 2
};

/**
 * The main class and entry point for working with the Beaconstac SDK.
 */
@interface Beaconstac : NSObject

/** 
 * Delegate for events on Beaconstac
 */
@property (nonatomic, weak) id <BeaconstacDelegate> delegate;

/**
 * The MSIdentity instance in use.
 */
@property (nonatomic, strong) MSIdentity *userIdentity;

/**
 * The MSBeaconManager instance in use.
 */
@property (nonatomic, strong) MSBeaconManager *beaconManager;

/**
 * The MSRuleProcessor instance in use.
 */
@property (nonatomic, strong) MSRuleProcessor *ruleProcessor;

/**
 * A dictionary of all the ranged beacons with beacon key(UUID:Major:Minor)
 * as the key and MSBeacon object as the value
 */
@property (strong, nonatomic, readonly) NSDictionary *rangedBeacons;

/** 
 * Set / get beacon affinity, which is how sticky we are to
 * a beacon once we camp on it. By default this is set to MSBeaconAffinityMedium.
 * Use this to control how sensitive your app is to multiple beacons in a given space. 
 * Increasing affinity values (Low -> High) will cause your app to lock harder
 * onto the closest beacon and switch to a new one it sees only when it is sufficiently close
 * to the new one. Random sighting of another "far away" beacon will not be ignored.
 *
 * @see MSBeaconAffinity in MSBeaconManager for allowed values
 */
@property (nonatomic) MSBeaconAffinity beaconaffinity;

/** 
 * Holds all the key values (for facts) required for rule processing. 
 * 
 * It contains keys: nearbeaconName - which contains the camped on beacon name, 
 * nearbeacon - which contains the UUID:major:minor of the camped on beacon and 
 * here - which contains the current location of the device
 */
@property (nonatomic, strong) NSMutableDictionary *factsDictionary;

/**
 * Returns the previously instantiated singleton instance of Beaconstac.
 */
+ (Beaconstac*)sharedInstance;

/**
 * Designated initializer method for Beaconstac singleton instance. Subsequent calls to initialize.
 * @param organizationId organizationId from Beaconstac Account
 * @param devToken developer token from Beaconstac Account
 */
+ (Beaconstac*)sharedInstanceWithOrganizationId:(NSInteger)organizationId developerToken:(NSString*)devToken;

/**
 * This destroys the existing Beaconstac singleton instance. This can be useful in case user logs out.
 */
+ (void)destroySharedInstance;

/**
 * Initialize a Beaconstac object with user-specific data, to be used in logging events and processing rules.
 *
 * @param firstName First name of the user
 * @param lastName Last name of the user
 * @param email Email ID of the user
 * @param userInfo Any additional information associated to a user. It must be a dictionary.
 */
- (void)setUserIdentityWithFirstName:(NSString*)firstName lastName:(NSString*)lastName emailAddress:(NSString*)email userInfo:(NSDictionary*)userInfo;

/**
 * Start ranging beacons in the CLBeaconRegion created with given proximity UUID and region identifier, filtered using option dictionary.
 *
 * @param uuid The Beacon UUID. Currently, Beaconstac supports only 1 UUID per app
 * @param identifier A string which identifies your beacons. It should be of the format com.<company_name>.<app_name>
 * @param options A set of key-value pairs specifying criteria to filter the detected beacons. Possible filter options include key
 * "mybeacons": accepts a boolean value. If set to True, only the beacons in your account are ranged.
 */
- (void)startRangingBeaconsWithUUIDString:(NSString*)uuid beaconIdentifier:(NSString*)identifier filterOptions:(NSDictionary*)options;

/**
 * Stops ranging beacons.
 */
- (void)stopRangingBeacons;

/**
 * Updates the primary facts dictionary which is used by MSRuleProcessor to evaluate rules.
 * Facts such as beacon proximity, user location, user id are updated by the SDK.
 * Any external fact which needs to be used must be set by the developer.
 *
 * @param fact The value of the fact for a corresponding key
 * @param key The key against which the fact must be stored
 */
- (void)updateFact:(id)fact forKey:(NSString*)key;

/**
 * Used to log user events to server such as when the user views
 * or clicks on a message shown by the SDK as a result of rule processing.
 *
 * @param actionType Value of type MSUIAction
 * @param message Message to be sent to the server
 */
- (void)logEventWithActionType:(MSUIAction)actionType andMessage:(NSString*)message;


@end
