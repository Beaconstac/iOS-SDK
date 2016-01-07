//
//  MSPlace.h
//  Beaconstac
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

/**
 * Represents a place in the system.
 */
@interface MSPlace : NSObject

/**
 * Represents place name assigned by user
 */
@property (nonatomic, strong) NSString *name;

/**
 * Represents place address
 */
@property (nonatomic, strong) NSString *address;

/**
 * Represents geographical longitude of the place
 */
@property (nonatomic) CLLocationDegrees longitude;

/**
 * Represents geographical latitude of the place
 */
@property (nonatomic) CLLocationDegrees latitude;

/**
 * Represents geographical radius of the geofence
 */
@property (nonatomic) CLLocationDistance radius;

/**
 * Represents the place ID of the place
 */
@property (nonatomic, strong, readonly) NSNumber *placeID;

/**
 * Updates the changes to the place object and syncs with the server
 * @param completionBlock This block is invoked when the sync is complete. It takes two arguments: succeeded - if the operation was successful, error - which is a NSError object describing the failure.
 */
- (void)saveInBackgroundWithCompletionBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

/**
 * Deletes the place object from server
 * @param completionBlock This block is invoked when the deletion operation is complete. It takes two arguments: succeeded - if the operation was successful, error - which is a NSError object describing the failure.
 */
- (void)deleteInBackgroundWithCompletionBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

/**
 * Creates a place object with the provided parameters
 *
 * @param name Represents name of place
 * @param address Represents address of place
 * @param latitude Represents latitude of place
 * @param longitude Represents longitude of place
 * @param radius Represents radius of geofence in meters around the place
 * @param completionBlock This block is invoked when the server responds. It takes two arguments: place - The place object whcih got created on the server, error - which is a NSError object describing the failure
 */
+ (void)createPlaceWithName:(NSString*)name address:(NSString*)address latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CLLocationDistance)radius withCompletionBlock:(void (^)(MSPlace *place, NSError *error))completionBlock;

/**
 * Returns an array of MSPlaces associated with the account
 * @param completionBlock This block is invoked when the server responds. It takes two arguments: places - An array of places associated with the account, error - which is a NSError object describing the failure
 */
+ (void)fetchAllPlacesWithCompletionBlock:(void (^)(NSArray *places, NSError *error))completionBlock;

/**
 * Starts monitoring for Geofence entry and exit for all places in the account.
 */
+ (void)startMonitoringGeofences;

/**
 * Stops monitoring all Geofence entry and exit.
 */
+ (void)stopMonitoringGeofences;

@end
