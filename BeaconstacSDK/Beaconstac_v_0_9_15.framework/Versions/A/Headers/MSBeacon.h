//
//  MSBeacon.h
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

/**
 * Represents a single beacon in the system.
 */
@interface MSBeacon : NSObject

/**
 * Represents beacon identity in the form "UUID:Major:Minor"
 */
@property (nonatomic, strong) NSString *beaconKey;

/**
 * Represents beacon proximity UUID
 */
@property (nonatomic, strong) NSUUID *beaconUUID;

/**
 * Represents beacon major value
 */
@property (nonatomic, strong) NSNumber *major;

/**
 * Represents beacon minor value
 */
@property (nonatomic, strong) NSNumber *minor;

/**
 * Latest value of RSSI, Reverse strength Index as registered by the receiver from the beacon
 */
@property (nonatomic, strong) NSNumber *latestRssi;

/**
 * The correction value applied to the RSSI to smoothen out erroneous values
 */
@property (nonatomic) int bias;

/**
 * If the device is camped on to the beacon
 */
@property (nonatomic) BOOL isCampedOn;

/**
 * Since how many ranging calls has this particular beacon not been detected
 */
@property (nonatomic) int stale;

/**
 * Beacon details in the format UUID:Major:Minor RSSI
 */
@property (nonatomic, copy, readonly) NSString *description;

/**
 * The designated initializer for MSBeacon class.
 *
 * @param beaconUUID Represents beacon proximity UUID
 * @param major Represents beacon major value
 * @param minor Represents beacon minor value
 */
- (id)initWithUUID:(NSUUID*)beaconUUID major:(NSNumber*)major minor:(NSNumber*)minor;

/**
 * This is used to set the current RSSI value internally.
 *
 * @param state Current RSSI value associated to the beacon object
 */
- (void)addBeaconState:(int)state;

/**
 * States if the proximity of the beacon is far
 */
- (BOOL)isFar;

/**
 * Returns the mean of previous three RSSI values associated to the beacon object.
 */
- (int)getMeanRssi;

@end
