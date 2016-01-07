//
//  MSRule.h
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

@interface MSRule : NSObject

/**
 * Represents the ID of the rule
 */
@property (nonatomic, strong) NSNumber *ruleID;

/**
 * Represents the name of the rule.
 */
@property (nonatomic, strong) NSString *name;

/**
 * Represents the event on which to trigger the rule.
 */
@property (nonatomic, strong) NSNumber *event;

/**
 * Represents the dwell time after which to trigger the rule.
 */
@property (nonatomic, strong) NSNumber *dwellTime;

/**
 * Represents the array of beacons attached to the rule.
 */
@property (nonatomic, strong) NSArray *beaconsArray;

/**
 * Represents the tagged beacons attached to the rule.
 */
@property (nonatomic, strong) NSArray *taggedBeacons;

/**
 * Represents the array of actions attached to the rule.
 */
@property (nonatomic, strong) NSArray *actionsArray;

/**
 * Represents the array of if conditions attached to the rule.
 */
@property (nonatomic, strong) NSDictionary *ifs;

/**
 * Represents the array of actions attached to the rule.
 */
@property (nonatomic, strong) NSString *connector;

/**
 * Represents status of the rule. 
 * true for Active, false for Paused.
 */
@property (nonatomic) BOOL isActive;

/**
 * Represents meta attached to the rule.
 */
@property (nonatomic, strong) NSDictionary *meta;

@end
