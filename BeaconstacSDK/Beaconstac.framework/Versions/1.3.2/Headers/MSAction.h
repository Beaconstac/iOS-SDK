//
//  MSAction.h
//  Beaconstac
//
//  Copyright (c) 2016 Mobstac. All rights reserved.
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
#import "MSCard.h"

/**
 * MSActionType describes the type of action triggered from a rule
 * An action can be -
 * popup - which returns a string value in message field
 * webpage - which returns a URL value in message field
 * card - which returns a reference to MSCard object
 * webhook - which returns a URL value in message field
 * custom - which returns a dictionary value in message field
 */
typedef NS_ENUM (NSUInteger, MSActionType) {
    MSActionTypeNone = 0,
    MSActionTypePopup = 1,
    MSActionTypeWebpage = 2,
    MSActionTypeCard = 3,
    MSActionTypeWebhook = 4,
    MSActionTypeCustom = 5,
    MSActionTypeNotification = 6
};

@interface MSAction : NSObject 

/**
 * Represents the action ID of the action
 */
@property (nonatomic, strong) NSNumber *actionID;

/**
 * Represents the name of the action
 */
@property (nonatomic, strong) NSString *name;

/**
 * Represents the type of the action. This can have values:
 * popup, webpage, video, audio, custom, webhook, notification
 */
@property (nonatomic) MSActionType type;

/**
 * Represents the message of the action. This can have 
 * text, url, JSON, MSCard or MSNotification depending on the type of action
 */
@property (nonatomic, strong) id message;

/**
 * Represents the rule ID associated to the action
 */
@property (nonatomic, strong) NSNumber *ruleID;

/**
 * Represents the name of the rule this action is associated with
 */
@property (nonatomic, strong) NSString *ruleName;

/**
 * A dictionary that contains meta information associated with the action
 */
@property (nonatomic, strong) NSMutableDictionary *actionMeta;

/**
 * Represents the status of action
 * This can have following values - 
 * A - active
 * P - paused
 * R - removed
 */
@property (nonatomic, strong) NSString *status;

/**
 * Represents the date when the action was created
 */
@property (nonatomic, strong) NSDate *created;

/**
 * Represents the date when the action was last modified
 */
@property (nonatomic, strong) NSDate *modified;

@end
