//
//  MSRuleProcessor.h
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

@class MSRuleProcessor;

/**
 * Protocol to receive events from the rule processor.
 */
@protocol RuleProcessorDelgate <NSObject>

/**
 * Called when a rule was triggered.
 */
- (void)ruleProcessor:(MSRuleProcessor*)ruleProcessor triggeredRuleWithRuleName:(NSString*)ruleName andActionArray:(NSArray*)actionArray;
@end

/**
 * MSEventType is an enumeration of all the events possible in Beaconstac
 */
typedef NS_ENUM (NSUInteger, MSEventType){
    MSEventTypeNone = 0,
    MSEventTypeCampOn = 1,
    MSEventTypeExitBeacon = 2,
    MSEventTypeEnterRegion = 3,
    MSEventTypeExitRegion = 4
};

/**
 * Processes rules configured in the Beaconstac backend, and calls back into the app
 * when rules match defined criteria.
 */
@interface MSRuleProcessor : NSObject

/**
 * Dictionary containing all known "facts" that you would like to use in your rules.
 *
 * For e.g., you may know that the temperature in the room is 23C. 
 * You can then set this in the dictionary.
 *     "temperature" => 23
 * and the rule processor will use this fact in evaluating rules.
 */
@property (nonatomic, strong) NSMutableDictionary *factsDict;

/**
 * Dictionary containing all rules, downloaded from the Beaconstac server
 */
@property (nonatomic, strong) NSMutableDictionary *ruleDict;

/**
 * Array of timers that will be fired?
 * @todo Not clear what this is
 */
@property (nonatomic, strong) NSMutableArray *timerArray;

/**
 * Delegate that will receive events fired by the rule processor.
 */
@property (nonatomic, weak) id <RuleProcessorDelgate> delegate;

/**
 * Download the latest ruleset from the server and update the app's local copy.
 */
- (void)syncWithServerWithCompletionBlock:(void (^)(NSNumber *statusCode, NSDictionary *responseJson, NSError *error))completionBlock;

/**
 * Process rules
 */
- (void)processRule;

/**
 * MSRuleProcessor singleton method
 */
+ (MSRuleProcessor*)sharedInstance;

@end
